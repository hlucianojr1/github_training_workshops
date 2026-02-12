# Leaderboard Refactoring: Findings & Recommendations

> **Document Version**: 1.0  
> **Created**: February 3, 2026  
> **Author**: Sr. Frontend Architect (via GitHub Copilot)  
> **Status**: Approved for Implementation

---

## Executive Summary

The current `Leaderboard.tsx` component contains **hardcoded fallback data** that violates separation of concerns, creates maintenance burdens, and causes runtime errors. This document details the findings, business impacts, and recommended architecture changes.

---

## 1. Current Implementation Analysis

### 1.1 Hardcoded Fallback Data Location

**File**: `frontend/src/app/components/Leaderboard.tsx` (Lines 8-21)

```typescript
const fallbackData = [
  { rank: 1, player: "GhostReaper", score: 145820, kills: 2847, wins: 156, icon: Trophy },
  { rank: 2, player: "ShadowSniper", score: 142150, kills: 2756, wins: 149, icon: Trophy },
  { rank: 3, player: "PhantomElite", score: 138490, kills: 2698, wins: 145, icon: Trophy },
  { rank: 4, player: "ViperStrike", score: 135280, kills: 2634, wins: 141, icon: Medal },
  { rank: 5, player: "StealthNinja", score: 132760, kills: 2589, wins: 138, icon: Medal },
  { rank: 6, player: "TacticalWolf", score: 129450, kills: 2523, wins: 134, icon: Medal },
  { rank: 7, player: "NightHawk47", score: 126890, kills: 2478, wins: 131, icon: Award },
  { rank: 8, player: "DeltaForce", score: 124320, kills: 2431, wins: 128, icon: Award },
  { rank: 9, player: "ApexPredator", score: 121750, kills: 2384, wins: 125, icon: Award },
  { rank: 10, player: "WarMachine", score: 119180, kills: 2337, wins: 122, icon: Award },
];
```

### 1.2 When Fallback Data Is Used

The fallback data is displayed when:
1. **API returns an error** (Line 91-94)
2. **API returns empty data** (Line 99-101)
3. **Initial render before API response** (Line 41)

```typescript
// Line 91-94: Error case
if (response.error) {
  setError(response.error);
  setLeaderboardData(fallbackData);
  setUsingFallback(true);
}

// Line 99-101: Empty response case  
} else {
  setLeaderboardData(fallbackData);
  setUsingFallback(true);
}
```

---

## 2. Identified Anti-Patterns

### 2.1 ❌ Data Duplication Across Layers

| Location | Data Type | Sync Status |
|----------|-----------|-------------|
| `frontend/Leaderboard.tsx` | Hardcoded array | ⚠️ Manually maintained |
| `go-backend/models/db.go` | Seed function | ⚠️ Separate copy |
| `java-spring-boot-backend/` | None | ❌ No seed data |

**Problem**: Three potential sources of truth with no synchronization mechanism.

### 2.2 ❌ Frontend Contains Business Data

The frontend component should only be responsible for:
- ✅ Rendering UI
- ✅ Managing component state
- ✅ Calling APIs

It should NOT contain:
- ❌ Business/domain data (player names, scores)
- ❌ Seed data that belongs in the database

### 2.3 ❌ Data Model Mismatch

**Frontend `LeaderboardEntry` interface**:
```typescript
interface LeaderboardEntry {
  rank: number;
  player: string;
  score: number;
  kills?: number;   // ⚠️ Optional but used as required
  wins?: number;    // ⚠️ Optional but used as required
  icon: typeof Trophy | typeof Medal | typeof Award;
}
```

**Backend `ScoreResponse` DTO**:
```typescript
// From frontend/src/app/api/types.ts
export interface ScoreResponse {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  achievedAt: string;
  createdAt: string;
}
// ❌ Missing: kills, wins
```

**Consequence**: When API data is used, `kills` and `wins` are `undefined`.

### 2.4 ❌ Runtime Error Risk

**Line 176-177 in Leaderboard.tsx**:
```typescript
<span className="text-gray-300">{entry.kills.toLocaleString()}</span>
// ...
<span className="text-green-400 font-bold">{entry.wins}</span>
```

When API data is loaded (without fallback), `entry.kills` is `undefined`, causing:
```
TypeError: Cannot read properties of undefined (reading 'toLocaleString')
```

---

## 3. Business Impact Analysis

### 3.1 User Experience Issues

| Issue | Impact | Severity |
|-------|--------|----------|
| "Demo data" warning always shown when Java backend starts fresh | Confuses users, appears broken | **Medium** |
| Kills/Wins columns show `undefined` or crash | Poor UX, unprofessional | **High** |
| Inconsistent data between page refreshes | Trust erosion | **Medium** |

### 3.2 Developer Experience Issues

