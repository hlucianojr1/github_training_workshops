package com.insight.ai_demo.repository;

import com.insight.ai_demo.entity.GameScore;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GameScoreRepository extends JpaRepository<GameScore, Long> {
    
    /**
     * Find all scores for a specific player, ordered by score descending
     */
    Page<GameScore> findByPlayerNameOrderByScoreDesc(String playerName, Pageable pageable);
    
    /**
     * Find all scores for a specific game, ordered by score descending
     */
    Page<GameScore> findByGameNameOrderByScoreDesc(String gameName, Pageable pageable);
    
    /**
     * Find top N scores for a specific game
     */
    @Query("SELECT gs FROM GameScore gs WHERE gs.gameName = :gameName ORDER BY gs.score DESC, gs.achievedAt ASC")
    List<GameScore> findTopScoresByGame(@Param("gameName") String gameName, Pageable pageable);
    
    /**
     * Find all scores for a specific player and game combination
     */
    Page<GameScore> findByPlayerNameAndGameNameOrderByScoreDesc(String playerName, String gameName, Pageable pageable);
    
    /**
     * Find all distinct game names
     */
    @Query("SELECT DISTINCT gs.gameName FROM GameScore gs ORDER BY gs.gameName")
    List<String> findDistinctGameNames();
    
    /**
     * Find all distinct player names
     */
    @Query("SELECT DISTINCT gs.playerName FROM GameScore gs ORDER BY gs.playerName")
    List<String> findDistinctPlayerNames();
    
    /**
     * Get the highest score for a specific player in a specific game
     */
    @Query("SELECT MAX(gs.score) FROM GameScore gs WHERE gs.playerName = :playerName AND gs.gameName = :gameName")
    Long findHighestScoreByPlayerAndGame(@Param("playerName") String playerName, @Param("gameName") String gameName);
    
    /**
     * Count total scores for a game
     */
    long countByGameName(String gameName);
    
    /**
     * Count total scores for a player
     */
    long countByPlayerName(String playerName);
}