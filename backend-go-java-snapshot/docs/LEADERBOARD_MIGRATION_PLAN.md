# Leaderboard Migration Plan: Technical Implementation Guide

> **Document Version**: 1.0  
> **Created**: February 3, 2026  
> **Prerequisites**: Read `LEADERBOARD_REFACTORING.md` first  
> **Total Effort**: ~27 story points (~5-6 developer days)

---

## Overview

This document provides the technical step-by-step plan to migrate hardcoded leaderboard data from the frontend to a properly seeded backend database, with both Java and Go backends reading from a canonical JSON file.

---

## Phase 1: Create Canonical Seed Data (0.5 days)

### 1.1 Create Shared Directory Structure

```bash
mkdir -p shared
```

### 1.2 Create `shared/seed-data.json`

This file becomes the **single source of truth** for all seed data.

```json
{
  "version": "1.0.0",
  "lastUpdated": "2026-02-03",
  "games": [
    {
      "name": "Operation Nightfall",
      "description": "Tactical stealth operations"
    },
    {
      "name": "Shadow Protocol", 
      "description": "Covert missions"
    }
  ],
  "scores": [
    {
      "playerName": "GhostReaper",
      "gameName": "Operation Nightfall",
      "score": 145820,
      "kills": 2847,
      "wins": 156
    }
    // ... more entries
  ]
}
```

### 1.3 Agent Assignment

```
@seed_data_agent create canonical seed data file at shared/seed-data.json
```

---

## Phase 2: Extend Backend Data Models (1 day)

### 2.1 Java Backend: Update GameScore Entity

**File**: `java-spring-boot-backend/src/main/java/com/insight/ai_demo/entity/GameScore.java`

**Add fields**:
```java
@Column(nullable = false)
private Integer kills = 0;

@Column(nullable = false)
private Integer wins = 0;
```

**Add to constructors and update Lombok annotations**.

### 2.2 Go Backend: Update GameScore Model

**File**: `go-backend/models/game_score.go`

**Add fields**:
```go
type GameScore struct {
    ID         uint           `gorm:"primaryKey" json:"id"`
    PlayerName string         `gorm:"not null;index" json:"playerName"`
    GameName   string         `gorm:"not null;index" json:"gameName"`
    Score      int64          `gorm:"not null" json:"score"`
    Kills      int            `gorm:"not null;default:0" json:"kills"`
    Wins       int            `gorm:"not null;default:0" json:"wins"`
    AchievedAt time.Time      `gorm:"not null" json:"achievedAt"`
    CreatedAt  time.Time      `json:"createdAt"`
    UpdatedAt  time.Time      `json:"-"`
    DeletedAt  gorm.DeletedAt `gorm:"index" json:"-"`
}
```

### 2.3 Update DTOs/Response Types

**Java**: Update any DTOs that map from GameScore
**Go**: Update `ScoreResponse` struct

### 2.4 Agent Assignments

```
@java_backend_agent extend GameScore entity with kills and wins fields
@go_backend_agent extend GameScore model with kills and wins fields
@api_contract_agent verify API responses include new fields
```

---

## Phase 3: Switch Java Backend to SQLite (0.5 days)

### 3.1 Add SQLite Dependency

**File**: `java-spring-boot-backend/build.gradle`

```gradle
dependencies {
    // Replace H2 with SQLite
    // implementation 'com.h2database:h2'  // Remove or comment out
    implementation 'org.xerial:sqlite-jdbc:3.45.1.0'
    implementation 'org.hibernate.orm:hibernate-community-dialects:6.4.4.Final'
}
```

### 3.2 Update Application Properties

**File**: `java-spring-boot-backend/src/main/resources/application.properties`

```properties
# SQLite Configuration (replaces H2)
spring.datasource.url=jdbc:sqlite:./data/highscores.db
spring.datasource.driver-class-name=org.sqlite.JDBC
spring.jpa.database-platform=org.hibernate.community.dialect.SQLiteDialect
spring.jpa.hibernate.ddl-auto=update

# Remove H2 console (not applicable for SQLite)
# spring.h2.console.enabled=false
```

### 3.3 Create Data Directory

```bash
mkdir -p java-spring-boot-backend/data
echo "data/*.db" >> java-spring-boot-backend/.gitignore
```

### 3.4 Update Docker Compose

**File**: `docker-compose.yml`

Add volume mount for Java backend:
```yaml
backend:
  volumes:
    - ./java-spring-boot-backend/data:/app/data
    - ./shared:/app/shared:ro  # Read-only access to seed data
```

### 3.5 Agent Assignment

```
@java_backend_agent switch database from H2 to SQLite with file persistence
@docker_agent update docker-compose.yml with volume mounts for SQLite and shared seed data
```

