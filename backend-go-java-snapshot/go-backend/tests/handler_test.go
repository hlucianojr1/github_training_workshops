package tests

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/insight/high-scores-go/handlers"
	"github.com/insight/high-scores-go/models"
	"github.com/insight/high-scores-go/repository"
	"github.com/insight/high-scores-go/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
)

// HandlerTestSuite contains all handler tests
type HandlerTestSuite struct {
	suite.Suite
	router  *gin.Engine
	handler *handlers.ScoreHandler
}

// SetupTest runs before each test
func (suite *HandlerTestSuite) SetupTest() {
	gin.SetMode(gin.TestMode)

	db, err := models.InitTestDB()
	assert.NoError(suite.T(), err)

	repo := repository.NewGameScoreRepository(db)
	svc := service.NewGameScoreService(repo, nil) // No notifier for handler tests
	suite.handler = handlers.NewScoreHandler(svc)

	suite.router = gin.New()
	api := suite.router.Group("/api/scores")
	{
		api.POST("/submit", suite.handler.SubmitScore)
		api.GET("/games", suite.handler.GetAllGames)
		api.GET("/players", suite.handler.GetAllPlayers)
		api.GET("/game/:gameName/top", suite.handler.GetTopScoresForGame)
		api.GET("/game/:gameName", suite.handler.GetGameScores)
		api.GET("/game/:gameName/stats", suite.handler.GetGameStats)
		api.GET("/player/:playerName/stats", suite.handler.GetPlayerStats)
	}

	// Seed test data
	testScores := []models.GameScore{
		{PlayerName: "HandlerPlayer1", GameName: "HandlerGame", Score: 10000, AchievedAt: time.Now()},
		{PlayerName: "HandlerPlayer2", GameName: "HandlerGame", Score: 8000, AchievedAt: time.Now()},
	}

	for _, score := range testScores {
		repo.Create(&score)
	}
}

func (suite *HandlerTestSuite) TestSubmitScore_Success() {
	request := models.ScoreSubmissionRequest{
		PlayerName: "NewHandlerPlayer",
		GameName:   "HandlerGame",
		Score:      12000,
	}

	body, _ := json.Marshal(request)
	req := httptest.NewRequest(http.MethodPost, "/api/scores/submit", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	suite.router.ServeHTTP(w, req)

	assert.Equal(suite.T(), http.StatusCreated, w.Code)

	var response models.ScoreResponse
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "NewHandlerPlayer", response.PlayerName)
	assert.Equal(suite.T(), int64(12000), response.Score)
}

func (suite *HandlerTestSuite) TestSubmitScore_InvalidRequest() {
	// Missing required fields
	request := map[string]string{
		"playerName": "Test",
		// Missing gameName and score
	}

	body, _ := json.Marshal(request)
	req := httptest.NewRequest(http.MethodPost, "/api/scores/submit", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	suite.router.ServeHTTP(w, req)

	assert.Equal(suite.T(), http.StatusBadRequest, w.Code)
}

func (suite *HandlerTestSuite) TestGetAllGames() {
	req := httptest.NewRequest(http.MethodGet, "/api/scores/games", nil)
	w := httptest.NewRecorder()

	suite.router.ServeHTTP(w, req)

	assert.Equal(suite.T(), http.StatusOK, w.Code)

	var games []string
	err := json.Unmarshal(w.Body.Bytes(), &games)
	assert.NoError(suite.T(), err)
	assert.Contains(suite.T(), games, "HandlerGame")
}

func (suite *HandlerTestSuite) TestGetTopScoresForGame() {
	req := httptest.NewRequest(http.MethodGet, "/api/scores/game/HandlerGame/top?limit=5", nil)
	w := httptest.NewRecorder()

	suite.router.ServeHTTP(w, req)

	assert.Equal(suite.T(), http.StatusOK, w.Code)

	var scores []models.ScoreResponse
	err := json.Unmarshal(w.Body.Bytes(), &scores)
	assert.NoError(suite.T(), err)
	assert.Len(suite.T(), scores, 2)
	// First score should be the highest
	assert.Equal(suite.T(), int64(10000), scores[0].Score)
}

func (suite *HandlerTestSuite) TestGetGameScores_Paginated() {
	req := httptest.NewRequest(http.MethodGet, "/api/scores/game/HandlerGame?page=0&size=1", nil)
	w := httptest.NewRecorder()

	suite.router.ServeHTTP(w, req)

	assert.Equal(suite.T(), http.StatusOK, w.Code)

	var response models.PageResponse
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(suite.T(), err)
	assert.Len(suite.T(), response.Content, 1)
	assert.Equal(suite.T(), int64(2), response.TotalElements)
}

func (suite *HandlerTestSuite) TestGetGameStats() {
	req := httptest.NewRequest(http.MethodGet, "/api/scores/game/HandlerGame/stats", nil)
	w := httptest.NewRecorder()

	suite.router.ServeHTTP(w, req)

	assert.Equal(suite.T(), http.StatusOK, w.Code)

	var stats models.GameStats
	err := json.Unmarshal(w.Body.Bytes(), &stats)
	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "HandlerGame", stats.GameName)
	assert.Equal(suite.T(), 2, stats.TotalPlayers)
	assert.Equal(suite.T(), int64(10000), stats.HighestScore)
}

func (suite *HandlerTestSuite) TestGetPlayerStats() {
	req := httptest.NewRequest(http.MethodGet, "/api/scores/player/HandlerPlayer1/stats", nil)
	w := httptest.NewRecorder()

	suite.router.ServeHTTP(w, req)

	assert.Equal(suite.T(), http.StatusOK, w.Code)

	var stats models.PlayerStats
	err := json.Unmarshal(w.Body.Bytes(), &stats)
	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "HandlerPlayer1", stats.PlayerName)
	assert.Equal(suite.T(), int64(10000), stats.HighestScore)
}

func TestHandlerTestSuite(t *testing.T) {
	suite.Run(t, new(HandlerTestSuite))
}
