# Urban Survivor — Copilot Instructions

## Project Overview

Urban Survivor is a third-person survival shooter set in post-apocalyptic 1960s
New York City, built with **Godot 4.3+** and **C++17 GDExtension**. The player
navigates a frozen, nuclear-winter Manhattan — scavenging supplies, surviving
hostile encounters, and uncovering the secrets of "Project Nightfall."

## Technology Stack

| Component        | Technology                                    |
|------------------|-----------------------------------------------|
| Game Engine      | Godot 4.3+ with GDExtension                  |
| Core Systems     | C++17 (MSVC `/W4 /permissive- /std:c++17 /bigobj`) |
| UI & Scripting   | GDScript for rapid iteration                  |
| Build System     | CMake 3.20+ → MSBuild                        |
| C++ Bindings     | godot-cpp (submodule in `external/godot-cpp/`)|
| 3D Pipeline      | Blender + assimp for model import             |
| Platforms        | Windows, macOS, Linux                         |

## Repository Structure

```
cpp_game/
├── .github/              # Copilot instructions, prompts, workflows
│   ├── copilot-instructions.md
│   ├── instructions/     # Task-specific instruction files
│   └── prompts/          # Agentic SDLC prompt files
├── docs/                 # Project documentation
│   ├── ARCHITECTURE.md   # System architecture
│   ├── SPEC.md           # Game design specification
│   ├── PRODUCTION_PLAN.md# Sprint tasks and roadmap
│   └── CODING_STANDARDS.md
├── src/                  # C++ GDExtension source
│   ├── core/             # GameManager, global state
│   ├── player/           # PlayerController, movement, input
│   ├── camera/           # ThirdPersonCamera, orbit + collision
│   ├── ai/               # EnemyAI, AIPerception, FSM behaviors
│   ├── combat/           # Weapon, DamageSystem, hit zones
│   ├── inventory/        # Inventory, Item, ItemDatabase, loot
│   ├── survival/         # SurvivalStats: health, stamina, radiation
│   ├── world/            # LevelManager, ScavengePoint, zones
│   ├── ui/               # HUD components
│   └── register_types.cpp/hpp  # GDExtension class registration
├── game/                 # Godot project root
│   ├── scenes/           # .tscn scene files
│   ├── scripts/          # GDScript files
│   ├── assets/           # Models, textures, audio, animations, UI
│   ├── bin/              # Compiled extension DLLs
│   └── project.godot
├── external/             # Third-party dependencies
│   └── godot-cpp/        # Godot C++ bindings (submodule)
└── CMakeLists.txt        # Root build configuration
```

## Build Commands

```bash
# Configure (first time)
cmake -B visualstudio/vs2026-x64 -G "Visual Studio 18 2026" -A x64

# Debug build
cmake --build visualstudio/vs2026-x64 --config Debug

# Clean rebuild
cmake --build visualstudio/vs2026-x64 --config Debug --clean-first

# Output DLL
# game/bin/liburban_survivor.windows.template_debug.x86_64.dll
```

## C++ Coding Standards

### Naming Conventions

| Element          | Convention   | Example                       |
|------------------|--------------|-------------------------------|
| Files            | `snake_case` | `enemy_ai.cpp`, `damage_system.hpp` |
| Classes/Structs  | `PascalCase` | `PlayerController`, `SurvivalStats`  |
| Class Members    | `snake_case` | `walk_speed`, `max_health`           |
| Local Variables  | `camelCase`  | `deltaTime`, `currentWeapon`         |
| Constants/Enums  | `UPPER_CASE` | `MAX_INVENTORY_SLOTS`                |

### Mandatory Patterns

- Every Godot class uses `GDCLASS(ClassName, ParentClass)` macro
- All exposed methods, properties, and signals go in `_bind_methods()`
- Use `ADD_PROPERTY` with `PropertyInfo` and `PROPERTY_HINT_RANGE` for numerics
- Group related properties with `ADD_GROUP("Name", "prefix_")` … `ADD_GROUP("", "")`
- Declare signals with `ADD_SIGNAL(MethodInfo(...))` including typed `PropertyInfo` args
- New classes must be registered in `src/register_types.cpp` via `ClassDB::register_class<T>()`
- Lifecycle methods (`_ready`, `_process`, `_physics_process`) must guard with `Engine::get_singleton()->is_editor_hint()`
- Use `#ifndef`/`#define`/`#endif` include guards matching the existing header style
- All classes live in `namespace godot { }`
- No GCC/Clang extensions (`__attribute__`, `__int128`, `typeof`, statement expressions)
- Every change must leave the project in a compilable state

### Code Quality

- Null-check all node pointers before use
- Use `UtilityFunctions::print()` for debug logging (matching existing style)
- Prefer `std::clamp`, `Math::lerp` over manual min/max chains
- Keep header includes minimal; forward-declare where possible
- Match the comment style, spacing, and structure of the file being edited

## GDScript Standards

- Used for UI, HUD, and rapid-iteration scripting in `game/scripts/`
- Follow Godot's GDScript style guide (snake_case functions/variables, PascalCase classes)
- Connect signals in `_ready()` or via the editor
- Prefer typed variables (`var speed: float = 5.0`)

## System Architecture

```
GameManager (Singleton)
├── LevelManager         — Zone loading, spawn points, objectives
├── DamageSystem         — Centralized damage processing, hit zones
├── ItemDatabase         — Item definitions, loot tables
├── PlayerController     — Movement, input, player states, melee
│   ├── ThirdPersonCamera — Orbit camera with spring arm collision
│   ├── Inventory        — Item management, quick slots
│   ├── SurvivalStats    — Health, stamina, radiation
│   └── Weapon           — Equipped firearm with firing mechanics
├── AIManager
│   └── EnemyAI[]        — FSM-based enemy behaviors
│       ├── AIPerception — Sight/hearing detection
│       └── NavigationAgent3D — Pathfinding
└── HUD (CanvasLayer)    — Health bars, ammo counter, crosshair
```

## Agentic SDLC Workflow

This project uses a five-agent Copilot pipeline. Reference the prompt files
in `.github/prompts/` for the full agent definitions:

| Agent               | Role                                       |
|---------------------|--------------------------------------------|
| `sprint-planner`    | Orchestrates tasks from PRODUCTION_PLAN.md |
| `cpp-planner`       | Researches and plans C++ implementation    |
| `cpp-engineer`      | Executes plans step-by-step               |
| `cpp-reviewer`      | Validates code against acceptance criteria |
| `cpp-test-engineer`  | Writes and runs tests for approved work   |

## MCP Servers

When available, use these MCP servers for extended capabilities:

| Server     | Purpose                           |
|------------|-----------------------------------|
| Context7   | Godot and godot-cpp API docs      |
| Azure MCP  | Cloud deployment and resources    |
| GitHub MCP | Repository actions, issues, PRs   |

## Content Exclusions

Do not reference or include content from these paths in suggestions:

- `config/server-keys.json`
- `*.pem`, `*.key` files
- Any credentials, API keys, or secrets
- Anti-cheat or DRM implementation details

## Key Documentation

- `docs/ARCHITECTURE.md` — Full system architecture
- `docs/SPEC.md` — Game design specification
- `docs/PRODUCTION_PLAN.md` — Sprint roadmap and task tracking
- `docs/CODING_STANDARDS.md` — Detailed coding standards
