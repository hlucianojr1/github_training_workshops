# Urban Survivor

<div align="center">

**A third-person survival shooter set in post-apocalyptic 1960s New York City**

*Navigate through a frozen, nuclear winter Manhattan after World War III. Scavenge supplies, survive hostile encounters, and uncover the secrets of "Project Nightfall."*

[![Engine](https://img.shields.io/badge/Engine-Godot%204.3+-blue)](https://godotengine.org)
[![Language](https://img.shields.io/badge/Language-C%2B%2B17-orange)](https://isocpp.org)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20macOS%20|%20Linux-green)](#building)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

</div>

---

## 🎮 Game Overview

### Setting & Narrative
- **Era**: 1960s aesthetic, post-World War III nuclear winter
- **Location**: New York City — from Grand Central Terminal through Times Square
- **Theme**: Survival, resource scarcity, faction conflict, moral choices

### Core Gameplay Loop
- **Perspective**: Third-person shooter with tactical cover mechanics
- **Objective**: Traverse city zones from entry to exit while surviving hostile encounters
- **Mechanics**:
  - 🔫 **Combat**: Realistic 1960s firearms with recoil, spread, and reload systems
  - 🎒 **Scavenging**: Loot supplies from the environment (ammo, medical kits, food)
  - 🏃 **Survival**: Manage health, stamina, radiation exposure, and cold
  - 🤫 **Stealth**: "Car Crawl" mechanics, ankle pulls, and silent takedowns
  - 🧠 **Tactics**: Use cover, flank enemies, exploit AI behaviors

### Enemy Factions
| Faction | Description | Behavior |
|---------|-------------|----------|
| **Scavengers** | Desperate survivors competing for resources | Flee at low health, melee-focused |
| **Raiders** | Organized hostile groups | Aggressive, use cover, call for backup |
| **NYPD** | Corrupted police maintaining control | Patrol routes, flashlights, coordinated response |
| **Military Police** | Government forces enforcing quarantine | Heavy weapons, gas masks, suppress threats |

---

## 🏗️ Technical Architecture

### Technology Stack
- **Game Engine**: Godot 4.3+ with GDExtension
- **Core Systems**: C++17 for performance-critical code
- **UI & Scripting**: GDScript for rapid iteration
- **Build System**: CMake 3.20+
- **3D Pipeline**: Blender MCP integration for AI-assisted asset creation

### Why This Stack?
| Choice | Rationale |
|--------|-----------|
| **Godot + GDExtension** | Open-source engine with native C++ performance, no licensing fees |
| **C++ for Core Systems** | Compile-time type safety, optimal performance for AI/physics |
| **GDScript for UI** | Rapid iteration, hot-reload for interface development |
| **Blender MCP** | AI-assisted 3D asset creation workflow |

### System Architecture
```
GameManager (Singleton)
├── LevelManager — Zone loading, spawn points, objectives
├── DamageSystem — Centralized damage processing, hit zones
├── ItemDatabase — Item definitions, loot tables
│
├── PlayerController (CharacterBody3D)
│   ├── ThirdPersonCamera — Orbit camera with collision
│   ├── Inventory — Item management, quick slots
│   ├── SurvivalStats — Health, stamina, radiation
│   └── Weapon — Equipped firearm with firing mechanics
│
├── AIManager
│   └── EnemyAI[] — FSM-based enemy behaviors
│       ├── AIPerception — Sight/hearing detection
│       └── NavigationAgent3D — Pathfinding
│
└── HUD (CanvasLayer) — Health bars, ammo counter, crosshair
```

### C++ GDExtension Classes

| Module | Classes | Purpose |
|--------|---------|---------|
| **core/** | `GameManager` | Global game state, level flow, singletons |
| **player/** | `PlayerController` | Movement, input, player states, melee |
| **camera/** | `ThirdPersonCamera` | Orbit camera with spring arm collision |
| **ai/** | `EnemyAI`, `AIPerception` | FSM behaviors, sight/hearing detection |
| **combat/** | `Weapon`, `DamageSystem` | Firearms, hit zones, damage calculation |
| **inventory/** | `Inventory`, `Item`, `ItemDatabase` | Item management, loot system |
| **survival/** | `SurvivalStats` | Health, stamina, status effects |
| **world/** | `LevelManager`, `ScavengePoint` | Zone management, lootable locations |
| **ui/** | `HUD` | In-game UI components |

---

## 📁 Project Structure

```
urban_survivor/
├── 📄 CMakeLists.txt              # Build configuration
├── 📄 README.md                   # This file
│
├── 📂 src/                        # C++ GDExtension source
│   ├── core/                      # Game state management
│   ├── player/                    # Player controller & mechanics
│   ├── camera/                    # Third-person camera system
│   ├── ai/                        # Enemy AI & perception
│   ├── combat/                    # Weapons & damage system
│   ├── inventory/                 # Items & inventory
│   ├── survival/                  # Health, stamina systems
│   ├── world/                     # Level & scavenge points
│   ├── ui/                        # HUD components
│   └── register_types.cpp/hpp     # GDExtension registration
│
├── 📂 game/                       # Godot project
│   ├── project.godot              # Project configuration
│   ├── scenes/                    # Scene files (.tscn)
│   │   ├── player.tscn            # Player prefab
│   │   ├── level_1.tscn           # Level 1 (The Heights)
│   │   ├── enemies/               # Enemy prefabs
│   │   ├── weapons/               # Weapon prefabs
│   │   └── singletons/            # Autoload scenes
│   ├── scripts/                   # GDScript files
│   ├── assets/                    # Art, audio, models
│   │   ├── models/                # 3D models (GLB/GLTF)
│   │   ├── textures/              # PBR textures
│   │   └── materials/             # Material library
│   └── bin/                       # Compiled GDExtension DLLs
│
├── 📂 external/                   # Third-party dependencies
│   ├── godot-cpp/                 # Godot C++ bindings (submodule)
│   └── assimp/                    # Asset import library
│
├── 📂 docs/                       # Project documentation
│   ├── ARCHITECTURE.md            # System architecture
│   ├── MEMORY.md                  # Development decisions log
│   ├── PRODUCTION_PLAN.md         # Sprint planning
│   └── game_design_document.md    # Full GDD
│
├── 📂 .github/                    # AI Agent workflows
│   ├── agents/                    # 20 specialized AI agents
│   ├── prompts/                   # 37 task prompts
│   └── instructions/              # Coding guidelines
│
└── 📂 blender/                    # Blender project files
```

---

## 🛠️ Building & Running

### Prerequisites
- **CMake** 3.20+
- **C++17** compatible compiler (MSVC, Clang, GCC)
- **Godot 4.3+** (for the editor)
- **Git** (for submodules)

### Setup
```bash
# Clone with submodules
git clone --recursive https://github.com/yourusername/urban_survivor.git
cd urban_survivor

# Or initialize submodules if already cloned
git submodule update --init --recursive
```

### Build Commands

#### macOS (Apple Silicon / Intel)
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

#### Windows (Visual Studio)
```powershell
cmake -B build -G "Visual Studio 18 2026"
cmake --build build --config Release
```

#### Linux
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

### Running the Game
```bash
# macOS
/Applications/Godot.app/Contents/MacOS/Godot --path game

# Or open game/project.godot in Godot Editor and press F5
```

---

## 🎯 Development Status

### Milestone Progress

| Milestone | Status | Completion |
|-----------|--------|------------|
| **1. Vertical Slice** | ✅ Complete | 100% |
| **2. Art Pipeline** | 🔄 In Progress | 70% |
| **3. Level Integration** | 📋 Planned | 0% |
| **4. Audio & Polish** | 📋 Planned | 0% |

### Implemented Features

#### ✅ Combat System (Complete)
- Raycast-based weapon firing with debug visualization
- Hit zone damage multipliers (HEAD 2.5x, TORSO 1.0x, LIMBS 0.7x)
- Dynamic spread system (increases during sustained fire, recovers over time)
- Recoil system with camera kick and recovery
- Reload mechanics with animation phase events (mag_out, mag_in)
- Melee attack system (V key, sphere cast, 30 damage)

#### ✅ Player Systems (Complete)
- Full movement (walk, sprint, crouch, jump)
- Third-person camera with spring arm collision
- Inventory management with quick slots
- Survival stats (health, stamina with regeneration)
- Interaction system (E key, 2m raycast)
- Death flow with input disable and signals

#### ✅ AI System (Complete)
- Finite State Machine: IDLE → PATROL → INVESTIGATE → CHASE → ATTACK → TAKE_COVER → FLEE → DEAD
- AIPerception with sight/hearing detection cones
- NavigationAgent3D pathfinding
- Cover-seeking behavior with peek-shoot cycles
- Zone-based activation (reduces CPU for inactive enemies)
- Enemy variants: Scavenger (melee, flees) and Raider (ranged, aggressive)

#### ✅ HUD System (Complete)
- Health bar with damage flash
- Stamina bar with low-stamina warning
- Ammo counter (magazine / reserve)
- Dynamic crosshair with spread visualization
- Interaction prompts with distance fade

#### ✅ Level 1: "The Heights" (Complete)
- 3 zones: Traffic Jam → Checkpoint → Commercial Strip
- 8 enemies with zone-based activation
- 10 scavenge points with randomized loot
- Level exit trigger at subway entrance

### Asset Library (70+ Assets)

| Category | Count | Examples |
|----------|-------|----------|
| **Vehicles** | 17+ | Taxi variants, police cars, bus, M48 tank, vintage sedans |
| **Characters** | 6+ | Player (with 4 LODs), police, scavengers |
| **Buildings** | 10+ | CBS Skyscraper, apartments, military base, storefronts |
| **Props** | 15+ | Phone booth, lampposts, debris, tents, trash cans |
| **Weapons** | 2 | M1911 Pistol, Remington 870 Shotgun |

---

## 🎮 Controls

| Action | Input |
|--------|-------|
| Move | WASD |
| Look | Mouse |
| Sprint | Shift (hold) |
| Crouch | Ctrl (toggle) |
| Jump | Space |
| Aim | Right Mouse (hold) |
| Shoot | Left Mouse |
| Reload | R |
| Melee | V |
| Interact | E |
| Inventory | Tab |

---

## 🤖 AI-Assisted Development Workflow

Urban Survivor features a comprehensive **AI agent system** with 20 specialized agents and 37 task prompts for accelerated game development.

### Agent Categories

#### 🎯 Core Development Agents
| Agent | Expertise |
|-------|-----------|
| **Godot C++ Expert** | GDExtension patterns, bindings, node lifecycle, Godot 4.3+ API |
| **Combat Systems Developer** | Weapon mechanics, hit detection, damage calculation, recoil |
| **Enemy AI Developer** | FSM behaviors, perception systems, pathfinding, tactics |
| **GDScript UI Developer** | HUD components, menus, signal-based UI wiring |
| **Game Architecture Advisor** | System design, component composition, signal patterns |

#### 🎨 Art & Asset Agents
| Agent | Expertise |
|-------|-----------|
| **Blender AI Artist** | 3D modeling via MCP commands, primitives, modifiers, export |
| **BlenderKit Asset Scout** | Asset discovery, poly-budget filtering, license tracking |
| **Character Artist** | Player/enemy models, 1960s clothing, skeletal rigging |
| **Environment Artist** | 1960s NYC aesthetic, lighting, WorldEnvironment, fog |
| **Texture Artist** | PBR materials, PolyHaven integration, procedural textures |
| **Animation Artist** | Locomotion cycles, combat animations, Mixamo retargeting |
| **GLB Import Reviewer** | Model quality assessment, Godot compatibility checks |

#### 📋 Planning & Documentation Agents
| Agent | Expertise |
|-------|-----------|
| **Sprint Planner** | Task breakdown, milestone planning, resource allocation |
| **Code Reviewer** | Standards compliance, architecture validation |
| **Documentation Maintainer** | MEMORY.md updates, decision logging |
| **3D Model Spec Writer** | Technical specs for 3D artists with poly budgets |
| **Level Populator** | Asset placement, scene hierarchy, performance optimization |

#### 🔊 Audio & Effects Agents
| Agent | Expertise |
|-------|-----------|
| **Audio Ambience Designer** | 1960s soundscapes, dynamic music, spatial audio |
| **Godot Shader Specialist** | Post-processing, PBR materials, visual effects |

#### 🛠️ Support Agents
| Agent | Expertise |
|-------|-----------|
| **Urban Survivor Debugger** | GDExtension crashes, null pointers, build issues |

### Key Prompts by Category

#### 🔧 Combat & Gameplay Implementation
```
implement-weapon-raycast    — Weapon firing with raycast hit detection
implement-reload-state      — Reload state machine with animation events
add-hit-zones               — Damage multipliers for body regions
implement-ai-attack-state   — Enemy attack behavior patterns
implement-ai-cover-seek     — AI cover-seeking and peek-shoot cycles
```

#### 🎨 Visual & Audio Setup
```
setup-worldenvironment-1960s    — Post-apocalyptic color grading, fog
implement-volumetric-lighting   — Light shafts, dust particles, shadows
configure-ambience-system       — Audio zones, dynamic music triggers
populate-1960s-props            — Period-accurate NYC street furniture
```

#### 🏗️ Asset Creation Pipeline
```
spec-player-model         — Generate player character specification
spec-enemy-model          — Generate enemy character specification
spec-vehicle-model        — Generate 1960s vehicle specification
spec-building-model       — Generate architecture specification
blender-create-character  — Generate character model from spec
blender-create-vehicle    — Generate vehicle model from spec
import-mixamo-animations  — Import and retarget Mixamo animations
material-library-workflow — PBR material creation pipeline
```

#### 🔨 Infrastructure & Tools
```
register-new-class           — Register C++ class in GDExtension
bind-cpp-method              — Expose C++ method to GDScript
debug-extension-not-loading  — Troubleshoot GDExtension issues
update-cmake-sources         — Update CMake build configuration
update-memory-entry          — Log decisions to MEMORY.md
```

### Blender MCP Integration

The project integrates with **Blender MCP Server** for AI-driven 3D asset creation:

```
Workflow:
1. model-spec-writer creates detailed specification
2. blender-artist reads spec and generates model via MCP commands
3. texture-artist applies PBR materials and weathering
4. Model exports to game/assets/models/[category]/
5. Import in Godot with proper settings
```

**MCP Capabilities:**
- Scene management (clear, list objects)
- Primitive creation and mesh manipulation
- Modifier application (subdivision, bevel, mirror)
- PBR material assignment with procedural textures
- GLTF/GLB export for Godot compatibility
- AI model generation via Hunyuan3D/Hyper3D

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | System hierarchy, data flow, class relationships |
| [MEMORY.md](docs/MEMORY.md) | Development decisions, technical learnings, issue resolutions |
| [PRODUCTION_PLAN.md](docs/PRODUCTION_PLAN.md) | Sprint planning, milestone breakdown, resource allocation |
| [game_design_document.md](docs/game_design_document.md) | Full GDD with gameplay flowcharts |
| [CODING_STANDARDS.md](docs/CODING_STANDARDS.md) | C++ and GDScript coding conventions |
| [ART_GUIDELINES.md](docs/ART_GUIDELINES.md) | Asset creation specs, poly budgets, naming |
| [WORKFLOW.md](docs/WORKFLOW.md) | Git workflow, sprint cycles, review process |
| [BUILD_INSTRUCTIONS.md](docs/BUILD_INSTRUCTIONS.md) | Platform-specific build guides |

---

## 🚀 Quick Start for Contributors

### 1. Set Up Development Environment
```bash
git clone --recursive https://github.com/yourusername/urban_survivor.git
cd urban_survivor
cmake -B build
cmake --build build
```

### 2. Open in Godot
```bash
# Open the Godot editor with the project
godot --path game
```

### 3. Use AI Agents
The project includes specialized AI agents in `.github/agents/`. When working with GitHub Copilot:

- **For C++ work**: Use `Godot C++ Expert` or `Combat Systems Developer`
- **For AI behavior**: Use `Enemy AI Developer`
- **For 3D assets**: Use `Blender AI Artist` or `Character Artist`
- **For planning**: Use `Sprint Planner`

### 4. Follow the Workflow
1. Create feature branch from `develop`
2. Implement changes following [CODING_STANDARDS.md](docs/CODING_STANDARDS.md)
3. Build and test: `cmake --build build && godot --path game`
4. Update [MEMORY.md](docs/MEMORY.md) with decisions
5. Create PR for review

---

## 📄 License

MIT License — See [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built with Godot 4.3+ | C++17 | AI-Assisted Development**

*"In the frozen streets of 1960s Manhattan, every supply cache could be your salvation... or your last mistake."*

</div>