# Operation Nightfall - Development Roadmap

> **Last Updated:** January 28, 2026  
> **Status:** In Progress  
> **Branch:** `java_intermedia_workshop`

This roadmap tracks the integration between frontend (React/Vite) and dual-backend architecture (Java Spring Boot + Go) with shared database and Redis event bus.

---

## Architecture Overview

### Backend Service Ownership

| Capability | Java Backend (Port 8080) | Go Backend (Port 8081) | Frontend | Status |
|-----------|--------------------------|------------------------|----------|--------|
| **Scores** | ✅ CRUD with kills/wins/gameMode | ❌ Read-only access | API + WebSocket | ✅ Phase 1 |
| **Leaderboard** | ✅ Data source | ✅ WebSocket broadcasts | API + real-time | ✅ Phase 1 |
| **Screenshots** | ❌ N/A | ❌ N/A | ✅ Static only | ✅ Intentional |
| **Missions (Campaign)** | ✅ CRUD + Prerequisites | ❌ N/A | API calls | 🔲 Phase 2 |
| **Puzzles** | ✅ CRUD + Solution validation | ❌ N/A | API calls | 🔲 Phase 2 |
| **Challenges** | ❌ N/A | ✅ CRUD + Progress tracking | API calls | 🔲 Phase 2-Go |
| **Trophies** | ❌ N/A | ✅ CRUD + Unlock logic + Notifications | API + WebSocket | 🔲 Phase 2-Go |

### Shared Infrastructure

- **Database:** Single SQLite instance at `./data/shared.db` (persistent volume)
- **Event Bus:** Redis Pub/Sub for cross-backend communication
- **WebSocket:** Go backend handles all real-time broadcasts
- **Config:** Runtime configuration via `/api/config` endpoint (SHA-256 versioned)

---

## Executive Summary

| Phase | Description | Status | Progress |
|-------|-------------|--------|----------|
| Phase 1 | Core Integration | ✅ **DONE** | 100% |
| Phase 2 | Java Backend: Scores, Missions, Puzzles + Event Queue | 🔲 Not Started | 0% |
| Phase 2-Go | Go Backend: Challenges, Trophies, Notifications + Redis | 🔲 Not Started | 0% |
| Phase 3 | Shared Database + Redis Infrastructure | 🔲 Not Started | 0% |
| Phase 4 | Frontend: Dual-Backend Integration + Runtime Config | 🔲 Not Started | 0% |
| Phase 5 | WebSocket Token-Based Authentication | 🔲 Future Work | 0% |
| Phase 6 | Advanced Monitoring & Logging | 🔲 Not Started | 0% |
| Phase 7 | Future Enhancements | 🔲 Future Work | 0% |

> **🎯 Key Decision:** Java and Go backends share a single SQLite database with Redis Pub/Sub for event-driven communication.

---

## Phase 1: Core Integration ✅

**Goal:** Connect frontend to backend API with game selection and dynamic leaderboard.

**Timeline:** Weeks 1-2  
**Status:** ✅ Complete

### Milestones

| ID | Task | Status | Agent Notes |
|----|------|--------|-------------|
| 1.1 | Create API types (`frontend/src/app/api/types.ts`) | ✅ Complete | Defines `ScoreResponse`, `ApiResponse<T>`, `ScoreSubmissionRequest`, `PlayerStats`, `GameStats`, `PageResponse<T>`, `LeaderboardEntry` |
| 1.2 | Create API service layer (`frontend/src/app/api/scoreService.ts`) | ✅ Complete | All functions return `Promise<ApiResponse<T>>` with try/catch; base URL from `VITE_API_URL` env var |
| 1.3 | Create barrel export (`frontend/src/app/api/index.ts`) | ✅ Complete | Re-exports types and service functions |
| 1.4 | Create GameContext (`frontend/src/app/context/GameContext.tsx`) | ✅ Complete | Manages `games`, `selectedGame`, URL param sync with `?game=`, defaults to "Operation Nightfall" |
| 1.5 | Create GameSelector component (`frontend/src/app/components/GameSelector.tsx`) | ✅ Complete | Uses Radix Select component; loading state; static fallback when no games |
| 1.6 | Update Navigation component | ✅ Complete | Replaced hardcoded "OPERATION NIGHTFALL" with `<GameSelector />` |
| 1.7 | Wrap App with GameProvider | ✅ Complete | All components can access `useGame()` hook |
| 1.8 | Update Leaderboard component | ✅ Complete | Fetches from `/api/scores/game/{selectedGame}/top`; loading/error states; fallback to demo data |
| 1.9 | Delete archived frontend | ✅ Complete | Removed `_archive/react-frontend/` directory |

### Files Created/Modified

```
frontend/src/app/
├── api/
│   ├── types.ts         # ✅ Created
│   ├── scoreService.ts  # ✅ Created
│   └── index.ts         # ✅ Created
├── context/
│   └── GameContext.tsx  # ✅ Created
├── components/
│   ├── GameSelector.tsx # ✅ Created
│   ├── Navigation.tsx   # ✅ Modified
│   └── Leaderboard.tsx  # ✅ Modified
└── App.tsx              # ✅ Modified
```

---

## Phase 2: Java Backend Extensions 🔲

**Goal:** Extend Java backend with scores (kills/wins/gameMode), missions, puzzles, event queue, and admin monitoring.

**Backend Ownership:** Java handles all score management, campaign missions, and puzzle validation  
**Timeline:** Weeks 3-4  
**Status:** 🔲 Not Started

### Architecture Decisions

- ✅ Migrate from H2 in-memory to **shared SQLite** at `./data/shared.db`
- ✅ Add **persistent event queue** (SQLite table) for reliable Redis publishing
- ✅ Implement **rate-limited admin endpoints** with basic auth (admin/demo123)
- ✅ Use **SHA-256 hashing** for puzzle solution validation
- ✅ Runtime **config endpoint** with SHA-256 versioning for cache invalidation

### Milestones

