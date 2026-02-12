# Urban Survivor - Development Memory

## Purpose
This document captures key development decisions, context, and lessons learned for AI agents and team members joining the project.

---

## Project Context

### What We're Building
A **third-person survival shooter** using:
- **Engine**: Godot 4.3+ with C++ GDExtension
- **Theme**: Post-apocalyptic 1960s America after WW3
- **Core Loop**: Traverse city levels, scavenge supplies, survive enemy encounters

### Why GDExtension + C++?
1. **Performance**: C++ for computationally heavy systems (AI, physics, combat)
2. **Type Safety**: Catch errors at compile time
3. **Familiarity**: Team has C++ experience
4. **Control**: Fine-grained memory and performance control

### Why Godot 4?
1. **Open Source**: No licensing fees
2. **GDExtension**: Native C++ without engine modification
3. **Modern Features**: Vulkan renderer, improved physics
4. **Lightweight**: Fast iteration times

---

## Technical Decisions Log

### 2025-11-30: Initial Architecture
**Decision**: Split code between C++ GDExtension and GDScript
- **C++ (GDExtension)**: Core systems, performance-critical code
  - PlayerController, EnemyAI, Inventory, Weapons, DamageSystem
- **GDScript**: UI, scene management, prototyping
  - Menus, HUD binding, level scripts

**Rationale**: Best of both worlds - C++ performance where needed, GDScript flexibility for rapid iteration

### 2025-11-30: Scene Composition Pattern
**Decision**: Use composition over inheritance for game entities
- Player = CharacterBody3D + Inventory + SurvivalStats + WeaponMount
- Enemy = CharacterBody3D + AIPerception + NavigationAgent3D

**Rationale**: Godot's node system favors composition; easier to mix and match behaviors

### 2025-11-30: AI State Machine
**Decision**: Finite State Machine (FSM) for enemy AI
- States: IDLE, PATROL, INVESTIGATE, CHASE, ATTACK, TAKE_COVER, FLEE, DEAD
- Single state active at a time, clean transitions

**Rationale**: Simple to implement, debug, and extend. Behavior Trees considered but FSM sufficient for initial scope.

### 2025-11-30: Signal-Based Communication
**Decision**: Use Godot signals for inter-system communication
- DamageSystem emits `damage_dealt`, `entity_killed`
- UI subscribes to player stats signals
- No direct coupling between systems

**Rationale**: Loose coupling, easier testing, cleaner architecture

### 2026-01-10: Singletons Folder & Autoload Architecture
**Decision**: Established `game/scenes/singletons/` folder for global autoload scenes
- **Singleton Scenes Created** (in load order):
  1. `game_manager.tscn` — GameManager C++ node (loads first, all systems depend on game state)
  2. `item_database.tscn` — ItemDatabase C++ node (Inventory/DamageSystem may reference items)
  3. `damage_system.tscn` — DamageSystem C++ node with `damage_system` group

- **Registered in project.godot [autoload]**:
  ```ini
  GameManager="*res://scenes/singletons/game_manager.tscn"
  ItemDatabase="*res://scenes/singletons/item_database.tscn"
  DamageSystem="*res://scenes/singletons/damage_system.tscn"
  ```

- **C++ Singleton Pattern**: Each singleton class implements:
  - Static `singleton` pointer (set in constructor, cleared in destructor)
  - Static `get_singleton()` method for C++ access
  - GameManager now has this pattern (was missing before)

**Problem Solved**: HUD controller warning `[HUD Controller] DamageSystem not found` — DamageSystem was implemented in C++ but never instantiated as an autoload.

**Rationale**: 
- Autoloads ensure singletons exist before any scene loads
- Load order matters: GameManager → ItemDatabase → DamageSystem
- Removed redundant inline DamageSystem node from `test_scene.tscn` (autoload provides it globally)
- Pattern matches ARCHITECTURE.md design intent

**Future Singleton Candidates** (add when implemented):
- `AudioManager` — Audio buses, sound pooling, music transitions
- `SaveManager` — Save/load game state (depends on GameManager)
- `DynamicMusicManager` (GDScript) — Dynamic music state machine
- `EventBus` (GDScript) — Global signal bus for decoupled events

**Note**: `LevelManager` should NOT be a singleton — it's per-level and tracks level-specific state.

### 2025-12-18: Art & Audio Agent/Prompt Structure
**Decision**: Added specialized agents and prompts for visual and audio aesthetics
- **New Agents**:
  - `environment-artist` — 1960s NYC destruction aesthetic, lighting, WorldEnvironment, weather
  - `character-artist` — Player/enemy models, 1960s clothing, animation integration
  - `audio-ambience` — Period soundscapes, dynamic music, 3D spatial audio
- **New Prompts**:
  - `setup-worldenvironment-1960s` — Configure post-apocalyptic color grading and fog
  - `implement-volumetric-lighting` — Light shafts, dust particles, dramatic shadows
  - `create-player-model-spec` — Define player character requirements
  - `setup-animation-tree` — Locomotion blend spaces and combat states
  - `configure-ambience-system` — Audio zones, dynamic music triggers
  - `populate-1960s-props` — Period-accurate NYC environmental props

**Rationale**: Original agent set focused on code/systems. Visual aesthetic (1960s NYC look) and audio design were missing from workflow. These additions ensure the game's unique period aesthetic is consistently implemented.

**Roadmap Updated**: Added 1960s aesthetic tasks to Phase 2 (Vertical Slice), Phase 3 (Alpha), and Phase 4 (Beta) in SPEC.md.

### 2025-12-18: 3D Model Specification System
**Decision**: Added model-spec-writer agent and model spec prompts
- **New Agent**:
  - `model-spec-writer` — Creates detailed 3D model specifications for artists
- **New Prompts**:
  - `spec-player-model` — Player character model specification
  - `spec-enemy-model` — Enemy character model specifications
  - `spec-vehicle-model` — 1960s vehicle model specifications
  - `spec-prop-model` — Props and weapons specifications
  - `spec-building-model` — Building and environment specifications

**Rationale**: Game currently uses CSG placeholder boxes. To get proper 3D models, artists need detailed technical specifications. This system provides a repeatable workflow for documenting any model type with consistent format including poly budgets, textures, 1960s era accuracy, and Godot integration requirements.

**First Deliverable**: Created `docs/models/PLAYER_MODEL_SPEC.md` with complete player character requirements.

### 2025-12-18: Blender MCP Integration for AI Model Generation
**Decision**: Added Blender MCP server integration for AI-driven 3D model creation
- **New Agent**:
  - `blender-artist` — Creates 3D models directly in Blender via MCP server commands
- **New Prompts**:
  - `blender-create-character` — Generate character models from specs
  - `blender-create-vehicle` — Generate 1960s vehicles from specs
  - `blender-create-prop` — Generate street props and items

**Blender MCP Capabilities**:
- Scene management (clear, list objects)
- Primitive creation (cube, sphere, cylinder, plane)
- Object manipulation (move, rotate, scale, duplicate)
- Modifiers (subdivision, bevel, mirror)
- PBR material assignment (color, metallic, roughness)
- UV unwrapping via Python scripts
- GLTF export for Godot import

