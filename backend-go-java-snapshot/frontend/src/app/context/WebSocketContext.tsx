import React, {
  createContext,
  useContext,
  useCallback,
  useState,
  useEffect,
  type ReactNode,
} from 'react';
import { useScoreWebSocket, type UseScoreWebSocketOptions } from '../api/websocketService';
import type {
  ScoreUpdatePayload,
  LeaderboardUpdatePayload,
  ConnectedPayload,
  WSConnectionStatus,
  ScoreResponse,
} from '../api/types';

/**
 * WebSocket context state
 */
interface WebSocketContextState {
  /** Current connection status */
  connectionStatus: WSConnectionStatus;
  /** Whether the connection is open */
  isConnected: boolean;
  /** Client ID assigned by the server */
  clientId: string | null;
  /** Available games from the server */
  availableGames: string[];
  /** Currently subscribed games */
  subscribedGames: string[];
  /** Latest score update received */
  latestScoreUpdate: ScoreUpdatePayload | null;
  /** Latest leaderboard data by game */
  leaderboardData: Record<string, ScoreResponse[]>;
  /** Subscribe to a game's updates */
  subscribeToGame: (gameName: string) => void;
  /** Unsubscribe from a game's updates */
  unsubscribeFromGame: (gameName: string) => void;
  /** Last error message */
  lastError: string | null;
}

const WebSocketContext = createContext<WebSocketContextState | undefined>(undefined);

/**
 * Props for the WebSocket provider
 */
interface WebSocketProviderProps {
  children: ReactNode;
}

/**
 * WebSocket provider component
 * Provides real-time score updates to the application
 */
export function WebSocketProvider({ children }: WebSocketProviderProps) {
  const [clientId, setClientId] = useState<string | null>(null);
  const [availableGames, setAvailableGames] = useState<string[]>([]);
  const [subscribedGames, setSubscribedGames] = useState<string[]>([]);
  const [latestScoreUpdate, setLatestScoreUpdate] = useState<ScoreUpdatePayload | null>(null);
  const [leaderboardData, setLeaderboardData] = useState<Record<string, ScoreResponse[]>>({});
  const [lastError, setLastError] = useState<string | null>(null);

  // Handle score updates
  const handleScoreUpdate = useCallback((payload: ScoreUpdatePayload) => {
    console.log('Score update received:', payload);
    setLatestScoreUpdate(payload);
  }, []);

  // Handle leaderboard updates
  const handleLeaderboardUpdate = useCallback((payload: LeaderboardUpdatePayload) => {
    console.log('Leaderboard update received for:', payload.gameName);
    setLeaderboardData((prev) => ({
      ...prev,
      [payload.gameName]: payload.topScores,
    }));
  }, []);

  // Handle connection confirmation
  const handleConnected = useCallback((payload: ConnectedPayload) => {
    console.log('Connected with client ID:', payload.clientId);
    setClientId(payload.clientId);
    setAvailableGames(payload.games);
  }, []);

  // Handle errors
  const handleError = useCallback((message: string) => {
    console.error('WebSocket error:', message);
    setLastError(message);
    // Clear error after 5 seconds
    setTimeout(() => setLastError(null), 5000);
  }, []);

  const options: UseScoreWebSocketOptions = {
    onScoreUpdate: handleScoreUpdate,
    onLeaderboardUpdate: handleLeaderboardUpdate,
    onConnected: handleConnected,
    onError: handleError,
    shouldReconnect: true,
  };

  const {
    subscribeToGame: wsSubscribe,
    unsubscribeFromGame: wsUnsubscribe,
    connectionStatus,
    isConnected,
  } = useScoreWebSocket(options);

  // Subscribe to a game and track it
  const subscribeToGame = useCallback(
    (gameName: string) => {
      if (!subscribedGames.includes(gameName)) {
        wsSubscribe(gameName);
        setSubscribedGames((prev) => [...prev, gameName]);
      }
    },
    [wsSubscribe, subscribedGames]
  );

  // Unsubscribe from a game and untrack it
  const unsubscribeFromGame = useCallback(
    (gameName: string) => {
      wsUnsubscribe(gameName);
      setSubscribedGames((prev) => prev.filter((g) => g !== gameName));
    },
    [wsUnsubscribe]
  );

  // Re-subscribe to games when reconnecting
  useEffect(() => {
    if (isConnected && subscribedGames.length > 0) {
      subscribedGames.forEach((game) => {
        wsSubscribe(game);
      });
    }
  }, [isConnected, subscribedGames, wsSubscribe]);

  const contextValue: WebSocketContextState = {
    connectionStatus,
    isConnected,
    clientId,
    availableGames,
    subscribedGames,
    latestScoreUpdate,
    leaderboardData,
    subscribeToGame,
    unsubscribeFromGame,
    lastError,
  };

  return (
    <WebSocketContext.Provider value={contextValue}>
      {children}
    </WebSocketContext.Provider>
  );
}

/**
 * Hook to access the WebSocket context
 */
export function useWebSocketContext(): WebSocketContextState {
  const context = useContext(WebSocketContext);
  if (context === undefined) {
    throw new Error('useWebSocketContext must be used within a WebSocketProvider');
  }
  return context;
}

/**
 * Hook for leaderboard-specific WebSocket functionality
 * Automatically subscribes to the specified game
 */
export function useLeaderboardWebSocket(gameName: string) {
  const {
    subscribeToGame,
    unsubscribeFromGame,
    leaderboardData,
    latestScoreUpdate,
    isConnected,
    connectionStatus,
  } = useWebSocketContext();

  // Subscribe when game changes
  useEffect(() => {
    if (isConnected && gameName) {
      subscribeToGame(gameName);
    }

    return () => {
      if (gameName) {
        unsubscribeFromGame(gameName);
      }
    };
  }, [gameName, isConnected, subscribeToGame, unsubscribeFromGame]);

  return {
    topScores: leaderboardData[gameName] || null,
    latestScoreUpdate:
      latestScoreUpdate?.gameName === gameName ? latestScoreUpdate : null,
    isConnected,
    connectionStatus,
  };
}