| ID | Task | Priority | Status | Agent Notes |
|----|------|----------|--------|-------------|
| 2.1 | **Migrate to shared SQLite database** | 🔥 HIGH | 🔲 Not Started | Update `application.properties` to use `jdbc:sqlite:./data/shared.db`; add SQLite JDBC dependency |
| 2.2 | **Extend `GameScore` entity** | 🔥 HIGH | 🔲 Not Started | Add `kills` (Integer), `wins` (Integer), `gameMode` (String) fields - **CRITICAL: Frontend already displays these columns** |
| 2.3 | Update DTOs for extended GameScore | 🔥 HIGH | 🔲 Not Started | Modify `ScoreSubmissionRequest` and `ScoreResponse` to include kills/wins/gameMode |
| 2.4 | Create database migration script | 🔥 HIGH | 🔲 Not Started | `migrate-to-sqlite.sh` to initialize clean database structure |
| 2.5 | Create `EventQueue` entity | 🔥 HIGH | 🔲 Not Started | Fields: id, eventType, payload (JSON), status, attempts, errorMessage, createdAt, processedAt |
| 2.6 | Create `EventPublisher` service | 🔥 HIGH | 🔲 Not Started | Save events to DB → publish to Redis channels (`score:events`, `puzzle:events`) |
| 2.7 | Create `@Scheduled` retry task | 🔥 HIGH | 🔲 Not Started | Every 30s, retry failed events (max 3 attempts, exponential backoff) |
| 2.8 | Add Redis dependencies | 🔥 HIGH | 🔲 Not Started | Add `spring-boot-starter-data-redis` to `build.gradle` |
| 2.9 | Create `RedisConfig` | 🔥 HIGH | 🔲 Not Started | Redis connection configuration (host: `redis`, port: 6379) |
| 2.10 | Create `Mission` entity | 📘 Medium | 🔲 Not Started | Fields: id, number, title, description, location, duration, difficulty, prerequisiteMissionIds (JSON) |
| 2.11 | Create `Puzzle` entity | 📘 Medium | 🔲 Not Started | Fields: id, missionId, title, description, type, difficulty, solutionHash (SHA-256), reward |
| 2.12 | Create `PlayerMissionProgress` entity | 📘 Medium | 🔲 Not Started | Fields: id, playerId, missionId, status (LOCKED/AVAILABLE/IN_PROGRESS/COMPLETED), completedAt |
| 2.13 | Create `PlayerPuzzleProgress` entity | 📘 Medium | 🔲 Not Started | Fields: id, playerId, puzzleId, solved, solvedAt, attempts |
| 2.14 | Create repositories | 📘 Medium | 🔲 Not Started | `MissionRepository`, `PuzzleRepository`, `PlayerMissionProgressRepository`, `PlayerPuzzleProgressRepository`, `EventQueueRepository` |
| 2.15 | Create `MissionService` | 📘 Medium | 🔲 Not Started | Business logic: validate prerequisites before unlocking missions |
| 2.16 | Create `PuzzleService` | 📘 Medium | 🔲 Not Started | Business logic: SHA-256 solution validation, track attempts, publish events with mission context |
| 2.17 | Create `MissionController` | 📘 Medium | 🔲 Not Started | Endpoints: `GET /api/missions`, `GET /api/players/{player}/missions` |
| 2.18 | Create `PuzzleController` | 📘 Medium | 🔲 Not Started | Endpoints: `GET /api/puzzles`, `POST /api/puzzles/{id}/solve` |
| 2.19 | Create `ConfigController` | 📘 Medium | 🔲 Not Started | Endpoint: `GET /api/config` returns `{version, javaApiUrl, goApiUrl, wsUrl}` with SHA-256 version hash |
| 2.20 | Add security dependencies | 📘 Medium | 🔲 Not Started | Add `spring-boot-starter-security`, `bucket4j-core` to `build.gradle` |
| 2.21 | Create `SecurityConfig` | 📘 Medium | 🔲 Not Started | Basic auth for admin endpoints (username: `admin`, password: `demo123`), rate limiter (10 req/min per IP) |
| 2.22 | Create `AdminController` | 📘 Medium | 🔲 Not Started | Endpoint: `GET /api/admin/event-queue?status={PENDING\|FAILED\|COMPLETED}` with pagination |
| 2.23 | Update `GameScoreService` | 📘 Medium | 🔲 Not Started | Publish events to `EventPublisher` after score save |
| 2.24 | Create `DataSeeder` component | 📘 Medium | 🔲 Not Started | Seed 13 scores, 6 missions, 6 puzzles matching frontend hardcoded data |
| 2.25 | Update docker volume mapping | 📘 Medium | 🔲 Not Started | Add `./data:/app/data` volume to Java backend service in `docker-compose.yml` |
| 2.26 | Enhance health endpoint | 📘 Medium | 🔲 Not Started | Add Redis connection status and event queue stats to `/actuator/health` |

### Data Model Changes

```java
// GameScore.java - Extended (JAVA OWNS THIS TABLE)
@Entity
@Table(name = "game_scores")
public class GameScore {
    private Long id;
    private String playerName;
    private String gameName;
    private Long score;
    private Integer kills;      // NEW - URGENT for frontend compatibility
    private Integer wins;       // NEW - URGENT for frontend compatibility
    private String gameMode;    // NEW: "multiplayer", "campaign", "coop"
    private LocalDateTime achievedAt;
    private LocalDateTime createdAt;
}

// Mission.java - New Entity (JAVA OWNS)
@Entity
@Table(name = "missions")
public class Mission {
    private Long id;
    private Integer number;
    private String title;
    private String description;
    private String location;
    private String duration;
    private String difficulty;
    private String prerequisiteMissionIds; // JSON: "[1, 2, 3]"
}

// Puzzle.java - New Entity (JAVA OWNS)
@Entity
@Table(name = "puzzles")
public class Puzzle {
    private Long id;
    private Long missionId;
    private String title;
    private String description;
    private String type;
    private String difficulty;
    private String solutionHash;  // SHA-256 hash for validation
    private String reward;
}

// EventQueue.java - New Entity (JAVA OWNS)
@Entity
@Table(name = "event_queue")
public class EventQueue {
    private Long id;
    private String eventType;     // "SCORE_SUBMITTED", "PUZZLE_SOLVED"
    private String payload;       // JSON payload
    private String status;        // "PENDING", "COMPLETED", "FAILED"
    private Integer attempts;
    private String errorMessage;
    private LocalDateTime createdAt;
    private LocalDateTime processedAt;
}
```

### Event Schemas

```json
// SCORE_SUBMITTED event (Java → Redis → Go)
{
  "type": "SCORE_SUBMITTED",
  "gameName": "Operation Nightfall",
  "playerName": "GhostReaper",
  "score": 145820,
  "kills": 2847,
  "wins": 156,
  "gameMode": "multiplayer",
  "timestamp": "2026-01-28T10:30:00Z"
}

// PUZZLE_SOLVED event (Java → Redis → Go)
{
  "type": "PUZZLE_SOLVED",
  "playerName": "GhostReaper",
  "puzzleId": 1,
  "puzzleTitle": "Cipher Decryption",
  "missionId": 5,
  "missionNumber": 5,
  "allMissionPuzzlesSolved": true,
  "totalPlayerPuzzles": 12,
  "timestamp": "2026-01-28T10:35:00Z",
  "context": {
    "difficulty": "Expert",
    "attempts": 3
  }
}
```

---

## Phase 2-Go: Go Backend Extensions 🔲

**Goal:** Implement challenges, trophies, notifications, and Redis subscription in Go backend.

