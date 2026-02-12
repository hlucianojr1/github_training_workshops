# Workshop 3: Advanced Web Development with GitHub Copilot

**Duration**: 90 minutes  
**Format**: Live coding demonstrations  
**Audience**: Developers proficient with Copilot prompting (completed Workshops 1-2)  
**Prerequisites**: Experience with explicit prompting, few-shot learning, React Context/Spring Boot patterns

---

## Project Context: High Scores Demo

This workshop uses the **High Scores Demo** application—a full-stack game leaderboard system:
- **Frontend**: React 18 + Vite + TypeScript + Tailwind CSS (`frontend/`)
- **Backend**: Java 21 + Spring Boot 3.5 REST API (`java-spring-boot-backend/`)
- **Infrastructure**: Terraform modules for local (Rancher Desktop) and Azure AKS deployment

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
9. **Customize Copilot** - Configure Copilot behavior with settings, extensions, and MCP servers

---

## Workshop Agenda

| Time | Demo | Topic | Focus Files |
|------|------|-------|-------------|
| 0-10 min | Demo 1 | Chain-of-Thought Prompting | `GameScoreService.java` |
| 10-20 min | Demo 2 | Instruction Files | `.github/copilot-instructions.md` |
| 20-30 min | Demo 3 | Prompt Files | `.github/prompts/*.prompt.md` |
| 30-40 min | Demo 4 | Copilot Code Review | Pull Request review |
| 40-55 min | Demo 5 | Copilot Plan Mode | `backend/src/test/` |
| 55-70 min | Demo 6 | Copilot Coding Agent | Multi-file refactoring |
| 70-80 min | Demo 7 | Copilot Agent HQ | Custom agent creation |
| 80-85 min | Demo 8 | Architecture & Tech Stack Generation | New microservice scaffolding |
| 85-90 min | Demo 9 | Customize Copilot | Settings, extensions, MCP servers |

---

## Demo 1: Chain-of-Thought Prompting (10 min)

### Objective
Learn to decompose complex features into step-by-step reasoning chains that guide Copilot toward correct solutions.

### Scenario
Add a **score streak tracking** feature to the High Scores backend that tracks consecutive high score achievements by a player.

### Live Coding Steps

**Step 1: Write chain-of-thought prompt in `GameScoreService.java`**
```java
// In java-spring-boot-backend/.../service/GameScoreService.java

/**
 * CHAIN OF THOUGHT: Add streak tracking for consecutive high scores
 *
 * Step 1: Define requirements
 * - Track when a player beats their own previous score
 * - Count consecutive "personal best" scores
 * - Reset streak when score doesn't beat previous
 *
 * Step 2: Data model changes
 * - Add currentStreak: int to GameScore entity
 * - Add longestStreak: int to track all-time best streak
 *
 * Step 3: Business logic
 * - On score submit: compare to player's last score for that game
 * - If score > previous: increment streak
 * - If score <= previous: reset streak to 0
 *
 * Step 4: Query requirements
 * - Need: findLatestScoreByPlayerAndGame(playerName, gameName)
 * - Return: Optional<GameScore> with most recent entry
 *
 * Step 5: Response enhancement
 * - Include streak info in ScoreResponse DTO
 * - Add isPersonalBest: boolean flag
 *
 * Now implement calculateStreak method:
 */
```

**Step 2: Accept Copilot suggestions following the chain**
```java
// Copilot should generate based on each step:
public int calculateStreak(String playerName, String gameName, Long newScore) {
    // Step 4: Query previous score
    Optional<GameScore> lastScore = gameScoreRepository
        .findTopByPlayerNameAndGameNameOrderByCreatedAtDesc(playerName, gameName);
    
    // Step 3: Compare and calculate streak
    if (lastScore.isEmpty()) {
        return 1; // First score starts streak
    }
    
    GameScore previous = lastScore.get();
    if (newScore > previous.getScore()) {
        return previous.getCurrentStreak() + 1; // Increment streak
    }
    return 0; // Reset streak
}
```

**Step 3: Complete the implementation**
```java
// Update submitScore method to use streak calculation
public GameScore submitScore(String playerName, String gameName, Long score, LocalDateTime achievedAt) {
    log.info("Submitting score for player: {}, game: {}, score: {}", playerName, gameName, score);
    
    // Calculate streak before saving
    int streak = calculateStreak(playerName, gameName, score);
    
    GameScore gameScore = new GameScore();
    gameScore.setPlayerName(playerName.trim());
    gameScore.setGameName(gameName.trim());
    gameScore.setScore(score);
    gameScore.setCurrentStreak(streak);
    gameScore.setAchievedAt(achievedAt != null ? achievedAt : LocalDateTime.now());
    
    GameScore saved = gameScoreRepository.save(gameScore);
    log.info("Score submitted with streak: {}", streak);
    
    return saved;
}
```

### Teaching Points

