# Tree of Thought (ToT) - Explanation and Examples

**Date**: February 10, 2026  
**Context**: High Scores Demo - Leaderboard Migration & Refactoring  
**Stack**: React + TypeScript (Frontend), Spring Boot + Java (Backend), Go + Gin (Backend)

---

## What is Tree of Thought?

Tree of Thought (ToT) is a prompting technique where you explore **multiple reasoning branches in parallel**, evaluate each branch, prune the weak ones, and converge on the best solution. Unlike Chain of Thought (which follows a single linear path), ToT builds a **branching decision tree** — testing several ideas simultaneously before committing.

**Think of it like a chess player** — you don't just calculate one move ahead. You consider several candidate moves, mentally play out each one a few turns deep, then pick the line that leads to the best position:

```
          [Current Position]
         /        |         \
     Move A    Move B     Move C
      /   \      |         /   \
   A1     A2    B1       C1    C2
   ✗      ✓     ✓        ✗     ✓
         Best → B1 (strongest after evaluation)
```

### CoT vs ToT at a Glance

| | Chain of Thought | Tree of Thought |
|---|---|---|
| **Structure** | Linear (Step 1 → 2 → 3) | Branching (explore → evaluate → prune) |
| **When to use** | Problem has one clear path | Problem has competing valid approaches |
| **Risk** | May lock into a suboptimal path early | More upfront work, but avoids dead ends |
| **Analogy** | Walking a trail | Scouting multiple trails, choosing the best |

---

## How to Use These Prompts

Each example below includes a **copy-paste prompt** in a blockquote. These are the exact words you'd type into GitHub Copilot Chat (or any LLM) to trigger Tree of Thought reasoning.

**Key patterns in the prompts:**
- **"Generate 3 candidate approaches"** — forces branching instead of a single answer
- **"Evaluate each against these criteria"** — forces structured comparison
- **"Consider what happens when we scale to..."** — forces lookahead
- **"Prune the weakest, explain why"** — forces elimination with rationale
- **"Deepen the winning branch"** — transitions from ToT into CoT for implementation

You can adapt these prompts to any task — just swap the task description and criteria.

---

## Examples Based on Leaderboard Migration Sprint

> **Sprint Goal** from `docs/SPRINT_BACKLOG_LEADERBOARD.md`: Remove hardcoded frontend data, implement canonical seed data in backends, extend data model with kills/wins. Total effort ~27 story points across 5 phases.

---

### **Example 1: Without Tree of Thought (Single Path)**

**Task T-3.1** — Create canonical seed data file at `shared/seed-data.json`

#### The Prompt (❌ no ToT)

> Create a seed-data.json file with player scores for the High Scores Demo leaderboard.

❌ **What you get back:**
> "Create a JSON file with an array of scores including player names and points."

**Problems:**
- Only considers one data structure — no alternatives evaluated
- Doesn't specify how many games, players, or what fields are needed
- Doesn't explore whether the file should include metadata (version, timestamps)
- No evaluation of how both Java and Go backends will consume the file
- Misses the opportunity to align with the existing `ScoreResponse` interface

---

### **Example 2: With Tree of Thought (Branching Evaluation)**

✅ **Better approach:**

**Task T-3.1** — Create canonical seed data structure for `shared/seed-data.json`

#### The Prompt (✅ ToT)

> I need to design the seed data structure for Task T-3.1 in the leaderboard migration.
> The acceptance criteria from `docs/SPRINT_BACKLOG_LEADERBOARD.md` are: 
> - Contains 20 scores with kills/wins
> - Both Java and Go backends can load it
> - Single source of truth for all environments
>
> **Use Tree of Thought reasoning:**
> 1. Generate 3 distinctly different JSON schema approaches (vary structure: flat array, nested by game, normalized with references)
> 2. Evaluate each against these criteria:
>    - Does it match the `ScoreResponse` interface in `frontend/src/app/api/types.ts`?
>    - Can both Java Jackson and Go json.Unmarshal parse it easily?
>    - Does it support adding new games without restructuring?
>    - How complex is the DataInitializer code to consume it?
> 3. Prune the weakest branch and explain why
> 4. If two branches are both strong, merge their best elements
> 5. Produce a final schema with example data matching existing player names from `go-backend/models/db.go`

