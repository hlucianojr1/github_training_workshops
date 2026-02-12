# Workshop 2: Intermediate Web Development with GitHub Copilot

**Duration**: 90 minutes  
**Format**: Live coding demonstrations  
**Audience**: Web developers with Copilot foundational knowledge (completed Workshop 1)  
**Prerequisites**: IntelliJ IDEA with GitHub Copilot plugin installed, GitHub Copilot CLI installed

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
9. **Privacy & Data Handling** - Understand Copilot's data handling and privacy controls
10. **Copilot CLI** - Generate shell commands and scripts using natural language

---

## Workshop Agenda

| Time | Demo | Learning Objective | File(s) |
|------|------|-------------------|---------|
| 0-10 min | Demo 1 | **Inline Code Suggestions** | `GameScoreRepository.java` |
| 10-20 min | Demo 2 | **Prompting** (Explicit) | `dto/PlayerStatsResponse.java` |
| 20-30 min | Demo 3 | **Comment-Based Generation** | `GameScoreController.java` |
| 30-40 min | Demo 4 | **Code Explanations** | `GameScoreService.java` |
| 40-50 min | Demo 5 | **Code Refactoring** + **Copilot Chat** | `Leaderboard.tsx`, `types.ts` |
| 50-60 min | Demo 6 | **Few-Shot Prompting** | `entity/Achievement.java` |
| 60-70 min | Demo 7 | **Unit Testing & Debugging** | `GameScoreServiceTest.java` |
| 70-80 min | Demo 8 | **Privacy & Data Handling** | IntelliJ Settings |
| 80-90 min | Demo 9 | **Copilot CLI** | Terminal / `docker-compose.yml` |

---

## Demo 1: Inline Code Suggestions (10 min)

### Learning Objective
Accept and modify Copilot's real-time code completions as you type, using pattern recognition.

### Scenario
Add a new repository method to `GameScoreRepository.java`. Copilot will recognize the Spring Data JPA naming convention and suggest the complete method signature.

### Before Demo: Setup
```bash
# Open the repository file in IntelliJ
# File: java-spring-boot-backend/src/main/java/com/insight/ai_demo/repository/GameScoreRepository.java
```

### Live Coding Steps

**Step 1: Position cursor after last method**
```java
// Navigate to end of GameScoreRepository.java, after countByPlayerName method
// Review existing query method patterns

/**
 * Count total scores for a player
 */
long countByPlayerName(String playerName);

// ← Position cursor here, press Enter
```

**Step 2: Type the beginning of a new method comment**
```java
/**
 * Find scores within a score range for a specific game
 */
```

**Step 3: Start typing the method signature**
```java
List<GameScore> findByGameNameAnd
```

**Expected Copilot Inline Suggestion** (appears as ghost text):
```java
List<GameScore> findByGameNameAndScoreBetweenOrderByScoreDesc(String gameName, Long minScore, Long maxScore);
```

**Step 4: Accept with Tab key**
- Press `Tab` to accept the entire suggestion
- Or use `Ctrl+→` (Windows/Linux) / `⌥→` (Mac) to accept word-by-word

**Step 5: Try another pattern-based method**
```java
/**
 * Find the most recent scores for a player
 */
List<GameScore> findTop5ByPlayerNameOrderBy
```

**Copilot suggests**:
```java
List<GameScore> findTop5ByPlayerNameOrderByCreatedAtDesc(String playerName);
```

### Teaching Points

> 💡 **Key Insight**: Inline suggestions work best when Copilot has context. Spring Data JPA naming conventions provide clear patterns for Copilot to follow.

| Action | Shortcut (Mac) | Shortcut (Windows/Linux) |
|--------|----------------|--------------------------|
| Accept full suggestion | `Tab` | `Tab` |
| Accept next word | `⌥→` | `Ctrl+→` |
| Dismiss suggestion | `Esc` | `Esc` |
| See alternatives | `⌥]` / `⌥[` | `Alt+]` / `Alt+[` |
| Open Copilot completions panel | `⌥\` | `Alt+\` |

### IntelliJ-Specific Tips
- **View all suggestions**: Press `⌥\` (Mac) or `Alt+\` (Windows) to see multiple suggestions in a panel
- **Inline completions appear automatically** as you type when Copilot detects a pattern

### Common Mistakes
- ❌ **Accepting without review**: Always verify the method naming follows Spring Data conventions
- ❌ **Ignoring alternatives**: Press `⌥]` to cycle through multiple suggestions

---

## Demo 2: Prompting - Explicit Prompt Technique (10 min)

### Learning Objective
Write detailed, explicit prompts that generate accurate DTOs with proper validation.

### Scenario
Create a `PlayerStatsResponse` DTO for returning aggregated player statistics. The explicit prompt technique specifies requirements, types, and validation rules upfront.

### Before Demo: Setup
```bash
# Create new file in IntelliJ:
# java-spring-boot-backend/src/main/java/com/insight/ai_demo/dto/PlayerStatsResponse.java
```

### Live Coding Steps

**Step 1: Add package and write an explicit prompt as a comment**
```java
package com.insight.ai_demo.dto;

