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
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
	"github.com/google/uuid"

	_ "github.com/go-sql-driver/mysql"
)

// CustomerAPIService is a service that implements the logic for the CustomerAPIServicer
// This service should implement the business logic for every endpoint for the CustomerAPI API.
// Include any external packages or services that will be required by this service.
type CustomerAPIService struct {
}

type DBCredentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
	Host     string `json:"host"`
	Port     int    `json:"port"`
}

// Function to retrieve database credentials from Secrets Manager
func getDBCredentials() (DBCredentials, error) {
	var dbCredentials DBCredentials

	region := "eu-central-1"
	secretName := "prod/v2/sql"

	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(region),
	)
	if err != nil {
		return DBCredentials{}, fmt.Errorf("failed to load AWS configuration: %v", err)
	}

	svc := secretsmanager.NewFromConfig(cfg)
	input := &secretsmanager.GetSecretValueInput{
		SecretId:     aws.String(secretName),
		VersionStage: aws.String("AWSCURRENT"),
	}

	result, err := svc.GetSecretValue(context.TODO(), input)
	if err != nil {
		return DBCredentials{}, fmt.Errorf("failed to retrieve database credentials from Secrets Manager: %v", err)
	}

	secretString := *result.SecretString

	// Parse the JSON secret string
	if err := json.Unmarshal([]byte(secretString), &dbCredentials); err != nil {
		return DBCredentials{}, fmt.Errorf("error parsing database credentials: %v", err)
	}

	return dbCredentials, nil
}

// Use getDBCredentials function to retrieve database credentials
func connectToDB() (*sql.DB, error) {
	// Retrieve database credentials
	dbCredentials, err := getDBCredentials()
	if err != nil {
		return nil, err
	}

	// Format the DSN for connecting to the MySQL database
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/meowmeddb", dbCredentials.Username, dbCredentials.Password, dbCredentials.Host, dbCredentials.Port)

	// Connect to the database
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, fmt.Errorf("error connecting to database: %v", err)
	}

	return db, nil
}

// NewCustomerAPIService creates a default api service
func NewCustomerAPIService() CustomerAPIServicer {
	return &CustomerAPIService{}
}

