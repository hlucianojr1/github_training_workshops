# Urban Survivor - Architecture Overview

## Project Architecture

```
cpp_game/
├── .github/                    # CI/CD workflows (to be added)
│   └── copilot-instructions.md # AI coding guidelines
├── docs/                       # Project documentation
│   ├── ARCHITECTURE.md         # This file
│   ├── SPEC.md                 # Game design specification
│   ├── MEMORY.md               # Development decisions & context
│   ├── CODING_STANDARDS.md     # C++ and GDScript standards
│   ├── ART_GUIDELINES.md       # Asset creation guidelines
│   └── godot_gdextension_reference.md
├── src/                        # C++ GDExtension source
│   ├── core/                   # Core game systems
│   ├── player/                 # Player systems
│   ├── camera/                 # Camera systems
│   ├── ai/                     # Enemy AI
│   ├── combat/                 # Weapons & damage
│   ├── inventory/              # Items & inventory
│   ├── survival/               # Health, stamina
│   ├── world/                  # Level management
│   ├── ui/                     # HUD systems
│   └── register_types.cpp/hpp  # GDExtension registration
├── game/                       # Godot project
│   ├── scenes/                 # Scene files (.tscn)
│   ├── scripts/                # GDScript files
│   ├── assets/                 # Art, audio, models
│   │   ├── models/
│   │   ├── textures/
│   │   ├── audio/
│   │   ├── animations/
│   │   └── ui/
│   ├── bin/                    # Compiled extension DLLs
│   └── project.godot
├── external/                   # Third-party dependencies
│   └── godot-cpp/              # Godot C++ bindings
└── build/                      # CMake build output
```

---

## System Architecture

### Core Systems Hierarchy

```
GameManager (Singleton)
├── Controls game state (MENU, PLAYING, PAUSED, GAME_OVER)
├── Manages level transitions
├── Coordinates all subsystems
│
├── LevelManager
│   ├── Loads/unloads levels
│   ├── Manages spawn points
│   └── Tracks level objectives
│
├── PlayerController (CharacterBody3D)
│   ├── ThirdPersonCamera
│   ├── Inventory
│   ├── SurvivalStats
│   └── Equipped Weapon
│
├── AIManager (manages enemy pool)
│   └── EnemyAI[] (CharacterBody3D)
│       ├── AIPerception
│       └── NavigationAgent3D
│
├── DamageSystem
│   └── Processes all damage events
│
├── ItemDatabase (Singleton)
│   └── All item definitions
│
└── HUD (CanvasLayer)
    ├── Health/Stamina bars
    ├── Inventory quick-slots
    └── Crosshair/interaction prompts
```

---

## C++ GDExtension Classes

### Core Module (`src/core/`)
| Class | Base | Purpose |
|-------|------|---------|
| `GameManager` | Node | Global game state, level flow |

### Player Module (`src/player/`)
| Class | Base | Purpose |
|-------|------|---------|
| `PlayerController` | CharacterBody3D | Movement, input, player state |

### Camera Module (`src/camera/`)
| Class | Base | Purpose |
|-------|------|---------|
| `ThirdPersonCamera` | Camera3D | Orbit camera with collision |

### AI Module (`src/ai/`)
| Class | Base | Purpose |
|-------|------|---------|
| `EnemyAI` | CharacterBody3D | FSM-based enemy behavior |
| `AIPerception` | Node3D | Sight/hearing detection |

### Combat Module (`src/combat/`)
| Class | Base | Purpose |
|-------|------|---------|
| `Weapon` | Node3D | Weapon base class |
| `DamageSystem` | Node | Centralized damage processing |

### Inventory Module (`src/inventory/`)
| Class | Base | Purpose |
|-------|------|---------|
| `Inventory` | Node | Player inventory management |
| `Item` | Resource | Item data definition |
| `ItemDatabase` | Node | Item registry/factory |

### Survival Module (`src/survival/`)
| Class | Base | Purpose |
|-------|------|---------|
| `SurvivalStats` | Node | Health, stamina, hunger |

### World Module (`src/world/`)
| Class | Base | Purpose |
|-------|------|---------|
| `LevelManager` | Node | Level loading/transitions |
| `ScavengePoint` | Area3D | Lootable locations |

### UI Module (`src/ui/`)
| Class | Base | Purpose |
|-------|------|---------|
| `HUD` | CanvasLayer | In-game UI |

---

## Data Flow Patterns

