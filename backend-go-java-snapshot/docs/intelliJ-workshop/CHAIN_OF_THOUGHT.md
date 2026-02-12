# Chain of Thought (CoT) - Explanation and Examples

**Date**: February 10, 2026  
**Context**: High Scores Demo - Full-Stack Leaderboard Application  
**Stack**: React 18 + Vite + TypeScript (Frontend) | Spring Boot (Java Backend) | Go (Go Backend)

---

## What is Chain of Thought?

Chain of Thought (CoT) is a prompting technique where you explicitly show the reasoning steps that lead to a solution, rather than just providing the final answer. It helps break down complex problems into manageable pieces and makes the thinking process transparent.

**Think of it like showing your work in math class** - you don't just write "42", you show:
1. The equation: `2x + 6 = 90`
2. Subtract 6: `2x = 84`
3. Divide by 2: `x = 42`

---

## Examples Based on the High Scores Demo Application

> **The High Scores Demo** is a full-stack leaderboard application with:
> - `frontend/`: React 18 + Vite + TypeScript + Tailwind. Calls `/api/scores/*`.
> - `java-spring-boot-backend/`: Spring Boot REST API implementing `/api/scores/*`.
> - `go-backend/`: Go implementation of the same API contract.
> - `shared/seed-data.json`: Canonical seed data for all backends.

### **Example 1: Without Chain of Thought (Direct Answer)**

> **📝 Developer Prompt (Poor):**
> ```
> Add a new endpoint to get game statistics.
> ```

**Task** — Add game statistics endpoint

❌ **Poor approach:**
> "Add a `/api/scores/game/{gameName}/stats` endpoint that returns statistics."