**Workflow**:
1. `model-spec-writer` creates specification document
2. `blender-artist` reads spec and generates model via MCP commands
3. Model exports to `game/assets/models/[category]/`
4. Import in Godot for testing

**Directory Structure Created**:
```
game/assets/models/
├── characters/
├── enemies/
├── vehicles/
├── props/
└── weapons/
```

**Rationale**: Enables AI-assisted 3D model creation without manual Blender work. Placeholder/simple models can be generated quickly; detailed models may need external refinement.

### 2025-12-23: Texture Artist Agent Added
**Decision**: Added specialized agent for PBR material creation
- **New Agent**:
  - `texture-artist` — Creates PBR materials using Blender MCP Material System with 20+ presets and PolyHaven integration

**Capabilities**:
- Apply 20+ procedural material presets (metal, fabric, leather, wood, concrete, rust, etc.)
- Integrate PolyHaven textures for photorealistic materials
- Auto-enhance materials based on object context
- Set up proper lighting for material verification
- Export materials compatible with Godot 4

**Rationale**: Materials are critical for visual quality. This agent bridges the gap between geometry creation (`blender-artist`) and final appearance, ensuring consistent 1960s aesthetic across all assets.

### 2025-12-23: Model Import Pipeline Established
**Decision**: Created automated model import workflow for external assets
- **New Scripts**:
  - `import_obj_model.sh` — Generic OBJ import automation
  - `import_survivor.sh` — Survivor character import
  - `import_police_officer.sh` — Police officer enemy import
  - `import_taxi.sh` — 1960s taxi vehicle import
  - `import_police_car.sh` — Police car vehicle import
  - `import_chevy_wrecked.sh` — Wrecked Chevy Bel Air import
  - `verify_integration.sh` — Validates player/scene integration

**Documentation**:
- `MODEL_IMPORT_SUMMARY.md` — Tracks imported models and statistics
- `IMPORT_MODELS_README.md` — Quick reference for import commands

**Models Imported**:
- Phone booth (classic Superman style)
- 1957 Chevrolet Bel Air (wrecked variant)
- 1960s NYC Yellow Taxi
- Police car
- Chrysler New Yorker 1960

**Rationale**: External 3D assets (OBJ/GLB files) needed a standardized import process with consistent naming, proper Godot configuration, and documentation tracking.

### 2025-12-23: Savage Character Integration
**Decision**: Integrated "Savage" character model as the player character
- **Model**: `savage.glb` (2.3MB GLB with textures)
- **Location**: `game/assets/models/characters/savage.glb`

**Player Scene Structure** (`game/scenes/player.tscn`):
```
Player (PlayerController - C++ CharacterBody3D)
├── CollisionShape3D (Capsule: 0.35m radius × 1.75m height)
├── SavageModel (savage.glb visual mesh)
├── ThirdPersonCamera (C++ camera system)
│   └── Camera3D (positioned at shoulder)
├── SurvivalStats (C++ component)
├── Inventory (C++ component)
└── Weapon (M1911 pistol)
    └── MuzzlePoint
```

**Camera Configuration**:
| Setting | Normal | Aiming |
|---------|--------|--------|
| Arm Length | 3.5m | 1.8m |
| Arm Height | 1.5m | 1.5m |
| Shoulder Offset | 0.5m (right) | 0.5m |
| FOV | 75° | 55° |

**Documentation**:
- `QUICKSTART_SAVAGE.md` — 3-step quick start guide
- `INTEGRATION_SUMMARY.md` — Full integration details
- `SAVAGE_CHARACTER_INTEGRATION.md` — C++ class integration notes

**Rationale**: Replaced CSG placeholder with actual character model. Savage model provides proper humanoid proportions for third-person camera and collision systems.

### 2025-12-23: Enemy Character Models Added
**Decision**: Added enemy character models for combat encounters
- **Police Officer**: `char_enemy_police_officer_lod0.glb` — Corrupt police enemy type
- **Scavenger**: `char_enemy_scavenger_lod0.gltf` — Hostile survivor enemy type

**Rationale**: AI enemies need visual distinction from player. Police officer represents authority threat, scavenger represents survivor-vs-survivor conflict.

### 2025-12-23: Vehicle Fleet Completed
**Decision**: Added period-accurate 1960s vehicle models
- **Taxi** (`vehicle_taxi_lod0.glb`): NYC Yellow Cab for street cover
- **Police Car** (`vehicle_police_car_1960s_lod0.gltf`): NYPD vehicle for checkpoint scenes
- **Wrecked Chevy** (`vehicle_chevy_belair_wrecked_lod0.glb`): Damaged vehicle for apocalyptic atmosphere
- **Chrysler New Yorker** (`chrysler_new_yorker_1960.gltf`): Period luxury car

### 2026-01-12: Vintage Sedan with Enhanced Materials
**Decision**: Added AI-generated vintage sedan with procedural weathering materials
- **Model**: `sedan_vintage_01.glb` (28,207 vertices, 19,495 polygons)
- **Type**: Classic 1960s Soviet-era sedan (GAZ/Volga style)
- **Location**: `game/assets/models/vehicles/sedan_vintage_01.glb`
- **Materials**: Enhanced PBR with procedural weathering
  - Roughness: 0.75 (weathered oxidized paint)
  - Metallic: 0.05 (non-metallic aged paint)
  - Procedural dirt/grime overlay: 35% blend factor
  - Noise-based weathering pattern (scale 25.0)
- **Aesthetic**: Perfect for 1960s abandoned vehicle scenes
- **Source**: Blender MCP generation via Hyper3D/Hunyuan3D
- **Import Archive**: `archive/sedan_vintage_01_import/`

**Rationale**: Needed additional civilian vehicle variety for level population. This sedan provides authentic 1960s Eastern European aesthetic (common in period NYC). AI-generated model workflow validated with professional material enhancement using Blender MCP Material System.

### 2026-01-12: Major Vehicle Fleet Expansion
**Decision**: Added comprehensive 1960s vehicle collection for level population
- **GMC City Bus** (`bus_1960_gmc.gltf`): Period-accurate transit bus for Zone 1 road block
- **Standard Bus** (`bus_1960.gltf`): Alternate bus variant
- **Checker Marathon Taxi** (`prop_vehicle_taxi_checker_marathon_lod0.gltf`): Iconic NYC yellow cab
- **Clean Taxi** (`taxi_1960_clean.gltf`): Undamaged taxi for variety
- **1960s Taxi** (`taxi_1960s.glb`): Additional taxi variant
- **Cadillac Convertible** (`cadillac_convertible_1960.glb`): Luxury vehicle wreck
- **1960 Limousine** (`limo_1960.gltf`): High-end vehicle for dramatic scenes
- **Vintage Pickup Truck** (`vehicle_pickup_vintage.glb`): Utility vehicle
- **1960 Truck** (`truck_1960.gltf`): Commercial vehicle
- **M48 Patton Tank** (`vehicle_tank_m48_lod0.glb`): Hero prop for Zone 2 checkpoint
- **Police Sedan** (`vehicle_police_sedan_1960s.glb`): Additional police variant

