# Trophies Feature Implementation Roadmap

**Feature ID:** TROPHY-001  
**Status:** 🟡 In Planning  
**Start Date:** 2026-02-11  
**Target Completion:** TBD  
**Constraint:** Java backend is PRIMARY for trophies, Go backend mirrors implementation

---

## 📋 Executive Summary

Replace hardcoded trophies in frontend (`frontend/src/app/components/Trophies.tsx`) with full backend implementation using **Data Seed approach** (JSON → Database on startup). This follows the existing `shared/seed-data.json` pattern and maintains architectural consistency across Java and Go backends.

**Technology Decision:** Data Seed (Score: 9/10)  
**Rationale:** Best deployment simplicity, service parity, DX, and future extensibility for trophy-unlock features.

---

## 🎯 Success Criteria

- [ ] Trophies data moved from hardcoded frontend to `shared/trophies.json`
- [ ] Java backend (PRIMARY) serves trophies via `GET /api/trophies`
- [ ] Go backend mirrors Java implementation with same endpoint
- [ ] Frontend dynamically fetches and displays trophies from backend
- [ ] Both backends seed trophies from shared JSON on startup
- [ ] API contract documented and validated
- [ ] Zero breaking changes to existing score endpoints
- [ ] Tests added for new trophy endpoints

---

## 🌳 Architecture Decision Record (ADR)

### Options Evaluated (Tree of Thought - 2 Step Lookahead)

| Option | Deployment | Parity | DX | Production | Score | Notes |
|--------|------------|--------|-----|------------|-------|-------|
| **1. Data Seed** | ✅ High | ✅ Perfect | ✅ Excellent | ✅ Extensible | **9/10** | **SELECTED** |
| 2. SQLite Table | ⚠️ Medium | ❌ Poor | ⚠️ Moderate | ❌ Sync Issues | 4/10 | Rejected |
| 3. Local Files | ✅ High | ⚠️ Partial | ⚠️ Good | ❌ No Relations | 6/10 | Rejected |

### Decision: Data Seed (JSON → Database)
- Matches existing `shared/seed-data.json` pattern
- Enables future trophy-unlock tracking with relational data
- Single source of truth in version control
- Both backends use same seeding mechanism
- Production-ready with H2/PostgreSQL (Java) and SQLite (Go)

---

## 📐 Phase Breakdown

### **Phase 1: Shared Data Schema** ✅ CORE Framework Ready
**Agent:** `@seed_data_agent`  
**Story Points:** 2  
**Status:** 🔵 Ready to Start

<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo
- Current state: Trophies hardcoded in frontend/src/app/components/Trophies.tsx
- Existing pattern: shared/seed-data.json used for game scores seeding
- Frontend uses Lucide React icons: Crown, Skull, Flame, Shield, etc.

OBJECTIVE:
Create shared/trophies.json with canonical trophy data matching the schema below. This will be the single source of truth for both Java and Go backends.

RESOURCES:
- Reference: shared/seed-data.json (existing pattern)
- Current hardcoded data: frontend/src/app/components/Trophies.tsx (lines 3-73)
- Icon names: Crown, Skull, Flame, Shield, Crosshair, Zap, Target, Award, Star, Trophy

EXECUTION:
1. Create file: shared/trophies.json
2. Schema structure:
   {
     "version": "1.0.0",
     "lastUpdated": "2026-02-11",
     "description": "Canonical trophy/achievement data",
     "trophies": [
       {
         "id": 1,
         "icon": "Crown",
         "name": "Champion",
         "description": "Win 100 matches",
         "rarity": "Legendary",
         "colorGradient": "from-yellow-400 to-orange-500",
         "bgColor": "bg-yellow-900/20",
         "unlockCriteria": {
           "type": "wins",
           "threshold": 100
         }
       }
     ]
   }
