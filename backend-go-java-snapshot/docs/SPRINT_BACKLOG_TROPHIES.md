# Sprint Backlog: Trophies Feature Implementation

> **Sprint Name**: Trophies Backend Migration Sprint  
> **Sprint Duration**: 3-4 working days  
> **Total Story Points**: 20 pts  
> **Sprint Goal**: Replace hardcoded frontend trophies with full backend implementation using Data Seed pattern

---

## Sprint Overview

| Metric | Value |
|--------|-------|
| Start Date | 2026-02-11 |
| End Date | 2026-02-14 |
| Velocity Target | 20 pts |
| Team Capacity | 1 developer |
| Daily Capacity | ~5-6 pts |
| Architecture Decision | Data Seed (JSON → Database) - Score: 9/10 |

---

## 📐 Sprint Phases

### Phase 1: Shared Data Schema (2 SP)
**Agent**: `@seed_data_agent`  
**Status**: 🔵 Ready to Start  
**Dependencies**: None

### Phase 2: Java Backend - PRIMARY (5 SP)
**Agent**: `@java_backend_agent`  
**Status**: 🔵 Ready to Start  
**Dependencies**: Phase 1 complete

### Phase 3: Go Backend - Mirror (5 SP)
**Agent**: `@go_backend_agent`  
**Status**: 🔵 Ready to Start  
**Dependencies**: Phase 1 complete (parallel with Phase 2)

### Phase 4: Frontend Integration (3 SP)
**Agent**: `@frontend_agent`  
**Status**: 🔵 Ready to Start  
**Dependencies**: Phase 2 OR Phase 3 complete

### Phase 5: API Contract & Testing (3 SP)
**Agent**: `@api_contract_agent` + `@testing_agent`  
**Status**: 🔵 Ready to Start  
**Dependencies**: Phases 2, 3, 4 complete

### Phase 6: Documentation & Deployment (2 SP)
**Agent**: Manual / `@planning_arch_agent`  
**Status**: 🔵 Ready to Start  
**Dependencies**: All phases complete

---

## User Stories

### US-TROPHY-1: Trophy Data Model & Seeding
**As a** developer  
**I want** trophies stored in a canonical JSON file and seeded to database  
**So that** both backends have consistent trophy data

**Story Points**: 7 pts  
**Priority**: High (blocks all other work)  
**Architecture**: Data Seed pattern (matches existing seed-data.json)

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-TROPHY-1.1 | Create shared/trophies.json schema | `@seed_data_agent` | 2 | 🔵 Ready | None |
| T-TROPHY-2.1 | Create Java Trophy entity + repo | `@java_backend_agent` | 1 | 🔵 Ready | T-TROPHY-1.1 |
| T-TROPHY-2.2 | Create Java Trophy DTO + service | `@java_backend_agent` | 1 | 🔵 Ready | T-TROPHY-2.1 |
| T-TROPHY-2.3 | Create Java TrophyDataInitializer | `@java_backend_agent` | 1 | 🔵 Ready | T-TROPHY-2.2 |
| T-TROPHY-3.1 | Create Go Trophy model + repo | `@go_backend_agent` | 1 | 🔵 Ready | T-TROPHY-1.1 |
| T-TROPHY-3.2 | Create Go Trophy service | `@go_backend_agent` | 1 | 🔵 Ready | T-TROPHY-3.1 |
| T-TROPHY-3.3 | Implement Go trophy seeding | `@go_backend_agent` | 1 | 🔵 Ready | T-TROPHY-3.2 |

#### Acceptance Criteria
- [ ] shared/trophies.json contains 10 trophies with schema: id, icon, name, description, rarity, colorGradient, bgColor, unlockCriteria
- [ ] Java Trophy entity uses JPA with H2/PostgreSQL support
- [ ] Go Trophy model uses GORM with SQLite support
- [ ] Both backends seed trophies on first startup
- [ ] Seeding skipped if trophies table already populated
- [ ] unlockCriteria stored as JSON text for future use