/*
 * Create DTO for aggregated player statistics response.
 * 
 * Requirements:
 * - playerName: String, required - the player's display name
 * - totalGamesPlayed: Integer - count of unique games played
 * - totalScore: Long - sum of all scores across all games  
 * - averageScore: Double - average score rounded to 2 decimal places
 * - highestScore: Long - the player's personal best score
 * - highestScoreGame: String - game name where highest score was achieved
 * - gamesPlayed: List<String> - list of unique game names
 * - lastPlayedAt: LocalDateTime - timestamp of most recent score
 * 
 * Implementation:
 * - Use Lombok @Data annotation
 * - Include @Builder for flexible construction
 * - Add constructor that takes individual statistics
 * - Follow project pattern: use existing ScoreResponse as reference
 */
```

**Step 2: Press Enter and let Copilot generate**

**Expected Copilot Suggestion**:
```java
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlayerStatsResponse {
    
    private String playerName;
    private Integer totalGamesPlayed;
    private Long totalScore;
    private Double averageScore;
    private Long highestScore;
    private String highestScoreGame;
    private List<String> gamesPlayed;
    private LocalDateTime lastPlayedAt;
    
    /**
     * Calculate average score rounded to 2 decimal places
     */
    public Double getAverageScore() {
        if (averageScore == null) return 0.0;
        return Math.round(averageScore * 100.0) / 100.0;
    }
}
```

### Prompting Formula

> 📝 **Explicit Prompting Formula**:
> ```
> 1. TASK: "Create [type] for [purpose]"
> 2. REQUIREMENTS: List all fields with types and descriptions
> 3. IMPLEMENTATION: Annotations, patterns, references
> 4. PATTERN: "Follow [existing pattern]" or "Use [reference file]"
> ```

### Teaching Points

| Prompt Quality | Example | Result |
|----------------|---------|--------|
| ❌ Vague | "Create player stats DTO" | Missing fields, no Lombok |
| ✅ Explicit | "PlayerStats DTO with playerName, totalScore, highestScore, use Lombok @Data @Builder..." | Complete, validated DTO |

---

## Demo 3: Comment-Based Generation (10 min)

### Learning Objective
Generate complete endpoint methods from descriptive comments placed directly above code.

### Scenario
Add a new API endpoint in `GameScoreController.java` for getting player statistics by writing a descriptive comment, then letting Copilot generate the implementation.

### Before Demo: Setup
```bash
# Open GameScoreController.java in IntelliJ
# Navigate to end of file (before closing brace of class)
```

### Live Coding Steps

**Step 1: Write descriptive comment**
```java
    /**
     * Get aggregated statistics for a specific player
     * 
     * Endpoint: GET /api/scores/player/{playerName}/stats
     * Returns: PlayerStatsResponse with:
     *   - Total games played
     *   - Total cumulative score
     *   - Average score across all games
     *   - Highest score achieved
     *   - List of games played
     * 
     * Calls gameScoreService.getPlayerStats(playerName)
     * Uses ResponseEntity for proper HTTP status codes
     */
```

**Step 2: Press Enter and type method annotation**
```java
    @GetMapping("/player/{playerName}/stats")
```

**Expected Copilot Suggestion** (completes the method):
```java
    @GetMapping("/player/{playerName}/stats")
    public ResponseEntity<PlayerStatsResponse> getPlayerStats(@PathVariable String playerName) {
        log.info("Getting statistics for player: {}", playerName);
        
        PlayerStatsResponse stats = gameScoreService.getPlayerStats(playerName);
        
        if (stats == null) {
            return ResponseEntity.notFound().build();
        }
        
        return ResponseEntity.ok(stats);
    }
