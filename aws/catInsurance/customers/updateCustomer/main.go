package customers

import (
	"catInsurance/common/database"
	"catInsurance/common/utils"
	"catInsurance/common/validator"
	"context"
	"encoding/json"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	customerId, customerReq, err := utils.ParseCustomerReqAndCustomerID(req.QueryStringParameters)
	//NEED TO PARSE CUSTOMERREQ AND CUSTOMERID
	// Parse request body
	if err := json.Unmarshal([]byte(req.Body), &customerReq); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "Invalid request body",
		}, nil
	}

	// Retrieve database credentials
	db, err := database.ConnectToDB()
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error connecting to database",
		}, nil
	}
	defer db.Close()

	// Begin transaction
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error starting transaction",
		}, nil
	}

	validationErr := validator.ValidateCustomer(customerReq)
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
		}, nil
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error committing transaction",
		}, nil
	}

	// Return success response
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       "Customer updated",
	}, nil
}

func main() {
	lambda.Start(handler)
}
