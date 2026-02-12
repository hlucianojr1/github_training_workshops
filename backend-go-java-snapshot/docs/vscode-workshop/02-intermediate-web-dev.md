# Workshop 2: Intermediate Web Development with GitHub Copilot

**Duration**: 90 minutes  
**Format**: Live coding demonstrations  
**Project**: High Scores Demo (Java Spring Boot Backend + React TypeScript Frontend)  
**Audience**: Web developers with Copilot foundational knowledge (completed Workshop 1)  
**Prerequisites**: VS Code with GitHub Copilot extension, GitHub Copilot CLI installed

---

## Learning Objectives

By the end of this workshop, you will be able to:

1. **Inline Code Suggestions** - Accept and modify Copilot's real-time code completions
2. **Prompting** - Write effective prompts that generate accurate, project-specific code
3. **Code Explanations** - Use Copilot to understand complex service and repository logic
4. **Comment-Based Generation** - Generate complete functions from descriptive comments
5. **Code Refactoring** - Extract duplicate code using Copilot's refactoring capabilities
6. **Copilot Chat** - Interact with Copilot for code questions, improvements, and debugging
7. **Few-Shot Prompting** - Teach Copilot patterns by showing examples before requesting new code
8. **Unit Testing & Debugging** - Generate test cases and debug failing tests with Copilot
9. **Privacy & Data Handling** - Understand how Copilot handles your code and data
10. **Copilot CLI** - Generate shell commands and scripts using natural language

---

## Workshop Agenda

| Time | Demo | Learning Objective | File(s) |
|------|------|-------------------|---------|
| 0-10 min | Demo 1 | **Inline Code Suggestions** | `GameScoreRepository.java` |
| 10-20 min | Demo 2 | **Prompting** (Explicit) | `dto/PlayerStatsResponse.java` |
| 20-30 min | Demo 3 | **Comment-Based Generation** | `GameScoreController.java` |
| 30-40 min | Demo 4 | **Code Explanations** | `GameScoreService.java` |
| 40-50 min | Demo 5 | **Code Refactoring** + **Copilot Chat** | `Leaderboard.tsx`, `scoreService.ts` |
| 50-60 min | Demo 6 | **Few-Shot Prompting** | `entity/Player.java` |
| 60-75 min | Demo 7 | **Unit Testing & Debugging** | `GameScoreServiceTest.java` |
| 75-80 min | Demo 8 | **Privacy & Data Handling** | Understanding Copilot's data practices |
| 80-90 min | Demo 9 | **Copilot CLI** | Terminal / Docker commands |

---

## Demo 1: Inline Code Suggestions (10 min)

### Learning Objective
Accept and modify Copilot's real-time code completions as you type, using pattern recognition.

### Scenario
Add a new custom query method to `GameScoreRepository.java`. Copilot will recognize the Spring Data JPA pattern and suggest the complete method signature and query.

### Before Demo: Setup
```bash
# Open GameScoreRepository.java
code java-spring-boot-backend/src/main/java/com/insight/ai_demo/repository/GameScoreRepository.java

# Review existing repository methods (query patterns)
```

### Live Coding Steps

**Step 1: Position cursor after last method**
```java
// Navigate to the end of the repository interface, after countByPlayerName method
@Repository
public interface GameScoreRepository extends JpaRepository<GameScore, Long> {
    // ... existing methods ...
    
    long countByPlayerName(String playerName);
    
    // ← Position cursor here, press Enter
```

**Step 2: Type the beginning of a new query method**
```java
    /**
     * Find all scores within a date range
     */
    @Query("SELECT gs FROM GameScore gs WHERE gs.achievedAt BETWEEN :startDate AND :endDate")
    List<GameScore> findByDateRange(
```

**Expected Copilot Inline Suggestion** (appears as ghost text):
```java
    List<GameScore> findByDateRange(
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate);
```

**Step 3: Accept with Tab key**
- Press `Tab` to accept the entire suggestion
- Or use `Ctrl+→` (Windows) / `Cmd+→` (Mac) to accept word-by-word

**Step 4: Try adding another method using Spring Data naming conventions**
```java
    /**
     * Find scores greater than a threshold
     */
    List<GameScore> findByScoreGreaterThan
```

**Copilot suggests** (using Spring Data JPA derived query naming):
```java
    List<GameScore> findByScoreGreaterThanOrderByScoreDesc(Long score);
```

### Teaching Points

> 💡 **Key Insight**: Inline suggestions work best when Copilot has context. The existing Spring Data JPA patterns teach Copilot the repository conventions.

