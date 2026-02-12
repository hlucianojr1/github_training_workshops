import { Loader2 } from 'lucide-react';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/app/components/ui/select';
import { useGame } from '@/app/context/GameContext';

export function GameSelector() {
  const { games, selectedGame, setSelectedGame, loading } = useGame();

  if (loading) {
    return (
      <div className="flex items-center gap-2 text-gray-400">
        <Loader2 className="w-4 h-4 animate-spin" />
        <span className="text-sm">Loading games...</span>
      </div>
    );
  }

  // If no games from API, show the selected game as static text
  if (games.length === 0) {
    return (
      <span className="text-white font-black text-2xl uppercase">
        {selectedGame}
      </span>
    );
  }

  return (
    <Select value={selectedGame} onValueChange={setSelectedGame}>
      <SelectTrigger
        className="w-auto min-w-[200px] border-gray-700 bg-black/50 text-white font-black text-lg uppercase hover:bg-gray-900/50 focus:ring-red-500/50"
        aria-label="Select game"
      >
        <SelectValue placeholder="Select a game" />
      </SelectTrigger>
      <SelectContent className="bg-gray-900 border-gray-700">
        {games.map((game) => (
          <SelectItem
            key={game}
            value={game}
            className="text-white font-bold uppercase hover:bg-red-900/30 focus:bg-red-900/30 cursor-pointer"
          >
            {game}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}
