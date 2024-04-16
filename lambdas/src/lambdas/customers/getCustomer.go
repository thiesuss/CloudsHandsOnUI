package customers

import (
	"context"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
)

func getCustomer(ctx context.Context, customerId events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Query to retrieve customer details with JOIN
	var customer CustomerRes

	// Perform database query
	err = db.QueryRowContext(ctx, `
		SELECT
			c.id, c.firstName, c.lastName, COALESCE(c.title, '') AS title, c.familyStatus, c.birthDate,
			c.socialSecurityNumber, c.taxId, c.email, c.street, c.houseNumber, c.zipCode, c.city, c.iban, c.bic, c.name
		FROM
			Customer AS c
		WHERE
			c.id = ?`, customerId).Scan(
		&customer.Id, &customer.FirstName, &customer.LastName, &customer.Title, &customer.FamilyStatus, &customer.BirthDate,
		&customer.SocialSecurityNumber, &customer.TaxId, &customer.Email,
		&customer.Address.Street, &customer.Address.HouseNumber, &customer.Address.ZipCode, &customer.Address.City,
		&customer.BankDetails.Iban, &customer.BankDetails.Bic, &customer.BankDetails.Name)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving customer details: %v", err)
	}

	// Return success response with the customer details
	return Response(http.StatusOK, customer), nil
}
