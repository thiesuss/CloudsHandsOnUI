package models

type EmployeeRes struct {
	Id string `json:"id"`

	FirstName string `json:"firstName"`

	LastName string `json:"lastName"`

	Address Address `json:"address"`
}
