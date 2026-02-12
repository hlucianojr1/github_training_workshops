# Phase 2: Enhance the Go Backend

> **Created:** January 28, 2026  
> **Status:** 🔲 Not Started  
> **Goal:** Restructure Go backend to `internal/` layout, extend data model (kills/wins/challenges/trophies), implement explicit SQL migrations with `golang-migrate`, configure separate database, and add structured logging with request IDs.

---

## Executive Summary

| Step | Description | Status | Progress |
|------|-------------|--------|----------|
| 1 | Restructure to `internal/` layout | 🔲 Not Started | 0% |
| 2 | Extend `GameScore` model | 🔲 Not Started | 0% |
| 3 | Create Challenge & Trophy domain entities | 🔲 Not Started | 0% |
| 4 | Add explicit SQL migrations | 🔲 Not Started | 0% |
| 5 | Implement storage adapters | 🔲 Not Started | 0% |
| 6 | Create HTTP handlers & routes | 🔲 Not Started | 0% |
| 7 | Add request-ID & structured logging middleware | 🔲 Not Started | 0% |
| 8 | Add config & observability | 🔲 Not Started | 0% |
| 9 | Update entrypoint | 🔲 Not Started | 0% |
| 10 | Add/update tests | 🔲 Not Started | 0% |
| 11 | Update dependencies | 🔲 Not Started | 0% |
| 12 | Update Docker & Compose | 🔲 Not Started | 0% |

---

## Step 1: Restructure to `internal/` Layout

**Goal:** Reorganize codebase to follow Go best practices per [copilot-instructions.md](../.github/copilot-instructions.md) section 4.1.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 1.1 | Create `go-backend/cmd/highscores-api/` directory | 🔲 | Entrypoint location |
| 1.2 | Create `go-backend/internal/domain/` directory | 🔲 | Pure domain types + business rules |
| 1.3 | Create `go-backend/internal/httpapi/` directory | 🔲 | Routing, handlers, middleware |
| 1.4 | Create `go-backend/internal/storage/` directory | 🔲 | Persistence adapters |
| 1.5 | Create `go-backend/internal/config/` directory | 🔲 | Environment/config loading |
| 1.6 | Create `go-backend/internal/observability/` directory | 🔲 | Logging/metrics wiring |
| 1.7 | Move `models/game_score.go` → `internal/domain/score.go` | 🔲 | Update imports |
| 1.8 | Move `models/websocket.go` → `internal/domain/websocket.go` | 🔲 | WebSocket message types |
| 1.9 | Move `handlers/score_handler.go` → `internal/httpapi/score_handler.go` | 🔲 | Update imports |
| 1.10 | Move `handlers/websocket_handler.go` → `internal/httpapi/websocket_handler.go` | 🔲 | Update imports |
| 1.11 | Move `repository/game_score_repository.go` → `internal/storage/score_repository.go` | 🔲 | Update imports |
| 1.12 | Move `service/game_score_service.go` → `internal/domain/score_service.go` | 🔲 | Business logic in domain |
| 1.13 | Move `service/notification_service.go` → `internal/domain/notification_service.go` | 🔲 | Or keep in separate `internal/service/` |
| 1.14 | Update all import paths from `github.com/insight/high-scores-go/{models,handlers,repository,service}` | 🔲 | To `internal/` paths |
| 1.15 | Verify build compiles after restructure | 🔲 | `go build ./...` |

### Import Boundary Rules

- `internal/domain` must NOT import `internal/httpapi` or `internal/storage`
- `internal/httpapi` depends on `domain` + small interfaces, not concrete DB types
- `internal/storage` implements interfaces defined in `domain`

---

## Step 2: Extend `GameScore` Model

**Goal:** Add kills, wins, gameMode fields to support frontend features.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 2.1 | Add `Kills *int` field to `GameScore` struct | 🔲 | Nullable for backward compat |
| 2.2 | Add `Wins *int` field to `GameScore` struct | 🔲 | Nullable for backward compat |
| 2.3 | Add `GameMode string` field to `GameScore` struct | 🔲 | Values: "multiplayer", "campaign", "coop" |
| 2.4 | Update `ScoreSubmissionRequest` DTO | 🔲 | Add optional kills, wins, gameMode |
| 2.5 | Update `ScoreResponse` DTO | 🔲 | Include kills, wins, gameMode in responses |
| 2.6 | Update `ToResponse()` method | 🔲 | Map new fields |
| 2.7 | Update seed data with sample kills/wins | 🔲 | In `internal/storage/seed.go` or migrations |