| Issue | Impact | Severity |
|-------|--------|----------|
| Data changes require frontend deployment | Slow iteration | **Medium** |
| No single source of truth for test data | Debugging difficulty | **High** |
| Backend inconsistency (Go has seed, Java doesn't) | Confusion, bugs | **High** |

### 3.3 Maintenance Burden

| Task | Current Effort | With Fix |
|------|----------------|----------|
| Update leaderboard test data | Edit 2-3 files across repos | Edit 1 JSON file |
| Add new game | Frontend + Go + Java changes | 1 JSON file + auto-seed |
| Sync data across backends | Manual verification | Automatic via shared JSON |

### 3.4 Technical Debt Quantification

- **Lines of duplicated code**: ~40 lines across 3 locations
- **Files requiring sync**: 3 files in 3 different languages
- **Risk of production bugs**: High (undefined property access)
- **Estimated fix time**: 3-5 developer days

---

## 4. Recommended Architecture

### 4.1 Single Source of Truth Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                    shared/seed-data.json                     │
│         (Canonical seed data for all environments)           │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
     ┌────────────────┐ ┌────────────────┐ ┌────────────────┐
     │  Java Backend  │ │   Go Backend   │ │    Frontend    │
     │ DataInitializer│ │   SeedData()   │ │  (No fallback) │
     │  reads JSON    │ │  reads JSON    │ │  Empty state   │
     └────────────────┘ └────────────────┘ └────────────────┘
              │               │               │
              ▼               ▼               ▼
     ┌────────────────┐ ┌────────────────┐ ┌────────────────┐
     │    SQLite DB   │ │   SQLite DB    │ │   API Calls    │
     │  (persistent)  │ │  (persistent)  │ │  (real data)   │
     └────────────────┘ └────────────────┘ └────────────────┘
```

### 4.2 Extended Data Model

**Add `kills` and `wins` to backend entities**:

```java
// Java: GameScore.java
@Column(nullable = false)
private Integer kills = 0;

@Column(nullable = false)  
private Integer wins = 0;
```

```go
// Go: game_score.go
type GameScore struct {
    // ... existing fields
    Kills int `gorm:"not null;default:0" json:"kills"`
    Wins  int `gorm:"not null;default:0" json:"wins"`
}
```

### 4.3 Frontend Error Handling

Replace hardcoded fallback with proper empty state:

```typescript
// BEFORE (anti-pattern)
if (response.error) {
  setLeaderboardData(fallbackData); // ❌ Hardcoded data
}

// AFTER (recommended)
if (response.error) {
  setLeaderboardData([]); // ✅ Empty array
  setError("Unable to load leaderboard. Please try again.");
}
```

### 4.4 Graceful Degradation UI

```typescript
{leaderboardData.length === 0 && !loading && (
  <div className="text-center py-20">
    <Trophy className="w-16 h-16 mx-auto text-gray-600 mb-4" />
    <h3 className="text-xl text-gray-400">No scores yet</h3>
    <p className="text-gray-500">Be the first to claim the top spot!</p>
  </div>
)}
```

---

## 5. Success Criteria

| Criteria | Measurement |
|----------|-------------|
| Single source of truth | Only `shared/seed-data.json` contains test data |
| No hardcoded frontend data | `fallbackData` constant removed from Leaderboard.tsx |
| Consistent backend seeding | Both Java and Go load from same JSON |
| No runtime errors | `kills` and `wins` always defined in API responses |
| Proper empty state | UI handles zero scores gracefully |
| SQLite persistence | Java backend retains data across restarts |

---

## 6. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Breaking existing API consumers | Low | High | Version API, add fields as non-breaking |
| Seed data not loading | Medium | Medium | Add startup validation, logging |
| SQLite file permissions | Low | Low | Docker volume configuration |
| Migration complexity | Medium | Medium | Phased rollout, feature flags |

---

## 7. Next Steps

1. **Review this document** with the team
2. **Proceed to**: `docs/LEADERBOARD_MIGRATION_PLAN.md` for implementation details
3. **Use agents**: Follow `docs/AGENTIC_WORKFLOW_LEADERBOARD.md` for execution
4. **Track progress**: Use `docs/SPRINT_BACKLOG_LEADERBOARD.md` for sprint planning

---

## Appendix A: Code References

| File | Lines | Description |
|------|-------|-------------|
| `frontend/src/app/components/Leaderboard.tsx` | 8-21 | Hardcoded fallback data |
| `frontend/src/app/components/Leaderboard.tsx` | 176-177 | Kills/wins rendering (crash risk) |
| `frontend/src/app/api/types.ts` | 1-10 | ScoreResponse interface (missing kills/wins) |
| `go-backend/models/db.go` | SeedData() | Go seed implementation |
| `java-spring-boot-backend/.../GameScore.java` | Entity | Missing kills/wins fields |

---

## Appendix B: Related Documents

- [LEADERBOARD_MIGRATION_PLAN.md](./LEADERBOARD_MIGRATION_PLAN.md) - Technical implementation plan
- [AGENTIC_WORKFLOW_LEADERBOARD.md](./AGENTIC_WORKFLOW_LEADERBOARD.md) - Agent execution guide
- [SPRINT_BACKLOG_LEADERBOARD.md](./SPRINT_BACKLOG_LEADERBOARD.md) - Sprint planning