#### CORE Framework Prompts
See detailed prompts in: `docs/TROPHIES_FEATURE_ROADMAP.md`
- Phase 1 Task 1.1: Create shared/trophies.json
- Phase 2 Tasks 2.1-2.3: Java backend implementation
- Phase 3 Tasks 3.1-3.3: Go backend implementation

---

### US-TROPHY-2: Trophy REST API Endpoints
**As a** frontend developer  
**I want** a GET /api/trophies endpoint  
**So that** I can fetch trophy data dynamically

**Story Points**: 5 pts  
**Priority**: High (required for frontend)  
**API Contract**: GET /api/trophies → Array<TrophyResponse>

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-TROPHY-2.4 | Add Java trophy controller endpoint | `@java_backend_agent` | 1 | 🔵 Ready | T-TROPHY-2.2 |
| T-TROPHY-3.4 | Add Go trophy handler endpoint | `@go_backend_agent` | 1 | 🔵 Ready | T-TROPHY-3.2 |
| T-TROPHY-5.1 | Validate API contract consistency | `@api_contract_agent` | 2 | 🔵 Ready | T-TROPHY-2.4, T-TROPHY-3.4 |
| T-TROPHY-5.2 | Create backend unit tests | `@testing_agent` | 1 | 🔵 Ready | T-TROPHY-2.4, T-TROPHY-3.4 |

#### Acceptance Criteria
- [ ] Java backend: GET http://localhost:8080/api/trophies returns 200 OK
- [ ] Go backend: GET http://localhost:8081/api/trophies returns 200 OK
- [ ] Both backends return array of 10 trophies
- [ ] Response structure matches TrophyResponse schema
- [ ] Java and Go responses are identical (validated by contract agent)
- [ ] Endpoints logged in application logs
- [ ] Unit tests cover happy path and error cases

#### CORE Framework Prompts
See detailed prompts in: `docs/TROPHIES_FEATURE_ROADMAP.md`
- Phase 2 Task 2.4: Java trophy controller
- Phase 3 Task 3.4: Go trophy handler
- Phase 5 Task 5.1: API contract validation
- Phase 5 Task 5.2: Backend tests

---

### US-TROPHY-3: Frontend Dynamic Trophy Display
**As a** user  
**I want** to see trophies loaded from the backend  
**So that** trophy data stays in sync with the backend

**Story Points**: 5 pts  
**Priority**: High (visible user feature)  
**Current State**: Hardcoded in frontend/src/app/components/Trophies.tsx

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-TROPHY-4.1 | Add TrophyResponse type and getTrophies API | `@frontend_agent` | 1 | 🔵 Ready | T-TROPHY-2.4 OR T-TROPHY-3.4 |
| T-TROPHY-4.2 | Update Trophies component with dynamic fetch | `@frontend_agent` | 2 | 🔵 Ready | T-TROPHY-4.1 |
| T-TROPHY-5.3 | Create integration tests (.http files) | `@testing_agent` | 1 | 🔵 Ready | T-TROPHY-4.2 |
| T-TROPHY-6.1 | Update documentation | Manual | 1 | 🔵 Ready | T-TROPHY-5.3 |

#### Acceptance Criteria
- [ ] TrophyResponse interface added to frontend/src/app/api/types.ts
- [ ] getTrophies() function added to scoreService.ts
- [ ] Trophies component fetches data on mount
- [ ] Loading state displayed during fetch
- [ ] Error state displayed on fetch failure
- [ ] Icon mapping works (string → Lucide component)
- [ ] Visual appearance identical to hardcoded version
- [ ] No console errors
- [ ] Network tab shows successful /api/trophies call

#### CORE Framework Prompts
See detailed prompts in: `docs/TROPHIES_FEATURE_ROADMAP.md`
- Phase 4 Task 4.1: API types and service
- Phase 4 Task 4.2: Update Trophies component
- Phase 5 Task 5.3: Integration tests

---

### US-TROPHY-4: Deployment & Documentation
**As a** developer  
**I want** comprehensive documentation and deployment support  
**So that** the trophy feature can be deployed and maintained