```

### Teaching Points

> 💡 **Comment-Based Generation Best Practices**:
> 1. Specify the HTTP method and endpoint path
> 2. Describe the return type and its contents
> 3. Mention the service method to call
> 4. Include error handling expectations

### Comparison: Comment Quality

```java
// ❌ Too vague - Copilot may generate incorrect implementation
// Get player stats

// ✅ Detailed - Copilot generates complete, correct implementation
/**
 * Get aggregated statistics for a specific player
 * Endpoint: GET /api/scores/player/{playerName}/stats
 * Returns: PlayerStatsResponse with total games, scores, averages
 * Calls gameScoreService.getPlayerStats(playerName)
 */
```

---

## Demo 4: Code Explanations (10 min)

### Learning Objective
Use Copilot Chat in IntelliJ to understand complex service and transaction logic.

### Scenario
Understand the pagination and transaction handling in `GameScoreService.java`.

### Before Demo: Setup
```bash
# Open GameScoreService.java in IntelliJ
# Select lines 50-75 (getPlayerScores and getTopScoresForGame methods)
```

### Live Coding Steps

**Step 1: Select the complex code block**
```java
// Select these methods:
    /**
     * Get all scores for a specific player with pagination
     */
    @Transactional(readOnly = true)
    public Page<GameScore> getPlayerScores(String playerName, int page, int size) {
        log.info("Getting scores for player: {} (page: {}, size: {})", playerName, page, size);
        Pageable pageable = PageRequest.of(page, size);
        return gameScoreRepository.findByPlayerNameOrderByScoreDesc(playerName, pageable);
    }
    
    /**
     * Get top N scores for a specific game
     */
    @Transactional(readOnly = true)
    public List<GameScore> getTopScoresForGame(String gameName, int limit) {
        log.info("Getting top {} scores for game: {}", limit, gameName);
        Pageable pageable = PageRequest.of(0, limit);
        return gameScoreRepository.findTopScoresByGame(gameName, pageable);
    }
```

**Step 2: Open Copilot Chat and ask for explanation**

In IntelliJ, open Copilot Chat:
- **Mac**: `⌘⇧C` or click the Copilot icon in the right sidebar
- **Windows/Linux**: `Ctrl+Shift+C`

Type in the chat:
```
Explain the selected code. Why is @Transactional(readOnly = true) used here? What's the difference between Page<T> and List<T> return types?
```

**Expected Copilot Explanation**:
```
This code implements paginated data retrieval for game scores:

**@Transactional(readOnly = true)**:
- Marks the method as read-only transaction
- Optimizes database connections (no write locks needed)
- Allows multiple threads to read simultaneously
- Improves performance by skipping dirty checking

**Page<T> vs List<T>**:
- `Page<GameScore>` returns scores + pagination metadata:
  - Total elements, total pages, current page
  - hasNext(), hasPrevious() for navigation
  - Useful for UI pagination components

- `List<GameScore>` returns just the results:
  - No metadata about total count
  - Used when you only need "top N" results
  - Lighter weight response

**PageRequest.of(page, size)**:
- Creates a Pageable object for Spring Data
- page: 0-indexed page number
- size: number of records per page
```

**Step 3: Ask follow-up questions**
```
What happens if a negative page number is passed? How should we handle that?
```

### IntelliJ Copilot Chat Features

> 🔍 **Code Explanation Options in IntelliJ**:
> - Select code + `⌘⇧C` → Opens chat with context
> - Right-click → **Copilot** → **Explain This**
> - Type `/explain` in chat window
> - Ask follow-up questions in the same chat thread

### Alternative: Inline Explanation
- Position cursor on `@Transactional` → Press `F1` (Quick Documentation)
- Copilot can enhance documentation with contextual explanations

---

## Demo 5: Code Refactoring + Copilot Chat (10 min)

### Learning Objective
Use Copilot Chat to identify and refactor duplicate code patterns across multiple files.

### Scenario
The `Leaderboard.tsx` component has rank-based icon logic that could be extracted into a reusable utility for consistent styling across the application.

### Before Demo: Setup
```bash
# Open both files in IntelliJ:
# frontend/src/app/components/Leaderboard.tsx
# frontend/src/app/api/types.ts
```

### The Code to Refactor (in Leaderboard.tsx)
```typescript
function getIconForRank(rank: number) {
  if (rank <= 3) return Trophy;
  if (rank <= 6) return Medal;
  return Award;
}