**Scene Integration**:
- Zone 1 (Traffic Jam): Bus blocking road, mixed civilian vehicles for cover
- Zone 2 (Checkpoint): M48 Tank centerpiece, police vehicles, military presence
- Zone 3 (Commercial Strip): Abandoned taxis, civilian cars, delivery trucks

**Rationale**: Vehicles are critical for 1960s NYC aesthetic and provide combat cover. Mix of working/wrecked states reinforces post-apocalyptic theme. Tank fulfills Zone 2 hero prop requirement from ASSET_TRACKER.md.

### 2026-01-12: Building & Architecture Assets Added
**Decision**: Added first architecture assets for Level 1
- **CBS Skyscraper** (`building_cbs_skyscraper_lod0.glb`): ~6.5MB, 1960s-era skyscraper for skyline backdrop
- **Military Base** (`building_military_base_lod0.glb`): ~4MB, military compound structure

**Rationale**: Architecture needed for visual depth and 1960s NYC skyline. CBS building provides period-accurate backdrop. Military base supports checkpoint/fortification scenes.

### 2026-01-12: Props & Environment Assets Expanded
**Decision**: Added street furniture and shelter props
- **Debris Pile** (`prop_debris_pile_lod0.glb`): Apocalyptic scatter prop
- **Victorian Lamppost** (`lamppost_victorian.glb`): Period street lighting
- **Vintage Lamppost** (`lamppost_vintage.glb`): Alternate lamppost style
- **Trashcan** (`trashcan.glb`): Street furniture
- **Camping Tent** (`tent_camping_01.glb`): Survivor shelter prop
- **1960s Tents** (`tent_1960.gltf`, `tent_1960_02.gltf`): Military/refugee tents

**Rationale**: Street props establish 1960s atmosphere. Debris and shelter props support post-apocalyptic survivor narrative. Multiple lamppost styles allow visual variety.

### 2026-01-12: Player Character LOD System
**Decision**: Added LOD variants for player survivor model
- **LOD0** (`char_player_survivor_alt_lod0.glb`): Full detail, close-up
- **LOD1** (`char_player_survivor_alt_lod1.glb`): Medium distance
- **LOD2** (`char_player_survivor_alt_lod2.glb`): Far distance
- **LOD3** (`char_player_survivor_alt_lod3.glb`): Extreme distance/silhouette

**Additional Player Models**:
- `player_character_man_lod0.glb`: Alternate male survivor
- `char_player_survivor_lod0.glb`: Original survivor model

**Rationale**: LOD system critical for performance with multiple characters on screen. Godot 4's automatic LOD switching will use appropriate detail level based on camera distance.

### 2026-01-12: 1960s Police Character Added
**Decision**: Added police enemy character variant
- **Model**: `character_police_1960s.glb`
- **Location**: `game/assets/characters/enemies/`
- **Shaded Preview**: `character_police_1960s_shaded.png`

**Rationale**: Expands enemy variety. Police represent corrupted authority antagonists in post-apocalyptic setting. Period-accurate 1960s NYPD uniform reinforces era aesthetic.

### 2025-12-23: Weapon Model Added
**Decision**: Added M1911 pistol model for player weapon
- **Model**: `weapon_pistol_m1911_lod0.gltf`
- **Location**: `game/assets/models/weapons/`

**Weapon System Features** (already in C++):
- Semi-auto fire mode with realistic fire rate
- 8-round magazine capacity with reload mechanics
- Dynamic spread system (increases during sustained fire)
- Recoil system (camera kick with recovery)
- Reload animation phases (mag out/in events)
- Muzzle point for projectile spawn

**Rationale**: M1911 is period-accurate (designed 1911, still in use in 1960s). Starting weapon for player with balanced stats.

### 2025-12-23: Street Props Added
**Decision**: Added period-accurate street furniture
- **Fire Hydrant** (`prop_street_fire_hydrant_lod0.gltf`)
- **Lamppost** (`prop_street_lamppost_lod0.gltf`)
- **Mailbox** (`prop_street_mailbox_lod0.gltf`)
- **Phone Booth** (`prop_street_phone_booth_lod0.gltf`)
- **Trash Can** (`prop_street_trashcan_lod0.gltf`)

**Rationale**: Street props establish 1960s NYC atmosphere. Phone booths and mailboxes are iconic period elements. All provide light cover or interaction points.

### 2026-01-06: macOS Build Support
**Decision**: Extended build system to support macOS (Darwin) development
- CMakeLists.txt detects Apple platform and sets `PLATFORM_NAME=macos`
- Automatic architecture detection (arm64 vs x86_64)
- Build output: `game/bin/liburban_survivor.macos.{debug|release}.{arch}.dylib`

**Build Commands (macOS)**:
```bash
# Configure with Makefile generator
cmake -B build

# Build debug
cmake --build build --config Debug

# Build release
cmake --build build --config Release
```

**Rationale**: Development moved to macOS (Apple Silicon). CMake configuration updated to detect Darwin platform and build appropriate dynamic library format.

### 2026-01-06: Level 1 Scene Populated
**Decision**: Level 1 ("The Heights") scene populated with models and zone logic
- **3 Zones**: Traffic Jam → Checkpoint → Commercial Strip
- **Zone System**: GDScript triggers events based on player Z position
- **Atmosphere**: Late afternoon sunset lighting, fog, dramatic shadows

**Level Script Features** (`level_1.gd`):
- Zone boundary detection with signals
- Player spawning from PackedScene
- Checkpoint encounter activation (Zone 2)
- Neon sign ambiance (Zone 3)
- Debug markers for development

**Rationale**: Core gameplay loop requires a playable level. Zone system allows progressive difficulty and story beats without loading screens.

---

### 2026-01-06: Enemy Zone Placement System
**Decision**: Created enemy variant prefabs and zone-based activation system
- **Enemy Types**:
  - `scavenger.tscn`: 60 HP, melee, flees at 30% HP, 40% accuracy
  - `raider.tscn`: 100 HP, ranged (15m), flees at 15% HP, 70% accuracy
- **Zone 2 (Checkpoint)**: 5 enemies (3 Scavengers, 2 Raiders)
  - MG nest position, flanking Raiders, patrolling Scavengers
- **Zone 3 (Commercial Strip)**: 3 enemies (2 Scavengers, 1 Raider sniper)
  - Looters at storefronts, sniper on elevated position

**AI Activation System**:
- Added `ai_active` flag to EnemyAI class
- `set_ai_active(bool)` / `is_ai_active()` methods exposed to GDScript
- Enemies start deactivated, become active when player enters zone
- Reduces CPU usage and prevents premature detection

**Level Script Integration** (`level_1.gd`):
- `_setup_enemies()` groups enemies by zone and deactivates them
- `_trigger_checkpoint_encounter()` activates Zone 2 enemies
- `_trigger_strip_ambush()` activates Zone 3 enemies

**Rationale**: Zone-based activation provides dramatic encounter pacing. Enemies don't patrol/detect until player approaches their zone. Reduces AI overhead for inactive enemies.

---

