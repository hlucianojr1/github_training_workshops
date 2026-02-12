# Workshop 3: Advanced Web Development with GitHub Copilot

**Duration**: 90 minutes  
**Format**: Live coding demonstrations  
**Audience**: Developers proficient with Copilot prompting (completed Workshops 1-2)  
**Prerequisites**: Experience with explicit prompting, few-shot learning, Spring Boot/React patterns  
**IDE**: IntelliJ IDEA with GitHub Copilot Plugin

---

## Learning Objectives

By the end of this workshop, you will master these **9 advanced Copilot techniques**:

1. **Chain-of-Thought Prompting** - Break complex features into logical reasoning steps
2. **Instruction Files** - Customize `.github/copilot-instructions.md` with project-specific rules
3. **Prompt Files** - Create reusable `.prompt.md` files for consistent code generation
4. **Copilot Code Review** - Use Copilot to review PRs, identify issues, and suggest fixes
5. **Copilot Plan Mode** - Architect multi-step solutions before implementation
6. **Copilot Coding Agent** - Delegate autonomous multi-file tasks to Copilot agents
7. **Copilot Agent HQ** - Manage and orchestrate custom agents for specialized workflows
8. **Architecture & Tech Stack Generation** - Generate project scaffolding and tech decisions
9. **Customize Copilot** - Configure Copilot settings for optimal project-specific behavior

---

## Project Context: High Scores Demo

This workshop uses the **High Scores Demo** - a full-stack game leaderboard application:

| Layer | Technology | Location |
|-------|------------|----------|
| **Frontend** | React 18 + Vite + TypeScript + Tailwind CSS 4 | `frontend/` |
| **Backend** | Java 21 + Spring Boot 3.5 REST API | `java-spring-boot-backend/` |
| **Infrastructure** | Terraform modules for Kubernetes | `terraform/` |
| **Database** | H2 (dev) / PostgreSQL (prod) | Configured via profiles |

### Key Files Reference
- Backend Controller: `java-spring-boot-backend/src/main/java/com/insight/ai_demo/controller/GameScoreController.java`
- Frontend API: `frontend/src/app/api/scoreService.ts`
- Types: `frontend/src/app/api/types.ts`
- Instructions: `.github/copilot-instructions.md`

---

## Workshop Agenda

| Time | Demo | Topic | Focus Files |
|------|------|-------|-------------|
| 0-10 min | Demo 1 | Chain-of-Thought Prompting | `GameScoreController.java` |
| 10-20 min | Demo 2 | Instruction Files | `.github/copilot-instructions.md` |
| 20-30 min | Demo 3 | Prompt Files | `.github/prompts/*.prompt.md` |
| 30-40 min | Demo 4 | Copilot Code Review | Pull Request review |
| 40-55 min | Demo 5 | Copilot Plan Mode | Test mocking strategy |
| 55-70 min | Demo 6 | Copilot Coding Agent | Multi-file refactoring |
| 70-80 min | Demo 7 | Copilot Agent HQ | Custom agent creation |
| 80-85 min | Demo 8 | Architecture & Tech Stack Generation | New microservice scaffolding |
| 85-90 min | Demo 9 | Customize Copilot | IntelliJ Copilot settings |

---

## Demo 1: Chain-of-Thought Prompting (10 min)

### Objective
Learn to decompose complex features into step-by-step reasoning chains that guide Copilot toward correct solutions.

### Scenario
Implement a score analytics endpoint that calculates player statistics across multiple games.

### IntelliJ Setup
1. Open IntelliJ IDEA
2. Ensure GitHub Copilot plugin is installed: **Settings → Plugins → GitHub Copilot**
3. Open the Copilot Chat tool window: **View → Tool Windows → GitHub Copilot Chat**

### Live Coding Steps

**Step 1: Write chain-of-thought prompt in GameScoreService.java**

Open `java-spring-boot-backend/src/main/java/com/insight/ai_demo/service/GameScoreService.java` and add this comment block:

```java
// In GameScoreService.java, add this Chain-of-Thought comment:

/**
 * CHAIN OF THOUGHT: Calculate comprehensive player analytics
 * 
 * Step 1: Identify requirements
 * - Accept playerName parameter
 * - Return: totalGamesPlayed, totalScore, averageScore, highestScore, favoriteGame
 * 
 * Step 2: Define return type
 * - Create PlayerAnalytics record/DTO with calculated fields
 * - All numeric fields should be primitive types (avoid nulls)
 * 
 * Step 3: Query strategy
 * - Get all scores for player using existing repository methods
 * - Group by gameName to count games played
 * - Calculate aggregates: sum, avg, max
 * 
 * Step 4: Determine favorite game
 * - Find game with highest total score for this player
 * - Or game with most entries (plays)
 * 
 * Step 5: Handle edge cases
 * - Player not found → return empty analytics with zeros
 * - No scores → return analytics with default values
 * 
 * Now implement:
 */
```

**Step 2: Let Copilot generate based on the chain**

Position your cursor after the comment and press **Tab** to accept Copilot suggestions:

```java
// Copilot should generate following the chain-of-thought:
public record PlayerAnalytics(
    String playerName,
    int totalGamesPlayed,
    long totalScore,
    double averageScore,
    long highestScore,
    String favoriteGame
) {}

public PlayerAnalytics getPlayerAnalytics(String playerName) {
    log.info("Calculating analytics for player: {}", playerName);
    
    // Step 3: Query all scores for player
    List<GameScore> allScores = gameScoreRepository.findByPlayerNameOrderByScoreDesc(playerName);
    
    if (allScores.isEmpty()) {
        // Step 5: Handle no scores case
        return new PlayerAnalytics(playerName, 0, 0L, 0.0, 0L, "N/A");
    }
    
    // Step 3: Calculate aggregates
    long totalScore = allScores.stream().mapToLong(GameScore::getScore).sum();
    double averageScore = allScores.stream().mapToLong(GameScore::getScore).average().orElse(0.0);
    long highestScore = allScores.stream().mapToLong(GameScore::getScore).max().orElse(0L);
    
    // Step 4: Determine favorite game (most plays)
    Map<String, Long> gamePlayCounts = allScores.stream()
        .collect(Collectors.groupingBy(GameScore::getGameName, Collectors.counting()));
    
    String favoriteGame = gamePlayCounts.entrySet().stream()
        .max(Map.Entry.comparingByValue())
        .map(Map.Entry::getKey)
        .orElse("N/A");
    
    return new PlayerAnalytics(
        playerName,
        gamePlayCounts.size(),
        totalScore,
        averageScore,
        highestScore,
        favoriteGame
    );
}
```

### Teaching Points

| Chain-of-Thought Formula | Example |
|-------------------------|---------|
| Step 1: Requirements | Inputs, outputs, constraints |
| Step 2: Data model | DTO/record definitions |
| Step 3: Query strategy | Repository methods, data access |
| Step 4: Business logic | Calculations, transformations |
| Step 5: Edge cases | Null handling, empty states |

**When to Use**: Multi-step features, aggregation logic, complex algorithms  
**Avoid**: Simple CRUD operations, straightforward getters/setters

---

### Additional Chain-of-Thought Examples (Sprint Backlog)

The following examples are derived from real sprint tasks in [SPRINT_BACKLOG_LEADERBOARD.md](../SPRINT_BACKLOG_LEADERBOARD.md). They demonstrate progressive complexity levels for chain-of-thought prompting.

