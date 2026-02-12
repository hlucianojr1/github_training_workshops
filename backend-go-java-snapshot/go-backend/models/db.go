package models

import (
	"log"
	"time"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// InitDB initializes the SQLite database connection
func InitDB(dbPath string) (*gorm.DB, error) {
	if dbPath == "" {
		dbPath = "highscores.db"
	}

	db, err := gorm.Open(sqlite.Open(dbPath), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		return nil, err
	}

	// Auto-migrate the schema
	if err := db.AutoMigrate(&GameScore{}); err != nil {
		return nil, err
	}

	log.Println("Database initialized successfully")
	return db, nil
}

// InitTestDB initializes an in-memory SQLite database for testing
func InitTestDB() (*gorm.DB, error) {
	db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	if err != nil {
		return nil, err
	}

	if err := db.AutoMigrate(&GameScore{}); err != nil {
		return nil, err
	}

	return db, nil
}

// SeedData populates the database with sample data
func SeedData(db *gorm.DB) error {
	var count int64
	db.Model(&GameScore{}).Count(&count)
	if count > 0 {
		log.Println("Database already seeded, skipping...")
		return nil
	}

	log.Println("Seeding database with sample data...")

	sampleScores := []GameScore{
		{PlayerName: "GhostReaper", GameName: "Operation Nightfall", Score: 145820, AchievedAt: time.Now().Add(-24 * time.Hour)},
		{PlayerName: "ShadowSniper", GameName: "Operation Nightfall", Score: 142150, AchievedAt: time.Now().Add(-23 * time.Hour)},
		{PlayerName: "PhantomElite", GameName: "Operation Nightfall", Score: 138490, AchievedAt: time.Now().Add(-22 * time.Hour)},
		{PlayerName: "ViperStrike", GameName: "Operation Nightfall", Score: 135280, AchievedAt: time.Now().Add(-21 * time.Hour)},
		{PlayerName: "StealthNinja", GameName: "Operation Nightfall", Score: 132760, AchievedAt: time.Now().Add(-20 * time.Hour)},
		{PlayerName: "TacticalWolf", GameName: "Operation Nightfall", Score: 129450, AchievedAt: time.Now().Add(-19 * time.Hour)},
		{PlayerName: "NightHawk47", GameName: "Operation Nightfall", Score: 126890, AchievedAt: time.Now().Add(-18 * time.Hour)},
		{PlayerName: "DeltaForce", GameName: "Operation Nightfall", Score: 124320, AchievedAt: time.Now().Add(-17 * time.Hour)},
		{PlayerName: "ApexPredator", GameName: "Operation Nightfall", Score: 121750, AchievedAt: time.Now().Add(-16 * time.Hour)},
		{PlayerName: "WarMachine", GameName: "Operation Nightfall", Score: 119180, AchievedAt: time.Now().Add(-15 * time.Hour)},
		// Additional game
		{PlayerName: "GhostReaper", GameName: "Shadow Protocol", Score: 98500, AchievedAt: time.Now().Add(-14 * time.Hour)},
		{PlayerName: "ShadowSniper", GameName: "Shadow Protocol", Score: 95200, AchievedAt: time.Now().Add(-13 * time.Hour)},
		{PlayerName: "PhantomElite", GameName: "Shadow Protocol", Score: 91800, AchievedAt: time.Now().Add(-12 * time.Hour)},
	}

	for _, score := range sampleScores {
		if err := db.Create(&score).Error; err != nil {
			log.Printf("Failed to seed score: %v", err)
			return err
		}
	}

	log.Printf("Seeded %d sample scores", len(sampleScores))
	return nil
}
