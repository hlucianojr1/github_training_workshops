// Re-export all types
export type {
  ApiResponse,
  ScoreResponse,
  ScoreSubmissionRequest,
  PlayerStats,
  GameStats,
  PageResponse,
  LeaderboardEntry,
  // WebSocket types
  WSMessageType,
  WSMessage,
  WSConnectionStatus,
  ScoreUpdatePayload,
  LeaderboardUpdatePayload,
  SubscribePayload,
  ConnectedPayload,
  ErrorPayload,
} from './types';

// Re-export all service functions
export {
  getGames,
  getTopScores,
  getGameScores,
  submitScore,
  getPlayerScores,
  getPlayerGameScores,
  getPlayerHighScore,
  getGameStats,
  getPlayerStats,
  getPlayers,
  getScoreById,
} from './scoreService';

// Re-export WebSocket service
export { useScoreWebSocket, type UseScoreWebSocketOptions } from './websocketService';
