package main

import (
	"log"
	"os"
	"strings"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/insight/high-scores-go/handlers"
	"github.com/insight/high-scores-go/models"
	"github.com/insight/high-scores-go/repository"
	"github.com/insight/high-scores-go/service"
	"github.com/insight/high-scores-go/websocket"
)

// Version represents the application version following Semantic Versioning 2.0.0
const Version = "0.0.1-SNAPSHOT"

func main() {
	// Get database path from environment or use default
	dbPath := os.Getenv("DB_PATH")
	if dbPath == "" {
		dbPath = "highscores.db"
	}

	// Initialize database
	db, err := models.InitDB(dbPath)
	if err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}

	// Seed sample data
	if err := models.SeedData(db); err != nil {
		log.Printf("Warning: Failed to seed data: %v", err)
	}

	// Initialize WebSocket hub
	hub := websocket.NewHub()
	go hub.Run()

	// Initialize repository
	scoreRepo := repository.NewGameScoreRepository(db)

	// Initialize notification service with the hub
	notifier := service.NewWebSocketNotificationService(hub)

	// Initialize service with notification capability
	scoreService := service.NewGameScoreService(scoreRepo, notifier)

	// Initialize handlers
	scoreHandler := handlers.NewScoreHandler(scoreService)
	wsHandler := handlers.NewWebSocketHandler(hub, scoreService)

	// Setup Gin router
	router := gin.Default()

	// Configure CORS — origins from CORS_ALLOWED_ORIGINS env var (comma-separated), with dev defaults
	allowedOrigins := os.Getenv("CORS_ALLOWED_ORIGINS")
	if allowedOrigins == "" {
		allowedOrigins = "http://localhost:3000,http://localhost:5173,http://127.0.0.1:3000,http://127.0.0.1:5173"
	}
	config := cors.Config{
		AllowOrigins:     strings.Split(allowedOrigins, ","),
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}
	router.Use(cors.New(config))

	// Health check endpoints
	router.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message":  "Welcome to High Scores API (Go)",
			"version":  "1.0.0",
			"features": []string{"REST API", "WebSocket Real-time Updates"},
		})
	})

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":  "UP",
			"service": "high-scores-go",
		})
	})

	router.HEAD("/health", func(c *gin.Context) {
		c.Status(200)
	})

	router.GET("/health/live", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "UP"})
	})

	router.GET("/health/ready", func(c *gin.Context) {
		// Check database connectivity
		sqlDB, err := db.DB()
		if err != nil {
			c.JSON(503, gin.H{"status": "DOWN", "reason": "database connection error"})
			return
		}
		if err := sqlDB.Ping(); err != nil {
			c.JSON(503, gin.H{"status": "DOWN", "reason": "database ping failed"})
			return
		}
		c.JSON(200, gin.H{"status": "UP"})
	})

	// WebSocket endpoint
	router.GET("/ws", wsHandler.HandleWebSocket)
	router.GET("/ws/stats", wsHandler.GetWebSocketStats)

	// API routes
	api := router.Group("/api/scores")
	{
		// Submit a new score
		api.POST("/submit", scoreHandler.SubmitScore)

		// Get all available games
		api.GET("/games", scoreHandler.GetAllGames)

		// Get all players
		api.GET("/players", scoreHandler.GetAllPlayers)

		// Get top scores for a game
		api.GET("/game/:gameName/top", scoreHandler.GetTopScoresForGame)

		// Get all scores for a game with pagination
		api.GET("/game/:gameName", scoreHandler.GetGameScores)

		// Get game statistics
		api.GET("/game/:gameName/stats", scoreHandler.GetGameStats)

		// Get scores for a specific player in a game
		api.GET("/game/:gameName/player/:playerName", scoreHandler.GetPlayerGameScores)

		// Get player's high score for a game
		api.GET("/game/:gameName/player/:playerName/high", scoreHandler.GetPlayerHighScore)

		// Get all scores for a player
		api.GET("/player/:playerName", scoreHandler.GetPlayerScores)

		// Get player statistics
		api.GET("/player/:playerName/stats", scoreHandler.GetPlayerStats)
	}

	// Get port from environment variable or default to 8081
	port := os.Getenv("PORT")
	if port == "" {
		port = "8081"
	}

	log.Printf("Starting High Scores Go Server on port %s", port)
	log.Printf("WebSocket endpoint: ws://localhost:%s/ws", port)
	log.Printf("REST API endpoint: http://localhost:%s/api/scores", port)

	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
