# Prompt Engineering Examples for AI-Assisted Documentation

**Date**: February 11, 2026  
**Purpose**: Learn how to generate comprehensive technical documentation (Roadmaps & Instruction Files) using VS Code Planning Agents and effective prompting techniques.

---

## Table of Contents

1. [Prompting Frameworks Overview](#prompting-frameworks-overview)
2. [Part 1: Generating the ROADMAP.md](#part-1-generating-the-roadmapmd)
3. [Part 2: Generating the copilot-instructions.md](#part-2-generating-the-copilot-instructionsmd)
4. [Best Practices Summary](#best-practices-summary)

---

## Prompting Frameworks Overview

### CORE Framework

**C**ontext → **O**bjective → **R**estrictions → **E**xpectations

| Component | Purpose | Example |
|-----------|---------|---------|
| **Context** | Background information, tech stack, current state | "Full-stack leaderboard with React + Spring Boot + Go" |
| **Objective** | What you want to accomplish | "Create a phased development roadmap" |
| **Restrictions** | Constraints, rules, what NOT to do | "Must maintain API contract compatibility" |
| **Expectations** | Desired format, structure, deliverables | "Markdown with tables, milestones, and agent notes" |

### Chain of Thought (CoT)

Linear step-by-step reasoning that shows the thinking process.

```
Step 1: Analyze current architecture
Step 2: Identify missing capabilities
Step 3: Prioritize by dependency order
Step 4: Create phased timeline
```

### Tree of Thought (ToT)

Explore multiple solution branches, evaluate each, prune weak ones, merge best elements.

```
          [Roadmap Structure]
         /        |         \
   By Feature   By Phase   By Team
      /            |            \
  Complex      Balanced      Siloed
     ✗            ✓             ✗
            Best → By Phase
```

---

# Part 1: Generating the ROADMAP.md

The [ROADMAP.md](ROADMAP.md) is a comprehensive 280+ line development roadmap tracking integration between frontend (React/Vite) and dual-backend architecture (Java Spring Boot + Go).

## Analysis: How This Roadmap Was Structured

Before prompting, understand what makes an effective roadmap:

1. **Executive Summary** - Quick status overview with phase progress
2. **Architecture Overview** - Clear service ownership matrix
3. **Shared Infrastructure** - Database, event bus, WebSocket decisions
4. **Phased Milestones** - Detailed tasks with IDs, priorities, status
5. **Data Model Changes** - Entity definitions with code examples
6. **Event Schemas** - Inter-service communication contracts

---

## Prompt Example 1: CORE Framework Approach

### The Prompt

```markdown
You are a VS Code Planning Agent helping create a development roadmap.

**CONTEXT:**
I have a full-stack leaderboard application called "Operation Nightfall" with:
- Frontend: React 18 + Vite + TypeScript + Tailwind CSS
- Java Backend: Spring Boot REST API on port 8080 (scores, missions, puzzles)
- Go Backend: Go + Gin API on port 8081 (challenges, trophies, WebSocket)
- Shared: SQLite database, Redis pub/sub for events

Phase 1 (Core Integration) is complete - frontend connects to backend API with:
- Game selection via URL params
- Dynamic leaderboard fetching
- GameContext provider

**OBJECTIVE:**
Create a comprehensive development roadmap (ROADMAP.md) that:
1. Documents backend service ownership clearly
2. Plans Phase 2 Java extensions (kills/wins/gameMode, missions, puzzles, event queue)
3. Plans Phase 2-Go extensions (challenges, trophies, notifications, Redis subscription)
4. Includes detailed milestones with task IDs, priorities, and agent notes
5. Shows data model changes with Java entity code examples
6. Defines event schemas for inter-service communication

**RESTRICTIONS:**
- Must maintain frontend API contract compatibility (see types.ts)
- Java and Go backends share one SQLite database at ./data/shared.db
- WebSocket broadcasts handled exclusively by Go backend
- No breaking changes to existing endpoints
- Follow existing code patterns in GameScoreController.java and score_handler.go

**EXPECTATIONS:**
- Format: Markdown with tables for milestones and service ownership
- Include: Code snippets for entity definitions and event schemas
- Structure: Executive summary → Architecture → Phase details → Data models
- Status tracking: Use emojis (✅ Complete, 🔲 Not Started)
- Include agent notes for each task explaining implementation approach
```

### Why This Prompt Works

| Aspect | Technique Used |
|--------|----------------|
| Sets clear scope | **Context** provides tech stack and current state |
| Defines deliverables | **Objective** lists 6 specific sections needed |
| Prevents mistakes | **Restrictions** maintain compatibility and patterns |
| Specifies format | **Expectations** detail structure and symbols |

---

## Prompt Example 2: Chain of Thought Approach

### The Prompt

```markdown
I need to create a development roadmap for a multi-backend leaderboard application.
Please reason through this step-by-step:

**Step 1: Analyze Current State**
Read and summarize what exists in:
- `frontend/src/app/api/types.ts` - what types does frontend expect?
- `java-spring-boot-backend/src/main/java/.../GameScoreController.java` - what endpoints exist?
- `go-backend/handlers/score_handler.go` - what does Go handle?
- `docker-compose.yml` - how are services connected?

**Step 2: Identify Capability Gaps**
Looking at the architecture, identify what's missing:
- The frontend shows kills/wins columns but backend doesn't have these fields
- No missions or puzzles functionality exists yet
- No challenges or trophies system
- No cross-backend event communication

**Step 3: Determine Service Ownership**
Create a matrix deciding which backend owns what:
- Java Backend: Where should scores, missions, puzzles live?
- Go Backend: Where should challenges, trophies, WebSocket broadcasts live?
- Shared: What infrastructure (database, cache) should both backends access?

**Step 4: Establish Dependencies and Order**
Identify what must happen before other things can start:
- SQLite migration must happen before any data model extension
- Redis setup must happen before event publishing
- Event queue must exist before retry mechanisms

**Step 5: Create Phased Timeline**
Group tasks into logical phases:
- Phase 2: Java Backend extensions (parallel workstream)
- Phase 2-Go: Go Backend extensions (parallel workstream)
- Phase 3: Shared infrastructure setup
- Phase 4: Frontend integration

**Step 6: Generate the Roadmap**
Create the final ROADMAP.md with:
- Executive summary table showing all phases
- Service ownership matrix
- Detailed milestone tables per phase
- Entity code examples
- Event schema JSON examples

Show your reasoning at each step, then produce the final document.
```

### Why This Prompt Works

Chain of Thought forces the AI to:

1. **Gather context** before making decisions (Step 1)
2. **Analyze gaps** systematically (Step 2)
3. **Make architectural decisions** explicitly (Step 3)
4. **Consider dependencies** to avoid broken plans (Step 4)
5. **Group logically** instead of random task lists (Step 5)
6. **Produce structured output** after reasoning (Step 6)

---

## Prompt Example 3: Tree of Thought Approach

### The Prompt

```markdown
I need to design a roadmap structure for a dual-backend leaderboard application.
Use Tree of Thought reasoning to evaluate approaches:

**Problem:** How should we organize development work across Java and Go backends
that share a database but own different capabilities?

**Generate 3 Candidate Roadmap Structures:**

**Branch A: Feature-Centric**
- Group by feature: Scores → Missions → Challenges → Trophies
- Each feature includes both backend + frontend work
- Pros/cons for this approach?

**Branch B: Phase-Centric with Parallel Tracks**
- Phase 1: Core (done)
- Phase 2 Java: Scores extension, Missions, Puzzles, Event Queue
- Phase 2 Go: Challenges, Trophies, Redis Subscription
- Phase 3: Infrastructure
- Pros/cons for this approach?

**Branch C: Infrastructure-First**
- Phase 1: Database migration, Redis setup
- Phase 2: Event system (queue, publishing, subscribing)
- Phase 3: Features (all backends)
- Pros/cons for this approach?

**Evaluate Each Branch Against Criteria:**
1. Can teams work in parallel? (reduces timeline)
2. Are dependencies respected? (no blocked work)
3. Is progress visible? (stakeholder communication)
4. Does it match existing patterns in the codebase?

**Prune the weakest branch and explain why.**

**If two branches are strong, merge their best elements.**

**Produce the final roadmap using the winning structure.**
```

### Why This Prompt Works

Tree of Thought:

| Step | What it does |
|------|--------------|
| Generate branches | Forces consideration of multiple valid approaches |
| Evaluate against criteria | Objective comparison instead of gut feel |
| Prune weak branches | Eliminates approaches that don't fit constraints |
| Merge best elements | Creates hybrid solution combining strengths |

**Expected outcome:** Branch B (Phase-Centric) wins because:
- Allows Java and Go teams to work in parallel
- Groups related work together
- Clear progress tracking per phase
- Matches the existing completed Phase 1 structure

---

## Prompt Example 4: Using a Planning Agent (@Plan)

### The Prompt to @Plan Agent

```markdown
@Plan Create a development roadmap for the High Scores Demo application.

**Research these files first:**
1. `docs/QUICK_REFERENCE.md` - existing architecture decisions
2. `frontend/src/app/api/types.ts` - API contract TypeScript interfaces
3. `java-spring-boot-backend/src/main/java/.../entities/` - existing entities
4. `go-backend/models/` - existing Go models
5. `shared/seed-data.json` - canonical data structure
6. `docker-compose.yml` - service configuration

**Questions to answer in your plan:**
1. What frontend types exist that backends don't yet support? (kills, wins, gameMode)
2. What new entities need to be created? (Mission, Puzzle, Challenge, Trophy, EventQueue)
3. What shared infrastructure needs setup? (SQLite path, Redis connection)
4. What is the logical order to implement these features?

**Deliverable:**
A ROADMAP.md file structured as:
- Executive Summary (phase table with progress bars)
- Architecture Overview (service ownership matrix)
- Phase 1 ✅ (already complete - document what was done)
- Phase 2 🔲 (Java backend milestones with IDs, tasks, priorities, agent notes)
- Phase 2-Go 🔲 (Go backend milestones matching format)
- Data Model Changes (entity code blocks)
- Event Schemas (JSON examples)

**Format requirements:**
- Use Markdown tables for milestones
- Use emojis for status: ✅ Complete, 🔲 Not Started, 🔥 HIGH priority
- Include code snippets in fenced blocks with language tags
- Add "Agent Notes" column explaining implementation approach
```

### Why This Prompt Works

The @Plan agent:
- **Researches multiple files** before writing (reduces hallucination)
- **Answers specific questions** instead of making assumptions
- **Follows a deliverable spec** for consistent output
- **Uses format requirements** to match team conventions

---

## Prompt Example 5: Incremental Roadmap Building

### Multi-Turn Conversation Approach

**Turn 1: Establish Context**
```markdown
I'm building a development roadmap for a full-stack leaderboard app.

Read these files and summarize the current architecture:
- `docker-compose.yml`
- `frontend/src/app/api/types.ts`
- `java-spring-boot-backend/README.md`
- `go-backend/main.go`

What capabilities exist today?
```

**Turn 2: Identify Gaps**
```markdown
Now compare the frontend types with actual backend implementations.

The frontend expects these fields on scores:
- kills: number
- wins: number  
- gameMode: string

Do the backends support these? If not, add to roadmap as Phase 2 work.
```

**Turn 3: Design Service Ownership**
```markdown
Based on the architecture, propose which backend should own:
- Score management (CRUD)
- Missions/Puzzles (campaign features)
- Challenges/Trophies (gamification)
- Real-time notifications (WebSocket)

Create a service ownership matrix.
```

**Turn 4: Create Milestones**
```markdown
For Phase 2 Java Backend, create detailed milestones:
- Use format: ID | Task | Priority | Status | Agent Notes
- Include: Entity creation, repository, service, controller, tests
- Add event publishing to Redis after score saves
- Include database migration from H2 to SQLite
```

**Turn 5: Generate Final Document**
```markdown
Combine everything into a single ROADMAP.md file.
Include:
1. Executive summary with phase progress percentages
2. The service ownership matrix
3. Shared infrastructure details (SQLite, Redis)
4. Phase 2 milestone tables for both Java and Go
5. Entity code examples
6. Event schema JSON
```

### Why This Approach Works

- **Smaller cognitive load** per turn
- **Verify correctness** at each step before proceeding
- **Adjust direction** if AI goes off track
- **Build understanding** incrementally

---

# Part 2: Generating the copilot-instructions.md

The [copilot-instructions.md](../.github/copilot-instructions.md) is a 100+ line rulebook that guides ALL Copilot suggestions for the codebase.

## Analysis: What Makes an Effective Instruction File

1. **Scope and goals** - What kind of changes are acceptable
2. **Repo architecture** - What exists and what technologies are used
3. **API contract constraints** - Endpoints the frontend depends on
4. **Backend rules** - Structure, HTTP quality, errors, dependencies
5. **Database ownership** - Schema boundaries between services
6. **Testing requirements** - What tests are expected
7. **Working agreements** - Behavior guidelines for AI edits

---

## Prompt Example 1: CORE Framework Approach

### The Prompt

```markdown
You are generating a copilot-instructions.md file for a full-stack codebase.

**CONTEXT:**
Repository: High Scores Demo - full-stack leaderboard application
- `frontend/`: React 18 + Vite + TypeScript + Tailwind
- `java-spring-boot-backend/`: Spring Boot REST API
- `go-backend/`: Go implementation following clean architecture
- `terraform/`: local + Azure infrastructure

Current API endpoints the frontend depends on:
- POST /api/scores/submit
- GET /api/scores/game/{name}/top?limit=10
- GET /api/scores/player/{name}?page=0&size=10
- GET /api/scores/games
- GET /api/scores/players

**OBJECTIVE:**
Create a .github/copilot-instructions.md that will:
1. Define scope - small, reviewable, minimal-diff changes
2. Document the repo architecture - what each folder contains
3. Lock in API contract compatibility - preserve JSON field names and types
4. Enforce Go backend standards - clean architecture, error handling, logging
5. Define database ownership - each service owns its schema
6. Require testing - what tests should accompany changes
7. Set working agreements - read before edit, preserve public APIs

**RESTRICTIONS:**
- Do NOT suggest changes that break frontend API contract
- Do NOT add new dependencies without clear justification
- Do NOT output or log secrets
- Do NOT run terminal commands to edit files unless asked

**EXPECTATIONS:**
- Format: Markdown with numbered sections and subsections
- Include: Code examples showing correct patterns
- Reference: Specific files in the repo as sources of truth
- Tone: Direct, actionable rules (not suggestions)
- Length: Comprehensive but scannable (~100-150 lines)
```

### Why This Prompt Works

| CORE Element | How It's Applied |
|--------------|------------------|
| Context | Lists all repo folders and current API endpoints |
| Objective | 7 specific sections the file must contain |
| Restrictions | Explicit list of what NOT to suggest |
| Expectations | Format, examples, references, tone, length |

---

## Prompt Example 2: Chain of Thought Approach

### The Prompt

```markdown
I need to create a copilot-instructions.md file that governs AI suggestions.
Think through this step-by-step:

**Step 1: Identify What Could Go Wrong**
Without instruction files, AI might:
- Suggest Redux when the project uses Zustand
- Generate code that breaks API contracts
- Add unnecessary dependencies
- Create massive refactoring diffs
- Ignore existing patterns in the codebase

**Step 2: Study Existing Patterns**
Look at these files to understand current conventions:
- `frontend/src/app/api/scoreService.ts` - how API calls are made
- `frontend/src/app/api/types.ts` - the API contract
- `go-backend/handlers/*.go` - handler structure
- `go-backend/models/*.go` - data model patterns
- `java-spring-boot-backend/src/.../*.java` - service patterns

**Step 3: Define the API Contract Rules**
Analyze types.ts and determine:
- What JSON field names must be preserved?
- What pagination format is expected?
- How are errors structured?

**Step 4: Define Go Backend Architecture Rules**
From examining the code, enforce:
- Folder structure (cmd/, internal/httpapi/, internal/domain/, internal/storage/)
- Import boundaries (domain must not import httpapi)
- Error handling patterns (wrap with context, sentinel errors)
- Logging requirements (structured, request_id)

**Step 5: Define Testing Rules**
Determine minimum test requirements:
- Happy path coverage
- Validation failure handling
- Dependency failure scenarios
- Table-driven tests for Go

**Step 6: Generate the Instruction File**
Create copilot-instructions.md with:
- Clear section headers (numbered)
- Explicit "DO" and "DON'T" rules
- Code examples showing patterns
- File references for sources of truth

Show your analysis at each step, then produce the final file.
```

### Why This Prompt Works

Chain of Thought ensures:

1. **Problem identification** - Understand what issues we're preventing
2. **Pattern discovery** - Base rules on actual code, not assumptions
3. **Contract documentation** - Explicit API compatibility rules
4. **Architecture enforcement** - Clean structure guidelines
5. **Test requirements** - Quality gates for changes
6. **Structured output** - Organized, scannable document

---

## Prompt Example 3: Tree of Thought Approach

### The Prompt

```markdown
I need to design the structure for a copilot-instructions.md file.
Use Tree of Thought reasoning:

**Problem:** How should we organize AI coding rules to be most effective?

**Generate 3 Candidate Structures:**

**Branch A: By Risk Level**
- Critical rules (breaking changes, security)
- Important rules (architecture, patterns)
- Nice-to-have rules (formatting, style)
Pros? Cons?

**Branch B: By Technology**
- Frontend rules (React, TypeScript)
- Go backend rules (structure, errors, tests)
- Java backend rules (Spring patterns)
- Infrastructure rules (Docker, Terraform)
Pros? Cons?

**Branch C: By Workflow Phase**
- Before editing (read files, understand context)
- During editing (patterns to follow)
- After editing (tests to run, validation)
Pros? Cons?

**Evaluate against criteria:**
1. Easy to find relevant rules quickly
2. Reduces cognitive load when reading
3. Covers all potential issues
4. Matches how developers think about code

**Prune weakest and explain why.**

**Merge best elements from remaining branches.**

**Produce the final instruction file using winning structure.**
```

### Why This Prompt Works

Tree of Thought:
- **Branch A** (By Risk) - Good for prioritization but hard to classify edge cases
- **Branch B** (By Technology) - Matches codebase structure, easiest to navigate
- **Branch C** (By Workflow) - Logical flow but rules span multiple phases

**Expected winner:** Branch B with elements from A (critical rules highlighted with warnings)

---

## Prompt Example 4: Few-Shot Learning Approach

### The Prompt

```markdown
I need to create a copilot-instructions.md file.
Here are examples of good instruction rules from other projects:

**Example 1: API Contract Rule**
```markdown
## 3) API contract constraints
Endpoints expected by the frontend:
- `POST /api/scores/submit`
- `GET /api/scores/game/{name}/top?limit=10`

When implementing these endpoints (in any backend), preserve:
- JSON field names and types as used by `frontend/src/app/api/types.ts`
- Error handling that is machine-readable and consistent
```

**Example 2: Go Backend Structure Rule**
```markdown
### 4.1 Structure
Prefer this layout:
- `go-backend/cmd/highscores-api/main.go`
- `go-backend/internal/httpapi/` (routing/handlers/middleware)
- `go-backend/internal/domain/` (pure domain types + business rules)

Import boundaries:
- `internal/domain` must not import `internal/httpapi` or `internal/storage`
```

**Example 3: Error Handling Rule**
```markdown
### 4.3 Errors, logging, concurrency
- Don't ignore errors. Wrap with context: `fmt.Errorf("…: %w", err)`
- Define sentinel domain errors in `internal/domain` for business cases
- Structured logging with a `request_id` (use `X-Request-Id` when present)
```

**Now create a complete copilot-instructions.md for my project following these patterns.**

Project details:
- Frontend: React 18 + Vite + TypeScript + Tailwind at `frontend/`
- Java Backend: Spring Boot at `java-spring-boot-backend/`
- Go Backend: Go at `go-backend/`
- API contract: `frontend/src/app/api/types.ts`

Include sections for:
1. Scope and goals
2. Repo architecture
3. API contract constraints
4. Go backend rules (structure, HTTP, errors, dependencies)
5. Database ownership
6. Testing requirements
7. Working agreements
```

### Why This Prompt Works

Few-Shot Learning:
- **Shows desired format** - AI learns the writing style
- **Demonstrates specificity** - File paths, code examples, explicit rules
- **Establishes tone** - Direct, actionable statements
- **Provides structure** - Section numbering, subsections

---

## Prompt Example 5: Reference-Based Generation

### The Prompt

```markdown
Generate a copilot-instructions.md file by analyzing my codebase.

**Files to read and extract rules from:**

1. **Frontend API Contract** - `frontend/src/app/api/types.ts`
   Extract: All interface names, field types, pagination format
   
2. **Frontend API Service** - `frontend/src/app/api/scoreService.ts`  
   Extract: All endpoint URLs, HTTP methods, error handling
   
3. **Go Handler Pattern** - `go-backend/handlers/score_handler.go`
   Extract: Response format, error structure, validation approach
   
4. **Go Repository Pattern** - `go-backend/repository/game_score_repository.go`
   Extract: Database access patterns, query structure
   
5. **Java Controller Pattern** - `java-spring-boot-backend/src/.../GameScoreController.java`
   Extract: Annotation patterns, response types, logging format

**For each file, derive rules that preserve existing patterns.**

**Example transformation:**
IF `types.ts` has `interface ScoreResponse { id: number; playerName: string; score: number }`
THEN rule = "Score submissions must return all fields: id (number), playerName (string), score (number)"

IF `score_handler.go` returns errors as `{"error": {"code": "...", "message": "..."}}`
THEN rule = "Return consistent JSON errors: `{\"error\":{\"code\":\"...\",\"message\":\"...\"}}`"

**Generate the full instruction file based on discovered patterns.**
```

### Why This Prompt Works

Reference-Based Generation:
- **Grounded in actual code** - Rules match reality
- **Systematic extraction** - Each file contributes rules
- **Pattern transformation** - Explicit IF/THEN logic
- **Complete coverage** - All relevant files analyzed

---

# Best Practices Summary

## Framework Selection Guide

| Situation | Best Framework | Why |
|-----------|----------------|-----|
| You know exactly what you want | **CORE** | Direct, complete spec |
| Problem is complex with dependencies | **Chain of Thought** | Step-by-step reasoning |
| Multiple valid approaches exist | **Tree of Thought** | Compare and select |
| You have examples of good output | **Few-Shot** | Pattern matching |
| Rules should come from code | **Reference-Based** | Grounded in reality |
| Need extensive research first | **@Plan Agent** | Multi-file analysis |

## Prompt Quality Checklist

✅ **Context provided** - Tech stack, current state, related files  
✅ **Objective clear** - Specific deliverables listed  
✅ **Constraints explicit** - What NOT to do  
✅ **Format specified** - Markdown, tables, code blocks  
✅ **Examples included** - Show desired output style  
✅ **File references** - Ground claims in actual code  

## Common Mistakes to Avoid

❌ **Vague prompts** - "Create a roadmap" (no context)  
❌ **Missing constraints** - AI may break existing patterns  
❌ **No format spec** - Output won't match team conventions  
❌ **Too many requests** - Break into focused prompts  
❌ **Ignoring existing code** - Don't let AI assume patterns  

## Combination Strategies

For complex documentation like roadmaps:

1. **Start with @Plan** for research and context gathering
2. **Use Chain of Thought** to reason through structure
3. **Apply Tree of Thought** for architecture decisions
4. **Finish with CORE** for final generation with full spec

---

## Quick Reference Templates

### CORE Template
```
**CONTEXT:** [Tech stack, current state]
**OBJECTIVE:** [Numbered list of requirements]
**RESTRICTIONS:** [What NOT to do]
**EXPECTATIONS:** [Format, length, style]
```

### CoT Template
```
Step 1: Analyze current state by reading [files]
Step 2: Identify gaps by comparing [A] with [B]
Step 3: Design solution considering [constraints]
Step 4: Create implementation plan
Step 5: Generate final document
Show your reasoning at each step.
```

### ToT Template
```
Generate 3 candidate approaches:
- Branch A: [approach]
- Branch B: [approach]
- Branch C: [approach]
Evaluate against: [criteria list]
Prune weakest, explain why.
Produce final using winning structure.
```

---

*This document demonstrates that the same deliverable (ROADMAP.md or copilot-instructions.md) can be generated using multiple prompting strategies. Choose based on your confidence level and the complexity of the task.*