#### **Step 1: Generate Candidate Branches**

The acceptance criteria say: *20 scores with kills/wins, loadable by both backends.* But "loadable" can be structured many ways. Let's explore three distinct approaches:

```
              [Design seed-data.json schema]
              /           |              \
        Branch A      Branch B        Branch C
      "Flat Array    "Nested by      "Normalized
       of Scores"     Game"           with Refs"
```

**Branch A — Flat Array of Scores**
- Root is `{ "scores": [...] }` 
- Each score object contains all fields including gameName
- Simple iteration in both backends

**Branch B — Nested by Game**
- Root is `{ "games": { "Operation Nightfall": { "scores": [...] } } }`
- Scores grouped under their game key
- Games are explicit in structure

**Branch C — Normalized with References**
- Separate `games` array and `scores` array
- Scores reference games by ID
- Most flexible but most complex to parse

#### **Step 2: Evaluate Each Branch**

| Criteria | Branch A (Flat) | Branch B (Nested) | Branch C (Normalized) |
|----------|-----------------|-------------------|----------------------|
| **Matches ScoreResponse?** | ✅ Direct mapping | ⚠️ Need to extract gameName from key | ⚠️ Need ID lookup |
| **Java Jackson parsing?** | ✅ Simple `List<ScoreData>` | ⚠️ Nested Map handling | ⚠️ Two-phase parsing |
| **Go json.Unmarshal?** | ✅ Simple `[]ScoreData` | ⚠️ `map[string]GameData` | ⚠️ Multiple structs |
| **Add new games?** | ✅ Just add entries | ✅ Add new key | ⚠️ Add to both arrays |
| **DataInitializer complexity** | ✅ Single loop | ⚠️ Nested loops | ❌ Complex joins |
| **Human readable?** | ✅ Clear structure | ⚠️ Repetitive game keys | ❌ ID references |
| **Matches existing Go seed data?** | ✅ Similar to db.go | ❌ Different structure | ❌ Different structure |

#### **Step 3: Prune and Decide**

```
              [Design seed-data.json schema]
              /           |              \
        Branch A      Branch B        Branch C
        ⭐ Best       ⚠️ Viable       ✗ Pruned
```

- **Branch C pruned** — over-engineered for our use case, complex parsing in both backends
- **Branch B is viable** but doesn't match existing Go seed pattern and complicates parsing
- **Branch A is best** — simple, matches existing patterns, easy for both backends

#### **Step 4: Enhance Branch A with Metadata**

Take the simplicity of A and add useful metadata:

```json
{
  "version": "1.0.0",
  "lastUpdated": "2026-02-03",
  "games": [
    { "name": "Operation Nightfall", "description": "Tactical stealth operations" },
    { "name": "Shadow Protocol", "description": "Covert missions" }
  ],
  "scores": [
    {
      "playerName": "GhostReaper",
      "gameName": "Operation Nightfall",
      "score": 145820,
      "kills": 2847,
      "wins": 156
    }
  ]
}
```

**Design Decisions:**
- `version` — allows future schema migrations
- `lastUpdated` — tracks when seed data was modified
- `games` array — optional metadata, backends can ignore if not needed
- `scores` array — main data, fields match `ScoreResponse` plus kills/wins

#### **Step 5: Verify Against Acceptance Criteria**
- [x] Contains 20 scores (with kills/wins fields)
- [x] Single source of truth (one JSON file)
- [x] Java can parse with Jackson ObjectMapper
- [x] Go can parse with json.Unmarshal
- [x] Player names match existing Go seed data (GhostReaper, ShadowSniper, etc.)

---

### **Example 3: Tree of Thought for Backend Database Choice (Task T-2.1)**

**Task**: Decide database persistence strategy for Java backend