---

### Example 2: Data Model Extension (Single-Layer)

**Sprint Reference**: US-1 (Extend Game Score Data Model), Tasks T-1.1 and T-1.2

**Scenario**: Add `kills` and `wins` statistics to the GameScore entity in both Java and Go backends.

#### Java Implementation (T-1.1)

**Step 1: Write chain-of-thought prompt in `GameScore.java`**

```java
// In java-spring-boot-backend/src/main/java/com/insight/ai_demo/entity/GameScore.java

/**
 * CHAIN OF THOUGHT: Add kills and wins fields to GameScore entity
 *
 * Step 1: Identify requirements (from US-1)
 * - Add kills: Integer field tracking total kills
 * - Add wins: Integer field tracking total wins
 * - Both fields should have sensible defaults (0)
 * - Fields are optional for backward compatibility
 *
 * Step 2: Define field constraints
 * - kills: non-negative integer, default 0
 * - wins: non-negative integer, default 0
 * - Use @Column with columnDefinition for default value
 *
 * Step 3: Update constructors
 * - Existing constructors should still work (backward compatible)
 * - Add new constructor accepting kills/wins
 * - Lombok @AllArgsConstructor will auto-update
 *
 * Step 4: Consider API impact
 * - JSON serialization will include new fields automatically
 * - Frontend types.ts needs matching update (T-1.4)
 * - Existing API consumers receive new fields with defaults
 *
 * Step 5: Database migration
 * - JPA will auto-create columns with ddl-auto=update
 * - For production: create migration script
 *
 * Now implement the new fields:
 */
```

**Step 2: Let Copilot generate the fields**

```java
// Copilot should generate following the chain-of-thought:

@Column(nullable = false, columnDefinition = "INTEGER DEFAULT 0")
private Integer kills = 0;

@Column(nullable = false, columnDefinition = "INTEGER DEFAULT 0")
private Integer wins = 0;
```

#### Go Implementation (T-1.2)

**Step 1: Write chain-of-thought prompt in `game_score.go`**

```go
// In go-backend/models/game_score.go

// CHAIN OF THOUGHT: Add Kills and Wins fields to GameScore model
//
// Step 1: Identify requirements (from US-1)
// - Add Kills: int field tracking total kills
// - Add Wins: int field tracking total wins
// - Use gorm tags for database mapping
// - Use json tags for API serialization
//
// Step 2: Define GORM constraints
// - Both fields: not null, default 0
// - gorm tag: `gorm:"not null;default:0"`
// - json tag: `json:"kills"` and `json:"wins"`
//
// Step 3: Update ScoreResponse DTO
// - Add Kills and Wins to ScoreResponse struct
// - Update ToResponse() method to map new fields
//
// Step 4: Maintain API contract compatibility
// - Field names must match frontend types.ts expectations
// - Use camelCase in JSON (kills, wins) not snake_case
//
// Now implement the new fields:
```

**Step 2: Let Copilot generate the Go implementation**

```go
// In GameScore struct, Copilot generates:
Kills int `gorm:"not null;default:0" json:"kills"`
Wins  int `gorm:"not null;default:0" json:"wins"`

// In ScoreResponse struct:
Kills int `json:"kills"`
Wins  int `json:"wins"`

// Update ToResponse method:
func (g *GameScore) ToResponse() ScoreResponse {
    return ScoreResponse{
        ID:         g.ID,
        PlayerName: g.PlayerName,
        GameName:   g.GameName,
        Score:      g.Score,
        Kills:      g.Kills,
        Wins:       g.Wins,
        AchievedAt: g.AchievedAt.Format(time.RFC3339),
        CreatedAt:  g.CreatedAt.Format(time.RFC3339),
    }
}
```

> **🎯 Try this prompt:**
>
> ```
> Context: High Scores Demo, Java 21 + Spring Boot 3.5, editing GameScore.java entity
> Goal: Add kills and wins integer fields to track player combat statistics
> Constraints: Use Lombok annotations, fields must have default value of 0, maintain backward compatibility with existing API consumers
> Example: Existing score field uses @Column(nullable = false) and Long type
> Request: Add kills and wins fields with proper JPA annotations and defaults, then show the equivalent Go implementation for game_score.go
> ```

---

### Example 3: Seed Data Initializer (Two-Layer)

**Sprint Reference**: US-3 (Canonical Seed Data System), Tasks T-3.2 and T-3.3

**Scenario**: Create a DataInitializer component that reads from `shared/seed-data.json` and persists scores to the database on startup. This involves two layers: JSON file parsing and repository persistence.

#### Java Implementation (T-3.2)

**Step 1: Write chain-of-thought prompt for DataInitializer.java**

```java
// Create new file: java-spring-boot-backend/src/main/java/com/insight/ai_demo/config/DataInitializer.java

/**
 * CHAIN OF THOUGHT: Create seed data initializer from JSON file
 *
 * Step 1: Define component requirements
 * - Spring @Component that runs on application startup
 * - Implements CommandLineRunner or ApplicationRunner
 * - Reads from shared/seed-data.json (canonical source)
 * - Only seeds if database is empty (idempotent)
 *
 * Step 2: Design JSON parsing layer
 * - Define SeedData record to match JSON structure
 * - Define SeedScore record for individual scores
 * - Use Jackson ObjectMapper for parsing
 * - Handle file not found gracefully (log warning, don't fail)
 *
 * Step 3: Design persistence layer
 * - Check if gameScoreRepository.count() == 0
 * - If empty: parse JSON, map to GameScore entities, saveAll
 * - If not empty: skip seeding, log info message
 *
 * Step 4: Map JSON fields to entity
 * - playerName → playerName
 * - gameName → gameName
 * - score → score (Long)
 * - kills → kills (Integer, new field from US-1)
 * - wins → wins (Integer, new field from US-1)
 * - achievedAt → generate timestamp (not in seed JSON)
 *
 * Step 5: Error handling and logging
 * - Log seed count on success
 * - Log skip message if data exists
 * - Log warning if file missing (don't throw)
 * - Wrap in try-catch for resilience
 *
 * Now implement:
 */
```

**Step 2: Copilot generates the implementation**

```java
package com.insight.ai_demo.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.insight.ai_demo.entity.GameScore;
import com.insight.ai_demo.repository.GameScoreRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final GameScoreRepository gameScoreRepository;
    private final ObjectMapper objectMapper;

    // Step 2: JSON structure records
    record SeedScore(String playerName, String gameName, Long score, Integer kills, Integer wins) {}
    record SeedData(String version, List<SeedScore> scores) {}

    @Override
    public void run(String... args) {
        // Step 3: Check if seeding needed
        if (gameScoreRepository.count() > 0) {
            log.info("Database already contains {} scores, skipping seed", gameScoreRepository.count());
            return;
        }

        try {
            // Step 2: Parse JSON file
            InputStream inputStream = new ClassPathResource("seed-data.json").getInputStream();
            SeedData seedData = objectMapper.readValue(inputStream, SeedData.class);

            // Step 4: Map to entities and save
            List<GameScore> scores = seedData.scores().stream()
                .map(this::mapToEntity)
                .toList();

            gameScoreRepository.saveAll(scores);
            log.info("Seeded {} scores from seed-data.json (version {})", scores.size(), seedData.version());

        } catch (Exception e) {
            // Step 5: Graceful error handling
            log.warn("Could not load seed data: {}. Starting with empty database.", e.getMessage());
        }
    }

    private GameScore mapToEntity(SeedScore seed) {
        GameScore score = new GameScore();
        score.setPlayerName(seed.playerName());
        score.setGameName(seed.gameName());
        score.setScore(seed.score());
        score.setKills(seed.kills() != null ? seed.kills() : 0);
        score.setWins(seed.wins() != null ? seed.wins() : 0);
        score.setAchievedAt(LocalDateTime.now());
        return score;
    }
}
```

