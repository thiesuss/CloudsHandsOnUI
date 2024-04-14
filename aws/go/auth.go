package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cognitoidentityprovider"
	"github.com/aws/aws-sdk-go/service/cognitoidentityprovider/cognitoidentityprovideriface"
)

// Cognito client
var cognitoClient cognitoidentityprovideriface.CognitoIdentityProviderAPI

func init() {
	// Initialize AWS session
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	// Create Cognito client
	cognitoClient = cognitoidentityprovider.New(sess)
}

// Struct for login request
type LoginRequest struct {
	Username string `json:"username"`
	Verifier string `json:"verifier"`
}

// Struct for login response
type LoginResponse struct {
	AccessToken  string `json:"access_token"`
	IdToken      string `json:"id_token"`
	RefreshToken string `json:"refresh_token"`
}

// Handler for user login
func LoginHandler(w http.ResponseWriter, r *http.Request) {
	// Parse request body to get username and verifier
	var req LoginRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Authenticate user with Cognito using SRP
	authParams := map[string]*string{
		"USERNAME": aws.String(req.Username),
		"SRP_A":    aws.String(req.Verifier),
	}
	authInput := &cognitoidentityprovider.InitiateAuthInput{
		AuthFlow:       aws.String(cognitoidentityprovider.AuthFlowTypeCustomAuth),
		AuthParameters: authParams,
		ClientId:       aws.String(os.Getenv("COGNITO_CLIENT_ID")),
	}
	authOutput, err := cognitoClient.InitiateAuth(authInput)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error authenticating user: %v", err), http.StatusInternalServerError)
		return
	}

	// Authentication successful, return tokens to client
	resp := LoginResponse{
		AccessToken:  *authOutput.AuthenticationResult.AccessToken,
		IdToken:      *authOutput.AuthenticationResult.IdToken,
		RefreshToken: *authOutput.AuthenticationResult.RefreshToken,
	}
	json.NewEncoder(w).Encode(resp)
}