**Backend Ownership:** Go handles challenges, trophies, notifications, and all WebSocket broadcasts  
**Timeline:** Weeks 3-4 (parallel with Phase 2)  
**Status:** 🔲 Not Started

### Architecture Decisions

- ✅ Use same **shared SQLite** database at `./data/shared.db`
- ✅ Add **unique constraint** on PlayerTrophy (PlayerName + TrophyID) to prevent duplicates
- ✅ Implement **hardcoded trophy unlock logic** (if-else statements for demo)
- ✅ Create **PlayerNotification** table for offline trophy unlocks
- ✅ **Daily cleanup job** removes read notifications older than 30 days
- ✅ Subscribe to Redis channels: `score:events`, `puzzle:events`
- ✅ Add basic auth middleware for admin endpoints (same credentials as Java)

### Milestones

| ID | Task | Priority | Status | Agent Notes |
|----|------|----------|--------|-------------|
| 2G.1 | Update `db.go` to use shared database | 🔥 HIGH | 🔲 Not Started | Change database path to `./data/shared.db` (same as Java) |
| 2G.2 | Create `Challenge` model | 📘 Medium | 🔲 Not Started | Fields: ID, Title, Description, Type, Difficulty, TargetValue, Reward, IconName |
| 2G.3 | Create `Trophy` model | 📘 Medium | 🔲 Not Started | Fields: ID, Name, Description, Rarity, IconName, UnlockCriteria |
| 2G.4 | Create `PlayerChallengeProgress` model | 📘 Medium | 🔲 Not Started | Fields: PlayerName, ChallengeID, CurrentProgress, Completed, CompletedAt |
| 2G.5 | Create `PlayerTrophy` model with constraint | 🔥 HIGH | 🔲 Not Started | Fields: PlayerName, TrophyID, UnlockedAt + `gorm:"uniqueIndex:idx_player_trophy"` |
| 2G.6 | Create `PlayerNotification` model | 📘 Medium | 🔲 Not Started | Fields: ID, PlayerName, Type, Title, Message, Read, CreatedAt |
| 2G.7 | Create `ChallengeRepository` | 📘 Medium | 🔲 Not Started | CRUD operations for challenges |
| 2G.8 | Create `TrophyRepository` | 📘 Medium | 🔲 Not Started | CRUD operations + `HasPlayerUnlockedTrophy(playerName, trophyID)` method |
| 2G.9 | Create `NotificationRepository` | 📘 Medium | 🔲 Not Started | CRUD + `DeleteOldReadNotifications(days int)` method |
| 2G.10 | Create `ChallengeHandler` | 📘 Medium | 🔲 Not Started | Endpoints: `GET /api/challenges`, `POST /api/challenges/{id}/progress` |
| 2G.11 | Create `TrophyHandler` | 📘 Medium | 🔲 Not Started | Endpoints: `GET /api/trophies`, `GET /api/players/{player}/trophies` |
| 2G.12 | Create `NotificationHandler` | 📘 Medium | 🔲 Not Started | Endpoints: `GET /api/players/{player}/notifications`, `PUT /api/notifications/{id}/read` |
| 2G.13 | Create `ConfigHandler` | 📘 Medium | 🔲 Not Started | Endpoint: `GET /api/config` with SHA-256 version hash (same as Java) |
| 2G.14 | Add Redis dependency | 🔥 HIGH | 🔲 Not Started | Add `github.com/redis/go-redis/v9` to `go.mod` |
| 2G.15 | Create `redis_subscriber.go` | 🔥 HIGH | 🔲 Not Started | Subscribe to `score:events` and `puzzle:events` channels with reconnection logic |
| 2G.16 | Create `TrophyService` with unlock logic | 📘 Medium | 🔲 Not Started | Hardcoded if-else logic: check criteria, verify not unlocked, insert PlayerTrophy, create notification |
| 2G.17 | Add WebSocket message types | 📘 Medium | 🔲 Not Started | Add `TROPHY_UNLOCKED`, `CHALLENGE_PROGRESS`, `PUZZLE_SOLVED` to `websocket.go` |
| 2G.18 | Update WebSocket Hub | 📘 Medium | 🔲 Not Started | Support broadcasting new message types |
| 2G.19 | Create daily cleanup job | 📘 Medium | 🔲 Not Started | Scheduled task (2 AM): call `DeleteOldReadNotifications(30)` |
| 2G.20 | Create basic auth middleware | 📘 Medium | 🔲 Not Started | Protect admin endpoints with username: `admin`, password: `demo123` |
| 2G.21 | Create rate limiter middleware | 📘 Medium | 🔲 Not Started | 10 requests/minute per IP for admin endpoints |
| 2G.22 | Create `AdminHandler` | 📘 Medium | 🔲 Not Started | Endpoint: `GET /api/admin/notifications/cleanup` (manual trigger) |
| 2G.23 | Update seed data | 📘 Medium | 🔲 Not Started | Add 6 challenges, 10 trophies matching frontend hardcoded data |
| 2G.24 | Update docker volume mapping | 📘 Medium | 🔲 Not Started | Ensure `./data:/app/data` volume in `docker-compose.yml` |
| 2G.25 | Enhance health endpoint | 📘 Medium | 🔲 Not Started | Add Redis connection, database, subscriber status to `/health` |

### Data Model Changes

```go
// Challenge model (GO OWNS THIS TABLE)
type Challenge struct {
    ID           uint   `gorm:"primaryKey"`
    Title        string `gorm:"not null"`
    Description  string
    Type         string // "combat", "tactical", "exploration"
    Difficulty   string // "easy", "medium", "hard", "extreme"
    TargetValue  int
    Reward       string
    IconName     string
    CreatedAt    time.Time
}

// Trophy model (GO OWNS THIS TABLE)
type Trophy struct {
    ID             uint   `gorm:"primaryKey"`
    Name           string `gorm:"not null"`
    Description    string
    Rarity         string // "COMMON", "RARE", "EPIC", "LEGENDARY"
    IconName       string
    UnlockCriteria string // Simple string for hardcoded logic
    CreatedAt      time.Time
}

// PlayerTrophy model (GO OWNS THIS TABLE) - WITH UNIQUE CONSTRAINT
type PlayerTrophy struct {
    ID         uint   `gorm:"primaryKey"`
    PlayerName string `gorm:"not null;uniqueIndex:idx_player_trophy"`
    TrophyID   uint   `gorm:"not null;uniqueIndex:idx_player_trophy"`
    Trophy     Trophy `gorm:"foreignKey:TrophyID"`
    UnlockedAt time.Time
}

// PlayerNotification model (GO OWNS THIS TABLE)
type PlayerNotification struct {
    ID         uint   `gorm:"primaryKey"`
    PlayerName string `gorm:"not null;index"`
    Type       string // "TROPHY_UNLOCKED", "CHALLENGE_COMPLETED"
    Title      string
    Message    string
    Read       bool      `gorm:"default:false;index"`
    CreatedAt  time.Time `gorm:"index"`
}
```