#### Go Implementation (T-3.3)

**Step 1: Write chain-of-thought prompt for seed.go**

```go
// Create new file: go-backend/internal/storage/seed.go

// CHAIN OF THOUGHT: Create seed data loader from JSON file
//
// Step 1: Define function requirements
// - Function SeedDatabase(db *gorm.DB) error
// - Reads from shared/seed-data.json
// - Only seeds if table is empty (idempotent)
// - Called from main.go after DB init
//
// Step 2: Design JSON parsing layer
// - Define SeedData struct matching JSON structure
// - Define SeedScore struct for individual scores
// - Use encoding/json for parsing
// - Use os.ReadFile to load file
//
// Step 3: Design persistence layer
// - Query: db.Model(&GameScore{}).Count(&count)
// - If count == 0: parse JSON, create records
// - If count > 0: return early with log message
//
// Step 4: Map JSON fields to model
// - playerName → PlayerName
// - gameName → GameName
// - score → Score (int64)
// - kills → Kills (int)
// - wins → Wins (int)
// - achievedAt → time.Now()
//
// Step 5: Error handling
// - Return nil on success or skip
// - Return wrapped error on failure
// - Use structured logging with request context
//
// Now implement:
```

**Step 2: Copilot generates the Go implementation**

```go
package storage

import (
    "encoding/json"
    "fmt"
    "log/slog"
    "os"
    "time"

    "github.com/your-org/high-scores-demo/go-backend/models"
    "gorm.io/gorm"
)

// Step 2: JSON structure types
type SeedScore struct {
    PlayerName string `json:"playerName"`
    GameName   string `json:"gameName"`
    Score      int64  `json:"score"`
    Kills      int    `json:"kills"`
    Wins       int    `json:"wins"`
}

type SeedData struct {
    Version string      `json:"version"`
    Scores  []SeedScore `json:"scores"`
}

// SeedDatabase loads initial data from seed-data.json if database is empty
func SeedDatabase(db *gorm.DB, seedFilePath string) error {
    // Step 3: Check if seeding needed
    var count int64
    if err := db.Model(&models.GameScore{}).Count(&count).Error; err != nil {
        return fmt.Errorf("failed to count existing scores: %w", err)
    }

    if count > 0 {
        slog.Info("Database already seeded", "existingScores", count)
        return nil
    }

    // Step 2: Parse JSON file
    data, err := os.ReadFile(seedFilePath)
    if err != nil {
        slog.Warn("Seed file not found, starting with empty database", "path", seedFilePath, "error", err)
        return nil // Graceful handling - don't fail startup
    }

    var seedData SeedData
    if err := json.Unmarshal(data, &seedData); err != nil {
        return fmt.Errorf("failed to parse seed data: %w", err)
    }

    // Step 4: Map to models and insert
    scores := make([]models.GameScore, len(seedData.Scores))
    for i, s := range seedData.Scores {
        scores[i] = models.GameScore{
            PlayerName: s.PlayerName,
            GameName:   s.GameName,
            Score:      s.Score,
            Kills:      s.Kills,
            Wins:       s.Wins,
            AchievedAt: time.Now(),
        }
    }

    if err := db.CreateInBatches(scores, 100).Error; err != nil {
        return fmt.Errorf("failed to seed scores: %w", err)
    }

    slog.Info("Database seeded successfully", "count", len(scores), "version", seedData.Version)
    return nil
}
```

> **🎯 Try this prompt:**
>
> ```
> Context: High Scores Demo, Java Spring Boot backend, need to create DataInitializer.java in config package
> Goal: Create a startup component that seeds the database from shared/seed-data.json containing 20 scores with playerName, gameName, score, kills, and wins fields
> Constraints: Must be idempotent (skip if data exists), use Lombok @RequiredArgsConstructor and @Slf4j, handle missing file gracefully without failing startup, use Jackson for JSON parsing
> Example: seed-data.json structure: {"version":"1.0.0","scores":[{"playerName":"GhostReaper","gameName":"Operation Nightfall","score":145820,"kills":2847,"wins":156}]}
> Request: Implement DataInitializer as CommandLineRunner that checks repository count, parses JSON, maps to GameScore entities, and saves all. Then show equivalent Go implementation using gorm.
> ```

---

### Example 4: Full-Stack Migration (Multi-Layer)

**Sprint Reference**: US-4 (Remove Frontend Hardcoded Data), Tasks T-4.1, T-4.2, T-4.3

**Scenario**: Remove hardcoded fallback data from the frontend Leaderboard component, update TypeScript types to include `kills`/`wins`, and implement a proper empty state UI. This spans three layers: TypeScript types, React component state, and UI rendering.

#### Multi-Layer Chain-of-Thought

**Step 1: Write comprehensive chain-of-thought spanning all layers**

```typescript
// CHAIN OF THOUGHT: Full-stack migration to remove fallback data
//
// === LAYER 1: TypeScript Types (frontend/src/app/api/types.ts) ===
//
// Step 1.1: Update LeaderboardEntry interface
// - Current: { rank, player, score, kills?, wins? }
// - Target: Make kills and wins required (not optional)
// - Reason: Backend now always provides these fields (US-1 complete)
//
// Step 1.2: Verify ScoreResponse alignment
// - Backend returns: id, playerName, gameName, score, kills, wins, achievedAt, createdAt
// - Frontend ScoreResponse must match exactly
// - Add kills: number and wins: number if missing
//
// === LAYER 2: Data Conversion (convertToLeaderboardEntries) ===
//
// Step 2.1: Update conversion function
// - Input: ScoreResponse[] from API
// - Output: LeaderboardEntry[] for display
// - Map: playerName → player, include kills/wins directly
// - Add rank based on array index + 1
//
// Step 2.2: Remove fallback data reference
// - Delete: const fallbackData = [...]
// - Delete: any useFallback or setUsingFallback logic
// - Delete: warning banner about demo data
//
// === LAYER 3: React Component State (Leaderboard.tsx) ===
//
// Step 3.1: Update state management
// - Remove: usingFallback state variable
// - Keep: scores, loading, error states
// - Add: isEmpty derived state (scores.length === 0 && !loading)
//
// Step 3.2: Implement empty state UI
// - Show when: !loading && !error && scores.length === 0
// - Display: Trophy icon + "No scores yet" message
// - Style: Centered, muted colors, consistent with app theme
//
// Step 3.3: Update score rendering
// - Remove conditional fallback rendering
// - Render kills and wins from actual data
// - Handle: entry.kills.toLocaleString() safely
//
// === LAYER 4: Error Boundary ===
//
// Step 4.1: Improve error handling
// - API error → Show error message with retry button
// - Empty data → Show empty state (not error)
// - Loading → Show skeleton/spinner
//
// Now implement layer by layer:
```