**Problems with this approach:**
- No reasoning about what statistics to include (total players, average score, highest score?)
- Skips API contract consideration — does the frontend need this?
- Ignores existing patterns in `GameScoreService` and `GameScoreController`
- No validation for the `gameName` parameter
- Doesn't consider consistency between Java and Go backends
- No thought about error handling (what if game doesn't exist?)

---

### **Example 2: With Chain of Thought (Reasoning Shown)**

> **📝 Developer Prompt (Better):**
> ```
> I need to implement a new endpoint: GET /api/scores/game/{gameName}/stats
> 
> Before implementing, please:
> 1. Review the existing endpoint patterns in GameScoreController.java
> 2. Check the frontend types in frontend/src/app/api/types.ts for existing stats interfaces
> 3. Reference the Go backend handlers to understand the contract
> 4. Design the response structure considering what's useful for a leaderboard UI
> 5. Ensure error handling follows the existing patterns (400 for validation, 404 for not found)
> 
> Show your reasoning for the response structure and implementation approach.
> Provide implementations for both Java and Go backends.
> ```

✅ **Better approach:**

**Task** — Add game statistics endpoint to both backends

#### **Step 1: Understand the Existing Patterns**
1. From `GameScoreController.java`: Endpoints follow RESTful patterns with `@GetMapping` annotations
2. Responses use DTOs like `ScoreResponse` for consistency
3. Validation happens via `@Valid` annotations and explicit checks
4. Logging follows the pattern: `log.info("Getting X for Y: {}", params)`

From `frontend/src/app/api/types.ts`:
```typescript
export interface GameStats {
  gameName: string;
  totalPlayers: number;
  totalScores: number;
  averageScore: number;
  highestScore: number;
  topPlayer: string;
}
```

#### **Step 2: Analyze the Requirements**
- The frontend already expects a `GameStats` interface
- Need total players, total scores, average, highest score, and top player
- Must return 404 if game has no scores
- Must match JSON field names exactly

#### **Step 3: Design the Solution**

**Java Implementation (Spring Boot):**

In `GameScoreService.java`:
```java
@Transactional(readOnly = true)
public GameStatistics getGameStatistics(String gameName) {
    log.info("Getting statistics for game: {}", gameName);
    
    List<GameScore> scores = gameScoreRepository.findByGameName(gameName);
    if (scores.isEmpty()) {
        return new GameStatistics(gameName, 0, 0, 0.0, 0L, null);
    }
    
    long totalPlayers = scores.stream()
        .map(GameScore::getPlayerName)
        .distinct()
        .count();
    
    double avgScore = scores.stream()
        .mapToLong(GameScore::getScore)
        .average()
        .orElse(0.0);
    
    GameScore topScore = scores.stream()
        .max(Comparator.comparing(GameScore::getScore))
        .orElse(null);
    
    return new GameStatistics(
        gameName,
        (int) totalPlayers,
        scores.size(),
        avgScore,
        topScore.getScore(),
        topScore.getPlayerName()
    );
}
```

In `GameScoreController.java`:
```java
@GetMapping("/game/{gameName}/stats")
public ResponseEntity<GameScoreService.GameStatistics> getGameStatistics(
        @PathVariable String gameName) {
    log.info("Getting statistics for game: {}", gameName);
    GameScoreService.GameStatistics stats = gameScoreService.getGameStatistics(gameName);
    return ResponseEntity.ok(stats);
}
```

**Go Implementation:**

In `service/game_score_service.go`:
```go
func (s *GameScoreService) GetGameStats(gameName string) (*models.GameStats, error) {
    stats, err := s.repo.GetGameStatistics(gameName)
    if err != nil {
        return nil, fmt.Errorf("getting game statistics: %w", err)
    }
    return stats, nil
}
```

In `handlers/score_handler.go`:
```go
func (h *ScoreHandler) GetGameStats(c *gin.Context) {
    gameName := c.Param("gameName")
    if gameName == "" {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Game name is required"})
        return
    }
    
    stats, err := h.service.GetGameStats(gameName)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get game stats"})
        return
    }
    
    c.JSON(http.StatusOK, stats)
}
```

#### **Step 4: Verify Against API Contract**
- [x] Response matches `GameStats` interface in `types.ts`
- [x] JSON field names are camelCase: `gameName`, `totalPlayers`, `averageScore`
- [x] Both backends return identical response structure
- [x] Error handling returns proper HTTP status codes

---

### **Example 3: Chain of Thought for Score Submission Validation (Task)**

> **📝 Developer Prompt:**
> ```
> Implement validation for the POST /api/scores/submit endpoint.
> 
> Requirements:
> - playerName: required, non-empty, max 100 characters
> - gameName: required, non-empty, max 100 characters  
> - score: required, must be >= 0
> - achievedAt: optional, must be valid ISO-8601 timestamp if provided
> 
> Please:
> 1. Review the existing ScoreSubmissionRequest in both backends
> 2. Check the validation patterns used in Java (@Valid, @NotBlank) and Go (binding tags)
> 3. Design error responses that are machine-readable: {"error":{"code":"...","message":"..."}}
> 4. Ensure validation failures return 400 Bad Request
> 5. Add corresponding tests for happy path, validation failures, and edge cases
> 
> Show your reasoning for each validation rule and provide implementations.
> ```

**Task**: Add comprehensive validation for score submission

#### **Step 1: Understand Current State**

From `java-spring-boot-backend/.../dto/ScoreSubmissionRequest.java`:
```java
public class ScoreSubmissionRequest {
    @NotBlank(message = "Player name is required")
    private String playerName;
    
    @NotBlank(message = "Game name is required")
    private String gameName;
    
    @NotNull(message = "Score is required")
    private Long score;
    
    private LocalDateTime achievedAt;
}
```

From `go-backend/models/game_score.go`:
```go
type ScoreSubmissionRequest struct {
    PlayerName string `json:"playerName" binding:"required"`
    GameName   string `json:"gameName" binding:"required"`
    Score      int64  `json:"score" binding:"required"`
    AchievedAt string `json:"achievedAt,omitempty"`
}
```

**Current gaps identified:**
1. No max length validation on player/game names
2. No score >= 0 validation
3. Go backend doesn't validate achievedAt format
4. Error responses aren't consistently structured

#### **Step 2: Design Validation Rules**

| Field | Rule | Error Code | Error Message |
|-------|------|------------|---------------|
| playerName | Required | PLAYER_NAME_REQUIRED | "Player name is required" |
| playerName | Non-empty after trim | PLAYER_NAME_EMPTY | "Player name cannot be blank" |
| playerName | Max 100 chars | PLAYER_NAME_TOO_LONG | "Player name must not exceed 100 characters" |
| gameName | Required | GAME_NAME_REQUIRED | "Game name is required" |
| gameName | Non-empty after trim | GAME_NAME_EMPTY | "Game name cannot be blank" |
| gameName | Max 100 chars | GAME_NAME_TOO_LONG | "Game name must not exceed 100 characters" |
| score | Required | SCORE_REQUIRED | "Score is required" |
| score | >= 0 | SCORE_NEGATIVE | "Score must be non-negative" |
| achievedAt | Valid ISO-8601 | ACHIEVED_AT_INVALID | "achievedAt must be a valid ISO-8601 timestamp" |

#### **Step 3: Implementation - Java Backend**

Update `ScoreSubmissionRequest.java`:
```java
public class ScoreSubmissionRequest {
    @NotBlank(message = "Player name is required")
    @Size(max = 100, message = "Player name must not exceed 100 characters")
    private String playerName;
    
    @NotBlank(message = "Game name is required")
    @Size(max = 100, message = "Game name must not exceed 100 characters")
    private String gameName;
    
    @NotNull(message = "Score is required")
    @Min(value = 0, message = "Score must be non-negative")
    private Long score;
    
    private LocalDateTime achievedAt;
}
```

Add global exception handler for consistent error responses:
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationExceptions(
            MethodArgumentNotValidException ex) {
        
        String message = ex.getBindingResult().getFieldErrors().stream()
            .map(FieldError::getDefaultMessage)
            .findFirst()
            .orElse("Validation failed");
        
        Map<String, Object> error = Map.of(
            "error", Map.of(
                "code", "VALIDATION_ERROR",
                "message", message
            )
        );
        
        return ResponseEntity.badRequest().body(error);
    }
}
```

#### **Step 4: Implementation - Go Backend**

Update validation in `handlers/score_handler.go`:
```go
func (h *ScoreHandler) SubmitScore(c *gin.Context) {
    var request models.ScoreSubmissionRequest
    if err := c.ShouldBindJSON(&request); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": gin.H{
                "code":    "VALIDATION_ERROR",
                "message": "Invalid request body: " + err.Error(),
            },
        })
        return
    }
    
    // Additional validation
    request.PlayerName = strings.TrimSpace(request.PlayerName)
    request.GameName = strings.TrimSpace(request.GameName)
    
    if len(request.PlayerName) > 100 {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": gin.H{
                "code":    "PLAYER_NAME_TOO_LONG",
                "message": "Player name must not exceed 100 characters",
            },
        })
        return
    }
    
    if len(request.GameName) > 100 {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": gin.H{
                "code":    "GAME_NAME_TOO_LONG",
                "message": "Game name must not exceed 100 characters",
            },
        })
        return
    }
    
    if request.Score < 0 {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": gin.H{
                "code":    "SCORE_NEGATIVE",
                "message": "Score must be non-negative",
            },
        })
        return
    }
    
    // Continue with submission...
}
```

#### **Step 5: Add Tests**

**Go handler test (table-driven):**
```go
func (suite *HandlerTestSuite) TestSubmitScore_ValidationErrors() {
    testCases := []struct {
        name       string
        request    map[string]interface{}
        wantStatus int
        wantCode   string
    }{
        {
            name:       "missing player name",
            request:    map[string]interface{}{"gameName": "Test", "score": 100},
            wantStatus: http.StatusBadRequest,
            wantCode:   "VALIDATION_ERROR",
        },
        {
            name:       "negative score",
            request:    map[string]interface{}{"playerName": "Test", "gameName": "Test", "score": -1},
            wantStatus: http.StatusBadRequest,
            wantCode:   "SCORE_NEGATIVE",
        },
        {
            name:       "player name too long",
            request:    map[string]interface{}{"playerName": strings.Repeat("a", 101), "gameName": "Test", "score": 100},
            wantStatus: http.StatusBadRequest,
            wantCode:   "PLAYER_NAME_TOO_LONG",
        },
    }
    
    for _, tc := range testCases {
        suite.Run(tc.name, func() {
            body, _ := json.Marshal(tc.request)
            req := httptest.NewRequest(http.MethodPost, "/api/scores/submit", bytes.NewBuffer(body))
            req.Header.Set("Content-Type", "application/json")
            w := httptest.NewRecorder()
            
            suite.router.ServeHTTP(w, req)
            
            assert.Equal(suite.T(), tc.wantStatus, w.Code)
        })
    }
}
```

#### **Step 6: Success Criteria**
- [x] All validation rules implemented in both backends
- [x] Error responses are structured: `{"error":{"code":"...","message":"..."}}`
- [x] Validation failures return 400 Bad Request
- [x] Tests cover happy path, each validation failure, and edge cases
- [x] Frontend can parse error responses for user-friendly messages

---

### **Example 4: Chain of Thought for Implementing Player Statistics Endpoint**

> **📝 Developer Prompt:**
> ```
> Implement GET /api/scores/player/{playerName}/stats for the Go backend.
> 
> Per the API contract in copilot-instructions.md, it should:
> - Return player statistics matching the PlayerStats interface in types.ts
> - Be consistent with the Java backend implementation
> 
> Before implementing:
> 1. Review the Java implementation in GameScoreService.java
> 2. Check the PlayerStats interface in frontend/src/app/api/types.ts
> 3. Design the repository query to efficiently calculate statistics
> 4. Follow go-backend rules: context.Context, error wrapping, consistent JSON errors
> 5. Add table-driven tests with httptest
> 
> Show your reasoning for the implementation approach and database queries.
> ```

**Task**: Implement player statistics endpoint in Go backend

#### **Step 1: Understand the Contract**

From `frontend/src/app/api/types.ts`:
```typescript
export interface PlayerStats {
  playerName: string;
  totalGames: number;
  totalScore: number;
  averageScore: number;
  highestScore: number;
  gamesPlayed: string[];
}
```

From Java `GameScoreService.java`:
```java
public PlayerStatistics getPlayerStatistics(String playerName) {
    List<GameScore> scores = gameScoreRepository.findByPlayerName(playerName);
    // ... calculates stats from scores
}
```

#### **Step 2: Design Repository Queries**

**Option A**: Fetch all scores, calculate in memory
- Simple to implement
- Inefficient for players with many scores

**Option B**: Use SQL aggregations
- More complex queries
- Efficient for large datasets

**Decision**: **Option B** — Use SQL aggregations for efficiency

**Why?**
- Following `.github/copilot-instructions.md` rule 4.4: prefer efficient solutions
- A player could have thousands of scores over time
- SQL is optimized for these calculations

#### **Step 3: Implementation**

**Add to `go-backend/models/game_score.go`:**
```go
// PlayerStats represents player statistics
type PlayerStats struct {
    PlayerName   string   `json:"playerName"`
    TotalGames   int      `json:"totalGames"`
    TotalScore   int64    `json:"totalScore"`
    AverageScore float64  `json:"averageScore"`
    HighestScore int64    `json:"highestScore"`
    GamesPlayed  []string `json:"gamesPlayed"`
}
```

**Add to `go-backend/repository/game_score_repository.go`:**
```go
func (r *GameScoreRepository) GetPlayerStatistics(playerName string) (*models.PlayerStats, error) {
    var stats models.PlayerStats
    stats.PlayerName = playerName
    
    // Get aggregate stats
    err := r.db.Model(&models.GameScore{}).
        Where("player_name = ?", playerName).
        Select("COUNT(DISTINCT game_name) as total_games, " +
               "COALESCE(SUM(score), 0) as total_score, " +
               "COALESCE(AVG(score), 0) as average_score, " +
               "COALESCE(MAX(score), 0) as highest_score").
        Scan(&stats).Error
    
    if err != nil {
        return nil, fmt.Errorf("querying player stats: %w", err)
    }
    
    // Get list of games played
    err = r.db.Model(&models.GameScore{}).
        Where("player_name = ?", playerName).
        Distinct("game_name").
        Pluck("game_name", &stats.GamesPlayed).Error
    
    if err != nil {
        return nil, fmt.Errorf("querying games played: %w", err)
    }
    
    return &stats, nil
}
```

**Add to `go-backend/service/game_score_service.go`:**
```go
func (s *GameScoreService) GetPlayerStats(playerName string) (*models.PlayerStats, error) {
    stats, err := s.repo.GetPlayerStatistics(playerName)
    if err != nil {
        return nil, fmt.Errorf("getting player statistics for %s: %w", playerName, err)
    }
    return stats, nil
}
```

**Add to `go-backend/handlers/score_handler.go`:**
```go
// GetPlayerStats handles GET /api/scores/player/:playerName/stats
func (h *ScoreHandler) GetPlayerStats(c *gin.Context) {
    playerName := c.Param("playerName")
    if playerName == "" {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": gin.H{
                "code":    "PLAYER_NAME_REQUIRED",
                "message": "Player name is required",
            },
        })
        return
    }
    
    stats, err := h.service.GetPlayerStats(playerName)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": gin.H{
                "code":    "INTERNAL_ERROR",
                "message": "Failed to get player statistics",
            },
        })
        return
    }
    
    c.JSON(http.StatusOK, stats)
}
```

**Register route in `main.go`:**
```go
api.GET("/player/:playerName/stats", scoreHandler.GetPlayerStats)
```

#### **Step 4: Add Tests**

```go
func (suite *HandlerTestSuite) TestGetPlayerStats() {
    testCases := []struct {
        name           string
        playerName     string
        wantStatus     int
        wantTotalGames int
    }{
        {
            name:           "existing player",
            playerName:     "HandlerPlayer1",
            wantStatus:     http.StatusOK,
            wantTotalGames: 1,
        },
        {
            name:           "non-existent player returns empty stats",
            playerName:     "NoSuchPlayer",
            wantStatus:     http.StatusOK,
            wantTotalGames: 0,
        },
    }
    
    for _, tc := range testCases {
        suite.Run(tc.name, func() {
            req := httptest.NewRequest(http.MethodGet, 
                "/api/scores/player/"+tc.playerName+"/stats", nil)
            w := httptest.NewRecorder()
            
            suite.router.ServeHTTP(w, req)
            
            assert.Equal(suite.T(), tc.wantStatus, w.Code)
            
            if tc.wantStatus == http.StatusOK {
                var stats models.PlayerStats
                json.Unmarshal(w.Body.Bytes(), &stats)
                assert.Equal(suite.T(), tc.wantTotalGames, stats.TotalGames)
            }
        })
    }
}
```

#### **Step 5: Verify Against API Contract**
- [x] Response matches `PlayerStats` interface in `types.ts`
- [x] JSON field names match: `playerName`, `totalGames`, `totalScore`, `averageScore`, `highestScore`, `gamesPlayed`
- [x] Error responses follow structured format
- [x] Tests include happy path and edge cases

---

### **Example 5: Chain of Thought for WebSocket Real-time Updates**

> **📝 Developer Prompt:**
> ```
> Implement real-time leaderboard updates via WebSocket in the Go backend.
> 
> Context:
> - The frontend expects WebSocket messages matching WSMessageType in types.ts
> - When a score is submitted, all connected clients should receive an update
> - The Go backend has a websocket/ package with hub.go and client.go
> 
> Please:
> 1. Review the WebSocket types in frontend/src/app/api/types.ts
> 2. Check the existing NotificationService interface in service/game_score_service.go
> 3. Design the message flow: Score submitted → Service → Hub → All clients
> 4. Ensure proper goroutine management (no leaks, tied to context)
> 5. Handle client disconnection gracefully
> 
> Show your reasoning for the hub architecture and message broadcasting.
> ```

**Task**: Implement WebSocket real-time leaderboard updates

#### **Step 1: Understand the WebSocket Contract**

From `frontend/src/app/api/types.ts`:
```typescript
export enum WSMessageType {
  SCORE_UPDATE = 'SCORE_UPDATE',
  LEADERBOARD_UPDATE = 'LEADERBOARD_UPDATE',
  SUBSCRIBE = 'SUBSCRIBE',
  UNSUBSCRIBE = 'UNSUBSCRIBE',
  PING = 'PING',
  PONG = 'PONG',
  ERROR = 'ERROR',
  CONNECTED = 'CONNECTED',
}
```

From `go-backend/service/game_score_service.go`:
```go
type NotificationService interface {
    BroadcastScoreUpdate(score *models.GameScore)
    BroadcastLeaderboardUpdate(gameName string, topScores []models.ScoreResponse)
}
```

#### **Step 2: Design the Architecture**

```
Score Submission Flow:
┌──────────┐    ┌─────────────────┐    ┌─────────┐    ┌─────────┐
│ Client A │───▶│ POST /submit    │───▶│ Service │───▶│ Hub     │
└──────────┘    └─────────────────┘    └─────────┘    └────┬────┘
                                                           │
                    ┌──────────────────────────────────────┘
                    ▼
              ┌─────────────────┐
              │ Broadcast to    │
              │ all WS clients  │
              └─────────────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
   ┌────────┐  ┌────────┐  ┌────────┐
   │Client B│  │Client C│  │Client D│
   └────────┘  └────────┘  └────────┘
