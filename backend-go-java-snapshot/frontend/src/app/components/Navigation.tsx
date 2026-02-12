import { Menu, X } from 'lucide-react';
import { useState } from 'react';
import { GameSelector } from '@/app/components/GameSelector';

export function Navigation() {
  const [isOpen, setIsOpen] = useState(false);

  const navItems = ['Screenshots', 'Leaderboard', 'Trophies', 'Challenges', 'Campaign', 'Puzzles'];

  const scrollToSection = (item: string) => {
    const element = document.getElementById(item.toLowerCase());
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
      setIsOpen(false);
    }
  };

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-black/80 backdrop-blur-md border-b border-gray-800">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex items-center justify-between h-20">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-gradient-to-br from-red-500 to-orange-500 rounded-lg flex items-center justify-center">
              <span className="text-white font-black text-xl">ON</span>
            </div>
            <GameSelector />
          </div>
          
          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center gap-8">
            {navItems.map((item) => (
              <button
                key={item}
                onClick={() => scrollToSection(item)}
                className="text-gray-300 hover:text-white transition-colors font-bold"
              >
                {item.toUpperCase()}
              </button>
            ))}
          </div>
          
          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden text-white p-2"
          >
            {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
        
        {/* Mobile Navigation */}
        {isOpen && (
          <div className="md:hidden py-4 border-t border-gray-800">
            {navItems.map((item) => (
              <button
                key={item}
                onClick={() => scrollToSection(item)}
                className="block w-full text-left text-gray-300 hover:text-white transition-colors font-bold py-3"
              >
                {item.toUpperCase()}
              </button>
            ))}
          </div>
        )}
      </div>
    </nav>
  );
}