#### Layer 1: TypeScript Types Update

```typescript
// In frontend/src/app/api/types.ts

// Update ScoreResponse to include kills and wins
export interface ScoreResponse {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  kills: number;      // Added: combat statistics
  wins: number;       // Added: victory count
  achievedAt: string;
  createdAt: string;
}

// Update LeaderboardEntry - make kills/wins required
export interface LeaderboardEntry {
  rank: number;
  player: string;
  score: number;
  kills: number;   // Changed from optional to required
  wins: number;    // Changed from optional to required
}
```

#### Layer 2: Conversion Function Update

```typescript
// In frontend/src/app/components/Leaderboard.tsx or utils

// BEFORE (with fallback):
const convertToLeaderboardEntries = (scores: ScoreResponse[]): LeaderboardEntry[] => {
  if (!scores || scores.length === 0) {
    return fallbackData; // ❌ REMOVE THIS
  }
  return scores.map((score, index) => ({
    rank: index + 1,
    player: score.playerName,
    score: score.score,
    kills: score.kills,
    wins: score.wins,
  }));
};

// AFTER (clean implementation):
const convertToLeaderboardEntries = (scores: ScoreResponse[]): LeaderboardEntry[] => {
  return scores.map((score, index) => ({
    rank: index + 1,
    player: score.playerName,
    score: score.score,
    kills: score.kills,
    wins: score.wins,
  }));
};
```

#### Layer 3: React Component with Empty State

```tsx
// In frontend/src/app/components/Leaderboard.tsx

import { Trophy, AlertCircle, RefreshCw } from 'lucide-react';

// Remove these:
// ❌ const fallbackData = [...];
// ❌ const [usingFallback, setUsingFallback] = useState(false);

// Empty State Component
const EmptyState = () => (
  <div className="flex flex-col items-center justify-center py-12 text-center">
    <Trophy className="h-16 w-16 text-gray-400 mb-4" />
    <h3 className="text-lg font-medium text-gray-900">No scores yet</h3>
    <p className="mt-2 text-sm text-gray-500">
      Be the first to submit a high score!
    </p>
  </div>
);

// Updated Leaderboard component render
const Leaderboard: React.FC<LeaderboardProps> = ({ gameName }) => {
  const [scores, setScores] = useState<LeaderboardEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Derived state
  const isEmpty = !loading && !error && scores.length === 0;

  // ... fetch logic ...

  if (loading) {
    return <LoadingSpinner />;
  }

  if (error) {
    return (
      <div className="flex flex-col items-center py-8">
        <AlertCircle className="h-12 w-12 text-red-400 mb-4" />
        <p className="text-red-600">{error}</p>
        <button onClick={refetch} className="mt-4 flex items-center gap-2">
          <RefreshCw className="h-4 w-4" /> Retry
        </button>
      </div>
    );
  }

  if (isEmpty) {
    return <EmptyState />;
  }

  // Render actual scores - kills/wins now guaranteed
  return (
    <table className="w-full">
      <thead>
        <tr>
          <th>Rank</th>
          <th>Player</th>
          <th>Score</th>
          <th>Kills</th>
          <th>Wins</th>
        </tr>
      </thead>
      <tbody>
        {scores.map((entry) => (
          <tr key={entry.rank}>
            <td>{entry.rank}</td>
            <td>{entry.player}</td>
            <td>{entry.score.toLocaleString()}</td>
            <td>{entry.kills.toLocaleString()}</td>
            <td>{entry.wins.toLocaleString()}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};
```

> **🎯 Try this prompt:**
>
> ```
> Context: High Scores Demo frontend, React 18 + TypeScript + Tailwind CSS, working across types.ts and Leaderboard.tsx
> Goal: Remove hardcoded fallbackData from Leaderboard component, update types to require kills/wins fields, and implement empty state UI with trophy icon
> Constraints: Must not break existing functionality, use lucide-react for icons, follow existing Tailwind patterns, handle loading/error/empty states distinctly
> Example: Current LeaderboardEntry has optional kills?: number and wins?: number, and component falls back to hardcoded data when API returns empty
> Request: 1) Update ScoreResponse and LeaderboardEntry interfaces to require kills and wins. 2) Remove fallbackData array and usingFallback state. 3) Create EmptyState component with Trophy icon and "No scores yet" message. 4) Update Leaderboard render logic to show EmptyState when scores array is empty.
> ```

---

### Chain-of-Thought Complexity Mapping

Use this table to determine the appropriate chain-of-thought depth based on your task:

| Complexity Level | Sprint Story Type | Chain Steps | Layers Involved | Example |
|-----------------|-------------------|-------------|-----------------|---------|
| **Single-Layer** | Data model changes | 3-5 steps | Entity/Model only | US-1: Add kills/wins fields |
| **Two-Layer** | Persistence features | 5-7 steps | Service + Repository | US-3: Seed data initializer |
| **Multi-Layer** | Full-stack migration | 7-10 steps | Frontend + Backend + DB | US-4: Remove fallback data |
| **Cross-Service** | API contract changes | 5-8 steps | Multiple backends | US-1 T-1.3: DTO alignment |

**Guidelines for Choosing Depth**:

1. **Single-Layer**: Use when changes are isolated to one file or one concern
   - Adding fields to an entity
   - Creating a new DTO/record
   - Simple refactoring

2. **Two-Layer**: Use when changes span data access and business logic
   - New service methods with repository queries
   - Data import/export features
   - Caching implementations

3. **Multi-Layer**: Use when changes touch UI, API, and persistence
   - Feature migrations
   - Breaking change rollouts
   - Full vertical slices

4. **Cross-Service**: Use when changes must be synchronized across services
   - API contract updates (Java + Go)
   - Shared data format changes
   - Event schema modifications

---

## Demo 2: Instruction Files (10 min)

### Objective
Customize `.github/copilot-instructions.md` with project-specific rules that Copilot automatically follows.

### Scenario
Add rules to enforce High Scores Demo coding standards: Lombok usage, pagination patterns, and DTO conventions.

### IntelliJ Navigation
1. Open Project view: **View → Tool Windows → Project**
2. Navigate to `.github/copilot-instructions.md`
3. IntelliJ + Copilot will automatically read this file for context

### Live Coding Steps

**Step 1: Add Lombok enforcement rule**
```markdown
<!-- In .github/copilot-instructions.md, add: -->

### 🚨 CRITICAL: Lombok Usage in Java Classes

**Rule**: All Java classes MUST use Lombok annotations. Never write boilerplate code.

```java
// ❌ WRONG - Manual boilerplate
public class GameScore {
    private Long id;
    private String playerName;
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    // ... 20 more lines of getters/setters
}

// ✅ CORRECT - Lombok annotations
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GameScore {
    private Long id;
    private String playerName;
}
```

**Required Lombok annotations by class type:**
- **Entities**: `@Data`, `@NoArgsConstructor`, `@AllArgsConstructor`
- **Services/Controllers**: `@RequiredArgsConstructor`, `@Slf4j`
- **DTOs**: `@Data` or use Java records
```

**Step 2: Add pagination pattern rule**
```markdown
### 🚨 API Pattern: Paginated Responses

**Rule**: All list endpoints MUST return paginated responses with metadata.

```java
// ❌ WRONG - Returning raw list
@GetMapping("/scores")
public List<ScoreResponse> getAllScores() { }

