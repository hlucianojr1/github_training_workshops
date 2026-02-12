package com.insight.ai_demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "game_scores")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GameScore {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Player name is required")
    @Column(nullable = false, length = 100)
    private String playerName;
    
    @NotBlank(message = "Game name is required")
    @Column(nullable = false, length = 100)
    private String gameName;
    
    @NotNull(message = "Score is required")
    @Column(nullable = false)
    private Long score;
    
    @NotNull
    @Column(nullable = false)
    private LocalDateTime achievedAt;
    
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (achievedAt == null) {
            achievedAt = LocalDateTime.now();
        }
    }
    
    // Custom constructor without ID and timestamps (for API requests)
    public GameScore(String playerName, String gameName, Long score) {
        this.playerName = playerName;
        this.gameName = gameName;
        this.score = score;
        this.achievedAt = LocalDateTime.now();
    }
    
    public GameScore(String playerName, String gameName, Long score, LocalDateTime achievedAt) {
        this.playerName = playerName;
        this.gameName = gameName;
        this.score = score;
        this.achievedAt = achievedAt;
    }
}