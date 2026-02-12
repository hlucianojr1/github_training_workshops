# Sprint Backlog: Leaderboard Data Migration

> **Sprint Name**: Leaderboard Refactoring Sprint  
> **Sprint Duration**: 5 working days  
> **Total Story Points**: 27 pts  
> **Sprint Goal**: Remove hardcoded frontend data, implement canonical seed data in backends, extend data model with kills/wins

---

## Sprint Overview

| Metric | Value |
|--------|-------|
| Start Date | 2026-02-03 |
| End Date | 2026-02-07 |
| Velocity Target | 27 pts |
| Team Capacity | 1 developer |
| Daily Capacity | ~5-6 pts |

---

## User Stories

### US-1: Extend Game Score Data Model
**As a** leaderboard viewer  
**I want** to see kills and wins statistics  
**So that** I can understand player performance beyond just score

**Story Points**: 6 pts  
**Priority**: High (blocks other stories)

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-1.1 | Add kills/wins to Java GameScore entity | `@java_backend_agent` | 2 | ⏳ Pending | None |
| T-1.2 | Add kills/wins to Go GameScore model | `@go_backend_agent` | 2 | ⏳ Pending | None |
| T-1.3 | Update DTOs and response types | `@api_contract_agent` | 1 | ⏳ Pending | T-1.1, T-1.2 |
| T-1.4 | Update frontend TypeScript types | `@frontend_agent` | 1 | ⏳ Pending | T-1.3 |

#### Acceptance Criteria
- [ ] Java entity includes `kills` and `wins` Integer fields with defaults
- [ ] Go model includes `Kills` and `Wins` int fields with gorm tags
- [ ] API responses include kills and wins in JSON
- [ ] Frontend types updated to require kills and wins

---

### US-2: SQLite Persistence for Java Backend
**As a** developer  
**I want** the Java backend to persist data in SQLite  
**So that** data survives container restarts

**Story Points**: 4 pts  
**Priority**: High (blocks seed data)

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-2.1 | Add SQLite dependency to build.gradle | `@java_backend_agent` | 1 | ⏳ Pending | None |
| T-2.2 | Configure SQLite in application.properties | `@java_backend_agent` | 1 | ⏳ Pending | T-2.1 |
| T-2.3 | Update docker-compose with volume mounts | `@docker_agent` | 2 | ⏳ Pending | T-2.2 |

#### Acceptance Criteria
- [ ] Java backend uses SQLite (jdbc:sqlite:./data/highscores.db)
- [ ] H2 dependency removed or disabled
- [ ] Docker volume persists database file
- [ ] Data survives `docker-compose down && docker-compose up`

---

### US-3: Canonical Seed Data System
**As a** developer  
**I want** a single source of truth for seed data  
**So that** both backends have consistent test data

**Story Points**: 7 pts  
**Priority**: High (core deliverable)

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-3.1 | Create/validate shared/seed-data.json | `@seed_data_agent` | 2 | ✅ Done | None |
| T-3.2 | Create Java DataInitializer | `@java_backend_agent` | 3 | ⏳ Pending | T-1.1, T-2.2 |
| T-3.3 | Update Go SeedData to read JSON | `@go_backend_agent` | 2 | ⏳ Pending | T-1.2, T-3.1 |

#### Acceptance Criteria
- [ ] shared/seed-data.json contains 20 scores with kills/wins
- [ ] Java DataInitializer loads from JSON on empty database
- [ ] Go SeedData loads from JSON on empty database
- [ ] Both backends skip seeding if data exists
- [ ] Both backends handle missing file gracefully

---

### US-4: Remove Frontend Hardcoded Data
**As a** user  
**I want** to see real data or a proper empty state  
**So that** I'm not confused by fake "demo" data

**Story Points**: 5 pts  
**Priority**: Medium (depends on backend work)

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-4.1 | Remove fallbackData from Leaderboard.tsx | `@frontend_agent` | 2 | ⏳ Pending | T-1.4 |
| T-4.2 | Add empty state UI component | `@frontend_agent` | 2 | ⏳ Pending | T-4.1 |
| T-4.3 | Update convertToLeaderboardEntries | `@frontend_agent` | 1 | ⏳ Pending | T-4.1 |

#### Acceptance Criteria
- [ ] No hardcoded fallbackData array in Leaderboard.tsx
- [ ] Empty state shows trophy icon and "No scores yet" message
- [ ] Kills and wins render from API response
- [ ] No `undefined.toLocaleString()` errors
- [ ] Warning banner removed (no more "demo data")

---

### US-5: Validate Migration with Tests
**As a** developer  
**I want** automated tests for the new functionality  
**So that** I can verify the migration works correctly

**Story Points**: 5 pts  
**Priority**: Medium (quality assurance)

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-5.1 | Create Java seed data tests | `@testing_agent` | 2 | ⏳ Pending | T-3.2 |
| T-5.2 | Create Go seed data tests | `@testing_agent` | 2 | ⏳ Pending | T-3.3 |
| T-5.3 | Create integration test script | `@testing_agent` | 1 | ⏳ Pending | T-4.2 |

#### Acceptance Criteria
- [ ] Java tests cover DataInitializer scenarios
- [ ] Go tests cover SeedData scenarios
- [ ] Integration script validates end-to-end flow
- [ ] All tests pass in CI/locally

---

## Sprint Schedule

### Day 1 (Feb 3) - Foundation
**Capacity**: 6 pts

| Time | Task | Agent | Points |
|------|------|-------|--------|
| AM | T-1.1: Java entity | `@java_backend_agent` | 2 |
| AM | T-1.2: Go model | `@go_backend_agent` | 2 |
| PM | T-2.1: SQLite dependency | `@java_backend_agent` | 1 |
| PM | T-2.2: SQLite config | `@java_backend_agent` | 1 |