// ✅ CORRECT - Return Map with pagination metadata
@GetMapping("/scores")
public ResponseEntity<Map<String, Object>> getAllScores(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
    
    Page<GameScore> scores = service.getScores(page, size);
    
    Map<String, Object> response = Map.of(
        "scores", scores.getContent(),
        "totalElements", scores.getTotalElements(),
        "totalPages", scores.getTotalPages(),
        "currentPage", page,
        "hasNext", scores.hasNext()
    );
    
    return ResponseEntity.ok(response);
}
```
```

**Step 3: Add TypeScript ApiResponse rule**
```markdown
### 🚨 Frontend: API Response Wrapper

**Rule**: All API calls MUST use the `ApiResponse<T>` wrapper for consistent error handling.

```typescript
// ❌ WRONG - Direct fetch without wrapper
const response = await fetch('/api/scores');
const data = await response.json();

// ✅ CORRECT - Use typed service functions
import { getTopScores, type ScoreResponse } from '@/app/api';

const response = await getTopScores(gameName, 10);
if (response.error) {
    // Handle error gracefully
    setUsingFallback(true);
} else {
    setScores(response.data);
}
```
```

### Verification in IntelliJ

```java
// Create a new file and type: "Create endpoint for player scores"
// Copilot should now:
// 1. Use @RequiredArgsConstructor instead of manual constructor
// 2. Return Map<String, Object> with pagination
// 3. Include page/size parameters
```

### Teaching Points

| Instruction Rule | Format |
|-----------------|--------|
| Critical rule | Use 🚨 emoji prefix |
| Examples | Show ❌ WRONG and ✅ CORRECT |
| Specificity | Include exact patterns and annotations |
| Context | Reference existing project files |

---

## Demo 3: Prompt Files (10 min)

### Objective
Create reusable `.prompt.md` files for consistent code generation patterns across the team.

### Scenario
Create prompt files for generating Spring Boot endpoints and React components that follow High Scores Demo conventions.

### IntelliJ Setup

**Step 1: Create prompt file directory**
In IntelliJ Terminal (**View → Tool Windows → Terminal**):
```bash
mkdir -p .github/prompts
```

**Step 2: Create Spring Boot endpoint prompt**

Create file `.github/prompts/spring-endpoint.prompt.md`:

```markdown
# Spring Boot Endpoint Generator

Generate a Spring Boot REST endpoint following High Scores Demo conventions.

## Requirements
- Use `@RequiredArgsConstructor` for dependency injection (Lombok)
- Use `@Slf4j` for logging
- Return `ResponseEntity<>` for all responses
- Use Jakarta validation on request bodies (`@Valid`)
- Paginated endpoints return `Map<String, Object>` with metadata

## Template
```java
package com.insight.ai_demo.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/{{resource}}")
@RequiredArgsConstructor
@Slf4j
public class {{ResourceName}}Controller {

    private final {{ResourceName}}Service {{resourceName}}Service;

    /**
     * {{Description}}
     */
    @{{HttpMethod}}Mapping("{{path}}")
    public ResponseEntity<{{ReturnType}}> {{methodName}}(
            {{parameters}}) {
        log.info("{{logMessage}}");
        
        // Implementation
        return ResponseEntity.ok(result);
    }
}
```

## Checklist
- [ ] Uses Lombok `@RequiredArgsConstructor` and `@Slf4j`
- [ ] Has proper logging at method entry
- [ ] Returns `ResponseEntity<>`
- [ ] Includes JSDoc-style Javadoc
- [ ] Paginated endpoints include metadata map
```

**Step 3: Create React component prompt**

Create file `.github/prompts/react-component.prompt.md`:

```markdown
# React Component Generator

Generate a typed React functional component following High Scores Demo conventions.

## Requirements
- Define props interface (exported)
- Use TypeScript strict types (NO `any`)
- Use path alias `@/` for imports
- Use `ApiResponse<T>` wrapper for API calls
- Include loading and error states
- Provide fallback data when API unavailable

## Template
```typescript
import { useState, useEffect } from 'react';
import { Loader2, AlertCircle } from 'lucide-react';
import { {{apiFunction}}, type {{ResponseType}} } from '@/app/api';

interface {{ComponentName}}Props {
  // Define typed props here
}

export function {{ComponentName}}({ prop1, prop2 }: {{ComponentName}}Props) {
  const [data, setData] = useState<{{DataType}}[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchData() {
      setLoading(true);
      const response = await {{apiFunction}}();
      
      if (response.error) {
        setError(response.error);
        // Use fallback data
      } else {
        setData(response.data);
      }
      setLoading(false);
    }
    fetchData();
  }, []);

  if (loading) {
    return <Loader2 className="animate-spin" />;
  }

  return (
    <div className="{{tailwindClasses}}">
      {/* Component JSX */}
    </div>
  );
}

export default {{ComponentName}};
```

## Checklist
- [ ] Props interface is exported
- [ ] All props have explicit types
- [ ] No `any` types anywhere
- [ ] Uses `@/` path alias
- [ ] Includes loading state
- [ ] Has error handling with fallback
```

**Step 4: Use prompt file in IntelliJ Copilot Chat**

Open Copilot Chat and type:
```
Using the template in .github/prompts/spring-endpoint.prompt.md, 
create a new endpoint to get game statistics (total players, 
total scores, average score) for a specific game.
```

### Teaching Points

| Prompt File Element | Purpose |
|--------------------|---------|
| Requirements section | Enforces project rules |
| Template section | Provides code structure |
| Checklist section | Verification criteria |
| Placeholders `{{}}` | Dynamic substitution |

---

## Demo 4: Copilot Code Review (10 min)

### Objective
Use Copilot to review code, identify issues, and suggest improvements within IntelliJ.

### Scenario
Review a hypothetical PR that adds a new batch score submission feature.

### IntelliJ Copilot Code Review

**Step 1: Select code for review**

In IntelliJ, select the code block you want to review, then:
- Right-click → **GitHub Copilot → Explain This**
- Or use Copilot Chat: **⌘+Shift+I** (Mac) / **Ctrl+Shift+I** (Windows)

**Step 2: Invoke Copilot Code Review in Chat**

```
Review the following code for the High Scores Demo project:
1. Security vulnerabilities (SQL injection, validation)
2. Missing Lombok annotations
3. Pagination pattern compliance
4. Error handling gaps
5. Test coverage needs

```java
// Proposed new endpoint in GameScoreController.java
@PostMapping("/batch")
public ResponseEntity<List<ScoreResponse>> submitBatchScores(
        @RequestBody List<ScoreSubmissionRequest> requests) {
    
    List<GameScore> savedScores = new ArrayList<>();
    for (ScoreSubmissionRequest request : requests) {
        GameScore score = new GameScore();
        score.setPlayerName(request.getPlayerName());
        score.setGameName(request.getGameName());
        score.setScore(request.getScore());
        savedScores.add(gameScoreRepository.save(score));
    }
    
    return ResponseEntity.ok(savedScores.stream()
        .map(ScoreResponse::new)
        .toList());
}
```

**Step 3: Copilot Review Output**

```markdown
## Code Review: Batch Score Submission

### 🔴 Critical Issues

**1. Missing `@Valid` Annotation** (Line 2)
```java
// ❌ Current - No validation
@RequestBody List<ScoreSubmissionRequest> requests

// ✅ Fix - Add validation
@RequestBody @Valid List<@Valid ScoreSubmissionRequest> requests
```

