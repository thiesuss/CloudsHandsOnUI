package models

type CustomerReq struct {
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

// AssertCustomerReqRequired checks if the required fields are not zero-ed
func AssertCustomerReqRequired(obj CustomerReq) error {
	elements := map[string]interface{}{
		"email":                obj.Email,
		"firstName":            obj.FirstName,
		"lastName":             obj.LastName,
		"familyStatus":         obj.FamilyStatus,
		"birthDate":            obj.BirthDate,
		"socialSecurityNumber": obj.SocialSecurityNumber,
		"taxId":                obj.TaxId,
		"address":              obj.Address,
		"bankDetails":          obj.BankDetails,
	}
	for name, el := range elements {
		if isZero := IsZeroValue(el); isZero {
			return &RequiredError{Field: name}
		}
	}

	if err := AssertAddressRequired(obj.Address); err != nil {
		return err
	}
	if err := AssertBankDetailsRequired(obj.BankDetails); err != nil {
		return err
	}
	return nil
}

// AssertCustomerReqConstraints checks if the values respects the defined constraints
func AssertCustomerReqConstraints(obj CustomerReq) error {
	return nil
}
