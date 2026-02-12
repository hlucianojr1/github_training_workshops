package service

import (
	"log"
	"time"

	"github.com/insight/high-scores-go/models"
	"github.com/insight/high-scores-go/repository"
)

// NotificationService defines the interface for broadcasting notifications
type NotificationService interface {
	BroadcastScoreUpdate(score *models.GameScore)
	BroadcastLeaderboardUpdate(gameName string, topScores []models.ScoreResponse)
}

// GameScoreService handles business logic for game scores
type GameScoreService struct {
	repo         *repository.GameScoreRepository
	notifier     NotificationService
}

// NewGameScoreService creates a new GameScoreService
func NewGameScoreService(repo *repository.GameScoreRepository, notifier NotificationService) *GameScoreService {
	return &GameScoreService{
		repo:     repo,
		notifier: notifier,
	}
}

// SubmitScore creates a new game score and broadcasts the update
func (s *GameScoreService) SubmitScore(request *models.ScoreSubmissionRequest) (*models.GameScore, error) {
	achievedAt := time.Now()
	if request.AchievedAt != "" {
		parsedTime, err := time.Parse(time.RFC3339, request.AchievedAt)
		if err == nil {
			achievedAt = parsedTime
		}
	}

	score := &models.GameScore{
		PlayerName: request.PlayerName,
		GameName:   request.GameName,
		Score:      request.Score,
		AchievedAt: achievedAt,
	}

	err := s.repo.Create(score)
	if err != nil {
		return nil, err
	}

	log.Printf("Score submitted: %s scored %d in %s", score.PlayerName, score.Score, score.GameName)

	// Broadcast the score update to connected clients
	if s.notifier != nil {
		s.notifier.BroadcastScoreUpdate(score)

		// Also broadcast updated leaderboard
		topScores, err := s.GetTopScoresForGame(score.GameName, 10)
		if err == nil {
			responses := make([]models.ScoreResponse, len(topScores))
			for i, ts := range topScores {
				responses[i] = ts.ToResponse()
			}
			s.notifier.BroadcastLeaderboardUpdate(score.GameName, responses)
		}
	}

	return score, nil
}

// GetAllGames returns all unique game names
func (s *GameScoreService) GetAllGames() ([]string, error) {
	return s.repo.FindAllGames()
}

// GetAllPlayers returns all unique player names
func (s *GameScoreService) GetAllPlayers() ([]string, error) {
	return s.repo.FindAllPlayers()
}

// GetTopScoresForGame returns the top N scores for a specific game
func (s *GameScoreService) GetTopScoresForGame(gameName string, limit int) ([]models.GameScore, error) {
	return s.repo.FindTopScoresForGame(gameName, limit)
}

// GetGameScores returns paginated scores for a specific game
func (s *GameScoreService) GetGameScores(gameName string, page, size int) (*models.PageResponse, error) {
	scores, total, err := s.repo.FindGameScoresPaginated(gameName, page, size)
	if err != nil {
		return nil, err
	}

	content := make([]models.ScoreResponse, len(scores))
	for i, score := range scores {
		content[i] = score.ToResponse()
	}

	totalPages := int(total) / size
	if int(total)%size > 0 {
		totalPages++
	}

	return &models.PageResponse{
		Content:       content,
		TotalElements: total,
		TotalPages:    totalPages,
		Size:          size,
		Number:        page,
		First:         page == 0,
		Last:          page >= totalPages-1,
	}, nil
}

// GetPlayerScores returns paginated scores for a specific player
func (s *GameScoreService) GetPlayerScores(playerName string, page, size int) (*models.PageResponse, error) {
	scores, total, err := s.repo.FindPlayerScoresPaginated(playerName, page, size)
	if err != nil {
		return nil, err
	}

	content := make([]models.ScoreResponse, len(scores))
	for i, score := range scores {
		content[i] = score.ToResponse()
	}

	totalPages := int(total) / size
	if int(total)%size > 0 {
		totalPages++
	}

	return &models.PageResponse{
		Content:       content,
		TotalElements: total,
		TotalPages:    totalPages,
		Size:          size,
		Number:        page,
		First:         page == 0,
		Last:          page >= totalPages-1,
	}, nil
}

// GetPlayerGameScores returns all scores for a player in a specific game
func (s *GameScoreService) GetPlayerGameScores(playerName, gameName string) ([]models.GameScore, error) {
	return s.repo.FindPlayerGameScores(playerName, gameName)
}

// GetPlayerHighScore returns the highest score for a player in a specific game
func (s *GameScoreService) GetPlayerHighScore(playerName, gameName string) (*models.GameScore, error) {
	return s.repo.FindPlayerHighScoreForGame(playerName, gameName)
}

// GetPlayerStats returns statistics for a player
func (s *GameScoreService) GetPlayerStats(playerName string) (*models.PlayerStats, error) {
	return s.repo.GetPlayerStats(playerName)
}

// GetGameStats returns statistics for a game
func (s *GameScoreService) GetGameStats(gameName string) (*models.GameStats, error) {
	return s.repo.GetGameStats(gameName)
}