**Story Points**: 3 pts  
**Priority**: Medium (nice-to-have)

#### Tasks

| Task ID | Description | Agent | Points | Status | Dependencies |
|---------|-------------|-------|--------|--------|--------------|
| T-TROPHY-6.1 | Update API documentation | Manual | 1 | 🔵 Ready | All implementation complete |
| T-TROPHY-6.2 | Verify Docker Compose deployment | `@docker_agent` | 2 | 🔵 Ready | T-TROPHY-6.1 |

#### Acceptance Criteria
- [ ] java-spring-boot-backend/README.md documents GET /api/trophies
- [ ] docs/TROPHIES_FEATURE_ROADMAP.md exists (this file)
- [ ] Trophies work in Docker Compose environment
- [ ] shared/trophies.json copied to Docker images
- [ ] Seeding logs visible in container logs
- [ ] Frontend displays trophies in containerized setup

#### CORE Framework Prompts
See detailed prompts in: `docs/TROPHIES_FEATURE_ROADMAP.md`
- Phase 6 Task 6.1: Update documentation
- Phase 6 Task 6.2: Docker & deployment verification

---

## 📊 Daily Stand-up Tracking

### Day 1 Target: Phase 1 + Start Phase 2 (6 SP)
**Goal**: Complete seed data schema and Java entity/repo  
**Tasks**: T-TROPHY-1.1, T-TROPHY-2.1, T-TROPHY-2.2, T-TROPHY-2.3

- [ ] Morning: Execute Phase 1 with @seed_data_agent (2 SP)
- [ ] Afternoon: Execute Phase 2 Tasks 2.1-2.3 with @java_backend_agent (4 SP)

**Deliverables**:
- shared/trophies.json
- Java Trophy entity, repository, DTO, service, DataInitializer

---

### Day 2 Target: Complete Phase 2 + Phase 3 (6 SP)
**Goal**: Finish Java backend and complete Go backend  
**Tasks**: T-TROPHY-2.4, T-TROPHY-3.1, T-TROPHY-3.2, T-TROPHY-3.3, T-TROPHY-3.4

- [ ] Morning: Execute Phase 2 Task 2.4 with @java_backend_agent (1 SP)
- [ ] Afternoon: Execute Phase 3 with @go_backend_agent (5 SP)

**Deliverables**:
- Java trophy endpoint at /api/trophies
- Go Trophy model, repo, service, handler, seeding
- Go trophy endpoint at /api/trophies

---

### Day 3 Target: Phase 4 + Phase 5 (6 SP)
**Goal**: Frontend integration and testing  
**Tasks**: T-TROPHY-4.1, T-TROPHY-4.2, T-TROPHY-5.1, T-TROPHY-5.2, T-TROPHY-5.3

- [ ] Morning: Execute Phase 4 with @frontend_agent (3 SP)
- [ ] Afternoon: Execute Phase 5 with @api_contract_agent and @testing_agent (3 SP)

**Deliverables**:
- Frontend TrophyResponse type and getTrophies()
- Updated Trophies.tsx component
- API contract validation
- Backend unit tests
- Integration tests

---

### Day 4 Target: Phase 6 + Buffer (2 SP + buffer)
**Goal**: Documentation, deployment verification, polish  
**Tasks**: T-TROPHY-6.1, T-TROPHY-6.2, bug fixes

- [ ] Morning: Documentation updates (1 SP)
- [ ] Afternoon: Docker Compose testing + bug fixes (1 SP + buffer)

**Deliverables**:
- Updated documentation
- Verified Docker Compose deployment
- All acceptance criteria met

---

## 🎯 Sprint Burndown

| Day | Completed SP | Remaining SP | Cumulative SP | Notes |
|-----|--------------|--------------|---------------|-------|
| Start | 0 | 20 | 0 | Sprint kickoff |
| Day 1 | 0 | 20 | 0 | Target: 6 SP |
| Day 2 | 0 | 20 | 0 | Target: 12 SP total |
| Day 3 | 0 | 20 | 0 | Target: 18 SP total |
| Day 4 | 0 | 20 | 0 | Target: 20 SP total (DONE) |