// And later in JSX (lines 127-142):
<span className={`text-2xl font-bold ${
  index === 0 ? 'text-yellow-400' :
  index === 1 ? 'text-gray-400' :
  index === 2 ? 'text-orange-600' :
  'text-gray-500'
}`}>
```

### Live Coding Steps

**Step 1: Open Copilot Chat panel in IntelliJ**
- **Mac**: `⌘⇧C`
- **Windows/Linux**: `Ctrl+Shift+C`

**Step 2: Ask Copilot to analyze the refactoring opportunity**
```
Looking at Leaderboard.tsx, the rank-based styling logic (getIconForRank, color classes for ranks) is embedded in the component. 

Create a new utility file frontend/src/app/utils/rankUtils.ts that:
1. Exports getIconForRank function
2. Exports getRankColorClass function for text colors
3. Exports getRankBackgroundClass for row highlighting
4. Uses TypeScript with proper typing
```

**Expected Copilot Response** (creates new file):

**New file: `frontend/src/app/utils/rankUtils.ts`**
```typescript
import { Trophy, Medal, Award, type LucideIcon } from 'lucide-react';

/**
 * Rank tier thresholds
 */
export const RANK_TIERS = {
  GOLD: 1,
  SILVER: 2,
  BRONZE: 3,
  TOP_SIX: 6,
} as const;

/**
 * Get the appropriate icon component for a rank position
 * @param rank - 1-based rank position
 */
export function getIconForRank(rank: number): LucideIcon {
  if (rank <= 3) return Trophy;
  if (rank <= 6) return Medal;
  return Award;
}

/**
 * Get the text color class for a rank position
 * @param rank - 1-based rank position
 */
export function getRankColorClass(rank: number): string {
  switch (rank) {
    case 1: return 'text-yellow-400'; // Gold
    case 2: return 'text-gray-400';   // Silver
    case 3: return 'text-orange-600'; // Bronze
    default: return 'text-gray-500';
  }
}

/**
 * Get the background class for a leaderboard row
 * @param rank - 1-based rank position
 */
export function getRankBackgroundClass(rank: number): string {
  if (rank <= 3) {
    return 'bg-gradient-to-r from-yellow-900/10 to-transparent';
  }
  return '';
}

/**
 * Format a score for display with locale-specific thousands separators
 */
export function formatScore(score: number): string {
  return score.toLocaleString();
}
```

**Step 3: Ask Copilot to update Leaderboard.tsx**
```
Now update Leaderboard.tsx to import and use these utilities from rankUtils.ts, removing the duplicate logic
```

**Updated: `Leaderboard.tsx`**
```typescript
import { Loader2, AlertCircle, RefreshCw } from 'lucide-react';
import { 
  getIconForRank, 
  getRankColorClass, 
  getRankBackgroundClass, 
  formatScore 
} from '@/app/utils/rankUtils';

// Remove local getIconForRank function
// Update JSX to use imported utilities:
<span className={`text-2xl font-bold ${getRankColorClass(entry.rank)}`}>
  {entry.rank}
</span>
```

### Teaching Points

> 🔧 **Copilot Chat Refactoring in IntelliJ**:
> - Select code → Right-click → **Copilot** → **Refactor This**
> - Use chat to describe the refactoring goal
> - Copilot suggests file structure and implementation
> - Apply changes using IntelliJ's diff view

### Verification
```bash
cd frontend
npm run build  # Verify no TypeScript errors
npm run dev    # Test the UI still works
```

---

## Demo 6: Few-Shot Prompting (10 min)

### Learning Objective
Teach Copilot project-specific patterns by showing 2-3 examples, then asking it to generate similar code.

### Scenario
Create a new `Achievement` entity following the existing `GameScore` entity pattern.

### Before Demo: Setup
```bash
# Open GameScore.java in IntelliJ for reference
# Create new file: entity/Achievement.java
```

### Live Coding Steps

**Step 1: Show Copilot the existing pattern**
```java
package com.insight.ai_demo.entity;