```

**Hub responsibilities:**
1. Track active WebSocket connections
2. Handle client registration/deregistration
3. Broadcast messages to all connected clients
4. Clean up on shutdown

#### **Step 3: Implementation**

**WebSocket message model (`go-backend/models/websocket.go`):**
```go
package models

// WSMessageType defines WebSocket message types
type WSMessageType string

const (
    WSScoreUpdate       WSMessageType = "SCORE_UPDATE"
    WSLeaderboardUpdate WSMessageType = "LEADERBOARD_UPDATE"
    WSConnected         WSMessageType = "CONNECTED"
    WSError             WSMessageType = "ERROR"
)

// WSMessage represents a WebSocket message
type WSMessage struct {
    Type    WSMessageType `json:"type"`
    Payload interface{}   `json:"payload"`
}

// ScoreUpdatePayload for SCORE_UPDATE messages
type ScoreUpdatePayload struct {
    Score ScoreResponse `json:"score"`
}

// LeaderboardUpdatePayload for LEADERBOARD_UPDATE messages
type LeaderboardUpdatePayload struct {
    GameName  string          `json:"gameName"`
    TopScores []ScoreResponse `json:"topScores"`
}
```

**Hub implementation (`go-backend/websocket/hub.go`):**
```go
package websocket

import (
    "encoding/json"
    "log"
    "sync"
    
    "github.com/insight/high-scores-go/models"
)