### Data Model

```go
// internal/domain/score.go
type GameScore struct {
    ID         uint           `gorm:"primaryKey" json:"id"`
    PlayerName string         `gorm:"not null;index" json:"playerName"`
    GameName   string         `gorm:"not null;index" json:"gameName"`
    Score      int64          `gorm:"not null" json:"score"`
    Kills      *int           `json:"kills,omitempty"`      // NEW
    Wins       *int           `json:"wins,omitempty"`       // NEW
    GameMode   string         `json:"gameMode,omitempty"`   // NEW
    AchievedAt time.Time      `gorm:"not null" json:"achievedAt"`
    CreatedAt  time.Time      `json:"createdAt"`
    UpdatedAt  time.Time      `json:"-"`
    DeletedAt  gorm.DeletedAt `gorm:"index" json:"-"`
}
```

---

## Step 3: Create Challenge & Trophy Domain Entities

**Goal:** Define new domain types for challenges and trophies.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 3.1 | Create `internal/domain/challenge.go` | 🔲 | Challenge struct |
| 3.2 | Create `internal/domain/trophy.go` | 🔲 | Trophy struct |
| 3.3 | Create `internal/domain/player_progress.go` | 🔲 | PlayerChallengeProgress, PlayerTrophy |
| 3.4 | Create `internal/domain/errors.go` | 🔲 | Sentinel errors |

### Data Models

```go
// internal/domain/challenge.go
type Challenge struct {
    ID          uint   `gorm:"primaryKey" json:"id"`
    Title       string `gorm:"not null" json:"title"`
    Description string `json:"description"`
    Type        string `json:"type"`        // "combat", "tactical", "exploration"
    Difficulty  string `json:"difficulty"`  // "easy", "medium", "hard", "extreme"
    TargetValue int    `json:"targetValue"`
    Reward      string `json:"reward"`
    IconName    string `json:"iconName"`
    CreatedAt   time.Time `json:"createdAt"`
}

// internal/domain/trophy.go
type Trophy struct {
    ID          uint   `gorm:"primaryKey" json:"id"`
    Name        string `gorm:"not null" json:"name"`
    Description string `json:"description"`
    Rarity      string `json:"rarity"` // "COMMON", "RARE", "EPIC", "LEGENDARY"
    IconName    string `json:"iconName"`
    Requirement string `json:"requirement"`
    CreatedAt   time.Time `json:"createdAt"`
}

// internal/domain/player_progress.go
type PlayerChallengeProgress struct {
    ID              uint       `gorm:"primaryKey" json:"id"`
    PlayerName      string     `gorm:"not null;index" json:"playerName"`
    ChallengeID     uint       `gorm:"not null;index" json:"challengeId"`
    Challenge       *Challenge `gorm:"foreignKey:ChallengeID" json:"challenge,omitempty"`
    CurrentProgress int        `json:"currentProgress"`
    Completed       bool       `json:"completed"`
    CompletedAt     *time.Time `json:"completedAt,omitempty"`
    CreatedAt       time.Time  `json:"createdAt"`
    UpdatedAt       time.Time  `json:"-"`
}

type PlayerTrophy struct {
    ID         uint      `gorm:"primaryKey" json:"id"`
    PlayerName string    `gorm:"not null;index" json:"playerName"`
    TrophyID   uint      `gorm:"not null;index" json:"trophyId"`
    Trophy     *Trophy   `gorm:"foreignKey:TrophyID" json:"trophy,omitempty"`
    UnlockedAt time.Time `json:"unlockedAt"`
    CreatedAt  time.Time `json:"createdAt"`
}

// internal/domain/errors.go
var (
    ErrChallengeNotFound = errors.New("challenge not found")
    ErrTrophyNotFound    = errors.New("trophy not found")
    ErrProgressNotFound  = errors.New("player progress not found")
    ErrAlreadyUnlocked   = errors.New("trophy already unlocked")
    ErrInvalidInput      = errors.New("invalid input")
)
```

---

## Step 4: Add Explicit SQL Migrations