3. Migrate all 10 trophies from Trophies.tsx
4. Run: python shared/validate-seed-data.py (adapt for trophies.json)
5. Validate JSON syntax and schema completeness
```
</details>

**Deliverables:**
- `shared/trophies.json` with 10 trophies
- Schema validation script (optional: extend `shared/validate-seed-data.py`)

**Acceptance Criteria:**
- [ ] JSON is valid and well-formed
- [ ] All 10 trophies from frontend migrated
- [ ] Icon names match Lucide React component names
- [ ] `unlockCriteria` field present (unused for now, future-proofing)

---

### **Phase 2: Java Backend (PRIMARY)** ✅ CORE Framework Ready
**Agent:** `@java_backend_agent`  
**Story Points:** 5  
**Status:** 🔵 Ready to Start  
**Dependencies:** Phase 1 complete

#### **Task 2.1: Trophy Entity & Repository**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/java-spring-boot-backend
- Package: com.insight.ai_demo
- Database: H2 (dev), PostgreSQL (prod)
- Reference entity: src/main/java/com/insight/ai_demo/entity/GameScore.java
- Reference repo: src/main/java/com/insight/ai_demo/repository/GameScoreRepository.java

OBJECTIVE:
Create Trophy JPA entity and Spring Data repository following existing GameScore pattern. Trophy is a read-only entity seeded on startup.

RESOURCES:
- Schema: shared/trophies.json
- Pattern reference: entity/GameScore.java (uses @Entity, @Table, @Id, @Column)
- Lombok annotations: @Data, @NoArgsConstructor, @AllArgsConstructor

EXECUTION:
1. Create: src/main/java/com/insight/ai_demo/entity/Trophy.java
   - @Entity, @Table(name = "trophies")
   - Fields: id (Long), icon (String), name (String), description (String), 
     rarity (String), colorGradient (String), bgColor (String), unlockCriteria (String, JSON text)
   - @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
   - Use @Column(nullable = false) for required fields
   - Add @Column(columnDefinition = "TEXT") for unlockCriteria JSON

2. Create: src/main/java/com/insight/ai_demo/repository/TrophyRepository.java
   - Extend JpaRepository<Trophy, Long>
   - Add method: List<Trophy> findAllByOrderByIdAsc();
   - Add method: Optional<Trophy> findByName(String name);

3. Run: ./gradlew build
4. Verify: No compilation errors
```
</details>

**Deliverables:**
- `entity/Trophy.java`
- `repository/TrophyRepository.java`

**Acceptance Criteria:**
- [ ] Entity follows JPA best practices
- [ ] Repository compiles without errors
- [ ] Schema matches `shared/trophies.json` structure

---

#### **Task 2.2: Trophy DTO & Service**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/java-spring-boot-backend
- Existing pattern: dto/ScoreResponse.java and service/GameScoreService.java
- Trophy entity created in Task 2.1
- Data source: shared/trophies.json seeded on startup

OBJECTIVE:
Create TrophyResponse DTO and TrophyService to handle trophy business logic and API serialization.

RESOURCES:
- Reference DTO: src/main/java/com/insight/ai_demo/dto/ScoreResponse.java
- Reference Service: src/main/java/com/insight/ai_demo/service/GameScoreService.java
- Repository: TrophyRepository (from Task 2.1)

EXECUTION:
1. Create: src/main/java/com/insight/ai_demo/dto/TrophyResponse.java
   - Fields: id, icon, name, description, rarity, colorGradient, bgColor
   - Constructor from Trophy entity
   - Use @JsonProperty for camelCase serialization if needed
   - Omit unlockCriteria (internal use only)

2. Create: src/main/java/com/insight/ai_demo/service/TrophyService.java
   - @Service, @RequiredArgsConstructor
   - Inject TrophyRepository
   - Method: List<TrophyResponse> getAllTrophies()
     - Returns all trophies ordered by ID
     - Maps entities to DTOs

3. Add logging with @Slf4j
4. Run: ./gradlew build
```
</details>

**Deliverables:**
- `dto/TrophyResponse.java`
- `service/TrophyService.java`

**Acceptance Criteria:**
- [ ] DTO serializes correctly to JSON
- [ ] Service follows existing pattern (GameScoreService)
- [ ] Builds without errors

---

#### **Task 2.3: Trophy Data Initializer**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/java-spring-boot-backend
- Data source: shared/trophies.json (created in Phase 1)
- Spring Boot startup hooks: @Component with @PostConstruct or ApplicationRunner
- Target database: H2 (dev), PostgreSQL (prod)

OBJECTIVE:
Create DataInitializer component to seed trophies from shared/trophies.json into database on application startup (only if table is empty).

RESOURCES:
- File location: Copy shared/trophies.json to src/main/resources/trophies.json
- JSON parsing: Jackson ObjectMapper (already in classpath)
- Reference: docs/vscode-workshop/03-advanced-web-dev.md (lines 289-417 show DataInitializer pattern)
- Spring Boot: Use @Component + ApplicationRunner or @EventListener(ApplicationReadyEvent)

EXECUTION:
1. Copy: shared/trophies.json → src/main/resources/trophies.json

2. Create: src/main/java/com/insight/ai_demo/config/TrophyDataInitializer.java
   - @Component, @Slf4j, @RequiredArgsConstructor
   - Inject TrophyRepository, ObjectMapper
   - Implement ApplicationRunner interface
   
3. In run() method:
   - Check if trophies table is empty: if (repository.count() > 0) { log.info("Trophies already seeded"); return; }
   - Read trophies.json from classpath: InputStream is = getClass().getResourceAsStream("/trophies.json")
   - Parse JSON: Map structure to Trophy entities
   - Save all: repository.saveAll(trophies)
   - Log success: "Seeded {} trophies from trophies.json"

4. Handle errors gracefully (log warning, don't crash app)
5. Run: ./gradlew bootRun
6. Verify: Check H2 console (http://localhost:8080/h2-console) - trophies table populated
```
</details>

