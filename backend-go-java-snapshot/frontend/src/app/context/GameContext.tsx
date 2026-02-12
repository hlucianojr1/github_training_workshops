import {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  type ReactNode,
} from 'react';
import { getGames } from '@/app/api';

const DEFAULT_GAME = 'Operation Nightfall';

interface GameContextValue {
  /** List of available games from the API */
  games: string[];
  /** Currently selected game */
  selectedGame: string;
  /** Update the selected game (also updates URL param) */
  setSelectedGame: (game: string) => void;
  /** Whether games are being loaded */
  loading: boolean;
  /** Error message if games failed to load */
  error: string | null;
  /** Refresh the games list from the API */
  refreshGames: () => Promise<void>;
}

const GameContext = createContext<GameContextValue | undefined>(undefined);

/**
 * Get the game parameter from the current URL
 */
function getGameFromUrl(): string | null {
  const params = new URLSearchParams(window.location.search);
  return params.get('game');
}

/**
 * Update the URL with the selected game parameter
 */
function setGameInUrl(game: string): void {
  const url = new URL(window.location.href);
  url.searchParams.set('game', game);
  window.history.replaceState({}, '', url.toString());
}

interface GameProviderProps {
  children: ReactNode;
}

export function GameProvider({ children }: GameProviderProps) {
  const [games, setGames] = useState<string[]>([]);
  const [selectedGame, setSelectedGameState] = useState<string>(() => {
    // Initialize from URL param or default
    return getGameFromUrl() || DEFAULT_GAME;
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchGames = useCallback(async () => {
    setLoading(true);
    setError(null);

    const response = await getGames();

    if (response.error) {
      setError(response.error);
      // Keep default game on error
      setGames([]);
    } else if (response.data) {
      setGames(response.data);

      // If URL param game exists in the list, keep it
      // Otherwise, use first game from API or default
      const urlGame = getGameFromUrl();
      if (urlGame && response.data.includes(urlGame)) {
        setSelectedGameState(urlGame);
        setGameInUrl(urlGame);
      } else if (response.data.length > 0 && !urlGame) {
        // Only auto-select first game if no URL param was provided
        const firstGame = response.data[0];
        setSelectedGameState(firstGame);
        setGameInUrl(firstGame);
      } else {
        // URL param provided but not in list, or empty list - use default
        setGameInUrl(selectedGame);
      }
    }

    setLoading(false);
  }, [selectedGame]);

  useEffect(() => {
    fetchGames();
  }, [fetchGames]);

  const setSelectedGame = useCallback((game: string) => {
    setSelectedGameState(game);
    setGameInUrl(game);
  }, []);

  const value: GameContextValue = {
    games,
    selectedGame,
    setSelectedGame,
    loading,
    error,
    refreshGames: fetchGames,
  };

  return <GameContext.Provider value={value}>{children}</GameContext.Provider>;
}

/**
 * Hook to access the game context
 * @throws Error if used outside of GameProvider
 */
export function useGame(): GameContextValue {
  const context = useContext(GameContext);
  if (context === undefined) {
    throw new Error('useGame must be used within a GameProvider');
  }
  return context;
}