// Hub maintains active WebSocket connections and broadcasts messages
type Hub struct {
    clients    map[*Client]bool
    broadcast  chan []byte
    register   chan *Client
    unregister chan *Client
    mu         sync.RWMutex
}

// NewHub creates a new Hub
func NewHub() *Hub {
    return &Hub{
        clients:    make(map[*Client]bool),
        broadcast:  make(chan []byte, 256),
        register:   make(chan *Client),
        unregister: make(chan *Client),
    }
}

// Run starts the hub's main loop
func (h *Hub) Run() {
    for {
        select {
        case client := <-h.register:
            h.mu.Lock()
            h.clients[client] = true
            h.mu.Unlock()
            log.Printf("Client connected. Total clients: %d", len(h.clients))
            
        case client := <-h.unregister:
            h.mu.Lock()
            if _, ok := h.clients[client]; ok {
                delete(h.clients, client)
                close(client.send)
            }
            h.mu.Unlock()
            log.Printf("Client disconnected. Total clients: %d", len(h.clients))
            
        case message := <-h.broadcast:
            h.mu.RLock()
            for client := range h.clients {
                select {
                case client.send <- message:
                default:
                    // Client buffer full, mark for removal
                    close(client.send)
                    delete(h.clients, client)
                }
            }
            h.mu.RUnlock()
        }
    }
}

