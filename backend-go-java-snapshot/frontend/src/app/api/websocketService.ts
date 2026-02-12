import { useCallback, useRef } from 'react';
import useWebSocket, { ReadyState } from 'react-use-websocket';
import type {
  WSMessage,
  WSMessageType,
  SubscribePayload,
  ScoreUpdatePayload,
  LeaderboardUpdatePayload,
  ConnectedPayload,
  WSConnectionStatus,
} from './types';

/**
 * WebSocket URL for the Go backend.
 * In production, VITE_WS_URL must be set at build time.
 * Falls back to localhost:8081 only during local development.
 */
const WS_URL = import.meta.env.VITE_WS_URL || (import.meta.env.DEV ? 'ws://localhost:8081/ws' : '');

/**
 * Options for the WebSocket hook
 */
export interface UseScoreWebSocketOptions {
  /** Callback when a score is updated */
  onScoreUpdate?: (payload: ScoreUpdatePayload) => void;
  /** Callback when the leaderboard is updated */
  onLeaderboardUpdate?: (payload: LeaderboardUpdatePayload) => void;
  /** Callback when connected to the server */
  onConnected?: (payload: ConnectedPayload) => void;
  /** Callback when an error occurs */
  onError?: (message: string) => void;
  /** Whether to automatically reconnect */
  shouldReconnect?: boolean;
}

/**
 * Return type for the WebSocket hook
 */
export interface UseScoreWebSocketReturn {
  /** Subscribe to updates for a specific game */
  subscribeToGame: (gameName: string) => void;
  /** Unsubscribe from updates for a specific game */
  unsubscribeFromGame: (gameName: string) => void;
  /** Current connection status */
  connectionStatus: WSConnectionStatus;
  /** Whether the connection is open */
  isConnected: boolean;
  /** Send a ping to the server */
  sendPing: () => void;
}

/**
 * Custom hook for WebSocket connection to the score service
 * Provides real-time updates for game scores and leaderboards
 */
export function useScoreWebSocket(
  options: UseScoreWebSocketOptions = {}
): UseScoreWebSocketReturn {
  const {
    onScoreUpdate,
    onLeaderboardUpdate,
    onConnected,
    onError,
    shouldReconnect = true,
  } = options;

  const didUnmount = useRef(false);

  // Handle incoming messages
  const handleMessage = useCallback(
    (event: MessageEvent) => {
      try {
        const message: WSMessage = JSON.parse(event.data);

        switch (message.type) {
          case 'SCORE_UPDATE':
            onScoreUpdate?.(message.payload as ScoreUpdatePayload);
            break;
          case 'LEADERBOARD_UPDATE':
            onLeaderboardUpdate?.(message.payload as LeaderboardUpdatePayload);
            break;
          case 'CONNECTED':
            onConnected?.(message.payload as ConnectedPayload);
            break;
          case 'ERROR':
            const errorPayload = message.payload as { message: string };
            onError?.(errorPayload.message);
            break;
          case 'PONG':
            // Heartbeat response, no action needed
            break;
          default:
            console.log('Unknown WebSocket message type:', message.type);
        }
      } catch (error) {
        console.error('Failed to parse WebSocket message:', error);
      }
    },
    [onScoreUpdate, onLeaderboardUpdate, onConnected, onError]
  );

  const { sendJsonMessage, readyState } = useWebSocket(WS_URL, {
    onMessage: handleMessage,
    onOpen: () => {
      console.log('WebSocket connected to', WS_URL);
    },
    onClose: () => {
      console.log('WebSocket disconnected');
    },
    onError: (event) => {
      console.error('WebSocket error:', event);
      onError?.('WebSocket connection error');
    },
    shouldReconnect: (closeEvent) => {
      // Don't reconnect if the component unmounted
      return didUnmount.current === false && shouldReconnect;
    },
    reconnectAttempts: 10,
    reconnectInterval: (attemptNumber) =>
      Math.min(Math.pow(2, attemptNumber) * 1000, 10000),
    heartbeat: {
      message: JSON.stringify({ type: 'PING' }),
      returnMessage: 'PONG',
      timeout: 60000,
      interval: 30000,
    },
  });

  // Subscribe to a game's updates
  const subscribeToGame = useCallback(
    (gameName: string) => {
      const message: WSMessage<SubscribePayload> = {
        type: 'SUBSCRIBE',
        payload: { gameName },
        timestamp: new Date().toISOString(),
      };
      sendJsonMessage(message);
      console.log('Subscribed to game:', gameName);
    },
    [sendJsonMessage]
  );

  // Unsubscribe from a game's updates
  const unsubscribeFromGame = useCallback(
    (gameName: string) => {
      const message: WSMessage<SubscribePayload> = {
        type: 'UNSUBSCRIBE',
        payload: { gameName },
        timestamp: new Date().toISOString(),
      };
      sendJsonMessage(message);
      console.log('Unsubscribed from game:', gameName);
    },
    [sendJsonMessage]
  );

  // Send a ping to keep the connection alive
  const sendPing = useCallback(() => {
    const message: WSMessage = {
      type: 'PING',
      timestamp: new Date().toISOString(),
    };
    sendJsonMessage(message);
  }, [sendJsonMessage]);

  // Map ReadyState to connection status
  const connectionStatus: WSConnectionStatus = {
    [ReadyState.CONNECTING]: 'connecting',
    [ReadyState.OPEN]: 'connected',
    [ReadyState.CLOSING]: 'disconnected',
    [ReadyState.CLOSED]: 'disconnected',
    [ReadyState.UNINSTANTIATED]: 'disconnected',
  }[readyState] as WSConnectionStatus;

  return {
    subscribeToGame,
    unsubscribeFromGame,
    connectionStatus,
    isConnected: readyState === ReadyState.OPEN,
    sendPing,
  };
}

export { ReadyState };