**Deliverables:**
- `config/TrophyDataInitializer.java`
- `src/main/resources/trophies.json` (copy of shared/trophies.json)

**Acceptance Criteria:**
- [ ] Trophies seeded on first startup
- [ ] Skips seeding if table already has data
- [ ] Logs informative messages
- [ ] No startup errors

---

#### **Task 2.4: Trophy REST Controller**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/java-spring-boot-backend
- Existing controller: src/main/java/com/insight/ai_demo/controller/GameScoreController.java
- API base path: /api (consistent with scores)
- Service: TrophyService (from Task 2.2)

OBJECTIVE:
Add trophy endpoints to GameScoreController or create TrophyController. Endpoint must be GET /api/trophies returning all trophies as JSON array.

RESOURCES:
- Reference: controller/GameScoreController.java (lines 154-162 show simple GET pattern)
- Service: TrophyService.getAllTrophies()
- DTO: TrophyResponse

EXECUTION:
Option A (Recommended): Add to GameScoreController
1. Open: src/main/java/com/insight/ai_demo/controller/GameScoreController.java
2. Inject TrophyService via constructor (add to @RequiredArgsConstructor fields)
3. Add method:
   /**
    * Get all available trophies/achievements
    */
   @GetMapping("/trophies")
   public ResponseEntity<List<TrophyResponse>> getAllTrophies() {
       log.info("Getting all trophies");
       List<TrophyResponse> trophies = trophyService.getAllTrophies();
       return ResponseEntity.ok(trophies);
   }

Option B: Create separate TrophyController (if controller gets too large)
- Same pattern as GameScoreController
- @RestController, @RequestMapping("/api/trophies")
- Single GET endpoint at root path "/"

4. Run: ./gradlew bootRun
5. Test: curl http://localhost:8080/api/trophies
6. Verify: Returns 10 trophies as JSON array
```
</details>

**Deliverables:**
- Trophy endpoint in `controller/GameScoreController.java` or new `controller/TrophyController.java`

**Acceptance Criteria:**
- [ ] GET /api/trophies returns 200 OK
- [ ] Response is JSON array of 10 trophies
- [ ] Fields match TrophyResponse DTO
- [ ] Endpoint logged in application logs

---

### **Phase 3: Go Backend (Mirror Implementation)** ✅ CORE Framework Ready
**Agent:** `@go_backend_agent`  
**Story Points:** 5  
**Status:** 🔵 Ready to Start  
**Dependencies:** Phase 1 complete (can run parallel to Phase 2)

#### **Task 3.1: Trophy Model & Repository**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/go-backend
- Go version: Per go.mod
- ORM: GORM (already in use)
- Reference: models/game_score.go, repository/game_score_repository.go
- Database: SQLite (highscores.db)

OBJECTIVE:
Create Trophy GORM model and repository following Go backend clean architecture structure.

RESOURCES:
- Schema: shared/trophies.json
- Reference model: models/game_score.go
- Reference repo: repository/game_score_repository.go
- GORM docs: gorm.io (for JSON field type)

EXECUTION:
1. Create: go-backend/models/trophy.go
   - Package: models
   - Struct: Trophy with GORM tags
     type Trophy struct {
       ID             uint   `gorm:"primaryKey" json:"id"`
       Icon           string `gorm:"not null" json:"icon"`
       Name           string `gorm:"not null;unique" json:"name"`
       Description    string `gorm:"not null" json:"description"`
       Rarity         string `gorm:"not null" json:"rarity"`
       ColorGradient  string `gorm:"not null" json:"colorGradient"`
       BgColor        string `gorm:"not null" json:"bgColor"`
       UnlockCriteria string `gorm:"type:text" json:"unlockCriteria,omitempty"` // JSON stored as text
     }
   - Add TableName() method: return "trophies"
   - Add ToResponse() method if needed

2. Create: go-backend/repository/trophy_repository.go
   - Package: repository
   - Type: TrophyRepository struct with *gorm.DB
   - Constructor: NewTrophyRepository(db *gorm.DB) *TrophyRepository
   - Methods:
     - GetAll() ([]models.Trophy, error)
     - Create(trophy *models.Trophy) error
     - CreateBatch(trophies []models.Trophy) error

3. Update: go-backend/models/db.go
   - Add Trophy to AutoMigrate: db.AutoMigrate(&GameScore{}, &Trophy{})

4. Run: go mod tidy
5. Run: go build
```
</details>