**2. Missing `@Transactional`** (Method level)
Batch operations should be atomic - if one fails, all should rollback.
```java
// ✅ Add to method or move logic to service
@Transactional
public List<GameScore> submitBatchScores(List<ScoreSubmissionRequest> requests)
```

**3. No Batch Size Limit** (Security)
```java
// ❌ Current - Unbounded batch size (DoS risk)

// ✅ Fix - Add limit
if (requests.size() > 100) {
    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, 
        "Batch size cannot exceed 100");
}
```

### 🟡 Warnings

**4. Should Use Service Layer**
```java
// ❌ Current - Controller directly uses repository
savedScores.add(gameScoreRepository.save(score));

// ✅ Move to GameScoreService
List<GameScore> savedScores = gameScoreRepository.saveAll(scoresToSave);
```

**5. Missing Logging**
```java
// ✅ Add logging
log.info("Received batch submission with {} scores", requests.size());
```

### 🟢 Suggestions

**6. Use `saveAll()` for Efficiency**
```java
// ❌ Current - N+1 saves
for (...) { gameScoreRepository.save(score); }

// ✅ Batch save
List<GameScore> savedScores = gameScoreRepository.saveAll(scoresToSave);
```

### Summary
- 3 critical issues (must fix)
- 2 warnings (should fix)  
- 1 suggestion (optimization)
```

**Step 4: Apply fixes with Copilot**

In Copilot Chat:
```
Apply the code review fixes to the batch submission endpoint.
Move logic to GameScoreService, add validation, add @Transactional,
and add batch size limit of 100.
```

### Teaching Points

| Review Category | What to Check |
|----------------|---------------|
| 🔴 Critical | Security, data integrity, crashes |
| 🟡 Warning | Performance, layer violations |
| 🟢 Suggestion | Best practices, optimizations |

---

## Demo 5: Copilot Plan Mode (15 min)

### Objective
Use Plan Mode to architect multi-step solutions before implementation.

### Scenario
Create a comprehensive plan to add WebSocket support for real-time leaderboard updates.

### IntelliJ Plan Mode

**Step 1: Invoke Plan Mode in Copilot Chat**

Click the **Plan** button in Copilot Chat or type:

```
@plan Create a plan to add WebSocket support for real-time leaderboard updates 
in the High Scores Demo application.

Context:
- Backend: Spring Boot 3.5 with Java 21
- Frontend: React 18 + TypeScript + Vite
- Current flow: Frontend polls `/api/scores/game/{name}/top` endpoint
- Goal: Push leaderboard updates in real-time when new scores are submitted

Requirements:
1. Use Spring WebSocket with STOMP protocol
2. Frontend subscribes to game-specific channels
3. When score submitted via POST /api/scores/submit, broadcast update
4. Maintain backward compatibility (REST API still works)
5. Add reconnection handling on frontend
```

**Step 2: Review generated plan**

```markdown
## Plan: Real-Time Leaderboard with WebSocket

### Phase 1: Backend WebSocket Configuration (15 min)
☐ 1.1 Add Spring WebSocket dependency to `build.gradle`
```groovy
implementation 'org.springframework.boot:spring-boot-starter-websocket'
```

☐ 1.2 Create `WebSocketConfig.java`
```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws").setAllowedOrigins("*").withSockJS();
    }
}
```

☐ 1.3 Create `LeaderboardWebSocketController.java`
```java
@Controller
@RequiredArgsConstructor
@Slf4j
public class LeaderboardWebSocketController {
    private final SimpMessagingTemplate messagingTemplate;
    
    public void broadcastLeaderboardUpdate(String gameName, List<ScoreResponse> topScores) {
        messagingTemplate.convertAndSend("/topic/leaderboard/" + gameName, topScores);
    }
}
```

### Phase 2: Integrate with Score Submission (10 min)
☐ 2.1 Modify `GameScoreService.submitScore()` to trigger broadcast
☐ 2.2 Fetch updated top 10 after save
☐ 2.3 Call WebSocket controller to broadcast

```java
// In GameScoreService.java
public GameScore submitScore(...) {
    GameScore saved = gameScoreRepository.save(gameScore);
    
    // Broadcast updated leaderboard
    List<GameScore> topScores = getTopScoresForGame(gameName, 10);
    webSocketController.broadcastLeaderboardUpdate(gameName, 
        topScores.stream().map(ScoreResponse::new).toList());
    
    return saved;
}
```

### Phase 3: Frontend WebSocket Client (20 min)
☐ 3.1 Install dependencies
```bash
cd frontend && npm install @stomp/stompjs sockjs-client
```

☐ 3.2 Create `src/app/api/websocket.ts`
☐ 3.3 Create `useLeaderboardSocket` hook
☐ 3.4 Update `Leaderboard.tsx` to use WebSocket with REST fallback

### Phase 4: Testing & Documentation (10 min)
☐ 4.1 Add WebSocket integration test
☐ 4.2 Update `README.md` with WebSocket documentation
☐ 4.3 Add reconnection logic with exponential backoff

### Success Criteria
✅ Leaderboard updates within 100ms of score submission
✅ REST API continues to work unchanged
✅ Graceful fallback when WebSocket unavailable
✅ Automatic reconnection on connection loss
```

**Step 3: Execute plan step-by-step**

Use Copilot to implement each phase:
```
Execute Phase 1.1 from the WebSocket plan - add the Spring WebSocket 
dependency to build.gradle
```

### Teaching Points

| Plan Mode Element | Purpose |
|------------------|---------|
| Phases | Logical groupings by component |
| Checkboxes ☐ | Track implementation progress |
| Code snippets | Specific implementation guidance |
| Success criteria | Definition of done |

---

## Demo 6: Copilot Coding Agent (15 min)

### Objective
Delegate autonomous multi-file tasks to Copilot's coding agent for complex refactoring.

### Scenario
Use the coding agent to add comprehensive input validation across all DTOs.

### IntelliJ Agent Mode

**Step 1: Invoke Copilot Agent**

In Copilot Chat, use the agent command:

```
@agent Add comprehensive Jakarta validation annotations to all DTOs 
in the High Scores Demo backend.

Context:
- Package: `com.insight.ai_demo.dto`
- Framework: Spring Boot 3.5 with Jakarta Validation
- Existing DTOs: ScoreSubmissionRequest, ScoreResponse

Rules to enforce:
1. All string fields: @NotBlank with custom message
2. All numeric fields: @NotNull, appropriate @Min/@Max
3. Score values: @Min(0), @Max(999999999)
4. Player/game names: @Size(min=1, max=100)
5. Optional date fields: @PastOrPresent where appropriate

For each DTO:
1. Identify all fields needing validation
2. Add appropriate Jakarta annotations
3. Include meaningful error messages
4. Verify no compile errors

Report progress after each file.
```

**Step 2: Agent executes autonomously**

```markdown
## Agent Progress Report

### File 1: ScoreSubmissionRequest.java
**Location**: `src/main/java/com/insight/ai_demo/dto/ScoreSubmissionRequest.java`

