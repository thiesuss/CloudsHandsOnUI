package utils

import (
	"catInsurance/common/database"
	"catInsurance/common/models"
	"context"
	"encoding/json"
	"math"
	"time"

	"github.com/aws/aws-lambda-go/events"
)

func InternCall(ctx context.Context, req models.RateCalculationReq) (events.APIGatewayProxyResponse, error) {

	customerReqJSON, err := json.Marshal(req)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error while calling calcRate intern",
		}, nil
	}

	rateReq := events.APIGatewayProxyRequest{
		Body: string(customerReqJSON),
	}

	return CalculateRate(ctx, rateReq)
}

func CalculateRate(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	var rateReq models.RateCalculationReq

	// Parse request body
	if err := json.Unmarshal([]byte(req.Body), &rateReq); err != nil {
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
			Body:       "error connecting to database",
		}, nil

	}
	defer db.Close()

	if rateReq.Coverage > 50000 {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "maximale Jahresdeckung beträgt 50,000",
		}, nil
	}

	var rate models.RateRes

	// Grundkosten
	var promille float32

	if rateReq.Color == "Schwarz" {
		promille = 0.002
	} else {
		promille = 0.0015
	}
	grundkosten := float32(rateReq.Coverage) * promille

	// Prozentzuschlag
	var prozentzuschlag float32

	if rateReq.ZipCode <= 19999 {
		prozentzuschlag = grundkosten * 0.05
	}
	if rateReq.Environment == "Draußen" {
		prozentzuschlag += grundkosten * 0.1
	}

	var lastQuartile float32
	var min, max float32
	var averageAge float32

	err = db.QueryRowContext(ctx, `
		SELECT Durchschnittsalter_min, Durchschnittsalter_max
		FROM Rate
		WHERE Rasse = ?
	`, rateReq.Breed).Scan(&min, &max)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "error retrieving average age details",
		}, nil

	}

	averageAge = ((min + max) / 2)
	lastQuartile = averageAge - (averageAge * 0.25)

	// Konvertiere den Geburtsdatum-String in ein time.Time Objekt

	geburtsdatum, err := time.Parse("2006-01-02", rateReq.BirthDate)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "error parsing birthdate",
		}, nil
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

	if !rateReq.Neutered {
		monatlicheVersicherungskosten += 5
	}

	// Gewichtszuschlag
	// GEWICHT IN GRAMM ANGEGEBEN!!!

	catWeight := rateReq.Weight / 1000
	err = db.QueryRowContext(ctx, `
		SELECT Durchschnittsgewicht_min, Durchschnittsgewicht_max
		FROM Rate 
		WHERE Rasse = ?
	`, rateReq.Breed).Scan(&min, &max)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "error retrieving weight intervall details",
		}, nil
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
	`, rateReq.Breed).Scan(&illRate)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "error retrieving illRate details",
		}, nil
	}
	monatlicheVersicherungskosten += float32(illRate)

	rate.Rate = float32(math.Round(float64(monatlicheVersicherungskosten)*100) / 100)
	responseJSON, err := json.Marshal(rate)
	// Return success response with the rate details
	return events.APIGatewayProxyResponse{
		StatusCode: 400,
		Body:       string(responseJSON),
	}, nil
}