**Deliverables:**
- `models/trophy.go`
- `repository/trophy_repository.go`
- Updated `models/db.go`

**Acceptance Criteria:**
- [ ] Compiles without errors
- [ ] GORM tags match schema
- [ ] AutoMigrate creates trophies table on startup

---

#### **Task 3.2: Trophy Service**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/go-backend
- Structure: internal/service or service/ (use existing structure)
- Reference: service/game_score_service.go
- Repository: TrophyRepository (from Task 3.1)

OBJECTIVE:
Create TrophyService to handle trophy business logic.

RESOURCES:
- Reference: service/game_score_service.go
- Repository: repository/trophy_repository.go

EXECUTION:
1. Create: go-backend/service/trophy_service.go
   - Package: service
   - Type: TrophyService struct with TrophyRepository
   - Constructor: NewTrophyService(repo *repository.TrophyRepository) *TrophyService
   - Method: GetAllTrophies() ([]models.Trophy, error)
     - Calls repo.GetAll()
     - Returns trophies ordered by ID

2. Add error handling and logging if applicable
3. Run: go build
```
</details>

**Deliverables:**
- `service/trophy_service.go`

**Acceptance Criteria:**
- [ ] Service follows existing pattern
- [ ] Compiles without errors
- [ ] Error handling present

---

#### **Task 3.3: Trophy Data Seeding**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/go-backend
- Data source: shared/trophies.json
- Existing seeding: models/db.go has SeedData function
- Database: SQLite (highscores.db)

OBJECTIVE:
Add trophy seeding to Go backend, reading from shared/trophies.json (or embed it in binary).

RESOURCES:
- Reference: models/db.go (SeedData function)
- JSON parsing: encoding/json (standard library)
- File: shared/trophies.json or embed in go-backend/trophies.json

EXECUTION:
1. Copy: shared/trophies.json → go-backend/trophies.json

2. Update: go-backend/models/db.go or create models/seed_trophies.go
   - Add function: SeedTrophies(db *gorm.DB) error
   - Check if trophies exist: var count int64; db.Model(&Trophy{}).Count(&count); if count > 0 { return nil }
   - Read trophies.json: data, err := os.ReadFile("trophies.json")
   - Parse JSON: var seedData struct { Trophies []Trophy `json:"trophies"` }; json.Unmarshal(data, &seedData)
   - Batch insert: repo := repository.NewTrophyRepository(db); repo.CreateBatch(seedData.Trophies)
   - Log success

3. Call SeedTrophies in main.go after SeedData:
   - models.SeedTrophies(db)

4. Run: go run main.go
5. Verify: SQLite browser - check trophies table populated
```
</details>

**Deliverables:**
- Trophy seeding function in `models/db.go` or `models/seed_trophies.go`
- Updated `main.go` to call seeding
- `go-backend/trophies.json` (copy of shared data)

**Acceptance Criteria:**
- [ ] Trophies seeded on first run
- [ ] Skips if table already populated
- [ ] No runtime errors

---

#### **Task 3.4: Trophy HTTP Handler**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/go-backend
- Framework: Gin (github.com/gin-gonic/gin)
- Reference: handlers/score_handler.go
- Service: TrophyService (from Task 3.2)

OBJECTIVE:
Create trophy HTTP handler with GET /api/trophies endpoint matching Java backend.

RESOURCES:
- Reference: handlers/score_handler.go (GetAllGames method shows simple GET)
- Service: service/trophy_service.go
- Gin docs: gin-gonic.com

EXECUTION:
1. Create: go-backend/handlers/trophy_handler.go
   - Package: handlers
   - Type: TrophyHandler struct with *service.TrophyService
   - Constructor: NewTrophyHandler(service *service.TrophyService) *TrophyHandler
   - Method: GetAllTrophies(c *gin.Context)
     - Call: trophies, err := h.service.GetAllTrophies()
     - Error handling: c.JSON(500, gin.H{"error": "..."})
     - Success: c.JSON(200, trophies)

2. Update: go-backend/main.go
   - Initialize: trophyRepo := repository.NewTrophyRepository(db)
   - Initialize: trophyService := service.NewTrophyService(trophyRepo)
   - Initialize: trophyHandler := handlers.NewTrophyHandler(trophyService)
   - Add route: router.GET("/api/trophies", trophyHandler.GetAllTrophies)

