package usecase

import (
	"context"

	"github.com/yourorg/project/internal/modules/home/domain"
)

// HomeUseCase contains business logic for home page
type HomeUseCase struct {
	repo domain.HomeRepository
}

// NewHomeUseCase creates a new HomeUseCase
func NewHomeUseCase(repo domain.HomeRepository) *HomeUseCase {
	return &HomeUseCase{
		repo: repo,
	}
}

// GetHomeOutput represents the output of GetHome use case
type GetHomeOutput struct {
	Title    string
	Message  string
	Features []string
	Version  string
}

// GetHome executes the GetHome use case
func (uc *HomeUseCase) GetHome(ctx context.Context, locale string) (*GetHomeOutput, error) {
	home, err := uc.repo.GetHome(ctx)
	if err != nil {
		return nil, err
	}

	return &GetHomeOutput{
		Title:    home.Title,
		Message:  home.Message,
		Features: home.Features,
		Version:  home.Version,
	}, nil
}
