package main

import (
	"catInsurance/common/database"
	"catInsurance/common/email"
	"catInsurance/common/models"
	"catInsurance/common/utils"
	"catInsurance/common/validator"
	"context"
	"encoding/json"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/google/uuid"
)

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	var contractReq models.ContractReq

	// Parse request body
	if err := json.Unmarshal([]byte(req.Body), &contractReq); err != nil {
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

	validationErr := validator.ValidateCat(contractReq)
	if validationErr != "valid" {
		tx.Rollback()
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       validationErr,
		}, nil
	}

	var zipCode float32

	// Perform database query
	err = db.QueryRowContext(ctx, `
	SELECT
		cu.zipCode
	FROM
		Customer cu
	WHERE
		cu.id = ?`, contractReq.CustomerId).Scan(&zipCode)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error retrieving zipcode from customer",
		}, nil
	}

	// Calculate rate
	rateCalculationReq := models.RateCalculationReq{
		Coverage:    contractReq.Coverage,
		Color:       contractReq.Color,
		Breed:       contractReq.Breed,
		BirthDate:   contractReq.BirthDate,
		Neutered:    contractReq.Neutered,
		Weight:      contractReq.Weight,
		ZipCode:     zipCode,
		Personality: contractReq.Personality,
		Environment: contractReq.Environment,
	}

	rateImpl, err := utils.InternCall(ctx, rateCalculationReq)
	var rateRes models.RateRes
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error calculating rate",
		}, nil
	}

	err = json.Unmarshal([]byte(rateImpl.Body), &rateRes)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "failed to Unmarshal RateRes",
		}, nil
	}

	// Insert into Contract table
	newContractID := uuid.New().String()
	_, err = tx.ExecContext(context.Background(), `
		INSERT INTO Contract (id, startDate, endDate, coverage, catName, breed, color, birthDate, neutered, personality, environment, weight, customerId, rate)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		newContractID, contractReq.StartDate, contractReq.EndDate, contractReq.Coverage, contractReq.CatName, contractReq.Breed, contractReq.Color,
		contractReq.BirthDate, contractReq.Neutered, contractReq.Personality, contractReq.Environment, contractReq.Weight, contractReq.CustomerId, rateRes.Rate)
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

	// Respond with the new contract details
	newContractRes := models.ContractRes{
		Id:          newContractID,
		StartDate:   contractReq.StartDate,
		EndDate:     contractReq.EndDate,
		Coverage:    contractReq.Coverage,
		CatName:     contractReq.CatName,
		Breed:       contractReq.Breed,
		Color:       contractReq.Color,
		BirthDate:   contractReq.BirthDate,
		Neutered:    contractReq.Neutered,
		Personality: contractReq.Personality,
		Environment: contractReq.Environment,
		Weight:      contractReq.Weight,
		CustomerId:  contractReq.CustomerId,
	}

	responseJSON, err := json.Marshal(newContractRes)
	if err != nil {
		log.Printf("Error serializing customer details: %v\n", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error serializing contract details",
		}, nil
	}

	//Send Email for new contract
	var customerEmail string

	// Perform database query
	err = db.QueryRowContext(ctx, `
	SELECT
		cu.email
	FROM
		Customer cu
	WHERE
		cu.id = ?`, contractReq.CustomerId).Scan(&customerEmail)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error retreiving email from customer",
		}, nil
	}

	email.SendEmail(customerEmail, "contract", rateRes.Rate, err, &contractReq)

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(responseJSON),
	}, nil
}

func main() {
	lambda.Start(handler)
}
