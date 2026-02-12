package com.insight.ai_demo.service;

import com.insight.ai_demo.entity.GameScore;
import com.insight.ai_demo.repository.GameScoreRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class GameScoreService {
    
    private final GameScoreRepository gameScoreRepository;
    
    /**
     * Submit a new high score
     */
    public GameScore submitScore(String playerName, String gameName, Long score, LocalDateTime achievedAt) {
        log.info("Submitting score for player: {}, game: {}, score: {}", playerName, gameName, score);
        
        GameScore gameScore = new GameScore();
        gameScore.setPlayerName(playerName.trim());
        gameScore.setGameName(gameName.trim());
        gameScore.setScore(score);
        gameScore.setAchievedAt(achievedAt != null ? achievedAt : LocalDateTime.now());
        
        GameScore saved = gameScoreRepository.save(gameScore);
        log.info("Score submitted successfully with ID: {}", saved.getId());
        
        return saved;
    }
    
    /**
     * Submit a new high score with current timestamp
     */
    public GameScore submitScore(String playerName, String gameName, Long score) {
        return submitScore(playerName, gameName, score, null);
    }
    
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
    
    /**
     * Get all scores for a specific game with pagination
     */
    @Transactional(readOnly = true)
    public Page<GameScore> getGameScores(String gameName, int page, int size) {
        log.info("Getting all scores for game: {} (page: {}, size: {})", gameName, page, size);
        Pageable pageable = PageRequest.of(page, size);
        return gameScoreRepository.findByGameNameOrderByScoreDesc(gameName, pageable);
    }
    
    /**
     * Get all scores for a specific player and game combination
     */
    @Transactional(readOnly = true)
    public Page<GameScore> getPlayerGameScores(String playerName, String gameName, int page, int size) {
        log.info("Getting scores for player: {} in game: {} (page: {}, size: {})", playerName, gameName, page, size);
        Pageable pageable = PageRequest.of(page, size);
        return gameScoreRepository.findByPlayerNameAndGameNameOrderByScoreDesc(playerName, gameName, pageable);
    }
    
    /**
     * Get all available games
     */
    @Transactional(readOnly = true)
    public List<String> getAllGames() {
        log.info("Getting all available games");
        return gameScoreRepository.findDistinctGameNames();
    }
    
    /**
     * Get all players
     */
    @Transactional(readOnly = true)
    public List<String> getAllPlayers() {
        log.info("Getting all players");
        return gameScoreRepository.findDistinctPlayerNames();
    }
    
    /**
     * Get highest score for a player in a specific game
     */
    @Transactional(readOnly = true)
    public Optional<Long> getPlayerHighScore(String playerName, String gameName) {
        log.info("Getting highest score for player: {} in game: {}", playerName, gameName);
        Long highScore = gameScoreRepository.findHighestScoreByPlayerAndGame(playerName, gameName);
        return Optional.ofNullable(highScore);
    }
    
    /**
     * Get a specific score by ID
     */
    @Transactional(readOnly = true)
    public Optional<GameScore> getScoreById(Long id) {
        log.info("Getting score by ID: {}", id);
        return gameScoreRepository.findById(id);
    }
    
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
     * Get statistics for a player
     */
    @Transactional(readOnly = true)
    public PlayerStatistics getPlayerStatistics(String playerName) {
        log.info("Getting statistics for player: {}", playerName);
        long totalScores = gameScoreRepository.countByPlayerName(playerName);
        
        return new PlayerStatistics(playerName, totalScores);
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

    /**
     * Inner class for player statistics
     */
    public static class PlayerStatistics {
        public final String playerName;
        public final long totalScores;
        
        public PlayerStatistics(String playerName, long totalScores) {
            this.playerName = playerName;
            this.totalScores = totalScores;
        }
    }
}