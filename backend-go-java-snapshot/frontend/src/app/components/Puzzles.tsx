import { Brain, Lock, Code, Search, Puzzle, Layers } from 'lucide-react';

const puzzles = [
  {
    icon: Code,
    title: "Cipher Decryption",
    type: "Code Breaking",
    difficulty: "Expert",
    description: "Decrypt enemy communications using advanced cryptographic algorithms",
    location: "Mission 5: Black Site",
    status: "Locked"
  },
  {
    icon: Lock,
    title: "Security Bypass",
    type: "Hacking",
    difficulty: "Hard",
    description: "Hack into the mainframe by solving complex logic puzzles under time pressure",
    location: "Mission 4: Urban Warfare",
    status: "Active"
  },
  {
    icon: Search,
    title: "Evidence Analysis",
    type: "Investigation",
    difficulty: "Medium",
    description: "Analyze crime scene evidence and connect the dots to find the traitor",
    location: "Mission 3: Frozen Wasteland",
    status: "Completed"
  },
  {
    icon: Puzzle,
    title: "Pattern Recognition",
    type: "Memory",
    difficulty: "Medium",
    description: "Match weapon serial numbers to identify the arms dealer's supply route",
    location: "Mission 2: Desert Storm",
    status: "Completed"
  },
  {
    icon: Brain,
    title: "Strategic Planning",
    type: "Tactics",
    difficulty: "Hard",
    description: "Plan the perfect infiltration route by analyzing guard patterns and timing",
    location: "Mission 1: Ghost Protocol",
    status: "Completed"
  },
  {
    icon: Layers,
    title: "Multi-Layer Encryption",
    type: "Advanced Hacking",
    difficulty: "Expert",
    description: "Break through multiple security layers to access classified information",
    location: "Mission 6: Operation Nightfall",
    status: "Locked"
  }
];

export function Puzzles() {
  return (
    <section className="py-20 bg-black">
      <div className="max-w-7xl mx-auto px-4">
        <h2 className="text-5xl font-black text-white mb-4 text-center">TACTICAL PUZZLES</h2>
        <p className="text-gray-400 text-center mb-12">Brains over bullets - solve complex challenges to gain tactical advantages</p>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {puzzles.map((puzzle, index) => {
            const Icon = puzzle.icon;
            
            return (
              <div
                key={index}
                className={`bg-gradient-to-br from-gray-900 to-gray-950 border rounded-lg p-6 hover:border-cyan-500/50 transition-all ${
                  puzzle.status === 'Active' ? 'border-cyan-500' :
                  puzzle.status === 'Completed' ? 'border-green-500/30' :
                  'border-gray-800'
                } ${puzzle.status === 'Locked' ? 'opacity-60' : ''}`}
              >
                <div className="flex items-start justify-between mb-4">
                  <div className={`w-14 h-14 rounded-lg flex items-center justify-center ${
                    puzzle.status === 'Active' ? 'bg-gradient-to-br from-cyan-600 to-blue-600' :
                    puzzle.status === 'Completed' ? 'bg-gradient-to-br from-green-600 to-emerald-600' :
                    'bg-gradient-to-br from-gray-700 to-gray-800'
                  }`}>
                    <Icon className="w-7 h-7 text-white" />
                  </div>
                  <span className={`text-xs font-bold px-3 py-1 rounded-full ${
                    puzzle.difficulty === 'Expert' ? 'bg-red-900 text-red-300' :
                    puzzle.difficulty === 'Hard' ? 'bg-orange-900 text-orange-300' :
                    'bg-yellow-900 text-yellow-300'
                  }`}>
                    {puzzle.difficulty}
                  </span>
                </div>
                
                <h3 className="text-xl font-bold text-white mb-2">{puzzle.title}</h3>
                <p className="text-sm text-cyan-400 mb-3 font-semibold">{puzzle.type}</p>
                <p className="text-gray-400 text-sm mb-4">{puzzle.description}</p>
                
                <div className="pt-4 border-t border-gray-800">
                  <p className="text-xs text-gray-500 mb-2">FOUND IN</p>
                  <p className="text-sm text-gray-300">{puzzle.location}</p>
                </div>
                
                <div className="mt-4">
                  {puzzle.status === 'Completed' && (
                    <div className="flex items-center gap-2 text-green-400">
                      <div className="w-2 h-2 bg-green-400 rounded-full"></div>
                      <span className="text-sm font-bold">Solved</span>
                    </div>
                  )}
                  {puzzle.status === 'Active' && (
                    <button className="w-full bg-gradient-to-r from-cyan-600 to-blue-600 text-white py-2 rounded-lg font-bold hover:from-cyan-700 hover:to-blue-700 transition-all">
                      Attempt Puzzle
                    </button>
                  )}
                  {puzzle.status === 'Locked' && (
                    <div className="flex items-center gap-2 text-gray-500">
                      <Lock className="w-4 h-4" />
                      <span className="text-sm font-bold">Progress campaign to unlock</span>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
        
        <div className="mt-12 bg-gradient-to-r from-cyan-900/20 to-blue-900/20 border border-cyan-800/30 rounded-lg p-6">
          <div className="flex items-start gap-4">
            <div className="w-12 h-12 rounded-full bg-gradient-to-br from-cyan-600 to-blue-600 flex items-center justify-center flex-shrink-0">
              <Brain className="w-6 h-6 text-white" />
            </div>
            <div>
              <h3 className="text-xl font-bold text-white mb-2">About Tactical Puzzles</h3>
              <p className="text-gray-400">
                Each mission contains unique puzzles that require critical thinking and problem-solving skills. 
                Successfully completing these puzzles unlocks bonus content, special weapons, and reveals hidden 
                story elements. Some puzzles are optional, but master operatives complete them all.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
