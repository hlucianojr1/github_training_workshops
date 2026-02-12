package com.insight.ai_demo.dto;

/**
 * DTO for game statistics response.
 * Matches the frontend GameStats interface.
 */
public record GameStatsResponse(
    String gameName,
    int totalPlayers,
    int totalScores,
    double averageScore,
    long highestScore,
    String topPlayer
) {}