| Action | Shortcut (Mac) | Shortcut (Windows) |
|--------|----------------|-------------------|
| Accept full suggestion | `Tab` | `Tab` |
| Accept next word | `Cmd+→` | `Ctrl+→` |
| Dismiss suggestion | `Esc` | `Esc` |
| See alternatives | `Alt+]` / `Alt+[` | `Alt+]` / `Alt+[` |

### Common Mistakes
- ❌ **Accepting without review**: Always verify the query logic and parameter types
- ❌ **Ignoring alternatives**: Press `Alt+]` to cycle through multiple suggestions (e.g., different return types)

---

## Demo 2: Prompting - Explicit Prompt Technique (10 min)

### Learning Objective
Write detailed, explicit prompts that generate accurate Java DTOs with proper validation and documentation.

### Scenario
Create a `PlayerStatsResponse` DTO for comprehensive player statistics. The explicit prompt technique specifies requirements, types, and validation rules upfront.

### Before Demo: Setup
```bash
code java-spring-boot-backend/src/main/java/com/insight/ai_demo/dto/PlayerStatsResponse.java
# Create a new file in the dto package
```

### Live Coding Steps

**Step 1: Write an explicit prompt as a comment block**
```java
package com.insight.ai_demo.dto;

/**
 * Create a DTO for comprehensive player statistics response.
 * 
 * Requirements:
 * - playerName: String, required, the player's display name
 * - totalGamesPlayed: Long, count of unique games played
 * - totalScore: Long, sum of all scores across all games
 * - averageScore: Double, calculated average score
 * - highestScore: Long, the player's best score ever
 * - favoriteGame: String, the game with most entries
 * - gamesPlayed: List<String>, list of unique game names
 * - recentScores: List<ScoreResponse>, last 5 scores
 * - firstPlayedAt: LocalDateTime, when player first submitted a score
 * - lastPlayedAt: LocalDateTime, most recent score submission
 * 
 * Annotations:
 * - Use Lombok @Data for getters/setters
 * - Include @Builder for flexible construction
 * - Add @JsonInclude to skip null values
 * - Follow existing project DTO patterns
 */
```

**Step 2: Press Enter and let Copilot generate**

**Expected Copilot Suggestion**:
```java
package com.insight.ai_demo.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Comprehensive player statistics response DTO.
 * Contains aggregated statistics and recent activity for a player.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PlayerStatsResponse {
    
    private String playerName;
    private Long totalGamesPlayed;
    private Long totalScore;
    private Double averageScore;
    private Long highestScore;
    private String favoriteGame;
    private List<String> gamesPlayed;
    private List<ScoreResponse> recentScores;
    private LocalDateTime firstPlayedAt;
    private LocalDateTime lastPlayedAt;
}
```

### Prompting Formula

> 📝 **Explicit Prompting Formula**:
> ```
> 1. TASK: "Create [type] for [purpose]"
> 2. REQUIREMENTS: List all fields with types
> 3. ANNOTATIONS: Specify framework annotations (Lombok, Jackson, etc.)
> 4. PATTERN: "Follow [existing pattern]"
> ```

### Teaching Points

| Prompt Quality | Example | Result |
|----------------|---------|--------|
| ❌ Vague | "Create player stats DTO" | Missing fields, no validation |
| ✅ Explicit | "PlayerStatsResponse with totalGamesPlayed (Long), averageScore (Double), use Lombok @Data @Builder..." | Precise, fully annotated DTO |

---

## Demo 3: Comment-Based Generation (10 min)

### Learning Objective
Generate complete functions from descriptive comments placed directly above code.

### Scenario
Add a new API endpoint in `GameScoreController.java` by writing a descriptive comment, then letting Copilot generate the implementation.

### Before Demo: Setup
```bash
code java-spring-boot-backend/src/main/java/com/insight/ai_demo/controller/GameScoreController.java
# Navigate to the end of the class (after getScoreById method)
```

### Live Coding Steps

**Step 1: Write descriptive comment**
```java
    /**
     * Delete all scores for a specific player.
     * This endpoint requires the player name as a path variable.
     * Returns the count of deleted scores.
     * Logs the deletion operation for audit purposes.
     * Returns 404 if player has no scores.
     */
```

**Step 2: Press Enter and type method annotation**
```java
    @DeleteMapping("/player/{playerName}")
    public ResponseEntity<Map<String, Object>> deletePlayerScores(@PathVariable String playerName) {
```

