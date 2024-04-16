package contracts

import (
	"context"
	"fmt"
	"net/http"

)

func CreateContract(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Begin transaction
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error starting transaction: %v", err)
	}

	validationErr := validateCat(contractReq)
	if validationErr != "valid" {
		tx.Rollback()
		return Response(http.StatusBadRequest, nil), fmt.Errorf(validationErr)
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
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving zipcode from customer: %v", err)
	}

	// Calculate rate
	rateCalculationReq := RateCalculationReq{
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

	rateImpl, err := s.CalculateRate(ctx, rateCalculationReq)

	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error calculating rate: %v", err)
	}

	// Insert into Contract table
	newContractID := uuid.New().String()
	_, err = tx.ExecContext(context.Background(), `
		INSERT INTO Contract (id, startDate, endDate, coverage, catName, breed, color, birthDate, neutered, personality, environment, weight, customerId, rate)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		newContractID, contractReq.StartDate, contractReq.EndDate, contractReq.Coverage, contractReq.CatName, contractReq.Breed, contractReq.Color,
		contractReq.BirthDate, contractReq.Neutered, contractReq.Personality, contractReq.Environment, contractReq.Weight, contractReq.CustomerId, rateImpl.Body.(RateRes).Rate)
	if err != nil {
		tx.Rollback()
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error inserting into Contract table: %v", err)
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error committing transaction: %v", err)
	}

	// Respond with the new contract details
	newContractRes := ContractRes{
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
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving email from customer: %v", err)
	}

	SendEmail(customerEmail, "contract", rateImpl.Body.(RateRes).Rate, err, &contractReq)

	return Response(http.StatusCreated, newContractRes), nil
}