3. Run: go run main.go
4. Test: curl http://localhost:8081/api/trophies
5. Verify: Returns 10 trophies as JSON array
```
</details>

**Deliverables:**
- `handlers/trophy_handler.go`
- Updated `main.go` with trophy routes

**Acceptance Criteria:**
- [ ] GET /api/trophies returns 200 OK
- [ ] Response matches Java backend structure
- [ ] Endpoint accessible on port 8081

---

### **Phase 4: Frontend Integration** ✅ CORE Framework Ready
**Agent:** `@frontend_agent`  
**Story Points:** 3  
**Status:** 🔵 Ready to Start  
**Dependencies:** Phase 2 OR Phase 3 complete (needs at least one backend)

#### **Task 4.1: API Types & Service**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/frontend
- Framework: React 18 + TypeScript + Vite
- API service: src/app/api/scoreService.ts
- Types: src/app/api/types.ts
- Backend URL: VITE_API_URL (defaults to http://localhost:8080)

OBJECTIVE:
Add Trophy types and API service function to fetch trophies from backend.

RESOURCES:
- Reference types: src/app/api/types.ts (ScoreResponse interface)
- Reference service: src/app/api/scoreService.ts (getGames function)
- Backend endpoint: GET /api/trophies

EXECUTION:
1. Update: src/app/api/types.ts
   - Add interface:
     export interface TrophyResponse {
       id: number;
       icon: string;
       name: string;
       description: string;
       rarity: string;
       colorGradient: string;
       bgColor: string;
     }

2. Update: src/app/api/scoreService.ts
   - Add function:
     /**
      * Get all available trophies/achievements
      */
     export async function getTrophies(): Promise<ApiResponse<TrophyResponse[]>> {
       return apiFetch<TrophyResponse[]>('/api/trophies');
     }

3. Run: npm run build (or tsc --noEmit for type checking)
4. Verify: No TypeScript errors
```
</details>

**Deliverables:**
- Updated `src/app/api/types.ts` with `TrophyResponse`
- Updated `src/app/api/scoreService.ts` with `getTrophies()`

**Acceptance Criteria:**
- [ ] TypeScript compiles without errors
- [ ] Interface matches backend DTO
- [ ] API function follows existing patterns

---

#### **Task 4.2: Update Trophies Component**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/frontend
- Component: src/app/components/Trophies.tsx (currently hardcoded)
- React: useState, useEffect hooks needed
- Icons: Lucide React (already imported)
- API: getTrophies() from Task 4.1

OBJECTIVE:
Replace hardcoded trophies array with dynamic data fetched from backend. Add loading and error states.

RESOURCES:
- Current file: src/app/components/Trophies.tsx (lines 1-119)
- Reference: src/app/components/Leaderboard.tsx (shows loading/error pattern)
- API: getTrophies() from scoreService
- Type: TrophyResponse

EXECUTION:
1. Update: src/app/components/Trophies.tsx

2. Add imports:
   import { useState, useEffect } from 'react';
   import { getTrophies } from '@/app/api/scoreService';
   import type { TrophyResponse } from '@/app/api/types';

3. Replace hardcoded trophies array with state:
   - const [trophies, setTrophies] = useState<TrophyResponse[]>([]);
   - const [loading, setLoading] = useState(true);
   - const [error, setError] = useState<string | null>(null);

4. Add useEffect to fetch data:
   useEffect(() => {
     async function loadTrophies() {
       setLoading(true);
       const response = await getTrophies();
       if (response.error) {
         setError(response.error);
       } else {
         setTrophies(response.data || []);
       }
       setLoading(false);
     }
     loadTrophies();
   }, []);

5. Create icon mapping (Lucide components by name):
   const iconMap: Record<string, any> = {
     Crown, Skull, Flame, Shield, Crosshair, Zap, Target, Award, Star, Trophy
   };

6. Update render logic:
   - Add loading state: {loading && <div className="text-white">Loading trophies...</div>}
   - Add error state: {error && <div className="text-red-500">Error: {error}</div>}
   - Update map: const Icon = iconMap[trophy.icon] || Trophy;