### 2026-01-06: Scavenge Points & Level Exit System
**Decision**: Implemented scavenge point population and level exit trigger
- **Scavenge Point Prefab**: `game/scenes/world/scavenge_point.tscn`
  - Uses C++ ScavengePoint (Area3D) class
  - Visual indicator (green glow box)
  - Configurable min/max items per point
  - Loot generated on _ready()

**Scavenge Point Placement** (10 total):
| Zone | Count | Purpose | Locations |
|------|-------|---------|-----------|
| Zone 1 | 5 | Tutorial loot | Start area, car trunks, phone booth, taxi |
| Zone 2 | 3 | Ammo caches | Barrier, tank, MG nest supplies |
| Zone 3 | 2 | Medical | Rexall Drugs, Diner counter |

**Level Exit System**:
- **Prefab**: `game/scenes/world/level_exit.tscn` (Area3D)
- **Position**: Z = -275 (subway entrance)
- **Detection**: Signal-based (`body_entered`) with distance fallback
- **Signal Flow**: `LevelExitTrigger.body_entered` → `_on_exit_trigger_body_entered()` → `_complete_level()`

**GDScript Integration** (`level_1.gd`):
- `_setup_exit_trigger()` connects Area3D signal
- `_on_exit_trigger_body_entered()` checks for player and triggers completion
- `level_completed` signal emitted for GameManager integration

**Rationale**: ScavengePoint prefab enables consistent loot placement with visual feedback. Area3D exit trigger is more reliable than distance polling and follows Godot's signal-based patterns.

---

### 2026-01-06: Remington 870 Shotgun Model Added
**Decision**: Added Remington 870 pump-action shotgun model
- **Model**: `wpn_remington870_lod0.gltf`
- **Location**: `game/assets/models/weapons/`
- **Stats**: 1,422 vertices, 1,750 faces (well within 2,500 tri budget)

**Model Features**:
- Subdivision surface (viewport 2, render 3)
- Edge beveling (0.005 width, 3 segments)
- Smooth shading with PBR materials
- Wood stock + metal barrel materials
- Godot 4.3 ready (Y-up, -Z forward, 1 unit = 1 meter)

**Weapon Properties** (for Godot scene):
- Weapon Type: SHOTGUN
- Fire Mode: PUMP_ACTION (single shot with delay)
- Magazine Capacity: 5+1 shells
- Ammo Type: 12 gauge
- Spread Pattern: Multi-pellet shotgun spread

**Rationale**: Second weapon type for player variety. Period-accurate police/military shotgun. Pump-action introduces tactical reload timing.

---

### 2026-01-08: Animation Artist Agent & MCP Animation System Integration
**Decision**: Created Animation Artist agent for character animation using Blender MCP Animation System
- **New Agent**: `animation-artist.agent.md` — Specialist in Blender MCP Animation System
- **New Prompts**:
  - `import-mixamo-animations.prompt.md` — Import and retarget Mixamo FBX animations
  - `create-character-animations.prompt.md` — Batch-apply MCP animation presets

**Animation MCP System Capabilities** (25 presets):
| Category | Presets |
|----------|---------|
| Locomotion | idle, walk, run, sprint, crouch_idle, crouch_walk, jump_start, jump_loop, jump_land, limp |
| Combat | aim_weapon, aim_idle, recoil, reload, cover_enter, cover_idle, cover_peek, melee_attack |
| Status | death, hit_react |
| Utility | t_pose, a_pose, jump, crouch, roll |

**Key MCP Tools**:
- `apply_animation_preset()` — Apply preset with bone mapping
- `export_animation_gltf()` — Export GLB for Godot
- `get_armature_bones()` — Validate bone mapping
- `insert_keyframe()` — Custom animation creation
- NLA layering for combined animations (aim + walk)

**Folder Structure Created**:
```
game/assets/animations/
├── player/   — Player character animations
├── enemies/  — Enemy type animations
└── shared/   — Animations shared across characters
```

**Rationale**: Animation was the missing piece in the 3D pipeline. MCP Animation System provides 25 presets covering all gameplay needs. GLB export ensures Godot compatibility with retargeting support.

---

### 2026-01-08: SkeletonProfileHumanoid Bone Naming Standard
**Decision**: Updated project skeleton to use Godot 4's SkeletonProfileHumanoid naming
- **Changed in**: `docs/ART_GUIDELINES.md` Section 4.1

**Bone Name Changes**:
| Old Name (Mixamo-style) | New Name (Godot Standard) |
|-------------------------|---------------------------|
| `LeftUpLeg` | `LeftUpperLeg` |
| `LeftLeg` | `LeftLowerLeg` |
| `LeftArm` | `LeftUpperArm` |
| `LeftForeArm` | `LeftLowerArm` |
| `LeftToeBase` | `LeftToes` |
| `Spine1` | `Chest` |
| `Spine2` | `UpperChest` |

**Benefits**:
1. Seamless animation retargeting in Godot 4
2. Auto-mapping works out of the box with BoneMap
3. Animations can be shared between player and enemy characters
4. Mixamo animations import with automatic renaming

**Rationale**: SkeletonProfileHumanoid is Godot 4's standard for humanoid rigs. Aligning our skeleton naming enables the "Overwrite Axis" and "Rename Bones" import options to work correctly, eliminating bone rotation issues.

---

### 2026-01-08: Hybrid Animation Workflow (MCP + Mixamo)
**Decision**: Adopted hybrid approach for character animations
- **Mixamo**: Base locomotion (walk, run, idle) — saves weeks of animation work
- **MCP Presets**: Combat and game-specific animations (reload, cover, aim)
- **Export Format**: GLB (not FBX) via `export_animation_gltf()`

**Workflow**:
1. Download Mixamo animations as FBX (without skin)
2. Import to Blender and transfer actions to project armature
3. Apply MCP presets for combat animations
4. Export combined GLB to `game/assets/animations/`
5. Import to Godot with retargeting settings

**Critical Godot Import Settings**:
```
Skeleton3D → Retarget:
  BoneMap: SkeletonProfileHumanoid
  Bone Renamer → Rename Bones: ON
  Rest Fixer → Overwrite Axis: ON  ← CRITICAL
  Normalize Position Tracks: ON
```

**Frame Markers for Gameplay Sync**:
| Animation | Marker | Frame | Usage |
|-----------|--------|-------|-------|
| reload | mag_out | 18 | Disable firing |
| reload | mag_in | 42 | Restore ammo |
| cover_peek | can_fire | 15 | AI can shoot |
| cover_peek | return_start | 22 | Return to cover |

**Rationale**: Mixamo provides high-quality base locomotion for free. MCP presets handle game-specific needs. GLB is Godot's preferred format (better than FBX for modern engines). Hybrid approach balances quality with development speed.

---

## Milestone 1 Task Completion Status

### Epic 1.1: Combat System Completion ✅ COMPLETE
| Task | Status | Notes |
|------|--------|-------|
| 1.1.1 Weapon raycast firing | ✅ | Weapon.fire() with raycast, debug lines |
| 1.1.2 Hit detection and damage | ✅ | DamageSystem.apply_damage(), hit zones (HEAD 2.5x, TORSO 1.0x, LIMBS 0.7x) |
| 1.1.3 Weapon reload system | ✅ | R key, animation states, mag_out/mag_in signals |
| 1.1.4 Recoil and spread | ✅ | Camera kick, spread increase/recovery |
| 1.1.5 M1911 Pistol data | ✅ | 8-round mag (spec says 7, using 8), 25 damage, pistol stats |