#### The Prompt

> Task T-2.1 requires switching Java backend from H2 to persistent storage.
> Current state: H2 in-memory (data lost on restart)
> Go backend already uses: SQLite file-based
>
> **Use Tree of Thought reasoning:**
> 1. Generate 3 different database options: SQLite (match Go), PostgreSQL (production-grade), H2 file-mode (minimal change)
> 2. Evaluate each against: Docker deployment simplicity, parity with Go backend, developer experience, data persistence across restarts
> 3. **Lookahead**: What happens when we deploy to Azure? What about running both backends locally?
> 4. Prune branches that violate simplicity goals
> 5. For the winning branch, list the exact Gradle dependencies and application.properties changes

#### **Step 1: Generate Three Database Options**

```
           [Choose Java backend database]
           /              |                \
     Branch A        Branch B          Branch C
    "SQLite"       "PostgreSQL"      "H2 File Mode"
```

**Branch A — SQLite**
- Match Go backend exactly
- File-based, zero external dependencies
- Add `sqlite-jdbc` and Hibernate community dialect

**Branch B — PostgreSQL**
- Production-grade RDBMS
- Requires separate container in Docker Compose
- Full SQL features, better for complex queries

**Branch C — H2 File Mode**
- Minimal change from current H2 setup
- Just change connection URL from `:memory:` to file path
- Keep existing H2 dependency

#### **Step 2: Evaluate with Lookahead**

| Criteria | A (SQLite) | B (PostgreSQL) | C (H2 File) |
|----------|------------|----------------|-------------|
| **Docker simplicity?** | ✅ No extra container | ❌ Needs pg container | ✅ No extra container |
| **Parity with Go backend?** | ✅ Both use SQLite | ❌ Different databases | ❌ Different databases |
| **Developer experience?** | ✅ Works out of the box | ⚠️ Must start Postgres | ✅ Works out of the box |
| **Data persistence?** | ✅ File survives restart | ✅ Container volume | ✅ File survives restart |
| **Lookahead: Azure?** | ⚠️ May need Azure SQL | ✅ Azure has Postgres | ❌ H2 not recommended |
| **Lookahead: Both backends local?** | ✅ Same DB tech, easy debug | ⚠️ Go still SQLite | ⚠️ Inconsistent |
| **Implementation effort?** | ⚠️ New dialect config | ❌ Docker + config | ✅ One line change |
| **Shared seed data?** | ✅ Same SQL syntax | ⚠️ SQL differences | ⚠️ SQL differences |

#### **Step 3: Prune and Decide**

```
           [Choose Java backend database]
           /              |                \
     Branch A        Branch B          Branch C
     ⭐ Best         ✗ Pruned         ⚠️ Fallback
   (parity +       (overkill,        (minimal but
    simplicity)     complexity)       inconsistent)
```

- **Branch B pruned** — PostgreSQL adds unnecessary complexity for a demo app, breaks Docker simplicity
- **Branch C is fallback** — works but leaves Go and Java inconsistent
- **Branch A wins** — matches Go backend, simplifies debugging, same SQL syntax for both

#### **Step 4: Refine Branch A — Implementation Details**

**build.gradle changes:**
```gradle
dependencies {
    // Remove H2
    // implementation 'com.h2database:h2'
    
    // Add SQLite
    implementation 'org.xerial:sqlite-jdbc:3.45.1.0'
    implementation 'org.hibernate.orm:hibernate-community-dialects:6.4.4.Final'
}
```

**application.properties changes:**
```properties
# SQLite Configuration
spring.datasource.url=jdbc:sqlite:./data/highscores.db
spring.datasource.driver-class-name=org.sqlite.JDBC
spring.jpa.database-platform=org.hibernate.community.dialect.SQLiteDialect
spring.jpa.hibernate.ddl-auto=update
```

**docker-compose.yml volume mount:**
```yaml
backend:
  volumes:
    - ./java-spring-boot-backend/data:/app/data
```

