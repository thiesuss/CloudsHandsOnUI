package customers

import (
	"context"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
)

func searchCustomers(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error connecting to database",
		}, fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Calculate offset based on page number and page size
	offset := (page - 1) * pageSize

	// Query to search for customers based on the provided text
	rows, err := db.QueryContext(ctx, `
		SELECT
			c.id, c.firstName, c.lastName, COALESCE(c.title, '') AS title, c.familyStatus, c.birthDate,
			c.socialSecurityNumber, c.taxId, c.email, c.street, c.houseNumber, c.zipCode, c.city, c.iban, c.bic, c.name
		FROM
			Customer AS c
		WHERE
			c.id LIKE ? OR
			c.firstName LIKE ? OR
			c.lastName LIKE ? OR
			c.street LIKE ? OR
			c.city LIKE ?
		ORDER BY c.id ASC
		LIMIT ? OFFSET ?`, "%"+text+"%", "%"+text+"%", "%"+text+"%", "%"+text+"%", "%"+text+"%", pageSize, offset)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error searching customers",
		}, fmt.Errorf("error searching customers: %v", err)
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
			return events.APIGatewayProxyResponse{
				StatusCode: http.StatusInternalServerError,
				Body:       "Error scanning customer details",
			}, fmt.Errorf("error scanning customer details: %v", err)
		}

		// Append customer details to the customers slice
		customers = append(customers, customer)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error iterating over customer details",
		}, fmt.Errorf("error iterating over customer details: %v", err)
	}

	// Return success response with the customer details
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       toJSON(customers), // Assuming toJSON is a function to convert to JSON
	}, nil
}