**Goal:** Create migration files for all schema changes using `golang-migrate` format.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 4.1 | Create `go-backend/migrations/` directory | 🔲 | Migration files location |
| 4.2 | Create `000001_create_game_scores.up.sql` | 🔲 | Baseline schema |
| 4.3 | Create `000001_create_game_scores.down.sql` | 🔲 | Rollback |
| 4.4 | Create `000002_add_kills_wins_gamemode.up.sql` | 🔲 | Extend game_scores |
| 4.5 | Create `000002_add_kills_wins_gamemode.down.sql` | 🔲 | Rollback |
| 4.6 | Create `000003_create_challenges.up.sql` | 🔲 | Challenges table |
| 4.7 | Create `000003_create_challenges.down.sql` | 🔲 | Rollback |
| 4.8 | Create `000004_create_trophies.up.sql` | 🔲 | Trophies table |
| 4.9 | Create `000004_create_trophies.down.sql` | 🔲 | Rollback |
| 4.10 | Create `000005_create_player_challenge_progress.up.sql` | 🔲 | Progress table |
| 4.11 | Create `000005_create_player_challenge_progress.down.sql` | 🔲 | Rollback |
| 4.12 | Create `000006_create_player_trophies.up.sql` | 🔲 | Player trophies table |
| 4.13 | Create `000006_create_player_trophies.down.sql` | 🔲 | Rollback |
| 4.14 | Create `000007_seed_challenges.up.sql` | 🔲 | Initial challenge data |
| 4.15 | Create `000007_seed_challenges.down.sql` | 🔲 | Rollback seed |
| 4.16 | Create `000008_seed_trophies.up.sql` | 🔲 | Initial trophy data |
| 4.17 | Create `000008_seed_trophies.down.sql` | 🔲 | Rollback seed |

### Migration File Examples

```sql
-- 000001_create_game_scores.up.sql
CREATE TABLE IF NOT EXISTS game_scores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    player_name TEXT NOT NULL,
    game_name TEXT NOT NULL,
    score INTEGER NOT NULL,
    achieved_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME
);
CREATE INDEX idx_game_scores_player_name ON game_scores(player_name);
CREATE INDEX idx_game_scores_game_name ON game_scores(game_name);
CREATE INDEX idx_game_scores_deleted_at ON game_scores(deleted_at);

-- 000002_add_kills_wins_gamemode.up.sql
ALTER TABLE game_scores ADD COLUMN kills INTEGER;
ALTER TABLE game_scores ADD COLUMN wins INTEGER;
ALTER TABLE game_scores ADD COLUMN game_mode TEXT DEFAULT '';

-- 000003_create_challenges.up.sql
CREATE TABLE IF NOT EXISTS challenges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    type TEXT,
    difficulty TEXT,
    target_value INTEGER DEFAULT 0,
    reward TEXT,
    icon_name TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 000004_create_trophies.up.sql
CREATE TABLE IF NOT EXISTS trophies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    rarity TEXT,
    icon_name TEXT,
    requirement TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 000005_create_player_challenge_progress.up.sql
CREATE TABLE IF NOT EXISTS player_challenge_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    player_name TEXT NOT NULL,
    challenge_id INTEGER NOT NULL,
    current_progress INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    completed_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (challenge_id) REFERENCES challenges(id)
);
CREATE INDEX idx_pcp_player_name ON player_challenge_progress(player_name);
CREATE INDEX idx_pcp_challenge_id ON player_challenge_progress(challenge_id);

-- 000006_create_player_trophies.up.sql
CREATE TABLE IF NOT EXISTS player_trophies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    player_name TEXT NOT NULL,
    trophy_id INTEGER NOT NULL,
    unlocked_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trophy_id) REFERENCES trophies(id),
    UNIQUE(player_name, trophy_id)
);
CREATE INDEX idx_pt_player_name ON player_trophies(player_name);
CREATE INDEX idx_pt_trophy_id ON player_trophies(trophy_id);
```

---

## Step 5: Implement Storage Adapters

**Goal:** Create repository implementations for all entities.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 5.1 | Create `internal/storage/db.go` | 🔲 | Database connection setup |
| 5.2 | Create `internal/storage/migrator.go` | 🔲 | golang-migrate wrapper |
| 5.3 | Refactor to `internal/storage/score_repository.go` | 🔲 | Move from repository/ |
| 5.4 | Create `internal/storage/challenge_repository.go` | 🔲 | CRUD for challenges |
| 5.5 | Create `internal/storage/trophy_repository.go` | 🔲 | CRUD for trophies |
| 5.6 | Create `internal/storage/player_progress_repository.go` | 🔲 | Progress + trophy unlock |
| 5.7 | Define repository interfaces in `internal/domain/` | 🔲 | For dependency inversion |

