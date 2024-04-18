package models

type EmployeeReq struct {
	FirstName string `json:"firstName"`

	LastName string `json:"lastName"`

	Address Address `json:"address"`
}
