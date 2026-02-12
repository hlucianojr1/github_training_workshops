import type {
  ApiResponse,
  ScoreResponse,
  ScoreSubmissionRequest,
  PlayerStats,
  GameStats,
  PageResponse,
} from './types';

/**
 * Base URL for the API.
 * In production, VITE_API_URL must be set at build time.
 * Falls back to localhost:8080 only during local development.
 */
const BASE_URL = import.meta.env.VITE_API_URL || (import.meta.env.DEV ? 'http://localhost:8080' : '');

/**
 * Generic fetch wrapper with error handling
 */
async function apiFetch<T>(
  endpoint: string,
  options?: RequestInit
): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(`${BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
      ...options,
    });

    if (!response.ok) {
      const errorText = await response.text();
      return {
        data: null,
        error: `HTTP ${response.status}: ${errorText || response.statusText}`,
      };
    }

    const data = await response.json();
    return { data, error: null };
  } catch (error) {
    return {
      data: null,
      error: error instanceof Error ? error.message : 'Unknown error occurred',
    };
  }
}

/**
 * Get list of all available games
 */
export async function getGames(): Promise<ApiResponse<string[]>> {
  return apiFetch<string[]>('/api/scores/games');
}

/**
 * Get top scores for a specific game
 * @param gameName - Name of the game
 * @param limit - Maximum number of scores to return (default: 10)
 */
export async function getTopScores(
  gameName: string,
  limit: number = 10
): Promise<ApiResponse<ScoreResponse[]>> {
  const encodedGame = encodeURIComponent(gameName);
  return apiFetch<ScoreResponse[]>(
    `/api/scores/game/${encodedGame}/top?limit=${limit}`
  );
}

/**
 * Get paginated scores for a specific game
 * @param gameName - Name of the game
 * @param page - Page number (0-indexed)
 * @param size - Page size
 */
export async function getGameScores(
  gameName: string,
  page: number = 0,
  size: number = 10
): Promise<ApiResponse<PageResponse<ScoreResponse>>> {
  const encodedGame = encodeURIComponent(gameName);
  return apiFetch<PageResponse<ScoreResponse>>(
    `/api/scores/game/${encodedGame}?page=${page}&size=${size}`
  );
}

/**
 * Submit a new score
 * @param request - Score submission data
 */
export async function submitScore(
  request: ScoreSubmissionRequest
): Promise<ApiResponse<ScoreResponse>> {
  return apiFetch<ScoreResponse>('/api/scores/submit', {
    method: 'POST',
    body: JSON.stringify(request),
  });
}

/**
 * Get all scores for a specific player
 * @param playerName - Name of the player
 * @param page - Page number (0-indexed)
 * @param size - Page size
 */
export async function getPlayerScores(
  playerName: string,
  page: number = 0,
  size: number = 10
): Promise<ApiResponse<PageResponse<ScoreResponse>>> {
  const encodedPlayer = encodeURIComponent(playerName);
  return apiFetch<PageResponse<ScoreResponse>>(
    `/api/scores/player/${encodedPlayer}?page=${page}&size=${size}`
  );
}

/**
 * Get player's scores for a specific game
 * @param gameName - Name of the game
 * @param playerName - Name of the player
 */
export async function getPlayerGameScores(
  gameName: string,
  playerName: string
): Promise<ApiResponse<ScoreResponse[]>> {
  const encodedGame = encodeURIComponent(gameName);
  const encodedPlayer = encodeURIComponent(playerName);
  return apiFetch<ScoreResponse[]>(
    `/api/scores/game/${encodedGame}/player/${encodedPlayer}`
  );
}

/**
 * Get player's high score for a specific game
 * @param gameName - Name of the game
 * @param playerName - Name of the player
 */
export async function getPlayerHighScore(
  gameName: string,
  playerName: string
): Promise<ApiResponse<ScoreResponse>> {
  const encodedGame = encodeURIComponent(gameName);
  const encodedPlayer = encodeURIComponent(playerName);
  return apiFetch<ScoreResponse>(
    `/api/scores/game/${encodedGame}/player/${encodedPlayer}/high`
  );
}

/**
 * Get statistics for a specific game
 * @param gameName - Name of the game
 */
export async function getGameStats(
  gameName: string
): Promise<ApiResponse<GameStats>> {
  const encodedGame = encodeURIComponent(gameName);
  return apiFetch<GameStats>(`/api/scores/games/${encodedGame}/stats`);
}

/**
 * Get statistics for a specific player
 * @param playerName - Name of the player
 */
export async function getPlayerStats(
  playerName: string
): Promise<ApiResponse<PlayerStats>> {
  const encodedPlayer = encodeURIComponent(playerName);
  return apiFetch<PlayerStats>(`/api/scores/players/${encodedPlayer}/stats`);
}

/**
 * Get list of all players
 */
export async function getPlayers(): Promise<ApiResponse<string[]>> {
  return apiFetch<string[]>('/api/scores/players');
}

/**
 * Get a specific score by ID
 * @param scoreId - ID of the score
 */
export async function getScoreById(
  scoreId: number
): Promise<ApiResponse<ScoreResponse>> {
  return apiFetch<ScoreResponse>(`/api/scores/${scoreId}`);
}