/*
 * PATTERN EXAMPLES (Few-Shot Learning):
 * 
 * Example 1: GameScore entity structure
 * - @Entity with @Table(name = "game_scores")
 * - @Data @NoArgsConstructor @AllArgsConstructor from Lombok
 * - @Id with @GeneratedValue(strategy = GenerationType.IDENTITY)
 * - Fields: playerName, gameName, score with @NotBlank/@NotNull validation
 * - Timestamps: achievedAt, createdAt with @PrePersist
 * - Custom constructors for API convenience
 * 
 * Example 2: Existing validation pattern
 * - @NotBlank(message = "...") for String fields
 * - @NotNull(message = "...") for required objects
 * - @Column(nullable = false, length = 100) for constraints
 * 
 * NOW CREATE: Achievement entity for player achievements/badges
 * Fields:
 * - id: Long (auto-generated)
 * - playerName: String (required, max 100 chars)
 * - achievementName: String (required, e.g., "First Victory", "Score Master")
 * - achievementType: String (e.g., "BRONZE", "SILVER", "GOLD", "PLATINUM")
 * - gameName: String (optional - null means global achievement)
 * - description: String (required, max 500 chars)
 * - pointsAwarded: Integer (required, default 0)
 * - unlockedAt: LocalDateTime (when achievement was earned)
 * - createdAt: LocalDateTime (record creation timestamp)
 * 
 * Follow the exact same patterns as GameScore entity.
 */
```

**Step 2: Press Enter and let Copilot generate**

**Expected Copilot Suggestion**:
```java
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "achievements")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Achievement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Player name is required")
    @Column(nullable = false, length = 100)
    private String playerName;
    
    @NotBlank(message = "Achievement name is required")
    @Column(nullable = false, length = 100)
    private String achievementName;
    
    @NotBlank(message = "Achievement type is required")
    @Column(nullable = false, length = 20)
    private String achievementType;
    
    @Column(length = 100)
    private String gameName;  // Nullable - null means global achievement
    
    @NotBlank(message = "Description is required")
    @Column(nullable = false, length = 500)
    private String description;
    
    @NotNull(message = "Points awarded is required")
    @Column(nullable = false)
    private Integer pointsAwarded = 0;
    
    @NotNull
    @Column(nullable = false)
    private LocalDateTime unlockedAt;
    
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (unlockedAt == null) {
            unlockedAt = LocalDateTime.now();
        }
    }
    
    // Custom constructor for API requests
    public Achievement(String playerName, String achievementName, String achievementType, 
                       String description, Integer pointsAwarded) {
        this.playerName = playerName;
        this.achievementName = achievementName;
        this.achievementType = achievementType;
        this.description = description;
        this.pointsAwarded = pointsAwarded;
        this.unlockedAt = LocalDateTime.now();
    }
}
```

### Teaching Points

> 📚 **Few-Shot Prompting Formula**:
> ```
> Example 1: [Existing pattern with details]
> Example 2: [Another existing pattern/aspect]
> NOW CREATE: [New thing following same pattern]
> ```

### Why Few-Shot Works

| Approach | Prompt | Result |
|----------|--------|--------|
| Zero-shot | "Create Achievement entity" | May miss Lombok, wrong validation patterns |
| Few-shot (2 examples) | "Example 1: GameScore pattern... Example 2: Validation pattern... NOW CREATE: Achievement" | Follows project conventions exactly |

### Verification
```bash
cd java-spring-boot-backend
./gradlew compileJava  # Verify no compilation errors
```

---

## Demo 7: Unit Testing & Debugging (10 min)

### Learning Objective
Generate test cases with Copilot and debug failing tests using Copilot Chat in IntelliJ.

### Scenario
Create unit tests for `GameScoreService` and use Copilot to debug any failing tests.

### Before Demo: Setup
```bash
# Create new test file in IntelliJ:
# java-spring-boot-backend/src/test/java/com/insight/ai_demo/service/GameScoreServiceTest.java
```

### Live Coding Steps

**Step 1: Write test class header with context comment**
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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for GameScoreService
 * 
 * Test scenarios needed:
 * 1. submitScore - should save and return new score
 * 2. submitScore - should trim whitespace from player/game names
 * 3. getTopScoresForGame - should return top N scores ordered by score desc
 * 4. getPlayerScores - should return paginated results
 * 5. getAllGames - should return distinct game names
 */
@ExtendWith(MockitoExtension.class)
class GameScoreServiceTest {
    
    @Mock
    private GameScoreRepository gameScoreRepository;
    
    @InjectMocks
    private GameScoreService gameScoreService;
    
    private GameScore testScore;
    
    @BeforeEach
    void setUp() {
        testScore = new GameScore();
        testScore.setId(1L);
        testScore.setPlayerName("TestPlayer");
        testScore.setGameName("Operation Nightfall");
        testScore.setScore(10000L);
        testScore.setAchievedAt(LocalDateTime.now());
        testScore.setCreatedAt(LocalDateTime.now());
    }
```

