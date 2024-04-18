package models

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
