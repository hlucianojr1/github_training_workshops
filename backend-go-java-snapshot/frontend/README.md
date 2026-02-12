# Game Frontend - Operation Nightfall

A modern React-based frontend for the high scores demo project. This is a first-person shooter game themed website featuring leaderboards, trophies, challenges, and more.

## Tech Stack

- **React 18** - UI library
- **Vite** - Build tool and dev server
- **TypeScript** - Type safety
- **Tailwind CSS 4** - Utility-first CSS framework
- **Radix UI** - Headless UI components
- **Lucide React** - Icon library
- **Recharts** - Charting library

## Features

- **Hero Section** - Stunning landing page with call-to-action
- **Screenshots Gallery** - Game screenshots showcase
- **Leaderboard** - Top player rankings with scores, kills, and wins
- **Trophies** - Achievement system display
- **Challenges** - Game challenges and missions
- **Campaign/Storyline** - Story mode information
- **Puzzles** - Mini-games section

## Getting Started

### Prerequisites

- Node.js 18+ or 20+
- npm, yarn, or pnpm

### Installation

```bash
cd frontend
npm install
```

### Development

Start the development server:

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

### Build for Production

```bash
npm run build
```

### Preview Production Build

```bash
npm run preview
```

## Project Structure

```
frontend/
├── src/
│   ├── app/
│   │   ├── App.tsx              # Main application component
│   │   └── components/
│   │       ├── Hero.tsx         # Hero section
│   │       ├── Leaderboard.tsx  # Leaderboard table
│   │       ├── Navigation.tsx   # Navigation bar
│   │       ├── Screenshots.tsx  # Screenshot gallery
│   │       ├── Trophies.tsx     # Trophies display
│   │       ├── Challenges.tsx   # Challenges section
│   │       ├── Storyline.tsx    # Campaign storyline
│   │       ├── Puzzles.tsx      # Puzzles section
│   │       ├── figma/           # Figma-related utilities
│   │       └── ui/              # Reusable UI components
│   ├── styles/
│   │   ├── index.css            # Main stylesheet
│   │   ├── fonts.css            # Font definitions
│   │   ├── tailwind.css         # Tailwind imports
│   │   └── theme.css            # Theme customizations
│   └── main.tsx                 # Application entry point
├── index.html                   # HTML template
├── vite.config.ts               # Vite configuration
├── tsconfig.json                # TypeScript configuration
└── package.json                 # Dependencies and scripts
```

## Original Design

This frontend was originally designed in Figma. Design reference: [First Person Shooter Game Site](https://www.figma.com/design/ZcSbKPfvTt4PeMLx2tj7em/First-Person-Shooter-Game-Site)
