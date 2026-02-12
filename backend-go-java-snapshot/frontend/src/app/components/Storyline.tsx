import { MapPin, Clock, Lock } from 'lucide-react';

const missions = [
  {
    number: 1,
    title: "Operation Ghost Protocol",
    location: "Moscow, Russia",
    duration: "15-20 min",
    status: "completed",
    description: "Infiltrate enemy base and extract classified intel. First contact with Shadow Syndicate.",
    unlocked: true
  },
  {
    number: 2,
    title: "Desert Storm",
    location: "Dubai, UAE",
    duration: "12-18 min",
    status: "completed",
    description: "Secure the weapons cache in the abandoned city. Discover the traitor's identity.",
    unlocked: true
  },
  {
    number: 3,
    title: "Frozen Wasteland",
    location: "Siberia, Russia",
    duration: "20-25 min",
    status: "completed",
    description: "Track down the arms dealer in harsh winter conditions. Uncover a larger conspiracy.",
    unlocked: true
  },
  {
    number: 4,
    title: "Urban Warfare",
    location: "Hong Kong, China",
    duration: "18-22 min",
    status: "active",
    description: "Navigate through dense city combat zones. Prevent a catastrophic terrorist attack.",
    unlocked: true
  },
  {
    number: 5,
    title: "Black Site",
    location: "Unknown Location",
    duration: "25-30 min",
    status: "locked",
    description: "Infiltrate the secret facility. Face the Shadow Syndicate's deadliest operatives.",
    unlocked: false
  },
  {
    number: 6,
    title: "Operation Nightfall",
    location: "Washington D.C., USA",
    duration: "30-35 min",
    status: "locked",
    description: "The final showdown. Stop the Shadow Syndicate's ultimate plan and save the world.",
    unlocked: false
  }
];

export function Storyline() {
  return (
    <section className="py-20 bg-gradient-to-b from-gray-900 to-black">
      <div className="max-w-6xl mx-auto px-4">
        <h2 className="text-5xl font-black text-white mb-4 text-center">CAMPAIGN</h2>
        <p className="text-gray-400 text-center mb-12">Follow the story. Complete the missions. Save the world.</p>
        
        <div className="relative">
          {/* Timeline line */}
          <div className="absolute left-8 top-0 bottom-0 w-0.5 bg-gradient-to-b from-red-500 via-orange-500 to-gray-700 hidden md:block"></div>
          
          <div className="space-y-8">
            {missions.map((mission, index) => (
              <div
                key={mission.number}
                className={`relative ${!mission.unlocked ? 'opacity-50' : ''}`}
              >
                {/* Timeline dot */}
                <div className={`absolute left-8 top-8 w-4 h-4 rounded-full -translate-x-1/2 hidden md:block ${
                  mission.status === 'completed' ? 'bg-green-500' :
                  mission.status === 'active' ? 'bg-orange-500 animate-pulse' :
                  'bg-gray-600'
                }`}></div>
                
                <div className="md:ml-20">
                  <div className={`bg-gray-900/50 backdrop-blur-sm border rounded-lg p-6 hover:border-red-500/50 transition-all ${
                    mission.status === 'active' ? 'border-orange-500' :
                    mission.status === 'completed' ? 'border-green-500/30' :
                    'border-gray-800'
                  }`}>
                    <div className="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
                      <div className="flex-1">
                        <div className="flex items-center gap-3 mb-3">
                          <span className="text-3xl font-black text-red-500">
                            {mission.number.toString().padStart(2, '0')}
                          </span>
                          <div>
                            <h3 className="text-2xl font-bold text-white mb-1">{mission.title}</h3>
                            <div className="flex flex-wrap items-center gap-4 text-sm text-gray-400">
                              <span className="flex items-center gap-1">
                                <MapPin className="w-4 h-4" />
                                {mission.location}
                              </span>
                              <span className="flex items-center gap-1">
                                <Clock className="w-4 h-4" />
                                {mission.duration}
                              </span>
                            </div>
                          </div>
                        </div>
                        <p className="text-gray-300 mb-4">{mission.description}</p>
                        
                        {mission.unlocked ? (
                          <button className={`px-6 py-2 rounded-lg font-bold transition-all ${
                            mission.status === 'completed' ? 'bg-green-900 text-green-300 cursor-default' :
                            mission.status === 'active' ? 'bg-gradient-to-r from-orange-600 to-red-600 text-white hover:from-orange-700 hover:to-red-700' :
                            'bg-gray-800 text-gray-400'
                          }`}>
                            {mission.status === 'completed' ? '✓ COMPLETED' :
                             mission.status === 'active' ? 'CONTINUE MISSION' :
                             'START MISSION'}
                          </button>
                        ) : (
                          <div className="flex items-center gap-2 text-gray-500">
                            <Lock className="w-4 h-4" />
                            <span className="font-bold">Complete previous missions to unlock</span>
                          </div>
                        )}
                      </div>
                      
                      <div className={`w-full md:w-48 h-32 rounded-lg overflow-hidden flex-shrink-0 ${
                        !mission.unlocked ? 'grayscale' : ''
                      }`}>
                        <img
                          src={`https://images.unsplash.com/photo-${
                            index % 2 === 0 ? '1637594619238-3df530c954ed' : '1638104977265-8e8ea24aa2aa'
                          }?w=400&h=300&fit=crop`}
                          alt={mission.title}
                          className="w-full h-full object-cover"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
        
        <div className="mt-16 bg-gradient-to-r from-red-900/20 to-orange-900/20 border border-red-800/30 rounded-lg p-8">
          <h3 className="text-3xl font-black text-white mb-4">THE SHADOW SYNDICATE</h3>
          <p className="text-gray-300 mb-4">
            A mysterious organization has emerged from the shadows, threatening global security. As an elite operative, 
            you must track down their leadership, dismantle their operations, and prevent a catastrophic attack that 
            could change the world forever.
          </p>
          <p className="text-gray-400 text-sm">
            Your choices matter. Each mission reveals more about the conspiracy. Trust no one. Complete the operation.
          </p>
        </div>
      </div>
    </section>
  );
}