**Expected Copilot Suggestion** (completes the function):
```java
    @DeleteMapping("/player/{playerName}")
    public ResponseEntity<Map<String, Object>> deletePlayerScores(@PathVariable String playerName) {
        log.info("Deleting all scores for player: {}", playerName);
        
        long deletedCount = gameScoreService.deletePlayerScores(playerName);
        
        if (deletedCount == 0) {
            return ResponseEntity.notFound().build();
        }
        
        Map<String, Object> response = Map.of(
            "playerName", playerName,
            "deletedCount", deletedCount,
            "message", String.format("Successfully deleted %d scores for player %s", deletedCount, playerName)
        );
        
        log.info("Deleted {} scores for player: {}", deletedCount, playerName);
        return ResponseEntity.ok(response);
    }
```

**Step 3: Try another endpoint with TypeScript frontend style**
Open `frontend/src/app/api/scoreService.ts` and add:
```typescript
/**
 * Delete all scores for a specific player
 * @param playerName - Name of the player whose scores to delete
 * @returns Count of deleted scores or error
 */
export async function deletePlayerScores(
```

**Expected Copilot Suggestion**:
```typescript
export async function deletePlayerScores(
  playerName: string
): Promise<ApiResponse<{ deletedCount: number }>> {
  const encodedPlayer = encodeURIComponent(playerName);
  return apiFetch<{ deletedCount: number }>(`/api/scores/player/${encodedPlayer}`, {
    method: 'DELETE',
  });
}
```

### Teaching Points

> 💡 **Comment-Based Generation Best Practices**:
> 1. Be specific about parameters and return types
> 2. Mention error handling expectations (404, validation errors)
> 3. Include logging/audit requirements
> 4. Reference HTTP methods and status codes

### Comparison: Comment Quality

```java
// ❌ Too vague - Copilot may generate incorrect implementation
// Delete player scores

// ✅ Detailed - Copilot generates complete, correct implementation
/**
 * Delete all scores for a specific player.
 * This endpoint requires the player name as a path variable.
 * Returns the count of deleted scores.
 * Logs the deletion operation for audit purposes.
 * Returns 404 if player has no scores.
 */
```

---

## Demo 4: Code Explanations (10 min)

### Learning Objective
Use Copilot Chat to understand complex service layer logic and repository query patterns.

### Scenario
Understand the transaction handling and statistics calculation logic in `GameScoreService.java`.

### Before Demo: Setup
```bash
code java-spring-boot-backend/src/main/java/com/insight/ai_demo/service/GameScoreService.java
# Select lines 120-150 (getGameStatistics and related methods)
```

### Live Coding Steps

**Step 1: Select the complex code block**
```java
// Select these lines (120-150):
    /**
     * Get statistics for a game
     */
    @Transactional(readOnly = true)
    public GameStatistics getGameStatistics(String gameName) {
        log.info("Getting statistics for game: {}", gameName);
        long totalScores = gameScoreRepository.countByGameName(gameName);
        List<GameScore> topScores = getTopScoresForGame(gameName, 1);
        Long highestScore = topScores.isEmpty() ? null : topScores.get(0).getScore();
        
        return new GameStatistics(gameName, totalScores, highestScore);
    }
    
    /**
     * Inner class for game statistics
     */
    public static class GameStatistics {
        public final String gameName;
        public final long totalScores;
        public final Long highestScore;
        
        public GameStatistics(String gameName, long totalScores, Long highestScore) {
            this.gameName = gameName;
            this.totalScores = totalScores;
            this.highestScore = highestScore;
        }
    }
```

**Step 2: Open Copilot Chat and ask for explanation**
Press `Cmd+I` (Mac) or `Ctrl+I` (Windows) to open inline chat, then type:

```
/explain Why is @Transactional(readOnly = true) used here? What's the benefit of the inner class pattern?
```

**Expected Copilot Explanation**:
```
This code demonstrates several Spring best practices:

**@Transactional(readOnly = true)**:
- Marks the transaction as read-only, optimizing database performance
- Prevents accidental writes during this method execution
- Hibernate can skip dirty checking for read-only transactions
- Some databases optimize query execution for read-only transactions

**Why call getTopScoresForGame(gameName, 1)?**:
- Reuses existing logic for fetching sorted scores
- Avoids duplicating the ORDER BY query
- Gets just the top 1 score (limit) for efficiency

**Inner Class Pattern (GameStatistics)**:
- Encapsulates related data in a single response object
- Immutable design with `public final` fields
- Keeps statistics-related code localized to the service
- Alternative: Move to a separate DTO class in dto/ package

**Considerations**:
- Could use a record instead: `public record GameStatistics(String gameName, long totalScores, Long highestScore) {}`
- Inner class creates tight coupling with the service
```

