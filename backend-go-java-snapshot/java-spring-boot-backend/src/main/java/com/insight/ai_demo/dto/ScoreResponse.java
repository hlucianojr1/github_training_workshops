package com.insight.ai_demo.dto;

import com.insight.ai_demo.entity.GameScore;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ScoreResponse {
    private Long id;
    private String playerName;
    private String gameName;
    private Long score;
    private LocalDateTime achievedAt;
    private LocalDateTime createdAt;
    
    public ScoreResponse(GameScore gameScore) {
        this.id = gameScore.getId();
        this.playerName = gameScore.getPlayerName();
        this.gameName = gameScore.getGameName();
        this.score = gameScore.getScore();
        this.achievedAt = gameScore.getAchievedAt();
        this.createdAt = gameScore.getCreatedAt();
    }
    
    // Default constructor for Jackson
    public ScoreResponse() {}
}