### Hardcoded Trophy Unlock Examples

```go
// TrophyService.checkTrophyUnlocks() - Simple if-else logic
func (s *TrophyService) checkTrophyUnlocks(event RedisEvent) {
    switch event.Type {
    case "PUZZLE_SOLVED":
        // Check: "Complete all Mission 1 puzzles" → Unlock "Puzzle Master"
        if event.Payload.AllMissionPuzzlesSolved && event.Payload.MissionNumber == 1 {
            s.unlockTrophy(event.Payload.PlayerName, TROPHY_ID_PUZZLE_MASTER)
        }
        
        // Check: "Solve 10 puzzles" → Unlock "Brain Teaser"
        if event.Payload.TotalPlayerPuzzles >= 10 {
            s.unlockTrophy(event.Payload.PlayerName, TROPHY_ID_BRAIN_TEASER)
        }
    
    case "SCORE_SUBMITTED":
        // Check: "Submit 10 scores" → Unlock "Competitor"
        playerScoreCount := s.countPlayerScores(event.Payload.PlayerName)
        if playerScoreCount >= 10 {
            s.unlockTrophy(event.Payload.PlayerName, TROPHY_ID_COMPETITOR)
        }
    }
}

// unlockTrophy() - Checks for existing trophy before insert
func (s *TrophyService) unlockTrophy(playerName string, trophyID uint) {
    // Check if already unlocked (skip if exists)
    if s.repo.HasPlayerUnlockedTrophy(playerName, trophyID) {
        return
    }
    
    // Insert PlayerTrophy record (unique constraint prevents duplicates)
    trophy := &PlayerTrophy{PlayerName: playerName, TrophyID: trophyID}
    s.repo.Create(trophy)
    
    // Create notification for offline users
    s.notificationRepo.Create(&PlayerNotification{
        PlayerName: playerName,
        Type:       "TROPHY_UNLOCKED",
        Title:      "Trophy Unlocked!",
        Message:    "You earned: " + trophy.Trophy.Name,
    })
    
    // Broadcast to online users via WebSocket
    s.hub.Broadcast(WebSocketMessage{
        Type:    "TROPHY_UNLOCKED",
        Payload: trophy,
    })
}
```

---

## Phase 3: Shared Infrastructure 🔲

**Goal:** Set up shared SQLite database and Redis event bus infrastructure.

**Timeline:** Week 3 (before Phase 2/2-Go backend work)  
**Status:** 🔲 Not Started

### Milestones

| ID | Task | Priority | Status | Agent Notes |
|----|------|----------|--------|-------------|
| 3.1 | Add Redis service to docker-compose | 🔥 HIGH | 🔲 Not Started | `redis:7-alpine` on port 6379 with health check |
| 3.2 | Create shared data directory | 🔥 HIGH | 🔲 Not Started | `mkdir -p ./data` for shared SQLite database |
| 3.3 | Update docker-compose volumes | 🔥 HIGH | 🔲 Not Started | Mount `./data:/app/data` for both Java and Go backends |
| 3.4 | Configure Redis connection in Java | 📘 Medium | 🔲 Not Started | `application.properties`: `spring.redis.host=redis`, `spring.redis.port=6379` |
| 3.5 | Configure Redis connection in Go | 📘 Medium | 🔲 Not Started | Redis client with host `redis:6379` |
| 3.6 | Test Redis connectivity | 📘 Medium | 🔲 Not Started | Verify both backends can connect to Redis |
| 3.7 | Test shared database access | 📘 Medium | 🔲 Not Started | Verify both backends can read/write to `./data/shared.db` |

---

## Phase 4: Frontend Dual-Backend Integration 🔲

**Goal:** Update frontend to support dual-backend architecture with runtime configuration.

**Timeline:** Weeks 4-5  
**Status:** 🔲 Not Started

### Architecture Decisions

- ✅ **Runtime config:** Fetch `/api/config` on app load (SHA-256 versioned, localStorage cached)
- ✅ **Dual API services:** Score/Mission/Puzzle → Java; Challenge/Trophy/Notification → Go
- ✅ **Bottom-right toast notifications** for real-time events (auto-dismiss 5s)
- ✅ Remove all hardcoded data from components (Challenges, Trophies, Storyline, Puzzles, Leaderboard)

### Milestones

| ID | Task | Priority | Status | Agent Notes |
|----|------|----------|--------|-------------|
| 4.1 | Create `.env.example` | 📘 Medium | 🔲 Not Started | Document: `VITE_CONFIG_ENDPOINT=http://localhost:8080/api/config` |
| 4.2 | Create `configService.ts` | 🔥 HIGH | 🔲 Not Started | Fetch config, compare SHA-256 version, use cache if match, fetch if mismatch |
| 4.3 | Create `ConfigContext` | 🔥 HIGH | 🔲 Not Started | React Context with Suspense for loading config before app render |
| 4.4 | Create `challengeService.ts` | 📘 Medium | 🔲 Not Started | API calls to Go backend: `getChallenges()`, `updateChallengeProgress()` |
| 4.5 | Create `trophyService.ts` | 📘 Medium | 🔲 Not Started | API calls to Go backend: `getTrophies()`, `getPlayerTrophies()` |
| 4.6 | Create `notificationService.ts` | 📘 Medium | 🔲 Not Started | API calls to Go backend: `getNotifications()`, `markAsRead()` |
| 4.7 | Create `missionService.ts` | 📘 Medium | 🔲 Not Started | API calls to Java backend: `getMissions()`, `getPlayerMissionProgress()` |
| 4.8 | Create `puzzleService.ts` | 📘 Medium | 🔲 Not Started | API calls to Java backend: `getPuzzles()`, `solvePuzzle()` |
| 4.9 | Update `scoreService.ts` | 📘 Medium | 🔲 Not Started | Use `config.javaApiUrl` from ConfigContext |
| 4.10 | Create `ToastNotification` component | 📘 Medium | 🔲 Not Started | Bottom-right positioned, auto-dismiss 5s, stack multiple notifications |
| 4.11 | Update `Challenges.tsx` | 📘 Medium | 🔲 Not Started | Remove hardcoded data, fetch from `challengeService`, add loading/error states |
| 4.12 | Update `Trophies.tsx` | 📘 Medium | 🔲 Not Started | Remove hardcoded data, fetch from `trophyService`, add loading/error states |
| 4.13 | Update `Storyline.tsx` | 📘 Medium | 🔲 Not Started | Remove hardcoded data, fetch from `missionService`, add loading/error states |
| 4.14 | Update `Puzzles.tsx` | 📘 Medium | 🔲 Not Started | Remove hardcoded data, fetch from `puzzleService`, add loading/error states |
| 4.15 | Update `Leaderboard.tsx` | 🔥 HIGH | 🔲 Not Started | Remove hardcoded fallback kills/wins data, display from API response |
| 4.16 | Enhance `WebSocketContext` | 📘 Medium | 🔲 Not Started | Handle `TROPHY_UNLOCKED`, `CHALLENGE_PROGRESS`, `PUZZLE_SOLVED` messages |
| 4.17 | Add toast notifications to WebSocket | 📘 Medium | 🔲 Not Started | Trigger `ToastNotification` on WebSocket events |
| 4.18 | Add offline notification banner | 📘 Medium | 🔲 Not Started | Fetch unread notifications on mount, display as toasts |
| 4.19 | Update frontend types | 📘 Medium | 🔲 Not Started | Add types for Config, Challenge, Trophy, Mission, Puzzle, Notification |