#### **Step 5: Verify Against Acceptance Criteria**
- [x] Uses SQLite (jdbc:sqlite:./data/highscores.db)
- [x] H2 dependency removed
- [x] Docker volume persists database file
- [x] Matches Go backend database technology

---

### **Example 4: Tree of Thought for Frontend Fallback Strategy (Task T-4.1)**

**Task**: Decide how to handle the hardcoded `fallbackData` in `Leaderboard.tsx`

#### The Prompt

> Task T-4.1: Remove fallbackData from Leaderboard.tsx
> Current state from `docs/LEADERBOARD_REFACTORING.md`:
> - Lines 8-21 contain hardcoded fallback data with 10 entries
> - Used when API errors or returns empty
> - Causes "Demo data" warning and data model mismatch
>
> **Use Tree of Thought with 2-step lookahead:**
> 1. Generate 3 approaches:
>    - A: Remove fallback completely, show empty state
>    - B: Move fallback to a constants file, keep as backup
>    - C: Replace with skeleton/loading placeholders
> 2. Evaluate each against: user experience when API fails, developer experience, separation of concerns, acceptance criteria match
> 3. **Lookahead**: What happens when the backend is slow? What about first-time users with no data?
> 4. Score and prune. Select the winner.
> 5. Within the winning branch, generate 3 UI variants (minimal, informative, engaging) and pick the one that matches acceptance criteria
> 6. Output the final React component code for the empty state

#### **Step 1: Generate Three Fallback Approaches**

```
         [Handle fallbackData removal]
         /            |               \
    Branch A      Branch B         Branch C
   "Empty State   "Constants       "Skeleton
    Only"          File Backup"     Placeholders"
```

**Branch A — Empty State Only**
- Remove fallbackData completely
- Show informative empty state when no data
- Error state shows error message, not fake data

**Branch B — Constants File Backup**
- Move fallbackData to `constants/mockData.ts`
- Import and use when API fails
- Maintains current behavior, just relocates code

**Branch C — Skeleton Placeholders**
- Show animated skeleton rows while loading
- No fallback data, just visual placeholders
- Empty state when truly empty

#### **Step 2: Evaluate with Lookahead**

| Criteria | A (Empty State) | B (Constants) | C (Skeleton) |
|----------|-----------------|---------------|--------------|
| **Matches acceptance criteria?** | ✅ "No hardcoded fallbackData" | ❌ Still has hardcoded data | ✅ No hardcoded data |
| **UX when API fails?** | ⚠️ Shows error, no data | ✅ Shows fake data | ⚠️ Shows error, no data |
| **Separation of concerns?** | ✅ Frontend has no business data | ❌ Frontend still has data | ✅ Frontend has no business data |
| **Developer experience?** | ✅ Clear data flow | ⚠️ Two data sources | ✅ Clear data flow |
| **Lookahead: Slow backend?** | ⚠️ Loading spinner only | ✅ Quick display | ✅ Skeleton looks good |
| **Lookahead: First-time user?** | ✅ "Be the first!" message | ❌ Shows fake players | ✅ Empty after skeleton |
| **Runtime error risk?** | ✅ kills/wins always defined | ⚠️ Still model mismatch | ✅ kills/wins always defined |
| **Implementation cost?** | ⚠️ Need empty state design | ✅ Minimal code move | ⚠️ Need skeleton design |

#### **Step 3: Score and Prune**

```
         [Handle fallbackData removal]
         /            |               \
    Branch A      Branch B         Branch C
    Score: 7      Score: 3         Score: 6
    ⭐ Best       ✗ Pruned         ⚠️ Good
```

**Scoring** (1 point per criterion met, 8 criteria):
- **Branch A (7/8)**: Meets AC, clean separation, small UX gap
- **Branch B (3/8)**: Violates acceptance criteria — data still hardcoded
- **Branch C (6/8)**: Good UX but more complex, skeleton + empty state needed

**Decision**: Branch A — cleanest solution that meets acceptance criteria

#### **Step 4: Deepen Branch A — UI Variants**

