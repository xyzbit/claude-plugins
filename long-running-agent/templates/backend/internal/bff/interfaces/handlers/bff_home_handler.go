package handlers

import (
	"context"

	"connectrpc.com/connect"

	projectv1 "github.com/yourorg/project/api/gen/project/v1"
	"github.com/yourorg/project/internal/modules/home/application/usecase"
)

// BFHHomeHandler handles BFF Home RPC requests
type BFFHomeHandler struct {
	homeUseCase *usecase.HomeUseCase
}

// NewBFFHomeHandler creates a new BFFHomeHandler
func NewBFFHomeHandler(homeUseCase *usecase.HomeUseCase) *BFFHomeHandler {
	return &BFFHomeHandler{
		homeUseCase: homeUseCase,
	}
}

// GetHome handles the GetHome RPC for BFF
func (h *BFFHomeHandler) GetHome(ctx context.Context, req *connect.Request[projectv1.GetHomeRequest]) (*connect.Response[projectv1.GetHomeResponse], error) {
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
