package api

import (
	"fmt"
	"net/http"
	"time"

	db "github.com/Ayobami-00/spectra/backend/db/sqlc"
	"github.com/Ayobami-00/spectra/backend/token"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type chatMessageResponse struct {
	ID        uuid.UUID `json:"id"`
	SessionID uuid.UUID `json:"session_id"`
	Role      string    `json:"role"`
	Content   string    `json:"content"`
	CreatedAt time.Time `json:"created_at"`
}

func newChatMessageResponse(message db.ChatMessage) chatMessageResponse {
	return chatMessageResponse{
		ID:        message.ID,
		SessionID: message.SessionID,
		Role:      message.Role,
		Content:   message.Content,
		CreatedAt: message.CreatedAt,
	}
}

type createChatMessageRequest struct {
	Content string `json:"content" binding:"required"`
	Role    string `json:"role" binding:"required,oneof=user assistant system"`
}

func (server *Server) createChatMessage(ctx *gin.Context) {
	var req createChatMessageRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	sessionID, err := uuid.Parse(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	// Check if session is public
	publicSession, err := server.store.GetPublicChatSession(ctx, sessionID)

	fmt.Println("publicSession", err)

	if err == nil && publicSession.IsPublic {
		// Allow message creation for public sessions
		arg := db.CreateChatMessageParams{
			ID:        uuid.New(),
			SessionID: sessionID,
			Role:      req.Role,
			Content:   req.Content,
			CreatedAt: time.Now(),
		}

		message, err := server.store.CreateChatMessage(ctx, arg)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, errorResponse(err))
			return
		}

		ctx.JSON(http.StatusOK, newChatMessageResponse(message))
		return
	}

	// If not public, require authentication
	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	// Verify session belongs to user
	_, err = server.store.GetChatSession(ctx, db.GetChatSessionParams{
		ID:     sessionID,
		UserID: userID,
	})
	if err != nil {
		ctx.JSON(http.StatusNotFound, errorResponse(err))
		return
	}

	arg := db.CreateChatMessageParams{
		ID:        uuid.New(),
		SessionID: sessionID,
		Role:      req.Role,
		Content:   req.Content,
		CreatedAt: time.Now(),
	}

	message, err := server.store.CreateChatMessage(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, newChatMessageResponse(message))
}

func (server *Server) getChatMessage(ctx *gin.Context) {
	messageID, err := uuid.Parse(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	// Try to get message as public first
	message, err := server.store.GetPublicChatMessage(ctx, messageID)
	if err == nil {
		ctx.JSON(http.StatusOK, newChatMessageResponse(message))
		return
	}

	// If not public, require authentication
	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	message, err = server.store.GetChatMessage(ctx, db.GetChatMessageParams{
		ID:     messageID,
		UserID: userID,
	})
	if err != nil {
		ctx.JSON(http.StatusNotFound, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, newChatMessageResponse(message))
}

func (server *Server) listChatMessages(ctx *gin.Context) {
	sessionID, err := uuid.Parse(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	// Try to get messages as public first
	messages, err := server.store.ListPublicSessionMessages(ctx, sessionID)
	if err == nil {
		response := make([]chatMessageResponse, len(messages))
		for i, msg := range messages {
			response[i] = newChatMessageResponse(msg)
		}
		ctx.JSON(http.StatusOK, response)
		return
	}

	// If not public, require authentication
	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	messages, err = server.store.ListSessionMessages(ctx, db.ListSessionMessagesParams{
		SessionID: sessionID,
		UserID:    userID,
	})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	response := make([]chatMessageResponse, len(messages))
	for i, msg := range messages {
		response[i] = newChatMessageResponse(msg)
	}

	// No need to sort since ListSessionMessages and ListPublicSessionMessages
	// already return messages ordered by created_at ASC

	ctx.JSON(http.StatusOK, response)
}

func (server *Server) deleteChatMessages(ctx *gin.Context) {
	sessionID, err := uuid.Parse(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	// Check if session is public
	publicSession, err := server.store.GetPublicChatSession(ctx, sessionID)
	if err == nil && publicSession.IsPublic {
		err = server.store.DeletePublicSessionMessages(ctx, sessionID)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusOK, gin.H{"status": "messages deleted"})
		return
	}

	// If not public, require authentication
	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	err = server.store.DeleteSessionMessages(ctx, db.DeleteSessionMessagesParams{
		SessionID: sessionID,
		UserID:    userID,
	})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"status": "messages deleted"})
}