**Velocity Trend**: TBD after sprint completion

---

## 🚧 Blockers & Risks

### Active Blockers
None currently

### Identified Risks

| Risk ID | Description | Impact | Probability | Mitigation | Owner |
|---------|-------------|--------|-------------|------------|-------|
| R-TROPHY-1 | Icon mapping fails (Lucide component names mismatch) | Medium | Low | Validate icon names in shared/trophies.json against Lucide exports | @frontend_agent |
| R-TROPHY-2 | Database migration issues in production PostgreSQL | High | Medium | Use Hibernate ddl-auto=validate with manual schema or Flyway | @java_backend_agent |
| R-TROPHY-3 | Go/Java JSON serialization differences | Medium | Low | API contract tests catch discrepancies early | @api_contract_agent |
| R-TROPHY-4 | Docker image size increase from embedded JSON | Low | Low | Shared JSON is <10KB, negligible impact | @docker_agent |

---

## 🔄 Sprint Retrospective (Post-Sprint)

### What Went Well
- TBD after sprint

### What Could Be Improved
- TBD after sprint

### Action Items
- TBD after sprint

---

## 📚 Reference Documents

- **Detailed Roadmap**: `docs/TROPHIES_FEATURE_ROADMAP.md` (CORE Framework prompts for each task)
- **Architecture Decision**: Tree of Thought analysis in roadmap (Data Seed vs SQLite vs Local Files)
- **API Contract**: `frontend/src/app/api/types.ts`, `frontend/src/app/api/scoreService.ts`
- **Existing Patterns**: `shared/seed-data.json`, `GameScore` entity/service
- **Go Backend Rules**: `.github/copilot-instructions.md` (Section 4)
- **Seed Data Example**: `docs/vscode-workshop/03-advanced-web-dev.md` (lines 289-417)

---

## ✅ Definition of Done

### Code Complete Checklist
- [ ] All 16 tasks marked as ✅ Complete
- [ ] shared/trophies.json created and validated
- [ ] Java backend: Trophy entity, repo, service, controller, DataInitializer
- [ ] Go backend: Trophy model, repo, service, handler, seeding
- [ ] Frontend: TrophyResponse type, getTrophies(), updated Trophies.tsx
- [ ] API contract validated (Java and Go return identical data)
- [ ] Tests passing: Java (JUnit), Go (go test), Integration (.http files)
- [ ] Documentation updated: READMEs, API specs

### Quality Checklist
- [ ] No compilation errors (Java: ./gradlew build, Go: go build, Frontend: npm run build)
- [ ] No TypeScript errors in frontend
- [ ] No console errors in browser
- [ ] Loading and error states work in frontend
- [ ] Trophies seed automatically on first startup
- [ ] Seeding skipped on subsequent startups
- [ ] Icons render correctly with dynamic mapping

### Deployment Checklist
- [ ] Works in development (localhost)
- [ ] Works in Docker Compose
- [ ] shared/trophies.json bundled in Docker images
- [ ] Container logs show successful seeding
- [ ] Frontend displays trophies from containerized backend
- [ ] No regressions to existing score endpoints

### Acceptance Checklist
- [ ] All User Story acceptance criteria met
- [ ] Product Owner approval (if applicable)
- [ ] Zero hardcoded trophies in frontend
- [ ] 10 trophies displayed dynamically from backend
- [ ] Visual appearance unchanged from original

---

**Sprint Created**: 2026-02-11  
**Status**: 🔵 Ready to Start  
**Next Action**: Execute Phase 1 Task 1.1 with `@seed_data_agent`

---

## 🚀 Quick Start Command

```bash
# Copy CORE Framework prompt from docs/TROPHIES_FEATURE_ROADMAP.md Phase 1 Task 1.1
# Paste to Copilot Chat with:
# "@seed_data_agent [CORE Framework Prompt]"
```

