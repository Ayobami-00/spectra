package api

import (
	"fmt"
	"net/http"
	"strings"
	"time"

	db "github.com/Ayobami-00/spectra/backend/db/sqlc"
	"github.com/Ayobami-00/spectra/backend/token"
	"github.com/Ayobami-00/spectra/backend/util"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

type chatSessionResponse struct {
	ID            uuid.UUID `json:"id"`
	UserID        uuid.UUID `json:"user_id"`
	Title         string    `json:"title"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
	LastMessageAt time.Time `json:"last_message_at"`
	IsArchived    bool      `json:"is_archived"`
	IsPublic      bool      `json:"is_public"`
}

func newChatSessionResponse(session db.ChatSession) chatSessionResponse {
	return chatSessionResponse{
		ID:            session.ID,
		UserID:        session.UserID,
		Title:         session.Title.String,
		CreatedAt:     session.CreatedAt,
		UpdatedAt:     session.UpdatedAt,
		LastMessageAt: session.LastMessageAt,
		IsArchived:    session.IsArchived,
		IsPublic:      session.IsPublic,
	}
}

type createChatSessionRequest struct {
	IsPublic bool `json:"is_public"`
}

func (server *Server) createChatSession(ctx *gin.Context) {
	var req createChatSessionRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	var userID uuid.UUID
	clientIP := server.getOriginalIP(ctx)

	count, err := server.store.ListUserChatSessionsByIP(ctx, clientIP)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	fmt.Println("count", count)

	if len(count) >= int(util.MaxSessionsPerIP) {
		ctx.JSON(http.StatusBadRequest, maxSessionsReachedResponse())
		return
	}

	if !req.IsPublic {
		authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
		userID = uuid.MustParse(authPayload.UserID)
	} else {
		userID = uuid.New()
	}

	now := time.Now()
	arg := db.CreateChatSessionParams{
		ID:        uuid.New(),
		UserID:    userID,
		CreatedAt: now,
		IsPublic:  req.IsPublic,
		IpAddress: clientIP,
	}

	session, err := server.store.CreateChatSession(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, newChatSessionResponse(session))
}

func (server *Server) getChatSession(ctx *gin.Context) {
	sessionID, err := uuid.Parse(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	// Try to get public session first
	session, err := server.store.GetPublicChatSession(ctx, sessionID)
	if err == nil {
		ctx.JSON(http.StatusOK, newChatSessionResponse(session))
		return
	}

	// If not public, require authentication
	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	session, err = server.store.GetChatSession(ctx, db.GetChatSessionParams{
		ID:     sessionID,
		UserID: userID,
	})
	if err != nil {
		ctx.JSON(http.StatusNotFound, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, newChatSessionResponse(session))
}

func (server *Server) listChatSessions(ctx *gin.Context) {
	isPublic := ctx.Query("public") == "true"

	if isPublic {
		sessions, err := server.store.ListPublicChatSessions(ctx)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, errorResponse(err))
			return
		}

		response := make([]chatSessionResponse, len(sessions))
		for i, session := range sessions {
			response[i] = newChatSessionResponse(session)
		}

		ctx.JSON(http.StatusOK, response)
		return
	}

	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	sessions, err := server.store.ListUserChatSessions(ctx, userID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	response := make([]chatSessionResponse, len(sessions))
	for i, session := range sessions {
		response[i] = newChatSessionResponse(session)
	}

	ctx.JSON(http.StatusOK, response)
}

type updateChatSessionTitleRequest struct {
	Title string `json:"title" binding:"required"`
}

func (server *Server) updateChatSessionTitle(ctx *gin.Context) {
	var req updateChatSessionTitleRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	sessionID, err := uuid.Parse(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	arg := db.UpdateChatSessionTitleParams{
		Title:  pgtype.Text{String: req.Title, Valid: req.Title != ""},
		ID:     sessionID,
		UserID: userID,
	}

	session, err := server.store.UpdateChatSessionTitle(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, newChatSessionResponse(session))
}

func (server *Server) archiveChatSession(ctx *gin.Context) {
	sessionID, err := uuid.Parse(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	authPayload := ctx.MustGet(authorizationPayloadKey).(*token.Payload)
	userID := uuid.MustParse(authPayload.UserID)

	arg := db.ArchiveChatSessionParams{
		ID:     sessionID,
		UserID: userID,
	}

	session, err := server.store.ArchiveChatSession(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, newChatSessionResponse(session))
}

func (server *Server) getOriginalIP(ctx *gin.Context) string {
	// Check X-Forwarded-For header first
	if xForwardedFor := ctx.GetHeader("X-Forwarded-For"); xForwardedFor != "" {
		// Split IPs and get the first one (original client)
		ips := strings.Split(xForwardedFor, ",")
		if len(ips) > 0 {
			return strings.TrimSpace(ips[0])
		}
	}
	// Fallback to regular ClientIP
	return ctx.ClientIP()
}

func (server *Server) listChatSessionsByIP(ctx *gin.Context) {
	clientIP := server.getOriginalIP(ctx)
	fmt.Println("Original clientIP:", clientIP)

	sessions, err := server.store.ListUserChatSessionsByIP(ctx, clientIP)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, len(sessions))
}
