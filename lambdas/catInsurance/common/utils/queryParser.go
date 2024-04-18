package utils

import "strconv"

func ParsePageAndPageSize(params map[string]string) (int, int, error) {
	// Default values for page and pageSize
	defaultPage := 1
	defaultPageSize := 100

	// Retrieve pageSize and page from the params map
	pageSizeStr, pageSizeExists := params["pageSize"]
	pageStr, pageExists := params["page"]

	// Set default values if pageSize or page are not provided
	if !pageSizeExists || pageSizeStr == "" {
		pageSizeStr = strconv.Itoa(defaultPageSize)
	}
	if !pageExists || pageStr == "" {
		pageStr = strconv.Itoa(defaultPage)
	}

	// Parse page and pageSize
	page, err := strconv.Atoi(pageStr)
	if err != nil {
		return 0, 0, err
	}
	pageSize, err := strconv.Atoi(pageSizeStr)
	if err != nil {
		return 0, 0, err
	}

	return page, pageSize, nil
}