**Changes Applied**:
```java
@Data
public class ScoreSubmissionRequest {
    
    @NotBlank(message = "Player name is required")
    @Size(min = 1, max = 100, message = "Player name must be between 1 and 100 characters")
    private String playerName;
    
    @NotBlank(message = "Game name is required")
    @Size(min = 1, max = 100, message = "Game name must be between 1 and 100 characters")
    private String gameName;
    
    @NotNull(message = "Score is required")
    @Min(value = 0, message = "Score must be non-negative")
    @Max(value = 999999999, message = "Score cannot exceed 999,999,999")
    private Long score;
    
    @PastOrPresent(message = "Achievement date cannot be in the future")
    private LocalDateTime achievedAt;
}
```
**Status**: ✅ Fixed | Compile: ✅ Success

### File 2: ScoreResponse.java
**Location**: `src/main/java/com/insight/ai_demo/dto/ScoreResponse.java`

**Analysis**: Response DTO - validation not typically needed on outbound data
**Status**: ⏭️ Skipped (response DTO)

### Summary
- Files processed: 2
- Validations added: 7 annotations
- Compile errors: 0

Run `./gradlew compileJava` to verify.
```

**Step 3: Verify agent work**

In IntelliJ Terminal:
```bash
cd java-spring-boot-backend
./gradlew compileJava

# Expected: BUILD SUCCESSFUL
```

### Teaching Points

| Agent Capability | Use Case |
|-----------------|----------|
| Multi-file edits | Consistent patterns across codebase |
| Autonomous execution | Repetitive annotation/boilerplate |
| Progress reporting | Track complex changes |
| Verification | Compile check after each change |

---

## Demo 7: Copilot Agent HQ (10 min)

### Objective
Manage and orchestrate custom agents for specialized workflows.

### Scenario
Create a custom `@score-validator` agent for the High Scores Demo.

### Live Coding Steps

**Step 1: Create custom agent definition**

Create file `.github/copilot-agents/score-validator.agent.md`:

```markdown
# Score Validator Agent

## Identity
You are a specialized agent for validating game score data integrity 
in the High Scores Demo application.

## Expertise
- Jakarta Bean Validation
- Spring Boot REST validation
- Game leaderboard domain knowledge
- Anti-cheat heuristics

## Rules
1. All scores MUST be non-negative integers
2. Player names: 1-100 characters, alphanumeric + spaces only
3. Game names: Must match existing games in system or valid new game format
4. Timestamps: Cannot be in the future
5. Suspicious patterns: Flag scores that are statistical outliers

## Behaviors
When asked to validate score data:
1. Check field constraints (type, length, range)
2. Verify business rules (timestamp logic)
3. Flag potential cheating patterns:
   - Score > 3 standard deviations above game average
   - Multiple max scores in short time period
   - Identical scores from same player
4. Suggest validation annotations if missing
5. Report findings with severity levels

## Example Invocation
```
@score-validator Review the score submission endpoint for validation gaps
```

## Output Format
```
## Score Validation Report

### ✅ Valid Patterns
- Field X properly validated with @NotNull

### ⚠️ Warnings
- Field Y missing @Size constraint

### ❌ Critical Issues
- Endpoint accepts negative scores

### 🎮 Anti-Cheat Recommendations
- Consider rate limiting per player
```
```

**Step 2: Register agent configuration**

Create file `.github/copilot-agents/agents.yaml`:

```yaml
agents:
  - name: score-validator
    file: score-validator.agent.md
    description: Validates game score data integrity and anti-cheat patterns
    triggers:
      - "validate scores"
      - "check score submission"
      - "anti-cheat review"
    
  - name: api-documenter
    file: api-documenter.agent.md
    description: Generates OpenAPI documentation for endpoints
    
  - name: test-generator
    file: test-generator.agent.md
    description: Creates JUnit and React Testing Library tests
```

**Step 3: Invoke custom agent**

In Copilot Chat:
```
@score-validator Review the entire score submission flow for validation 
gaps and potential cheating vulnerabilities.

Focus on:
- GameScoreController.submitScore()
- ScoreSubmissionRequest DTO
- GameScoreService validation logic
```

**Step 4: Agent response**

```markdown
## Score Validation Report

### Files Analyzed: 3
### Validation Rules Checked: 12

### ✅ Valid Patterns (7)
- `ScoreSubmissionRequest.playerName`: @NotBlank ✓
- `ScoreSubmissionRequest.gameName`: @NotBlank ✓
- `GameScoreController`: Uses @Valid on request body ✓
- Service layer: Trims whitespace from names ✓
...

### ⚠️ Warnings (3)

**1. Missing Score Range Validation**
```java
// Current - No max limit
@NotNull
private Long score;

// Recommended
@NotNull
@Min(0)
@Max(999_999_999)
private Long score;
```

**2. Player Name Allows Special Characters**
```java
// Add pattern validation
@Pattern(regexp = "^[a-zA-Z0-9 ]+$", 
         message = "Player name can only contain letters, numbers, and spaces")
private String playerName;
```

### ❌ Critical Issues (1)

**3. No Rate Limiting**
Current endpoint allows unlimited submissions. Recommend:
```java
@RateLimiter(name = "scoreSubmission", fallbackMethod = "rateLimitFallback")
@PostMapping("/submit")
public ResponseEntity<ScoreResponse> submitScore(...)
```

### 🎮 Anti-Cheat Recommendations
1. **Statistical Outlier Detection**: Flag scores > 3σ above game average
2. **Duplicate Detection**: Prevent identical scores within 1 minute
3. **Session Validation**: Consider adding player session tokens
4. **Score Increment Limits**: Max +50% improvement per submission

### Summary
- 7 valid patterns
- 3 warnings (should fix)
- 1 critical (must fix before production)
```

### Teaching Points

| Agent HQ Feature | Purpose |
|-----------------|---------|
| Agent definitions | Specialized domain knowledge |
| Triggers | Auto-invoke based on keywords |
| Output format | Consistent, actionable reports |
| Orchestration | Chain multiple agents together |

---

## Demo 8: Architecture & Tech Stack Generation (5 min)

### Objective
Use Copilot to generate project scaffolding, architecture decisions, and tech stack recommendations.

### Scenario
Generate architecture for extracting the leaderboard service into a dedicated microservice.

### Live Coding Steps

**Step 1: Request architecture generation**

In Copilot Chat:

```
Generate architecture for extracting the High Scores leaderboard 
functionality into a dedicated microservice.

Context:
- Current: Monolithic Spring Boot app with embedded H2/PostgreSQL
- Target: Dedicated leaderboard microservice
- Deployment: Azure Kubernetes Service (AKS)
- Requirements:
  1. Project structure for new Kotlin + Spring Boot 3 service
  2. Dockerfile (multi-stage build, JRE 21)
  3. API contract (OpenAPI 3.1 spec)
  4. Kubernetes manifests
  5. CI/CD pipeline (GitHub Actions)

Generate complete scaffolding with all files.
```

**Step 2: Copilot generates architecture**

```markdown
## Generated Architecture: Leaderboard Microservice

### Project Structure
```
leaderboard-service/
├── src/
│   └── main/
│       ├── kotlin/
│       │   └── com/insight/leaderboard/
│       │       ├── LeaderboardApplication.kt
│       │       ├── controller/
│       │       │   └── LeaderboardController.kt
│       │       ├── service/
│       │       │   └── LeaderboardService.kt
│       │       ├── repository/
│       │       │   └── ScoreRepository.kt
│       │       └── model/
│       │           └── Score.kt
│       └── resources/
│           ├── application.yml
│           └── application-prod.yml
├── build.gradle.kts
├── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
└── .github/
    └── workflows/
        └── ci-cd.yaml
```

