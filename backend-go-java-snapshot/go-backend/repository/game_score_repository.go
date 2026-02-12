package repository

import (
	"github.com/insight/high-scores-go/models"
	"gorm.io/gorm"
)

// GameScoreRepository handles database operations for game scores
type GameScoreRepository struct {
	db *gorm.DB
}

// NewGameScoreRepository creates a new GameScoreRepository
func NewGameScoreRepository(db *gorm.DB) *GameScoreRepository {
	return &GameScoreRepository{db: db}
}

// Create saves a new game score to the database
func (r *GameScoreRepository) Create(score *models.GameScore) error {
	return r.db.Create(score).Error
}

// FindByID retrieves a game score by its ID
func (r *GameScoreRepository) FindByID(id uint) (*models.GameScore, error) {
	var score models.GameScore
	err := r.db.First(&score, id).Error
	if err != nil {
		return nil, err
	}
	return &score, nil
}

// FindAllGames returns all unique game names
func (r *GameScoreRepository) FindAllGames() ([]string, error) {
	var games []string
	err := r.db.Model(&models.GameScore{}).
		Distinct("game_name").
		Pluck("game_name", &games).Error
	return games, err
}

// FindAllPlayers returns all unique player names
func (r *GameScoreRepository) FindAllPlayers() ([]string, error) {
	var players []string
	err := r.db.Model(&models.GameScore{}).
		Distinct("player_name").
		Pluck("player_name", &players).Error
	return players, err
}

// FindTopScoresForGame returns the top N scores for a specific game
func (r *GameScoreRepository) FindTopScoresForGame(gameName string, limit int) ([]models.GameScore, error) {
	var scores []models.GameScore
	err := r.db.Where("game_name = ?", gameName).
		Order("score DESC").
		Limit(limit).
		Find(&scores).Error
	return scores, err
}

// FindGameScoresPaginated returns paginated scores for a specific game
func (r *GameScoreRepository) FindGameScoresPaginated(gameName string, page, size int) ([]models.GameScore, int64, error) {
	var scores []models.GameScore
	var total int64

	// Get total count
	r.db.Model(&models.GameScore{}).Where("game_name = ?", gameName).Count(&total)

	// Get paginated results
	offset := page * size
	err := r.db.Where("game_name = ?", gameName).
		Order("score DESC").
		Offset(offset).
		Limit(size).
		Find(&scores).Error

	return scores, total, err
}

// FindPlayerScoresPaginated returns paginated scores for a specific player
func (r *GameScoreRepository) FindPlayerScoresPaginated(playerName string, page, size int) ([]models.GameScore, int64, error) {
	var scores []models.GameScore
	var total int64

	r.db.Model(&models.GameScore{}).Where("player_name = ?", playerName).Count(&total)

	offset := page * size
	err := r.db.Where("player_name = ?", playerName).
		Order("score DESC").
		Offset(offset).
		Limit(size).
		Find(&scores).Error

	return scores, total, err
}

// FindPlayerGameScores returns all scores for a player in a specific game
func (r *GameScoreRepository) FindPlayerGameScores(playerName, gameName string) ([]models.GameScore, error) {
	var scores []models.GameScore
	err := r.db.Where("player_name = ? AND game_name = ?", playerName, gameName).
		Order("score DESC").
		Find(&scores).Error
	return scores, err
}

// FindPlayerHighScoreForGame returns the highest score for a player in a specific game
func (r *GameScoreRepository) FindPlayerHighScoreForGame(playerName, gameName string) (*models.GameScore, error) {
	var score models.GameScore
	err := r.db.Where("player_name = ? AND game_name = ?", playerName, gameName).
		Order("score DESC").
		First(&score).Error
	if err != nil {
		return nil, err
	}
	return &score, nil
}

// GetPlayerStats returns statistics for a player
func (r *GameScoreRepository) GetPlayerStats(playerName string) (*models.PlayerStats, error) {
	stats := &models.PlayerStats{
		PlayerName: playerName,
	}

	// Get total games and scores
	var result struct {
		TotalGames   int
		TotalScore   int64
		AverageScore float64
		HighestScore int64
	}

	err := r.db.Model(&models.GameScore{}).
		Where("player_name = ?", playerName).
		Select("COUNT(*) as total_games, COALESCE(SUM(score), 0) as total_score, COALESCE(AVG(score), 0) as average_score, COALESCE(MAX(score), 0) as highest_score").
		Scan(&result).Error
	if err != nil {
		return nil, err
	}

	stats.TotalGames = result.TotalGames
	stats.TotalScore = result.TotalScore
	stats.AverageScore = result.AverageScore
	stats.HighestScore = result.HighestScore

	// Get games played
	var games []string
	r.db.Model(&models.GameScore{}).
		Where("player_name = ?", playerName).
		Distinct("game_name").
		Pluck("game_name", &games)
	stats.GamesPlayed = games

	return stats, nil
}

// GetGameStats returns statistics for a game
func (r *GameScoreRepository) GetGameStats(gameName string) (*models.GameStats, error) {
	stats := &models.GameStats{
		GameName: gameName,
	}

	var result struct {
		TotalPlayers int
		TotalScores  int
		AverageScore float64
		HighestScore int64
	}

	err := r.db.Model(&models.GameScore{}).
		Where("game_name = ?", gameName).
		Select("COUNT(DISTINCT player_name) as total_players, COUNT(*) as total_scores, COALESCE(AVG(score), 0) as average_score, COALESCE(MAX(score), 0) as highest_score").
		Scan(&result).Error
	if err != nil {
		return nil, err
	}

	stats.TotalPlayers = result.TotalPlayers
	stats.TotalScores = result.TotalScores
	stats.AverageScore = result.AverageScore
	stats.HighestScore = result.HighestScore

	// Get top player
	var topScore models.GameScore
	if err := r.db.Where("game_name = ?", gameName).Order("score DESC").First(&topScore).Error; err == nil {
		stats.TopPlayer = topScore.PlayerName
	}

	return stats, nil
}

// Delete removes a game score by ID
func (r *GameScoreRepository) Delete(id uint) error {
	return r.db.Delete(&models.GameScore{}, id).Error
}
