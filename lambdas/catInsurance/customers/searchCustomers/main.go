package main

import (
	"catInsurance/common/database"
	"catInsurance/common/models"
	"catInsurance/common/utils"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// Parse query parameters
	page, pageSize, err := utils.ParsePageAndPageSize(req.QueryStringParameters)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       fmt.Sprintf("Error parsing query parameters: %v", err),
		}, nil
	}
	// Log the request parameters
	log.Printf("Received request. page: %d, pageSize: %d\n", page, pageSize)

	// Retrieve text parameter from request
	text := req.QueryStringParameters["text"]

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
			Body:       fmt.Sprintf("Error searching customers: %v", err),
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
				Body:       fmt.Sprintf("Error scanning customer details: %v", err),
			}, nil
		}

		// Append customer details to the customers slice
		customers = append(customers, customer)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       fmt.Sprintf("Error iterating over customer details: %v", err),
		}, nil
	}

	// Marshal customers slice to JSON
	customerJSON, err := json.Marshal(customers)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       fmt.Sprintf("Error marshaling customer details to JSON: %v", err),
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
