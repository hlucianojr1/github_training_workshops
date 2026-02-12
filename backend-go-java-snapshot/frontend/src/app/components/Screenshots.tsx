import { useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const screenshots = [
  {
    url: "https://images.unsplash.com/photo-1637594619238-3df530c954ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmcHMlMjBnYW1lJTIwbmlnaHQlMjBjb21iYXR8ZW58MXx8fHwxNzY5NTY0OTIzfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "Night Operations",
    description: "Tactical stealth missions in urban environments"
  },
  {
    url: "https://images.unsplash.com/photo-1737363642262-8866f0903a1f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtaWxpdGFyeSUyMHRhY3RpY2FsJTIwc2hvb3RlcnxlbnwxfHx8fDE3Njk1NjEwMzN8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "Desert Warfare",
    description: "Intense combat in hostile territories"
  },
  {
    url: "https://images.unsplash.com/photo-1681045110239-fe01f330844f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmcHMlMjBnYW1lJTIwZGVzZXJ0JTIwd2FyZmFyZXxlbnwxfHx8fDE3Njk1NjQ5MjN8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "Special Forces",
    description: "Elite squad tactical operations"
  },
  {
    url: "https://images.unsplash.com/photo-1638104977265-8e8ea24aa2aa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjeWJlcnB1bmslMjBzb2xkaWVyJTIwYXJtb3J8ZW58MXx8fHwxNzY5NTY0OTI0fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "Future Combat",
    description: "Advanced warfare technology"
  }
];

export function Screenshots() {
  const [currentIndex, setCurrentIndex] = useState(0);

  const nextSlide = () => {
    setCurrentIndex((prev) => (prev + 1) % screenshots.length);
  };

  const prevSlide = () => {
    setCurrentIndex((prev) => (prev - 1 + screenshots.length) % screenshots.length);
  };

  return (
    <section className="py-20 bg-black">
      <div className="max-w-7xl mx-auto px-4">
        <h2 className="text-5xl font-black text-white mb-4 text-center">SCREENSHOTS</h2>
        <p className="text-gray-400 text-center mb-12">Experience the intensity of combat</p>
        
        <div className="relative">
          <div className="aspect-video relative overflow-hidden rounded-lg">
            <img
              src={screenshots[currentIndex].url}
              alt={screenshots[currentIndex].title}
              className="w-full h-full object-cover"
            />
            <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/90 to-transparent p-6">
              <h3 className="text-2xl font-bold text-white mb-2">{screenshots[currentIndex].title}</h3>
              <p className="text-gray-300">{screenshots[currentIndex].description}</p>
            </div>
          </div>
          
          <button
            onClick={prevSlide}
            className="absolute left-4 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white p-3 rounded-full transition-all"
          >
            <ChevronLeft className="w-6 h-6" />
          </button>
          
          <button
            onClick={nextSlide}
            className="absolute right-4 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white p-3 rounded-full transition-all"
          >
            <ChevronRight className="w-6 h-6" />
          </button>
          
          <div className="flex gap-2 justify-center mt-6">
            {screenshots.map((_, index) => (
              <button
                key={index}
                onClick={() => setCurrentIndex(index)}
                className={`w-3 h-3 rounded-full transition-all ${
                  index === currentIndex ? 'bg-red-500 w-8' : 'bg-gray-600'
                }`}
              />
            ))}
          </div>
        </div>
        
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-8">
          {screenshots.map((screenshot, index) => (
            <button
              key={index}
              onClick={() => setCurrentIndex(index)}
              className={`aspect-video rounded-lg overflow-hidden border-2 transition-all ${
                index === currentIndex ? 'border-red-500' : 'border-transparent opacity-60 hover:opacity-100'
              }`}
            >
              <img
                src={screenshot.url}
                alt={screenshot.title}
                className="w-full h-full object-cover"
              />
            </button>
          ))}
        </div>
      </div>
    </section>
  );
}
