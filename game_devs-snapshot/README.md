# Urban Survivor

A third-person survival shooter set in a post-apocalyptic 1960s America. Navigate through devastated cities from north to south, scavenging supplies and surviving encounters with hostile survivors.

## Game Concept

### Setting
- **Era**: 1960s aesthetic, post-World War III
- **Location**: Starting in New York City, progressing southward through the US
- **Theme**: Survival, resource management, tactical combat

### Gameplay
- **Perspective**: Third-person shooter
- **Objective**: Traverse each city level from entry to exit
- **Mechanics**: 
  - Scavenge supplies (ammo, health kits, food)
  - Manage limited resources strategically
  - Combat enemy survivors who raid and steal
  - Light survival elements (health, stamina)

### Enemies
- Other survivors competing for resources
- Various AI behaviors (patrolling, scavenging, aggressive)
- Group tactics and territorial defense

## Project Structure

```
cpp_game/
├── CMakeLists.txt          # Build configuration
├── README.md               # This file
├── external/
│   └── godot-cpp/          # Godot C++ bindings (submodule)
├── src/
│   ├── core/               # Core game systems
│   ├── player/             # Player controller
│   ├── camera/             # Third-person camera
│   ├── ai/                 # Enemy AI systems
│   ├── inventory/          # Inventory management
│   ├── survival/           # Health, stamina systems
│   ├── combat/             # Weapons, damage
│   ├── world/              # Level management
│   └── ui/                 # HUD, menus
└── game/                   # Godot project files
    ├── project.godot
    ├── bin/                # Compiled GDExtension
    ├── scenes/
    ├── scripts/
    └── assets/
```

## Building

### Prerequisites
- CMake 3.20+
- C++17 compatible compiler
- Godot 4.2+ (for the editor)
- Git (for submodules)

### Setup
```bash
# Clone with submodules
git clone --recursive https://github.com/yourusername/urban_survivor.git
cd urban_survivor

# Or initialize submodules if already cloned
git submodule update --init --recursive
```

### Build Commands

#### Windows (Visual Studio)
```powershell
cmake -B build -G "Visual Studio 17 2022"
cmake --build build --config Release
```

#### Windows (Ninja)
```powershell
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

#### Linux/macOS
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

### Running
1. Build the GDExtension library
2. Open `game/project.godot` in Godot 4
3. Run the project (F5)

## Development Roadmap

### Phase 1: Core Systems ✓
- [x] Project structure
- [x] GDExtension setup
- [x] Third-person camera
- [x] Player controller
- [x] Basic movement

### Phase 2: Combat & Inventory
- [x] Inventory system
- [x] Weapon system
- [x] Combat mechanics
- [ ] Ammo management

### Phase 3: AI & Enemies
- [x] AI state machine
- [x] Pathfinding
- [x] Enemy behaviors
- [ ] Group tactics

### Phase 4: Survival & World
- [x] Health/stamina system
- [ ] Scavenging mechanics
- [ ] Level progression
- [ ] Save/load system

### Phase 5: Polish
- [ ] 1960s visual style
- [ ] Audio implementation
- [ ] UI/HUD
- [ ] Level design

## Controls

| Action | Key/Mouse |
|--------|-----------|
| Move | WASD |
| Look | Mouse |
| Sprint | Shift |
| Crouch | Ctrl |
| Jump | Space |
| Aim | Right Mouse |
| Shoot | Left Mouse |
| Reload | R |
| Interact | E |
| Inventory | Tab |

## Documentation

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | System architecture, class hierarchy, data flow |
| [SPEC.md](docs/SPEC.md) | Game design specification |
| [MEMORY.md](docs/MEMORY.md) | Development decisions, known issues, context |
| [CODING_STANDARDS.md](docs/CODING_STANDARDS.md) | C++ and GDScript coding standards |
| [ART_GUIDELINES.md](docs/ART_GUIDELINES.md) | Asset creation guidelines for artists |
| [WORKFLOW.md](docs/WORKFLOW.md) | Team workflow, version control, processes |
| [AGENT_WORKFLOW.md](docs/AGENT_WORKFLOW.md) | **AI agent invocation, chaining, and pipelines** |

---

## 🤖 AI Agent Workflow System

Urban Survivor features a comprehensive **AI-assisted development system** with 21 specialized agents and 39 task prompts. For complete documentation, see [AGENT_WORKFLOW.md](docs/AGENT_WORKFLOW.md).

### How to Invoke Agents

**Method 1: VS Code Chat Panel**
```
1. Open Copilot Chat: Ctrl+Shift+I (Windows/Linux) or Cmd+Shift+I (macOS)
2. Type @agent-name followed by your request
3. Example: @Combat Systems Developer implement weapon spread system
```

**Method 2: With Specific Prompts**
```
@Blender AI Artist blender-create-vehicle prompt for 1957 Chevrolet
```

### Agent Quick Reference

| Category | Agents | Use For |
|----------|--------|---------|
| **Code & Architecture** | Godot C++ Expert, Combat Systems, Enemy AI, GDScript UI, Game Architecture, Shader Specialist | C++ development, systems, gameplay |
| **Project Management** | Sprint Planner, Code Reviewer, Debugger, Doc Maintainer | Planning, reviews, debugging |
| **Art Pipeline** | Blender Artist, Model Spec Writer, Texture Artist, Character Artist, Environment Artist, Animation Artist, Level Populator, GLB Reviewer, BlenderKit Scout | 3D assets, materials, animations |
| **Audio** | Audio Ambience Designer | Soundscapes, music, spatial audio |

### Common Workflow Pipelines

#### 🔧 Feature Development Pipeline
```
@Sprint Planner → Plan feature tasks
    ↓