---

## Phase 5: WebSocket Token-Based Authentication 🔲

**Goal:** Secure WebSocket connections with JWT authentication.

**Timeline:** Future Work  
**Status:** 🔲 Future Work

### Notes

- This phase is deferred to future work
- WebSocket connections are currently open to all clients
- When implemented: validate JWT token on WebSocket upgrade request
- Include token in WebSocket connection query params or headers

---

## Phase 6: Advanced Monitoring & Logging 🔲

**Goal:** Implement comprehensive observability with structured logging and metrics.

**Timeline:** Weeks 6-7  
**Status:** 🔲 Not Started

### Milestones

| ID | Task | Status | Agent Notes |
|----|------|--------|-------------|
| 6.1 | Add structured logging (Java) | 🔲 Not Started | Use Logback with JSON encoder for Spring Boot |
| 6.2 | Add structured logging (Go) | 🔲 Not Started | Use `zerolog` or `zap` for JSON-formatted logs |
| 6.3 | Add request ID middleware (Java) | 🔲 Not Started | Generate UUID for each request, include in logs |
| 6.4 | Add request ID middleware (Go) | 🔲 Not Started | Generate UUID for each request, include in logs |
| 6.5 | Add Prometheus metrics (Java) | 🔲 Not Started | Expose metrics via Spring Boot Actuator |
| 6.6 | Add Prometheus metrics (Go) | 🔲 Not Started | HTTP request duration, WebSocket connections, message rates |
| 6.7 | Create Prometheus service | 🔲 Not Started | Add to `docker-compose.yml` for metric collection |
| 6.8 | Create Grafana service | 🔲 Not Started | Add to `docker-compose.yml` for visualization |
| 6.9 | Create Grafana dashboards | 🔲 Not Started | Visualize metrics, logs, request traces |
| 6.10 | Document monitoring setup | 🔲 Not Started | Runbook for monitoring and troubleshooting |

---

## Phase 7: Future Enhancements 🔲

**Goal:** Advanced features for future implementation.

**Timeline:** Future Work  
**Status:** 🔲 Future Work

### Planned Enhancements

| ID | Feature | Description | Complexity |
|----|---------|-------------|------------|
| 7.1 | Event queue auto-cleanup | Automatically delete processed events older than 7 days from `event_queue` table | Low |
| 7.2 | Data-driven trophy unlock criteria | Store trophy unlock rules in database with expression evaluator instead of hardcoded if-else logic | High |
| 7.3 | Config version invalidation UI | Add "Refresh Config" button in frontend settings to manually clear cache | Low |
| 7.4 | Notification retention policy UI | Admin interface to configure notification retention days (currently hardcoded 30 days) | Medium |
| 7.5 | Admin dashboard | Web UI for viewing event queue, failed events, notification cleanup stats | Medium |
| 7.6 | Multi-language support | i18n for frontend with language selector | Medium |
| 7.7 | Player achievements system | Combine trophies and challenges into unified achievement tracking | High |
| 7.8 | Social features | Friend lists, challenge other players, share achievements | Very High |

---

## Testing Strategy 🧪

### Integration Tests

| Test Suite | Purpose | Status |
|------------|---------|--------|
| `test-java-backend.sh` | Test Java endpoints, event queue, admin auth, rate limiting | 🔲 To Create |
| `test-go-backend.sh` | Test Go endpoints, Redis subscription, WebSocket, notifications | 🔲 To Create |
| `test-integration.sh` | End-to-end flows: score → Redis → WebSocket, puzzle → trophy → notification | 🔲 To Create |
| `test-dual-backend.sh` | Verify shared database access, config consistency between backends | 🔲 To Create |

### Test Scenarios

```bash
# test-integration.sh - Key scenarios to test

# 1. Score submission flow
POST /api/scores/submit (Java) 
  → Event saved to event_queue
  → Event published to Redis score:events
  → Go subscriber receives event
  → WebSocket broadcasts SCORE_UPDATE
  → Frontend updates leaderboard in real-time

# 2. Trophy unlock flow
POST /api/puzzles/1/solve (Java)
  → Event published to Redis puzzle:events
  → Go TrophyService receives event
  → Checks trophy unlock criteria
  → Verifies not already unlocked (unique constraint)
  → Inserts PlayerTrophy record
  → Creates PlayerNotification
  → Broadcasts TROPHY_UNLOCKED via WebSocket
  → Frontend shows toast notification

# 3. Config versioning
GET /api/config (Java)
  → Returns {version: "abc123...", javaApiUrl, goApiUrl, wsUrl}
GET /api/config (Go)
  → Returns same version hash
Frontend on load:
  → Checks localStorage for cached config
  → Compares SHA-256 version hash
  → Uses cache if match, fetches fresh if mismatch

# 4. Duplicate trophy prevention
Solve puzzle → Trophy unlocked → Notification created
Solve same puzzle again → Trophy check fails (already exists) → Skip
Verify: Only one PlayerTrophy record, one notification

# 5. Admin endpoint security
GET /api/admin/event-queue (no auth) → 401 Unauthorized
GET /api/admin/event-queue (wrong password) → 401 Unauthorized
GET /api/admin/event-queue (correct auth) → 200 OK with events
Multiple rapid requests → 429 Too Many Requests (rate limit)
```

---

## Environment Configuration

### Frontend Environment Variables

```env
# frontend/.env.example
VITE_CONFIG_ENDPOINT=http://localhost:8080/api/config
```

### Java Backend Configuration

```properties
# application.properties
# Database
spring.datasource.url=jdbc:sqlite:./data/shared.db
spring.jpa.hibernate.ddl-auto=update

# Redis
spring.redis.host=redis
spring.redis.port=6379

# Security (Basic Auth for Admin)
admin.username=admin
admin.password=demo123

# Rate Limiting
ratelimit.admin.capacity=10
ratelimit.admin.refillDuration=60s
```

