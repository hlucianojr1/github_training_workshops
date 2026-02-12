/**
 * Generic API response wrapper for consistent error handling
 */
export type ApiResponse<T> = {
  data: T | null;
  error: string | null;
};

/**
 * Score response from the backend API
 */
export interface ScoreResponse {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  achievedAt: string;
  createdAt: string;
}

/**
 * Request payload for submitting a new score
 */
export interface ScoreSubmissionRequest {
  playerName: string;
  gameName: string;
  score: number;
  achievedAt?: string;
}

/**
 * Player statistics from the backend
 */
export interface PlayerStats {
  playerName: string;
  totalGames: number;
  totalScore: number;
  averageScore: number;
  highestScore: number;
  gamesPlayed: string[];
}

/**
 * Game statistics from the backend
 */
export interface GameStats {
  gameName: string;
  totalPlayers: number;
  totalScores: number;
  averageScore: number;
  highestScore: number;
  topPlayer: string;
}

/**
 * Paginated response wrapper
 */
export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  first: boolean;
  last: boolean;
}

/**
 * Extended leaderboard entry with display properties
 * Used by the frontend to display additional UI elements
 */
export interface LeaderboardEntry {
  rank: number;
  player: string;
  score: number;
  kills?: number;
  wins?: number;
}

// ============================================
// WebSocket Types for Real-time Updates
// ============================================

/**
 * WebSocket message types
 */
export enum WSMessageType {
  SCORE_UPDATE = 'SCORE_UPDATE',
  LEADERBOARD_UPDATE = 'LEADERBOARD_UPDATE',
  SUBSCRIBE = 'SUBSCRIBE',
  UNSUBSCRIBE = 'UNSUBSCRIBE',
  PING = 'PING',
  PONG = 'PONG',
  ERROR = 'ERROR',
  CONNECTED = 'CONNECTED',
}

/**
 * Base WebSocket message envelope
 */
export interface WSMessage<T = unknown> {
  type: WSMessageType | string;
  payload?: T;
  timestamp: string;
}

/**
 * Payload for score update messages
 */
export interface ScoreUpdatePayload {
  id: number;
  playerName: string;
  gameName: string;
  score: number;
  achievedAt: string;
}

/**
 * Payload for leaderboard update messages
 */
export interface LeaderboardUpdatePayload {
  gameName: string;
  topScores: ScoreResponse[];
}

/**
 * Payload for subscription requests
 */
export interface SubscribePayload {
  gameName: string;
}

/**
 * Payload for connection confirmation
 */
export interface ConnectedPayload {
  clientId: string;
  games: string[];
}

/**
 * Payload for error messages
 */
export interface ErrorPayload {
  code: string;
  message: string;
}

/**
 * WebSocket connection status
 */
export type WSConnectionStatus = 'connecting' | 'connected' | 'disconnected' | 'error';
