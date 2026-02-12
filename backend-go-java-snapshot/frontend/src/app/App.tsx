import { Navigation } from '@/app/components/Navigation';
import { Hero } from '@/app/components/Hero';
import { Screenshots } from '@/app/components/Screenshots';
import { Leaderboard } from '@/app/components/Leaderboard';
import { Trophies } from '@/app/components/Trophies';
import { Challenges } from '@/app/components/Challenges';
import { Storyline } from '@/app/components/Storyline';
import { Puzzles } from '@/app/components/Puzzles';
import { GameProvider } from '@/app/context/GameContext';
import { WebSocketProvider } from '@/app/context/WebSocketContext';

export default function App() {
  return (
    <GameProvider>
    <WebSocketProvider>
    <div className="size-full bg-black">
      <Navigation />
      <Hero />
      <div id="screenshots">
        <Screenshots />
      </div>
      <div id="leaderboard">
        <Leaderboard />
      </div>
      <div id="trophies">
        <Trophies />
      </div>
      <div id="challenges">
        <Challenges />
      </div>
      <div id="campaign">
        <Storyline />
      </div>
      <div id="puzzles">
        <Puzzles />
      </div>
      
      {/* Footer */}
      <footer className="bg-black border-t border-gray-800 py-12">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
            <div>
              <h3 className="text-white font-black text-xl mb-4">OPERATION NIGHTFALL</h3>
              <p className="text-gray-400 text-sm">
                The ultimate first-person shooter experience. Join millions of players worldwide in intense tactical combat.
              </p>
            </div>
            <div>
              <h4 className="text-white font-bold mb-4">GAME MODES</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li>Campaign</li>
                <li>Multiplayer</li>
                <li>Co-op Operations</li>
                <li>Battle Royale</li>
              </ul>
            </div>
            <div>
              <h4 className="text-white font-bold mb-4">COMMUNITY</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li>Discord Server</li>
                <li>Forums</li>
                <li>Support</li>
                <li>News & Updates</li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-800 pt-8 text-center text-gray-500 text-sm">
            <p>© 2026 Operation Nightfall. All rights reserved. This is a fictional game website.</p>
          </div>
        </div>
      </footer>
    </div>
    </WebSocketProvider>
    </GameProvider>
  );
}
