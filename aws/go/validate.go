package openapi

import (
	"regexp" // Für Regular Expressions
	"time"   // Für Zeit- und Datumsfunktionen
)

// validate cat
func validateCat(contractReq ContractReq) bool {
	// Überprüft, ob das Gewicht im gültigen Bereich liegt.
	if contractReq.Weight < 5000 {
		return false
	}

	// Regex für die Überprüfung, ob der String nur Buchstaben enthält.
	nameRegex := regexp.MustCompile(`^[A-Za-z]+(?:\s[A-Za-z]+)*$`)

	// Überprüft, ob CatName, Breed, Color, Personality und Environment nur Buchstaben enthalten. Wenn nicht, gib false zurück.
	if !nameRegex.MatchString(contractReq.CatName) ||
		!nameRegex.MatchString(contractReq.Breed) ||
		!nameRegex.MatchString(contractReq.Color) ||
		!nameRegex.MatchString(contractReq.Personality) ||
		!nameRegex.MatchString(contractReq.Environment) {
		return false
	}

	// Überprüft, ob die Start- und Enddaten ein gültiges Format haben.
	if _, err := time.Parse("2006-01-02", contractReq.StartDate); err != nil {
		return false
	}
	if _, err := time.Parse("2006-01-02", contractReq.EndDate); err != nil {
		return false
	}

	// Überprüft, ob das Startdatum nicht in der Vergangenheit liegt.
	parsedStartDate, _ := time.Parse("2006-01-02", contractReq.StartDate)
	if parsedStartDate.Before(time.Now()) {
		return false
	}

	// Überprüft, ob das Enddatum nicht vor dem Startdatum liegt.
	parsedEndDate, _ := time.Parse("2006-01-02", contractReq.EndDate)
	if parsedEndDate.Before(parsedStartDate) {
		return false
	}

	// Wenn alle Überprüfungen bestanden wurden, gib true zurück.
	return true
}

// validate cat
func validateCustomer(customerReq CustomerReq) bool {

	//Ausdruck für email
	emailRegex := regexp.MustCompile(`^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$`)

	//Überprüfung für die Email
	if !emailRegex.MatchString(customerReq.Email) {
		return false
	}

	// Regex für die Überprüfung, ob der String nur Buchstaben enthält.
	nameRegex := regexp.MustCompile(`^[A-Za-z]+(?:\s[A-Za-z]+)*$`)

	//Überprüfung für den Vor und Nachnamen
	if !nameRegex.MatchString(customerReq.FirstName) || !nameRegex.MatchString(customerReq.LastName) {
		return false
	}

	parsedBirthDate, err := time.Parse("2006-01-02", customerReq.BirthDate)
	// Das Geburtsdatum hat ein ungültiges Format.
	if err != nil {
		return false
	}

	// Überprüft, ob BirthDate ein gültiges Datum ist und nicht in der Zukunft oder mehr als 110 Jahre in der Vergangenheit liegt.
	parsedBirthDate, err = time.Parse("2006-01-02", customerReq.BirthDate)
	if err != nil || parsedBirthDate.After(time.Now().AddDate(0, 0, -1)) || parsedBirthDate.Before(time.Now().AddDate(-110, 0, 0)) {
		return false
	}

	// Überprüft, ob SocialSecurityNumber und TaxId dem Muster entsprechen.
	if !regexp.MustCompile(`^[0-9]{11}$`).MatchString(customerReq.SocialSecurityNumber) ||
		!regexp.MustCompile(`^[0-9]{11}$`).MatchString(customerReq.TaxId) {
		return false
	}

	// Überprüft, ob Street, City und HouseNumber dem Muster entsprechen.
	if !nameRegex.MatchString(customerReq.Address.Street) ||
		!nameRegex.MatchString(customerReq.Address.City) ||
		!regexp.MustCompile(`^[0-9]{1,3}[a-z]?$`).MatchString(customerReq.Address.HouseNumber) {
		return false
	}

	// Überprüft, ob ZipCode im gültigen Bereich liegt.
	if customerReq.Address.ZipCode < 0 || customerReq.Address.ZipCode > 99999 {
		return false
	}

	// Überprüft, ob IBAN und BIC den entsprechenden Regex-Mustern entsprechen.
	if !regexp.MustCompile(`^[A-Z]{2}[0-9]{2}[A-Z]{4}[0-9]{7}([A-Z0-9]{0,16})?$`).MatchString(customerReq.BankDetails.Iban) ||
		!regexp.MustCompile(`^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`).MatchString(customerReq.BankDetails.Bic) {
		return false
	}

	// Überprüft, ob Name dem Muster entspricht.
	if !nameRegex.MatchString(customerReq.BankDetails.Name) {
		return false
	}

	// Wenn alle Überprüfungen bestanden wurden, gib true zurück.
	return true
}
