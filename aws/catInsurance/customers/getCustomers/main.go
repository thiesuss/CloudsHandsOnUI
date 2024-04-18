package main

import (
	"catInsurance/common/database"
	"catInsurance/common/models"
	"catInsurance/common/utils"
	"context"
	"encoding/json"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	page, pageSize, err := utils.ParsePageAndPageSize(req.QueryStringParameters)
	if err != nil || page < 1 {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       err.Error(),
		}, nil
	}
	// Log the request parameters
	log.Printf("Received request. page: %d, pageSize: %d\n", page, pageSize)

	// Retrieve database credentials
	db, err := database.ConnectToDB()
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error connecting to database",
		}, nil
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
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error retrieving customer details",
		}, nil
	}
	defer rows.Close()

	// Construct slice to hold customer details
	var customers []models.CustomerRes

	// Iterate over the rows and populate the customers slice
	for rows.Next() {
		var customer models.CustomerRes
		if err := rows.Scan(
			&customer.Id, &customer.FirstName, &customer.LastName, &customer.Title, &customer.FamilyStatus, &customer.BirthDate,
			&customer.SocialSecurityNumber, &customer.TaxId, &customer.Email,
			&customer.Address.Street, &customer.Address.HouseNumber, &customer.Address.ZipCode, &customer.Address.City,
			&customer.BankDetails.Iban, &customer.BankDetails.Bic, &customer.BankDetails.Name,
		); err != nil {
			return events.APIGatewayProxyResponse{
				StatusCode: http.StatusInternalServerError,
				Body:       "Error scanning customer details",
			}, nil
		}

		// Append customer details to the customers slice
		customers = append(customers, customer)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error iterating over customer details",
		}, nil
	}

	// Marshal customers slice to JSON
	customerJSON, err := json.Marshal(customers)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error marshaling customer details to JSON",
		}, nil
	}

	// Return success response with the customer details
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(customerJSON),
	}, nil
}

func main() {
	lambda.Start(handler)
}