**Step 3: Ask follow-up questions**
```
/explain What happens if gameName doesn't exist? How does the repository handle null results?
```

### Teaching Points

> 🔍 **Code Explanation Commands**:
> - `/explain` - Detailed explanation of selected code
> - `/explain performance` - Focus on performance implications
> - `/explain simply` - ELI5 explanation for beginners
> - `Cmd+I` then just ask a question - Contextual Q&A

### Alternative: Hover Explanation
- Hover over `@Transactional` → See inline annotation documentation
- Hover over `@Query` annotations → Understand JPQL syntax

---

## Demo 5: Code Refactoring + Copilot Chat (10 min)

### Learning Objective
Use Copilot Chat to identify and refactor duplicate code across multiple files.

### Scenario
`Leaderboard.tsx` contains hardcoded fallback data and `getIconForRank` logic that could be extracted to a shared utility for reuse across components.

### Before Demo: Setup
```bash
# Open the Leaderboard component
code frontend/src/app/components/Leaderboard.tsx

# Note the fallback data (lines 7-18) and getIconForRank function (lines 20-24)
```

### The Code to Refactor
```typescript
// Fallback data when API is unavailable
const fallbackData = [
  { rank: 1, player: "GhostReaper", score: 145820, kills: 2847, wins: 156, icon: Trophy },
  { rank: 2, player: "ShadowSniper", score: 142150, kills: 2756, wins: 149, icon: Trophy },
  // ... more entries
];

function getIconForRank(rank: number) {
  if (rank <= 3) return Trophy;
  if (rank <= 6) return Medal;
  return Award;
}
```

### Live Coding Steps

**Step 1: Open Copilot Chat panel**
Press `Cmd+Shift+I` (Mac) or `Ctrl+Shift+I` (Windows)

**Step 2: Use @workspace to analyze the codebase**
```
@workspace Are there other components that display player rankings or could benefit from using getIconForRank and fallback leaderboard data?
```

**Expected Response**:
```
Looking at the codebase, I found:
- Leaderboard.tsx: Contains getIconForRank and fallbackData
- The api/types.ts has LeaderboardEntry interface that could be extended
- Other components might need similar ranking display logic

Recommendation: Extract to a shared utility:
- frontend/src/app/utils/leaderboardUtils.ts
```

**Step 3: Ask Copilot to refactor**
```
/refactor Extract getIconForRank function and the fallbackData to a new file frontend/src/app/utils/leaderboardUtils.ts with proper TypeScript types
```

**Expected Copilot Actions** (creates new file):

**New file: `frontend/src/app/utils/leaderboardUtils.ts`**
```typescript
import { Trophy, Medal, Award, type LucideIcon } from 'lucide-react';

/**
 * Leaderboard entry with display properties
 */
export interface LeaderboardEntry {
  rank: number;
  player: string;
  score: number;
  kills?: number;
  wins?: number;
  icon: LucideIcon;
}

/**
 * Get the appropriate icon based on player rank
 * @param rank - Player's position (1-based)
 * @returns Trophy for top 3, Medal for 4-6, Award for others
 */
export function getIconForRank(rank: number): LucideIcon {
  if (rank <= 3) return Trophy;
  if (rank <= 6) return Medal;
  return Award;
}

/**
 * Fallback leaderboard data for when API is unavailable
 */
export const FALLBACK_LEADERBOARD: LeaderboardEntry[] = [
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

/**
 * Format a score with thousands separators
 */
export function formatScore(score: number): string {
  return score.toLocaleString();
}
```

**Updated: `Leaderboard.tsx`**
```typescript
import { Loader2, AlertCircle, RefreshCw } from 'lucide-react';
import { useState, useEffect, useCallback } from 'react';
import { useGame } from '@/app/context/GameContext';
import { getTopScores, type ScoreResponse } from '@/app/api';
import { 
  getIconForRank, 
  FALLBACK_LEADERBOARD, 
  type LeaderboardEntry 
} from '@/app/utils/leaderboardUtils';

// Remove local definitions - now imported
```

### Teaching Points

> 🔧 **Copilot Chat Refactoring Commands**:
> - `/refactor` - General refactoring
> - `/refactor extract` - Extract to function/file
> - `/refactor rename` - Rename with all references
> - `@workspace` - Search across entire codebase

