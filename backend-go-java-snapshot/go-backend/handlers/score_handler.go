package handlers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/insight/high-scores-go/models"
	"github.com/insight/high-scores-go/service"
)

// ScoreHandler handles HTTP requests for game scores
type ScoreHandler struct {
	service *service.GameScoreService
}

// NewScoreHandler creates a new ScoreHandler
func NewScoreHandler(service *service.GameScoreService) *ScoreHandler {
	return &ScoreHandler{service: service}
}

// SubmitScore handles POST /api/scores/submit
func (h *ScoreHandler) SubmitScore(c *gin.Context) {
	var request models.ScoreSubmissionRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body: " + err.Error()})
		return
	}

	score, err := h.service.SubmitScore(&request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to submit score: " + err.Error()})
		return
	}

	c.JSON(http.StatusCreated, score.ToResponse())
}

// GetAllGames handles GET /api/scores/games
func (h *ScoreHandler) GetAllGames(c *gin.Context) {
	games, err := h.service.GetAllGames()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get games: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, games)
}

// GetAllPlayers handles GET /api/scores/players
func (h *ScoreHandler) GetAllPlayers(c *gin.Context) {
	players, err := h.service.GetAllPlayers()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get players: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, players)
}

// GetTopScoresForGame handles GET /api/scores/game/:gameName/top
func (h *ScoreHandler) GetTopScoresForGame(c *gin.Context) {
	gameName := c.Param("gameName")
	if gameName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Game name is required"})
		return
	}

	limitStr := c.DefaultQuery("limit", "10")
	limit, err := strconv.Atoi(limitStr)
	if err != nil || limit <= 0 {
		limit = 10
	}

	scores, err := h.service.GetTopScoresForGame(gameName, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get top scores: " + err.Error()})
		return
	}

	responses := make([]models.ScoreResponse, len(scores))
	for i, score := range scores {
		responses[i] = score.ToResponse()
	}

	c.JSON(http.StatusOK, responses)
}

// GetGameScores handles GET /api/scores/game/:gameName
func (h *ScoreHandler) GetGameScores(c *gin.Context) {
	gameName := c.Param("gameName")
	if gameName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Game name is required"})
		return
	}

	page := parseIntQuery(c, "page", 0)
	size := parseIntQuery(c, "size", 10)

	response, err := h.service.GetGameScores(gameName, page, size)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get game scores: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// GetPlayerGameScores handles GET /api/scores/game/:gameName/player/:playerName
func (h *ScoreHandler) GetPlayerGameScores(c *gin.Context) {
	gameName := c.Param("gameName")
	playerName := c.Param("playerName")

	if gameName == "" || playerName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Game name and player name are required"})
		return
	}

	scores, err := h.service.GetPlayerGameScores(playerName, gameName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get player game scores: " + err.Error()})
		return
	}

	responses := make([]models.ScoreResponse, len(scores))
	for i, score := range scores {
		responses[i] = score.ToResponse()
	}

	c.JSON(http.StatusOK, responses)
}

// GetPlayerHighScore handles GET /api/scores/game/:gameName/player/:playerName/high
func (h *ScoreHandler) GetPlayerHighScore(c *gin.Context) {
	gameName := c.Param("gameName")
	playerName := c.Param("playerName")

	if gameName == "" || playerName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Game name and player name are required"})
		return
	}

	score, err := h.service.GetPlayerHighScore(playerName, gameName)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "High score not found"})
		return
	}

	c.JSON(http.StatusOK, score.ToResponse())
}

// GetPlayerScores handles GET /api/scores/player/:playerName
func (h *ScoreHandler) GetPlayerScores(c *gin.Context) {
	playerName := c.Param("playerName")
	if playerName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Player name is required"})
		return
	}

	page := parseIntQuery(c, "page", 0)
	size := parseIntQuery(c, "size", 10)

	response, err := h.service.GetPlayerScores(playerName, page, size)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get player scores: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// GetPlayerStats handles GET /api/scores/player/:playerName/stats
func (h *ScoreHandler) GetPlayerStats(c *gin.Context) {
	playerName := c.Param("playerName")
	if playerName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Player name is required"})
		return
	}

	stats, err := h.service.GetPlayerStats(playerName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get player stats: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, stats)
}

// GetGameStats handles GET /api/scores/game/:gameName/stats
func (h *ScoreHandler) GetGameStats(c *gin.Context) {
	gameName := c.Param("gameName")
	if gameName == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": gin.H{
				"code":    "GAME_NAME_REQUIRED",
				"message": "Game name is required",
			},
		})
		return
	}

	stats, err := h.service.GetGameStats(gameName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": gin.H{
				"code":    "INTERNAL_ERROR",
				"message": "Failed to get game statistics",
			},
		})
		return
	}

	c.JSON(http.StatusOK, stats)
}

// parseIntQuery parses an integer query parameter with a default value
func parseIntQuery(c *gin.Context, key string, defaultValue int) int {
	valueStr := c.Query(key)
	if valueStr == "" {
		return defaultValue
	}

	value, err := strconv.Atoi(valueStr)
	if err != nil || value < 0 {
		return defaultValue
	}

	return value
}