---

## Phase 4: Implement Seed Data Loaders (1.5 days)

### 4.1 Java Backend: Create DataInitializer

**File**: `java-spring-boot-backend/src/main/java/com/insight/ai_demo/config/DataInitializer.java`

```java
package com.insight.ai_demo.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.insight.ai_demo.entity.GameScore;
import com.insight.ai_demo.repository.GameScoreRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Component
public class DataInitializer implements CommandLineRunner {
    
    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);
    private static final String SEED_FILE_PATH = "./shared/seed-data.json";
    
    private final GameScoreRepository repository;
    private final ObjectMapper objectMapper;
    
    public DataInitializer(GameScoreRepository repository, ObjectMapper objectMapper) {
        this.repository = repository;
        this.objectMapper = objectMapper;
    }
    
    @Override
    public void run(String... args) throws Exception {
        if (repository.count() > 0) {
            logger.info("Database already contains data, skipping seed");
            return;
        }
        
        logger.info("Seeding database from {}", SEED_FILE_PATH);
        
        Resource resource = new FileSystemResource(SEED_FILE_PATH);
        if (!resource.exists()) {
            logger.warn("Seed file not found at {}, skipping seed", SEED_FILE_PATH);
            return;
        }
        
        try (InputStream is = resource.getInputStream()) {
            Map<String, Object> seedData = objectMapper.readValue(is, Map.class);
            List<Map<String, Object>> scores = (List<Map<String, Object>>) seedData.get("scores");
            
            for (Map<String, Object> scoreData : scores) {
                GameScore score = new GameScore();
                score.setPlayerName((String) scoreData.get("playerName"));
                score.setGameName((String) scoreData.get("gameName"));
                score.setScore(((Number) scoreData.get("score")).longValue());
                score.setKills(((Number) scoreData.get("kills")).intValue());
                score.setWins(((Number) scoreData.get("wins")).intValue());
                score.setAchievedAt(LocalDateTime.now());
                
                repository.save(score);
            }
            
            logger.info("Successfully seeded {} scores", scores.size());
        }
    }
}
```

### 4.2 Go Backend: Update Seed Function

**File**: `go-backend/models/db.go`

Update `SeedData()` to read from JSON file:

```go
func SeedData(db *gorm.DB) error {
    var count int64
    db.Model(&GameScore{}).Count(&count)
    if count > 0 {
        log.Println("Database already contains data, skipping seed")
        return nil
    }
    
    seedFile := "./shared/seed-data.json"
    data, err := os.ReadFile(seedFile)
    if err != nil {
        log.Printf("Seed file not found at %s, skipping seed: %v", seedFile, err)
        return nil
    }
    
    var seedData struct {
        Scores []struct {
            PlayerName string `json:"playerName"`
            GameName   string `json:"gameName"`
            Score      int64  `json:"score"`
            Kills      int    `json:"kills"`
            Wins       int    `json:"wins"`
        } `json:"scores"`
    }
    
    if err := json.Unmarshal(data, &seedData); err != nil {
        return fmt.Errorf("failed to parse seed data: %w", err)
    }
    
    for _, s := range seedData.Scores {
        score := GameScore{
            PlayerName: s.PlayerName,
            GameName:   s.GameName,
            Score:      s.Score,
            Kills:      s.Kills,
            Wins:       s.Wins,
            AchievedAt: time.Now(),
        }
        if err := db.Create(&score).Error; err != nil {
            log.Printf("Failed to seed score for %s: %v", s.PlayerName, err)
        }
    }
    
    log.Printf("Successfully seeded %d scores", len(seedData.Scores))
    return nil
}
```

### 4.3 Update Docker Compose for Go Backend

```yaml
go-backend:
  volumes:
    - ./go-backend/data:/app/data
    - ./shared:/app/shared:ro  # Read-only access to seed data
```

### 4.4 Agent Assignments

```
@java_backend_agent create DataInitializer.java to load seed data from shared/seed-data.json
@go_backend_agent update SeedData function to load from shared/seed-data.json
@docker_agent ensure both backends have volume mounts for shared seed data
```

---

## Phase 5: Update Frontend (1 day)

### 5.1 Update Types

**File**: `frontend/src/app/api/types.ts`

```typescript
export interface ScoreResponse {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  kills: number;    // Add
  wins: number;     // Add
  achievedAt: string;
  createdAt: string;
}
```

### 5.2 Remove Hardcoded Fallback Data

**File**: `frontend/src/app/components/Leaderboard.tsx`

**Remove** lines 8-21 (the `fallbackData` constant).