### Epic 1.2: Player Assembly ✅ COMPLETE
| Task | Status | Notes |
|------|--------|-------|
| 1.2.1 Create player.tscn prefab | ✅ | PlayerController + Inventory + SurvivalStats + Weapon + Camera |
| 1.2.2 Player death flow | ✅ | Health check, death state, input disabled, player_died signal |
| 1.2.3 Add melee attack | ✅ | V key, sphere cast, 30 damage, cooldown in PlayerController |
| 1.2.4 Implement interaction system | ✅ | E key, 2m raycast, interact() calls |

### Epic 1.3: AI Combat Behavior ✅ COMPLETE
| Task | Status | Notes |
|------|--------|-------|
| 1.3.1 AI attack state | ✅ | state_attack(), perform_attack(), weapon firing, cooldown |
| 1.3.2 Cover-seeking behavior | ✅ | state_take_cover(), find_cover_position(), peek-shoot cycles |
| 1.3.3 Enemy death | ✅ | DEAD state, drop_loot(), corpse cleanup timer |
| 1.3.4 Scavenger enemy variant | ✅ | scavenger.tscn: 60 HP, melee, flees at 30% |
| 1.3.5 Raider enemy variant | ✅ | raider.tscn: 100 HP, ranged, 70% accuracy |

### Epic 1.4: Basic HUD ✅ COMPLETE
| Task | Status | Notes |
|------|--------|-------|
| 1.4.1 Health bar | ✅ | HUD C++ class, damage flash, hud_controller.gd signal wiring |
| 1.4.2 Stamina bar | ✅ | Low stamina pulsing warning at 20% |
| 1.4.3 Ammo counter | ✅ | Mag/reserve display, empty flash |
| 1.4.4 Create crosshair | ✅ | Center reticle, spread support, color change |
| 1.4.5 Interaction prompt | ✅ | interaction_prompt.gd: "Press E to...", distance fade |

### Epic 1.5: Level 1 Population ✅ COMPLETE
| Task | Status | Notes |
|------|--------|-------|
| 1.5.1 Place 5 enemies in Zone 2 | ✅ | 3 Scavengers, 2 Raiders, zone-based activation |
| 1.5.2 Place 3 enemies in Zone 3 | ✅ | 2 Scavengers, 1 Raider sniper |
| 1.5.3 Add 10 scavenge points | ✅ | 5 Zone 1, 3 Zone 2, 2 Zone 3 |
| 1.5.4 Level exit trigger | ✅ | Area3D at Z=-275, signal-based detection |
| 1.5.5 Player spawn + link | ✅ | player.tscn at (0, 1, -5), camera init |

**Milestone 1 Status: 100% COMPLETE** 🎉

---

## Milestone 2: Art Pipeline Sprint Plan

**Timeline**: Weeks 4-10 (6 weeks)  
**Goal**: Replace all placeholders with production assets  
**Created**: 2026-01-06

### Current Asset Inventory (Already Complete)
| Category | Existing Assets | Status |
|----------|-----------------|--------|
| **Characters** | savage.glb (player), char_player_survivor_lod0-3.glb (4 LODs), player_character_man_lod0.glb | ✅ Player done with LODs |
| **Enemies** | police_officer.glb, scavenger.gltf, character_police_1960s.glb | ✅ 3 enemy types |
| **Vehicles** | taxi (5 variants), police_car (2 variants), chevy_wrecked, chrysler_1960, cadillac_convertible, limo_1960, bus_1960_gmc, bus_1960, truck_1960, pickup_vintage, sedan_vintage_01, sedan_deville, tank_m48 | ✅ 17 vehicles |
| **Props** | phone_booth, fire_hydrant, lamppost (3 variants), mailbox, trash_can (2), debris_pile, tents (3 variants) | ✅ 12+ street props |
| **Buildings** | building_cbs_skyscraper_lod0, building_military_base_lod0 | ✅ 2 buildings |
| **Weapons** | m1911_pistol_lod0.gltf, wpn_remington870_lod0.gltf | ✅ 2 weapons |
| **Environment** | env_1960s_overcast.tres | ✅ WorldEnvironment |

### Gap Analysis (Still Needed)
| Category | Missing Assets | Priority |
|----------|----------------|----------|
| **Vehicles** | ~~GMC City Bus~~, ~~M48 Patton Tank~~, vehicle material library | LOW (only material library) |
| **Architecture** | Apartment building, Loew's Theatre, Woolworth's, Rexall Drugs, Chrome Diner, building trim sheet | HIGH |
| **Props** | Newsstand, ~~debris scatter~~, military fortifications (sandbags, barbed wire, jersey barriers) | MEDIUM |
| **Characters** | Raider enemy model, player animations, enemy animations | HIGH |
| **Weapons** | ~~Remington 870 Shotgun~~, M14 Rifle, Thompson SMG, weapon VFX | MEDIUM |

---

### Sprint 2.1: Hero Vehicles & Architecture (Weeks 4-5)
**Focus**: High-impact assets for Level 1 visual upgrade

| ID | Task | Agent | Est | Acceptance Criteria |
|----|------|-------|-----|---------------------|
| 2.1.3 | Model GMC City Bus | `blender-artist` | 8h | ✅ COMPLETE: `bus_1960_gmc.gltf` |
| 2.1.4 | Model M48 Patton Tank | `blender-artist` | 8h | ✅ COMPLETE: `vehicle_tank_m48_lod0.glb` |
| 2.1.5 | Create vehicle material library | `texture-artist` | 4h | Rusted metal, broken glass, faded paint presets |
| 2.2.1 | Model modular apartment building | `blender-artist` | 8h | 6-story, < 8,000 tris, modular facades |
| 2.2.6 | Create building trim sheet | `texture-artist` | 4h | 2048x2048, brick/concrete/window frames |
| 2.1.6 | Import and test all vehicles in Godot | `godot-cpp-expert` | 4h | ✅ COMPLETE: 17 vehicles imported |

**Sprint 2.1 Total**: ~36 hours → ~16h remaining (buildings + materials)

**Deliverables**:
- ✅ GMC City Bus (hero prop for Zone 1 Traffic Jam)
- ✅ M48 Patton Tank (hero prop for Zone 2 Checkpoint)
- ⬜ Vehicle material library (reusable across all vehicles)
- ⬜ Modular apartment building sections
- ⬜ Building trim texture atlas
- ✅ CBS Skyscraper (bonus - skyline backdrop)
- ✅ Military Base building (bonus - checkpoint scene)

---

### Sprint 2.2: Storefronts & Props (Weeks 5-6)
**Focus**: Commercial Strip (Zone 3) visual identity