### Input → Action Flow
```
Input Event
    ↓
PlayerController._input()
    ↓
┌─────────────────────────────────┐
│ Movement → _physics_process()   │
│ Shoot → Weapon.fire()           │
│ Interact → ScavengePoint.loot() │
│ Inventory → Inventory.use()     │
└─────────────────────────────────┘
```

### Damage Flow
```
Weapon.fire() / EnemyAI.attack()
    ↓
DamageSystem.apply_damage(target, amount, type, source)
    ↓
Target receives damage signal
    ↓
┌─────────────────────────────────────┐
│ PlayerController → SurvivalStats   │
│ EnemyAI → health tracking → death  │
└─────────────────────────────────────┘
    ↓
HUD updates (if player)
```

### AI Decision Flow
```
_physics_process(delta)
    ↓
AIPerception.update()
    ↓
┌────────────────────────────────┐
│ Can see player? → CHASE/ATTACK │
│ Heard noise? → INVESTIGATE     │
│ Low health? → FLEE/TAKE_COVER  │
│ Nothing? → PATROL/IDLE         │
└────────────────────────────────┘
    ↓
NavigationAgent3D.get_next_path_position()
    ↓
move_and_slide()
```

---

## Signal Architecture

### Key Signals
```gdscript
# GameManager
signal game_state_changed(new_state: int)
signal level_loaded(level_index: int)
signal game_over(victory: bool)

# PlayerController
signal movement_state_changed(new_state: int)
signal weapon_fired()
signal player_interacted(target: Node)
signal player_died()

# EnemyAI
signal state_changed(new_state: int)
signal enemy_died(enemy: EnemyAI)
signal player_spotted(player: Node)

# DamageSystem
signal damage_dealt(target: Node, amount: float, type: int)
signal entity_killed(entity: Node)

# Inventory
signal item_added(item: Item, count: int)
signal item_removed(item: Item, count: int)
signal inventory_full()

# SurvivalStats
signal health_changed(new_health: float, max_health: float)
signal stamina_changed(new_stamina: float, max_stamina: float)
signal stat_depleted(stat_name: String)
```

---

## Scene Composition Patterns

### Player Scene Structure
```
Player (PlayerController - C++)
├── CameraPivot (Node3D)
│   └── ThirdPersonCamera (C++)
├── CollisionShape3D
├── MeshInstance3D (or AnimatedMesh)
├── Inventory (C++)
├── SurvivalStats (C++)
└── WeaponMount (Node3D)
    └── [Equipped Weapon]
```

### Enemy Scene Structure
```
Enemy (EnemyAI - C++)
├── CollisionShape3D
├── NavigationAgent3D
├── AIPerception (C++)
│   ├── SightArea (Area3D)
│   └── HearingArea (Area3D)
├── MeshInstance3D
└── WeaponMount (Node3D)
```

### Level Scene Structure
```
Level (Node3D)
├── LevelManager (C++)
├── Environment
│   ├── StaticBody3D (buildings, terrain)
│   ├── NavigationRegion3D
│   └── Lighting
├── SpawnPoints (Node3D)
│   ├── PlayerSpawn (Marker3D)
│   └── EnemySpawns (Marker3D[])
├── ScavengePoints (Node3D)
│   └── ScavengePoint[] (C++)
├── Enemies (Node3D)
│   └── [EnemyAI instances]
└── WorldEnvironment
```

---

## Build System

### CMake Configuration
- Target: `urban_survivor` (shared library)
- C++ Standard: C++17
- Dependencies: godot-cpp (git submodule)
- Output: `game/bin/liburban_survivor.{platform}.{target}.{arch}.{ext}`

### Build Configurations
| Config | Use Case | Defines |
|--------|----------|---------|
| `Debug` | Development | `DEBUG`, symbols enabled |
| `Release` | Testing | Optimized, symbols stripped |
| `RelWithDebInfo` | Profiling | Optimized + symbols |

---

## Extension Points

### Adding New Enemy Types
1. Subclass `EnemyAI` or create new states
2. Register in `register_types.cpp`
3. Create scene prefab in `game/scenes/enemies/`

### Adding New Weapons
1. Subclass `Weapon` in `src/combat/`
2. Register in `register_types.cpp`
3. Add weapon stats to `ItemDatabase`
4. Create weapon scene with animations

### Adding New Items
1. Define item in `ItemDatabase`
2. Implement any special behavior
3. Create pickup scene

### Adding New Levels
1. Create level scene from template
2. Add to `LevelManager` level list
3. Configure navigation mesh
4. Place spawn points and scavenge locations