@[Specialist Agent] → Implement feature
    ↓
@Code Reviewer → Validate implementation
    ↓
@Documentation Maintainer → Update MEMORY.md
```

#### 🎨 3D Asset Pipeline
```
@3D Model Spec Writer → Create specification
    ↓
@Blender AI Artist → Generate model via MCP
    ↓
@Texture Artist → Apply PBR materials
    ↓
@GLB Import Reviewer → Quality check
    ↓
@Level Populator → Place in scene
```

#### 🐛 Bug Fix Pipeline
```
@Urban Survivor Debugger → Diagnose issue
    ↓
@[Specialist Agent] → Implement fix
    ↓
@Code Reviewer → Verify fix
    ↓
@Documentation Maintainer → Log resolution
```

### Agent Chaining Examples

**Add New Weapon:**
```bash
@Sprint Planner plan adding Thompson SMG weapon
@3D Model Spec Writer spec-prop-model for Thompson M1928
@Blender AI Artist blender-create-prop using Thompson spec
@Combat Systems Developer add Thompson with full-auto fire
@Code Reviewer review Thompson implementation
```

**Add New Enemy:**
```bash
@3D Model Spec Writer spec-enemy-model for Military Police
@Character Artist blender-create-character for MP soldier
@Animation Artist create-character-animations for MP
@Enemy AI Developer create MP enemy with suppression behavior
@Level Populator place MP enemies in Zone 2
```

### MCP Requirements

Art pipeline agents require **Blender MCP Server**:
- Blender AI Artist
- Texture Artist
- Character Artist
- Animation Artist
- GLB Import Reviewer

**Setup**: Install Blender 3.6+ → Install MCP addon → Start MCP server → Configure VS Code

### All 21 Agents

| Agent | Definition | Purpose |
|-------|------------|---------|
| Godot C++ Expert | `godot-cpp-expert.agent.md` | GDExtension, bindings, lifecycle |
| Game Architecture Advisor | `game-architecture.agent.md` | System design, patterns |
| Combat Systems Developer | `combat-systems.agent.md` | Weapons, damage, hit detection |
| Enemy AI Developer | `enemy-ai.agent.md` | FSM, perception, navigation |
| GDScript UI Developer | `gdscript-ui.agent.md` | HUD, menus, signals |
| Godot Shader Specialist | `shader-specialist.agent.md` | Shaders, VFX, post-processing |
| Sprint Planner | `sprint-planner.agent.md` | Task breakdown, estimation |
| Code Reviewer | `code-reviewer.agent.md` | Standards, patterns |
| Urban Survivor Debugger | `debug-helper.agent.md` | Crashes, build issues |
| Documentation Maintainer | `doc-maintainer.agent.md` | MEMORY.md updates |
| Blender AI Artist | `blender-artist.agent.md` | 3D modeling via MCP |
| 3D Model Spec Writer | `model-spec-writer.agent.md` | Model specifications |
| Texture Artist | `texture-artist.agent.md` | PBR materials |
| Character Artist | `character-artist.agent.md` | Characters, rigging |
| Environment Artist | `environment-artist.agent.md` | Lighting, atmosphere |
| Animation Artist | `animation-artist.agent.md` | Animations, retargeting |
| Level Populator | `level-populator.agent.md` | Asset placement |
| GLB Import Reviewer | `glb-import-reviewer.agent.md` | Model quality checks |
| BlenderKit Asset Scout | `blenderkit-asset-scout.agent.md` | Asset discovery |
| Audio Ambience Designer | `audio-ambience.agent.md` | Soundscapes, music |

### All 39 Prompts

Located in `.github/prompts/`. Key prompts by category:

**Combat & Gameplay:**
`implement-weapon-raycast`, `implement-reload-state`, `add-hit-zones`, `implement-ai-attack-state`, `implement-ai-cover-seek`

**Visual & Environment:**
`setup-worldenvironment-1960s`, `implement-volumetric-lighting`, `configure-ambience-system`, `populate-1960s-props`, `populate-level-1`

**Asset Creation:**
`spec-player-model`, `spec-enemy-model`, `spec-vehicle-model`, `spec-building-model`, `blender-create-character`, `blender-create-vehicle`, `blender-create-prop`, `generate-pbr-textures`, `material-library-workflow`

**Animation:**
`import-mixamo-animations`, `create-character-animations`, `setup-animation-tree`

**BlenderKit:**
`search-blenderkit-asset`, `import-blenderkit-model`, `poll-blenderkit-download`

**Infrastructure:**
`register-new-class`, `bind-cpp-method`, `debug-extension-not-loading`, `update-cmake-sources`, `update-memory-entry`, `code-review-changes`, `plan-sprint`

---

## 📄 License

MIT License — See [LICENSE](LICENSE) file for details.

---

## 🚀 Running the Game

### macOS
```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game
# Or with custom path:
/Users/hluciano/Downloads/Godot.app/Contents/MacOS/Godot --path game &
```

### Windows
```powershell
godot.exe --path game
```

### Linux
```bash
godot --path game
```

---

<div align="center">

**Built with Godot 4.3+ | C++17 | AI-Assisted Development**

*"In the frozen streets of 1960s Manhattan, every supply cache could be your salvation... or your last mistake."*

</div>