| ID | Task | Agent | Est | Acceptance Criteria |
|----|------|-------|-----|---------------------|
| 2.2.2 | Model Loew's Theatre facade | `blender-artist` | 6h | < 10,000 tris, 1930s ornate, barricaded |
| 2.2.3 | Model Woolworth's storefront | `blender-artist` | 4h | < 4,000 tris, looted interior, broken signage |
| 2.2.4 | Model Rexall Drugs storefront | `blender-artist` | 4h | < 4,000 tris, neon sign (emissive) |
| 2.2.5 | Model Chrome Diner | `blender-artist` | 6h | < 5,000 tris, 1950s aesthetic, counter visible |
| 2.3.3 | Model newsstand | `blender-artist` | 3h | < 1,500 tris, magazine decals |
| 2.3.5 | Model military fortifications | `blender-artist` | 4h | Sandbags, barbed wire, jersey barriers |
| 2.3.4 | Generate debris assets | `blender-artist` | 3h | ✅ PARTIAL: `prop_debris_pile_lod0.glb` complete, need suitcases/papers |

**Sprint 2.2 Total**: ~30 hours → ~27h remaining

**Deliverables**:
- ⬜ 4 storefront facades for Zone 3
- ⬜ Newsstand prop
- ⬜ Military checkpoint props (sandbags, barriers)
- ✅ Debris pile asset complete
- ✅ Tent/shelter assets complete (3 variants)

---

### Sprint 2.3: Characters & Animations (Weeks 7-8)
**Focus**: Character visual polish and animation

| ID | Task | Agent | Est | Acceptance Criteria |
|----|------|-------|-----|---------------------|
| 2.4.4 | Model Raider enemy | `character-artist` | 6h | < 5,000 tris, military surplus, armored variant |
| 2.4.2 | Create player animations | `character-artist` | 12h | Idle, walk, run, crouch, jump, aim, fire, reload, death |
| 2.4.5 | Create enemy animations | `character-artist` | 8h | Idle, patrol, run, fire, death (3 variants) |
| - | Rig existing Savage model | `character-artist` | 4h | Godot-compatible skeleton if not rigged |
| - | Rig enemy models | `character-artist` | 4h | Shared enemy skeleton |

**Sprint 2.3 Total**: ~34 hours (1.5 weeks)

**Deliverables**:
- Raider enemy model with military gear
- Full player animation set (13+ animations)
- Enemy animation set (8+ animations)
- Rigged character models for Godot

---

### Sprint 2.4: Weapons & VFX (Weeks 9-10)
**Focus**: Weapon variety and combat polish

| ID | Task | Agent | Est | Acceptance Criteria |
|----|------|-------|-----|---------------------|
| 2.5.2 | ~~Model Remington 870 Shotgun~~ | `blender-artist` | ~~4h~~ | ✅ COMPLETE: 1,750 faces, wood stock + metal barrel |
| 2.5.3 | Model M14 Rifle | `blender-artist` | 4h | < 3,000 tris, semi-auto |
| 2.5.4 | Model Thompson SMG | `blender-artist` | 4h | < 3,000 tris, drum magazine |
| 2.5.5 | Create weapon VFX | `environment-artist` | 6h | Muzzle flash, shell casings, impact sparks |
| - | Weapon reload animations | `character-artist` | 6h | Per-weapon reload (pistol, shotgun, rifle, SMG) |
| - | Integrate weapons in Godot | `godot-cpp-expert` | 4h | Weapon data, scene prefabs, fire/reload working |

**Sprint 2.4 Total**: ~28 hours (1 week)

**Deliverables**:
- 3 new weapon models (Shotgun, Rifle, SMG)
- GPU particle VFX for combat
- Weapon animations integrated
- Weapon prefab scenes ready to use

---

### Milestone 2 Summary

| Sprint | Focus | Duration | Key Deliverables | Progress |
|--------|-------|----------|------------------|----------|
| 2.1 | Hero Vehicles & Architecture | 1.5 weeks | Bus ✅, Tank ✅, Apartments ⬜, Materials ⬜ | 70% |
| 2.2 | Storefronts & Props | 1 week | 4 storefronts ⬜, Checkpoint props ⬜, Debris ✅ | 20% |
| 2.3 | Characters & Animations | 1.5 weeks | Raider model ⬜, All animations ⬜ | 0% |
| 2.4 | Weapons & VFX | 1 week | 3 weapons ⬜, Combat VFX ⬜ | 0% |

**Total Milestone 2**: ~128 hours → ~90h remaining

**Bonus Completed (Not in Original Plan)**:
- CBS Skyscraper (skyline backdrop)
- Military Base building
- Player character LOD system (4 levels)
- Additional police enemy variant
- 13 additional vehicle variants beyond original plan
- Multiple lamppost variants
- Tent/shelter props for survivor camps

### Agent Assignment Summary

| Agent | Tasks | Total Hours |
|-------|-------|-------------|
| `blender-artist` | 3D modeling (vehicles, buildings, props, weapons) | ~60h |
| `texture-artist` | Materials, trim sheets | ~8h |
| `character-artist` | Character models, rigging, animations | ~40h |
| `environment-artist` | VFX, lighting | ~6h |
| `godot-cpp-expert` | Integration, prefabs, weapon data | ~14h |

### Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Animation bottleneck | HIGH | Use Mixamo for base animations, customize in Blender |
| High-poly models | MEDIUM | Enforce tri counts during modeling, auto-LOD in Godot |
| Texture consistency | MEDIUM | Use trim sheets and material library for cohesion |
| Integration delays | LOW | Test imports after each sprint, not at end |

---

### Phase 2 Completion & Phase 3 Handoff

**Phase 2 Complete (2026-01-19)**: Asset optimization and staging  
**Status**: ✅ LOD creation, material export, Godot staging finished

**Phase 2 Deliverables**:
1. **LOD Variants Created**:
   - `suspension_bridge_lod0/1/2.glb` → 951K/476K/238K tris (3 LODs)
   - `abandoned_factory_lod0/1/2.glb` → 631K/315K/158K tris (3 LODs)
   - `city_buildings_lod0/1/2.glb` → 1.145M/~570K/~285K tris (3 LODs)
   - Road City already integrated with LOD0-3 (671K/336K/168K/67K polys)

2. **Material Library Exported**:
   - Total: 2,718 materials exported to `game/assets/materials/library/`
   - Paint: 2,439 materials | Concrete: 257 | Metal: 12 | Stone/Wood/Brick/Glass/Roads: 2 each
   - Library index: `library_index.json`

3. **Godot Staging Complete**:
   - 17 assets copied to `game/assets/models/` (562.8 MB total)
   - Categories: buildings (8), infrastructure (5), vehicles (1), props (3)
   - Phone booth skipped (source missing; existing game import at `prop_street_phone_booth_lod0.gltf`)

**Phase 3 Task: Level Integration & Placement**

