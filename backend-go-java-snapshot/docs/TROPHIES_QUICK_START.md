# Trophies Feature - Developer Quick Start Guide

> **Quick execution guide for implementing the Trophies feature using CORE Framework prompts with GitHub Copilot agents**

---

## 📋 Prerequisites

1. ✅ Read: `docs/TROPHIES_FEATURE_ROADMAP.md` (full technical details)
2. ✅ Read: `docs/SPRINT_BACKLOG_TROPHIES.md` (sprint tracking)
3. ✅ Ensure you have access to GitHub Copilot Chat
4. ✅ Backends running: Java (port 8080), Go (port 8081)
5. ✅ Frontend development server available (port 5173)

---

## 🎯 Execution Flow

### Overview: 6 Phases, 16 Tasks, 20 Story Points

```
Phase 1 (2 SP) → Phase 2 (5 SP) → Phase 4 (3 SP) → Phase 5 (3 SP) → Phase 6 (2 SP)
                     ↓
                 Phase 3 (5 SP) ↗
```

**Critical Path**: Phase 1 → Phase 2 → Phase 4 → Phase 5 → Phase 6  
**Parallel Option**: Phase 3 can run concurrently with Phase 2

---

## 🚀 Step-by-Step Execution

### **Phase 1: Shared Data Schema** (30 minutes, 2 SP)

**Agent**: `@seed_data_agent`

#### Task 1.1: Create shared/trophies.json

<details>
<summary><b>Click to copy CORE Framework Prompt</b></summary>

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

**Execution Steps**:
1. Open GitHub Copilot Chat
2. Type: `@seed_data_agent` + paste CORE prompt above
3. Wait for agent to create `shared/trophies.json`
4. Verify file exists and has 10 trophies
5. Mark task as ✅ in `docs/SPRINT_BACKLOG_TROPHIES.md`

**Deliverables**: ✅ `shared/trophies.json`

---

### **Phase 2: Java Backend (PRIMARY)** (2 hours, 5 SP)

**Agent**: `@java_backend_agent`

#### Task 2.1: Trophy Entity & Repository

<details>
<summary><b>Click to copy CORE Framework Prompt</b></summary>

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

**Execution**: `@java_backend_agent` + paste CORE prompt  
**Deliverables**: ✅ `entity/Trophy.java`, ✅ `repository/TrophyRepository.java`

---

#### Task 2.2: Trophy DTO & Service

<details>
<summary><b>Click to copy CORE Framework Prompt</b></summary>

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

**Execution**: `@java_backend_agent` + paste CORE prompt  
**Deliverables**: ✅ `dto/TrophyResponse.java`, ✅ `service/TrophyService.java`

---

#### Task 2.3: Trophy Data Initializer

<details>
<summary><b>Click to copy CORE Framework Prompt</b></summary>

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

**Execution**: `@java_backend_agent` + paste CORE prompt  
**Deliverables**: ✅ `config/TrophyDataInitializer.java`, ✅ `resources/trophies.json`

---

#### Task 2.4: Trophy REST Controller

<details>
<summary><b>Click to copy CORE Framework Prompt</b></summary>

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

**Execution**: `@java_backend_agent` + paste CORE prompt  
**Test**: `curl http://localhost:8080/api/trophies | jq`  
**Deliverables**: ✅ Trophy endpoint in controller

---

### **Phase 3: Go Backend (Mirror)** (2 hours, 5 SP)

**Agent**: `@go_backend_agent`  
**Note**: Can run parallel to Phase 2

#### Tasks 3.1-3.4 Combined Prompt

<details>
<summary><b>Click to copy CORE Framework Prompt (All Go Tasks)</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/go-backend
- Go version: Per go.mod
- ORM: GORM (already in use)
- Database: SQLite (highscores.db)
- Reference: models/game_score.go, handlers/score_handler.go, main.go

