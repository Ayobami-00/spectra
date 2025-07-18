package api

import (
	"net/http"

	db "github.com/Ayobami-00/spectra/backend/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type AddToWaitlistRequest struct {
	Email    string `json:"email"`
	PlanType string `json:"plan_type"`
}

func (server *Server) addToWaitlist(ctx *gin.Context) {
	var req AddToWaitlistRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := db.AddToWaitlistParams{
		ID:       uuid.New(),
		Email:    req.Email,
		PlanType: req.PlanType,
	}

	err := server.store.AddToWaitlist(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"message": "Added to waitlist"})
}

func (server *Server) getAllWaitlist(ctx *gin.Context) {
	waitlist, err := server.store.GetAllWaitlist(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}
	ctx.JSON(http.StatusOK, waitlist)
}
