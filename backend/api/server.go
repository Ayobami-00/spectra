package api

import (
	"fmt"
	"time"

	db "github.com/Ayobami-00/spectra/backend/db/sqlc"
	"github.com/Ayobami-00/spectra/backend/token"
	"github.com/Ayobami-00/spectra/backend/util"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

// Server serves HTTP requests for our banking service.
type Server struct {
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
	router     *gin.Engine
}

// NewServer creates a new HTTP server and set up routing.
func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	server.setupRouter()
	return server, nil
}

func (server *Server) setupRouter() {
	router := gin.Default()

	router.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders: []string{
			"Origin",
			"Content-Type",
			"Accept",
			"Authorization",
			"X-Requested-With",
			"token",
		},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	authRoutes := router.Group("/").Use(authMiddleware(server.tokenMaker))
	{
		authRoutes.POST("/sessions", server.createChatSession)
		authRoutes.PUT("/sessions/:id", server.updateChatSessionTitle)
		authRoutes.DELETE("/sessions/:id", server.archiveChatSession)
		authRoutes.GET("/sessions/:id", server.getChatSession)
		authRoutes.GET("/sessions", server.listChatSessions)

		authRoutes.POST("/sessions/:id/messages", server.createChatMessage)
		authRoutes.GET("/sessions/:id/messages", server.listChatMessages)
		authRoutes.DELETE("/sessions/:id/messages", server.deleteChatMessages)

		authRoutes.GET("/sessions/ip", server.listChatSessionsByIP)
	}

	publicRoutes := router.Group("/public")
	{
		publicRoutes.POST("/sessions", server.createChatSession)
		publicRoutes.GET("/sessions/:id", server.getChatSession)
		publicRoutes.PUT("/sessions/:id", server.updateChatSessionTitle)
		publicRoutes.DELETE("/sessions/:id", server.archiveChatSession)
		publicRoutes.GET("/sessions", server.listChatSessions)

		publicRoutes.POST("/sessions/:id/messages", server.createChatMessage)
		publicRoutes.GET("/sessions/:id/messages", server.listChatMessages)
		publicRoutes.DELETE("/sessions/:id/messages", server.deleteChatMessages)
		publicRoutes.GET("/sessions/ip", server.listChatSessionsByIP)

		publicRoutes.POST("/waitlist", server.addToWaitlist)
		// publicRoutes.GET("/waitlist", server.getAllWaitlist)
	}

	server.router = router
}

// Start runs the HTTP server on a specific address.
func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}

func maxSessionsReachedResponse() gin.H {
	return gin.H{"error": "You have reached the maximum number of sessions"}
}