| Chain-of-Thought Formula | High Scores Example |
|-------------------------|---------------------|
| Step 1: Requirements | Track consecutive personal bests |
| Step 2: Data model | Add streak fields to GameScore entity |
| Step 3: Business logic | Compare scores, increment/reset streak |
| Step 4: Query needs | Find latest score for player+game |
| Step 5: Response | Include streak info in DTO |

**When to Use**: Multi-step features, complex algorithms, unfamiliar domains  
**Avoid**: Simple CRUD operations, straightforward getter/setter changes

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
Add rules to enforce High Scores project conventions: Lombok usage, pagination patterns, and API response format.

### Live Coding Steps

**Step 1: Add Lombok annotation rule**
```markdown
<!-- In .github/copilot-instructions.md -->

### 🚨 CRITICAL: Use Lombok Annotations

**ALWAYS use Lombok for boilerplate code in Java classes**

```java
// ❌ WRONG - Manual getters/setters
public class GameScore {
    private String playerName;
    
    public String getPlayerName() { return playerName; }
    public void setPlayerName(String name) { this.playerName = name; }
}

// ✅ CORRECT - Use Lombok
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GameScore {
    private String playerName;
}
```

**Required annotations for each class type:**
- Entities: `@Data`, `@NoArgsConstructor`, `@AllArgsConstructor`
- Services: `@RequiredArgsConstructor`, `@Slf4j`
- Controllers: `@RequiredArgsConstructor`, `@Slf4j`
```

**Step 2: Add pagination response rule**
```markdown
### 🚨 API Response Pattern - Pagination

**Rule**: All list endpoints MUST return paginated `Map<String, Object>` with metadata.

```java
// ❌ WRONG - Raw list return
@GetMapping("/scores")
public List<ScoreResponse> getScores() { ... }

// ✅ CORRECT - Paginated response with metadata
@GetMapping("/scores")
public ResponseEntity<Map<String, Object>> getScores(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
    
    Page<GameScore> scores = service.getScores(page, size);
    
    Map<String, Object> response = Map.of(
        "scores", scores.getContent(),
        "totalElements", scores.getTotalElements(),
        "totalPages", scores.getTotalPages(),
        "currentPage", page,
        "pageSize", size,
        "hasNext", scores.hasNext(),
        "hasPrevious", scores.hasPrevious()
    );
    return ResponseEntity.ok(response);
}
```
```

**Step 3: Add TypeScript API response rule**
```markdown
### 🚨 Frontend API Pattern - MANDATORY

**Rule**: All API calls MUST use the `ApiResponse<T>` wrapper from `scoreService.ts`.

```typescript
// ❌ WRONG - Direct fetch without error handling
const data = await fetch('/api/scores').then(r => r.json());

// ✅ CORRECT - Use typed service with ApiResponse wrapper
import { getTopScores, type ScoreResponse } from '@/app/api';

const response = await getTopScores(gameName, 10);
if (response.error) {
    console.error(response.error);
    setUsingFallback(true);
} else {
    setData(response.data);
}
```
```

### Verification
```bash
# Test by asking Copilot to create a new endpoint
# Expected: Copilot generates with Lombok, pagination, and proper response format
```

### Teaching Points

| Instruction Rule | Format |
|-----------------|--------|
| Critical rule | Use 🚨 emoji prefix |
| Examples | Show ❌ WRONG and ✅ CORRECT |
| Specificity | Include exact annotations/types |
| Rationale | Explain why pattern matters |

---

## Demo 3: Prompt Files (10 min)

### Objective
Create reusable `.prompt.md` files for consistent code generation patterns across the team.

### Scenario
Create prompt files for generating Spring Boot endpoints and React components that follow High Scores project conventions.

### Live Coding Steps

**Step 1: Create prompt file directory**
```bash
mkdir -p .github/prompts
```

**Step 2: Create Spring Boot endpoint prompt**
```markdown
<!-- .github/prompts/spring-endpoint.prompt.md -->

# Spring Boot Endpoint Generator

Generate a REST endpoint following High Scores Demo conventions.

## Requirements
- Use Lombok annotations (`@RequiredArgsConstructor`, `@Slf4j`)
- Include logging for all operations
- Use `ResponseEntity<T>` for all returns
- Add pagination for list endpoints with `Map<String, Object>` response
- Include JavaDoc with endpoint description

## Template
```java
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * {{Description}}
 */
@GetMapping("/{{path}}")
public ResponseEntity<{{ReturnType}}> {{methodName}}(
        @PathVariable {{pathParams}},
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
    
    log.info("{{logMessage}}", {{logParams}});
    
    // Implementation
    
    return ResponseEntity.ok(response);
}
```

## Checklist
- [ ] Lombok annotations present on class
- [ ] Logging added with appropriate level
- [ ] Pagination included for lists
- [ ] ResponseEntity used for return
- [ ] JavaDoc documentation added
```

