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
	"errors"
)



type RateCalculationReq struct {

	Coverage float32 `json:"coverage"`

	Breed string `json:"breed"`

	Color string `json:"color"`

	BirthDate string `json:"birthDate"`

	Neutered bool `json:"neutered"`

	Personality string `json:"personality"`

	Environment string `json:"environment"`

	// In Gramm
	Weight float32 `json:"weight"`

	ZipCode float32 `json:"zipCode"`
}

// AssertRateCalculationReqRequired checks if the required fields are not zero-ed
func AssertRateCalculationReqRequired(obj RateCalculationReq) error {
	elements := map[string]interface{}{
		"coverage": obj.Coverage,
		"breed": obj.Breed,
		"color": obj.Color,
		"birthDate": obj.BirthDate,
		"neutered": obj.Neutered,
		"personality": obj.Personality,
		"environment": obj.Environment,
		"weight": obj.Weight,
		"zipCode": obj.ZipCode,
	}
	for name, el := range elements {
		if isZero := IsZeroValue(el); isZero {
			return &RequiredError{Field: name}
		}
	}

	return nil
}

// AssertRateCalculationReqConstraints checks if the values respects the defined constraints
func AssertRateCalculationReqConstraints(obj RateCalculationReq) error {
	if obj.Coverage < 1 {
		return &ParsingError{Err: errors.New(errMsgMinValueConstraint)}
	}
	if obj.Weight < 50 {
		return &ParsingError{Err: errors.New(errMsgMinValueConstraint)}
	}
	if obj.ZipCode < 0 {
		return &ParsingError{Err: errors.New(errMsgMinValueConstraint)}
	}
	if obj.ZipCode > 99999 {
		return &ParsingError{Err: errors.New(errMsgMaxValueConstraint)}
	}
	return nil
}