OBJECTIVE:
Implement complete Trophy support in Go backend mirroring Java implementation: model, repository, service, handler, seeding, and HTTP endpoint.

RESOURCES:
- Schema: shared/trophies.json
- Reference model: models/game_score.go
- Reference handler: handlers/score_handler.go
- Reference seeding: models/db.go (SeedData function)

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
       UnlockCriteria string `gorm:"type:text" json:"unlockCriteria,omitempty"`
     }
   - Add TableName() method: return "trophies"

2. Create: go-backend/repository/trophy_repository.go
   - Type: TrophyRepository struct with *gorm.DB
   - Constructor: NewTrophyRepository(db *gorm.DB) *TrophyRepository
   - Methods: GetAll(), Create(), CreateBatch()

3. Create: go-backend/service/trophy_service.go
   - Type: TrophyService struct with TrophyRepository
   - Constructor: NewTrophyService(repo *repository.TrophyRepository) *TrophyService
   - Method: GetAllTrophies() ([]models.Trophy, error)

4. Create: go-backend/handlers/trophy_handler.go
   - Type: TrophyHandler struct with *service.TrophyService
   - Constructor: NewTrophyHandler(service *service.TrophyService) *TrophyHandler
   - Method: GetAllTrophies(c *gin.Context)

5. Copy: shared/trophies.json → go-backend/trophies.json

6. Update: go-backend/models/db.go
   - Add Trophy to AutoMigrate: db.AutoMigrate(&GameScore{}, &Trophy{})
   - Add function: SeedTrophies(db *gorm.DB) error
     - Check if trophies exist, skip if yes
     - Read trophies.json, parse, batch insert

7. Update: go-backend/main.go
   - Call models.SeedTrophies(db) after SeedData
   - Initialize trophy components:
     trophyRepo := repository.NewTrophyRepository(db)
     trophyService := service.NewTrophyService(trophyRepo)
     trophyHandler := handlers.NewTrophyHandler(trophyService)
   - Add route: router.GET("/api/trophies", trophyHandler.GetAllTrophies)

8. Run: go mod tidy && go build && go run main.go
9. Test: curl http://localhost:8081/api/trophies
10. Verify: Returns 10 trophies as JSON array
```
</details>

**Execution**: `@go_backend_agent` + paste CORE prompt  
**Test**: `curl http://localhost:8081/api/trophies | jq`  
**Deliverables**: ✅ All Go backend components + endpoint

---

### **Phase 4: Frontend Integration** (1 hour, 3 SP)

**Agent**: `@frontend_agent`

#### Tasks 4.1-4.2 Combined Prompt

<details>
<summary><b>Click to copy CORE Framework Prompt (Frontend Tasks)</b></summary>

```
CONTEXT:
- Repository: high-scores-demo/frontend
- Framework: React 18 + TypeScript + Vite
- API service: src/app/api/scoreService.ts
- Types: src/app/api/types.ts
- Backend URL: VITE_API_URL (defaults to http://localhost:8080)
- Current component: src/app/components/Trophies.tsx (hardcoded trophies array)

OBJECTIVE:
Replace hardcoded trophies with dynamic data fetched from backend. Add loading and error states.

RESOURCES:
- Backend endpoint: GET /api/trophies
- Reference component: src/app/components/Leaderboard.tsx (shows loading/error pattern)
- Lucide React icons: Crown, Skull, Flame, Shield, Crosshair, Zap, Target, Award, Star, Trophy

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
     export async function getTrophies(): Promise<ApiResponse<TrophyResponse[]>> {
       return apiFetch<TrophyResponse[]>('/api/trophies');
     }

3. Update: src/app/components/Trophies.tsx
   - Add imports:
     import { useState, useEffect } from 'react';
     import { getTrophies } from '@/app/api/scoreService';
     import type { TrophyResponse } from '@/app/api/types';
   
   - Replace hardcoded array with state:
     const [trophies, setTrophies] = useState<TrophyResponse[]>([]);
     const [loading, setLoading] = useState(true);
     const [error, setError] = useState<string | null>(null);
   
   - Add useEffect to fetch:
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
   
   - Create icon mapping:
     const iconMap: Record<string, any> = {
       Crown, Skull, Flame, Shield, Crosshair, Zap, Target, Award, Star, Trophy
     };
   
   - Update render:
     {loading && <div className="text-white">Loading trophies...</div>}
     {error && <div className="text-red-500">Error: {error}</div>}
     {trophies.map((trophy) => {
       const Icon = iconMap[trophy.icon] || Trophy;
       // ... rest of rendering
     })}

4. Run: npm run build
5. Run: npm run dev
6. Test: Open http://localhost:5173, navigate to Trophies section
7. Verify: Network tab shows /api/trophies call, trophies display correctly
```
</details>

