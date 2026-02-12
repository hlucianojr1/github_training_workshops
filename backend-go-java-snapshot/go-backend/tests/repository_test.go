package tests

import (
	"testing"
	"time"

	"github.com/insight/high-scores-go/models"
	"github.com/insight/high-scores-go/repository"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
)

// RepositoryTestSuite contains all repository tests
type RepositoryTestSuite struct {
	suite.Suite
	repo *repository.GameScoreRepository
}

// SetupTest runs before each test
func (suite *RepositoryTestSuite) SetupTest() {
	db, err := models.InitTestDB()
	assert.NoError(suite.T(), err)
	suite.repo = repository.NewGameScoreRepository(db)

	// Seed test data
	testScores := []models.GameScore{
		{PlayerName: "Player1", GameName: "GameA", Score: 1000, AchievedAt: time.Now()},
		{PlayerName: "Player2", GameName: "GameA", Score: 2000, AchievedAt: time.Now()},
		{PlayerName: "Player1", GameName: "GameB", Score: 500, AchievedAt: time.Now()},
		{PlayerName: "Player3", GameName: "GameA", Score: 1500, AchievedAt: time.Now()},
	}

	for _, score := range testScores {
		err := suite.repo.Create(&score)
		assert.NoError(suite.T(), err)
	}
}

func (suite *RepositoryTestSuite) TestCreate() {
	score := &models.GameScore{
		PlayerName: "TestPlayer",
		GameName:   "TestGame",
		Score:      9999,
		AchievedAt: time.Now(),
	}

	err := suite.repo.Create(score)
	assert.NoError(suite.T(), err)
	assert.NotZero(suite.T(), score.ID)
}

func (suite *RepositoryTestSuite) TestFindByID() {
	// Create a score first
	score := &models.GameScore{
		PlayerName: "FindByIDPlayer",
		GameName:   "FindByIDGame",
		Score:      5000,
		AchievedAt: time.Now(),
	}
	suite.repo.Create(score)

	// Find it
	found, err := suite.repo.FindByID(score.ID)
	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), score.PlayerName, found.PlayerName)
	assert.Equal(suite.T(), score.Score, found.Score)
}

func (suite *RepositoryTestSuite) TestFindAllGames() {
	games, err := suite.repo.FindAllGames()
	assert.NoError(suite.T(), err)
	assert.Contains(suite.T(), games, "GameA")
	assert.Contains(suite.T(), games, "GameB")
}

func (suite *RepositoryTestSuite) TestFindAllPlayers() {
	players, err := suite.repo.FindAllPlayers()
	assert.NoError(suite.T(), err)
	assert.Contains(suite.T(), players, "Player1")
	assert.Contains(suite.T(), players, "Player2")
	assert.Contains(suite.T(), players, "Player3")
}

func (suite *RepositoryTestSuite) TestFindTopScoresForGame() {
	scores, err := suite.repo.FindTopScoresForGame("GameA", 2)
	assert.NoError(suite.T(), err)
	assert.Len(suite.T(), scores, 2)
	// Should be sorted by score descending
	assert.Equal(suite.T(), int64(2000), scores[0].Score)
	assert.Equal(suite.T(), int64(1500), scores[1].Score)
}

func (suite *RepositoryTestSuite) TestFindGameScoresPaginated() {
	scores, total, err := suite.repo.FindGameScoresPaginated("GameA", 0, 2)
	assert.NoError(suite.T(), err)
	assert.Len(suite.T(), scores, 2)
	assert.Equal(suite.T(), int64(3), total)
}

func (suite *RepositoryTestSuite) TestFindPlayerGameScores() {
	scores, err := suite.repo.FindPlayerGameScores("Player1", "GameA")
	assert.NoError(suite.T(), err)
	assert.Len(suite.T(), scores, 1)
	assert.Equal(suite.T(), "Player1", scores[0].PlayerName)
}

func (suite *RepositoryTestSuite) TestFindPlayerHighScoreForGame() {
	// Player1 has a score in GameA
	score, err := suite.repo.FindPlayerHighScoreForGame("Player1", "GameA")
	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), int64(1000), score.Score)
}

func (suite *RepositoryTestSuite) TestGetPlayerStats() {
	stats, err := suite.repo.GetPlayerStats("Player1")
	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "Player1", stats.PlayerName)
	assert.Equal(suite.T(), 2, stats.TotalGames) // Player1 has scores in 2 games
	assert.Contains(suite.T(), stats.GamesPlayed, "GameA")
	assert.Contains(suite.T(), stats.GamesPlayed, "GameB")
}

func (suite *RepositoryTestSuite) TestGetGameStats() {
	stats, err := suite.repo.GetGameStats("GameA")
	assert.NoError(suite.T(), err)
	assert.Equal(suite.T(), "GameA", stats.GameName)
	assert.Equal(suite.T(), 3, stats.TotalPlayers)
	assert.Equal(suite.T(), 3, stats.TotalScores)
	assert.Equal(suite.T(), int64(2000), stats.HighestScore)
	assert.Equal(suite.T(), "Player2", stats.TopPlayer)
}

func (suite *RepositoryTestSuite) TestDelete() {
	score := &models.GameScore{
		PlayerName: "DeletePlayer",
		GameName:   "DeleteGame",
		Score:      100,
		AchievedAt: time.Now(),
	}
	suite.repo.Create(score)

	err := suite.repo.Delete(score.ID)
	assert.NoError(suite.T(), err)

	// Verify deletion
	_, err = suite.repo.FindByID(score.ID)
	assert.Error(suite.T(), err)
}

func TestRepositoryTestSuite(t *testing.T) {
	suite.Run(t, new(RepositoryTestSuite))
}
