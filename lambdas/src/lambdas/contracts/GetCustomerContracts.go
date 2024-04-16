package contracts

import (
	"context"
	"fmt"
	"net/http"

)

func (ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Calculate offset based on page number and page size
	offset := (page - 1) * pageSize

	// Query to retrieve contract details with JOIN
	var contracts []ContractRes

	// Query to retrieve paginated contract details
	rows, err := db.QueryContext(ctx,
		`SELECT co.id, co.startDate, co.endDate, co.coverage, co.catName, co.breed, co.color, co.birthDate, co.neutered, co.personality, co.environment, co.weight, co.customerId, co.rate
			FROM Contract co
			WHERE co.customerId = ?
			ORDER BY co.customerId ASC
			LIMIT ? OFFSET ?`, customerId, pageSize, offset)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving contract details: %v", err)
	}
	defer rows.Close()

	// Iterate over the rows and populate the contract slice
	for rows.Next() {
		var contract ContractRes
		if err := rows.Scan(
			&contract.Id, &contract.StartDate, &contract.EndDate, &contract.Coverage, &contract.CatName, &contract.Breed, &contract.Color, &contract.BirthDate, &contract.Neutered,
			&contract.Personality, &contract.Environment, &contract.Weight, &contract.CustomerId, &contract.Rate); err != nil {
			return Response(http.StatusInternalServerError, nil), fmt.Errorf("error scanning contract details: %v", err)
		}

		// Append contract details to the contract slice
		contracts = append(contracts, contract)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error iterating over contract details: %v", err)
	}

	if len(contracts) == 0 {
		return Response(http.StatusOK, []int{}), nil
	}

	// Return success response with the customer details
	return Response(http.StatusOK, contracts), nil
}