**Step 2: Let Copilot generate the first test**
Type the test method signature and let Copilot complete:

```java
    @Test
    void submitScore_shouldSaveAndReturnNewScore() {
```

**Expected Copilot Suggestion**:
```java
    @Test
    void submitScore_shouldSaveAndReturnNewScore() {
        // Arrange
        when(gameScoreRepository.save(any(GameScore.class))).thenReturn(testScore);
        
        // Act
        GameScore result = gameScoreService.submitScore(
            "TestPlayer", 
            "Operation Nightfall", 
            10000L, 
            LocalDateTime.now()
        );
        
        // Assert
        assertNotNull(result);
        assertEquals("TestPlayer", result.getPlayerName());
        assertEquals("Operation Nightfall", result.getGameName());
        assertEquals(10000L, result.getScore());
        verify(gameScoreRepository, times(1)).save(any(GameScore.class));
    }
```

**Step 3: Generate test for trimming whitespace**
```java
    @Test
    void submitScore_shouldTrimWhitespaceFromNames() {
```

**Expected Copilot Suggestion**:
```java
    @Test
    void submitScore_shouldTrimWhitespaceFromNames() {
        // Arrange
        when(gameScoreRepository.save(any(GameScore.class))).thenAnswer(invocation -> {
            GameScore saved = invocation.getArgument(0);
            saved.setId(1L);
            return saved;
        });
        
        // Act
        GameScore result = gameScoreService.submitScore(
            "  TestPlayer  ", 
            "  Operation Nightfall  ", 
            10000L, 
            null
        );
        
        // Assert
        assertEquals("TestPlayer", result.getPlayerName());
        assertEquals("Operation Nightfall", result.getGameName());
    }
```

**Step 4: Run tests and debug with Copilot**
```bash
# Run tests in IntelliJ: Right-click → Run 'GameScoreServiceTest'
# Or use terminal:
./gradlew test --tests GameScoreServiceTest
```

**Step 5: If a test fails, use Copilot to debug**
Select the failing test + error message, open Copilot Chat:
```
This test is failing with: [paste error message]
Explain why and suggest a fix.
```

### IntelliJ Testing Integration

> 🧪 **Testing Commands in IntelliJ**:
> - Right-click test class → **Generate** → **Test** (or `⌘N`)
> - Select code → **Copilot** → **Generate Tests**
> - Use Copilot Chat: "Write unit tests for the selected method"
> - Run with coverage: `⌘⇧F10` (Mac) / `Ctrl+Shift+F10` (Windows)

### Test Generation Tips

```java
// ❌ Vague comment - generates basic tests
// Test the service

// ✅ Specific comment - generates comprehensive tests
/**
 * Test scenarios needed:
 * 1. submitScore - should save and return new score
 * 2. submitScore - should trim whitespace from player/game names
 * 3. submitScore - should use current time if achievedAt is null
 */
```

---

## Demo 8: Privacy & Data Handling (10 min)

### Learning Objective
Understand how GitHub Copilot handles your code data and configure privacy settings in IntelliJ.

### Key Privacy Concepts

**What Copilot DOES send to GitHub servers:**
- Code context around your cursor (for suggestions)
- Your prompts in Copilot Chat
- File content you explicitly share

**What Copilot does NOT do (for business/individual plans):**
- Store your code for training AI models
- Share your code with other users
- Access private repositories you haven't opened

### IntelliJ Privacy Settings

**Step 1: Access Copilot Settings**
```
IntelliJ IDEA → Settings/Preferences (⌘, on Mac)
→ Tools → GitHub Copilot
```

**Step 2: Review Privacy Options**

| Setting | Description | Recommendation |
|---------|-------------|----------------|
| **Allow Copilot completions** | Enable/disable suggestions | Keep enabled |
| **Enable Copilot Chat** | Enable/disable chat feature | Keep enabled |
| **Allow telemetry** | Send usage data to GitHub | Your choice |

