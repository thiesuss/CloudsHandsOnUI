package main

import (
	"catInsurance/common/database"
	"catInsurance/common/models"
	"context"
	"encoding/json"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	var customerId int
	// Parse request body
	if err := json.Unmarshal([]byte(req.Body), &customerId); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "Invalid request body",
		}, nil
	}

	// Retrieve database credentials
	db, err := database.ConnectToDB()
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error connecting to database",
		}, nil
	}
	defer db.Close()

	// Query to retrieve customer details with JOIN
	var customer models.CustomerRes

	// Perform database query
	err = db.QueryRowContext(ctx, `
		SELECT
			c.id, c.firstName, c.lastName, COALESCE(c.title, '') AS title, c.familyStatus, c.birthDate,
			c.socialSecurityNumber, c.taxId, c.email, c.street, c.houseNumber, c.zipCode, c.city, c.iban, c.bic, c.name
		FROM
			Customer AS c
		WHERE
			c.id = ?`, customerId).Scan(
		&customer.Id, &customer.FirstName, &customer.LastName, &customer.Title, &customer.FamilyStatus, &customer.BirthDate,
		&customer.SocialSecurityNumber, &customer.TaxId, &customer.Email,
		&customer.Address.Street, &customer.Address.HouseNumber, &customer.Address.ZipCode, &customer.Address.City,
		&customer.BankDetails.Iban, &customer.BankDetails.Bic, &customer.BankDetails.Name)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error retrieving customer details",
		}, nil
	}

	// Marshal customers slice to JSON
	customerJSON, err := json.Marshal(customer)
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