### Repository Interfaces

```go
// internal/domain/repositories.go
type ScoreRepository interface {
    Create(ctx context.Context, score *GameScore) error
    FindByID(ctx context.Context, id uint) (*GameScore, error)
    FindTopScoresForGame(ctx context.Context, gameName string, limit int) ([]GameScore, error)
    // ... other methods
}

type ChallengeRepository interface {
    Create(ctx context.Context, challenge *Challenge) error
    FindByID(ctx context.Context, id uint) (*Challenge, error)
    FindAll(ctx context.Context) ([]Challenge, error)
}

type TrophyRepository interface {
    Create(ctx context.Context, trophy *Trophy) error
    FindByID(ctx context.Context, id uint) (*Trophy, error)
    FindAll(ctx context.Context) ([]Trophy, error)
}

type PlayerProgressRepository interface {
    GetChallengeProgress(ctx context.Context, playerName string, challengeID uint) (*PlayerChallengeProgress, error)
    UpdateChallengeProgress(ctx context.Context, progress *PlayerChallengeProgress) error
    GetPlayerChallenges(ctx context.Context, playerName string) ([]PlayerChallengeProgress, error)
    GetPlayerTrophies(ctx context.Context, playerName string) ([]PlayerTrophy, error)
    UnlockTrophy(ctx context.Context, playerName string, trophyID uint) (*PlayerTrophy, error)
}
```

---

## Step 6: Create HTTP Handlers & Routes

**Goal:** Implement REST endpoints for challenges, trophies, and player progress.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 6.1 | Create `internal/httpapi/router.go` | 🔲 | Central route registration |
| 6.2 | Create `internal/httpapi/errors.go` | 🔲 | Consistent JSON error helper |
| 6.3 | Refactor `internal/httpapi/score_handler.go` | 🔲 | Use new error format |
| 6.4 | Create `internal/httpapi/challenge_handler.go` | 🔲 | Challenge endpoints |
| 6.5 | Create `internal/httpapi/trophy_handler.go` | 🔲 | Trophy endpoints |
| 6.6 | Create `internal/httpapi/player_progress_handler.go` | 🔲 | Progress endpoints |
| 6.7 | Add request validation helpers | 🔲 | Validate required fields, bounds |

### API Endpoints

| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | `/api/challenges` | `GetAllChallenges` | List all challenges |
| GET | `/api/challenges/{id}` | `GetChallenge` | Get challenge by ID |
| POST | `/api/challenges` | `CreateChallenge` | Create challenge (admin) |
| GET | `/api/trophies` | `GetAllTrophies` | List all trophies |
| GET | `/api/trophies/{id}` | `GetTrophy` | Get trophy by ID |
| POST | `/api/trophies` | `CreateTrophy` | Create trophy (admin) |
| GET | `/api/players/{player}/challenges` | `GetPlayerChallenges` | Player's challenge progress |
| PUT | `/api/players/{player}/challenges/{id}/progress` | `UpdateChallengeProgress` | Update progress |
| GET | `/api/players/{player}/trophies` | `GetPlayerTrophies` | Player's unlocked trophies |
| POST | `/api/players/{player}/trophies/{id}/unlock` | `UnlockTrophy` | Unlock a trophy |

### Error Response Format

```go
// internal/httpapi/errors.go
type ErrorResponse struct {
    Error ErrorDetail `json:"error"`
}

type ErrorDetail struct {
    Code    string `json:"code"`
    Message string `json:"message"`
}

// Usage
func RespondError(c *gin.Context, status int, code, message string) {
    c.JSON(status, ErrorResponse{
        Error: ErrorDetail{Code: code, Message: message},
    })
}

// Error codes
const (
    ErrCodeValidation    = "VALIDATION_ERROR"
    ErrCodeNotFound      = "NOT_FOUND"
    ErrCodeInternal      = "INTERNAL_ERROR"
    ErrCodeAlreadyExists = "ALREADY_EXISTS"
)
```

---

## Step 7: Add Request-ID & Structured Logging Middleware

