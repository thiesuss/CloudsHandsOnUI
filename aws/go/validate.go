import (
    "regexp"  // Für Regular Expressions
    "time"    // Für Zeit- und Datumsfunktionen
)


//validate cat
func validateCat(contractReq ContractReq) bool {
    // Überprüft, ob das Gewicht im gültigen Bereich liegt.
    if contractReq.Weight < 0 || contractReq.Weight > 30 {
        return false
    }

    // Regex für die Überprüfung, ob der String nur Buchstaben enthält.
    nameRegex := regexp.MustCompile(`^[a-zA-Z]+$`)

    // Überprüft, ob CatName nur Buchstaben enthält. Wenn nicht, gib false zurück.
    if !nameRegex.MatchString(contractReq.CatName) {
        return false
    }

    // Überprüft, ob Environment nur Buchstaben enthält. Wenn nicht, gib false zurück.
    if !nameRegex.MatchString(contractReq.Environment) {
        return false
    }

    // Überprüft, ob Breed nur Buchstaben enthält. Wenn nicht, gib false zurück.
    if !nameRegex.MatchString(contractReq.Breed) {
        return false
    }

    // Überprüft, ob Personality nur Buchstaben enthält. Wenn nicht, gib false zurück.
    if !nameRegex.MatchString(contractReq.Personality) {
        return false
    }

    // Wenn alle Überprüfungen bestanden wurden, gib true zurück.
    return true
}


//validate cat
func validateCustomer(customerReq CustomerReq) bool {

	//Ausdruck für email
	emailRegex := regexp.MustCompile(`^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$`)

	//Überprüfung für die Email
	if !emailRegex.MatchString(customerReq.Email){
		return false
	}

    // Regex für die Überprüfung, ob der String nur Buchstaben enthält.
	nameRegex := regexp.MustCompile(`^[a-zA-Z]+$`)

	//Überprüfung für den Vor und Nachnamen	
	if !nameRegex.MatchString(customerReq.FirstName) || !nameRegex.MatchString(customerReq.LastName){
		return false
	}

	parsedBirthDate, err := time.Parse("2006-01-02", customerReq.BirthDate)
	// Das Geburtsdatum hat ein ungültiges Format.
    if err != nil {
        return false
    }

    // Überprüft, ob das Geburtsdatum in der Zukunft liegt.
    if parsedBirthDate.After(time.Now().AddDate(0, 0, -1)) {
        return false
    }

    // Überprüft, ob das Geburtsdatum mehr als 110 Jahre zurückliegt.
    if parsedBirthDate.Before(time.Now().AddDate(-110, 0, 0)) {
        return false
    }

    // Wenn alle Überprüfungen bestanden wurden, gib true zurück.
    return true
}
