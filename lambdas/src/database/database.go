package database

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
	_ "github.com/go-sql-driver/mysql" // MySQL driver
)

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