**Step 3: Create React component prompt**
```markdown
<!-- .github/prompts/react-component.prompt.md -->

# React Component Generator

Generate a typed React functional component following High Scores Demo conventions.

## Requirements
- Define props interface (exported)
- Use TypeScript strict types (NO `any`)
- Use `@/app/api` for API calls with `ApiResponse<T>` handling
- Include loading and error states
- Use Tailwind CSS for styling
- Use Lucide icons for visual elements

## Template
```typescript
import { useState, useEffect } from 'react';
import { Loader2, AlertCircle } from 'lucide-react';
import { {{apiFunction}}, type {{ResponseType}} } from '@/app/api';

/**
 * {{Component description}}
 */
export interface {{ComponentName}}Props {
  // Define typed props here
}

export function {{ComponentName}}({ ...props }: {{ComponentName}}Props) {
  const [data, setData] = useState<{{DataType}} | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchData() {
      setLoading(true);
      const response = await {{apiFunction}}();
      if (response.error) {
        setError(response.error);
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

  if (error) {
    return <AlertCircle className="text-red-500" />;
  }

  return (
    <div className="{{tailwind-classes}}">
      {/* JSX implementation */}
    </div>
  );
}

export default {{ComponentName}};
```

## Checklist
- [ ] Props interface is exported
- [ ] All props have explicit types
- [ ] No `any` types
- [ ] Loading state handled
- [ ] Error state handled
- [ ] Uses `@/app/api` service functions
- [ ] Tailwind CSS for styling
```

**Step 4: Use prompt file in Copilot Chat**
```
# In Copilot Chat:
@workspace /file:.github/prompts/react-component.prompt.md

Create a PlayerStats component that displays a player's statistics.
Props: playerName (string)
API: Use getPlayerStats from scoreService
Display: totalGames, totalScore, averageScore, highestScore
```

### Teaching Points

| Prompt File Element | Purpose |
|--------------------|---------|
| Requirements section | Enforces project rules |
| Template section | Provides code structure |
| Checklist section | Verification criteria |
| Placeholders `{{}}` | Dynamic substitution |

**Benefits**:
- Consistency across team
- Onboarding new developers
- Reusable patterns
- Version-controlled prompts

---

## Demo 4: Copilot Code Review (10 min)

### Objective
Use Copilot to review pull requests, identify issues, and suggest improvements.

### Scenario
Review a PR that adds a new "achievements" feature to the High Scores backend.

### Live Coding Steps

**Step 1: Open PR diff in VS Code**
```bash
# Fetch the PR branch
git fetch origin feature/achievements
git diff main..feature/achievements -- java-spring-boot-backend/
```

**Step 2: Invoke Copilot Code Review**
```
# In Copilot Chat:
@workspace Review the changes in this PR for:
1. Security vulnerabilities (SQL injection, improper validation)
2. Missing Lombok annotations
3. Missing error handling
4. Pagination pattern compliance
5. Test coverage gaps

Files changed:
- java-spring-boot-backend/.../entity/Achievement.java
- java-spring-boot-backend/.../controller/AchievementController.java
- java-spring-boot-backend/.../service/AchievementService.java
- frontend/src/app/components/Achievements.tsx
```

**Step 3: Copilot Review Output**
```markdown
## Code Review: Achievements Feature

### 🔴 Critical Issues

**1. Missing Input Validation** (AchievementController.java:45)
```java
// ❌ Current code - no validation
@PostMapping("/unlock")
public ResponseEntity<Achievement> unlockAchievement(
    @RequestBody AchievementRequest request) {

// ✅ Fix: Add Jakarta validation
@PostMapping("/unlock")
public ResponseEntity<Achievement> unlockAchievement(
    @Valid @RequestBody AchievementRequest request) {
```

**2. N+1 Query Problem** (AchievementService.java:78)
```java
// ❌ Current - fetches achievements then loops for player data
List<Achievement> achievements = repo.findAll();
achievements.forEach(a -> a.setPlayer(playerRepo.findById(a.getPlayerId())));

// ✅ Fix: Use JOIN FETCH query
@Query("SELECT a FROM Achievement a JOIN FETCH a.player")
List<Achievement> findAllWithPlayer();
```

### 🟡 Warnings

**3. Missing Lombok Annotations** (Achievement.java:12)
```java
// ❌ Current - manual boilerplate
public class Achievement {
    private Long id;
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
}

// ✅ Fix - Use Lombok
@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Achievement {
    private Long id;
}
```

**4. TypeScript `any` Usage** (Achievements.tsx:34)
```typescript
// ❌ Current
const handleUnlock = (data: any) => { }

// ✅ Fix
interface UnlockData { 
    achievementId: number; 
    playerName: string; 
}
const handleUnlock = (data: UnlockData) => { }
```

### 🟢 Suggestions

**5. Add Caching** (AchievementService.java)
- Consider `@Cacheable` for frequently accessed achievements list

**6. Test Coverage** (test/AchievementServiceTest.java)
- Missing test for duplicate unlock attempt
- Missing test for invalid achievement ID (404)

### Summary
- 2 critical issues (must fix before merge)
- 2 warnings (should fix)
- 2 suggestions (nice to have)
```

**Step 4: Apply fixes with Copilot**
```
# In Copilot Chat:
@workspace Fix the N+1 query problem in AchievementService.java
Use a JOIN FETCH query in the repository instead of multiple queries.
```

### Teaching Points

| Review Category | What to Check |
|----------------|---------------|
| 🔴 Critical | Security, data integrity, crashes |
| 🟡 Warning | Performance, maintainability, conventions |
| 🟢 Suggestion | Best practices, improvements |

**Copilot Review Prompts**:
```
# Security-focused review
Review for OWASP Top 10 vulnerabilities

# Performance review
Review for N+1 queries, missing indexes, unnecessary re-renders

# Architecture review
Review for SOLID principles, separation of concerns

# Convention review
Review for Lombok usage, pagination patterns, API response format
```

---

## Demo 5: Copilot Plan Mode (15 min)

### Objective
Use Plan Mode to architect multi-step solutions before implementation.

### Scenario
Create a comprehensive plan to add integration tests for the High Scores backend using Testcontainers.

### Live Coding Steps

**Step 1: Invoke Plan Mode**
```
# In Copilot Chat, click "Plan" button or type:
@plan Create plan to add integration tests with Testcontainers

Context:
- Backend uses Spring Boot 3.5 with H2 for dev, PostgreSQL for prod
- Currently only unit tests exist in src/test/java
- Need real database integration tests using Testcontainers
- Tests should run in CI/CD pipeline

Goals:
1. Add Testcontainers dependency
2. Create test configuration for PostgreSQL container
3. Write integration tests for GameScoreController
4. Configure CI to run integration tests
5. Document testing patterns
```

**Step 2: Review generated plan**
```markdown
## Plan: Add Integration Tests with Testcontainers

### Phase 1: Dependencies Setup (5 min)
☐ 1.1 Add to `build.gradle`:
```gradle
testImplementation 'org.springframework.boot:spring-boot-testcontainers'
testImplementation 'org.testcontainers:junit-jupiter'
testImplementation 'org.testcontainers:postgresql'
```

☐ 1.2 Run: `./gradlew build --refresh-dependencies`

### Phase 2: Test Configuration (10 min)
☐ 2.1 Create `src/test/resources/application-integration.properties`
```properties
spring.datasource.driver-class-name=org.testcontainers.jdbc.ContainerDatabaseDriver
spring.datasource.url=jdbc:tc:postgresql:16:///highscores
spring.jpa.hibernate.ddl-auto=create-drop
```

☐ 2.2 Create base integration test class:
```java
// src/test/java/.../integration/BaseIntegrationTest.java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("integration")
@Testcontainers
public abstract class BaseIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16")
        .withDatabaseName("highscores")
        .withUsername("test")
        .withPassword("test");
    
    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }
}
```

### Phase 3: Integration Tests (20 min)
☐ 3.1 Create `GameScoreControllerIntegrationTest.java`
```java
class GameScoreControllerIntegrationTest extends BaseIntegrationTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void submitScore_shouldPersistAndReturn201() {
        ScoreSubmissionRequest request = new ScoreSubmissionRequest(
            "TestPlayer", "Test Game", 1000L);
        
        ResponseEntity<ScoreResponse> response = restTemplate.postForEntity(
            "/api/scores/submit", request, ScoreResponse.class);
        
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody().getPlayerName()).isEqualTo("TestPlayer");
    }
    
    @Test
    void getTopScores_shouldReturnSortedList() { ... }
    
    @Test
    void getPlayerScores_shouldReturnPaginated() { ... }
}
```

☐ 3.2 Create `GameScoreServiceIntegrationTest.java`
☐ 3.3 Verify: `./gradlew test --tests '*IntegrationTest'`

### Phase 4: CI Configuration (5 min)
☐ 4.1 Update `.github/workflows/ci.yml`:
```yaml
- name: Run Integration Tests
  run: ./gradlew test --tests '*IntegrationTest'
  env:
    TESTCONTAINERS_RYUK_DISABLED: true
