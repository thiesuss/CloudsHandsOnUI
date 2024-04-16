package contracts

import (
	"context"
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"time"

	"src/database/database"
	"github.com/aws/aws-lambda-go/events"
)

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

func CalculateRate(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "error connecting to database",
		}, nil
		
	}
	defer db.Close()

	coverage := req.PathParameters["coverage"]

	if coverage > 50000 {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "maximale Jahresdeckung beträgt 50,000",
		}, nil
	}

	var rate RateRes

	// Grundkosten
	var promille float32
	color := req.PathParameters["color"]

	if color == "Schwarz" {
		promille = 0.002
	} else {
		promille = 0.0015
	}
	grundkosten := float32(coverage) * promille

	// Prozentzuschlag
	var prozentzuschlag float32
	zipcode := req.PathParameters["zipcode"]
	environment := req.PathParameters["environment"]

	if zipcode <= 19999 {
		prozentzuschlag = grundkosten * 0.05
	}
	if environment == "Draußen" {
		prozentzuschlag += grundkosten * 0.1
	}

	var lastQuartile float32
	var min, max float32
	var averageAge float32
	breed := req.PathParameters["breed"]

	err = db.QueryRowContext(ctx, `
		SELECT Durchschnittsalter_min, Durchschnittsalter_max
		FROM Rate
		WHERE Rasse = ?
	`, breed).Scan(&min, &max)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "error retrieving average age details",
		}, nil
		
	}

	averageAge = ((min + max) / 2)
	lastQuartile = averageAge - (averageAge * 0.25)

	// Konvertiere den Geburtsdatum-String in ein time.Time Objekt
	birthDate := req.PathParameters["birthdate"]

	geburtsdatum, err := time.Parse("2006-01-02", birthDate)
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

	neutered := req.PathParameters["neutered"]
	if !neutered {
		monatlicheVersicherungskosten += 5
	}

	// Gewichtszuschlag
	// GEWICHT IN GRAMM ANGEGEBEN!!!
	weight := req.PathParameters["weight"]

	catWeight := weight / 1000
	err = db.QueryRowContext(ctx, `
		SELECT Durchschnittsgewicht_min, Durchschnittsgewicht_max
		FROM Rate 
		WHERE Rasse = ?
	`, breed).Scan(&min, &max)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "error retrieving weight intervall details",
		}, nil
	}
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
	`, breed).Scan(&illRate)
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
