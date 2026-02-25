package domain

// Home represents the home page entity
type Home struct {
	Title    string
	Message  string
	Features []string
	Version  string
}

// NewHome creates a new Home entity
func NewHome(title, message, version string, features []string) *Home {
	return &Home{
		Title:    title,
		Message:  message,
		Features: features,
		Version:  version,
	}
}
