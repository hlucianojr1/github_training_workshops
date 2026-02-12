package service

import (
	"encoding/json"
	"log"

	"github.com/insight/high-scores-go/models"
)

// WebSocketHub defines the interface for the WebSocket hub
type WebSocketHub interface {
	Broadcast(message []byte)
	BroadcastToGame(gameName string, message []byte)
	GetConnectedGames() []string
}

// WebSocketNotificationService broadcasts notifications via WebSocket
type WebSocketNotificationService struct {
	hub WebSocketHub
}

// NewWebSocketNotificationService creates a new WebSocketNotificationService
func NewWebSocketNotificationService(hub WebSocketHub) *WebSocketNotificationService {
	return &WebSocketNotificationService{hub: hub}
}

// BroadcastScoreUpdate sends a score update to all connected clients subscribed to the game
func (s *WebSocketNotificationService) BroadcastScoreUpdate(score *models.GameScore) {
	if s.hub == nil {
		log.Println("WebSocket hub not initialized, skipping broadcast")
		return
	}

	payload := models.ScoreUpdatePayload{
		ID:         score.ID,
		PlayerName: score.PlayerName,
		GameName:   score.GameName,
		Score:      score.Score,
		AchievedAt: score.AchievedAt.Format("2006-01-02T15:04:05Z07:00"),
	}

	message := models.NewWSMessage(models.MessageTypeScoreUpdate, payload)
	
	// Serialize to JSON
	jsonBytes, err := serializeMessage(message)
	if err != nil {
		log.Printf("Failed to serialize score update: %v", err)
		return
	}

	// Broadcast to clients subscribed to this game
	s.hub.BroadcastToGame(score.GameName, jsonBytes)
	log.Printf("Broadcasted score update for game: %s", score.GameName)
}

// BroadcastLeaderboardUpdate sends a leaderboard update to all connected clients subscribed to the game
func (s *WebSocketNotificationService) BroadcastLeaderboardUpdate(gameName string, topScores []models.ScoreResponse) {
	if s.hub == nil {
		log.Println("WebSocket hub not initialized, skipping broadcast")
		return
	}

	payload := models.LeaderboardUpdatePayload{
		GameName:  gameName,
		TopScores: topScores,
	}

	message := models.NewWSMessage(models.MessageTypeLeaderboardUpdate, payload)
	
	jsonBytes, err := serializeMessage(message)
	if err != nil {
		log.Printf("Failed to serialize leaderboard update: %v", err)
		return
	}

	s.hub.BroadcastToGame(gameName, jsonBytes)
	log.Printf("Broadcasted leaderboard update for game: %s", gameName)
}

// serializeMessage converts a message to JSON bytes
func serializeMessage(message interface{}) ([]byte, error) {
	return json.Marshal(message)
}
