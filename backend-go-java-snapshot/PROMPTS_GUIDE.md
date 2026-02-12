# Agentic Development Workflow Guide

> **Search(Ask) → Plan (Agent) → Human Feedback → RoadMap → Generate Agents/Prompts → Dev Agentic Workflow**

---

## Workflow Overview

```mermaid
flowchart LR
    subgraph Input
        A[👤 User Request]
    end
    
    subgraph Planning
        B[@planning_arch_agent<br/>Analyze & Plan]
        C[Generate Task<br/>Breakdown]
    end
    
    subgraph Implementation
        D[@backend_agent<br/>Java/Go]
        E[@frontend_agent<br/>React/TypeScript]
    end
    
    subgraph Validation
        F[@testing_agent<br/>Write Tests]
        G[@code_reviewer<br/>Review Code]
    end
    
    subgraph Feedback
        H[User Review]
        I[Commit Changes]
    end
    
    A --> B --> C --> D & E
    D & E --> F --> G --> H
    H -->|iterate| B
    H -->|approve| I
```

---

## Expected Results

| Deliverable | Description |
|-------------|-------------|
| **Custom Agents** | Specialized `.agent.md` files for backend/frontend development |
| **Executable Prompts** | CORE Framework prompts ready to copy-paste |
| **End-to-End Workflows** | Complete feature implementation flows |

---

## Prerequisites

Before using these prompts, ensure you understand:

1. **Repository Architecture** (detailed in [.github/copilot-instructions.md](.github/copilot-instructions.md)):
   - `frontend/`: React 18 + Vite + TypeScript + Tailwind
   - `java-spring-boot-backend/`: Spring Boot REST API
   - `go-backend/`: Go + Gin REST API (alternative implementation)
   - Both backends implement the same API contract for `/api/scores/*`

2. **API Contract** (defined in [frontend/src/app/api/types.ts](frontend/src/app/api/types.ts)):
   - All backends must match `ScoreResponse`, `ScoreSubmissionRequest`, `PageResponse<T>`, etc.
   - Breaking changes require frontend coordination

3. **Development Workflow**:
   - Create custom agents first (`.agent.md` files in `.github/agents/`)
   - Use agents via `@agent_name` syntax in Copilot Chat
   - Follow CORE Framework for all prompts

### Development Workflow Patterns

```mermaid
flowchart LR
    subgraph HappyPath["Happy Path: New Feature"]
        U1[User] --> PA[@planning_arch_agent]
        PA --> AC[@api_contract_agent]
        AC --> BE1[@java_backend_agent]
        AC --> BE2[@go_backend_agent]
        BE1 & BE2 --> FE[@frontend_agent]
        FE --> TA[@testing_agent]
        TA --> CR[@code_reviewer]
        CR --> UF[User Feedback]
        UF -->|iterate| PA
        UF -->|approve| UC[Commit]
    end
    
    subgraph BugPath["Bug Path: Issue Resolution"]
        U2[User] --> BA[@bug_assist]
        BA --> BE3[@backend_agent]
        BE3 --> TA2[@testing_agent]
        TA2 --> CR2[@code_reviewer]
    end
```

**Reference Patterns:**
- **Go Backend**: [go-backend/handlers/score_handler.go](go-backend/handlers/score_handler.go), [go-backend/tests/handler_test.go](go-backend/tests/handler_test.go)
- **Java Backend**: `java-spring-boot-backend/src/main/java/com/insight/`
- **Frontend API**: [frontend/src/app/api/scoreService.ts](frontend/src/app/api/scoreService.ts), [frontend/src/app/api/types.ts](frontend/src/app/api/types.ts)

---

## CORE Framework Reference

The CORE Framework for prompts consists of:

| Component | Description |
|-----------|-------------|
| **C**ontext | Background information and role definition |
| **O**bjective | Specific goal or task to accomplish |
| **R**equirements | Constraints and specifications |
| **E**xample | Sample input/output or workflow demonstration |

---

## Agent Inventory

Create these custom agents in `.github/agents/` before using the prompts below.