7. Run: npm run dev
8. Test: Open http://localhost:5173 and navigate to Trophies section
9. Verify: Trophies load from backend (check Network tab for /api/trophies call)
```
</details>

**Deliverables:**
- Updated `src/app/components/Trophies.tsx` with dynamic data fetching

**Acceptance Criteria:**
- [ ] Trophies fetch from backend on component mount
- [ ] Loading state displayed during fetch
- [ ] Error handling for failed requests
- [ ] Icons render correctly via dynamic mapping
- [ ] Visual appearance unchanged from hardcoded version

---

### **Phase 5: API Contract & Testing** ✅ CORE Framework Ready
**Agent:** `@api_contract_agent` + `@testing_agent`  
**Story Points:** 3  
**Status:** 🔵 Ready to Start  
**Dependencies:** Phase 2, 3, 4 complete

#### **Task 5.1: API Contract Validation**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo
- API Contract Agent: Validates consistency between frontend and backends
- Endpoints: GET /api/trophies (Java on :8080, Go on :8081)
- Frontend: TrophyResponse type in types.ts

OBJECTIVE:
Validate that Java and Go backends return identical trophy data structure and that frontend type matches backend response.

RESOURCES:
- Java backend: http://localhost:8080/api/trophies
- Go backend: http://localhost:8081/api/trophies
- Frontend type: src/app/api/types.ts (TrophyResponse)
- Reference: docs/API_CONTRACT_UPDATES_2026-02-04.md

EXECUTION:
1. Start both backends:
   - Terminal 1: cd java-spring-boot-backend && ./gradlew bootRun
   - Terminal 2: cd go-backend && go run main.go

2. Test Java backend:
   curl http://localhost:8080/api/trophies | jq '.[0]'
   - Verify: Returns array of 10 trophies
   - Verify: First trophy has fields: id, icon, name, description, rarity, colorGradient, bgColor

3. Test Go backend:
   curl http://localhost:8081/api/trophies | jq '.[0]'
   - Verify: Same structure as Java backend
   - Verify: Same trophy count (10)

4. Compare responses:
   diff <(curl -s http://localhost:8080/api/trophies | jq -S '.[0]') \
        <(curl -s http://localhost:8081/api/trophies | jq -S '.[0]')
   - Expected: No differences (or only ordering differences if IDs match)

5. Create contract test file: tests/api-contract/trophies-contract.test.ts (optional)

6. Document endpoint in API_CONTRACT_UPDATES_2026-02-04.md or create TROPHIES_API_SPEC.md
```
</details>

**Deliverables:**
- API contract validation results
- Updated API documentation

**Acceptance Criteria:**
- [ ] Java and Go backends return identical trophy structure
- [ ] Both backends return 10 trophies
- [ ] Frontend TrophyResponse type matches backend response
- [ ] No breaking changes to existing score endpoints

---

#### **Task 5.2: Backend Tests**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Java tests: src/test/java/com/insight/ai_demo
- Go tests: go-backend/tests/
- Testing frameworks: JUnit 5 + MockMvc (Java), Go testing package (Go)

OBJECTIVE:
Add tests for trophy endpoints and services in both backends.

RESOURCES:
- Java reference: src/test/java/.../AiDemoApplicationTests.java
- Go reference: tests/handler_test.go, tests/service_test.go
- Test data: shared/trophies.json

EXECUTION (Java):
1. Create: src/test/java/com/insight/ai_demo/controller/TrophyControllerTest.java
   - Use @WebMvcTest or @SpringBootTest
   - Test GET /api/trophies returns 200
   - Test response contains 10 trophies
   - Test trophy structure (has required fields)

2. Create: src/test/java/com/insight/ai_demo/service/TrophyServiceTest.java
   - Mock TrophyRepository
   - Test getAllTrophies returns all trophies

3. Run: ./gradlew test

EXECUTION (Go):
1. Create: tests/trophy_handler_test.go
   - Use httptest package
   - Test GET /api/trophies handler
   - Verify status 200 and response structure

2. Create: tests/trophy_service_test.go
   - Mock repository or use in-memory DB
   - Test GetAllTrophies

3. Run: go test ./tests/...

4. Verify: All tests pass
```
</details>

**Deliverables:**
- Java: `TrophyControllerTest.java`, `TrophyServiceTest.java`
- Go: `trophy_handler_test.go`, `trophy_service_test.go`

**Acceptance Criteria:**
- [ ] All tests pass in both backends
- [ ] Tests cover happy path for GET /api/trophies
- [ ] Tests verify response structure
- [ ] No existing tests broken

---

#### **Task 5.3: Integration Tests**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo
- HTTP test files: java-spring-boot-backend/*.http
- Python test: java-spring-boot-backend/test-api.py
- Shell test: java-spring-boot-backend/test-api.sh

OBJECTIVE:
Add trophy endpoint to existing API test files for manual and automated testing.

RESOURCES:
- Reference: java-spring-boot-backend/api-tests.http
- Reference: java-spring-boot-backend/test-api.py

EXECUTION:
1. Create: java-spring-boot-backend/trophy-tests.http
   ### Get All Trophies
   GET http://localhost:8080/api/trophies
   Accept: application/json
   
   ### Expected: 200 OK with array of 10 trophies

2. Update: java-spring-boot-backend/test-api.py
   - Add test: test_endpoint("Get All Trophies", f"{BASE_URL}/api/trophies")
   - Verify: Response is array with length 10

3. Update: java-spring-boot-backend/test-api.sh
   - Add: test_endpoint "Get All Trophies" "$BASE_URL/api/trophies"

4. Create: go-backend/trophy-tests.http
   ### Get All Trophies (Go Backend)
   GET http://localhost:8081/api/trophies
   Accept: application/json

5. Run tests:
   - ./test-api.sh (in java-spring-boot-backend)
   - python test-api.py (in java-spring-boot-backend)
   - Manual: Open .http files in VS Code, click "Send Request"

6. Verify: All tests pass
```
</details>

