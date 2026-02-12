# API Contract Updates - February 4, 2026

## 📋 Summary

Updated frontend API types to include `kills` and `wins` fields in the ScoreResponse interface and related types. These fields were already present in seed data but missing from the TypeScript contracts.

## ✅ Changes Made

### 1. Frontend TypeScript Types (`frontend/src/app/api/types.ts`)

#### ScoreResponse Interface
**Status:** ✅ Updated

```typescript
export interface ScoreResponse {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  kills?: number;        // NEW - Optional for backward compatibility
  wins?: number;         // NEW - Optional for backward compatibility
  achievedAt: string;
  createdAt: string;
}
```

**Rationale:** Fields are optional (`?`) for backward compatibility with existing backend implementations that don't yet return these fields.

#### ScoreSubmissionRequest Interface
**Status:** ✅ Updated

```typescript
export interface ScoreSubmissionRequest {
  playerName: string;
  gameName: string;
  score: number;
  kills?: number;        // NEW - Optional submission
  wins?: number;         // NEW - Optional submission
  achievedAt?: string;
}
```

**Rationale:** Allows clients to submit kills/wins when available, but doesn't require them.

#### ScoreUpdatePayload Interface (WebSocket)
**Status:** ✅ Updated

```typescript
export interface ScoreUpdatePayload {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  kills?: number;        // NEW
  wins?: number;         // NEW
  achievedAt: string;
}
```

**Rationale:** Maintains consistency with ScoreResponse for real-time updates.

### 2. API Test Files

#### Java Backend Tests
**File:** `java-spring-boot-backend/game-score-tests.http`
**Status:** ✅ Updated

- Added kills/wins to all score submission tests (Tests 3-7, 23-25)
- Added expected response format documentation in header
- Tests now reflect the complete contract

**File:** `java-spring-boot-backend/comprehensive-api-tests.http`
**Status:** ✅ Updated

- Added new Game Score API test section (Tests 18-20)
- Includes score submission with kills/wins
- Documents expected response format

## 🔄 Backend Implementation Status

### Java Backend
**Status:** ⚠️ Requires Implementation

**Files to Update:**
- `src/main/java/com/insight/ai_demo/entity/GameScore.java` - Add `Integer kills, wins` fields
- `src/main/java/com/insight/ai_demo/dto/ScoreResponse.java` - Add `Integer kills, wins` fields
- `src/main/java/com/insight/ai_demo/dto/ScoreSubmissionRequest.java` - Add optional `Integer kills, wins`

**Migration Required:** Yes - ALTER TABLE to add nullable columns

### Go Backend
**Status:** ⚠️ Requires Implementation

**Files to Update:**
- `go-backend/models/game_score.go` - Add `Kills *int, Wins *int` to GameScore struct
- `go-backend/models/game_score.go` - Add fields to ScoreResponse and ScoreSubmissionRequest
- `go-backend/models/game_score.go` - Update ToResponse() method

**Migration Required:** Yes - if using separate schema

## 📊 Contract Validation Matrix

| Field | Frontend Type | Java Backend | Go Backend | Seed Data | Status |
|-------|--------------|--------------|------------|-----------|--------|
| `id` | `number` | `Long` | `uint` | ✅ | ✅ Consistent |
| `playerName` | `string` | `String` | `string` | ✅ | ✅ Consistent |
| `gameName` | `string` | `String` | `string` | ✅ | ✅ Consistent |
| `score` | `number` | `Long` | `int64` | ✅ | ✅ Consistent |
| `kills` | `number?` | ❌ Missing | ❌ Missing | ✅ | ⚠️ Frontend ready, backends need update |
| `wins` | `number?` | ❌ Missing | ❌ Missing | ✅ | ⚠️ Frontend ready, backends need update |
| `achievedAt` | `string` | `LocalDateTime` | `time.Time` | ✅ | ✅ Consistent |
| `createdAt` | `string` | `LocalDateTime` | `time.Time` | ✅ | ✅ Consistent |

## 🎯 Backward Compatibility Strategy

### Phase 1: Frontend Update (✅ COMPLETE)
- Add optional `kills?` and `wins?` fields to TypeScript types
- Frontend handles both old responses (no kills/wins) and new responses (with kills/wins)
- No breaking changes for consumers

### Phase 2: Backend Updates (⏳ PENDING)
- Java backend adds nullable `kills` and `wins` columns to database
- Go backend adds nullable fields to its model
- Both backends accept but don't require kills/wins in submissions
- Both backends return kills/wins when available

### Phase 3: Data Migration (⏳ FUTURE)
- Existing scores without kills/wins remain valid (NULL values)
- New submissions can include kills/wins
- Frontend gracefully handles both cases

### Phase 4: Make Required (⏳ FUTURE - Optional)
- After sufficient data coverage, optionally make fields required
- Update TypeScript types from `kills?: number` to `kills: number`
- Update backend validations to require fields

## 🧪 Testing Checklist

- [x] TypeScript types compile without errors
- [x] Test files updated with new fields
- [x] Documentation includes expected response format
- [ ] Java backend accepts kills/wins in POST requests
- [ ] Java backend returns kills/wins in GET responses
- [ ] Go backend accepts kills/wins in POST requests
- [ ] Go backend returns kills/wins in GET responses
- [ ] Integration tests pass with new fields
- [ ] Frontend displays kills/wins when available
- [ ] WebSocket updates include kills/wins

## 📝 Migration Coordination Notes

**For Java Backend Agent:**
- Add `Integer kills` and `Integer wins` to GameScore entity (nullable)
- Update ScoreResponse DTO constructor to map new fields
- Update ScoreSubmissionRequest to accept optional kills/wins
- Database migration: `ALTER TABLE game_scores ADD COLUMN kills INTEGER, ADD COLUMN wins INTEGER`

**For Go Backend Agent:**
- Add `Kills *int \`json:"kills,omitempty"\`` to GameScore struct
- Add `Wins *int \`json:"wins,omitempty"\`` to GameScore struct
- Update ScoreResponse and ScoreSubmissionRequest structs
- Update ToResponse() method to include new fields
- If using separate schema, create migration

**For Testing Agent:**
- Verify optional field handling in all endpoints
- Test backward compatibility (old requests without kills/wins still work)
- Test forward compatibility (new requests with kills/wins are accepted)
- Verify NULL handling in database queries

## 🚀 Deployment Strategy

1. **Deploy Frontend** - Safe to deploy immediately (handles both old and new backend responses)
2. **Deploy Backend Changes** - Can deploy independently, no coordination required
3. **Verify Contract** - Use .http test files to validate responses include kills/wins
4. **Monitor** - Ensure old clients (if any) continue working

## 📚 References

- **Seed Data:** `shared/seed-data.json` - Contains kills/wins for all entries
- **Frontend Types:** `frontend/src/app/api/types.ts` - Updated interfaces
- **Java Tests:** `java-spring-boot-backend/game-score-tests.http` - Updated test payloads
- **Planning Doc:** `docs/PHASE2_GO_BACKEND_PLAN.md` - Original enhancement plan
- **Roadmap:** `docs/ROADMAP.md` - Phase 2 backend extensions

---

**Updated by:** @api_contract_agent  
**Date:** February 4, 2026  
**Status:** Frontend Complete ✅ | Backends Pending ⏳