### Verification
```bash
# Verify TypeScript compilation
cd frontend
npm run build

# Check imports are correct
grep -r "getIconForRank" frontend/src/
```

---

## Demo 6: Few-Shot Prompting (10 min)

### Learning Objective
Teach Copilot project-specific patterns by showing 2-3 examples, then asking it to generate similar code.

### Scenario
Create a new `Player` entity with relationships and validation, using the existing `GameScore` entity as a pattern example.

### Before Demo: Setup
```bash
code java-spring-boot-backend/src/main/java/com/insight/ai_demo/entity/GameScore.java
# Review the existing entity pattern
```

### Live Coding Steps

**Step 1: Show Copilot the existing pattern**
Create a new file and write this few-shot prompt:

```java
package com.insight.ai_demo.entity;

/**
 * PATTERN EXAMPLES (Few-Shot Learning):
 * 
 * Example 1: GameScore Entity (existing pattern)
 * - Uses @Entity and @Table(name = "table_name")
 * - Uses Lombok @Data, @NoArgsConstructor, @AllArgsConstructor
 * - Has @Id with @GeneratedValue(strategy = GenerationType.IDENTITY)
 * - Uses @NotBlank and @NotNull for validation
 * - Has @Column annotations with nullable and length constraints
 * - Includes @PrePersist for automatic timestamp handling
 * - Has custom constructors for convenience
 * 
 * Example 2: Existing field patterns
 * - String fields: @Column(nullable = false, length = 100)
 * - Long fields: @Column(nullable = false)
 * - LocalDateTime: @Column(nullable = false, updatable = false) for createdAt
 * 
 * NOW CREATE: Player entity
 * - Fields: id (Long, PK), username (String, unique, max 50), email (String, unique, max 100), 
 *   displayName (String, max 100), createdAt (LocalDateTime), lastLoginAt (LocalDateTime),
 *   totalGamesPlayed (Long, default 0), isActive (Boolean, default true)
 * - Validation: username and email required, email format validation
 * - Follow the GameScore entity pattern exactly
 */
```

**Step 2: Press Enter and let Copilot generate**

**Expected Copilot Suggestion**:
```java
package com.insight.ai_demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "players")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Player {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Username is required")
    @Column(nullable = false, unique = true, length = 50)
    private String username;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    @Column(nullable = false, unique = true, length = 100)
    private String email;
    
    @Column(length = 100)
    private String displayName;
    
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    private LocalDateTime lastLoginAt;
    
    @Column(nullable = false)
    private Long totalGamesPlayed = 0L;
    
    @Column(nullable = false)
    private Boolean isActive = true;
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
    
    // Custom constructor for registration
    public Player(String username, String email, String displayName) {
        this.username = username;
        this.email = email;
        this.displayName = displayName;
        this.totalGamesPlayed = 0L;
        this.isActive = true;
    }
}
```

**Step 3: Copilot should also suggest the repository**
```java
// Create PlayerRepository.java following GameScoreRepository pattern
```

### Teaching Points

> 📚 **Few-Shot Prompting Formula**:
> ```
> Example 1: [Existing pattern with specific details]
> Example 2: [Field/annotation patterns]
> NOW CREATE: [New thing following same pattern]
> ```

### Why Few-Shot Works

| Approach | Prompt | Result |
|----------|--------|--------|
| Zero-shot | "Create Player entity" | May miss validation, wrong annotations |
| Few-shot (2 examples) | "Example 1: GameScore with @Entity, @Data... Example 2: Field patterns... NOW CREATE: Player" | Follows project conventions exactly |

### Verification
```bash
# Build the project to verify entity compiles
cd java-spring-boot-backend
./gradlew compileJava

# Check Hibernate generates correct DDL
./gradlew bootRun
# Check logs for: create table players (...)
```

---

## Demo 7: Unit Testing & Debugging (15 min)

### Learning Objective
Generate test cases with Copilot and debug failing tests using Copilot Chat.

### Scenario
Part A: Generate backend tests for the GameScoreService  
Part B: Debug a failing test in the frontend

### Part A: Backend Tests (JUnit 5 + Spring Boot Test)

**Setup:**
```bash
# Create a new test file
code java-spring-boot-backend/src/test/java/com/insight/ai_demo/service/GameScoreServiceTest.java
```

