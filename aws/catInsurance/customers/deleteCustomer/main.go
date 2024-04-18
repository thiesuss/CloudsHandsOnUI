package customers

import (
	"catInsurance/common/database"
	"context"
	"encoding/json"

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

	// Begin transaction
	tx, err := db.Begin()
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error starting transaction",
		}, nil
	}

	// Delete associated contracts
	_, err = tx.ExecContext(ctx, `
	DELETE FROM Contract WHERE customerId = ?`, customerId)
	if err != nil {
		tx.Rollback()
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error deleting associated contracts",
		}, nil
	}

	// Delete the customer
	_, err = tx.ExecContext(ctx, `
	DELETE FROM Customer WHERE id = ?`, customerId)
	if err != nil {
		tx.Rollback()
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error deleting customer",
		}, nil
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error committing transaction",
		}, nil
	}

	// Return success response
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(""),
	}, nil
}

func main() {
	lambda.Start(handler)
}
