package tests

import (
	"testing"
	"time"

	"github.com/insight/high-scores-go/models"
	"github.com/insight/high-scores-go/repository"
	"github.com/insight/high-scores-go/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/suite"
)

// MockNotificationService is a mock implementation of NotificationService
type MockNotificationService struct {
	mock.Mock
}

func (m *MockNotificationService) BroadcastScoreUpdate(score *models.GameScore) {
	m.Called(score)
}

func (m *MockNotificationService) BroadcastLeaderboardUpdate(gameName string, topScores []models.ScoreResponse) {
	m.Called(gameName, topScores)
}

// ServiceTestSuite contains all service tests
type ServiceTestSuite struct {
	suite.Suite
	service  *service.GameScoreService
	repo     *repository.GameScoreRepository
	notifier *MockNotificationService
}

// SetupTest runs before each test
func (suite *ServiceTestSuite) SetupTest() {
	db, err := models.InitTestDB()
	assert.NoError(suite.T(), err)

	suite.repo = repository.NewGameScoreRepository(db)
	suite.notifier = new(MockNotificationService)
	suite.service = service.NewGameScoreService(suite.repo, suite.notifier)

	// Seed test data
	testScores := []models.GameScore{
		{PlayerName: "TestPlayer1", GameName: "TestGame", Score: 5000, AchievedAt: time.Now()},
		{PlayerName: "TestPlayer2", GameName: "TestGame", Score: 3000, AchievedAt: time.Now()},
	}

	for _, score := range testScores {
		suite.repo.Create(&score)
	}
}

func (suite *ServiceTestSuite) TestSubmitScore_Success() {
	// Setup mock expectations
	suite.notifier.On("BroadcastScoreUpdate", mock.AnythingOfType("*models.GameScore")).Return()
	suite.notifier.On("BroadcastLeaderboardUpdate", "TestGame", mock.Anything).Return()

	request := &models.ScoreSubmissionRequest{
		PlayerName: "NewPlayer",
		GameName:   "TestGame",
		Score:      7500,
	}

	score, err := suite.service.SubmitScore(request)

	assert.NoError(suite.T(), err)
	assert.NotNil(suite.T(), score)
	assert.Equal(suite.T(), "NewPlayer", score.PlayerName)
	assert.Equal(suite.T(), int64(7500), score.Score)
	assert.NotZero(suite.T(), score.ID)

	// Verify notifications were sent
	suite.notifier.AssertCalled(suite.T(), "BroadcastScoreUpdate", mock.AnythingOfType("*models.GameScore"))
	suite.notifier.AssertCalled(suite.T(), "BroadcastLeaderboardUpdate", "TestGame", mock.Anything)
}

func (suite *ServiceTestSuite) TestSubmitScore_WithAchievedAt() {
	suite.notifier.On("BroadcastScoreUpdate", mock.Anything).Return()
	suite.notifier.On("BroadcastLeaderboardUpdate", mock.Anything, mock.Anything).Return()

	achievedAt := "2026-01-15T10:30:00Z"
	request := &models.ScoreSubmissionRequest{
		PlayerName: "TimedPlayer",
		GameName:   "TestGame",
		Score:      6000,
		AchievedAt: achievedAt,
	}

	score, err := suite.service.SubmitScore(request)

	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "2026-01-15", score.AchievedAt.Format("2006-01-02"))
}

func (suite *ServiceTestSuite) TestGetAllGames() {
	games, err := suite.service.GetAllGames()

	assert.NoError(suite.T(), err)
	assert.Contains(suite.T(), games, "TestGame")
}

func (suite *ServiceTestSuite) TestGetTopScoresForGame() {
	scores, err := suite.service.GetTopScoresForGame("TestGame", 10)

	assert.NoError(suite.T(), err)
	assert.Len(suite.T(), scores, 2)
	// Should be sorted by score descending
	assert.Equal(suite.T(), int64(5000), scores[0].Score)
	assert.Equal(suite.T(), int64(3000), scores[1].Score)
}

func (suite *ServiceTestSuite) TestGetGameScores_Pagination() {
	response, err := suite.service.GetGameScores("TestGame", 0, 1)

	assert.NoError(suite.T(), err)
	assert.Len(suite.T(), response.Content, 1)
	assert.Equal(suite.T(), int64(2), response.TotalElements)
	assert.Equal(suite.T(), 2, response.TotalPages)
	assert.True(suite.T(), response.First)
	assert.False(suite.T(), response.Last)
}

func (suite *ServiceTestSuite) TestGetPlayerStats() {
	stats, err := suite.service.GetPlayerStats("TestPlayer1")

	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "TestPlayer1", stats.PlayerName)
	assert.Equal(suite.T(), 1, stats.TotalGames)
	assert.Equal(suite.T(), int64(5000), stats.HighestScore)
}

func (suite *ServiceTestSuite) TestGetGameStats() {
	stats, err := suite.service.GetGameStats("TestGame")

	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "TestGame", stats.GameName)
	assert.Equal(suite.T(), 2, stats.TotalPlayers)
	assert.Equal(suite.T(), int64(5000), stats.HighestScore)
	assert.Equal(suite.T(), "TestPlayer1", stats.TopPlayer)
}

func TestServiceTestSuite(t *testing.T) {
	suite.Run(t, new(ServiceTestSuite))
}