**Step 1: Ask Copilot to generate tests using comment-based generation**
```java
package com.insight.ai_demo.service;

import com.insight.ai_demo.entity.GameScore;
import com.insight.ai_demo.repository.GameScoreRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GameScoreServiceTest {

    @Mock
    private GameScoreRepository gameScoreRepository;

    @InjectMocks
    private GameScoreService gameScoreService;

    // Test that submitting a score saves it correctly and returns the saved entity
    @Test
    void submitScore_shouldSaveAndReturnScore() {
```

**Expected Copilot Suggestion**:
```java
    @Test
    void submitScore_shouldSaveAndReturnScore() {
        // Arrange
        String playerName = "TestPlayer";
        String gameName = "Operation Nightfall";
        Long score = 50000L;
        LocalDateTime achievedAt = LocalDateTime.now();
        
        GameScore savedScore = new GameScore(playerName, gameName, score, achievedAt);
        savedScore.setId(1L);
        
        when(gameScoreRepository.save(any(GameScore.class))).thenReturn(savedScore);
        
        // Act
        GameScore result = gameScoreService.submitScore(playerName, gameName, score, achievedAt);
        
        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getPlayerName()).isEqualTo(playerName);
        assertThat(result.getGameName()).isEqualTo(gameName);
        assertThat(result.getScore()).isEqualTo(score);
        
        verify(gameScoreRepository, times(1)).save(any(GameScore.class));
    }
```

**Step 2: Generate more tests with comments**
```java
    // Test that getting top scores for a game returns ordered results
    @Test
    void getTopScoresForGame_shouldReturnOrderedScores() {
```

### Part B: Frontend Test - Debugging (Vitest)

**Setup:**
```bash
code frontend/src/app/api/scoreService.test.ts
```

**Step 1: Create a test file and introduce a "bug" for demo**
```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { getTopScores } from './scoreService';

// Mock fetch globally
global.fetch = vi.fn();

describe('scoreService', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should fetch top scores for a game', async () => {
    const mockScores = [
      { id: 1, playerName: 'Player1', gameName: 'TestGame', score: 1000 },
      { id: 2, playerName: 'Player2', gameName: 'TestGame', score: 900 },
    ];

    (global.fetch as any).mockResolvedValueOnce({
      ok: true,
      json: async () => mockScores,
    });

    const result = await getTopScores('TestGame', 10);
    
    // ❌ BUG: Wrong assertion - expecting 3 scores but mock has 2
    expect(result.data?.length).toBe(3);
  });
});
```

**Step 2: Run test and see failure**
```bash
cd frontend
npm test -- scoreService.test.ts

# Output:
# FAILED - AssertionError: expected 2 to be 3
```

**Step 3: Use Copilot to debug**
Select the failing test, open Copilot Chat (`Cmd+I`):

```
/fix This test is failing because the assertion expects 3 scores but the mock only has 2. Fix the assertion to match the mock data.
```

**Copilot Fix**:
```typescript
    // ✓ Fixed: Match the mock data length
    expect(result.data?.length).toBe(2);
```

### Teaching Points

> 🧪 **Testing Commands**:
> - `/tests` - Generate tests for selected code
> - `/fix` - Fix failing test or code
> - `@workspace /tests` - Generate tests based on project patterns

### Test Generation Prompt Tips

```java
// ❌ Vague - generates generic tests
// Test the service

// ✅ Specific - generates targeted tests
// Test that submitting a score with null achievedAt uses current timestamp
// and verify the repository save method is called exactly once
```

---

## Demo 8: Privacy & Data Handling (5 min)

### Learning Objective
Understand how GitHub Copilot handles your code, what data is collected, and privacy best practices.

### Key Privacy Concepts

**What Copilot DOES access:**
- Code in your currently open files (context for suggestions)
- Comments and docstrings you write
- File names and paths in your workspace
- Recent code changes for context

**What Copilot does NOT do:**
- Store your private code permanently (for individual plans)
- Train models on your private code (configurable by organization)
- Share your code with other users
- Access files outside your workspace