### Go Backend Configuration

```go
// Environment variables or config file
DATABASE_PATH=./data/shared.db
REDIS_HOST=redis:6379
ADMIN_USERNAME=admin
ADMIN_PASSWORD=demo123
NOTIFICATION_CLEANUP_DAYS=30
```

### Docker Compose Services

| Service | Port | Status | Dependencies |
|---------|------|--------|--------------|
| Frontend (Vite) | 3000 | ✅ Running | - |
| Java Backend | 8080 | ✅ Running | Redis, shared volume |
| Go Backend | 8081 | ✅ Running | Redis, shared volume |
| Redis | 6379 | 🔲 To Add | - |

---

## API Endpoint Summary

### Java Backend (Port 8080)

| Endpoint | Method | Purpose | Auth Required |
|----------|--------|---------|---------------|
| `GET /api/scores/games` | GET | List all games | No |
| `GET /api/scores/game/{game}/top` | GET | Top scores for game | No |
| `POST /api/scores/submit` | POST | Submit new score | No (Future: Yes) |
| `GET /api/missions` | GET | List all missions | No |
| `GET /api/players/{player}/missions` | GET | Player mission progress | No |
| `GET /api/puzzles` | GET | List all puzzles | No |
| `POST /api/puzzles/{id}/solve` | POST | Solve puzzle | No (Future: Yes) |
| `GET /api/config` | GET | Runtime config (SHA-256 versioned) | No |
| `GET /api/admin/event-queue` | GET | View event queue (paginated) | Yes (admin/demo123) |
| `GET /actuator/health` | GET | Health check + Redis/queue stats | No |

### Go Backend (Port 8081)

| Endpoint | Method | Purpose | Auth Required |
|----------|--------|---------|---------------|
| `GET /api/challenges` | GET | List all challenges | No |
| `POST /api/challenges/{id}/progress` | POST | Update challenge progress | No (Future: Yes) |
| `GET /api/trophies` | GET | List all trophies | No |
| `GET /api/players/{player}/trophies` | GET | Player unlocked trophies | No |
| `GET /api/players/{player}/notifications` | GET | Player notifications | No (Future: Yes) |
| `PUT /api/notifications/{id}/read` | PUT | Mark notification as read | No (Future: Yes) |
| `GET /api/config` | GET | Runtime config (same as Java) | No |
| `GET /api/admin/notifications/cleanup` | GET | Trigger notification cleanup | Yes (admin/demo123) |
| `GET /health` | GET | Health check + Redis/DB/subscriber status | No |
| `WS /ws` | WebSocket | Real-time updates | No (Future: Yes) |

---

## Redis Channels

| Channel | Publisher | Subscriber | Event Types |
|---------|-----------|------------|-------------|
| `score:events` | Java Backend | Go Backend | `SCORE_SUBMITTED` |
| `puzzle:events` | Java Backend | Go Backend | `PUZZLE_SOLVED` |

---

## Database Schema Overview

### Java-Owned Tables

```sql
-- Scores (Java writes, Go reads)
game_scores (id, player_name, game_name, score, kills, wins, game_mode, achieved_at, created_at)

-- Missions
missions (id, number, title, description, location, duration, difficulty, prerequisite_mission_ids)
player_mission_progress (id, player_id, mission_id, status, completed_at)

-- Puzzles
puzzles (id, mission_id, title, description, type, difficulty, solution_hash, reward)
player_puzzle_progress (id, player_id, puzzle_id, solved, solved_at, attempts)

-- Event Queue
event_queue (id, event_type, payload, status, attempts, error_message, created_at, processed_at)
```

### Go-Owned Tables

```sql
-- Challenges
challenges (id, title, description, type, difficulty, target_value, reward, icon_name, created_at)
player_challenge_progress (id, player_name, challenge_id, current_progress, completed, completed_at)

-- Trophies
trophies (id, name, description, rarity, icon_name, unlock_criteria, created_at)
player_trophies (id, player_name, trophy_id, unlocked_at)
  -- UNIQUE INDEX: idx_player_trophy ON (player_name, trophy_id)

-- Notifications
player_notifications (id, player_name, type, title, message, read, created_at)
  -- INDEX: player_name, read, created_at
```

---

## Changelog

| Date | Phase | Changes |
|------|-------|---------|
| 2026-01-28 | All | 🔄 **MAJOR ARCHITECTURE UPDATE:** Dual-backend with shared database and Redis event bus |
| 2026-01-28 | Overview | 🆕 Added Backend Service Ownership table and architecture decisions |
| 2026-01-28 | Phase 1 | ✅ **MARKED AS DONE (100% COMPLETE)** - All core integration milestones finished |
| 2026-01-28 | Phase 2 | 🔄 Updated to "Java Backend Extensions" - Focus on scores, missions, puzzles, event queue |
| 2026-01-28 | Phase 2-Go | 🆕 Created "Go Backend Extensions" - Focus on challenges, trophies, notifications |
| 2026-01-28 | Phase 3 | 🔄 Repurposed as "Shared Infrastructure" - Redis and SQLite setup |
| 2026-01-28 | Phase 4 | 🔄 Updated to "Frontend Dual-Backend Integration" - Runtime config and API services |
| 2026-01-28 | Phase 5 | 🔄 Changed to "WebSocket Token-Based Authentication" - Marked as future work |
| 2026-01-28 | Phase 7 | 🆕 Added "Future Enhancements" - Event cleanup, data-driven trophies, etc. |
| 2026-01-28 | Testing | 🆕 Added comprehensive testing strategy and integration test scenarios |
| 2026-01-28 | Documentation | 🆕 Added API endpoint summary, Redis channels, database schema overview |

---

## Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Complete |
| 🔄 | In Progress |
| 🔲 | Not Started |
| 🔥 | High Priority |
| 📘 | Medium Priority |
| ⚠️ | Blocked |
| ❌ | Cancelled/Deprecated |

---

## Next Steps for Implementation

### Immediate Priorities (Week 3)

1. **Phase 3: Infrastructure Setup**
   - Add Redis service to docker-compose
   - Create shared data directory
   - Configure volume mappings

2. **Phase 2: Java Backend** (Priority: 🔥 HIGH tasks first)
   - Migrate to SQLite
   - Extend GameScore entity with kills/wins/gameMode
   - Set up Redis event publishing
   - Create event queue

3. **Phase 2-Go: Go Backend** (Priority: 🔥 HIGH tasks first)
   - Update to shared database
   - Create Redis subscriber
   - Add unique constraints to PlayerTrophy

4. **Phase 4: Frontend**
   - Create runtime config system
   - Update API services for dual-backend
   - Remove hardcoded data from components

### Development Workflow

