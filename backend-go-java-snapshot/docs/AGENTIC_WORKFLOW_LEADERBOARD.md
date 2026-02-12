# Agentic Workflow Guide: Leaderboard Migration

> **Document Version**: 1.0  
> **Created**: February 3, 2026  
> **Purpose**: Developer guide for executing the leaderboard migration using GitHub Copilot agents

---

## Overview

This guide explains how to execute the leaderboard migration using the specialized agents defined in `.github/agents/`. Each task is mapped to an agent with ready-to-use prompts.

---

## Agent Inventory

| Agent | File | Purpose |
|-------|------|---------|
| `@planning_arch_agent` | `.github/agents/planning_arch_agent.agent.md` | Sprint planning and orchestration |
| `@seed_data_agent` | `.github/agents/seed_data_agent.agent.md` | Canonical seed data management |
| `@api_contract_agent` | `.github/agents/api_contract_agent.agent.md` | API contract validation |
| `@java_backend_agent` | `.github/agents/java_backend_agent.agent.md` | Spring Boot implementation |
| `@go_backend_agent` | `.github/agents/go_backend_agent.agent.md` | Go backend implementation |
| `@frontend_agent` | `.github/agents/frontend_agent.agent.md` | React/TypeScript implementation |
| `@testing_agent` | `.github/agents/testing_agent.agent.md` | Test creation and execution |
| `@docker_agent` | `.github/agents/docker_agent.agent.md` | Container configuration |

---

## How to Invoke Agents

### VS Code Copilot Chat

1. Open Copilot Chat (`Ctrl+Shift+I` or `Cmd+Shift+I`)
2. Type `@` followed by the agent name
3. Provide the task prompt

**Example:**
```
@java_backend_agent Add kills and wins fields to GameScore entity
```

### Using with Agent Mode

1. Switch to Agent mode in Copilot Chat
2. The agent will automatically detect which specialized agent to use based on context
3. Alternatively, explicitly reference the agent in your prompt

---

## Task Execution Workflow

### Step 1: Start with Planning Agent

Always begin by consulting the planning agent:

```
@planning_arch_agent

I need to migrate hardcoded leaderboard data from frontend to backend.
Please create an execution plan with agent assignments.

Context:
- Frontend has hardcoded fallbackData in Leaderboard.tsx
- Need to extend GameScore entity with kills/wins fields
- Need to implement seed data loading from shared/seed-data.json
- Both Java and Go backends need updates
```

### Step 2: Execute Tasks in Dependency Order

The planning agent will provide a sequence. Execute each task using the assigned agent.

---

## Phase 1: Seed Data Setup

### Task 1.1: Create/Verify Canonical Seed Data

```
@seed_data_agent

Verify the canonical seed data file at shared/seed-data.json.

Requirements:
1. Ensure JSON schema includes: playerName, gameName, score, kills, wins
2. Include at least 10 scores for "Operation Nightfall"
3. Include at least 5 scores for "Shadow Protocol"
4. Ensure player names match the current frontend fallbackData

Expected Output:
- Validated seed-data.json with all required fields
- Version and lastUpdated fields populated
```

---

## Phase 2: Backend Entity Updates

### Task 2.1: Extend Java Entity

```
@java_backend_agent

Add kills and wins fields to the GameScore entity.

File: java-spring-boot-backend/src/main/java/com/insight/ai_demo/entity/GameScore.java

Requirements:
1. Add Integer kills field with @Column(nullable = false) and default value 0
2. Add Integer wins field with @Column(nullable = false) and default value 0
3. Add fields to any existing constructors
4. Ensure Lombok generates proper getters/setters

Constraints:
- Keep existing fields unchanged
- Maintain @PrePersist behavior
- Follow existing code style

Acceptance Criteria:
- [ ] kills field added with proper annotations
- [ ] wins field added with proper annotations
- [ ] Entity compiles without errors
- [ ] Existing tests still pass
```

### Task 2.2: Extend Go Model

```
@go_backend_agent

Add kills and wins fields to the GameScore model.

File: go-backend/models/game_score.go

Requirements:
1. Add Kills int field with gorm tag: `gorm:"not null;default:0" json:"kills"`
2. Add Wins int field with gorm tag: `gorm:"not null;default:0" json:"wins"`
3. Update ScoreResponse struct to include kills and wins
4. Update any DTOs that map from GameScore

Constraints:
- Follow existing naming conventions
- Ensure JSON tags use camelCase
- Maintain GORM compatibility

Acceptance Criteria:
- [ ] Kills field added with proper tags
- [ ] Wins field added with proper tags
- [ ] ScoreResponse includes new fields
- [ ] Code compiles: go build ./...
```