### API Contract (api/openapi.yaml)
```yaml
openapi: 3.1.0
info:
  title: Leaderboard Service API
  version: 1.0.0
  description: High-performance game leaderboard microservice
paths:
  /api/v1/leaderboards/{gameId}/scores:
    get:
      summary: Get top scores for a game
      parameters:
        - name: gameId
          in: path
          required: true
          schema:
            type: string
        - name: limit
          in: query
          schema:
            type: integer
            default: 10
            maximum: 100
      responses:
        '200':
          description: Top scores
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LeaderboardResponse'
components:
  schemas:
    LeaderboardResponse:
      type: object
      properties:
        gameName:
          type: string
        scores:
          type: array
          items:
            $ref: '#/components/schemas/ScoreEntry'
```

### Dockerfile
```dockerfile
# Build stage
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
COPY build.gradle.kts settings.gradle.kts ./
COPY gradle gradle
COPY src src
RUN ./gradlew bootJar --no-daemon

# Runtime stage  
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Architecture Decision Record (ADR)
```markdown
# ADR 001: Kotlin for Leaderboard Microservice

## Status: Accepted

## Context
Extracting leaderboard functionality from Java monolith.

## Decision
Use **Kotlin** for the new microservice because:
1. Null safety reduces NullPointerExceptions
2. Coroutines for high-throughput score updates
3. Data classes reduce boilerplate
4. Full Spring Boot 3 support

## Consequences
- Team needs Kotlin onboarding (1-2 days)
- Better performance for read-heavy leaderboard queries
```
```

### Teaching Points

| Generation Type | Use Case |
|----------------|----------|
| Project structure | New microservices |
| API contracts | Service interfaces |
| Infrastructure | Kubernetes, Docker |
| ADRs | Architecture decisions |

---

## Demo 9: Customize Copilot (5 min)

### Objective
Configure Copilot settings in IntelliJ for optimal project-specific behavior.

### IntelliJ Copilot Settings

**Step 1: Access Copilot Settings**

Navigate to: **Settings → Tools → GitHub Copilot**

**Step 2: Configure Code Completions**

| Setting | Recommended Value | Reason |
|---------|------------------|--------|
| **Enable Copilot** | ✅ Enabled | Core functionality |
| **Enable auto-completions** | ✅ Enabled | Inline suggestions |
| **Show completions automatically** | ✅ Enabled | Seamless workflow |

**Step 3: Configure Copilot Chat**

| Setting | Recommended Value | Reason |
|---------|------------------|--------|
| **Enable Copilot Chat** | ✅ Enabled | Interactive assistance |
| **Use @workspace context** | ✅ Enabled | Project-aware responses |

**Step 4: File-Level Configuration**

Create/update `.copilotignore` in project root:

```gitignore
# .copilotignore - Files Copilot should not analyze

# Sensitive configuration
**/application-prod.properties
**/secrets/
**/*.env

# Generated files (no need to analyze)
**/build/
**/node_modules/
**/dist/
**/*.min.js

# Test fixtures with mock data
**/test-fixtures/
**/mock-data/
```

**Step 5: Language-Specific Settings**

In `.github/copilot-instructions.md`, add language preferences:

```markdown
## Language-Specific Instructions

### Java (Backend)
- Java version: 21 (use modern features: records, pattern matching)
- Prefer `var` for local variables with obvious types
- Use `Optional` instead of null checks
- Prefer Stream API over traditional loops

### TypeScript (Frontend)
- Strict mode: enabled
- Prefer `interface` over `type` for object shapes
- Use `const` assertions for literal types
- Always use explicit return types on exported functions

### SQL (Queries)
- Use parameterized queries only (never string concatenation)
- Prefer JPA/JPQL over native SQL when possible
```

**Step 6: Keyboard Shortcuts Reference**

| Action | Mac | Windows/Linux |
|--------|-----|---------------|
| Accept suggestion | `Tab` | `Tab` |
| Dismiss suggestion | `Esc` | `Esc` |
| Open Copilot Chat | `⌘+Shift+I` | `Ctrl+Shift+I` |
| Next suggestion | `⌥+]` | `Alt+]` |
| Previous suggestion | `⌥+[` | `Alt+[` |
| Inline chat | `⌘+I` | `Ctrl+I` |

### Teaching Points

| Customization Area | Impact |
|-------------------|--------|
| Settings UI | Global Copilot behavior |
| `.copilotignore` | Exclude sensitive/irrelevant files |
| Instruction files | Project-specific rules |
| Keyboard shortcuts | Workflow efficiency |

---

## Workshop Summary

### 9 Advanced Techniques Mastered

| # | Technique | Key Takeaway |
|---|-----------|--------------|
| 1 | **Chain-of-Thought** | Break complex features into numbered steps |
| 2 | **Instruction Files** | Project rules with 🚨 critical markers |
| 3 | **Prompt Files** | Reusable templates in `.github/prompts/` |
| 4 | **Code Review** | Security, validation, and pattern checks |
| 5 | **Plan Mode** | Multi-phase architecture before coding |
| 6 | **Coding Agent** | Autonomous multi-file refactoring |
| 7 | **Agent HQ** | Custom agents for specialized tasks |
| 8 | **Architecture Gen** | Scaffolding, ADRs, tech stack decisions |
| 9 | **Customize Copilot** | IntelliJ settings, `.copilotignore`, preferences |

### Quick Reference

```
# Chain-of-Thought
/**
 * CHAIN OF THOUGHT: [Feature Name]
 * Step 1: [requirement]
 * Step 2: [data model]
 * Step 3: [query strategy]
 * Now implement:
 */

# Instruction File
### 🚨 CRITICAL: [Rule Name]
// ❌ WRONG
// ✅ CORRECT

# Prompt File
<!-- .github/prompts/[name].prompt.md -->
## Requirements
## Template
## Checklist

# Code Review
Review for security, Lombok usage, pagination patterns

# Plan Mode
@plan Create plan for [complex feature]

# Coding Agent
@agent Add validation to all DTOs in [package]

# Agent HQ
@[custom-agent] [domain-specific task]

# Architecture
Generate [language] microservice structure for [description]

# Customize
Settings → Tools → GitHub Copilot
```

### High Scores Demo Files Reference

| File | Purpose |
|------|---------|
| `GameScoreController.java` | REST API endpoints |
| `GameScoreService.java` | Business logic layer |
| `GameScore.java` | JPA entity with Lombok |
| `scoreService.ts` | Frontend API client |
| `types.ts` | TypeScript interfaces |
| `Leaderboard.tsx` | React component example |
| `.github/copilot-instructions.md` | Project rules |

### Next Workshop Preview

**Workshop 4: Expert Web Development**
- MCP Servers for live documentation
- Spec Kit for feature specifications
- Terraform planning agents
- Full production deployment workflow

---

## Resources

- **IntelliJ Copilot Plugin**: [JetBrains Marketplace](https://plugins.jetbrains.com/plugin/17718-github-copilot)
- **Instruction File**: `.github/copilot-instructions.md`
- **Prompt Files**: `.github/prompts/`
- **Agent Definitions**: `.github/copilot-agents/`
- **Project Repository**: High Scores Demo