```

### Phase 5: Documentation (5 min)
☐ 5.1 Add testing guide to `java-spring-boot-backend/README.md`

**Success Criteria**:
✅ Integration tests pass locally with Docker
✅ Tests use real PostgreSQL, not H2
✅ CI pipeline runs integration tests
✅ Test runtime < 60 seconds
```

**Step 3: Execute plan step-by-step**
```bash
# Phase 1.1 - Add dependencies
# Open build.gradle and add testcontainers dependencies

# Phase 2.2 - Use Copilot to generate base test class
# Type: "Create Testcontainers base class for PostgreSQL"
```

### Teaching Points

| Plan Mode Element | Purpose |
|------------------|---------|
| Phases | Logical groupings |
| Checkboxes ☐ | Track progress |
| Code snippets | Specific implementation |
| Time estimates | Set expectations |
| Success criteria | Definition of done |

**When to Use Plan Mode**:
- Complex refactoring (multi-file changes)
- New feature architecture
- Migration strategies
- Team collaboration (share plan for review)

---

## Demo 6: Copilot Coding Agent (15 min)

### Objective
Delegate autonomous multi-file tasks to Copilot's coding agent for complex refactoring.

### Scenario
Use the coding agent to add comprehensive logging across all service methods in the backend.

### Live Coding Steps

