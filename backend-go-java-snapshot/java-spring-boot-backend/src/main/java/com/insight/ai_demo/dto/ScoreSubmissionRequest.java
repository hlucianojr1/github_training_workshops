package com.insight.ai_demo.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ScoreSubmissionRequest {
    
    @NotBlank(message = "Player name is required")
    private String playerName;
    
    @NotBlank(message = "Game name is required")
    private String gameName;
    
    @NotNull(message = "Score is required")
    private Long score;
    
    private LocalDateTime achievedAt;  // Optional - will use current time if not provided
}