| ID | Task | Agent | Priority | Est | Description |
|----|------|-------|----------|-----|-------------|
| 3.1 | Generate asset placement map | `environment-artist` | HIGH | 2h | Map 17 staged assets to Level 1 zones with filenames, transforms, and placement rationale |
| 3.2 | Wire ext_resources in level_1.tscn | `godot-cpp-expert` | HIGH | 3h | Add ext_resource entries for all staged GLBs, create node instances with transforms |
| 3.3 | Implement multi-LOD switching | `godot-cpp-expert` | MEDIUM | 2h | Adapt RoadCityLOD script for suspension_bridge, factory, city_buildings |
| 3.4 | Test Godot imports & collision | `godot-cpp-expert` | HIGH | 2h | Verify .import generation, check materials, add simple collision (Box/Convex) |
| 3.5 | Performance profiling | `godot-cpp-expert` | MEDIUM | 1h | Profile FPS at TS Center (z -75) and Blockade (z -115); tune LOD thresholds |

**Phase 3.1 Deliverable** (Immediate Next Step):  
Generate placement map for 17 staged assets with:
- **Filenames**: Exact GLB paths from `game/assets/models/` staging
- **Zone Assignments**: Map to Level 1 zones (Entrance -5 to -30, Sanctuary -30 to -60, TS Center -60 to -90, Killzone -90 to -120, Blockade/Exit -120 to -150)
- **Placement Rationale**: Why each asset goes in its zone (cover, sightlines, visual landmarks, gameplay flow)
- **Transform Guidance**: Position/rotation/scale suggestions aligned to existing RoadCity (z -75) and exit (z -150)

**Staged Assets Awaiting Placement** (from Phase 2B):

| File | Category | Size | Tris | Notes |
|------|----------|------|------|-------|
| `suspension_bridge_lod0.glb` | Infrastructure | 84.3 MB | 951K | Hero vista piece; consider backdrop or far-ground |
| `abandoned_factory_lod0.glb` | Buildings | 55.8 MB | 631K | Large skyline filler; west/east elevated position |
| `city_buildings_lod0.glb` | Buildings | 101.5 MB | 1.145M | Mid-ground corridor filler; z -40 to -120 spacing |
| `downtown_modernoffice_3.glb` | Buildings | 27.1 MB | - | Office building for commercial/office zones |
| `downtown_modernoffice_4.glb` | Buildings | 28.3 MB | - | Office building variant |
| `downtown_residential_2.glb` | Buildings | 25.7 MB | - | Residential building for neighborhood feel |
| `downtown_residential_3.glb` | Buildings | 26.4 MB | - | Residential variant |
| `downtown_publicbuilding_1.glb` | Buildings | 31.2 MB | - | Public building (library/post office aesthetic) |
| `u2NBuild3.gltf` | Buildings | 18.9 MB | - | City building variant |
| `u2SEBuild2.gltf` | Buildings | 19.4 MB | - | City building variant |
| `u2WBuild1.gltf` | Buildings | 17.8 MB | - | City building variant |
| `road_city_LOD0-3.gltf` | Infrastructure | - | 671K/336K/168K/67K | ✅ Already integrated at z -75 with LOD script |
| `building_cbs_skyscraper_lod0.glb` | Buildings | 6.5 MB | - | ✅ Already placed (skyline backdrop) |
| `building_military_base_lod0.glb` | Buildings | 4.0 MB | - | Checkpoint/fortification structure |
| `sedan_vintage_01.glb` | Vehicles | 2.8 MB | 19.5K | Additional sedan variant for traffic jam |
| `prop_debris_pile_lod0.glb` | Props | 1.2 MB | - | ✅ Already placed (3 instances) |
| `tent_1960.gltf` | Props | 0.8 MB | - | ✅ Already placed (sanctuary camp) |
| `prop_street_trashcan_lod0.gltf` | Props | 0.3 MB | - | ✅ Already placed (4 instances) |

**Placement Constraints**:
- RoadCity center: z = -75 (Times Square Plaza)
- Level exit: z = -150
- Existing zones: Entrance (-5 to -30), Sanctuary (-30 to -60), TS Center (-60 to -90), Killzone (-90 to -120), Blockade (-120 to -150)
- Player camera: Third-person, 20-100m LOD switching optimal
- Collision: Keep simple (Box/Convex) unless gameplay requires concave mesh

**Next Action**: `environment-artist` agent generates placement map document with asset-to-zone mappings and transform recommendations.

---

## Known Issues & Workarounds

### Godot 4.3 API Changes
The following changes were required for Godot 4.3 compatibility:

| Old API | New API (4.3) |
|---------|---------------|
| `Vector3::ZERO` | `Vector3(0, 0, 0)` |
| `Vector3::UP` | `Vector3(0, 1, 0)` |
| `Math::lerp()` | `Math::lerp()` (same, but include path changed) |
| `Input::is_action_just_pressed()` | Returns bool, not Ref |

### Platform-Specific Notes
**macOS (Current Development)**:
- Build system auto-detects arm64/x86_64 architecture
- Output: `.dylib` instead of `.dll`
- No Vulkan fallback issues on Apple Silicon

**Windows**:
- D3D12 fallback may be used if Vulkan unavailable
- Godot automatically handles this, no action needed
- Test on Vulkan before release

### GDExtension Hot Reload
**Issue**: C++ changes require editor restart
**Workaround**: 
1. Close Godot
2. Rebuild (`cmake --build build`)
3. Reopen Godot

### Model Import Positioning
**Issue**: Imported GLB/GLTF models may have incorrect origin or scale
**Workaround**:
1. Check model origin in Blender before export (feet at 0,0,0)
2. Apply transforms in Blender (Ctrl+A → All Transforms)
3. Use import settings in Godot to adjust scale if needed

### Camera Clipping Through Walls
**Issue**: Third-person camera can clip through geometry
**Solution**: ThirdPersonCamera includes spring arm collision detection. Ensure level geometry has proper collision layers.

---

## File Naming Conventions

### C++ Files
```
src/module_name/class_name.hpp     # Header
src/module_name/class_name.cpp     # Implementation
```

### Godot Files
```
game/scenes/scene_name.tscn        # Scenes
game/scenes/scene_name.gd          # Attached scripts
game/scripts/utility_name.gd       # Standalone scripts
game/assets/category/asset.ext     # Assets
```

### Documentation
```
docs/UPPERCASE.md                  # Major documents
docs/subfolder/lowercase.md        # Reference docs
```

---

## Build Commands Reference

### Quick Reference (macOS - Current)
```bash
# Configure (first time)
cmake -B build

# Build Debug
cmake --build build --config Debug

# Build Release
cmake --build build --config Release

# Clean
cmake --build build --target clean
```

### Quick Reference (Windows)
```powershell
# Configure (first time)
cmake -B build -G "Visual Studio 17 2022"

# Build Debug
cmake --build build --config Debug

# Build Release
cmake --build build --config Release

# Clean
cmake --build build --target clean
```

### Build Output Location
**macOS**:
- Debug: `game/bin/liburban_survivor.macos.debug.arm64.dylib` (Apple Silicon)
- Debug: `game/bin/liburban_survivor.macos.debug.x86_64.dylib` (Intel)
- Release: `game/bin/liburban_survivor.macos.release.{arch}.dylib`

**Windows**:
- Debug: `game/bin/liburban_survivor.windows.debug.x86_64.dll`
- Release: `game/bin/liburban_survivor.windows.release.x86_64.dll`

---

## Code Patterns

### Registering a New GDExtension Class

1. Create header and implementation files
2. Add to `register_types.cpp`:

```cpp
#include "module/my_class.hpp"

void initialize_urban_survivor(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
    
    // Add this line:
    GDREGISTER_CLASS(MyClass);
}
```

3. Rebuild the extension

### Exposing Properties to Editor

```cpp
// In header
private:
    float my_property = 1.0f;

// In _bind_methods()
ClassDB::bind_method(D_METHOD("get_my_property"), &MyClass::get_my_property);
ClassDB::bind_method(D_METHOD("set_my_property", "value"), &MyClass::set_my_property);
ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "my_property"), "set_my_property", "get_my_property");
```

### Emitting Signals

```cpp
// In _bind_methods()
ADD_SIGNAL(MethodInfo("my_signal", PropertyInfo(Variant::INT, "value")));

// To emit
emit_signal("my_signal", 42);
```

---

## Testing Checklist

### Before Committing C++ Changes
- [ ] Code compiles without errors
- [ ] Code compiles without warnings (treat warnings as errors)
- [ ] Godot editor opens without crashes
- [ ] Test scene runs
- [ ] Affected features still work

### Before Merging to Main
- [ ] All unit tests pass
- [ ] Manual playtest of affected features
- [ ] No regression in unrelated features
- [ ] Documentation updated if needed
- [ ] Code reviewed by another team member

---

## Performance Guidelines

### Target Frame Budget (60 FPS = 16.67ms)
| System | Budget |
|--------|--------|
| Physics | 4ms |
| AI | 3ms |
| Rendering | 8ms |
| Everything else | 1.67ms |

### Optimization Priorities
1. **Measure first**: Use Godot profiler before optimizing
2. **AI updates**: Stagger AI updates across frames
3. **Physics queries**: Cache results, don't query every frame
4. **Draw calls**: Batch similar materials

---

## Asset Pipeline Notes

### Current Asset Inventory
| Category | Assets |
|----------|--------|
| Characters | savage.glb (player), char_player_survivor_lod0-3.glb (4 LODs), player_character_man_lod0.glb |
| Enemies | police_officer.glb, scavenger.gltf, character_police_1960s.glb |
| Vehicles | taxi (5 variants), police_car (2), chevy_wrecked, chrysler_1960, cadillac_convertible, limo_1960, bus_1960_gmc, bus_1960, truck_1960, pickup_vintage, sedan_vintage_01, sedan_deville, tank_m48 (17 total) |
| Props | phone_booth, fire_hydrant, lamppost (3 variants), mailbox, trash_can (2), debris_pile, tents (3 variants) |
| Buildings | cbs_skyscraper, military_base |
| Weapons | m1911_pistol, remington_870_shotgun |
| Environments | env_1960s_overcast.tres |

### Model Import Settings
- Scale: 1 unit = 1 meter
- Up axis: Y
- Forward: -Z
- Format: GLTF 2.0 / GLB preferred, OBJ supported

### Import Scripts (macOS)
```bash
# Generic OBJ import
./import_obj_model.sh <file.obj> <category> <asset_name>

# Specific imports (pre-configured)
./import_survivor.sh
./import_police_officer.sh
./import_taxi.sh
./import_police_car.sh
./import_chevy_wrecked.sh

# Verify player integration
./verify_integration.sh
```

### Naming Convention
```
{category}_{type}_{name}_lod{N}.{ext}

Examples:
- char_player_savage_lod0.glb
- vehicle_taxi_lod0.glb
- prop_street_phone_booth_lod0.gltf
- weapon_pistol_m1911_lod0.gltf
```

### Texture Guidelines
- Power of 2 dimensions (256, 512, 1024, 2048)
- PNG for UI, JPG for photos
- Normal maps: OpenGL format (Y+ = up)
- GLB models can include embedded textures

### Audio Guidelines
- Effects: WAV (uncompressed) or OGG
- Music: OGG Vorbis
- Sample rate: 44100 Hz
- Mono for 3D sounds, Stereo for music/UI

---

## Common Mistakes to Avoid

### C++ Pitfalls
1. **Forgetting `_bind_methods()`**: Class won't be usable in editor
2. **Using raw pointers without null checks**: Crash city
3. **Not calling parent `_ready()`**: Missing initialization
4. **Hardcoding paths**: Use `res://` or export variables

### Godot Pitfalls
1. **Modifying nodes during tree iteration**: Use `call_deferred()`
2. **Ignoring `@tool` implications**: Editor crashes
3. **Circular dependencies**: Leads to load order issues
4. **Not freeing nodes**: Memory leaks

### GDExtension Pitfalls
1. **Binary compatibility**: Rebuild when Godot updates
2. **Thread safety**: Godot is not thread-safe by default
3. **Resource loading**: Use `ResourceLoader` in C++

---

## Useful Resources

### Documentation
- [Godot 4 Docs](https://docs.godotengine.org/en/stable/)
- [GDExtension Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/)
- [godot-cpp Repo](https://github.com/godotengine/godot-cpp)

### Tutorials
- [GDExtension C++ Tutorial](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html)
- [Third Person Shooter Tutorial](https://docs.godotengine.org/en/stable/getting_started/first_3d_game/)

### Tools
- [Godot Asset Library](https://godotengine.org/asset-library/asset)
- [Blender (3D modeling)](https://www.blender.org/)
- [Audacity (Audio)](https://www.audacityteam.org/)

---

## AI Agent Reference

### Available Agents (`.github/agents/`)
| Agent | Purpose |
|-------|---------|
| `godot-cpp-expert` | C++ GDExtension patterns, bindings, lifecycle |
| `combat-systems` | Weapon firing/reload, hit detection, DamageSystem |
| `enemy-ai` | FSM AI, perception, navigation, tactical behaviors |
| `gdscript-ui` | HUD/menus in GDScript wired via signals |
| `game-architecture` | Architecture review and cross-system integration |
| `sprint-planner` | Roadmap-aligned sprint planning and task breakdown |
| `debug-helper` | Build/runtime crash debugging for GDExtension |
| `code-reviewer` | Standards + architecture code review |
| `doc-maintainer` | Updates to MEMORY/ARCHITECTURE/SPEC when decisions change |
| `blender-artist` | Creates 3D models in Blender via MCP |
| `character-artist` | Player/enemy character models and materials |
| `environment-artist` | Lighting, atmosphere, WorldEnvironment |
| `texture-artist` | PBR materials, procedural textures, PolyHaven integration |
| `audio-ambience` | Period soundscapes, dynamic music, 3D audio |
| `model-spec-writer` | Technical specifications for 3D model requests |

### Recommended Workflow
1. **Plan**: Use `sprint-planner` agent with `plan-sprint.prompt.md`
2. **Implement**: Pick specialist agent for feature area
3. **Debug**: Use `debug-helper` when builds/crashes occur
4. **Review**: Use `code-reviewer` before merging
5. **Document**: Use `doc-maintainer` for decisions/known issues

### File-Type Instructions (`.github/instructions/`)
- `cpp-gdextension.instructions.md` → `**/*.{cpp,hpp}`
- `gdscript.instructions.md` → `**/*.gd`
- `scene-files.instructions.md` → `**/*.tscn`