### Understanding Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    YOUR VS CODE EDITOR                       │
├─────────────────────────────────────────────────────────────┤
│  [Open File Context] → Sent to Copilot for suggestions      │
│  [Comments/Prompts] → Used to generate completions          │
│  [Accepted Code] → Stays in your local workspace            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                   GITHUB COPILOT SERVICE                     │
├─────────────────────────────────────────────────────────────┤
│  • Processes requests in real-time                          │
│  • Does NOT store code from Individual plans                │
│  • Organization admins control data retention policies      │
│  • Telemetry is anonymized and aggregated                  │
└─────────────────────────────────────────────────────────────┘
```

### Privacy Settings to Know

**VS Code Settings (`Cmd+,` → Search "copilot"):**
```json
{
  // Control what files Copilot can access
  "github.copilot.enable": {
    "*": true,
    "plaintext": false,     // Disable for plain text files
    "markdown": true,
    "yaml": true
  }
}
```

**Organization-Level Controls:**
- Admins can enable/disable Copilot for repos
- Code retention policies are configurable
- "No code retention" mode available for sensitive projects

### Best Practices for Sensitive Projects

```java
// ✅ DO: Use placeholder values in examples
String apiKey = "YOUR_API_KEY_HERE";

// ❌ DON'T: Include real credentials in comments
// String apiKey = "sk-real-key-abc123"; // Copilot sees this!

// ✅ DO: Use environment variables  
String apiKey = System.getenv("API_KEY");
```

### Teaching Points

> 🔒 **Privacy Quick Reference**:
> - Copilot Individual: No code retention
> - Copilot Business: Admin-configurable retention
> - Your code is NOT used to train public models
> - Use `.gitignore` patterns - Copilot respects them for file context

### Resources
- [GitHub Copilot Trust Center](https://resources.github.com/copilot-trust-center/)
- [GitHub Copilot Privacy FAQ](https://docs.github.com/en/copilot/overview-of-github-copilot/about-github-copilot-individual#about-privacy-and-github-copilot)

---

## Demo 9: Copilot CLI (10 min)

### Learning Objective
Use GitHub Copilot CLI to generate shell commands and scripts from natural language.

### Scenario
Generate Docker and Gradle commands for the high-scores-demo project without memorizing complex CLI syntax.

### Prerequisites
```bash
# Verify Copilot CLI is installed
gh copilot --version

# If not installed:
gh extension install github/gh-copilot
```

### Live Coding Steps

**Step 1: Ask Copilot CLI to explain a command**
```bash
gh copilot explain "docker-compose up --build -d"
```

**Expected Explanation**:
```
This command manages Docker Compose services:

- `docker-compose up`: Start containers defined in docker-compose.yml
- `--build`: Rebuild images before starting containers
- `-d`: Run in detached mode (background)

This is useful for starting the entire application stack
(frontend, backend, database) in one command.
```

**Step 2: Generate a command from natural language**
```bash
gh copilot suggest "run gradle bootRun with prod profile and debug logging"
```

**Expected Suggestion**:
```bash
./gradlew bootRun --args='--spring.profiles.active=prod --logging.level.root=DEBUG'
```

**Step 3: Generate Docker commands for the project**
```bash
gh copilot suggest "build the docker image for java-spring-boot-backend and tag it as high-scores-api:latest"
```

**Expected Suggestion**:
```bash
docker build -t high-scores-api:latest ./java-spring-boot-backend
```

**Step 4: Generate a complete deployment script**
```bash
gh copilot suggest "create a bash script that builds both frontend and backend docker images, then runs docker-compose up"
```

**Expected Script**:
```bash
#!/bin/bash
set -e

echo "Building backend image..."
docker build -t high-scores-backend:latest ./java-spring-boot-backend

echo "Building frontend image..."
docker build -t high-scores-frontend:latest ./frontend

echo "Starting services with docker-compose..."
docker-compose up -d

echo "✓ All services started"
docker-compose ps
```

### Teaching Points

> 💻 **Copilot CLI Commands**:
> - `gh copilot suggest "..."` - Generate command from description
> - `gh copilot explain "..."` - Explain what a command does
> - `ghcs` - Shortcut for `gh copilot suggest`
> - `ghce` - Shortcut for `gh copilot explain`

### Practical Examples for This Project

| Natural Language | Generated Command |
|-----------------|-------------------|
| "Run Spring Boot tests with coverage" | `./gradlew test jacocoTestReport` |
| "Start postgres container for local dev" | `docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=pass postgres:15` |
| "Check what's running on port 8080" | `lsof -i :8080` |
| "Tail the docker logs for backend" | `docker-compose logs -f java-spring-boot-backend` |
| "Run frontend dev server" | `cd frontend && npm run dev` |

### Alias Setup (Optional)
```bash
# Add to ~/.zshrc or ~/.bashrc
alias ghcs='gh copilot suggest'
alias ghce='gh copilot explain'

