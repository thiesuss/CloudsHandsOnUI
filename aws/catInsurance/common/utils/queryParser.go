package utils

import (
	"catInsurance/common/models"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
)

func ParsePageAndPageSize(params map[string]string) (int, int, error) {
	// Default values for page and pageSize
	defaultPage := 1
	defaultPageSize := 100

	// Retrieve pageSize and page from the params map
	pageSizeStr, pageSizeExists := params["pageSize"]
	pageStr, pageExists := params["page"]

	// Set default values if pageSize or page are not provided
	if !pageSizeExists || pageSizeStr == "" {
		pageSizeStr = strconv.Itoa(defaultPageSize)
	}
	if !pageExists || pageStr == "" {
		pageStr = strconv.Itoa(defaultPage)
	}

	// Parse page and pageSize
	page, err := strconv.Atoi(pageStr)
	if err != nil {
		return 0, 0, err
	}
	pageSize, err := strconv.Atoi(pageSizeStr)
	if err != nil {
		return 0, 0, err
	}

	return page, pageSize, nil
}

// Annahme: models.CustomerReq ist eine benutzerdefinierte Struktur, die dein customerReq repräsentiert

func ParseCustomerReqAndCustomerID(params map[string]string) (int, models.CustomerReq, error) {
	// Überprüfe, ob customerId im Request-Parameter vorhanden ist
	customerIDStr, ok := params["customerId"]
	if !ok {
		return 0, models.CustomerReq{}, errors.New("customerId not found in request parameters")
	}

	// Extrahiere und konvertiere die customerId in einen Integer
	customerID, err := strconv.Atoi(customerIDStr)
	if err != nil {
		return 0, models.CustomerReq{}, fmt.Errorf("failed to parse customerId: %v", err)
	}

	// Überprüfe, ob customerReq im Request-Parameter vorhanden ist
	customerReqJSON, ok := params["customerReq"]
	if !ok {
		return 0, models.CustomerReq{}, errors.New("customerReq not found in request parameters")
	}

	// Dekodiere das customerReq JSON
	var customerReq models.CustomerReq
	err = json.Unmarshal([]byte(customerReqJSON), &customerReq)
	if err != nil {
		return 0, models.CustomerReq{}, fmt.Errorf("failed to parse customerReq JSON: %v", err)
	}

	return customerID, customerReq, nil
}
