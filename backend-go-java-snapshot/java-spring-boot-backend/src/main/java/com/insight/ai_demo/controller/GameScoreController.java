package com.insight.ai_demo.controller;

import com.insight.ai_demo.dto.ScoreSubmissionRequest;
import com.insight.ai_demo.dto.ScoreResponse;
import com.insight.ai_demo.entity.GameScore;
import com.insight.ai_demo.service.GameScoreService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/scores")
@RequiredArgsConstructor
@Slf4j
public class GameScoreController {
    
    private final GameScoreService gameScoreService;
    
    /**
     * Submit a new high score
     */
    @PostMapping("/submit")
    public ResponseEntity<ScoreResponse> submitScore(@Valid @RequestBody ScoreSubmissionRequest request) {
        log.info("Received score submission: {}", request);
        
        GameScore savedScore = gameScoreService.submitScore(
            request.getPlayerName(),
            request.getGameName(),
            request.getScore(),
            request.getAchievedAt()
        );
        
        ScoreResponse response = new ScoreResponse(savedScore);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
    
    /**
     * Get all scores for a specific player
     */
    @GetMapping("/player/{playerName}")
    public ResponseEntity<Map<String, Object>> getPlayerScores(
            @PathVariable String playerName,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        log.info("Getting scores for player: {} (page: {}, size: {})", playerName, page, size);
        
        Page<GameScore> scores = gameScoreService.getPlayerScores(playerName, page, size);
        List<ScoreResponse> scoreResponses = scores.getContent().stream()
                .map(ScoreResponse::new)
                .collect(Collectors.toList());
        
        Map<String, Object> response = Map.of(
            "scores", scoreResponses,
            "totalElements", scores.getTotalElements(),
            "totalPages", scores.getTotalPages(),
            "currentPage", page,
            "pageSize", size,
            "hasNext", scores.hasNext(),
            "hasPrevious", scores.hasPrevious()
        );
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get top N scores for a specific game
     */
    @GetMapping("/game/{gameName}/top")
    public ResponseEntity<List<ScoreResponse>> getTopScoresForGame(
            @PathVariable String gameName,
            @RequestParam(defaultValue = "10") int limit) {
        
        log.info("Getting top {} scores for game: {}", limit, gameName);
        
        List<GameScore> topScores = gameScoreService.getTopScoresForGame(gameName, limit);
        List<ScoreResponse> response = topScores.stream()
                .map(ScoreResponse::new)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get all scores for a specific game with pagination
     */
    @GetMapping("/game/{gameName}")
    public ResponseEntity<Map<String, Object>> getGameScores(
            @PathVariable String gameName,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        log.info("Getting all scores for game: {} (page: {}, size: {})", gameName, page, size);
        
        Page<GameScore> scores = gameScoreService.getGameScores(gameName, page, size);
        List<ScoreResponse> scoreResponses = scores.getContent().stream()
                .map(ScoreResponse::new)
                .collect(Collectors.toList());
        
        Map<String, Object> response = Map.of(
            "scores", scoreResponses,
            "totalElements", scores.getTotalElements(),
            "totalPages", scores.getTotalPages(),
            "currentPage", page,
            "pageSize", size,
            "hasNext", scores.hasNext(),
            "hasPrevious", scores.hasPrevious()
        );
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get scores for a specific player in a specific game
     */
    @GetMapping("/player/{playerName}/game/{gameName}")
    public ResponseEntity<Map<String, Object>> getPlayerGameScores(
            @PathVariable String playerName,
            @PathVariable String gameName,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        log.info("Getting scores for player: {} in game: {} (page: {}, size: {})", 
                playerName, gameName, page, size);
        
        Page<GameScore> scores = gameScoreService.getPlayerGameScores(playerName, gameName, page, size);
        List<ScoreResponse> scoreResponses = scores.getContent().stream()
                .map(ScoreResponse::new)
                .collect(Collectors.toList());
        
        Map<String, Object> response = Map.of(
            "scores", scoreResponses,
            "totalElements", scores.getTotalElements(),
            "totalPages", scores.getTotalPages(),
            "currentPage", page,
            "pageSize", size,
            "hasNext", scores.hasNext(),
            "hasPrevious", scores.hasPrevious()
        );
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get all available games
     */
    @GetMapping("/games")
    public ResponseEntity<List<String>> getAllGames() {
        log.info("Getting all available games");
        List<String> games = gameScoreService.getAllGames();
        return ResponseEntity.ok(games);
    }
    
    /**
     * Get all players
     */
    @GetMapping("/players")
    public ResponseEntity<List<String>> getAllPlayers() {
        log.info("Getting all players");
        List<String> players = gameScoreService.getAllPlayers();
        return ResponseEntity.ok(players);
    }
    
    /**
     * Get highest score for a player in a specific game
     */
    @GetMapping("/player/{playerName}/game/{gameName}/high-score")
    public ResponseEntity<Map<String, Object>> getPlayerHighScore(
            @PathVariable String playerName,
            @PathVariable String gameName) {
        
        log.info("Getting high score for player: {} in game: {}", playerName, gameName);
        
        Optional<Long> highScore = gameScoreService.getPlayerHighScore(playerName, gameName);
        
        if (highScore.isPresent()) {
            Map<String, Object> response = Map.of(
                "playerName", playerName,
                "gameName", gameName,
                "highScore", highScore.get()
            );
            return ResponseEntity.ok(response);
        } else {
            Map<String, Object> response = Map.of(
                "playerName", playerName,
                "gameName", gameName,
                "message", "No scores found for this player in this game"
            );
            return ResponseEntity.ok(response);
        }
    }
    
    /**
     * Get statistics for a specific game
     */
    @GetMapping("/game/{gameName}/stats")
    public ResponseEntity<GameScoreService.GameStatistics> getGameStatistics(@PathVariable String gameName) {
        log.info("Getting statistics for game: {}", gameName);
        GameScoreService.GameStatistics stats = gameScoreService.getGameStatistics(gameName);
        return ResponseEntity.ok(stats);
    }
    
    /**
     * Get statistics for a specific player
     */
    @GetMapping("/player/{playerName}/stats")
    public ResponseEntity<GameScoreService.PlayerStatistics> getPlayerStatistics(@PathVariable String playerName) {
        log.info("Getting statistics for player: {}", playerName);
        GameScoreService.PlayerStatistics stats = gameScoreService.getPlayerStatistics(playerName);
        return ResponseEntity.ok(stats);
    }
    
    /**
     * Get a specific score by ID
     */
    @GetMapping("/id/{id}")
    public ResponseEntity<ScoreResponse> getScoreById(@PathVariable Long id) {
        log.info("Getting score by ID: {}", id);
        
        Optional<GameScore> score = gameScoreService.getScoreById(id);
        
        if (score.isPresent()) {
            ScoreResponse response = new ScoreResponse(score.get());
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}