```bash
# 1. Start infrastructure
docker-compose up redis -d

# 2. Initialize shared database
cd java-spring-boot-backend
./migrate-to-sqlite.sh

# 3. Start backends in development mode
./gradlew bootRun  # Java backend (port 8080)
cd ../go-backend && go run main.go  # Go backend (port 8081)

# 4. Start frontend
cd ../frontend && npm run dev  # Vite (port 5173)

# 5. Run integration tests
./test-integration.sh
```

---

**End of Roadmap**

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND (React/Vite)                     │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────┐    ┌──────────────────┐                   │
│  │  scoreService.ts │    │ websocketService │                   │
│  │  (REST API)      │    │ (react-use-ws)   │                   │
│  └────────┬─────────┘    └────────┬─────────┘                   │
└───────────┼───────────────────────┼──────────────────────────────┘
            │  HTTP :8081           │  WebSocket :8081/ws
            ▼                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GO BACKEND (Microservice)                     │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │   Gin Router │  │ WS Upgrader  │  │     Hub (Broadcast)  │   │
│  │  /api/scores │  │  /ws         │  │  clients map[*Client]│   │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘   │
│         │                 │                      │               │
│         ▼                 ▼                      ▼               │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   Service Layer                             │ │
│  │  ScoreService → NotificationService → Hub broadcast         │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              │                                   │
│                              ▼                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Repository Layer (GORM + SQLite)               │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Milestones

| ID | Task | Status | Agent Notes |
|----|------|--------|-------------|
| 4.1 | Create Go module and dependencies | 🔲 Not Started | `go.mod` with gin, gorilla/websocket, gorm, sqlite |
| 4.2 | Create `GameScore` model | 🔲 Not Started | `go-backend/models/game_score.go` with GORM tags |
| 4.3 | Create database initialization | 🔲 Not Started | `go-backend/models/db.go` with SQLite setup and seeding |
| 4.4 | Create WebSocket message types | 🔲 Not Started | `go-backend/models/websocket.go` with JSON message structs |
| 4.5 | Create `GameScoreRepository` | 🔲 Not Started | `go-backend/repository/game_score_repository.go` with CRUD + queries |
| 4.6 | Create `GameScoreService` | 🔲 Not Started | `go-backend/service/game_score_service.go` business logic |
| 4.7 | Create `NotificationService` | 🔲 Not Started | `go-backend/service/notification_service.go` for broadcasting |
| 4.8 | Create WebSocket Hub | 🔲 Not Started | `go-backend/websocket/hub.go` client management and broadcast |
| 4.9 | Create WebSocket Client | 🔲 Not Started | `go-backend/websocket/client.go` per-connection goroutines |
| 4.10 | Create REST handlers | 🔲 Not Started | `go-backend/handlers/score_handler.go` REST API endpoints |
| 4.11 | Create WebSocket handler | 🔲 Not Started | `go-backend/handlers/websocket_handler.go` upgrade and serve |
| 4.12 | Create main.go | 🔲 Not Started | Wire up components, Gin router, CORS, health checks |
| 4.13 | Create Go backend tests | 🔲 Not Started | TDD: repository, service, handler tests with testify |
| 4.14 | Create Go Dockerfile | 🔲 Not Started | Multi-stage build for production |
| 4.15 | Update docker-compose.yml | 🔲 Not Started | Add `go-backend` service on port 8081 |
| 4.16 | Add `react-use-websocket` dependency | 🔲 Not Started | Update `frontend/package.json` |
| 4.17 | Create WebSocket service | 🔲 Not Started | `frontend/src/app/api/websocketService.ts` hook wrapper |
| 4.18 | Create WebSocketContext | 🔲 Not Started | `frontend/src/app/context/WebSocketContext.tsx` shared state |
| 4.19 | Update frontend types | 🔲 Not Started | Add WebSocket message types to `types.ts` |
| 4.20 | Update Leaderboard component | 🔲 Not Started | Subscribe to WebSocket, real-time updates |
| 4.21 | Update App.tsx | 🔲 Not Started | Wrap with WebSocketProvider |

### WebSocket Message Protocol

```json
// Server → Client: Score Update
{
  "type": "SCORE_UPDATE",
  "payload": {
    "id": 1,
    "playerName": "GhostReaper",
    "gameName": "Operation Nightfall",
    "score": 145820,
    "achievedAt": "2026-01-28T10:30:00Z"
  },
  "timestamp": "2026-01-28T10:30:01Z"
}

// Server → Client: Leaderboard Refresh
{
  "type": "LEADERBOARD_UPDATE",
  "payload": {
    "gameName": "Operation Nightfall",
    "topScores": [...]
  },
  "timestamp": "2026-01-28T10:30:01Z"
}

// Client → Server: Subscribe to game
{
  "type": "SUBSCRIBE",
  "payload": {
    "gameName": "Operation Nightfall"
  }
}
```

### Files to Create/Modify

```
go-backend/
├── go.mod                              # NEW
├── go.sum                              # NEW (generated)
├── main.go                             # NEW
├── Dockerfile                          # NEW
├── models/
│   ├── game_score.go                   # NEW
│   ├── db.go                           # NEW
│   └── websocket.go                    # NEW
├── repository/
│   └── game_score_repository.go        # NEW
├── service/
│   ├── game_score_service.go           # NEW
│   └── notification_service.go         # NEW
├── handlers/
│   ├── score_handler.go                # NEW
│   └── websocket_handler.go            # NEW
├── websocket/
│   ├── hub.go                          # NEW
│   └── client.go                       # NEW
└── tests/
    ├── repository_test.go              # NEW
    ├── service_test.go                 # NEW
    └── handler_test.go                 # NEW

frontend/
├── package.json                        # MODIFY - add react-use-websocket
└── src/app/
    ├── api/
    │   ├── types.ts                    # MODIFY - add WS types
    │   └── websocketService.ts         # NEW
    ├── context/
    │   └── WebSocketContext.tsx        # NEW
    └── components/
        └── Leaderboard.tsx             # MODIFY - add WS subscription

docker-compose.yml                      # MODIFY - add go-backend service
```

---

## Phase 5: JWT Authentication 🔲

**Goal:** Secure the application with JWT authentication for both Go and Java backends.

**Timeline:** Weeks 9-10  
**Status:** 🔲 Not Started

### Milestones