# Usage:
ghcs "find all Java files with TODO comments"
ghce "grep -r TODO --include='*.java' ."
```

---

## Workshop Summary & Key Takeaways

### Techniques Comparison Matrix

| Technique | When to Use | Trigger | Example |
|-----------|-------------|---------|---------|
| **Inline Suggestions** | Pattern-based code | Just type | Repository methods, entity fields |
| **Prompting** | Complex requirements | Docstring/comment | DTOs with validation and annotations |
| **Comment-Based** | New functions/endpoints | `/** Description */` + Enter | Controller endpoints, service methods |
| **Code Explanations** | Understanding code | `/explain` or `Cmd+I` | Transaction handling, query logic |
| **Refactoring** | Duplicate/messy code | `/refactor` in Chat | Extract utilities, shared components |
| **Copilot Chat** | Questions, debugging | `Cmd+Shift+I` | "@workspace find...", "/fix" |
| **Few-Shot** | Project patterns | 2-3 examples + request | JPA entities, Spring repositories |
| **Testing** | Test generation | `/tests` or comments | JUnit tests, Vitest mocks |
| **Privacy** | Sensitive code | Settings/awareness | Environment variables, no credentials |
| **CLI** | Shell commands | `gh copilot suggest` | Docker, Gradle, Git commands |

### Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                  COPILOT QUICK REFERENCE                     │
├─────────────────────────────────────────────────────────────┤
│ INLINE SUGGESTIONS                                           │
│   Tab          Accept full suggestion                        │
│   Cmd+→        Accept word-by-word                          │
│   Alt+]        Next suggestion                               │
│   Esc          Dismiss                                       │
├─────────────────────────────────────────────────────────────┤
│ COPILOT CHAT                                                 │
│   Cmd+I        Inline chat (quick question)                  │
│   Cmd+Shift+I  Chat panel (longer conversations)             │
│   /explain     Explain selected code                         │
│   /fix         Fix errors in selection                       │
│   /tests       Generate tests                                │
│   /refactor    Refactor selected code                        │
│   @workspace   Search/query entire codebase                  │
├─────────────────────────────────────────────────────────────┤
│ COPILOT CLI                                                  │
│   gh copilot suggest "..."    Generate command               │
│   gh copilot explain "..."    Explain command                │
│   ghcs / ghce                 Shortcuts                      │
└─────────────────────────────────────────────────────────────┘
```

### Common Pitfalls to Avoid

| Pitfall | Solution |
|---------|----------|
| Accepting suggestions blindly | Always review for correctness |
| Vague prompts | Be explicit: list fields, types, validation |
| Ignoring alternatives | Press `Alt+]` to see other options |
| Not using few-shot for patterns | Show 2-3 examples for project-specific code |
| Skipping test verification | Always run tests after generation |
| Including secrets in comments | Use environment variables, check privacy settings |

---

## Next Workshop Preview

**Workshop 3: Advanced Web Development**
- **Copilot Edits**: Multi-file changes in one operation
- **Custom Instructions**: Project-specific `.github/copilot-instructions.md`
- **Agent Mode**: Autonomous multi-step workflows
- **Workspace Agents**: `@workspace`, `@vscode`, `@terminal`
- **MCP Servers**: Connecting to external tools and APIs

**Preparation**:
- Review `.github/copilot-instructions.md` 
- Explore Copilot Edits panel (`Cmd+Shift+I` → Edits tab)
- Read project README.md files for context

---

## Hands-On Exercise (Optional - 15 min)

**Challenge**: Use ALL techniques from this workshop to add a "Player Achievements" feature.

1. **Inline Suggestions**: Add new repository methods for achievements
2. **Comment-Based**: Create `/api/achievements` endpoint with JavaDoc comment
3. **Few-Shot**: Create `Achievement` entity using GameScore/Player examples
4. **Refactoring**: Extract common response mapping logic in controller
5. **Testing**: Generate JUnit test for achievement service
6. **CLI**: Generate command to query achievements via curl

**Verification**:
```bash
# Backend
cd java-spring-boot-backend
./gradlew test

# Frontend  
cd frontend
npm test
```

---

## Resources

- **GitHub Copilot Docs**: https://docs.github.com/en/copilot
- **Copilot CLI**: https://githubnext.com/projects/copilot-cli
- **Copilot Trust Center**: https://resources.github.com/copilot-trust-center/
- **Spring Boot Docs**: https://spring.io/projects/spring-boot
- **Vitest Docs**: https://vitest.dev/
- **JUnit 5 Docs**: https://junit.org/junit5/

**Questions?** Proceed to Workshop 3 or ask for clarification.