**Goal:** Implement request tracing and JSON-formatted logging.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 7.1 | Create `internal/httpapi/middleware.go` | 🔲 | Middleware definitions |
| 7.2 | Implement `RequestIDMiddleware` | 🔲 | Extract/generate X-Request-Id |
| 7.3 | Implement `LoggingMiddleware` | 🔲 | Log with zerolog |
| 7.4 | Implement `RecoveryMiddleware` | 🔲 | Panic recovery with logging |
| 7.5 | Add context key for request ID | 🔲 | `internal/httpapi/context.go` |
| 7.6 | Wire middleware in router | 🔲 | Apply to all routes |

### Middleware Implementation

```go
// internal/httpapi/middleware.go
func RequestIDMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        requestID := c.GetHeader("X-Request-Id")
        if requestID == "" {
            requestID = uuid.New().String()
        }
        c.Set("request_id", requestID)
        c.Header("X-Request-Id", requestID)
        c.Next()
    }
}

func LoggingMiddleware(logger zerolog.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        path := c.Request.URL.Path
        
        c.Next()
        
        logger.Info().
            Str("request_id", c.GetString("request_id")).
            Str("method", c.Request.Method).
            Str("path", path).
            Int("status", c.Writer.Status()).
            Dur("latency", time.Since(start)).
            Str("client_ip", c.ClientIP()).
            Msg("request completed")
    }
}
```

---

## Step 8: Add Config & Observability

**Goal:** Centralize configuration and logging setup.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 8.1 | Create `internal/config/config.go` | 🔲 | Config struct + loader |
| 8.2 | Create `internal/observability/logger.go` | 🔲 | Zerolog setup |
| 8.3 | Add environment variable support | 🔲 | GO_DB_PATH, PORT, LOG_LEVEL |
| 8.4 | Add config validation | 🔲 | Required fields, defaults |

### Configuration

```go
// internal/config/config.go
type Config struct {
    Port           string
    DBPath         string
    MigrationsPath string
    LogLevel       string
    Environment    string // "development", "production"
}

func Load() (*Config, error) {
    return &Config{
        Port:           getEnv("PORT", "8081"),
        DBPath:         getEnv("GO_DB_PATH", "go-highscores.db"),
        MigrationsPath: getEnv("MIGRATIONS_PATH", "migrations"),
        LogLevel:       getEnv("LOG_LEVEL", "info"),
        Environment:    getEnv("ENVIRONMENT", "development"),
    }, nil
}

func getEnv(key, defaultValue string) string {
    if value := os.Getenv(key); value != "" {
        return value
    }
    return defaultValue
}
```

```go
// internal/observability/logger.go
func NewLogger(level, env string) zerolog.Logger {
    lvl, _ := zerolog.ParseLevel(level)
    zerolog.SetGlobalLevel(lvl)
    
    if env == "development" {
        return zerolog.New(zerolog.ConsoleWriter{Out: os.Stdout}).
            With().Timestamp().Caller().Logger()
    }
    
    return zerolog.New(os.Stdout).
        With().Timestamp().Logger()
}
```

---

## Step 9: Update Entrypoint

**Goal:** Rewrite main.go to use new architecture.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 9.1 | Create `cmd/highscores-api/main.go` | 🔲 | New entrypoint |
| 9.2 | Load config via `internal/config` | 🔲 | |
| 9.3 | Initialize logger via `internal/observability` | 🔲 | |
| 9.4 | Run migrations via `internal/storage/migrator` | 🔲 | |
| 9.5 | Wire repositories with interfaces | 🔲 | |
| 9.6 | Wire services with dependencies | 🔲 | |
| 9.7 | Wire handlers with services | 🔲 | |
| 9.8 | Set server timeouts | 🔲 | Read: 15s, Write: 15s, Idle: 60s |
| 9.9 | Start Gin router via `internal/httpapi/router` | 🔲 | |
| 9.10 | Add graceful shutdown | 🔲 | Handle SIGINT/SIGTERM |
| 9.11 | Delete old `go-backend/main.go` | 🔲 | After migration complete |

### Server Timeouts

```go
// cmd/highscores-api/main.go
server := &http.Server{
    Addr:         ":" + cfg.Port,
    Handler:      router,
    ReadTimeout:  15 * time.Second,
    WriteTimeout: 15 * time.Second,
    IdleTimeout:  60 * time.Second,
}
```

---

## Step 10: Add/Update Tests

