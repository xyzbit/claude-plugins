package handlers

import (
	"context"

	"connectrpc.com/connect"

	projectv1 "github.com/yourorg/project/api/gen/project/v1"
	"github.com/yourorg/project/internal/modules/home/application/usecase"
)

// HomeHandler handles HomeService RPC requests
type HomeHandler struct {
	homeUseCase *usecase.HomeUseCase
}

// NewHomeHandler creates a new HomeHandler
func NewHomeHandler(homeUseCase *usecase.HomeUseCase) *HomeHandler {
	return &HomeHandler{
		homeUseCase: homeUseCase,
	}
}

// GetHome handles the GetHome RPC
func (h *HomeHandler) GetHome(ctx context.Context, req *connect.Request[projectv1.GetHomeRequest]) (*connect.Response[projectv1.GetHomeResponse], error) {
	output, err := h.homeUseCase.GetHome(ctx, req.Msg.Locale)
	if err != nil {
		return nil, err
	}

	resp := connect.NewResponse(&projectv1.GetHomeResponse{
		Title:    output.Title,
		Message:  output.Message,
		Features: output.Features,
		Version:  output.Version,
	})

	return resp, nil
}