| Agent Name | Agent File | Purpose | Technology Focus |
|------------|------------|---------|------------------|
| `@planning_arch_agent` | `planning_arch_agent.agent.md` | Sprint planning, task breakdown, architecture decisions | Planning, System Design |
| `@api_contract_agent` | `api_contract_agent.agent.md` | Validate API contracts, ensure frontend/backend compatibility | API Design, TypeScript Types |
| `@java_backend_agent` | `java_backend_agent.agent.md` | Implement Spring Boot features, entities, repositories | Java, Spring Boot, JPA |
| `@go_backend_agent` | `go_backend_agent.agent.md` | Implement Go backend features, handlers, services | Go, Gin, Clean Architecture |
| `@frontend_agent` | `frontend_agent.agent.md` | Implement React components, API integration, state management | React, TypeScript, Tailwind |
| `@testing_agent` | `testing_agent.agent.md` | Write unit tests, integration tests, validation | Go testing, JUnit, React Testing Library |
| `@seed_data_agent` | `seed_data_agent.agent.md` | Manage canonical seed data in `shared/seed-data.json` | JSON Schema, Data Validation |
| `@docker_agent` | `docker_agent.agent.md` | Update docker-compose, Dockerfiles, local development setup | Docker, Docker Compose |
| `@code_reviewer` | `code_reviewer.agent.md` | Review code for quality, security, conventions | All Technologies |
| `@bug_assist` | `bug_assist.agent.md` | Diagnose bugs, trace issues across stack | Full Stack Debugging |

