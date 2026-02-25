package domain

import "context"

// HomeRepository defines the interface for home data access
type HomeRepository interface {
	// GetHome retrieves the home page data
	GetHome(ctx context.Context) (*Home, error)
}
