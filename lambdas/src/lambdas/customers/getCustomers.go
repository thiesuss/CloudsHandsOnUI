package customers

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/aws/aws-lambda-go/events"
	_ "github.com/go-sql-driver/mysql"
)

func getCustomers(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	page, pageSize, err := parseQueryParams(req.QueryStringParameters)
	if err != nil || page < 1 {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       err.Error(),
		}, nil
	}

	offset := (page - 1) * pageSize

	// Log the request parameters
	log.Printf("Received request. page: %d, pageSize: %d\n", page, pageSize)
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Calculate offset based on page number and page size
	offset := (page - 1) * pageSize

	// Query to retrieve paginated customer details
	rows, err := db.QueryContext(ctx, `
		SELECT
			c.id, c.firstName, c.lastName, COALESCE(c.title, '') AS title, c.familyStatus, c.birthDate,
			c.socialSecurityNumber, c.taxId, c.email, c.street, c.houseNumber, c.zipCode, c.city, c.iban, c.bic, c.name
		FROM
			Customer AS c
		ORDER BY c.id ASC
		LIMIT ? OFFSET ?`, pageSize, offset)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving customer details: %v", err)
	}
	defer rows.Close()

	// Construct slice to hold customer details
	var customers []CustomerRes

	// Iterate over the rows and populate the customers slice
	for rows.Next() {
		var customer CustomerRes
		if err := rows.Scan(
			&customer.Id, &customer.FirstName, &customer.LastName, &customer.Title, &customer.FamilyStatus, &customer.BirthDate,
			&customer.SocialSecurityNumber, &customer.TaxId, &customer.Email,
			&customer.Address.Street, &customer.Address.HouseNumber, &customer.Address.ZipCode, &customer.Address.City,
			&customer.BankDetails.Iban, &customer.BankDetails.Bic, &customer.BankDetails.Name,
		); err != nil {
			return Response(http.StatusInternalServerError, nil), fmt.Errorf("error scanning customer details: %v", err)
		}

		// Append customer details to the customers slice
		customers = append(customers, customer)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error iterating over customer details: %v", err)
	}

	// Return success response with the customer details
	return Response(http.StatusOK, customers), nil
}

func parseQueryParams(params map[string]string) (int, int, error) {
	pageStr, pageSizeStr := params["page"], params["pageSize"]
	page, err := strconv.Atoi(pageStr)
	if err != nil {
		return 0, 0, fmt.Errorf("Invalid value for page: %s", pageStr)
	}
	pageSize, err := strconv.Atoi(pageSizeStr)
	if err != nil {
		return 0, 0, fmt.Errorf("Invalid value for pageSize: %s", pageSizeStr)
	}
	return page, pageSize, nil
}
