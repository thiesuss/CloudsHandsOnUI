package models

type BankDetails struct {
	Iban string `json:"iban"`

	Bic string `json:"bic"`

	Name string `json:"name"`
}
