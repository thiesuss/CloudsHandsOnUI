package openapi

import (
	"regexp" // Für Regular Expressions
	"strings"
	"time" // Für Zeit- und Datumsfunktionen
)

// validate cat
func validateCat(contractReq ContractReq) string {
	// Überprüft, ob das Gewicht im gültigen Bereich liegt.
	if contractReq.Weight < 5000 {
		return "weight is not valid"
	}

	// Regex für die Überprüfung, ob der String nur Buchstaben enthält.
	nameRegex := regexp.MustCompile(`^[A-Za-zßÄÖÜäöü]+(?:\s[A-Za-zßÄÖÜäöü]+)*$`)

	// Überprüft, ob CatName, Breed, Color, Personality und Environment nur Buchstaben enthalten. Wenn nicht, gib false zurück.
	if !nameRegex.MatchString(contractReq.CatName) {
		return "name is not valid"
	}

	if !nameRegex.MatchString(contractReq.Breed) {
		return "breed is not valid"
	}

	if !nameRegex.MatchString(contractReq.Color) {
		return "color is not valid"
	}

	if !nameRegex.MatchString(contractReq.Personality) {
		return "personality is not valid"
	}

	if !nameRegex.MatchString(contractReq.Environment) {
		return "environment is not valid"
	}

	// Überprüft, ob die Start- und Enddaten ein gültiges Format haben.
	if _, err := time.Parse("2006-01-02", contractReq.StartDate); err != nil {
		return "start date is not valid"
	}
	if _, err := time.Parse("2006-01-02", contractReq.EndDate); err != nil {
		return "end date is not valid"
	}

	// Überprüft, ob das Startdatum nicht in der Vergangenheit liegt.
	parsedStartDate, _ := time.Parse("2006-01-02", contractReq.StartDate)
	if parsedStartDate.Before(time.Now()) {
		return "start date is in the past"
	}

	// Überprüft, ob das Enddatum nicht vor dem Startdatum liegt.
	parsedEndDate, _ := time.Parse("2006-01-02", contractReq.EndDate)
	if parsedEndDate.Before(parsedStartDate) {
		return "end date is before start date"
	}

	if strings.ToLower(contractReq.Personality) == "besonders verspielt" {
		return "keine Versicherung für besonders verspielte Katzen möglich"
	}

	// Wenn alle Überprüfungen bestanden wurden, gib true zurück.
	return "valid"
}

// validate cat
func validateCustomer(customerReq CustomerReq) string {

	//Ausdruck für email
	emailRegex := regexp.MustCompile(`^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$`)

	//Überprüfung für die Email
	if !emailRegex.MatchString(customerReq.Email) {
		return "email is not valid"
	}

	// Regex für die Überprüfung, ob der String nur Buchstaben enthält.
	nameRegex := regexp.MustCompile(`^[A-Za-zßÄÖÜäöü]+(?:\s[A-Za-zßÄÖÜäöü]+)*$`)

	//Überprüfung für den Vor und Nachnamen
	if !nameRegex.MatchString(customerReq.FirstName) || !nameRegex.MatchString(customerReq.LastName) {
		return "name is not valid"
	}

	// Überprüft, ob BirthDate ein gültiges Datum ist
	parsedBirthDate, err := time.Parse("2006-01-02", customerReq.BirthDate)
	if err != nil {
		return "birthDate is not valid"
	}

	// Überprüft, ob das Geburtsdatum in der Zukunft liegt
	if parsedBirthDate.After(time.Now()) {
		return "birthDate cannot be in the future"
	}

	age := int(time.Since(parsedBirthDate).Hours() / 24 / 365)

	// Überprüft, ob das Alter zwischen 18 und 110 Jahren liegt
	if age < 18 || age > 110 {
		return "age must be between 18 and 110 years"
	}

	// Überprüft, ob SocialSecurityNumber und TaxId dem Muster entsprechen.
	if !regexp.MustCompile(`^[0-9]{12}$`).MatchString(customerReq.SocialSecurityNumber) {
		return "socialSecurityNumber is not valid"
	}

	if !regexp.MustCompile(`^[0-9]{11}$`).MatchString(customerReq.TaxId) {
		return "taxId is not valid"
	}

	// Überprüft, ob Street, City und HouseNumber dem Muster entsprechen.
	if !nameRegex.MatchString(customerReq.Address.Street) {
		return "street is not valid"
	}

	if !nameRegex.MatchString(customerReq.Address.City) {
		return "city is not valid"
	}

	if !regexp.MustCompile(`^[0-9]{1,3}[a-z]?$`).MatchString(customerReq.Address.HouseNumber) {
		return "houseNumber is not valid"
	}

	// Überprüft, ob ZipCode im gültigen Bereich liegt.
	if customerReq.Address.ZipCode < 0 || customerReq.Address.ZipCode > 99999 {
		return "zipCode is not valid"
	}

	// Überprüft, ob IBAN und BIC den entsprechenden Regex-Mustern entsprechen.
	if !regexp.MustCompile(`^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$`).MatchString(customerReq.BankDetails.Iban) {
		return "bank iban is not valid"
	}

	if !regexp.MustCompile(`^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`).MatchString(customerReq.BankDetails.Bic) {
		return "bank bic is not valid"
	}
	// Überprüft, ob Name dem Muster entspricht.
	if !nameRegex.MatchString(customerReq.BankDetails.Name) {
		return "bank name is not valid"
	}

	// Wenn alle Überprüfungen bestanden wurden, gib true zurück.
	return "valid"
}
