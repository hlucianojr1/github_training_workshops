import { Trophy, Star, Award, Target, Crosshair, Zap, Shield, Skull, Crown, Flame } from 'lucide-react';

const trophies = [
  {
    icon: Crown,
    name: "Champion",
    description: "Win 100 matches",
    rarity: "Legendary",
    color: "from-yellow-400 to-orange-500",
    bgColor: "bg-yellow-900/20"
  },
  {
    icon: Skull,
    name: "Headhunter",
    description: "1000 headshot kills",
    rarity: "Epic",
    color: "from-purple-400 to-pink-500",
    bgColor: "bg-purple-900/20"
  },
  {
    icon: Flame,
    name: "Hot Streak",
    description: "20 kills without dying",
    rarity: "Epic",
    color: "from-orange-400 to-red-500",
    bgColor: "bg-orange-900/20"
  },
  {
    icon: Shield,
    name: "Defender",
    description: "Protect 50 objectives",
    rarity: "Rare",
    color: "from-blue-400 to-cyan-500",
    bgColor: "bg-blue-900/20"
  },
  {
    icon: Crosshair,
    name: "Sharpshooter",
    description: "95% accuracy over 10 matches",
    rarity: "Rare",
    color: "from-green-400 to-emerald-500",
    bgColor: "bg-green-900/20"
  },
  {
    icon: Zap,
    name: "Speed Demon",
    description: "Complete mission under 5 minutes",
    rarity: "Rare",
    color: "from-cyan-400 to-blue-500",
    bgColor: "bg-cyan-900/20"
  },
  {
    icon: Target,
    name: "Marksman",
    description: "500 long-range eliminations",
    rarity: "Uncommon",
    color: "from-gray-400 to-gray-500",
    bgColor: "bg-gray-800/20"
  },
  {
    icon: Award,
    name: "First Blood",
    description: "Get the first kill in 50 matches",
    rarity: "Uncommon",
    color: "from-red-400 to-red-500",
    bgColor: "bg-red-900/20"
  },
  {
    icon: Star,
    name: "Veteran",
    description: "Play 500 matches",
    rarity: "Common",
    color: "from-gray-300 to-gray-400",
    bgColor: "bg-gray-700/20"
  },
  {
    icon: Trophy,
    name: "Winner",
    description: "Win your first match",
    rarity: "Common",
    color: "from-gray-300 to-gray-400",
    bgColor: "bg-gray-700/20"
  }
];

export function Trophies() {
  return (
    <section className="py-20 bg-gray-900">
      <div className="max-w-7xl mx-auto px-4">
        <h2 className="text-5xl font-black text-white mb-4 text-center">TROPHIES</h2>
        <p className="text-gray-400 text-center mb-12">Unlock achievements and prove your skills</p>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">
          {trophies.map((trophy, index) => {
            const Icon = trophy.icon;
            return (
              <div
                key={index}
                className={`${trophy.bgColor} border border-gray-800 rounded-lg p-6 hover:scale-105 transition-transform cursor-pointer`}
              >
                <div className={`w-16 h-16 rounded-full bg-gradient-to-br ${trophy.color} flex items-center justify-center mb-4 mx-auto`}>
                  <Icon className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-white font-bold text-center mb-2">{trophy.name}</h3>
                <p className="text-gray-400 text-sm text-center mb-3">{trophy.description}</p>
                <div className="text-center">
                  <span className={`text-xs font-bold px-3 py-1 rounded-full bg-gradient-to-r ${trophy.color} text-white`}>
                    {trophy.rarity}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