### Day 2 (Feb 4) - Infrastructure
**Capacity**: 5 pts

| Time | Task | Agent | Points |
|------|------|-------|--------|
| AM | T-2.3: Docker compose | `@docker_agent` | 2 |
| PM | T-3.2: Java DataInitializer | `@java_backend_agent` | 3 |

### Day 3 (Feb 5) - Seed Data
**Capacity**: 5 pts

| Time | Task | Agent | Points |
|------|------|-------|--------|
| AM | T-3.3: Go SeedData update | `@go_backend_agent` | 2 |
| AM | T-1.3: API contract validation | `@api_contract_agent` | 1 |
| PM | T-1.4: Frontend types | `@frontend_agent` | 1 |
| PM | T-4.1: Remove fallback | `@frontend_agent` | 1 |

### Day 4 (Feb 6) - Frontend
**Capacity**: 5 pts

| Time | Task | Agent | Points |
|------|------|-------|--------|
| AM | T-4.1: (continued) | `@frontend_agent` | 1 |
| AM | T-4.2: Empty state UI | `@frontend_agent` | 2 |
| PM | T-4.3: Entry conversion | `@frontend_agent` | 1 |
| PM | T-5.1: Java tests | `@testing_agent` | 1 |

### Day 5 (Feb 7) - Testing & Validation
**Capacity**: 6 pts

| Time | Task | Agent | Points |
|------|------|-------|--------|
| AM | T-5.1: (continued) | `@testing_agent` | 1 |
| AM | T-5.2: Go tests | `@testing_agent` | 2 |
| PM | T-5.3: Integration test | `@testing_agent` | 1 |
| PM | Sprint review & demo | `@planning_arch_agent` | - |

---

## Dependency Graph

```
T-3.1 (seed-data.json) ─────────────────────────────────┐
         ✅ Done                                        │
                                                        ▼
T-1.1 (Java entity) ───────┬────────────────► T-3.2 (Java DataInitializer)
         │                 │                           │
         │                 │                           ▼
         │                 └────────────────► T-1.3 (API contract)
         │                                             │
         ▼                                             ▼
T-2.1 (SQLite dep) ────► T-2.2 (SQLite config)  T-1.4 (Frontend types)
         │                       │                     │
         │                       │                     ▼
         │                       │              T-4.1 (Remove fallback)
         │                       │                     │
         │                       ▼                     ▼
         └──────────────► T-2.3 (Docker)        T-4.2 (Empty state)
                                │                     │
                                │                     ▼
                                │              T-4.3 (Entry conversion)
                                │                     │
                                ▼                     │
T-1.2 (Go model) ────────► T-3.3 (Go SeedData)        │
                                │                     │
                                ▼                     ▼
                          T-5.2 (Go tests)     T-5.1 (Java tests)
                                │                     │
                                └─────────┬───────────┘
                                          ▼
                                    T-5.3 (Integration)
```

---

## Definition of Done

### Per Task
- [ ] Code changes committed to feature branch
- [ ] No compilation/lint errors
- [ ] Relevant tests pass
- [ ] Agent acceptance criteria met

### Per User Story
- [ ] All tasks completed
- [ ] Story acceptance criteria met
- [ ] Code reviewed (self or peer)
- [ ] Integrated with main branch

### Sprint Complete
- [ ] All user stories done
- [ ] Integration test passes
- [ ] Documentation updated
- [ ] Demo completed

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| SQLite file permissions in Docker | Medium | Medium | Test volume mounts early |
| JSON parsing differences Java/Go | Low | High | Use @api_contract_agent |
| Frontend breaks during migration | Medium | High | Keep fallback until tested |
| Merge conflicts | Low | Low | Small, frequent commits |

---

## Rollback Criteria

Rollback sprint if:
- Integration tests fail repeatedly
- Data corruption detected
- More than 2 days behind schedule

Rollback procedure:
1. Revert Leaderboard.tsx to include fallbackData
2. Revert Java backend to H2
3. Comment out DataInitializer
4. Document lessons learned

---

## Sprint Ceremonies

| Ceremony | When | Duration | Agent |
|----------|------|----------|-------|
| Sprint Planning | Day 1 AM | 30 min | `@planning_arch_agent` |
| Daily Standup | Each day AM | 10 min | `@planning_arch_agent` |
| Sprint Review | Day 5 PM | 30 min | `@planning_arch_agent` |
| Retrospective | Day 5 PM | 20 min | Manual |

### Daily Standup Prompt

```
@planning_arch_agent

Daily standup for Leaderboard Migration Sprint.

Please provide:
1. Tasks completed yesterday
2. Tasks planned for today
3. Any blockers
4. Updated burndown status

Reference: docs/SPRINT_BACKLOG_LEADERBOARD.md
```

---

## Progress Tracking

### Burndown Chart Data

| Day | Planned Remaining | Actual Remaining | Notes |
|-----|------------------|------------------|-------|
| 0 | 27 | 27 | Sprint start |
| 1 | 21 | - | Target: 6 pts |
| 2 | 16 | - | Target: 5 pts |
| 3 | 11 | - | Target: 5 pts |
| 4 | 6 | - | Target: 5 pts |
| 5 | 0 | - | Sprint end |

---

## Completed Tasks Log

| Task | Completed | Agent | Notes |
|------|-----------|-------|-------|
| T-3.1 | 2026-02-03 | @seed_data_agent | Created shared/seed-data.json with 20 scores |

---

## Next Sprint Preview

If this sprint succeeds, the next sprint could include:
- Add player statistics page
- Implement score submission with kills/wins
- Add new games to seed data
- Performance optimizations