---

## Phase 3: Database Configuration

### Task 3.1: Switch Java to SQLite

```
@java_backend_agent

Switch the Java backend from H2 to SQLite for persistent storage.

Files to modify:
1. java-spring-boot-backend/build.gradle - Add SQLite dependencies
2. java-spring-boot-backend/src/main/resources/application.properties - Update datasource config

Requirements:
1. Add org.xerial:sqlite-jdbc:3.45.1.0 dependency
2. Add org.hibernate.orm:hibernate-community-dialects:6.4.4.Final dependency
3. Configure datasource URL: jdbc:sqlite:./data/highscores.db
4. Set hibernate.ddl-auto=update (not create-drop)
5. Create data directory if needed

Constraints:
- Remove or comment out H2 dependency
- Disable H2 console
- Ensure SQLiteDialect is used

Acceptance Criteria:
- [ ] Build succeeds with new dependencies
- [ ] Application starts without database errors
- [ ] Data persists across restarts
```

### Task 3.2: Update Docker Compose

```
@docker_agent

Update docker-compose.yml to support SQLite persistence and shared seed data.

Requirements:
1. Add volume mount for Java backend: ./java-spring-boot-backend/data:/app/data
2. Add read-only volume for shared seed data: ./shared:/app/shared:ro
3. Add same shared volume to Go backend
4. Ensure volume permissions are correct

Acceptance Criteria:
- [ ] docker-compose up starts all services
- [ ] Both backends can read shared/seed-data.json
- [ ] SQLite database persists across container restarts
```

---

## Phase 4: Seed Data Loaders

### Task 4.1: Java DataInitializer

```
@java_backend_agent

Create DataInitializer to load seed data from shared/seed-data.json.

File to create: java-spring-boot-backend/src/main/java/com/insight/ai_demo/config/DataInitializer.java

Requirements:
1. Implement CommandLineRunner interface
2. Check if database is empty before seeding
3. Read seed data from ./shared/seed-data.json
4. Parse JSON and create GameScore entities
5. Log success/failure of seeding

Error Handling:
- If file not found: log warning, continue without crashing
- If database not empty: skip seeding, log info
- If JSON parse error: log error, continue without crashing

Acceptance Criteria:
- [ ] DataInitializer created in config package
- [ ] Seeds database on first start
- [ ] Skips seeding if data exists
- [ ] Handles missing file gracefully
```

### Task 4.2: Update Go Seed Function

```
@go_backend_agent

Update SeedData function to load from shared/seed-data.json instead of hardcoded data.

File: go-backend/models/db.go

Requirements:
1. Read seed data from ./shared/seed-data.json
2. Parse JSON into appropriate struct
3. Create GameScore records including kills and wins
4. Maintain existing "skip if data exists" behavior

Error Handling:
- If file not found: log warning, return nil (no error)
- If JSON parse error: return error with context

Acceptance Criteria:
- [ ] SeedData reads from JSON file
- [ ] Kills and wins populated from JSON
- [ ] Existing skip logic preserved
- [ ] Error handling is graceful
```

---

## Phase 5: API Contract Validation

### Task 5.1: Validate API Responses

```
@api_contract_agent

Verify that both backends return consistent responses with kills and wins fields.

Validation Steps:
1. Start both backends
2. Query top scores endpoint from each
3. Compare response structures
4. Verify kills and wins are present and populated

Test Commands:
curl http://localhost:8080/api/scores/game/Operation%20Nightfall/top?limit=3
curl http://localhost:8081/api/scores/game/Operation%20Nightfall/top?limit=3

Expected Response Structure:
{
  "id": number,
  "playerName": string,
  "gameName": string,
  "score": number,
  "kills": number,      // Must be present
  "wins": number,       // Must be present
  "achievedAt": string,
  "createdAt": string
}

Acceptance Criteria:
- [ ] Both backends return kills field
- [ ] Both backends return wins field
- [ ] Field names match exactly (camelCase)
- [ ] Values are numbers, not null/undefined
```

### Task 5.2: Update Frontend Types

```
@frontend_agent

Update frontend TypeScript types to include kills and wins fields.

File: frontend/src/app/api/types.ts

Requirements:
1. Add kills: number to ScoreResponse interface
2. Add wins: number to ScoreResponse interface
3. Ensure fields are required (not optional)

Acceptance Criteria:
- [ ] ScoreResponse includes kills: number
- [ ] ScoreResponse includes wins: number
- [ ] TypeScript compilation succeeds
```

---

## Phase 6: Frontend Cleanup

### Task 6.1: Remove Hardcoded Fallback

