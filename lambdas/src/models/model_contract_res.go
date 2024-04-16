/*
 * Cat Insurance API
 *
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * API version: 1.0.0
 * Generated by: OpenAPI Generator (https://openapi-generator.tech)
 */

package models

import (
	"errors"
)

type ContractRes struct {
	Id string `json:"id"`

	StartDate string `json:"startDate"`

	EndDate string `json:"endDate"`

	Coverage float32 `json:"coverage"`

	CatName string `json:"catName"`

	Breed string `json:"breed"`

	Color string `json:"color"`

	BirthDate string `json:"birthDate"`

	Neutered bool `json:"neutered"`

	Personality string `json:"personality"`

	Environment string `json:"environment"`

	// In Gramm
	Weight float32 `json:"weight"`

	CustomerId string `json:"customerId"`

	Rate float32 `json:"rate"`
}

// AssertContractResRequired checks if the required fields are not zero-ed
func AssertContractResRequired(obj ContractRes) error {
	elements := map[string]interface{}{
		"id":          obj.Id,
		"startDate":   obj.StartDate,
		"endDate":     obj.EndDate,
		"coverage":    obj.Coverage,
		"catName":     obj.CatName,
		"breed":       obj.Breed,
		"color":       obj.Color,
		"birthDate":   obj.BirthDate,
		"neutered":    obj.Neutered,
		"personality": obj.Personality,
		"environment": obj.Environment,
		"weight":      obj.Weight,
		"customerId":  obj.CustomerId,
		"rate":        obj.Rate,
	}
	for name, el := range elements {
		if isZero := IsZeroValue(el); isZero {
			return &RequiredError{Field: name}
		}
	}

	return nil
}

// AssertContractResConstraints checks if the values respects the defined constraints
func AssertContractResConstraints(obj ContractRes) error {
	if obj.Coverage < 1 {
		return &ParsingError{Err: errors.New(errMsgMinValueConstraint)}
	}
	if obj.Weight < 50 {
		return &ParsingError{Err: errors.New(errMsgMinValueConstraint)}
	}
	return nil
}
