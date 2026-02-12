package models

import (
	"time"

	"gorm.io/gorm"
)

// GameScore represents a game score entry in the database
type GameScore struct {
	ID         uint           `gorm:"primaryKey" json:"id"`
	PlayerName string         `gorm:"not null;index" json:"playerName"`
	GameName   string         `gorm:"not null;index" json:"gameName"`
	Score      int64          `gorm:"not null" json:"score"`
	AchievedAt time.Time      `gorm:"not null" json:"achievedAt"`
	CreatedAt  time.Time      `json:"createdAt"`
	UpdatedAt  time.Time      `json:"-"`
	DeletedAt  gorm.DeletedAt `gorm:"index" json:"-"`
}

// TableName returns the table name for the GameScore model
func (GameScore) TableName() string {
	return "game_scores"
}

// ScoreResponse is the DTO for API responses
type ScoreResponse struct {
	ID         uint   `json:"id"`
	PlayerName string `json:"playerName"`
	GameName   string `json:"gameName"`
	Score      int64  `json:"score"`
	AchievedAt string `json:"achievedAt"`
	CreatedAt  string `json:"createdAt"`
}

// ToResponse converts a GameScore to ScoreResponse
func (g *GameScore) ToResponse() ScoreResponse {
	return ScoreResponse{
		ID:         g.ID,
		PlayerName: g.PlayerName,
		GameName:   g.GameName,
		Score:      g.Score,
		AchievedAt: g.AchievedAt.Format(time.RFC3339),
		CreatedAt:  g.CreatedAt.Format(time.RFC3339),
	}
}

// ScoreSubmissionRequest is the DTO for score submission
type ScoreSubmissionRequest struct {
	PlayerName string `json:"playerName" binding:"required"`
	GameName   string `json:"gameName" binding:"required"`
	Score      int64  `json:"score" binding:"required"`
	AchievedAt string `json:"achievedAt,omitempty"`
}

// PlayerStats represents player statistics
type PlayerStats struct {
	PlayerName   string   `json:"playerName"`
	TotalGames   int      `json:"totalGames"`
	TotalScore   int64    `json:"totalScore"`
	AverageScore float64  `json:"averageScore"`
	HighestScore int64    `json:"highestScore"`
	GamesPlayed  []string `json:"gamesPlayed"`
}

// GameStats represents game statistics
type GameStats struct {
	GameName     string  `json:"gameName"`
	TotalPlayers int     `json:"totalPlayers"`
	TotalScores  int     `json:"totalScores"`
	AverageScore float64 `json:"averageScore"`
	HighestScore int64   `json:"highestScore"`
	TopPlayer    string  `json:"topPlayer"`
}

// PageResponse represents a paginated response
type PageResponse struct {
	Content       []ScoreResponse `json:"content"`
	TotalElements int64           `json:"totalElements"`
	TotalPages    int             `json:"totalPages"`
	Size          int             `json:"size"`
	Number        int             `json:"number"`
	First         bool            `json:"first"`
	Last          bool            `json:"last"`
}