**Note**: See [Custom Agent Creation Guide](#custom-agent-creation-guide) below for templates.

---

---

## End-to-End Development Scenarios

Below are three complete workflows demonstrating how to use custom agents for common development tasks. All prompts follow the **CORE Framework**.

---

## Scenario A: Add New API Endpoint (Backend → Frontend)

**Use Case**: Add a new `GET /api/scores/game/{name}/stats` endpoint that returns detailed game statistics.

### A1: Planning Phase

**Agent**: `@planning_arch_agent`

```
Context: You are a planning agent for the high-scores-demo leaderboard app. 
The repo has Java Spring Boot and Go backends (both implement /api/scores/*), 
and a React TypeScript frontend. Review .github/copilot-instructions.md for 
architecture constraints.

Objective: Create an implementation plan for adding a new endpoint:
GET /api/scores/game/{name}/stats returning GameStats.

Requirements:
1. Define the GameStats TypeScript interface (matches backend DTOs)
2. Break down into tasks for: API contract, Java backend, Go backend, frontend
3. Identify files to modify in each layer
4. Estimate: 4-6 hours total across all agents
5. Ensure API contract compatibility (see frontend/src/app/api/types.ts)

Example Output:
Task 1: @api_contract_agent - Define GameStats type
Task 2: @java_backend_agent - Implement controller + service
Task 3: @go_backend_agent - Implement handler + service
Task 4: @frontend_agent - Add scoreService method + UI integration
Task 5: @testing_agent - Write tests for all layers
```

### A2: Define API Contract

**Agent**: `@api_contract_agent`

```
Context: You ensure API contracts between frontend and backend remain 
compatible. The frontend uses TypeScript types defined in 
frontend/src/app/api/types.ts.

Objective: Define the GameStats interface for the new /api/scores/game/{name}/stats endpoint.

Requirements:
1. Add GameStats interface to frontend/src/app/api/types.ts
2. Include fields: gameName, totalPlayers, totalScores, averageScore, highestScore, topPlayer
3. Ensure field naming matches existing conventions (camelCase)
4. Document with JSDoc comments
5. Validate against existing ScoreResponse and PlayerStats patterns

Example:
export interface GameStats {
  gameName: string;
  totalPlayers: number;
  totalScores: number;
  averageScore: number;
  highestScore: number;
  topPlayer: string;
}
```

### A3: Implement Java Backend

**Agent**: `@java_backend_agent`

```
Context: You are a Java Spring Boot specialist. The backend is in 
java-spring-boot-backend/src/main/java/com/insight/. Follow Spring Boot 
best practices and repository layer patterns already established.

Objective: Implement GET /api/scores/game/{gameName}/stats endpoint.

Requirements:
1. Create GameStatsDTO class matching the TypeScript GameStats interface
2. Add getGameStats(String gameName) method to GameScoreService
3. Add @GetMapping to ScoreController: /api/scores/game/{gameName}/stats
4. Use repository layer to aggregate data (totalPlayers, avgScore, etc.)
5. Handle case when game doesn't exist (return empty stats or 404)
6. Follow error handling patterns from existing endpoints
7. Reference: Look at existing controller methods for patterns

Example Service Signature:
public GameStatsDTO getGameStats(String gameName) {
  // Aggregate logic using repository
}
```

### A4: Implement Go Backend

**Agent**: `@go_backend_agent`

```
Context: You are a Go backend specialist working on go-backend/. The code 
follows clean architecture: handlers/ → service/ → repository/. Follow Go 
backend rules from .github/copilot-instructions.md section 4.

Objective: Implement GET /api/scores/game/:gameName/stats handler in Go.

Requirements:
1. Add GameStats struct to models/game_score.go
2. Add GetGameStats(gameName string) method to GameScoreService
3. Implement repository method to aggregate scores (use SQL aggregation)
4. Add handler method GetGameStats to handlers/score_handler.go
5. Register route in main.go: api.GET("/game/:gameName/stats", ...)
6. Use context.Context end-to-end (rule 4.2)
7. Return consistent JSON errors on failure (rule 4.2)
8. Reference: go-backend/handlers/score_handler.go GetTopScoresForGame for pattern

Example Response:
{
  "gameName": "Operation Nightfall",
  "totalPlayers": 42,
  "totalScores": 156,
  "averageScore": 8450.5,
  "highestScore": 15000,
  "topPlayer": "Ghost"
}
```

### A5: Frontend Integration

**Agent**: `@frontend_agent`

```
Context: You are a React TypeScript specialist. The frontend calls backend 
APIs via frontend/src/app/api/scoreService.ts using a wrapper pattern. 
Types are defined in types.ts.

Objective: Add frontend method to fetch game statistics.

Requirements:
1. Verify GameStats interface exists in types.ts (added by @api_contract_agent)
2. Add getGameStats(gameName: string) function to scoreService.ts
3. Use the existing apiFetch<T> wrapper for error handling
4. Return ApiResponse<GameStats> type
5. URL encode gameName parameter
6. Follow existing patterns (see getTopScores for reference)

Example Implementation:
export async function getGameStats(
  gameName: string
): Promise<ApiResponse<GameStats>> {
  const encodedGame = encodeURIComponent(gameName);
  return apiFetch<GameStats>(
    `/api/scores/game/${encodedGame}/stats`
  );
}
```

### A6: Write Tests

**Agent**: `@testing_agent`

```
Context: You write tests for all layers. Go tests use table-driven patterns 
(see go-backend/tests/handler_test.go). Java tests use JUnit + Spring Boot Test.

Objective: Write comprehensive tests for the new /stats endpoint.

Requirements:
Go Tests (go-backend/tests/handler_test.go):
1. Add TestGetGameStats_Success (happy path)
2. Add TestGetGameStats_GameNotFound (404 case)
3. Add TestGetGameStats_InvalidGameName (400 case)
4. Use httptest.NewRecorder pattern
5. Verify JSON response matches GameStats struct

Java Tests:
1. Add GameStatsControllerTest with @WebMvcTest
2. Test happy path with mock data
3. Test game not found scenario
4. Verify aggregation logic in service tests

Example Go Test:
func (suite *HandlerTestSuite) TestGetGameStats_Success() {
  req := httptest.NewRequest(http.MethodGet, "/api/scores/game/TestGame/stats", nil)
  w := httptest.NewRecorder()
  suite.router.ServeHTTP(w, req)
  
  assert.Equal(suite.T(), http.StatusOK, w.Code)
  var stats models.GameStats
  json.Unmarshal(w.Body.Bytes(), &stats)
  assert.Equal(suite.T(), "TestGame", stats.GameName)
}
```

---

## Scenario B: Add Real-Time WebSocket Feature

**Use Case**: Broadcast score updates to all connected clients when a new score is submitted.

### B1: Planning Phase

**Agent**: `@planning_arch_agent`

```
Context: The go-backend already has WebSocket infrastructure (go-backend/websocket/ 
with hub.go and client.go). Frontend types.ts defines WSMessageType enum. 
Review existing WebSocket code before planning.

Objective: Create implementation plan for broadcasting SCORE_UPDATE messages 
when POST /api/scores/submit is called.

Requirements:
1. Leverage existing websocket/hub.go broadcast mechanism
2. Integrate with service layer (notify hub on score submission)
3. Add frontend WebSocket client connection management
4. Support subscribe/unsubscribe to specific games
5. Tasks for: Go backend integration, frontend WebSocket service, testing

Example Output:
Task 1: @go_backend_agent - Integrate NotificationService with SubmitScore
Task 2: @frontend_agent - Create WebSocket connection manager
Task 3: @frontend_agent - Subscribe to game-specific updates
Task 4: @testing_agent - Test WebSocket message flow
Task 5: @docker_agent - Ensure WebSocket ports exposed in docker-compose
```

### B2: Backend WebSocket Integration

**Agent**: `@go_backend_agent`

```
Context: You are working on go-backend/ which has websocket/hub.go and 
websocket/client.go. The NotificationService is in service/notification_service.go. 
Follow Go backend rules section 4.3 (no goroutine leaks).

Objective: Integrate score submission with WebSocket broadcasting.

Requirements:
1. Review service/game_score_service.go SubmitScore method
2. Call notificationService.NotifyScoreUpdate(score) after successful save
3. Ensure NotificationService.NotifyScoreUpdate creates proper WSMessage
4. Use WSMessageType.SCORE_UPDATE from message types
5. Broadcast to hub (hub.Broadcast channel)
6. Include score data in message payload
7. Add error logging if broadcast fails (don't fail the API request)
8. Reference: service/notification_service.go for existing patterns

Example Integration (in game_score_service.go):
func (s *GameScoreService) SubmitScore(req *models.ScoreSubmissionRequest) (*models.GameScore, error) {
  score, err := s.repository.Create(req)
  if err != nil {
    return nil, fmt.Errorf("failed to create score: %w", err)
  }
  
  // Notify WebSocket clients
  if s.notifier != nil {
    s.notifier.NotifyScoreUpdate(score)
  }
  
  return score, nil
}
```

### B3: Frontend WebSocket Client

**Agent**: `@frontend_agent`

```
Context: You are building a React TypeScript WebSocket client. Types are 
defined in frontend/src/app/api/types.ts (WSMessageType enum, WSMessage interface). 
Follow React best practices for WebSocket lifecycle management.

Objective: Create a WebSocket connection manager for real-time score updates.

Requirements:
1. Create frontend/src/app/api/websocketService.ts
2. Implement connect(), disconnect(), subscribe(gameName), unsubscribe()
3. Use WebSocket connection to ws://localhost:8080/ws (or env var)
4. Handle WSMessageType.SCORE_UPDATE, CONNECTED, PING/PONG, ERROR
5. Emit events using EventEmitter or React Context
6. Reconnect logic on disconnect (exponential backoff)
7. Clean up connections on unmount
8. Type all messages using WSMessage<T> from types.ts

Example Service Structure:
class WebSocketService {
  private ws: WebSocket | null = null;
  private reconnectAttempts = 0;
  
  connect(url: string): void {
    this.ws = new WebSocket(url);
    this.ws.onmessage = this.handleMessage;
    this.ws.onerror = this.handleError;
    this.ws.onclose = this.handleClose;
  }
  
  subscribe(gameName: string): void {
    this.send({
      type: WSMessageType.SUBSCRIBE,
      payload: { gameName },
      timestamp: new Date().toISOString()
    });
  }
  
  private handleMessage(event: MessageEvent): void {
    const message: WSMessage = JSON.parse(event.data);
    if (message.type === WSMessageType.SCORE_UPDATE) {
      // Emit to listeners
    }
  }
}
```

### B4: Testing WebSocket Flow

**Agent**: `@testing_agent`

```
Context: Testing WebSocket requires both backend tests (Go) and frontend 
tests (React Testing Library + mock WebSocket).

Objective: Write comprehensive WebSocket tests.

Requirements:
Go Backend Tests (go-backend/tests/):
1. Test NotificationService.NotifyScoreUpdate sends to hub
2. Test WebSocket handler accepts connections
3. Test message broadcast to multiple connected clients
4. Test subscribe/unsubscribe message handling

Frontend Tests:
1. Mock WebSocket API (use global.WebSocket = vi.fn())
2. Test connection establishment
3. Test SCORE_UPDATE message handling
4. Test reconnection logic on disconnect
5. Test subscribe/unsubscribe calls

Example Go Test:
func TestNotificationService_BroadcastScoreUpdate(t *testing.T) {
  hub := websocket.NewHub()
  go hub.Run()
  defer hub.Stop()
  
  service := service.NewNotificationService(hub)
  score := &models.GameScore{
    PlayerName: "Test",
    Score: 1000,
  }
  
  service.NotifyScoreUpdate(score)
  
  // Verify message sent to hub.Broadcast channel
  select {
  case msg := <-hub.Broadcast:
    assert.Equal(t, "SCORE_UPDATE", msg.Type)
  case <-time.After(100 * time.Millisecond):
    t.Fatal("No message received")
  }
}
```

---

## Scenario C: Add Entity Field Across Full Stack

**Use Case**: Add a `rank: number` field to ScoreResponse that calculates the player's rank for that game.

### C1: Planning Phase

**Agent**: `@planning_arch_agent`

```
Context: Adding a field to ScoreResponse impacts: backend entities (Java + Go), 
API contract (types.ts), frontend components, seed data, and potentially database 
migrations. Follow .github/copilot-instructions.md section 3 (API contract constraints).

Objective: Create implementation plan for adding `rank` field to ScoreResponse.

Requirements:
1. Define rank calculation logic (rank within game, 1 = highest score)
2. Decide if rank is computed at query time or stored
3. Update API contract first (types.ts)
4. Coordinate backend changes (Java + Go must match)
5. Update seed data if needed
6. Tasks for: API contract, backends, frontend display, tests

Example Output:
Task 1: @api_contract_agent - Add rank: number to ScoreResponse in types.ts
Task 2: @java_backend_agent - Add rank field to ScoreResponseDTO
Task 3: @go_backend_agent - Add Rank field to ScoreResponse struct
Task 4: Both backends - Compute rank in GetTopScoresForGame method
Task 5: @frontend_agent - Display rank badge in leaderboard UI
Task 6: @testing_agent - Verify rank calculation correctness
```

### C2: Update API Contract

**Agent**: `@api_contract_agent`

```
Context: You manage the API contract between frontend and backends. All changes 
to frontend/src/app/api/types.ts must be coordinated with both Java and Go backends.

Objective: Add rank field to ScoreResponse interface.

Requirements:
1. Edit frontend/src/app/api/types.ts
2. Add `rank: number` to ScoreResponse interface
3. Add JSDoc comment explaining rank (1 = highest score in game)
4. Verify no breaking changes to existing fields
5. Document that rank is computed server-side

Example:
/**
 * Score response from the backend API
 */
export interface ScoreResponse {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  /**
   * Player's rank for this game (1 = highest score)
   * Computed server-side based on score ordering
   */
  rank: number;
  achievedAt: string;
  createdAt: string;
}
```

### C3: Update Java Backend

**Agent**: `@java_backend_agent`

```
Context: You are updating the Java Spring Boot backend to include rank calculation. 
The ScoreResponseDTO must match the TypeScript ScoreResponse interface.

Objective: Add rank field to ScoreResponseDTO and compute it in service layer.

Requirements:
1. Add `private Integer rank` to ScoreResponseDTO class
2. Update GameScoreService.getTopScoresForGame to compute rank
3. Rank logic: ORDER BY score DESC, then assign rank 1, 2, 3...
4. Add rank to DTO mapping/builder
5. Ensure all endpoints returning ScoreResponse include rank
6. Handle tie-breaking (same score = same rank, or sequential?)

Example Service Logic:
public List<ScoreResponseDTO> getTopScoresForGame(String gameName, int limit) {
  List<GameScore> scores = repository.findTopByGameNameOrderByScoreDesc(gameName, limit);
  
  return IntStream.range(0, scores.size())
    .mapToObj(i -> {
      GameScore score = scores.get(i);
      return ScoreResponseDTO.builder()
        .id(score.getId())
        .playerName(score.getPlayerName())
        .gameName(score.getGameName())
        .score(score.getScore())
        .rank(i + 1) // Rank is 1-indexed
        .achievedAt(score.getAchievedAt())
        .createdAt(score.getCreatedAt())
        .build();
    })
    .collect(Collectors.toList());
}
```

### C4: Update Go Backend

**Agent**: `@go_backend_agent`

```
Context: You are updating go-backend/ to add rank calculation. Follow Go backend 
rules section 4 (structure, validation, error handling).

Objective: Add Rank field to ScoreResponse and compute it in service methods.

Requirements:
1. Add `Rank int \`json:"rank"\`` to models.ScoreResponse struct
2. Update GameScoreService.GetTopScoresForGame to assign rank
3. Rank is position in DESC score order (1 = highest)
4. Update ToResponse() method if needed
5. Ensure all handlers returning []ScoreResponse include rank
6. Use 1-indexed ranks (not 0-indexed)

Example (in service/game_score_service.go):
func (s *GameScoreService) GetTopScoresForGame(gameName string, limit int) ([]models.GameScore, error) {
  scores, err := s.repository.GetTopScoresForGame(gameName, limit)
  if err != nil {
    return nil, fmt.Errorf("failed to get top scores: %w", err)
  }
  
  // Assign ranks
  for i := range scores {
    scores[i].Rank = i + 1
  }
  
  return scores, nil
}
```

### C5: Frontend Display

**Agent**: `@frontend_agent`

```
Context: The frontend now receives rank field from backend. Update UI components 
to display rank badges in the leaderboard.

Objective: Display rank badges in leaderboard components.

Requirements:
1. Verify ScoreResponse.rank is available in types.ts
2. Update Leaderboard component to display rank
3. Add rank badge/icon (e.g., trophy for #1, medal for top 3)
4. Use Tailwind CSS for styling
5. Handle cases where rank might be undefined (graceful degradation)
6. Update any table headers to include "Rank" column

Example Component Update:
<div className="leaderboard-entry">
  <div className="rank-badge">
    {score.rank === 1 && <span className="text-yellow-500">🏆</span>}
    {score.rank === 2 && <span className="text-gray-400">🥈</span>}
    {score.rank === 3 && <span className="text-orange-600">🥉</span>}
    <span className="font-bold">#{score.rank}</span>
  </div>
  <div className="player-name">{score.playerName}</div>
  <div className="score">{score.score.toLocaleString()}</div>
</div>
```

### C6: Update Seed Data

**Agent**: `@seed_data_agent`

```
Context: You manage canonical seed data in shared/seed-data.json. This file is 
used to bootstrap databases in both backends.

Objective: Assess if seed data needs rank field (likely not, since computed).

Requirements:
1. Review shared/seed-data.json structure
2. Determine if rank should be in seed data (recommendation: NO, compute at runtime)
3. Validate seed data against schema
4. Update version field if schema changes
5. Run validate-seed-data.py to verify

Example Decision:
Rank is computed dynamically based on score ordering, so it should NOT be 
stored in seed-data.json. No changes needed to seed data file.

If rank WERE stored:
- Add "rank": 1 to first entry for each game
- Ensure ranks are sequential within each game
- Update lastUpdated timestamp
```

### C7: Integration Testing

**Agent**: `@testing_agent`

```
Context: Test that rank field is correctly computed and returned across all layers.

Objective: Write integration tests verifying rank calculation.

Requirements:
Backend Tests (both Java and Go):
1. Test GetTopScoresForGame returns ranks 1, 2, 3... in order
2. Test tied scores (if tie-breaking implemented)
3. Test rank for single score (should be 1)
4. Test rank is included in JSON response

Frontend Tests:
1. Mock API response with rank field
2. Verify rank badge renders correctly
3. Test rank = 1 shows trophy icon
4. Test rank > 3 shows numeric rank only

End-to-End Test:
1. Seed database with 5 scores
2. Call GET /api/scores/game/{game}/top
3. Verify response includes rank field in ascending order
4. Verify frontend displays ranks correctly

Example Go Test:
func TestGetTopScoresForGame_IncludesRank(t *testing.T) {
  // Setup: Insert 3 scores with different values
  service.SubmitScore(&models.ScoreSubmissionRequest{
    PlayerName: "Alice", GameName: "Test", Score: 1000,
  })
  service.SubmitScore(&models.ScoreSubmissionRequest{
    PlayerName: "Bob", GameName: "Test", Score: 900,
  })
  
  scores, _ := service.GetTopScoresForGame("Test", 10)
  
  assert.Equal(t, 1, scores[0].Rank)
  assert.Equal(t, 2, scores[1].Rank)
  assert.Equal(t, "Alice", scores[0].PlayerName) // Highest score
}
```

---

## Custom Agent Creation Guide

Before using the prompts above, create custom agent files in `.github/agents/`.

### Agent File Structure

Each `.agent.md` file should follow this template:

```markdown
# {Agent Name}

{Brief description of agent's purpose and expertise}

## Instructions

- {What this agent should do}
- {What this agent should NOT do}
- {Key rules and constraints}

## Tools

- {Specific tools this agent uses}
- {File patterns this agent works with}

## Context

- {Important files to always reference}
- {Conventions to follow}

## Examples

{Example inputs and expected outputs}
```

### Example: Go Backend Agent

Create `.github/agents/go_backend_agent.agent.md`:

```markdown
# Go Backend Agent

Specialist in Go backend development for the high-scores-demo project. 
Implements handlers, services, and repositories following clean architecture.

## Instructions

- Implement Go backend features using Gin framework
- Follow structure: handlers/ → service/ → repository/
- Use clean architecture patterns (domain separation)
- Write table-driven tests in tests/
- Follow ALL rules in .github/copilot-instructions.md section 4 (Go backend rules)

## Constraints

- Must use context.Context end-to-end
- Must validate requests explicitly
- Must return consistent JSON errors: {"error":{"code":"...","message":"..."}}
- Must wrap errors with context: fmt.Errorf("...: %w", err)
- Prefer standard library over external dependencies

## Tools

- File patterns: go-backend/**/*.go
- Testing: go-backend/tests/*_test.go
- Always run: go mod tidy after adding dependencies

## Reference Files

- go-backend/handlers/score_handler.go (handler patterns)
- go-backend/service/game_score_service.go (service patterns)
- go-backend/tests/handler_test.go (test patterns)
- go-backend/models/game_score.go (model definitions)
- .github/copilot-instructions.md (architecture rules)

## Examples

**Input**: "Add GetPlayerStats handler"

**Output**:
1. Create PlayerStats struct in models/
2. Add GetPlayerStats method to GameScoreService
3. Add repository method to fetch player aggregates
4. Add handler method to handlers/score_handler.go
5. Register route in main.go
6. Write handler test in tests/handler_test.go
```

### Example: Frontend Agent

Create `.github/agents/frontend_agent.agent.md`:

```markdown
# Frontend Agent

React TypeScript specialist for high-scores-demo frontend. Implements 
components, API integration, and state management.

## Instructions

- Implement React components using TypeScript
- Use Tailwind CSS for styling
- Integrate with backend via frontend/src/app/api/scoreService.ts
- Maintain type safety using types from types.ts
- Follow React best practices (hooks, component composition)

## Constraints

- All API calls MUST use scoreService.ts wrapper (never raw fetch)
- All types MUST be defined in types.ts
- Components MUST handle loading and error states
- Use ApiResponse<T> type for all API calls
- Never expose API keys or secrets

## Tools

- File patterns: frontend/src/**/*.{ts,tsx}
- Styling: Tailwind CSS classes
- Testing: React Testing Library + Vitest

## Reference Files

- frontend/src/app/api/types.ts (TypeScript types)
- frontend/src/app/api/scoreService.ts (API integration patterns)
- frontend/src/app/components/ (component examples)
- .github/copilot-instructions.md (API contract constraints)

## Examples

**Input**: "Add component to display game statistics"

**Output**:
1. Import GameStats type from types.ts
2. Create GameStatsCard.tsx component
3. Use getGameStats from scoreService
4. Handle loading state with spinner
5. Handle error state with error message
6. Display stats using Tailwind grid layout
7. Add prop types with TypeScript interface
```

### Invocation Syntax

Once agent files are created, invoke them in Copilot Chat:

```
@go_backend_agent Add a new endpoint for player leaderboard
```

```
@frontend_agent Create a component to display top players
```

```
@api_contract_agent Verify the PlayerLeaderboard type matches backend DTO
```

---

## Quick Start: Try It Now

### Step 1: Create Agent Files

1. Create directory: `.github/agents/`
2. Copy the agent templates above
3. Create at minimum:
   - `planning_arch_agent.agent.md`
   - `go_backend_agent.agent.md`
   - `java_backend_agent.agent.md`
   - `frontend_agent.agent.md`
   - `api_contract_agent.agent.md`
   - `testing_agent.agent.md`

### Step 2: Choose a Scenario

- **New to agents?** Start with **Scenario A** (Add New API Endpoint)
- **Building real-time features?** Use **Scenario B** (WebSocket)
- **Modifying schema?** Use **Scenario C** (Entity Field)

### Step 3: Execute Prompts in Order

1. **Start with planning**: Copy the "Planning Phase" prompt for your scenario
2. **Paste in Copilot Chat** and send
3. **Review the plan**: Agent will break down tasks
4. **Execute each task**: Use the subsequent prompts (A2, A3, A4...)
5. **Invoke agents**: Use `@agent_name` syntax with prompts
6. **Iterate**: Ask follow-up questions, request changes

### Step 4: Validate Changes

1. **Run tests**: `@testing_agent Run all tests for the changes`
2. **Code review**: `@code_reviewer Review the implementation for quality and security`
3. **Local testing**: Test endpoints with `.http` files in `java-spring-boot-backend/`

### Example Full Workflow

```
Step 1: @planning_arch_agent {paste Scenario A planning prompt}
  ↓
Step 2: @api_contract_agent {paste prompt A2}
  ↓
Step 3: @java_backend_agent {paste prompt A3}
  ↓
Step 4: @go_backend_agent {paste prompt A4}
  ↓
Step 5: @frontend_agent {paste prompt A5}
  ↓
Step 6: @testing_agent {paste prompt A6}
  ↓
Step 7: @code_reviewer Review all changes for API contract compliance
```

> **Pro Tip**: Keep [.github/copilot-instructions.md](.github/copilot-instructions.md) 
> open in a tab. Agents reference these rules, and you can verify their outputs 
> against the documented conventions.

---

## Related Documentation

### Agent Workflows
- [docs/AGENTIC_WORKFLOW_LEADERBOARD.md](docs/AGENTIC_WORKFLOW_LEADERBOARD.md) - Detailed leaderboard migration agent workflow
- [.github/copilot-instructions.md](.github/copilot-instructions.md) - Repository rules and conventions for agents

### API Contracts & Architecture
- [frontend/src/app/api/types.ts](frontend/src/app/api/types.ts) - TypeScript API contract definitions
- [frontend/src/app/api/scoreService.ts](frontend/src/app/api/scoreService.ts) - Frontend API service patterns
- [docs/API_CONTRACT_UPDATES_2026-02-04.md](docs/API_CONTRACT_UPDATES_2026-02-04.md) - API contract evolution

### Implementation Examples
- [go-backend/handlers/score_handler.go](go-backend/handlers/score_handler.go) - Go handler patterns
- [go-backend/tests/handler_test.go](go-backend/tests/handler_test.go) - Go testing patterns
- [go-backend/websocket/hub.go](go-backend/websocket/hub.go) - WebSocket implementation

### Project Roadmaps
- [docs/ROADMAP.md](docs/ROADMAP.md) - Overall development phases and milestones
- [docs/LEADERBOARD_MIGRATION_PLAN.md](docs/LEADERBOARD_MIGRATION_PLAN.md) - Leaderboard feature implementation
- [docs/TROPHIES_FEATURE_ROADMAP.md](docs/TROPHIES_FEATURE_ROADMAP.md) - Trophies feature details

### Workshop Materials
- [docs/vscode-workshop/00-key-definitions-best-practices.md](docs/vscode-workshop/00-key-definitions-best-practices.md) - Custom agent definitions and patterns