```
       [Branch A: Empty State Design]
       /               |                \
   A1: Minimal      A2: Informative    A3: Engaging
   (text only)      (icon + text)      (CTA + animation)
```

**Sub-Branch A1 — Minimal**
- Simple text: "No scores available"
- No visual elements
- 5 minutes to implement

**Sub-Branch A2 — Informative**
- Trophy icon + "No scores yet"
- Subtext: "Be the first to claim the top spot!"
- Matches existing UI aesthetic
- 15 minutes to implement

**Sub-Branch A3 — Engaging**
- Animated trophy icon
- "Start playing to see your score here!"
- Button CTA to submit score
- 45 minutes to implement (beyond AC scope)

**Decision**: **A2** — informative without overscoping

#### **Step 5: Final Implementation**

```typescript
// Empty state component for Leaderboard.tsx
{leaderboardData.length === 0 && !loading && !error && (
  <div className="text-center py-20 bg-black/40 backdrop-blur-sm border border-gray-800 rounded-lg">
    <Trophy className="w-16 h-16 mx-auto text-gray-600 mb-4" />
    <h3 className="text-xl text-gray-400 mb-2">No scores yet</h3>
    <p className="text-gray-500">Be the first to claim the top spot!</p>
  </div>
)}

// Error state (no fallback data)
if (response.error) {
  setError(response.error);
  setLeaderboardData([]);  // Empty array instead of fallbackData
  setUsingFallback(false);
}
```

#### **Step 6: Verify**
- [x] No hardcoded fallbackData array in Leaderboard.tsx
- [x] Empty state shows trophy icon and "No scores yet" message
- [x] Warning banner removed (no more "demo data")
- [x] Clean separation — frontend has no business data

---

### **Example 5: Tree of Thought for Data Model Extension Strategy (US-1)**

**Task**: How should kills/wins fields be added across the full stack?

This is a cross-cutting concern that affects US-1 (Tasks T-1.1 through T-1.4). The change spans Java entity, Go model, API responses, and frontend types.

#### The Prompt

> User Story US-1: Extend Game Score Data Model with kills and wins.
> The change must propagate through:
> - Java: `GameScore.java` entity
> - Go: `game_score.go` model + `ScoreResponse` struct  
> - API: JSON responses from both backends
> - Frontend: `types.ts` ScoreResponse interface
>
> Current state from `docs/LEADERBOARD_REFACTORING.md`:
> - Frontend has optional kills/wins (`kills?: number`)
> - Backend ScoreResponse has NO kills/wins
> - This causes `undefined.toLocaleString()` runtime errors
>
> **Use Tree of Thought with 3-step lookahead:**
> 1. Generate 3 migration strategies: big-bang (all at once), frontend-first, backend-first
> 2. Evaluate each against: risk of runtime errors, ability to test incrementally, deployment complexity
> 3. **Lookahead**: What if Go backend deploys before Java? What if frontend deploys first?
> 4. Prune and select.
> 5. Produce a detailed execution order diagram showing which files change in what sequence
> 6. Show the specific code changes for each file

#### **Step 1: Generate Migration Branches**

```
          [Add kills/wins across full stack]
          /              |                \
     Branch A        Branch B          Branch C
    "Big-Bang"     "Frontend-First"  "Backend-First"
     (all at once)  (types → API)    (API → types)
```

**Branch A — Big-Bang Migration**
- All 4 layers changed in single PR
- Deploy all services simultaneously
- One comprehensive test at the end

**Branch B — Frontend-First**
- Make kills/wins required in frontend types FIRST
- Then update backends to supply the fields
- Frontend breaks until backends deploy

**Branch C — Backend-First**
- Add kills/wins to backends FIRST (with defaults)
- Then update frontend to use them
- Backends deploy independently, frontend catches up

#### **Step 2: Evaluate with 3-Step Lookahead**

