import { Trophy, Medal, Award, Loader2, AlertCircle, RefreshCw, Wifi, WifiOff, Zap } from 'lucide-react';
import { useState, useEffect, useCallback } from 'react';
import { useGame } from '@/app/context/GameContext';
import { getTopScores, type ScoreResponse } from '@/app/api';
import { useLeaderboardWebSocket } from '@/app/context/WebSocketContext';

// Fallback data when API is unavailable
const fallbackData = [
  { rank: 1, player: "GhostReaper", score: 145820, kills: 2847, wins: 156, icon: Trophy },
  { rank: 2, player: "ShadowSniper", score: 142150, kills: 2756, wins: 149, icon: Trophy },
  { rank: 3, player: "PhantomElite", score: 138490, kills: 2698, wins: 145, icon: Trophy },
  { rank: 4, player: "ViperStrike", score: 135280, kills: 2634, wins: 141, icon: Medal },
  { rank: 5, player: "StealthNinja", score: 132760, kills: 2589, wins: 138, icon: Medal },
  { rank: 6, player: "TacticalWolf", score: 129450, kills: 2523, wins: 134, icon: Medal },
  { rank: 7, player: "NightHawk47", score: 126890, kills: 2478, wins: 131, icon: Award },
  { rank: 8, player: "DeltaForce", score: 124320, kills: 2431, wins: 128, icon: Award },
  { rank: 9, player: "ApexPredator", score: 121750, kills: 2384, wins: 125, icon: Award },
  { rank: 10, player: "WarMachine", score: 119180, kills: 2337, wins: 122, icon: Award },
];

function getIconForRank(rank: number) {
  if (rank <= 3) return Trophy;
  if (rank <= 6) return Medal;
  return Award;
}

interface LeaderboardEntry {
  rank: number;
  player: string;
  score: number;
  kills?: number;
  wins?: number;
  icon: typeof Trophy | typeof Medal | typeof Award;
  isNew?: boolean;
}