| ID | Task | Status | Agent Notes |
|----|------|--------|-------------|
| 5.1 | Create `Player` model in Go | 🔲 Not Started | Fields: `id`, `username`, `email`, `passwordHash`, `createdAt`, `lastLogin`, `role` |
| 5.2 | Create `PlayerRepository` in Go | 🔲 Not Started | GORM repository with `FindByUsername`, `FindByEmail` |
| 5.3 | Create `JwtService` in Go | 🔲 Not Started | Token generation, validation, extraction using `golang-jwt/jwt` |
| 5.4 | Create `AuthHandler` in Go | 🔲 Not Started | Endpoints: `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/refresh` |
| 5.5 | Create JWT middleware in Go | 🔲 Not Started | Gin middleware for protected routes |
| 5.6 | Add WebSocket JWT validation | 🔲 Not Started | Validate JWT on WebSocket upgrade request |
| 5.7 | Create frontend auth types | 🔲 Not Started | `LoginRequest`, `RegisterRequest`, `AuthResponse`, `User` interfaces |
| 5.8 | Create auth service | 🔲 Not Started | `frontend/src/app/api/authService.ts` with login, register, refresh |
| 5.9 | Create AuthContext | 🔲 Not Started | Manage `user`, `token`, `isAuthenticated`, `login`, `logout` |
| 5.10 | Create Login/Register components | 🔲 Not Started | Modal or page components for authentication |
| 5.11 | Add auth state to Navigation | 🔲 Not Started | Show login button or user avatar based on auth state |
| 5.12 | Protect score submission | 🔲 Not Started | Require authentication for score submission |
| 5.13 | Add JWT to WebSocket connection | 🔲 Not Started | Pass token in query param or header on connect |

---

## Phase 6: Advanced Monitoring & Logging 🔲

**Goal:** Implement comprehensive observability with structured logging, metrics, and distributed tracing.

**Timeline:** Weeks 11-12  
**Status:** 🔲 Not Started

### Milestones

| ID | Task | Status | Agent Notes |
|----|------|--------|-------------|
| 6.1 | Add structured logging (Go) | 🔲 Not Started | Use `zerolog` or `zap` for JSON-formatted logs |
| 6.2 | Add request ID middleware | 🔲 Not Started | Generate unique ID for each request, propagate through context |
| 6.3 | Add Prometheus metrics | 🔲 Not Started | HTTP request duration, WebSocket connections, message rates |
| 6.4 | Create `/metrics` endpoint | 🔲 Not Started | Expose Prometheus metrics for scraping |
| 6.5 | Add health check endpoints | 🔲 Not Started | `/health/live`, `/health/ready` with dependency checks |
| 6.6 | Add distributed tracing | 🔲 Not Started | OpenTelemetry integration for request tracing |
| 6.7 | Create Grafana dashboards | 🔲 Not Started | Visualize metrics, logs, and traces |
| 6.8 | Add alerting rules | 🔲 Not Started | Prometheus alerting for error rates, latency |
| 6.9 | Update docker-compose | 🔲 Not Started | Add Prometheus, Grafana, Jaeger services |
| 6.10 | Document monitoring setup | 🔲 Not Started | Runbook for monitoring and troubleshooting |

### Metrics to Expose

```
# HTTP Metrics
http_requests_total{method, path, status}
http_request_duration_seconds{method, path}
http_request_size_bytes{method, path}
http_response_size_bytes{method, path}

# WebSocket Metrics
websocket_connections_active
websocket_connections_total
websocket_messages_sent_total{type}
websocket_messages_received_total{type}
websocket_connection_duration_seconds

# Business Metrics
scores_submitted_total{game}
leaderboard_updates_broadcast_total{game}
```

---

## Gap Analysis Summary

### Frontend Components → Backend Requirements

| Component | Current State | Required Backend | Priority |
|-----------|--------------|------------------|----------|
| `Leaderboard.tsx` | ✅ Connected | `GET /api/scores/game/{game}/top` | Complete |
| `GameSelector` | ✅ Connected | `GET /api/scores/games` | Complete |
| `Challenges.tsx` | ❌ Hardcoded | Challenge + PlayerChallengeProgress APIs | Phase 2 |
| `Trophies.tsx` | ❌ Hardcoded | Trophy + PlayerTrophy APIs | Phase 2 |
| `Storyline.tsx` | ❌ Hardcoded | Mission + PlayerMissionProgress APIs | Phase 3 |
| `Puzzles.tsx` | ❌ Hardcoded | Puzzle + PlayerPuzzleProgress APIs | Phase 3 |
| Score Submission | ❌ Not implemented | Auth + `POST /api/scores/submit` | Phase 4 |

### Backend Features Without Frontend

| Backend Feature | Frontend Status | Phase |
|-----------------|-----------------|-------|
| Player statistics (`/api/scores/players/{player}/stats`) | Not displayed | Phase 2 |
| Game statistics (`/api/scores/games/{game}/stats`) | Not displayed | Phase 3 |
| Pagination support | Not implemented | Phase 2 |
| Score by ID (`/api/scores/{id}`) | Not used | Optional |

---

## Environment Configuration

### Frontend Environment Variables

```env
# .env.local (create in frontend/)
VITE_API_URL=http://localhost:8080
```

### Docker Compose Services

| Service | Port | Status |
|---------|------|--------|
| Frontend (Vite) | 3000 | ✅ Running |
| Backend (Spring Boot) | 8080 | ✅ Running |
| PostgreSQL | 5432 | ✅ Running |

### CORS Configuration

```java
// WebConfig.java - Required origins
@Override
public void addCorsMappings(CorsRegistry registry) {
    registry.addMapping("/api/**")
        .allowedOrigins(
            "http://localhost:3000",    // Docker
            "http://localhost:5173",    // Vite dev
            "http://127.0.0.1:3000",
            "http://127.0.0.1:5173"
        )
        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
}
```

---

## Agent Instructions

### How to Use This Roadmap

1. **Check Status**: Review the milestone tables to find tasks marked 🔲 Not Started
2. **Dependencies**: Complete tasks in order within each phase; phases can overlap
3. **Update Status**: After completing a task, update its status to ✅ Complete
4. **Add Notes**: Include implementation details in the "Agent Notes" column

### Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Complete |
| 🔄 | In Progress |
| 🔲 | Not Started |
| ⚠️ | Blocked |
| ❌ | Cancelled |

### Task Naming Convention

- `X.Y` where X = Phase number, Y = Task sequence
- Backend tasks: entity → repository → controller
- Frontend tasks: types → service → context → component

---

## Changelog

| Date | Phase | Changes |
|------|-------|---------|
| 2026-01-28 | Phase 2-Go | 🆕 Created [PHASE2_GO_BACKEND_PLAN.md](./PHASE2_GO_BACKEND_PLAN.md) - Detailed plan for Go backend enhancements |
| 2026-01-28 | Phase 4 | 🆕 Added Phase 4: Real-time Updates (Go WebSocket Microservice) |
| 2026-01-28 | Phase 5 | 🆕 Added Phase 5: JWT Authentication |
| 2026-01-28 | Phase 6 | 🆕 Added Phase 6: Advanced Monitoring & Logging |
| 2026-01-28 | Phase 1 | ✅ Completed all Phase 1 milestones (1.1-1.9) |
| 2026-01-28 | - | Created initial roadmap document |
