package customers

import (
	"context"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
)

func updateCustomers(ctx context.Context, customerReq events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error connecting to database",
		}, fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Begin transaction
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error starting transaction",
		}, fmt.Errorf("error starting transaction: %v", err)
	}

	validationErr := validateCustomer(customerReq)
	if validationErr != "valid" {
		tx.Rollback()
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       validationErr,
		}, nil
	}

	// Update Customer table
	_, err = tx.ExecContext(ctx, `
		UPDATE Customer
		SET
			firstName = ?,
			lastName = ?,
			title = ?,
			familyStatus = ?,
			birthDate = ?,
			socialSecurityNumber = ?,
			taxId = ?,
			email = ?,
			street = ?,
			houseNumber = ?,
			zipCode = ?,
			city = ?,
			iban = ?,
			bic = ?,
			name = ?
		WHERE
			id = ?`,
		customerReq.FirstName, customerReq.LastName, customerReq.Title, customerReq.FamilyStatus,
		customerReq.BirthDate, customerReq.SocialSecurityNumber, customerReq.TaxId,
		customerReq.Email, customerReq.Address.Street, customerReq.Address.HouseNumber,
		customerReq.Address.ZipCode, customerReq.Address.City, customerReq.BankDetails.Iban, customerReq.BankDetails.Bic,
		customerReq.BankDetails.Name, customerId)
	if err != nil {
		tx.Rollback()
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error updating customer details",
		}, fmt.Errorf("error updating customer details: %v", err)
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error committing transaction",
		}, fmt.Errorf("error committing transaction: %v", err)
	}

	// Return success response
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       "Customer updated",
	}, nil
}
