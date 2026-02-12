package websocket

import (
	"context"
	"encoding/json"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
	"github.com/insight/high-scores-go/models"
)

const (
	// Time allowed to write a message to the peer
	writeWait = 10 * time.Second

	// Time allowed to read the next pong message from the peer
	pongWait = 60 * time.Second

	// Send pings to peer with this period (must be less than pongWait)
	pingPeriod = (pongWait * 9) / 10

	// Maximum message size allowed from peer
	maxMessageSize = 512 * 1024 // 512KB
)

// Client represents a single WebSocket connection
type Client struct {
	// Unique client ID
	ID string

	// The WebSocket hub
	hub *Hub

	// The WebSocket connection
	conn *websocket.Conn

	// Buffered channel of outbound messages
	send chan []byte

	// Games this client is subscribed to
	subscribedGames map[string]bool

	// Context for cancellation
	ctx    context.Context
	cancel context.CancelFunc
}

// NewClient creates a new Client instance
func NewClient(hub *Hub, conn *websocket.Conn) *Client {
	return &Client{
		ID:              uuid.New().String(),
		hub:             hub,
		conn:            conn,
		send:            make(chan []byte, 256),
		subscribedGames: make(map[string]bool),
	}
}

// ReadPump pumps messages from the WebSocket connection to the hub
func (c *Client) ReadPump() {
	defer func() {
		c.hub.unregister <- c
		c.conn.Close()
	}()

	c.conn.SetReadLimit(maxMessageSize)
	c.conn.SetReadDeadline(time.Now().Add(pongWait))
	c.conn.SetPongHandler(func(string) error {
		c.conn.SetReadDeadline(time.Now().Add(pongWait))
		return nil
	})

	for {
		_, message, err := c.conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("Client %s read error: %v", c.ID, err)
			}
			break
		}

		c.handleMessage(message)
	}
}

// WritePump pumps messages from the hub to the WebSocket connection
func (c *Client) WritePump() {
	ticker := time.NewTicker(pingPeriod)
	defer func() {
		ticker.Stop()
		c.conn.Close()
	}()

	for {
		select {
		case message, ok := <-c.send:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				// The hub closed the channel
				c.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}

			w, err := c.conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}
			w.Write(message)

			// Add queued messages to the current WebSocket message
			n := len(c.send)
			for i := 0; i < n; i++ {
				w.Write([]byte{'\n'})
				w.Write(<-c.send)
			}

			if err := w.Close(); err != nil {
				return
			}

		case <-ticker.C:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := c.conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}

// handleMessage processes incoming messages from the client
func (c *Client) handleMessage(message []byte) {
	var clientMsg models.ClientMessage
	if err := json.Unmarshal(message, &clientMsg); err != nil {
		log.Printf("Client %s: failed to parse message: %v", c.ID, err)
		c.sendError("PARSE_ERROR", "Failed to parse message")
		return
	}

	log.Printf("Client %s: received message type: %s", c.ID, clientMsg.Type)

	switch clientMsg.Type {
	case models.MessageTypeSubscribe:
		c.handleSubscribe(clientMsg.Payload.GameName)
	case models.MessageTypeUnsubscribe:
		c.handleUnsubscribe(clientMsg.Payload.GameName)
	case models.MessageTypePing:
		c.sendPong()
	default:
		log.Printf("Client %s: unknown message type: %s", c.ID, clientMsg.Type)
	}
}

// handleSubscribe subscribes the client to a game
func (c *Client) handleSubscribe(gameName string) {
	if gameName == "" {
		c.sendError("INVALID_GAME", "Game name is required")
		return
	}

	c.subscribedGames[gameName] = true
	c.hub.SubscribeToGame(c, gameName)
	log.Printf("Client %s subscribed to game: %s", c.ID, gameName)
}

// handleUnsubscribe unsubscribes the client from a game
func (c *Client) handleUnsubscribe(gameName string) {
	if gameName == "" {
		return
	}

	delete(c.subscribedGames, gameName)
	c.hub.UnsubscribeFromGame(c, gameName)
	log.Printf("Client %s unsubscribed from game: %s", c.ID, gameName)
}

// sendError sends an error message to the client
func (c *Client) sendError(code, message string) {
	errMsg := models.NewWSMessage(models.MessageTypeError, models.ErrorPayload{
		Code:    code,
		Message: message,
	})

	jsonBytes, err := json.Marshal(errMsg)
	if err != nil {
		log.Printf("Client %s: failed to marshal error: %v", c.ID, err)
		return
	}

	select {
	case c.send <- jsonBytes:
	default:
		log.Printf("Client %s: send buffer full, dropping error message", c.ID)
	}
}

// sendPong sends a pong response to the client
func (c *Client) sendPong() {
	pongMsg := models.NewWSMessage(models.MessageTypePong, nil)
	jsonBytes, err := json.Marshal(pongMsg)
	if err != nil {
		return
	}

	select {
	case c.send <- jsonBytes:
	default:
	}
}

// SendConnectedMessage sends a connection confirmation to the client
func (c *Client) SendConnectedMessage(games []string) {
	connMsg := models.NewWSMessage(models.MessageTypeConnected, models.ConnectedPayload{
		ClientID: c.ID,
		Games:    games,
	})

	jsonBytes, err := json.Marshal(connMsg)
	if err != nil {
		log.Printf("Client %s: failed to marshal connected message: %v", c.ID, err)
		return
	}

	select {
	case c.send <- jsonBytes:
	default:
	}
}
