package customers

import (
	"context"
	"encoding/json"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/google/uuid"
	"github.com/marcmarder/CloudsHandsOn/lambdas/src/database"
	"github.com/marcmarder/CloudsHandsOn/lambdas/src/lambdas/email"
	"github.com/marcmarder/CloudsHandsOn/lambdas/src/models"
	"github.com/marcmarder/CloudsHandsOn/lambdas/src/validator"

	_ "github.com/go-sql-driver/mysql"
)

func createCustomer(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	var customerReq models.CustomerReq

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
			StatusCode: 500,
			Body:       "Error connecting to database",
		}, nil
	}
	defer db.Close()

	// Begin transaction
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error starting transaction",
		}, nil
	}

	// Generate UUID for the new customer
	newCustomerID := uuid.New().String()

	validationErr := validator.ValidateCustomer(customerReq)
	if validationErr != "valid" {
		tx.Rollback()
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       validationErr,
		}, nil
	}

	// Insert into Customer table
	_, err = tx.ExecContext(ctx, `
		INSERT INTO Customer (id, firstName, lastName, title, familyStatus, birthDate, socialSecurityNumber, taxId, email, street, houseNumber, zipCode, city, iban, bic, name)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		newCustomerID, customerReq.FirstName, customerReq.LastName, customerReq.Title, customerReq.FamilyStatus, customerReq.BirthDate, customerReq.SocialSecurityNumber, customerReq.TaxId, customerReq.Email, customerReq.Address.Street, customerReq.Address.HouseNumber, customerReq.Address.ZipCode, customerReq.Address.City, customerReq.BankDetails.Iban, customerReq.BankDetails.Bic, customerReq.BankDetails.Name)
	if err != nil {
		tx.Rollback()
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error inserting into Customer table",
		}, nil
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error committing transaction",
		}, nil
	}

	// Respond with the new customer details
	newCustomerRes := models.CustomerRes{
		Id:                   newCustomerID,
		FirstName:            customerReq.FirstName,
		LastName:             customerReq.LastName,
		Title:                customerReq.Title,
		FamilyStatus:         customerReq.FamilyStatus,
		BirthDate:            customerReq.BirthDate,
		SocialSecurityNumber: customerReq.SocialSecurityNumber,
		TaxId:                customerReq.TaxId,
		Email:                customerReq.Email,
		Address: models.Address{
			Street:      customerReq.Address.Street,
			HouseNumber: customerReq.Address.HouseNumber,
			ZipCode:     customerReq.Address.ZipCode,
			City:        customerReq.Address.City,
		},
		BankDetails: models.BankDetails{
			Iban: customerReq.BankDetails.Iban,
			Bic:  customerReq.BankDetails.Bic,
			Name: customerReq.BankDetails.Name,
		},
	}

	responseJSON, err := json.Marshal(newCustomerRes)
	if err != nil {
		log.Printf("Error serializing customer details: %v\n", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error serializing customer details",
		}, nil
	}

	email.SendEmail(customerReq.Email, "customer", 0.0, err, nil)

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(responseJSON),
	}, nil
}
