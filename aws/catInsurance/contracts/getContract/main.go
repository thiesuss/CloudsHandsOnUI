package contracts

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
	var contractId int
	// Parse request body
	if err := json.Unmarshal([]byte(req.Body), &contractId); err != nil {
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

	// Query to retrieve contract details with JOIN
	var contract models.ContractRes

	// Perform database query
	err = db.QueryRowContext(ctx, `
	SELECT
		co.id, co.startDate, co.endDate, co.coverage, co.catName, co.breed, co.color, co.birthDate, co.neutered, co.personality, co.environment, co.weight, 
		cu.id, co.rate
	FROM
		Contract co
	JOIN
		Customer cu ON co.customerId = cu.id
	WHERE
		co.id = ?`, contractId).Scan(
		&contract.Id, &contract.StartDate, &contract.EndDate, &contract.Coverage, &contract.CatName, &contract.Breed, &contract.Color, &contract.BirthDate, &contract.Neutered,
		&contract.Personality, &contract.Environment, &contract.Weight, &contract.CustomerId, &contract.Rate)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error retrieving contract details",
		}, nil
	}

	// Marshal contract slice to JSON
	contractJSON, err := json.Marshal(contract)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error marshaling contract details to JSON",
		}, nil
	}

	// Return success response with the contract details
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(contractJSON),
	}, nil
}

func main() {
	lambda.Start(handler)
}
