/*
 * Cat Insurance API
 *
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * API version: 1.0.0
 * Generated by: OpenAPI Generator (https://openapi-generator.tech)
 */

package openapi

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/google/uuid"
)

// ContractAPIService is a service that implements the logic for the ContractAPIServicer
// This service should implement the business logic for every endpoint for the ContractAPI API.
// Include any external packages or services that will be required by this service.
type ContractAPIService struct {
}

// NewContractAPIService creates a default api service
func NewContractAPIService() ContractAPIServicer {
	return &ContractAPIService{}
}

// Maximale jahresdeckung 50,000
// Grundkosten: Jahresdeckung * Promille -> Normal 1.5 Schwarz 2.0 (Promille = 1/1000)
// Prozentzuschlag = Grundkosten * (P1 + P2 + P3)
// P1 = Risikozuschlag für Postleitzahl
// P2 = Zuschlag für Freigängerkatzen
// P3 = Aufschlag nach Alter
// Monatliche Versicherungskosten = Grundkosten + Prozentzuschlag +
// Kastriert-Zuschlag + Gewichtszuschlag + Krankheitswahrscheinlichkeitszuschlag
// Letztes Quartiel von Durschnittsalter +20%
// unter 2 dann	+10%
// Draußen/Freigänger +10%
// Persönlichkeit "besonders verspielt" NICHT VERSICHERT
// Postleitzahl 0, 1 +5%
// Pauschal 1-10 Krankheiten Wert in Euro (1-10 Euro)
// nicht Kastriert +5
// Gewicht außerhalb von Intervall -> Jedes kilo 5 Euro

// CalculateRate - Calculate rate
var globRate float32

func (s *ContractAPIService) CalculateRate(ctx context.Context, rateCalculationReq RateCalculationReq) (ImplResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	if rateCalculationReq.Coverage > 50000 {
		return Response(http.StatusBadRequest, nil), fmt.Errorf("maximale Jahresdeckung beträgt 50,000: %v", err)
	}

	var rate RateRes

	// Grundkosten
	var promille float32
	if rateCalculationReq.Breed == "Schwarz" {
		promille = 0.002
	} else {
		promille = 0.0015
	}
	grundkosten := float32(rateCalculationReq.Coverage) * promille

	// Prozentzuschlag
	var prozentzuschlag float32

	if rateCalculationReq.ZipCode <= 19999 {
		prozentzuschlag = grundkosten * 0.05
	}
	if rateCalculationReq.Environment == "Draußen" {
		prozentzuschlag += grundkosten * 0.1
	}

	var lastQuartile float32
	var min, max float32
	var averageAge float32

	err = db.QueryRowContext(ctx, `
		SELECT Durchschnittsalter_min, Durchschnittsalter_max
		FROM Rate
		WHERE Rasse = ?
	`, rateCalculationReq.Breed).Scan(&min, &max)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving average age details: %v", err)
	}

	averageAge = ((min + max) / 2)
	lastQuartile = averageAge - (averageAge * 0.25)

	// Konvertiere den Geburtsdatum-String in ein time.Time Objekt
	geburtsdatum, err := time.Parse("2006-01-02", rateCalculationReq.BirthDate)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error parsing birthdate: %v", err)
	}

	// Berechne das Alter der Katze in Jahren
	heute := time.Now()
	alter := heute.Year() - geburtsdatum.Year()

	// Überprüfe, ob die Katze jünger als 2 Jahre ist
	if alter < 2 {
		prozentzuschlag += grundkosten * 0.1
	} else if float32(alter) > lastQuartile {
		prozentzuschlag += grundkosten * 0.2
	}

	// Monatliche Versicherungskosten
	monatlicheVersicherungskosten := grundkosten + prozentzuschlag

	// Pauschalzuschlag
	// Kastriert-Zuschlag

	if !rateCalculationReq.Neutered {
		monatlicheVersicherungskosten += 5
	}

	// Gewichtszuschlag
	// GEWICHT IN GRAMM ANGEGEBEN!!!
	catWeight := rateCalculationReq.Weight / 1000
	err = db.QueryRowContext(ctx, `
		SELECT Durchschnittsgewicht_min, Durchschnittsgewicht_max
		FROM Rate 
		WHERE Rasse = ?
	`, rateCalculationReq.Breed).Scan(&min, &max)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving weight intervall details: %v", err)
	}
	if catWeight < min {
		monatlicheVersicherungskosten += (min - catWeight) * 5 //TODO Für jedes Kilo oder die genaue Differenz?
	} else if catWeight > max {
		monatlicheVersicherungskosten += (catWeight - max) * 5
	}

	// Krankheitswahrscheinlichkeitszuschlag
	var illRate int
	err = db.QueryRowContext(ctx, `
	SELECT Anfälligkeit_für_Krankheiten
		FROM Rate 
		WHERE Rasse = ?
	`, rateCalculationReq.Breed).Scan(&illRate)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving illRate details: %v", err)
	}
	monatlicheVersicherungskosten += float32(illRate)

	rate.Rate = monatlicheVersicherungskosten
	globRate = monatlicheVersicherungskosten

	// Return success response with the rate details
	return Response(http.StatusOK, rate), nil
}

// CreateContract - Create a new contract
func (s *ContractAPIService) CreateContract(ctx context.Context, contractReq ContractReq) (ImplResponse, error) {

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

	// Insert into Contract table
	newContractID := uuid.New().String()
	_, err = tx.ExecContext(context.Background(), `
		INSERT INTO Contract (id, startDate, endDate, coverage, catName, breed, color, birthDate, neutered, personality, environment, weight, customerId)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		newContractID, contractReq.StartDate, contractReq.EndDate, contractReq.Coverage, contractReq.CatName, contractReq.Breed, contractReq.Color,
		contractReq.BirthDate, contractReq.Neutered, contractReq.Personality, contractReq.Environment, contractReq.Weight, contractReq.CustomerId)
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

	SendEmail(customerEmail, "contract", globRate, err, &contractReq)

	return Response(http.StatusCreated, newContractRes), nil
}

// GetContract -
func (s *ContractAPIService) GetContract(ctx context.Context, contractId string) (ImplResponse, error) {
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
		cu.id
	FROM
		Contract co
	JOIN
		Customer cu ON co.customerId = cu.id
	WHERE
		co.id = ?`, contractId).Scan(
		&contract.Id, &contract.StartDate, &contract.EndDate, &contract.Coverage, &contract.CatName, &contract.Breed, &contract.Color, &contract.BirthDate, &contract.Neutered,
		&contract.Personality, &contract.Environment, &contract.Weight, &contract.CustomerId)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving contract details: %v", err)
	}

	// Return success response with the contract details
	return Response(http.StatusOK, contract), nil
}

// GetCustomerContracts - Get customer contracts
func (s *ContractAPIService) GetCustomerContracts(ctx context.Context, customerId string, page int32, pageSize int32) (ImplResponse, error) {
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
		`SELECT co.id, co.startDate, co.endDate, co.coverage, co.catName, co.breed, co.color, co.birthDate, co.neutered, co.personality, co.environment, co.weight, co.customerId
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
			&contract.Personality, &contract.Environment, &contract.Weight, &contract.CustomerId); err != nil {
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
