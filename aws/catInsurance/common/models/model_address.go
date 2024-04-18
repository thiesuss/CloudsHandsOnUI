package models

type Address struct {
	Street string `json:"street"`

	HouseNumber string `json:"houseNumber"`

	ZipCode float32 `json:"zipCode"`

	City string `json:"city"`
}