**Goal:** Comprehensive test coverage for new functionality.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 10.1 | Create `internal/httpapi/challenge_handler_test.go` | 🔲 | Table-driven tests |
| 10.2 | Create `internal/httpapi/trophy_handler_test.go` | 🔲 | Table-driven tests |
| 10.3 | Create `internal/httpapi/player_progress_handler_test.go` | 🔲 | Table-driven tests |
| 10.4 | Create `internal/storage/challenge_repository_test.go` | 🔲 | |
| 10.5 | Create `internal/storage/trophy_repository_test.go` | 🔲 | |
| 10.6 | Create `internal/storage/player_progress_repository_test.go` | 🔲 | |
| 10.7 | Migrate existing tests to new structure | 🔲 | Or keep as integration tests |
| 10.8 | Add test coverage for middleware | 🔲 | Request ID, logging |
| 10.9 | Verify all tests pass | 🔲 | `go test ./...` |

### Test Coverage Requirements

Each handler test file must include:
- ✅ Happy path (200/201 response)
- ✅ Validation failure (400 response)
- ✅ Not found (404 response)
- ✅ Repository/internal error (500 response)

### Test Example

```go
// internal/httpapi/challenge_handler_test.go
func TestChallengeHandler_GetAll(t *testing.T) {
    t.Parallel()
    
    tests := []struct {
        name           string
        setupMock      func(*MockChallengeRepo)
        expectedStatus int
        expectedBody   string
    }{
        {
            name: "success - returns challenges",
            setupMock: func(m *MockChallengeRepo) {
                m.On("FindAll", mock.Anything).Return([]domain.Challenge{
                    {ID: 1, Title: "First Blood"},
                }, nil)
            },
            expectedStatus: http.StatusOK,
        },
        {
            name: "error - repository failure",
            setupMock: func(m *MockChallengeRepo) {
                m.On("FindAll", mock.Anything).Return(nil, errors.New("db error"))
            },
            expectedStatus: http.StatusInternalServerError,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()
            // ... test implementation
        })
    }
}
```

---

## Step 11: Update Dependencies

**Goal:** Add required packages and clean up go.mod.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 11.1 | Add `github.com/rs/zerolog` | 🔲 | Structured logging |
| 11.2 | Add `github.com/golang-migrate/migrate/v4` | 🔲 | Migration runner |
| 11.3 | Add `github.com/golang-migrate/migrate/v4/database/sqlite3` | 🔲 | SQLite driver |
| 11.4 | Add `github.com/golang-migrate/migrate/v4/source/file` | 🔲 | File source |
| 11.5 | Run `go mod tidy` | 🔲 | Clean up unused deps |
| 11.6 | Verify no security vulnerabilities | 🔲 | `go list -m all` |

### Commands

```bash
cd go-backend
go get github.com/rs/zerolog
go get github.com/golang-migrate/migrate/v4
go get github.com/golang-migrate/migrate/v4/database/sqlite3
go get github.com/golang-migrate/migrate/v4/source/file
go mod tidy
```

---

## Step 12: Update Docker & Compose

**Goal:** Update build and deployment configuration.

### Tasks

| ID | Task | Status | Notes |
|----|------|--------|-------|
| 12.1 | Update `go-backend/Dockerfile` build path | 🔲 | `cmd/highscores-api/` |
| 12.2 | Copy migrations folder in Dockerfile | 🔲 | `COPY migrations/ /app/migrations/` |
| 12.3 | Update `docker-compose.yml` environment | 🔲 | Set `GO_DB_PATH` |
| 12.4 | Add separate volume for Go database | 🔲 | `go-db-data:/data` |
| 12.5 | Verify Docker build works | 🔲 | `docker build -t go-backend .` |
| 12.6 | Verify docker-compose up works | 🔲 | Full stack test |

### Dockerfile Changes

```dockerfile
# go-backend/Dockerfile
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=1 go build -o highscores-api ./cmd/highscores-api

FROM alpine:latest
RUN apk add --no-cache sqlite-libs
WORKDIR /app
COPY --from=builder /app/highscores-api .
COPY --from=builder /app/migrations ./migrations
ENV PORT=8081
ENV GO_DB_PATH=/data/go-highscores.db
ENV MIGRATIONS_PATH=/app/migrations
EXPOSE 8081
CMD ["./highscores-api"]
```

### docker-compose.yml Changes