```
@frontend_agent

Remove hardcoded fallbackData from Leaderboard.tsx and implement proper empty state.

File: frontend/src/app/components/Leaderboard.tsx

Requirements:
1. Remove the fallbackData constant (lines 8-21)
2. Update initial state to empty array: useState<LeaderboardEntry[]>([])
3. Update error handler to set empty array instead of fallbackData
4. Update empty response handler to set empty array
5. Update convertToLeaderboardEntries to include kills and wins from API response
6. Add empty state UI when leaderboardData.length === 0

Empty State UI:
<div className="text-center py-20 bg-black/40 backdrop-blur-sm border border-gray-800 rounded-lg">
  <Trophy className="w-16 h-16 mx-auto text-gray-600 mb-4" />
  <h3 className="text-xl text-gray-400 mb-2">No scores yet</h3>
  <p className="text-gray-500">Be the first to claim the top spot!</p>
</div>

Constraints:
- Keep all existing UI structure
- Maintain WebSocket integration
- Keep refresh functionality

Acceptance Criteria:
- [ ] fallbackData constant removed
- [ ] Empty state UI renders when no data
- [ ] Kills and wins display from API data
- [ ] No TypeScript errors
- [ ] No runtime errors
```

---

## Phase 7: Testing

### Task 7.1: Backend Tests

```
@testing_agent

Create tests for the new seed data functionality.

Java Tests (create in src/test/java):
1. DataInitializerTest - test seed loading
2. GameScoreEntityTest - test kills/wins fields

Go Tests (create in tests/):
1. seed_data_test.go - test SeedData function
2. model_test.go - test GameScore with new fields

Requirements:
- Test happy path: seed data loads correctly
- Test empty database triggers seeding
- Test populated database skips seeding
- Test missing file handling
- Test new fields are persisted correctly

Acceptance Criteria:
- [ ] Java tests pass: ./gradlew test
- [ ] Go tests pass: go test ./...
```

### Task 7.2: Integration Test

```
@testing_agent

Create integration test script for full migration validation.

File to create: scripts/test-leaderboard-migration.sh

Test Steps:
1. Stop and remove containers
2. Remove database volumes
3. Start fresh containers
4. Wait for services to be ready
5. Verify Java backend has seeded data with kills/wins
6. Verify Go backend has seeded data with kills/wins
7. Verify frontend displays data correctly (curl or playwright)
8. Stop containers
9. Start containers again
10. Verify data persists

Acceptance Criteria:
- [ ] Script runs without errors
- [ ] All verification steps pass
- [ ] Data persists across restarts
```

---

## Execution Checklist

Use this checklist to track progress:

```markdown
## Sprint Progress: Leaderboard Migration

### Phase 1: Seed Data Setup
- [ ] Task 1.1: Verify seed-data.json (@seed_data_agent)

### Phase 2: Backend Entity Updates  
- [ ] Task 2.1: Extend Java entity (@java_backend_agent)
- [ ] Task 2.2: Extend Go model (@go_backend_agent)

### Phase 3: Database Configuration
- [ ] Task 3.1: Switch Java to SQLite (@java_backend_agent)
- [ ] Task 3.2: Update Docker Compose (@docker_agent)

### Phase 4: Seed Data Loaders
- [ ] Task 4.1: Java DataInitializer (@java_backend_agent)
- [ ] Task 4.2: Update Go SeedData (@go_backend_agent)

### Phase 5: API Contract Validation
- [ ] Task 5.1: Validate API responses (@api_contract_agent)
- [ ] Task 5.2: Update frontend types (@frontend_agent)

### Phase 6: Frontend Cleanup
- [ ] Task 6.1: Remove hardcoded fallback (@frontend_agent)

### Phase 7: Testing
- [ ] Task 7.1: Backend tests (@testing_agent)
- [ ] Task 7.2: Integration test (@testing_agent)
```

---

## Troubleshooting

### Agent Not Responding as Expected

1. Ensure agent file exists in `.github/agents/`
2. Check agent file has correct frontmatter (description, tools)
3. Provide more context in your prompt
4. Break task into smaller pieces

### Dependency Issues

1. Use `@planning_arch_agent` to verify task sequence
2. Check if blocking task is completed
3. Verify files exist before referencing them

### Compilation Errors After Agent Changes

1. Use `@testing_agent` to run builds
2. Check for typos in generated code
3. Verify imports are correct
4. Run type checking: `npm run build`, `./gradlew build`, `go build ./...`

---

## Best Practices

1. **Start each session** with `@planning_arch_agent` to get current status
2. **Complete one task** before starting the next
3. **Verify acceptance criteria** before marking task complete
4. **Document blockers** immediately when encountered
5. **Use `@api_contract_agent`** when making cross-service changes