**Step 3: Content Exclusions (Enterprise)**
For GitHub Copilot Business/Enterprise, admins can configure:
- Repository-level exclusions
- File pattern exclusions (e.g., `*.env`, `*secret*`)
- Organization-wide policies

### Code That Should Not Be Shared

> ⚠️ **Best Practices for Sensitive Code**:
> 1. Never put secrets/API keys in code files
> 2. Use environment variables for sensitive data
> 3. Add sensitive files to `.gitignore`
> 4. Use content exclusions for compliance requirements

### Example: Secure Configuration Pattern

```java
// ❌ BAD - Hardcoded secrets (Copilot will see this)
private static final String API_KEY = "sk-abc123secret";

// ✅ GOOD - Environment variables (secret not in code)
private final String apiKey = System.getenv("API_KEY");
```

### Privacy in This Project

The high-scores-demo project follows best practices:
```properties
# application-prod.properties uses environment variables:
spring.datasource.url=${DATABASE_URL}
spring.datasource.username=${DATABASE_USERNAME}
spring.datasource.password=${DATABASE_PASSWORD}
```

### Teaching Points

> 🔒 **Privacy Quick Facts**:
> - Copilot Individual: Code not used for training
> - Copilot Business: Enhanced privacy, admin controls
> - Copilot Enterprise: Content exclusions, audit logs
> - All plans: Code processed but not stored long-term

---

## Demo 9: Copilot CLI (10 min)

### Learning Objective
Use GitHub Copilot CLI to generate shell commands and scripts from natural language.

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
gh copilot explain "docker-compose up --build -d && docker-compose logs -f backend"
```

**Expected Explanation**:
```
This command does two things in sequence:

1. `docker-compose up --build -d`:
   - `up`: Start containers defined in docker-compose.yml
   - `--build`: Rebuild images before starting
   - `-d`: Run in detached mode (background)

2. `docker-compose logs -f backend`:
   - `logs`: Show container logs
   - `-f`: Follow log output (stream new logs)
   - `backend`: Only show logs from the backend service

Use this to rebuild and restart your stack, then 
monitor the backend service logs.
```

**Step 2: Generate a command from natural language**
```bash
gh copilot suggest "check if the spring boot backend is healthy on port 8080"
```

**Expected Suggestion**:
```bash
curl -s http://localhost:8080/actuator/health | jq .
# or simpler:
curl -f http://localhost:8080/actuator/health && echo "Backend is healthy"
```

**Step 3: Generate a deployment script**
```bash
gh copilot suggest "create a bash script that builds the frontend docker image, tags it for a registry, and shows the image size"
```

**Expected Script**:
```bash
#!/bin/bash
set -e

REGISTRY="${REGISTRY:-localhost:5000}"
IMAGE_NAME="high-scores-frontend"
TAG="${TAG:-latest}"

echo "Building frontend image..."
docker build -t ${IMAGE_NAME}:${TAG} ./frontend

echo "Tagging for registry..."
docker tag ${IMAGE_NAME}:${TAG} ${REGISTRY}/${IMAGE_NAME}:${TAG}

echo "Image details:"
docker images ${IMAGE_NAME}:${TAG} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo "✓ Build complete: ${REGISTRY}/${IMAGE_NAME}:${TAG}"
```

**Step 4: Get help with Gradle commands**
```bash
gh copilot suggest "run spring boot tests with coverage report using gradle"
```

**Expected Suggestion**:
```bash
cd java-spring-boot-backend && ./gradlew test jacocoTestReport
# Coverage report will be at: build/reports/jacoco/test/html/index.html
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
| "Start the full stack locally" | `./run-docker.sh` or `docker-compose up --build` |
| "View backend API logs" | `docker-compose logs -f backend` |
| "Run backend tests" | `cd java-spring-boot-backend && ./gradlew test` |
| "Check what's running on port 8080" | `lsof -i :8080` |
| "Build frontend for production" | `cd frontend && npm run build` |
| "Connect to the postgres database" | `docker exec -it high-scores-db psql -U postgres -d highscores` |

---

## Workshop Summary & Key Takeaways

### Techniques Comparison Matrix

