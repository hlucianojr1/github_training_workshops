import { Play, Download } from 'lucide-react';

export function Hero() {
  return (
    <section className="relative h-screen flex items-center justify-center overflow-hidden">
      <div className="absolute inset-0 z-0">
        <img
          src="https://images.unsplash.com/photo-1603459404717-3be44e62c824?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmdXR1cmlzdGljJTIwZnBzJTIwZ2FtZSUyMHNvbGRpZXJ8ZW58MXx8fHwxNzY5NTY0OTIyfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
          alt="Hero Background"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-black/70 via-black/50 to-black"></div>
      </div>
      
      <div className="relative z-10 text-center px-4 max-w-5xl mx-auto">
        <h1 className="text-6xl md:text-8xl font-black mb-6 text-white tracking-tight">
          OPERATION<br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-red-500 to-orange-500">
            NIGHTFALL
          </span>
        </h1>
        <p className="text-xl md:text-2xl text-gray-300 mb-8 max-w-2xl mx-auto">
          Enter the battlefield. Complete the mission. Become a legend.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <button className="bg-gradient-to-r from-red-600 to-orange-600 text-white px-8 py-4 rounded-lg font-bold text-lg hover:from-red-700 hover:to-orange-700 transition-all flex items-center gap-2 justify-center">
            <Play className="w-6 h-6" />
            PLAY NOW
          </button>
          <button className="bg-white/10 backdrop-blur-sm border border-white/20 text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white/20 transition-all flex items-center gap-2 justify-center">
            <Download className="w-6 h-6" />
            DOWNLOAD
          </button>
        </div>
      </div>
    </section>
  );
}
