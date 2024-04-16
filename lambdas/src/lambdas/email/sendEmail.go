package openapi

import (
	"fmt"
	"net/http"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ses"
)

const (
	Sender  = "meowmed.noreply@gmail.com"
	CharSet = "UTF-8"
)

func SendEmail(receiverMail string, action string, rateRes float32, err error, contractReq *ContractReq) (ImplResponse, error) {
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
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("invalid Email Type: %v", err)
	}

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("eu-central-1")},
	)

	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("failed to create Session: %v", err)
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
				return Response(http.StatusInternalServerError, nil), fmt.Errorf("aws error: ErrCodeMessageRejected: %v", err)
			case ses.ErrCodeMailFromDomainNotVerifiedException:
				return Response(http.StatusInternalServerError, nil), fmt.Errorf("aws error: ErrCodeMailFromDomainNotVerifiedException: %v", err)
			case ses.ErrCodeConfigurationSetDoesNotExistException:
				return Response(http.StatusInternalServerError, nil), fmt.Errorf("aws error: ErrCodeConfigurationSetDoesNotExistException: %v", err)
			default:
				return Response(http.StatusInternalServerError, nil), fmt.Errorf("aws error (from SES-Service): %v", err)
			}
		} else {
			// Falls ein Fehler auftritt, der nicht vom SES-Service ist
			return Response(http.StatusInternalServerError, nil), fmt.Errorf("aws error (NOT from SES-Service): %v", err)
		}
	}

	return Response(http.StatusOK, receiverMail), nil
}
