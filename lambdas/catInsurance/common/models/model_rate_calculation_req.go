package models

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