```yaml
go-backend:
  build: ./go-backend
  ports:
    - "8081:8081"
  environment:
    - PORT=8081
    - GO_DB_PATH=/data/go-highscores.db
    - MIGRATIONS_PATH=/app/migrations
    - LOG_LEVEL=info
    - ENVIRONMENT=production
  volumes:
    - go-db-data:/data

volumes:
  go-db-data:
```

---

## File Structure After Phase 2

```
go-backend/
├── cmd/
│   └── highscores-api/
│       └── main.go                         # NEW (entrypoint)
├── internal/
│   ├── config/
│   │   └── config.go                       # NEW
│   ├── domain/
│   │   ├── score.go                        # MOVED + EXTENDED
│   │   ├── challenge.go                    # NEW
│   │   ├── trophy.go                       # NEW
│   │   ├── player_progress.go              # NEW
│   │   ├── websocket.go                    # MOVED
│   │   ├── errors.go                       # NEW
│   │   ├── repositories.go                 # NEW (interfaces)
│   │   ├── score_service.go                # MOVED
│   │   └── notification_service.go         # MOVED
│   ├── httpapi/
│   │   ├── router.go                       # NEW
│   │   ├── middleware.go                   # NEW
│   │   ├── errors.go                       # NEW
│   │   ├── context.go                      # NEW
│   │   ├── score_handler.go                # MOVED
│   │   ├── score_handler_test.go           # MOVED
│   │   ├── challenge_handler.go            # NEW
│   │   ├── challenge_handler_test.go       # NEW
│   │   ├── trophy_handler.go               # NEW
│   │   ├── trophy_handler_test.go          # NEW
│   │   ├── player_progress_handler.go      # NEW
│   │   ├── player_progress_handler_test.go # NEW
│   │   └── websocket_handler.go            # MOVED
│   ├── storage/
│   │   ├── db.go                           # NEW
│   │   ├── migrator.go                     # NEW
│   │   ├── score_repository.go             # MOVED
│   │   ├── score_repository_test.go        # MOVED
│   │   ├── challenge_repository.go         # NEW
│   │   ├── challenge_repository_test.go    # NEW
│   │   ├── trophy_repository.go            # NEW
│   │   ├── trophy_repository_test.go       # NEW
│   │   ├── player_progress_repository.go   # NEW
│   │   └── player_progress_repository_test.go # NEW
│   └── observability/
│       └── logger.go                       # NEW
├── migrations/
│   ├── 000001_create_game_scores.up.sql    # NEW
│   ├── 000001_create_game_scores.down.sql  # NEW
│   ├── 000002_add_kills_wins_gamemode.up.sql
│   ├── 000002_add_kills_wins_gamemode.down.sql
│   ├── 000003_create_challenges.up.sql
│   ├── 000003_create_challenges.down.sql
│   ├── 000004_create_trophies.up.sql
│   ├── 000004_create_trophies.down.sql
│   ├── 000005_create_player_challenge_progress.up.sql
│   ├── 000005_create_player_challenge_progress.down.sql
│   ├── 000006_create_player_trophies.up.sql
│   ├── 000006_create_player_trophies.down.sql
│   ├── 000007_seed_challenges.up.sql
│   ├── 000007_seed_challenges.down.sql
│   ├── 000008_seed_trophies.up.sql
│   └── 000008_seed_trophies.down.sql
├── websocket/                              # KEEP
│   ├── hub.go
│   └── client.go
├── go.mod                                  # MODIFIED
├── go.sum                                  # MODIFIED
└── Dockerfile                              # MODIFIED
```

---

## Validation Checklist

Before marking Phase 2 complete:

- [ ] All tests pass: `go test ./...`
- [ ] Build succeeds: `go build ./cmd/highscores-api`
- [ ] Linting passes: `golangci-lint run`
- [ ] Docker build works: `docker build -t go-backend ./go-backend`
- [ ] Docker compose up works: `docker-compose up go-backend`
- [ ] All new endpoints return correct responses
- [ ] Error responses follow `{"error":{"code":"...","message":"..."}}` format
- [ ] Request IDs appear in logs
- [ ] Migrations run successfully on fresh database
- [ ] Frontend contract remains compatible (existing endpoints unchanged)

---

## Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Complete |
| 🔄 | In Progress |
| 🔲 | Not Started |
| ⚠️ | Blocked |
| ❌ | Cancelled |

---

## Changelog

| Date | Step | Changes |
|------|------|---------|
| 2026-01-28 | - | Created Phase 2 plan document |