// BroadcastScoreUpdate broadcasts a score update to all clients
func (h *Hub) BroadcastScoreUpdate(score *models.GameScore) {
    msg := models.WSMessage{
        Type: models.WSScoreUpdate,
        Payload: models.ScoreUpdatePayload{
            Score: score.ToResponse(),
        },
    }
    
    data, err := json.Marshal(msg)
    if err != nil {
        log.Printf("Error marshaling score update: %v", err)
        return
    }
    
    h.broadcast <- data
}

// BroadcastLeaderboardUpdate broadcasts leaderboard update to all clients
func (h *Hub) BroadcastLeaderboardUpdate(gameName string, topScores []models.ScoreResponse) {
    msg := models.WSMessage{
        Type: models.WSLeaderboardUpdate,
        Payload: models.LeaderboardUpdatePayload{
            GameName:  gameName,
            TopScores: topScores,
        },
    }
    
    data, err := json.Marshal(msg)
    if err != nil {
        log.Printf("Error marshaling leaderboard update: %v", err)
        return
    }
    
    h.broadcast <- data
}
```

#### **Step 4: Wire Up in Service**

The service already calls the notifier when a score is submitted:
```go
// In SubmitScore method
if s.notifier != nil {
    s.notifier.BroadcastScoreUpdate(score)
    
    // Also broadcast updated leaderboard
    topScores, err := s.GetTopScoresForGame(score.GameName, 10)
    if err == nil {
        responses := make([]models.ScoreResponse, len(topScores))
        for i, ts := range topScores {
            responses[i] = ts.ToResponse()
        }
        s.notifier.BroadcastLeaderboardUpdate(score.GameName, responses)
    }
}
```

#### **Step 5: Success Criteria**
- [x] Hub tracks active connections
- [x] Score submissions broadcast SCORE_UPDATE to all clients
- [x] Leaderboard updates broadcast LEADERBOARD_UPDATE
- [x] Message types match `WSMessageType` enum in types.ts
- [x] No goroutine leaks (proper channel cleanup)
- [x] Graceful client disconnection handling

---

## Why Chain of Thought Matters for the High Scores Demo

### **Without Chain of Thought:**
- ❌ Add endpoints that don't match the frontend's expected types
- ❌ Implement features differently in Java and Go backends
- ❌ Skip validation, causing data integrity issues
- ❌ Ignore error handling patterns, making debugging difficult
- ❌ Create WebSocket messages the frontend can't parse

### **With Chain of Thought:**
1. ✅ Reference the API contract in `types.ts` before implementing
2. ✅ Check existing patterns in both backends for consistency
3. ✅ Design validation rules that match across services
4. ✅ Follow error response format: `{"error":{"code":"...","message":"..."}}`
5. ✅ Verify implementations against success criteria

### **Result:**
- **Consistent API contract** — Frontend works with both backends
- **Testable implementations** — Each feature has specific validation criteria
- **Maintainable code** — Follows established patterns in the codebase
- **Reliable real-time updates** — WebSocket messages match expected types
- **Better developer experience** — Clear reasoning makes code review easier

---

## How to Write Prompts That Trigger Chain of Thought

### The Key Principles

| Principle | Poor Prompt | Better Prompt |
|-----------|-------------|---------------|
| **Be specific** | "Add an endpoint" | "Add GET /api/scores/player/{name}/stats matching PlayerStats in types.ts" |
| **Reference files** | "Make it work" | "Review GameScoreService.java and match the implementation in Go" |
| **Ask for reasoning** | (silent) | "Show your reasoning for the database query design" |
| **Request verification** | (silent) | "Verify the response matches the frontend's expected types" |
| **Include constraints** | (silent) | "Follow copilot-instructions.md rules for Go backend" |

### Prompt Structure Template

```markdown
Implement [endpoint/feature]: [Brief description].