// CreateCustomer - Create a new customer
func (s *CustomerAPIService) CreateCustomer(ctx context.Context, customerReq CustomerReq) (ImplResponse, error) {
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

	// Generate UUID for the new customer
	newCustomerID := uuid.New().String()

	// Insert into Customer table
	_, err = tx.ExecContext(ctx, `
			INSERT INTO Customer (id, firstName, lastName, title, familyStatus, birthDate, socialSecurityNumber, taxId, email, street, houseNumber, zipCode, city, iban, bic, name)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		newCustomerID, customerReq.FirstName, customerReq.LastName, customerReq.Title, customerReq.FamilyStatus, customerReq.BirthDate,
		customerReq.SocialSecurityNumber, customerReq.TaxId, customerReq.Email,
		customerReq.Address.Street, customerReq.Address.HouseNumber, customerReq.Address.ZipCode, customerReq.Address.City,
		customerReq.BankDetails.Iban, customerReq.BankDetails.Bic, customerReq.BankDetails.Name)
	if err != nil {
		tx.Rollback()
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error inserting into Customer table: %v", err)
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error committing transaction: %v", err)
	}

	// Respond with the new customer details
	newCustomerRes := CustomerRes{
		Id:                   newCustomerID,
		FirstName:            customerReq.FirstName,
		LastName:             customerReq.LastName,
		Title:                customerReq.Title,
		FamilyStatus:         customerReq.FamilyStatus,
		BirthDate:            customerReq.BirthDate,
		SocialSecurityNumber: customerReq.SocialSecurityNumber,
		TaxId:                customerReq.TaxId,
		Email:                customerReq.Email,
		Address: Address{
			Street:      customerReq.Address.Street,
			HouseNumber: customerReq.Address.HouseNumber,
			ZipCode:     customerReq.Address.ZipCode,
			City:        customerReq.Address.City,
		},
		BankDetails: BankDetails{
			Iban: customerReq.BankDetails.Iban,
			Bic:  customerReq.BankDetails.Bic,
			Name: customerReq.BankDetails.Name,
		},
	}

	return Response(http.StatusCreated, newCustomerRes), nil
}

// DeleteCustomer - Delete a customer
func (s *CustomerAPIService) DeleteCustomer(ctx context.Context, customerId string) (ImplResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Begin transaction
	tx, err := db.Begin()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error starting transaction: %v", err)
	}

	// Delete associated contracts
	_, err = tx.ExecContext(ctx, `
        DELETE FROM Contract WHERE customerId = ?`, customerId)
	if err != nil {
		tx.Rollback()
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error deleting associated contracts: %v", err)
	}

	// Delete the customer
	_, err = tx.ExecContext(ctx, `
        DELETE FROM Customer WHERE id = ?`, customerId)
	if err != nil {
		tx.Rollback()
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error deleting customer: %v", err)
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error committing transaction: %v", err)
	}

	// Return success response
	return Response(http.StatusOK, nil), nil
}

// GetCustomer - Get customer details
func (s *CustomerAPIService) GetCustomer(ctx context.Context, customerId string) (ImplResponse, error) {
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

// GetCustomers - Get all customers
func (s *CustomerAPIService) GetCustomers(ctx context.Context, page int32, pageSize int32) (ImplResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Calculate offset based on page number and page size
	offset := (page - 1) * pageSize

	// Query to retrieve paginated customer details
	rows, err := db.QueryContext(ctx, `
        SELECT
            c.id, c.firstName, c.lastName, COALESCE(c.title, '') AS title, c.familyStatus, c.birthDate,
            c.socialSecurityNumber, c.taxId, c.email, c.street, c.houseNumber, c.zipCode, c.city, c.iban, c.bic, c.name
        FROM
            Customer AS c
        ORDER BY c.id ASC
        LIMIT ? OFFSET ?`, pageSize, offset)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error retrieving customer details: %v", err)
	}
	defer rows.Close()

	// Construct slice to hold customer details
	var customers []CustomerRes

	// Iterate over the rows and populate the customers slice
	for rows.Next() {
		var customer CustomerRes
		if err := rows.Scan(
			&customer.Id, &customer.FirstName, &customer.LastName, &customer.Title, &customer.FamilyStatus, &customer.BirthDate,
			&customer.SocialSecurityNumber, &customer.TaxId, &customer.Email,
			&customer.Address.Street, &customer.Address.HouseNumber, &customer.Address.ZipCode, &customer.Address.City,
			&customer.BankDetails.Iban, &customer.BankDetails.Bic, &customer.BankDetails.Name,
		); err != nil {
			return Response(http.StatusInternalServerError, nil), fmt.Errorf("error scanning customer details: %v", err)
		}

		// Append customer details to the customers slice
		customers = append(customers, customer)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error iterating over customer details: %v", err)
	}

	// Return success response with the customer details
	return Response(http.StatusOK, customers), nil
}

// SearchCustomers - Search for customers
func (s *CustomerAPIService) SearchCustomers(ctx context.Context, text string, page int32, pageSize int32) (ImplResponse, error) {
	// Retrieve database credentials
	db, err := connectToDB()
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error connecting to database: %v", err)
	}
	defer db.Close()

	// Calculate offset based on page number and page size
	offset := (page - 1) * pageSize

	// Query to search for customers based on the provided text
	rows, err := db.QueryContext(ctx, `
        SELECT
            c.id, c.firstName, c.lastName, COALESCE(c.title, '') AS title, c.familyStatus, c.birthDate,
            c.socialSecurityNumber, c.taxId, c.email, c.street, c.houseNumber, c.zipCode, c.city, c.iban, c.bic, c.name
        FROM
            Customer AS c
        WHERE
            c.firstName LIKE ? OR
            c.lastName LIKE ? OR
            a.street LIKE ?
        ORDER BY c.id ASC
        LIMIT ? OFFSET ?`, "%"+text+"%", "%"+text+"%", "%"+text+"%", pageSize, offset)
	if err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error searching customers: %v", err)
	}
	defer rows.Close()

	// Construct slice to hold customer details
	var customers []CustomerRes

	// Iterate over the rows and populate the customers slice
	for rows.Next() {
		var customer CustomerRes
		if err := rows.Scan(
			&customer.Id, &customer.FirstName, &customer.LastName, &customer.Title, &customer.FamilyStatus, &customer.BirthDate,
			&customer.SocialSecurityNumber, &customer.TaxId, &customer.Email,
			&customer.Address.Street, &customer.Address.HouseNumber, &customer.Address.ZipCode, &customer.Address.City,
			&customer.BankDetails.Iban, &customer.BankDetails.Bic, &customer.BankDetails.Name,
		); err != nil {
			return Response(http.StatusInternalServerError, nil), fmt.Errorf("error scanning customer details: %v", err)
		}

		// Append customer details to the customers slice
		customers = append(customers, customer)
	}

	// Check for errors during rows iteration
	if err := rows.Err(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error iterating over customer details: %v", err)
	}

	// Return success response with the customer details
	return Response(http.StatusOK, customers), nil
}

// UpdateCustomer - Update a customer
func (s *CustomerAPIService) UpdateCustomer(ctx context.Context, customerId string, customerReq CustomerReq) (ImplResponse, error) {

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

	// Update Customer table
	_, err = tx.ExecContext(ctx, `
        UPDATE Customer
        SET
            firstName = ?,
            lastName = ?,
            title = ?,
            familyStatus = ?,
            birthDate = ?,
            socialSecurityNumber = ?,
            taxId = ?,
            email = ?,
			street = ?,
            houseNumber = ?,
            zipCode = ?,
            city = ?,
			iban = ?,
            bic = ?,
            name = ?
        WHERE
            id = ?`,
		customerReq.FirstName, customerReq.LastName, customerReq.Title, customerReq.FamilyStatus,
		customerReq.BirthDate, customerReq.SocialSecurityNumber, customerReq.TaxId,
		customerReq.Email, customerReq.Address.Street, customerReq.Address.HouseNumber,
		customerReq.Address.ZipCode, customerReq.Address.City, customerReq.BankDetails.Iban, customerReq.BankDetails.Bic,
		customerReq.BankDetails.Name, customerId)
	if err != nil {
		tx.Rollback()
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error updating customer details: %v", err)
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return Response(http.StatusInternalServerError, nil), fmt.Errorf("error committing transaction: %v", err)
	}

	// Return success response
	return Response(http.StatusOK, "Customer updated"), nil
}