**Step 1: Invoke Copilot Agent**
```
# In Copilot Chat:
@agent Add structured logging to all GameScoreService methods

Context:
- Service class uses Lombok @Slf4j annotation
- Need consistent logging pattern: entry, exit, errors
- Log method name, parameters, and return values
- Use appropriate log levels: INFO for normal, WARN for edge cases, ERROR for exceptions

Files to modify:
- java-spring-boot-backend/.../service/GameScoreService.java

For each method:
1. Add entry log with method name and parameters
2. Add exit log with result summary (count, ID, etc.)
3. Add error logging in catch blocks
4. Use structured format: "methodName - action - details"

Report progress after each method.
```

**Step 2: Agent executes autonomously**
```markdown
## Agent Progress Report

### Method 1: submitScore
**Before**: Basic log on entry only
**After**: Complete structured logging
```java
public GameScore submitScore(String playerName, String gameName, Long score, LocalDateTime achievedAt) {
    log.info("submitScore - entry - player={}, game={}, score={}", playerName, gameName, score);
    
    try {
        GameScore gameScore = new GameScore();
        // ... implementation ...
        
        GameScore saved = gameScoreRepository.save(gameScore);
        log.info("submitScore - success - id={}, player={}", saved.getId(), playerName);
        
        return saved;
    } catch (Exception e) {
        log.error("submitScore - failed - player={}, game={}, error={}", playerName, gameName, e.getMessage());
        throw e;
    }
}
```
**Status**: ✅ Fixed

### Method 2: getPlayerScores
**Before**: Single info log
**After**: Entry/exit with pagination info
```java
public Page<GameScore> getPlayerScores(String playerName, int page, int size) {
    log.info("getPlayerScores - entry - player={}, page={}, size={}", playerName, page, size);
    
    Pageable pageable = PageRequest.of(page, size);
    Page<GameScore> result = gameScoreRepository.findByPlayerNameOrderByScoreDesc(playerName, pageable);
    
    log.info("getPlayerScores - success - player={}, totalElements={}, totalPages={}", 
             playerName, result.getTotalElements(), result.getTotalPages());
    
    return result;
}
```
**Status**: ✅ Fixed

### Method 3: getTopScoresForGame
**Status**: ✅ Fixed

### Method 4: getAllGames
**Status**: ✅ Fixed

### Method 5: getPlayerStats
**Status**: ✅ Fixed

### Summary
- Methods processed: 12
- Logging patterns added: 36 (entry + exit + error for each)
- Log levels: INFO (24), WARN (0), ERROR (12)
- Compilation errors: 0

Run `./gradlew compileJava` to verify.
```

**Step 3: Verify agent work**
```bash
cd java-spring-boot-backend
./gradlew compileJava

# Test logging output
./gradlew bootRun
# Make API call and observe logs
curl http://localhost:8080/api/scores/games
```

### Teaching Points

| Agent Capability | Use Case |
|-----------------|----------|
| Multi-file edits | Refactoring patterns |
| Autonomous execution | Repetitive tasks |
| Progress reporting | Track complex changes |
| Verification steps | Quality assurance |

**Agent Prompt Best Practices**:
```
# Structure your agent prompt:
1. Clear objective (what to accomplish)
2. Context (project rules, patterns)
3. Scope (which files/directories)
4. Steps (how to approach each case)
5. Reporting (what to communicate back)
```

---

## Demo 7: Copilot Agent HQ (10 min)

### Objective
Manage and orchestrate custom agents for specialized workflows using Agent HQ.

### Scenario
Create and configure a custom `@api-validator` agent for the High Scores Demo.

### Live Coding Steps

**Step 1: Create custom agent definition**
```markdown
<!-- .github/copilot-agents/api-validator.agent.md -->

# API Validator Agent

## Identity
You are a specialized agent for validating REST API consistency between the Spring Boot backend and React frontend in the High Scores Demo.

## Expertise
- Spring Boot REST controllers and DTOs
- TypeScript API service patterns
- OpenAPI/Swagger specifications
- Request/Response payload matching

## Rules
1. Backend endpoints MUST have corresponding frontend service functions
2. DTO field names MUST match TypeScript interface properties (camelCase)
3. Pagination responses MUST include: totalElements, totalPages, currentPage, hasNext, hasPrevious
4. All list endpoints MUST use `ApiResponse<T>` wrapper in frontend

## Behaviors
When asked to validate API consistency:
1. Scan `GameScoreController.java` for all endpoint definitions
2. Scan `scoreService.ts` for all API call functions
3. Compare request/response types between Java DTOs and TypeScript interfaces
4. Check pagination metadata fields match
5. Report mismatches with specific file locations
6. Suggest fixes for any inconsistencies

## Example Invocation
```
@api-validator Check consistency between backend and frontend APIs
```

## Output Format
```
## API Consistency Report