### 5.3 Update LeaderboardEntry Conversion

```typescript
const convertToLeaderboardEntries = useCallback((scores: ScoreResponse[]): LeaderboardEntry[] => {
  return scores.map((score, index) => ({
    rank: index + 1,
    player: score.playerName,
    score: score.score,
    kills: score.kills,    // Add
    wins: score.wins,      // Add
    icon: getIconForRank(index + 1),
  }));
}, []);
```

### 5.4 Add Empty State UI

Replace fallback data usage with proper empty state:

```typescript
// In error handler
if (response.error) {
  setError(response.error);
  setLeaderboardData([]);  // Empty array instead of fallback
  setUsingFallback(false);
}

// In empty response handler
} else {
  setLeaderboardData([]);  // Empty array instead of fallback
}

// Add empty state render
{leaderboardData.length === 0 && !loading && !error && (
  <div className="text-center py-20 bg-black/40 backdrop-blur-sm border border-gray-800 rounded-lg">
    <Trophy className="w-16 h-16 mx-auto text-gray-600 mb-4" />
    <h3 className="text-xl text-gray-400 mb-2">No scores yet</h3>
    <p className="text-gray-500">Be the first to claim the top spot!</p>
  </div>
)}
```

### 5.5 Agent Assignment

```
@frontend_agent remove hardcoded fallbackData, update types, add empty state UI
@api_contract_agent verify frontend types match backend responses
```

---

## Phase 6: Testing (1 day)

### 6.1 Java Backend Tests

- Test DataInitializer loads seed data correctly
- Test GameScore entity with new fields
- Test API returns kills/wins in responses

### 6.2 Go Backend Tests

- Test SeedData function with JSON file
- Test GameScore model with new fields
- Test API returns kills/wins in responses

### 6.3 Frontend Tests

- Test Leaderboard renders with API data (kills/wins)
- Test empty state renders when no data
- Test error state renders appropriately

### 6.4 Integration Tests

- Test full flow: backend seeds → API returns → frontend displays
- Test Docker Compose with volume mounts
- Test both backends produce consistent data

### 6.5 Agent Assignment

```
@testing_agent create tests for Java DataInitializer and extended entity
@testing_agent create tests for Go seed function and extended model
@testing_agent create frontend tests for leaderboard with new fields and empty state
```

---

## Phase 7: Validation & Deployment (0.5 days)

### 7.1 Local Validation Checklist

- [ ] `docker-compose up` starts all services
- [ ] Java backend seeds data on first start
- [ ] Go backend seeds data on first start
- [ ] Both backends return identical data for same player
- [ ] Frontend displays kills/wins columns correctly
- [ ] Frontend shows empty state when database is cleared
- [ ] Data persists across container restarts

### 7.2 Smoke Test Script

```bash
#!/bin/bash
# test-migration.sh

echo "Testing Java backend..."
curl -s http://localhost:8080/api/scores/game/Operation%20Nightfall/top?limit=3 | jq '.[] | {player: .playerName, kills, wins}'

echo "Testing Go backend..."
curl -s http://localhost:8081/api/scores/game/Operation%20Nightfall/top?limit=3 | jq '.[] | {player: .playerName, kills, wins}'

echo "Comparing outputs..."
# Both should return identical data
```

### 7.3 Agent Assignment

```
@testing_agent create integration test script for migration validation
@docker_agent verify docker-compose configuration and volume mounts
```

---

## Rollback Plan

If issues are discovered:

1. **Frontend rollback**: Revert Leaderboard.tsx to include fallbackData
2. **Backend rollback**: Comment out DataInitializer, revert entity changes
3. **Database rollback**: Delete SQLite file, revert to H2 configuration

---

## File Change Summary

| File | Action | Phase |
|------|--------|-------|
| `shared/seed-data.json` | Create | 1 |
| `java-spring-boot-backend/.../GameScore.java` | Modify | 2 |
| `go-backend/models/game_score.go` | Modify | 2 |
| `java-spring-boot-backend/build.gradle` | Modify | 3 |
| `java-spring-boot-backend/.../application.properties` | Modify | 3 |
| `java-spring-boot-backend/.../DataInitializer.java` | Create | 4 |
| `go-backend/models/db.go` | Modify | 4 |
| `docker-compose.yml` | Modify | 3, 4 |
| `frontend/src/app/api/types.ts` | Modify | 5 |
| `frontend/src/app/components/Leaderboard.tsx` | Modify | 5 |

---

## Next Steps

1. Review this plan with the team
2. Execute using agents per `AGENTIC_WORKFLOW_LEADERBOARD.md`
3. Track progress in `SPRINT_BACKLOG_LEADERBOARD.md`