**Deliverables:**
- `java-spring-boot-backend/trophy-tests.http`
- Updated `test-api.py` and `test-api.sh`
- `go-backend/trophy-tests.http`

**Acceptance Criteria:**
- [ ] HTTP test files work in VS Code REST Client
- [ ] Automated test scripts include trophy endpoint
- [ ] All tests pass successfully

---

### **Phase 6: Documentation & Deployment** ✅ CORE Framework Ready
**Agent:** Manual / `@planning_arch_agent`  
**Story Points:** 2  
**Status:** 🔵 Ready to Start  
**Dependencies:** All phases complete

#### **Task 6.1: Update Documentation**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo
- Documentation files: README.md, java-spring-boot-backend/README.md, docs/*.md
- New endpoint: GET /api/trophies

OBJECTIVE:
Update all relevant documentation to reflect new trophy endpoint.

RESOURCES:
- Main README: README.md
- Backend README: java-spring-boot-backend/README.md
- API docs: docs/API_CONTRACT_UPDATES_2026-02-04.md or similar

EXECUTION:
1. Update: java-spring-boot-backend/README.md
   - Add to API Endpoints section:
     #### Get All Trophies
     ```http
     GET /api/trophies
     ```
     Returns array of all available trophies/achievements.

2. Update: README.md (if it has API section)
   - Add trophy endpoint to feature list

3. Create or Update: docs/TROPHIES_API_SPEC.md (this roadmap file)
   - Document full trophy implementation
   - Include data model, endpoints, frontend integration

4. Update: QUICK_REFERENCE.md (if exists)
   - Add trophy endpoint to quick reference

5. Verify: All links in docs are valid
```
</details>

**Deliverables:**
- Updated documentation files
- Trophy API specification

**Acceptance Criteria:**
- [ ] All READMEs updated with trophy endpoint
- [ ] API specification documented
- [ ] No broken links in documentation

---

#### **Task 6.2: Docker & Deployment**
<details>
<summary><b>CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo
- Docker Compose: docker-compose.yml
- Build scripts: build-images.sh, build-images.py
- Deployment: Local (Docker Compose), Azure (Terraform)

OBJECTIVE:
Verify trophy feature works in containerized environment (Docker Compose) and update deployment scripts if needed.

RESOURCES:
- Docker Compose: docker-compose.yml
- Build script: build-images.sh
- Deploy script: deploy-local.sh

EXECUTION:
1. Ensure shared/trophies.json is copied to backend containers:
   - Check Dockerfile (java-spring-boot-backend/Dockerfile)
   - Verify src/main/resources/trophies.json is in image
   - Check go-backend/Dockerfile
   - Verify trophies.json is in image

2. Build images:
   ./build-images.sh (or python build-images.py)

3. Start containers:
   docker-compose up -d

4. Wait for health checks:
   docker-compose ps (verify all healthy)

5. Test endpoints:
   curl http://localhost:8080/api/trophies
   curl http://localhost:8081/api/trophies
   curl http://localhost:3000 (frontend - check trophies section)

6. Verify seeding:
   docker-compose logs backend | grep -i trophy
   docker-compose logs go-backend | grep -i trophy

7. Stop containers:
   docker-compose down

8. Document: Add to DEPLOYMENT.md if seeding requires special steps
```
</details>

**Deliverables:**
- Verified Docker Compose deployment
- Updated Dockerfiles if needed
- Deployment documentation

**Acceptance Criteria:**
- [ ] Trophies work in Docker Compose environment
- [ ] Both backends seed trophies on container startup
- [ ] Frontend displays trophies from containerized backend
- [ ] No deployment regressions

---

## 📊 Progress Tracking

### Overall Status
- **Phase 1:** 🔵 Ready to Start (0/1 tasks)
- **Phase 2:** 🔵 Ready to Start (0/4 tasks)
- **Phase 3:** 🔵 Ready to Start (0/4 tasks)
- **Phase 4:** 🔵 Ready to Start (0/2 tasks)
- **Phase 5:** 🔵 Ready to Start (0/3 tasks)
- **Phase 6:** 🔵 Ready to Start (0/2 tasks)

**Total:** 0/16 tasks complete (0%)

### Story Points
- **Estimated:** 20 SP
- **Completed:** 0 SP
- **Remaining:** 20 SP

---

## 🚀 Quick Start for Developers

### Run Entire Feature (Sequential)
```bash
# Phase 1: Create seed data
# Execute CORE prompt for Task 1.1 with @seed_data_agent

# Phase 2: Java backend
# Execute CORE prompts for Tasks 2.1-2.4 with @java_backend_agent

# Phase 3: Go backend
# Execute CORE prompts for Tasks 3.1-3.4 with @go_backend_agent

# Phase 4: Frontend
# Execute CORE prompts for Tasks 4.1-4.2 with @frontend_agent

# Phase 5: Testing
# Execute CORE prompts for Tasks 5.1-5.3 with @api_contract_agent and @testing_agent

# Phase 6: Documentation
# Execute CORE prompts for Tasks 6.1-6.2 manually or with @planning_arch_agent
```

### Run Specific Phase
```bash
# Example: Just implement Java backend
# Copy CORE prompts from Phase 2 tasks and execute with @java_backend_agent
```

---

## 🔧 Developer Commands

Each CORE Framework prompt can be copy-pasted directly to GitHub Copilot Chat with the appropriate agent mentioned.

**Example workflow:**
1. Developer says: "@seed_data_agent" + [paste CORE prompt from Task 1.1]
2. Agent executes and reports completion
3. Developer marks task as ✅ complete in this roadmap
4. Repeat for next task

---

## 📝 Notes & Decisions

### Icon Handling Decision
- **Problem:** Frontend uses Lucide React components, backend stores strings
- **Solution:** Store icon name as string ("Crown"), map to component in frontend via iconMap
- **Rationale:** Keeps backend agnostic, allows icon library changes without backend changes

### unlockCriteria Field
- **Status:** Added but unused
- **Purpose:** Future-proofing for trophy unlock tracking
- **Implementation:** Stored as JSON text in database, not exposed in API response
- **Future:** Will enable player-trophy associations and unlock logic

### Database Choice
- **Java:** Uses existing H2 (dev) / PostgreSQL (prod) setup
- **Go:** Uses existing SQLite (highscores.db)
- **Rationale:** No new dependencies, follows established patterns

### Seeding Strategy
- **Check Before Seed:** Both backends check if trophies table is empty
- **Idempotent:** Safe to restart application multiple times
- **Data Location:** shared/trophies.json is source of truth, copied to backend resources

---

## 🎯 Success Metrics

- [ ] Frontend no longer has hardcoded trophies
- [ ] Java backend serves 10 trophies via GET /api/trophies
- [ ] Go backend serves identical trophies via same endpoint
- [ ] Trophies seed automatically on first run
- [ ] Frontend displays trophies with no visual regression
- [ ] All tests pass (unit, integration, contract)
- [ ] Documentation updated
- [ ] Docker Compose deployment works
- [ ] Zero breaking changes to existing score endpoints

---

## 🐛 Known Issues / Risks

### Risks
1. **Icon mapping complexity:** If icon names don't match Lucide components exactly
   - **Mitigation:** Validate icon names in shared/trophies.json against Lucide exports

2. **Database migration in production:** PostgreSQL needs schema updates
   - **Mitigation:** Use Hibernate `ddl-auto=validate` with manual schema or Flyway migration

3. **Go/Java parity:** Slight differences in JSON serialization
   - **Mitigation:** API contract tests in Phase 5 catch discrepancies

### Open Questions
- Should trophies be cacheable on frontend? (Currently: No, fetched on mount)
- Should backend support filtering trophies by rarity? (Currently: No, return all)
- Should trophy order be configurable? (Currently: Ordered by ID)

---

## 📚 References

- **Architecture Decision:** Tree of Thought analysis in this document (Section: Architecture Decision Record)
- **Existing Patterns:** `shared/seed-data.json`, `GameScore` entity/repository/service
- **API Contract:** `frontend/src/app/api/types.ts`, `frontend/src/app/api/scoreService.ts`
- **Go Structure:** `.github/copilot-instructions.md` (Section 4: Go backend rules)
- **Seeding Example:** `docs/vscode-workshop/03-advanced-web-dev.md` (lines 289-417)

---

**Last Updated:** 2026-02-11  
**Status:** 🟡 In Planning  
**Next Step:** Execute Phase 1 Task 1.1 with @seed_data_agent

