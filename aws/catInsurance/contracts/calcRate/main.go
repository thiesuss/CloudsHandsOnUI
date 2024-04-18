package main

import (
	"catInsurance/common/utils"
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
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

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return utils.CalculateRate(ctx, req)
}

func main() {
	lambda.Start(handler)
}
