package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/yourorg/project/api/gen/project/v1/v1connect"
	"github.com/yourorg/project/internal/bff/interfaces/handlers"
	"github.com/yourorg/project/internal/modules/home/application/usecase"
	homehandlers "github.com/yourorg/project/internal/modules/home/interfaces/handlers"
	"github.com/yourorg/project/internal/modules/home/infrastructure/repository"
)

type App struct {
	BFFHandler    *handlers.BFFHomeHandler
	HomeHandler   *homehandlers.HomeHandler
}

func main() {
	// For demonstration, we'll create the app manually
	// In production, use wire.Generate to create the App
	repo := repository.NewHomeRepository()
	homeUseCase := usecase.NewHomeUseCase(repo)
	homeHandler := homehandlers.NewHomeHandler(homeUseCase)
	bffHandler := handlers.NewBFFHomeHandler(homeUseCase)

	app := &App{
		BFFHandler:  bffHandler,
		HomeHandler: homeHandler,
	}

	// Register BFF handlers with Connect RPC
	mux := http.NewServeMux()
	path, handler := v1connect.NewHomeServiceHandler(app.BFFHandler)
	mux.Handle(path, handler)

	// Start server
	fmt.Println("Starting server on :8081")
	log.Fatal(http.ListenAndServe(":8081", mux))
}

// Compile-time check that BFFHomeHandler implements HomeServiceHandler
var _ v1connect.HomeServiceHandler = (*handlers.BFFHomeHandler)(nil)