### ✅ Matched Endpoints
| Backend | Frontend | Status |
|---------|----------|--------|
| POST /api/scores/submit | submitScore() | ✓ |

### ❌ Mismatches
**1. Field name mismatch**
- Backend: `achievedAt` (ScoreResponse.java:15)
- Frontend: `achieved_at` (types.ts:18)
- Fix: Change frontend to `achievedAt`

### ⚠️ Missing Coverage
- Backend endpoint `/api/scores/stats` has no frontend function
```
```

**Step 2: Register agent in Agent HQ**
```yaml
# .github/copilot-agents/agents.yaml

agents:
  - name: api-validator
    file: api-validator.agent.md
    description: Validates API consistency between backend and frontend
    triggers:
      - "validate api"
      - "check endpoints"
      - "api consistency"
    
  - name: lombok-checker
    file: lombok-checker.agent.md
    description: Ensures Lombok annotations are used correctly
    
  - name: test-generator
    file: test-generator.agent.md
    description: Generates JUnit tests for Spring Boot services
```

**Step 3: Invoke custom agent**
```
# In Copilot Chat:
@api-validator Check consistency between backend and frontend APIs

Focus on:
- GameScoreController.java endpoints
- scoreService.ts functions
- types.ts interfaces vs Java DTOs
```

**Step 4: Agent response**
```markdown
## API Consistency Report

### Files Analyzed
- Backend: GameScoreController.java (15 endpoints)
- Frontend: scoreService.ts (12 functions)
- Types: types.ts (6 interfaces)

### ✅ Matched Endpoints (12)
| Backend Endpoint | Frontend Function | Request Type | Response Type |
|-----------------|-------------------|--------------|---------------|
| POST /api/scores/submit | submitScore() | ✓ Match | ✓ Match |
| GET /api/scores/game/{name}/top | getTopScores() | ✓ Match | ✓ Match |
| GET /api/scores/player/{name} | getPlayerScores() | ✓ Match | ✓ Match |
| GET /api/scores/games | getGames() | N/A | ✓ Match |
...

### ❌ Mismatches (1)

**1. Missing pagination field in TypeScript**
```typescript
// Backend returns (GameScoreController.java:67)
Map.of(
    "scores", scoreResponses,
    "totalElements", scores.getTotalElements(),
    "hasPrevious", scores.hasPrevious()  // ← This field
);

// Frontend PageResponse missing (types.ts:55)
export interface PageResponse<T> {
    content: T[];
    totalElements: number;
    totalPages: number;
    // hasPrevious: boolean;  ← MISSING
}

// Fix: Add to types.ts
hasPrevious: boolean;
```

### ⚠️ Missing Frontend Coverage (3)
| Backend Endpoint | Status | Recommendation |
|-----------------|--------|----------------|
| GET /api/scores/stats/global | Missing | Add getGlobalStats() |
| DELETE /api/scores/{id} | Missing | Add deleteScore() |
| PUT /api/scores/{id} | Missing | Add updateScore() |

### Summary
- 12/15 endpoints have frontend coverage
- 1 type mismatch found
- 3 endpoints need frontend implementation
```

### Teaching Points

| Agent HQ Feature | Purpose |
|-----------------|---------|
| Agent definitions | Custom specialized behaviors |
| Registration | Discoverability and triggers |
| Orchestration | Combine multiple agents |
| Invocation patterns | Consistent interface |

**Custom Agent Structure**:
```markdown
# Agent Name

## Identity - Who the agent is
## Expertise - What it knows
## Rules - What it enforces
## Behaviors - How it acts
## Example - How to use it
## Output Format - What it returns
```

---

## Demo 8: Architecture & Tech Stack Generation (5 min)

### Objective
Use Copilot to generate project scaffolding, architecture decisions, and tech stack recommendations.

### Scenario
Generate architecture for extracting a notification microservice from the High Scores monolith.

### Live Coding Steps

**Step 1: Request architecture generation**
```
# In Copilot Chat:
@workspace Generate architecture for a new notification microservice

Context:
- Extracting notification logic from High Scores monolith
- Service: Send notifications when new high scores are achieved
- Deployment: Azure Container Apps (same as main app)
- Communication: Event-driven using Azure Service Bus

Requirements:
1. Project structure for Spring Boot microservice
2. Dockerfile (multi-stage build matching existing pattern)
3. API contract (OpenAPI spec)
4. Infrastructure as Code (Terraform module)
5. Event schemas for Service Bus messages
6. CI/CD pipeline (GitHub Actions)

Generate complete scaffolding with all files.
```

