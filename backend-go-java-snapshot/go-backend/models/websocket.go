package models

import "time"

// WebSocket message types
const (
	MessageTypeScoreUpdate       = "SCORE_UPDATE"
	MessageTypeLeaderboardUpdate = "LEADERBOARD_UPDATE"
	MessageTypeSubscribe         = "SUBSCRIBE"
	MessageTypeUnsubscribe       = "UNSUBSCRIBE"
	MessageTypePing              = "PING"
	MessageTypePong              = "PONG"
	MessageTypeError             = "ERROR"
	MessageTypeConnected         = "CONNECTED"
)

// WSMessage represents a WebSocket message envelope
type WSMessage struct {
	Type      string      `json:"type"`
	Payload   interface{} `json:"payload,omitempty"`
	Timestamp string      `json:"timestamp"`
}

// NewWSMessage creates a new WebSocket message with current timestamp
func NewWSMessage(msgType string, payload interface{}) WSMessage {
	return WSMessage{
		Type:      msgType,
		Payload:   payload,
		Timestamp: time.Now().UTC().Format(time.RFC3339),
	}
}

// ScoreUpdatePayload is the payload for score update messages
type ScoreUpdatePayload struct {
	ID         uint   `json:"id"`
	PlayerName string `json:"playerName"`
	GameName   string `json:"gameName"`
	Score      int64  `json:"score"`
	AchievedAt string `json:"achievedAt"`
}

// LeaderboardUpdatePayload is the payload for leaderboard updates
type LeaderboardUpdatePayload struct {
	GameName  string          `json:"gameName"`
	TopScores []ScoreResponse `json:"topScores"`
}

// SubscribePayload is the payload for subscription requests
type SubscribePayload struct {
	GameName string `json:"gameName"`
}

// ErrorPayload is the payload for error messages
type ErrorPayload struct {
	Code    string `json:"code"`
	Message string `json:"message"`
}

// ConnectedPayload is the payload for connection confirmation
type ConnectedPayload struct {
	ClientID string   `json:"clientId"`
	Games    []string `json:"games"`
}

// ClientMessage represents a message received from a client
type ClientMessage struct {
	Type    string          `json:"type"`
	Payload SubscribePayload `json:"payload,omitempty"`
}
