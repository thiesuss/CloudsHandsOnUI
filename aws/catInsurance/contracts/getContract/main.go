package contracts

import (
	"context"
	"fmt"
	"net/http"

)

func (ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error){
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Query to retrieve contract details with JOIN
	var contract ContractRes

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
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving contract details: %v", err)
	}

	// Return success response with the contract details
	return Response(http.StatusOK, contract), nil
}