//go:build wireinject

package main

import (
	"github.com/google/wire"

	"github.com/yourorg/project/internal/bff/interfaces/handlers"
	"github.com/yourorg/project/internal/modules/home/application/usecase"
	"github.com/yourorg/project/internal/modules/home/infrastructure/repository"
	homehandlers "github.com/yourorg/project/internal/modules/home/interfaces/handlers"
)

// InitializeApp creates the application with all dependencies
func InitializeApp() (*App, error) {
	wire.Build(
		// Infrastructure
		repository.NewHomeRepository,

		// Application
		usecase.NewHomeUseCase,

		// Handlers (Module)
		homehandlers.NewHomeHandler,

		// Handlers (BFF)
		handlers.NewBFFHomeHandler,

		// App
		NewApp,
	)

	return nil, nil
}