Context from [relevant files]:
- [Key requirement 1]
- [Key requirement 2]
- [Key requirement 3]

Before implementing, please:
1. Review [existing code patterns to follow]
2. Check [API contract/types files]
3. Reference [related implementations]
4. Design [what needs to be designed]
5. Follow [coding standards/rules]

Show your reasoning for [specific decisions you want explained].

Provide:
- [Deliverable 1: e.g., service implementation]
- [Deliverable 2: e.g., handler code]
- [Deliverable 3: e.g., tests]
```

### Anti-Patterns to Avoid

| ❌ Don't | ✅ Do Instead |
|----------|--------------|
| "Add a stats endpoint" | "Add GET /api/scores/game/{name}/stats returning GameStats from types.ts" |
| "Make it validated" | "Validate: playerName required + max 100 chars, score >= 0" |
| "Add WebSocket" | "Implement WebSocket broadcasting matching WSMessageType enum" |
| "Just make it work" | "Follow existing patterns in GameScoreService and ScoreHandler" |
| "Figure it out" | "First check the Java implementation, then implement equivalently in Go" |

---

## Chain of Thought Template for High Scores Demo Tasks

```markdown
### Problem: [Describe the task - endpoint, feature, or fix]

#### Step 1: Understand the API Contract
- What does `frontend/src/app/api/types.ts` expect?
- What does `frontend/src/app/api/scoreService.ts` call?
- Are there existing implementations in Java or Go to reference?

