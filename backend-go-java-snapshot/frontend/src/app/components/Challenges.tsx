import { Swords, Timer, Crosshair, Users, Flag, Skull } from 'lucide-react';

const challenges = [
  {
    icon: Swords,
    title: "Close Quarters Combat",
    description: "Get 50 melee kills in multiplayer",
    difficulty: "Medium",
    progress: 32,
    total: 50,
    reward: "1500 XP + Tactical Knife Skin",
    color: "border-yellow-500"
  },
  {
    icon: Timer,
    title: "Speed Run",
    description: "Complete Campaign Mission 7 under 8 minutes",
    difficulty: "Hard",
    progress: 0,
    total: 1,
    reward: "2000 XP + Ghost Operator",
    color: "border-red-500"
  },
  {
    icon: Crosshair,
    title: "Precision Strike",
    description: "Get 100 headshots with sniper rifles",
    difficulty: "Easy",
    progress: 87,
    total: 100,
    reward: "1000 XP + Sniper Charm",
    color: "border-green-500"
  },
  {
    icon: Users,
    title: "Team Player",
    description: "Win 20 team deathmatch games",
    difficulty: "Medium",
    progress: 14,
    total: 20,
    reward: "1500 XP + Team Badge",
    color: "border-blue-500"
  },
  {
    icon: Flag,
    title: "Objective Master",
    description: "Capture 100 objectives in any game mode",
    difficulty: "Medium",
    progress: 63,
    total: 100,
    reward: "1500 XP + Flag Emblem",
    color: "border-purple-500"
  },
  {
    icon: Skull,
    title: "Elimination Expert",
    description: "Get 25 kills in a single match",
    difficulty: "Hard",
    progress: 0,
    total: 1,
    reward: "2500 XP + Legendary Weapon",
    color: "border-orange-500"
  }
];

export function Challenges() {
  return (
    <section className="py-20 bg-black">
      <div className="max-w-7xl mx-auto px-4">
        <h2 className="text-5xl font-black text-white mb-4 text-center">CHALLENGES</h2>
        <p className="text-gray-400 text-center mb-12">Complete objectives to earn exclusive rewards</p>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {challenges.map((challenge, index) => {
            const Icon = challenge.icon;
            const progressPercent = (challenge.progress / challenge.total) * 100;
            
            return (
              <div
                key={index}
                className={`bg-gray-900 border-2 ${challenge.color} rounded-lg p-6 hover:shadow-lg hover:shadow-${challenge.color}/20 transition-all`}
              >
                <div className="flex items-start gap-4 mb-4">
                  <div className={`w-12 h-12 rounded-lg bg-gradient-to-br ${challenge.color === 'border-red-500' ? 'from-red-600 to-red-800' : challenge.color === 'border-yellow-500' ? 'from-yellow-600 to-yellow-800' : challenge.color === 'border-green-500' ? 'from-green-600 to-green-800' : challenge.color === 'border-blue-500' ? 'from-blue-600 to-blue-800' : challenge.color === 'border-purple-500' ? 'from-purple-600 to-purple-800' : 'from-orange-600 to-orange-800'} flex items-center justify-center flex-shrink-0`}>
                    <Icon className="w-6 h-6 text-white" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-white font-bold text-lg mb-1">{challenge.title}</h3>
                    <span className={`text-xs font-bold px-2 py-1 rounded ${
                      challenge.difficulty === 'Easy' ? 'bg-green-900 text-green-300' :
                      challenge.difficulty === 'Medium' ? 'bg-yellow-900 text-yellow-300' :
                      'bg-red-900 text-red-300'
                    }`}>
                      {challenge.difficulty}
                    </span>
                  </div>
                </div>
                
                <p className="text-gray-400 text-sm mb-4">{challenge.description}</p>
                
                <div className="mb-4">
                  <div className="flex justify-between text-sm mb-2">
                    <span className="text-gray-400">Progress</span>
                    <span className="text-white font-bold">{challenge.progress}/{challenge.total}</span>
                  </div>
                  <div className="w-full bg-gray-800 rounded-full h-2 overflow-hidden">
                    <div
                      className={`h-full ${challenge.color === 'border-red-500' ? 'bg-red-500' : challenge.color === 'border-yellow-500' ? 'bg-yellow-500' : challenge.color === 'border-green-500' ? 'bg-green-500' : challenge.color === 'border-blue-500' ? 'bg-blue-500' : challenge.color === 'border-purple-500' ? 'bg-purple-500' : 'bg-orange-500'} transition-all duration-300`}
                      style={{ width: `${progressPercent}%` }}
                    ></div>
                  </div>
                </div>
                
                <div className="pt-4 border-t border-gray-800">
                  <p className="text-xs text-gray-500 mb-1">REWARD</p>
                  <p className="text-sm text-green-400 font-bold">{challenge.reward}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