**Execution**: `@frontend_agent` + paste CORE prompt  
**Test**: Open browser DevTools Network tab, verify API call  
**Deliverables**: ✅ Updated types, service, and Trophies component

---

### **Phase 5: Testing & Validation** (1.5 hours, 3 SP)

**Agent**: `@api_contract_agent` + `@testing_agent`

#### Task 5.1: API Contract Validation

<details>
<summary><b>Click to copy CORE Framework Prompt</b></summary>

```
CONTEXT:
- Repository: high-scores-demo
- Endpoints: GET /api/trophies (Java :8080, Go :8081)
- Frontend: TrophyResponse type in types.ts

OBJECTIVE:
Validate that Java and Go backends return identical trophy data structure.

RESOURCES:
- Java backend: http://localhost:8080/api/trophies
- Go backend: http://localhost:8081/api/trophies
- Frontend type: src/app/api/types.ts (TrophyResponse)

EXECUTION:
1. Start both backends (if not running)

2. Test Java backend:
   curl http://localhost:8080/api/trophies | jq '.[0]'
   - Verify: Array of 10 trophies
   - Verify: Fields: id, icon, name, description, rarity, colorGradient, bgColor

3. Test Go backend:
   curl http://localhost:8081/api/trophies | jq '.[0]'
   - Verify: Same structure

4. Compare responses:
   diff <(curl -s http://localhost:8080/api/trophies | jq -S '.[0]') \
        <(curl -s http://localhost:8081/api/trophies | jq -S '.[0]')
   - Expected: No differences

5. Document findings in validation report
```
</details>

**Execution**: `@api_contract_agent` + paste CORE prompt  
**Deliverables**: ✅ Validation report

---

#### Tasks 5.2-5.3: Backend & Integration Tests

<details>
<summary><b>Click to copy CORE Framework Prompt</b></summary>

```
CONTEXT:
- Java tests: src/test/java/com/insight/ai_demo
- Go tests: go-backend/tests/
- HTTP tests: java-spring-boot-backend/*.http

OBJECTIVE:
Add tests for trophy endpoints in both backends and create integration tests.

RESOURCES:
- Java reference: existing test files
- Go reference: tests/handler_test.go
- HTTP reference: api-tests.http

EXECUTION (Java):
1. Create: src/test/java/.../controller/TrophyControllerTest.java
   - Test GET /api/trophies returns 200
   - Test response has 10 trophies
2. Create: src/test/java/.../service/TrophyServiceTest.java
   - Test getAllTrophies method
3. Run: ./gradlew test

EXECUTION (Go):
1. Create: tests/trophy_handler_test.go
   - Test GET /api/trophies handler
2. Create: tests/trophy_service_test.go
   - Test GetAllTrophies service
3. Run: go test ./tests/...

EXECUTION (Integration):
1. Create: java-spring-boot-backend/trophy-tests.http
   ### Get All Trophies
   GET http://localhost:8080/api/trophies
   Accept: application/json

2. Create: go-backend/trophy-tests.http
   ### Get All Trophies (Go)
   GET http://localhost:8081/api/trophies
   Accept: application/json

3. Update: test-api.py and test-api.sh to include trophy endpoint tests

4. Verify: All tests pass
```
</details>