**Step 2: Copilot generates project structure**
```
## Generated Architecture: Notification Service

### Project Structure
```
notification-service/
├── src/
│   ├── main/
│   │   ├── java/com/insight/notifications/
│   │   │   ├── NotificationApplication.java
│   │   │   ├── config/
│   │   │   │   └── ServiceBusConfig.java
│   │   │   ├── listener/
│   │   │   │   └── HighScoreEventListener.java
│   │   │   ├── service/
│   │   │   │   └── NotificationService.java
│   │   │   └── dto/
│   │   │       └── HighScoreEvent.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── Dockerfile
├── build.gradle
└── README.md
```

### Event Schema (dto/HighScoreEvent.java)
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class HighScoreEvent {
    private String playerName;
    private String gameName;
    private Long score;
    private Long previousHighScore;
    private LocalDateTime achievedAt;
    private boolean isNewRecord;
}
```

### Service Bus Listener
```java
@Component
@Slf4j
@RequiredArgsConstructor
public class HighScoreEventListener {
    
    private final NotificationService notificationService;
    
    @ServiceBusListener(
        destination = "highscore-events",
        subscription = "notification-service"
    )
    public void handleHighScoreEvent(HighScoreEvent event) {
        log.info("Received high score event: player={}, game={}, score={}", 
                 event.getPlayerName(), event.getGameName(), event.getScore());
        
        if (event.isNewRecord()) {
            notificationService.sendNewRecordNotification(event);
        }
    }
}
```

### Terraform Module
```hcl
# terraform/modules/notification-service/main.tf
resource "azurerm_container_app" "notification_service" {
  name                         = "notification-service-${var.environment}"
  container_app_environment_id = var.container_app_env_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "notification-service"
      image  = "${var.container_registry}/notification-service:${var.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name        = "AZURE_SERVICEBUS_CONNECTION_STRING"
        secret_name = "servicebus-connection"
      }
    }
  }
}
```
```

**Step 3: Generate ADR (Architecture Decision Record)**
```
# In Copilot Chat:
@workspace Generate ADR for event-driven notification service
```

```markdown
<!-- docs/adr/001-notification-microservice.md -->

# ADR 001: Event-Driven Notification Microservice

## Status
Proposed

## Context
High score achievements need real-time notifications. Currently embedded in monolith, causing:
- Tight coupling between scoring and notification logic
- Difficulty scaling notification processing independently
- Complex testing of notification scenarios

## Decision
Extract notifications into a separate microservice using:
- **Azure Service Bus** for event communication
- **Spring Boot** to match existing tech stack
- **Container Apps** for deployment consistency

## Alternatives Considered
| Option | Pros | Cons |
|--------|------|------|
| Keep in monolith | Simple, no network calls | Tight coupling, scaling issues |
| HTTP webhooks | Simple implementation | Synchronous, adds latency |
| Azure Functions | Auto-scaling, pay-per-use | Different tech stack |
| **Service Bus (chosen)** | Async, reliable, decoupled | Additional infrastructure |

## Consequences
- (+) Independent scaling of notifications
- (+) Async processing doesn't block score submission
- (+) Dead letter queue for failed notifications
- (-) Additional infrastructure complexity
- (-) Eventual consistency (notifications may be delayed)
```

### Teaching Points

| Generation Type | Use Case |
|----------------|----------|
| Project structure | New services, microservices |
| Event schemas | Message contracts |
| Infrastructure | Terraform modules |
| ADRs | Architecture decisions |

---

## Demo 9: Customize Copilot (5 min)

### Objective
Configure Copilot behavior through VS Code settings, extensions, and MCP (Model Context Protocol) servers.

### Scenario
Customize Copilot for optimal High Scores Demo development experience.

### Live Coding Steps

**Step 1: Configure VS Code Settings**
```json
// .vscode/settings.json
{
  // Copilot general settings
  "github.copilot.enable": {
    "*": true,
    "yaml": true,
    "markdown": true,
    "plaintext": false
  },
  
  // Copilot Chat settings
  "github.copilot.chat.localeOverride": "en",
  "github.copilot.chat.welcomeMessage": "always",
  
  // Code suggestions
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.editor.enableCodeActions": true,
  
  // Workspace-specific instruction file
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": ".github/copilot-instructions.md"
    }
  ],
  
  // Test generation preferences
  "github.copilot.chat.testGeneration.instructions": [
    {
      "text": "Use JUnit 5 with AssertJ assertions for Java tests"
    },
    {
      "text": "Use Vitest with Testing Library for React tests"
    }
  ]
}
```

**Step 2: Configure MCP Servers for Enhanced Context**
```json
// .vscode/mcp.json
{
  "servers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"],
      "description": "Live documentation for Spring Boot, React, and Tailwind"
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${env:DATABASE_URL}"
      },
      "description": "Query High Scores database schema"
    }
  }
}
```

**Step 3: Create Custom Code Actions**
```json
// .vscode/settings.json (additional)
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  
  // Custom slash commands via prompt files
  "github.copilot.chat.promptFiles": true
}
```

**Step 4: Workspace-specific Copilot Configuration**
```markdown
<!-- .github/copilot-instructions.md (additions) -->