| Technique | When to Use | IntelliJ Trigger | Example |
|-----------|-------------|------------------|---------|
| **Inline Suggestions** | Pattern-based code | Just type | Repository methods, entity fields |
| **Prompting** | Complex requirements | Detailed comment | DTOs with validation |
| **Comment-Based** | New methods/endpoints | `/** ... */` + Enter | Controller endpoints |
| **Code Explanations** | Understanding code | Select + `⌘⇧C` | Service transaction logic |
| **Refactoring** | Duplicate/messy code | Copilot Chat | Extract utilities |
| **Copilot Chat** | Questions, debugging | `⌘⇧C` | "@workspace find...", debug |
| **Few-Shot** | Project patterns | Examples + request | New entities matching existing |
| **Testing** | Test generation | Right-click → Generate | JUnit tests with Mockito |
| **Privacy** | Sensitive code | Settings → Copilot | Content exclusions |
| **CLI** | Shell commands | `gh copilot suggest` | Docker, Gradle, deployment |

### Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│           COPILOT QUICK REFERENCE (IntelliJ)                │
├─────────────────────────────────────────────────────────────┤
│ INLINE SUGGESTIONS                                          │
│   Tab              Accept full suggestion                   │
│   ⌥→ / Ctrl+→      Accept word-by-word                     │
│   ⌥] / Alt+]       Next suggestion                         │
│   ⌥\ / Alt+\       Open completions panel                  │
│   Esc              Dismiss                                  │
├─────────────────────────────────────────────────────────────┤
│ COPILOT CHAT                                                │
│   ⌘⇧C / Ctrl+Shift+C    Open Copilot Chat                  │
│   Select + Chat         Context-aware questions             │
│   Right-click           Copilot menu options                │
├─────────────────────────────────────────────────────────────┤
│ COPILOT CLI                                                 │
│   gh copilot suggest "..."    Generate command              │
│   gh copilot explain "..."    Explain command               │
│   ghcs / ghce                 Shortcuts                     │
├─────────────────────────────────────────────────────────────┤
│ INTELLIJ SPECIFIC                                           │
│   ⌘N / Alt+Insert       Generate (tests, constructors)      │
│   ⌘, / Ctrl+Alt+S       Settings (Copilot config)           │
│   F1                    Quick Documentation                 │
└─────────────────────────────────────────────────────────────┘
```

### Common Pitfalls to Avoid

| Pitfall | Solution |
|---------|----------|
| Accepting suggestions blindly | Always review for correctness and project patterns |
| Vague prompts | Be explicit: list fields, types, validation, patterns |
| Ignoring alternatives | Press `⌥]` to see other options |
| Not using few-shot for patterns | Show 2-3 examples for project-specific code |
| Skipping test verification | Always run tests after generation |
| Hardcoding secrets | Use environment variables, add to `.gitignore` |

---

## Next Workshop Preview

**Workshop 3: Advanced Web Development**
- **Copilot Edits**: Multi-file changes in one operation
- **Custom Instructions**: Project-specific `.github/copilot-instructions.md`
- **Agent Mode**: Autonomous multi-step workflows
- **Workspace Context**: Full project understanding
- **MCP Servers**: Connecting to external tools and APIs

**Preparation**:
- Review `.github/copilot-instructions.md` in this project
- Explore Copilot Edits in IntelliJ
- Read `docs/QUICK_REFERENCE.md` for project context

---

## Hands-On Exercise (Optional - 15 min)

**Challenge**: Use ALL techniques from this workshop to add an "Achievement" feature.

1. **Inline Suggestions**: Add `findByPlayerName` method to a new `AchievementRepository`
2. **Comment-Based**: Create `/api/achievements/player/{name}` endpoint with comment
3. **Few-Shot**: Create `AchievementService` using `GameScoreService` as pattern
4. **Refactoring**: Extract common pagination response building
5. **Testing**: Generate tests for achievement creation
6. **CLI**: Generate command to query achievements via curl

**Verification**:
```bash
cd java-spring-boot-backend
./gradlew test
./gradlew bootRun
# Test endpoint:
curl http://localhost:8080/api/achievements/player/TestPlayer
```

---

## Resources

- **GitHub Copilot Docs**: https://docs.github.com/en/copilot
- **Copilot in IntelliJ**: https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-your-ide
- **Copilot CLI**: https://docs.github.com/en/copilot/github-copilot-in-the-cli
- **Privacy Documentation**: https://docs.github.com/en/copilot/using-github-copilot/copilot-individual/about-github-copilot-individual
- **Project Documentation**: `docs/QUICK_REFERENCE.md`

**Questions?** Proceed to Workshop 3 or ask for clarification.