export function Leaderboard() {
  const { selectedGame } = useGame();
  const [leaderboardData, setLeaderboardData] = useState<LeaderboardEntry[]>(fallbackData);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [usingFallback, setUsingFallback] = useState(false);
  const [recentlyUpdated, setRecentlyUpdated] = useState<Set<string>>(new Set());

  // WebSocket integration for real-time updates
  const { topScores: wsTopScores, latestScoreUpdate, isConnected, connectionStatus } = useLeaderboardWebSocket(selectedGame);

  // Convert API/WebSocket ScoreResponse to LeaderboardEntry
  const convertToLeaderboardEntries = useCallback((scores: ScoreResponse[]): LeaderboardEntry[] => {
    return scores.map((score, index) => ({
      rank: index + 1,
      player: score.playerName,
      score: score.score,
      icon: getIconForRank(index + 1),
    }));
  }, []);

  // Update leaderboard from WebSocket data
  useEffect(() => {
    if (wsTopScores && wsTopScores.length > 0) {
      const entries = convertToLeaderboardEntries(wsTopScores);
      setLeaderboardData(entries);
      setUsingFallback(false);
      setLoading(false);
    }
  }, [wsTopScores, convertToLeaderboardEntries]);

  // Highlight newly added scores
  useEffect(() => {
    if (latestScoreUpdate) {
      const playerKey = `${latestScoreUpdate.playerName}-${latestScoreUpdate.score}`;
      setRecentlyUpdated((prev) => new Set(prev).add(playerKey));
      
      // Remove highlight after 3 seconds
      setTimeout(() => {
        setRecentlyUpdated((prev) => {
          const next = new Set(prev);
          next.delete(playerKey);
          return next;
        });
      }, 3000);
    }
  }, [latestScoreUpdate]);

  const fetchLeaderboard = useCallback(async () => {
    setLoading(true);
    setError(null);

    const response = await getTopScores(selectedGame, 10);

    if (response.error) {
      setError(response.error);
      setLeaderboardData(fallbackData);
      setUsingFallback(true);
    } else if (response.data && response.data.length > 0) {
      const entries = convertToLeaderboardEntries(response.data);
      setLeaderboardData(entries);
      setUsingFallback(false);
    } else {
      // Empty response - use fallback
      setLeaderboardData(fallbackData);
      setUsingFallback(true);
    }

    setLoading(false);
  }, [selectedGame, convertToLeaderboardEntries]);

  useEffect(() => {
    fetchLeaderboard();
  }, [fetchLeaderboard]);

  // Check if an entry was recently updated
  const isRecentlyUpdated = (entry: LeaderboardEntry) => {
    const key = `${entry.player}-${entry.score}`;
    return recentlyUpdated.has(key);
  };

  return (
    <section className="py-20 bg-gradient-to-b from-black to-gray-900">
      <div className="max-w-6xl mx-auto px-4">
        <div className="flex items-center justify-center gap-4 mb-4">
          <h2 className="text-5xl font-black text-white text-center">LEADERBOARD</h2>
          <button
            onClick={fetchLeaderboard}
            disabled={loading}
            className="p-2 text-gray-400 hover:text-white transition-colors disabled:opacity-50"
            aria-label="Refresh leaderboard"
          >
            <RefreshCw className={`w-6 h-6 ${loading ? 'animate-spin' : ''}`} />
          </button>
        </div>
        <p className="text-gray-400 text-center mb-2">Top warriors of {selectedGame}</p>
        
        {/* Connection status indicator */}
        <div className="flex items-center justify-center gap-2 mb-4">
          {isConnected ? (
            <div className="flex items-center gap-2 text-green-500">
              <Wifi className="w-4 h-4" />
              <span className="text-sm">Live updates active</span>
              <Zap className="w-3 h-3 animate-pulse" />
            </div>
          ) : (
            <div className="flex items-center gap-2 text-gray-500">
              <WifiOff className="w-4 h-4" />
              <span className="text-sm">
                {connectionStatus === 'connecting' ? 'Connecting...' : 'Live updates unavailable'}
              </span>
            </div>
          )}
        </div>
        
        {usingFallback && (
          <div className="flex items-center justify-center gap-2 text-yellow-500 mb-4">
            <AlertCircle className="w-4 h-4" />
            <span className="text-sm">Showing demo data - API unavailable</span>
          </div>
        )}

        {loading ? (
          <div className="flex items-center justify-center py-20">
            <Loader2 className="w-8 h-8 animate-spin text-red-500" />
            <span className="ml-3 text-gray-400">Loading leaderboard...</span>
          </div>
        ) : (
        <div className="bg-black/40 backdrop-blur-sm border border-gray-800 rounded-lg overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-red-900/30 border-b border-gray-800">
                  <th className="px-6 py-4 text-left text-white font-bold">RANK</th>
                  <th className="px-6 py-4 text-left text-white font-bold">PLAYER</th>
                  <th className="px-6 py-4 text-right text-white font-bold">SCORE</th>
                  <th className="px-6 py-4 text-right text-white font-bold">KILLS</th>
                  <th className="px-6 py-4 text-right text-white font-bold">WINS</th>
                </tr>
              </thead>
              <tbody>
                {leaderboardData.map((entry, index) => {
                  const Icon = entry.icon;
                  const isUpdated = isRecentlyUpdated(entry);
                  return (
                    <tr
                      key={entry.rank}
                      className={`border-b border-gray-800/50 hover:bg-white/5 transition-all duration-300 ${
                        index < 3 ? 'bg-gradient-to-r from-yellow-900/10 to-transparent' : ''
                      } ${isUpdated ? 'animate-pulse bg-green-900/30 ring-1 ring-green-500/50' : ''}`}
                    >
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-3">
                          <span className={`text-2xl font-bold ${
                            index === 0 ? 'text-yellow-400' :
                            index === 1 ? 'text-gray-400' :
                            index === 2 ? 'text-orange-600' :
                            'text-gray-500'
                          }`}>
                            {entry.rank}
                          </span>
                          <Icon className={`w-5 h-5 ${
                            index === 0 ? 'text-yellow-400' :
                            index === 1 ? 'text-gray-400' :
                            index === 2 ? 'text-orange-600' :
                            'text-gray-600'
                          }`} />
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-white font-bold">{entry.player}</span>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <span className="text-red-400 font-bold">{entry.score.toLocaleString()}</span>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <span className="text-gray-300">{entry.kills.toLocaleString()}</span>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <span className="text-green-400 font-bold">{entry.wins}</span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
        )}
      </div>
    </section>
  );
}
