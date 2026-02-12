package handlers

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/insight/high-scores-go/service"
	ws "github.com/insight/high-scores-go/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		// Allow connections from any origin in development
		// In production, this should be restricted to specific origins
		origin := r.Header.Get("Origin")
		allowedOrigins := []string{
			"http://localhost:3000",
			"http://localhost:5173",
			"http://127.0.0.1:3000",
			"http://127.0.0.1:5173",
		}

		for _, allowed := range allowedOrigins {
			if origin == allowed {
				return true
			}
		}

		// Allow if no origin (e.g., from same origin or tools like wscat)
		if origin == "" {
			return true
		}

		log.Printf("WebSocket connection rejected from origin: %s", origin)
		return false
	},
}

// WebSocketHandler handles WebSocket connections
type WebSocketHandler struct {
	hub          *ws.Hub
	scoreService *service.GameScoreService
}

// NewWebSocketHandler creates a new WebSocketHandler
func NewWebSocketHandler(hub *ws.Hub, scoreService *service.GameScoreService) *WebSocketHandler {
	return &WebSocketHandler{
		hub:          hub,
		scoreService: scoreService,
	}
}

// HandleWebSocket handles the WebSocket upgrade and serves the connection
func (h *WebSocketHandler) HandleWebSocket(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Printf("Failed to upgrade WebSocket connection: %v", err)
		return
	}

	client := ws.NewClient(h.hub, conn)

	// Register client with the hub
	h.hub.Register(client)

	// Get available games to send to the client
	games, err := h.scoreService.GetAllGames()
	if err != nil {
		log.Printf("Failed to get games for new client: %v", err)
		games = []string{}
	}

	// Send connected message with available games
	client.SendConnectedMessage(games)

	// Start the client's read and write pumps in goroutines
	go client.WritePump()
	go client.ReadPump()
}

// GetWebSocketStats returns WebSocket connection statistics
func (h *WebSocketHandler) GetWebSocketStats(c *gin.Context) {
	stats := gin.H{
		"connectedClients": h.hub.GetClientCount(),
		"activeGames":      h.hub.GetConnectedGames(),
	}

	c.JSON(http.StatusOK, stats)
}