**Execution**: `@testing_agent` + paste CORE prompt  
**Test**: Run all test suites  
**Deliverables**: ✅ All test files

---

### **Phase 6: Documentation & Deployment** (1 hour, 2 SP)

**Agent**: Manual or `@docker_agent`

#### Task 6.1-6.2: Documentation & Docker

<details>
<summary><b>Manual Execution Steps</b></summary>

**Documentation Updates**:
1. Update `java-spring-boot-backend/README.md`:
   - Add GET /api/trophies to API Endpoints section
   - Example:
     ```markdown
     #### Get All Trophies
     ```http
     GET /api/trophies
     ```
     Returns array of all available trophies/achievements.
     ```

2. Update main `README.md` (if has API section)

3. Create/update `docs/API_REFERENCE.md` with trophy endpoint

**Docker Verification**:
1. Ensure `shared/trophies.json` copied to Docker images:
   - Check `java-spring-boot-backend/Dockerfile`
   - Check `go-backend/Dockerfile`

2. Build images:
   ```bash
   ./build-images.sh
   # or
   python build-images.py
   ```

3. Start Docker Compose:
   ```bash
   docker-compose up -d
   ```

4. Test endpoints:
   ```bash
   curl http://localhost:8080/api/trophies | jq
   curl http://localhost:8081/api/trophies | jq
   curl http://localhost:3000  # Frontend
   ```

5. Check logs:
   ```bash
   docker-compose logs backend | grep -i trophy
   docker-compose logs go-backend | grep -i trophy
   ```

6. Verify frontend displays trophies

7. Stop containers:
   ```bash
   docker-compose down
   ```
</details>

**Deliverables**: ✅ Updated docs, ✅ Docker Compose verified

---

## ✅ Final Checklist

After completing all phases, verify:

### Code Complete
- [ ] ✅ All 16 tasks marked complete in `SPRINT_BACKLOG_TROPHIES.md`
- [ ] ✅ No compilation errors (Java, Go, Frontend)
- [ ] ✅ All tests passing

### Functionality
- [ ] ✅ Java backend: `curl http://localhost:8080/api/trophies` returns 10 trophies
- [ ] ✅ Go backend: `curl http://localhost:8081/api/trophies` returns 10 trophies
- [ ] ✅ Frontend: Trophies section displays dynamically from backend
- [ ] ✅ No hardcoded trophies in `Trophies.tsx`
- [ ] ✅ Loading/error states work

### Deployment
- [ ] ✅ Docker Compose works
- [ ] ✅ Trophies seed on first startup
- [ ] ✅ No regressions to score endpoints

### Documentation
- [ ] ✅ README files updated
- [ ] ✅ API documentation complete

---

## 🆘 Troubleshooting

### Issue: Agent doesn't respond
**Solution**: Simplify prompt, remove unnecessary context

### Issue: Compilation errors after agent changes
**Solution**: Check imports, re-run build, validate syntax

### Issue: Trophies not seeding
**Solution**: Check logs, verify `trophies.json` in resources, ensure table is empty

### Issue: Frontend can't fetch trophies
**Solution**: Verify backend running, check CORS, inspect Network tab

### Issue: Icons not rendering
**Solution**: Verify icon names match Lucide exports exactly (case-sensitive)

---

## 📞 Support

- **Full Details**: `docs/TROPHIES_FEATURE_ROADMAP.md`
- **Sprint Tracking**: `docs/SPRINT_BACKLOG_TROPHIES.md`
- **Architecture Rules**: `.github/copilot-instructions.md`

---

**Created**: 2026-02-11  
**Last Updated**: 2026-02-11  
**Status**: Ready for execution

