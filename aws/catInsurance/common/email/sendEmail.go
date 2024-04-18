package email

import (
	"catInsurance/common/models"
	"encoding/json"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ses"
)

const (
	Sender  = "meowmed.noreply@gmail.com"
	CharSet = "UTF-8"
)

func SendEmail(receiverMail string, action string, rateRes float32, err error, contractReq *models.ContractReq) (events.APIGatewayProxyResponse, error) {
	var Subject, HTMLBody, TextBody string
	if action == "customer" {
		Subject = "Registrierung als Kunde bei MeowMed"
		HTMLBody = "<h1>Wir haben Sie als Kunden registriert.</h1><p>Vielen Dank, dass Sie sich für uns als Versicherer Ihrer geliebten Katze entschieden haben.</p>"
		TextBody = "Wir haben Sie als Kunden registriert. Vielen Dank, dass Sie sich für uns als Versicherer Ihrer geliebten Katze entschieden haben."
	} else if action == "contract" {
		Subject = "Vertrag Bestätigung"
		HTMLBody = "<h1>Sie haben den Vertrag erfolgreich abgeschlossen.</h1><p>Wir bestätigen Ihnen hiermit, dass wir Ihre Katze " + contractReq.CatName + " versichern. Die monatlichen Versicherungskosten betragen " + fmt.Sprintf("%.2f", rateRes) + "€."
		TextBody = "Sie haben den Vertrag erfolgreich abgeschlossen. Wir bestätigen Ihnen hiermit, dass wir Ihre Katze " + contractReq.CatName + " versichern. Die monatlichen Versicherungskosten betragen " + fmt.Sprintf("%.2f", rateRes) + "€."
	} else {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Invalid email type",
		}, nil
	}

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("eu-central-1")},
	)

	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Failed to create Session",
		}, nil
	}

	svc := ses.New(sess)
	input := &ses.SendEmailInput{
		Destination: &ses.Destination{
			ToAddresses: []*string{
				aws.String(receiverMail),
			},
		},
		Message: &ses.Message{
			Body: &ses.Body{
				Html: &ses.Content{
					Charset: aws.String(CharSet),
					Data:    aws.String(HTMLBody),
				},
				Text: &ses.Content{
					Charset: aws.String(CharSet),
					Data:    aws.String(TextBody),
				},
			},
			Subject: &ses.Content{
				Charset: aws.String(CharSet),
				Data:    aws.String(Subject),
			},
		},
		Source: aws.String(Sender),
	}

	_, err = svc.SendEmail(input)

	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case ses.ErrCodeMessageRejected:
				return events.APIGatewayProxyResponse{
					StatusCode: 500,
					Body:       "aws error: ErrCodeMessageRejected",
				}, nil
			case ses.ErrCodeMailFromDomainNotVerifiedException:
				return events.APIGatewayProxyResponse{
					StatusCode: 500,
					Body:       "aws error: ErrCodeMailFromDomainNotVerifiedException",
				}, nil
			case ses.ErrCodeConfigurationSetDoesNotExistException:
				return events.APIGatewayProxyResponse{
					StatusCode: 500,
					Body:       "aws error: ErrCodeConfigurationSetDoesNotExistException",
				}, nil
			default:
				return events.APIGatewayProxyResponse{
					StatusCode: 500,
					Body:       "aws error (from SES-Service)",
				}, nil
			}
		} else {
			// Falls ein Fehler auftritt, der nicht vom SES-Service ist
			return events.APIGatewayProxyResponse{
				StatusCode: 500,
				Body:       "aws error (NOT from SES-Service)",
			}, nil
		}
	}

	responseJSON, err := json.Marshal(receiverMail)
	if err != nil {
		log.Printf("Error serializing email details: %v\n", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Error serializing email details",
		}, nil
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(responseJSON),
	}, nil
}
