package models

type CustomerRes struct {
	Id string `json:"id"`

	Email string `json:"email"`

	FirstName string `json:"firstName"`

	LastName string `json:"lastName"`

	Title string `json:"title,omitempty"`

	FamilyStatus string `json:"familyStatus"`

	BirthDate string `json:"birthDate"`

	SocialSecurityNumber string `json:"socialSecurityNumber"`

	TaxId string `json:"taxId"`

	Address Address `json:"address"`

	BankDetails BankDetails `json:"bankDetails"`
}