## Custom Copilot Behavior

### Code Generation Preferences
- **Java**: Always use records for DTOs when immutability is appropriate
- **TypeScript**: Prefer `interface` over `type` for object shapes
- **Tests**: Generate descriptive test names using `should_expectedBehavior_when_condition`

### File Naming Conventions
- Java: `PascalCase` for classes, `camelCase` for methods
- TypeScript: `PascalCase.tsx` for components, `camelCase.ts` for utilities
- Tests: `*Test.java` for Java, `*.test.tsx` for React

### Import Organization
```java
// Java import order
import com.insight.ai_demo.*      // Project imports first
import jakarta.*                   // Jakarta EE
import lombok.*                    // Lombok
import org.springframework.*       // Spring
import java.*                      // Java standard library
```
```

**Step 5: Install Recommended Extensions**
```json
// .vscode/extensions.json
{
  "recommendations": [
    "GitHub.copilot",
    "GitHub.copilot-chat",
    "GitHub.vscode-pull-request-github",
    "vscjava.vscode-java-pack",
    "vmware.vscode-spring-boot",
    "bradlc.vscode-tailwindcss",
    "humao.rest-client"
  ]
}
```

### Teaching Points

| Customization Area | Purpose |
|-------------------|---------|
| VS Code settings | Control Copilot behavior per language/file type |
| Instruction files | Project-specific rules automatically applied |
| MCP servers | Extend Copilot with live documentation/database context |
| Prompt files | Reusable templates for consistent generation |
| Extensions | Enhanced IDE integration |

**Key Customization Options**:
```
# Enable/disable per file type
github.copilot.enable.*

# Instruction files for context
github.copilot.chat.codeGeneration.instructions

# Test generation preferences
github.copilot.chat.testGeneration.instructions

# MCP servers for external context
.vscode/mcp.json
```

---

## Workshop Summary

### 9 Advanced Techniques Mastered

| # | Technique | Key Takeaway |
|---|-----------|--------------|
| 1 | **Chain-of-Thought** | Break complex features into numbered steps |
| 2 | **Instruction Files** | Project rules with 🚨 critical markers |
| 3 | **Prompt Files** | Reusable templates in `.github/prompts/` |
| 4 | **Code Review** | Security, performance, and convention checks |
| 5 | **Plan Mode** | Multi-phase architecture before coding |
| 6 | **Coding Agent** | Autonomous multi-file refactoring |
| 7 | **Agent HQ** | Custom agents for specialized tasks |
| 8 | **Architecture Gen** | Scaffolding, ADRs, tech stack decisions |
| 9 | **Customize Copilot** | Settings, MCP servers, workspace config |

### Quick Reference

```
# Chain-of-Thought (Java)
/**
 * CHAIN OF THOUGHT: [Feature Name]
 * Step 1: [requirement]
 * Step 2: [data model]
 * Step 3: [business logic]
 * Now implement:
 */

# Instruction File
### 🚨 CRITICAL: [Rule Name]
// ❌ WRONG - [anti-pattern]
// ✅ CORRECT - [pattern]

# Prompt File
<!-- .github/prompts/[name].prompt.md -->
## Requirements
## Template
## Checklist

# Code Review
@workspace Review for security, Lombok usage, pagination patterns

# Plan Mode
@plan Create plan for [complex task]

# Coding Agent
@agent Add [feature] to all [components] in [directory]

# Agent HQ
@[custom-agent] [task description]

# Architecture
Generate Spring Boot microservice for [description]

# Customize Copilot
.vscode/settings.json - Editor preferences
.vscode/mcp.json - MCP server configuration
.github/copilot-instructions.md - Project rules
```

### High Scores Demo Specific Patterns

| Component | Pattern |
|-----------|---------|
| Controllers | `@RequiredArgsConstructor`, `ResponseEntity<Map<String, Object>>` |
| Services | `@Slf4j`, `@Transactional`, structured logging |
| Entities | `@Data`, `@NoArgsConstructor`, `@AllArgsConstructor` |
| Frontend API | `ApiResponse<T>` wrapper, `@/app/api` imports |
| Tests | JUnit 5 + Testcontainers (backend), Vitest (frontend) |

### Next Workshop Preview

**Workshop 4: Expert Web Development**
- MCP Servers for live documentation
- Spec Kit for feature specifications
- Terraform planning agents
- Full production deployment workflow

---

## Resources

- **Instruction File**: `.github/copilot-instructions.md`
- **Prompt Files**: `.github/prompts/`
- **Agent Definitions**: `.github/copilot-agents/`
- **VS Code Config**: `.vscode/settings.json`, `.vscode/mcp.json`
- **Project Docs**: `docs/DEPLOYMENT.md`, `docs/AZURE_DEPLOYMENT_GUIDE.md`

