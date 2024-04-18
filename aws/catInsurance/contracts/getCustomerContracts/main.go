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
	customerId := req.QueryStringParameters["customerId"]

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

	// Query to retrieve contract details with JOIN
	var contracts []models.ContractRes

	// Query to retrieve paginated contract details
	rows, err := db.QueryContext(ctx,
		`SELECT co.id, co.startDate, co.endDate, co.coverage, co.catName, co.breed, co.color, co.birthDate, co.neutered, co.personality, co.environment, co.weight, co.customerId, co.rate
			FROM Contract co
			WHERE co.customerId = ?
			ORDER BY co.customerId ASC
			LIMIT ? OFFSET ?`, customerId, pageSize, offset)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       "Error retrieving contract details",
		}, nil
	}
	defer rows.Close()

	// Iterate over the rows and populate the contract slice
	for rows.Next() {
		var contract models.ContractRes
		if err := rows.Scan(
			&contract.Id, &contract.StartDate, &contract.EndDate, &contract.Coverage, &contract.CatName, &contract.Breed, &contract.Color, &contract.BirthDate, &contract.Neutered,
			&contract.Personality, &contract.Environment, &contract.Weight, &contract.CustomerId, &contract.Rate); err != nil {
			return events.APIGatewayProxyResponse{
				StatusCode: http.StatusBadRequest,
				Body:       "Error scanning contract details",
			}, nil
		}

		// Append contract details to the contract slice
		contracts = append(contracts, contract)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       "Error iterating over contract details",
		}, nil
	}

	if len(contracts) == 0 {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusOK,
			Headers: map[string]string{
				"Content-Type": "application/json",
			},
			Body: "{}",
		}, nil
	}

	// Marshal customers slice to JSON
	contractsJSON, err := json.Marshal(contracts)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       fmt.Sprintf("Error marshaling contract details to JSON: %v", err),
		}, nil
	}

	// Return success response with the customer details
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(contractsJSON),
	}, nil

}

func main() {
	lambda.Start(handler)
}