| Criteria | A (Big-Bang) | B (Frontend-First) | C (Backend-First) |
|----------|--------------|--------------------|--------------------|
| **Risk of runtime errors?** | ⚠️ High if deploy fails | ❌ Frontend breaks immediately | ✅ Additive, no breaks |
| **Incremental testing?** | ❌ All or nothing | ❌ Can't test frontend alone | ✅ Test backend, then frontend |
| **Deployment complexity?** | ❌ Must coordinate 3 services | ⚠️ Frontend depends on backend | ✅ Independent deploys |
| **Lookahead: Go before Java?** | ❌ Inconsistent state | ❌ Frontend still breaks | ✅ Go has fields, Java catches up |
| **Lookahead: Frontend first?** | ❌ Breaks production | ❌ Breaks production | ✅ Frontend still works (undefined) |
| **Rollback complexity?** | ❌ Full rollback | ⚠️ Revert frontend types | ✅ Remove fields, no breaks |
| **Matches existing optional typing?** | ❌ Forces breaking change | ❌ Forces breaking change | ✅ Optional → required is safe |
| **API contract safety?** | ⚠️ Breaking change | ⚠️ Breaking change | ✅ Additive (new fields) |

#### **Step 3: Prune**

```
          [Add kills/wins across full stack]
          /              |                \
     Branch A        Branch B          Branch C
     ✗ Pruned       ✗ Pruned          ⭐ Best
   (high risk,     (breaks frontend   (additive,
    no rollback)    until done)        safe rollback)
```

- **Branch A pruned** — too risky, no incremental validation
- **Branch B pruned** — frontend breaks immediately, poor DX
- **Branch C wins** — additive changes, each step is safe, easy rollback

#### **Step 4: Deepen Branch C — Execution Order**

```
Backend-First Migration Order:

Phase 1: Extend Backend Models (parallel)
┌─────────────────────────────────────────────────────┐
│  T-1.1: Java GameScore.java                         │
│  - Add: Integer kills = 0                           │
│  - Add: Integer wins = 0                            │
│  - Existing API unchanged (new fields in response)  │
│                                                      │
│  T-1.2: Go game_score.go                            │
│  - Add: Kills int `json:"kills"`                    │
│  - Add: Wins int `json:"wins"`                      │
│  - Update ToResponse() to include fields            │
└─────────────────────────────────────────────────────┘
                    │
                    ▼ both backends deploy
Phase 2: Update API Contract (verification)
┌─────────────────────────────────────────────────────┐
│  T-1.3: Verify API responses                        │
│  - Java: GET /api/scores/game/*/top returns kills   │
│  - Go: GET /api/scores/game/*/top returns kills     │
│  - Both return 0 for existing data without kills    │
└─────────────────────────────────────────────────────┘
                    │
                    ▼ API verified
Phase 3: Update Frontend Types
┌─────────────────────────────────────────────────────┐
│  T-1.4: Update frontend/src/app/api/types.ts        │
│  - Change: kills?: number → kills: number           │
│  - Change: wins?: number → wins: number             │
│  - Now safe because API always provides them        │
└─────────────────────────────────────────────────────┘
```

#### **Step 5: Implementation Code for Each Layer**

**Java: `GameScore.java`**
```java
@Entity
@Table(name = "game_scores")
@Data
public class GameScore {
    // ...existing fields...
    
    @Column(nullable = false)
    private Integer kills = 0;
    
    @Column(nullable = false)
    private Integer wins = 0;
}
```

**Go: `game_score.go`**
```go
type GameScore struct {
    // ...existing fields...
    Kills      int            `gorm:"not null;default:0" json:"kills"`
    Wins       int            `gorm:"not null;default:0" json:"wins"`
}

type ScoreResponse struct {
    // ...existing fields...
    Kills      int    `json:"kills"`
    Wins       int    `json:"wins"`
}

func (g *GameScore) ToResponse() ScoreResponse {
    return ScoreResponse{
        // ...existing fields...
        Kills:      g.Kills,
        Wins:       g.Wins,
    }
}
```

