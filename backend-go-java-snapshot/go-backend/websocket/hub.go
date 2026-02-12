package websocket

import (
	"log"
	"sync"
)

// Hub maintains the set of active clients and broadcasts messages to them
type Hub struct {
	// Registered clients
	clients map[*Client]bool

	// Clients subscribed to specific games
	gameSubscriptions map[string]map[*Client]bool

	// Inbound messages from the clients
	broadcast chan []byte

	// Game-specific broadcast channel
	gameBroadcast chan GameMessage

	// Register requests from the clients
	register chan *Client

	// Unregister requests from clients
	unregister chan *Client

	// Mutex for thread-safe operations
	mu sync.RWMutex
}

// GameMessage represents a message to be sent to clients of a specific game
type GameMessage struct {
	GameName string
	Message  []byte
}

// NewHub creates a new Hub instance
func NewHub() *Hub {
	return &Hub{
		clients:           make(map[*Client]bool),
		gameSubscriptions: make(map[string]map[*Client]bool),
		broadcast:         make(chan []byte, 256),
		gameBroadcast:     make(chan GameMessage, 256),
		register:          make(chan *Client),
		unregister:        make(chan *Client),
	}
}

// Run starts the hub's main event loop
func (h *Hub) Run() {
	log.Println("WebSocket Hub started")
	for {
		select {
		case client := <-h.register:
			h.mu.Lock()
			h.clients[client] = true
			h.mu.Unlock()
			log.Printf("Client %s connected. Total clients: %d", client.ID, len(h.clients))

		case client := <-h.unregister:
			h.mu.Lock()
			if _, ok := h.clients[client]; ok {
				delete(h.clients, client)
				close(client.send)

				// Remove from all game subscriptions
				for gameName, subscribers := range h.gameSubscriptions {
					delete(subscribers, client)
					if len(subscribers) == 0 {
						delete(h.gameSubscriptions, gameName)
					}
				}
			}
			h.mu.Unlock()
			log.Printf("Client %s disconnected. Total clients: %d", client.ID, len(h.clients))

		case message := <-h.broadcast:
			h.mu.RLock()
			for client := range h.clients {
				select {
				case client.send <- message:
				default:
					close(client.send)
					delete(h.clients, client)
				}
			}
			h.mu.RUnlock()

		case gameMsg := <-h.gameBroadcast:
			h.mu.RLock()
			if subscribers, ok := h.gameSubscriptions[gameMsg.GameName]; ok {
				for client := range subscribers {
					select {
					case client.send <- gameMsg.Message:
					default:
						close(client.send)
						delete(subscribers, client)
					}
				}
			}
			h.mu.RUnlock()
		}
	}
}

// SubscribeToGame subscribes a client to a specific game
func (h *Hub) SubscribeToGame(client *Client, gameName string) {
	h.mu.Lock()
	defer h.mu.Unlock()

	if _, ok := h.gameSubscriptions[gameName]; !ok {
		h.gameSubscriptions[gameName] = make(map[*Client]bool)
	}
	h.gameSubscriptions[gameName][client] = true
	log.Printf("Client %s subscribed to game: %s", client.ID, gameName)
}

// UnsubscribeFromGame unsubscribes a client from a specific game
func (h *Hub) UnsubscribeFromGame(client *Client, gameName string) {
	h.mu.Lock()
	defer h.mu.Unlock()

	if subscribers, ok := h.gameSubscriptions[gameName]; ok {
		delete(subscribers, client)
		if len(subscribers) == 0 {
			delete(h.gameSubscriptions, gameName)
		}
	}
	log.Printf("Client %s unsubscribed from game: %s", client.ID, gameName)
}

// Broadcast sends a message to all connected clients
func (h *Hub) Broadcast(message []byte) {
	h.broadcast <- message
}

// BroadcastToGame sends a message to all clients subscribed to a specific game
func (h *Hub) BroadcastToGame(gameName string, message []byte) {
	h.gameBroadcast <- GameMessage{
		GameName: gameName,
		Message:  message,
	}
}

// GetConnectedGames returns a list of games with active subscriptions
func (h *Hub) GetConnectedGames() []string {
	h.mu.RLock()
	defer h.mu.RUnlock()

	games := make([]string, 0, len(h.gameSubscriptions))
	for game := range h.gameSubscriptions {
		games = append(games, game)
	}
	return games
}

// GetClientCount returns the number of connected clients
func (h *Hub) GetClientCount() int {
	h.mu.RLock()
	defer h.mu.RUnlock()
	return len(h.clients)
}

// GetGameSubscriberCount returns the number of subscribers for a specific game
func (h *Hub) GetGameSubscriberCount(gameName string) int {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if subscribers, ok := h.gameSubscriptions[gameName]; ok {
		return len(subscribers)
	}
	return 0
}

// Register adds a client to the hub
func (h *Hub) Register(client *Client) {
	h.register <- client
}

// Unregister removes a client from the hub
func (h *Hub) Unregister(client *Client) {
	h.unregister <- client
}