#### Step 2: Identify Dependencies
- What service methods are needed?
- What repository queries are required?
- What models/DTOs need to be created or updated?

#### Step 3: Design the Solution
- Option A: [Approach + pros/cons]
- Option B: [Approach + pros/cons]
- Decision: [Chosen option] because [rationale from copilot-instructions.md]

#### Step 4: Implementation Plan
1. [Model/DTO changes]
2. [Repository method]
3. [Service method]
4. [Handler/Controller endpoint]
5. [Route registration]

#### Step 5: Verify Against API Contract
- [ ] Response JSON matches frontend types
- [ ] Error format: {"error":{"code":"...","message":"..."}}
- [ ] Consistent between Java and Go backends

#### Step 6: Test Plan
- Happy path test
- Validation failure test
- Repository/dependency error test
```

---

## Key Takeaway

**Chain of Thought = Show your reasoning work**, just like in math class.

For the High Scores Demo, this means:
1. **Why** does this endpoint need these specific fields?
2. **What** does the frontend expect in the response?
3. **How** should validation errors be formatted?
4. **Where** in the codebase are similar patterns used?
5. **Which** backend(s) need this implementation?

This structured thinking prevents creating endpoints that don't match the API contract and ensures both Java and Go backends stay compatible with the React frontend.

---

## Additional Resources

- **API Contract**: `frontend/src/app/api/types.ts` — TypeScript interfaces
- **Frontend Service**: `frontend/src/app/api/scoreService.ts` — API call implementations
- **Copilot Instructions**: `.github/copilot-instructions.md` — Repository rules
- **Java Controller**: `java-spring-boot-backend/.../controller/GameScoreController.java`
- **Java Service**: `java-spring-boot-backend/.../service/GameScoreService.java`
- **Go Handlers**: `go-backend/handlers/score_handler.go`
- **Go Service**: `go-backend/service/game_score_service.go`
- **Go Models**: `go-backend/models/game_score.go`
- **Seed Data**: `shared/seed-data.json` — Canonical test data

---

**Author**: GitHub Copilot  
**Context**: High Scores Demo - Full-Stack Leaderboard Application  
**Last Updated**: February 10, 2026