**Frontend: `types.ts`**
```typescript
export interface ScoreResponse {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  kills: number;    // Changed from optional to required
  wins: number;     // Changed from optional to required
  achievedAt: string;
  createdAt: string;
}
```

#### **Step 6: Verify**
- [x] Java entity includes kills and wins with defaults
- [x] Go model includes Kills and Wins with gorm tags
- [x] API responses include kills and wins in JSON
- [x] Frontend types require kills and wins (safe after backend deploy)
- [x] No `undefined.toLocaleString()` errors
- [x] Safe rollback: remove fields, no breaking change

---

## Why Tree of Thought Matters for the Leaderboard Migration

### **Without Tree of Thought:**
- ❌ Pick the first database that comes to mind (maybe PostgreSQL because it's "production-grade")
- ❌ Never discover that SQLite matches Go backend and simplifies Docker
- ❌ Deploy frontend changes before backend, causing runtime errors
- ❌ No systematic evaluation — just gut feeling
- ❌ Surprised when `undefined.toLocaleString()` crashes production

### **With Tree of Thought:**
1. ✅ Generate 3+ candidate approaches before committing
2. ✅ Evaluate with multi-step lookahead (what happens if Go deploys first?)
3. ✅ Prune bad branches early (save time, avoid rollbacks)
4. ✅ Merge best ideas from different branches when possible
5. ✅ Arrive at a decision with documented rationale
6. ✅ Future developers understand *why* H2 was rejected for SQLite

### **Result:**
- **Better architecture decisions** — compared 3 database options, picked SQLite for parity
- **Fewer production incidents** — backend-first migration prevents runtime errors
- **Documented rationale** — team knows why PostgreSQL was over-engineered for this use case
- **Combinable with CoT** — once the best branch is selected, use Chain of Thought to implement it step-by-step

---

## When to Use ToT vs CoT

| Scenario | Use |
|----------|-----|
| Problem has one obvious approach | **CoT** — show steps linearly |
| Multiple valid architectures compete | **ToT** — branch, evaluate, prune |
| Cross-service changes (frontend + backend) | **ToT** — explore migration strategies |
| Implementing a chosen design | **CoT** — step-by-step implementation |
| Database/persistence decisions | **ToT** — many valid options |
| Single-file refactoring | **CoT** — straightforward coding |

**Best practice**: Use **ToT to decide WHAT to build**, then **CoT to decide HOW to build it**.

---

## Prompt Cheat Sheet

Here are the prompts stripped to their reusable skeleton. Copy, fill in the blanks, paste.

### Quick Prompt — Data Structure Decision (Example 2)

```
I need to design [DATA STRUCTURE] for [TASK ID].
Acceptance criteria: [PASTE FROM SPRINT_BACKLOG]

Use Tree of Thought reasoning:
1. Generate 3 distinctly different schema approaches
2. Evaluate each against: [PARSING EASE], [EXTENSIBILITY], [MATCH EXISTING PATTERNS]
3. Prune the weakest branch and explain why
4. If two branches are strong, merge their best elements
5. Produce a final schema with example data from [EXISTING SOURCE]
```

### Quick Prompt — Technology/Architecture Decision (Example 3)

```
Task [ID]: [DESCRIPTION]
Current state: [WHAT EXISTS NOW]
Constraint: [MUST MATCH / MUST WORK WITH]

Use Tree of Thought with 2-step lookahead:
1. Generate 3 technology options (list them: A, B, C)
2. Evaluate each against: deployment simplicity, parity with other services, DX
3. Lookahead: what happens in [PRODUCTION ENV]? With [MULTIPLE SERVICES]?
4. Score and prune. Select the winner.
5. For the winner, list exact config file changes.
```

### Quick Prompt — Frontend Component Decision (Example 4)

```
Task [ID]: [COMPONENT CHANGE]
Current anti-pattern from [DOC REFERENCE]:
- [CURRENT PROBLEM]
- [WHY IT'S BAD]

Use Tree of Thought with 2-step lookahead:
1. Generate 3 approaches: [OPTION A], [OPTION B], [OPTION C]
2. Evaluate: UX impact, separation of concerns, acceptance criteria match
3. Lookahead: what if [EDGE CASE]?
4. Score and prune. Select the winner.
5. Within winner, generate 3 UI variants (minimal, informative, engaging)
6. Output final React component code.
```

### Quick Prompt — Cross-Cutting Migration (Example 5)

```
[USER STORY]: [DESCRIPTION]
Change must propagate through: [LIST LAYERS]

Current state: [WHAT'S BROKEN]

Use Tree of Thought with 3-step lookahead:
1. Generate 3 migration strategies: [NAME_A], [NAME_B], [NAME_C]
2. Evaluate: runtime error risk, incremental testing, deployment complexity
3. Lookahead: what if [SERVICE A] deploys before [SERVICE B]?
4. Prune and select.
5. Produce detailed execution order diagram.
6. Show specific code changes for each layer.
```

---

## Tree of Thought Template for Full-Stack Development

```markdown
### Problem: [Task from SPRINT_BACKLOG]

#### Step 1: Generate Candidate Branches
         [Problem]
         /    |    \
    Branch A  B     C
    "name"  "name" "name"

Describe each branch in 2-3 sentences.

#### Step 2: Evaluate with Lookahead
| Criteria | Branch A | Branch B | Branch C |
|----------|----------|----------|----------|
| Matches acceptance criteria? | | | |
| API contract safety? | | | |
| Matches existing patterns? | | | |
| Lookahead: independent deploy? | | | |
| Lookahead: rollback ease? | | | |
| Implementation effort? | | | |
| Testing complexity? | | | |

#### Step 3: Score and Prune
- Branch [X] pruned because...
- Branch [Y] selected because...
- (Optional) Merge elements from pruned branches

#### Step 4: Deepen Winning Branch
Expand the chosen branch one more level.
Apply CoT within this branch for implementation details.

#### Step 5: Verify Against Acceptance Criteria
- [ ] Criterion from SPRINT_BACKLOG
- [ ] Lookahead criterion (deploys independently?)
- [ ] Contract criterion (matches existing API?)
```

---

## Key Takeaway

**Tree of Thought = Explore before you commit**, like a chess player considering multiple moves.

For the Leaderboard Migration, this means:
1. **Branch** — "What are 3 ways to structure the seed data JSON?"
2. **Evaluate** — "Which is easiest for both Java and Go backends to parse?"
3. **Prune** — "Normalized with references is over-engineered — cut it."
4. **Merge** — "Take flat array simplicity, add metadata header."
5. **Deepen** — "Now use CoT to implement the winning design step-by-step."

The power of ToT is avoiding the trap of the first idea. In full-stack development, the first database you consider, the first migration strategy you imagine, and the first UI pattern you sketch are rarely the best. **Branching before committing** leads to stronger, more considered designs.

---

## Additional Resources

- **Chain of Thought doc**: `docs/intelliJ-workshop/CHAIN_OF_THOUGHT.md` — linear reasoning companion
- **Migration Plan**: `docs/LEADERBOARD_MIGRATION_PLAN.md` — technical implementation steps
- **Refactoring Analysis**: `docs/LEADERBOARD_REFACTORING.md` — problem analysis and recommendations
- **Sprint Backlog**: `docs/SPRINT_BACKLOG_LEADERBOARD.md` — task breakdown and acceptance criteria
- **API Types**: `frontend/src/app/api/types.ts` — ScoreResponse interface
- **API Service**: `frontend/src/app/api/scoreService.ts` — API client implementation
- **Go Model**: `go-backend/models/game_score.go` — Go entity and DTOs
- **Java Entity**: `java-spring-boot-backend/.../entity/GameScore.java` — JPA entity
- **Seed Data**: `go-backend/models/db.go` — existing Go seed implementation

---

**Author**: GitHub Copilot  
**Context**: High Scores Demo - Leaderboard Migration & Refactoring Sprint  
**Last Updated**: February 10, 2026
