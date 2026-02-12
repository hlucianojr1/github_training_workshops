# Urban Survivor - AI Coding Agent Instructions

> **IDE**: Visual Studio 2026 | **Engine**: Godot 4.3+ | **Language**: C++17 | **Team Development**

---

## ⚠️ CRITICAL REQUIREMENT: CLARIFICATION PROTOCOL

**BEFORE implementing ANY non-trivial code, you MUST ask the developer clarifying questions.**

### When to Ask Questions:
- **Always** before implementing new features or systems
- When modifying existing architecture or class relationships
- When unclear about integration points with other game systems
- When performance implications are uncertain
- When multiple valid approaches exist
- When error handling strategy is not specified
- When Godot node structure or scene hierarchy is involved
- Before suggesting changes to existing patterns
- When the scope of changes might affect multiple modules

### Example Questions to Ask:
- "Which existing system should this integrate with?"
- "What's the expected performance budget for this feature?"
- "Should this inherit from an existing class or be standalone?"
- "How should errors/edge cases be handled?"
- "Does this need to be exposed to GDScript or C++ only?"
- "Are there any team conventions I should follow beyond the documented standards?"
- "Should I update the documentation after this change?"

**Never assume architectural decisions. Always confirm with the developer.**

---

## Project Overview
This is a **third-person survival shooter** built with:
- **IDE**: Visual Studio 2026
- **Godot 4.3+** game engine
- **C++ GDExtension** for core systems (C++17 standard)
- **GDScript** for UI and rapid prototyping

---

## CRITICAL: Read These Files First
Before making ANY changes, read these documentation files:
1. `docs/ARCHITECTURE.md` - System architecture and class hierarchy
2. `docs/SPEC.md` - Game design specification
3. `docs/MEMORY.md` - Development decisions and known issues
4. `docs/CODING_STANDARDS.md` - Code style requirements

---

## Build System

### Building C++ Extension (Visual Studio 2026)
```powershell
# Configure (first time only) - Visual Studio 2026
cmake -B build -G "Visual Studio 18 2026"

# Build debug
cmake --build build --config Debug

# Build release
cmake --build build --config Release
```

### Visual Studio 2026 Specific
- Use CMake integration in VS 2026 for seamless builds
- Enable C++17 IntelliSense for godot-cpp compatibility
- Configure solution to use Clang-based toolset if needed for cross-platform

### Output Location
- DLL: `game/bin/liburban_survivor.windows.{debug|release}.x86_64.dll`

### After C++ Changes
1. Close Godot editor
2. Rebuild with cmake
3. Reopen Godot editor
4. Test changes

---

## Code Organization

### C++ Source (`src/`)
| Module | Purpose | Key Classes |
|--------|---------|-------------|
| `core/` | Game state | GameManager |
| `player/` | Player control | PlayerController |
| `camera/` | Camera system | ThirdPersonCamera |
| `ai/` | Enemy behavior | EnemyAI, AIPerception |
| `combat/` | Weapons/damage | Weapon, DamageSystem |
| `inventory/` | Items | Inventory, Item, ItemDatabase |
| `survival/` | Stats | SurvivalStats |
| `world/` | Levels | LevelManager, ScavengePoint |
| `ui/` | HUD | HUD |

### GDScript (`game/scenes/`, `game/scripts/`)
- Scene-specific scripts
- UI logic
- Prototyping

---

## Adding New Features

### Adding a New C++ Class

1. **Create header** (`src/module/my_class.hpp`):
```cpp
#ifndef MY_CLASS_HPP
#define MY_CLASS_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

class MyClass : public Node {
    GDCLASS(MyClass, Node)

protected:
    static void _bind_methods();

public:
    MyClass();
    ~MyClass();
};

} // namespace godot

#endif
```

2. **Create implementation** (`src/module/my_class.cpp`):
```cpp
#include "my_class.hpp"

namespace godot {

void MyClass::_bind_methods() {
    // Register methods, properties, signals
}

MyClass::MyClass() {}
MyClass::~MyClass() {}

} // namespace godot
```

3. **Register in `src/register_types.cpp`**:
```cpp
#include "module/my_class.hpp"

void initialize_urban_survivor(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
    
    GDREGISTER_CLASS(MyClass);  // Add this line
}
```

4. **Add to `CMakeLists.txt`**:
```cmake
set(SOURCES
    # ... existing sources ...
    src/module/my_class.cpp
)
```

5. **Rebuild**

### Adding a New GDScript

1. Create `.gd` file in `game/scenes/` or `game/scripts/`
2. Use proper naming: `snake_case.gd`
3. Follow `docs/CODING_STANDARDS.md`

---

## Godot 4.3 API Notes

### Changed APIs (common mistakes)
```cpp
// OLD (doesn't work):
Vector3::ZERO, Vector3::UP, Vector3::FORWARD

// NEW (Godot 4.3):
Vector3(0, 0, 0)
Vector3(0, 1, 0)
Vector3(0, 0, -1)
```

### Proper Includes
```cpp
// Core
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/math.hpp>

// Classes (use the specific class header)
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/input_event.hpp>
```

### Signal Binding
```cpp
void MyClass::_bind_methods() {
    // Signal with parameters
    ADD_SIGNAL(MethodInfo("my_signal",
        PropertyInfo(Variant::FLOAT, "value"),
        PropertyInfo(Variant::STRING, "name")));
    
    // Emit signal
    emit_signal("my_signal", 1.5f, "test");
}
```

---

## Common Tasks

### Player Movement (already implemented in PlayerController)
- Uses CharacterBody3D
- WASD input → velocity → move_and_slide()
- Sprint with Shift, Crouch with Ctrl
- Jump with Space

### AI Behavior (already implemented in EnemyAI)
- Finite State Machine pattern
- States: IDLE, PATROL, INVESTIGATE, CHASE, ATTACK, FLEE, DEAD
- Uses NavigationAgent3D for pathfinding
- AIPerception for sight/hearing

### Damage System (already implemented)
- DamageSystem.apply_damage(target, amount, type, source)
- Emits signals for UI updates
- Hit zones: HEAD (2.5x), TORSO (1.0x), LIMBS (0.7x)

---

## Testing

### Quick Test
1. Build the extension
2. Open Godot: `game/project.godot`
3. Run (F5) - starts at main menu
4. Click "Start" to load test scene
5. WASD to move, mouse to look, ESC to quit

### Testing C++ Classes
1. Add test scene with the class
2. Expose properties to editor for tweaking
3. Use `print()` or Godot debugger

---

## DO NOT

1. **Don't modify `external/godot-cpp/`** - it's a git submodule
2. **Don't hardcode file paths** - use `res://` paths
3. **Don't ignore warnings** - they often indicate bugs
4. **Don't skip `_bind_methods()`** - class won't work in Godot
5. **Don't forget null checks** - use `ERR_FAIL_NULL(ptr)`
6. **Don't create nodes in constructors** - use `_ready()`

---

## DO

1. **Follow existing patterns** - look at similar classes
2. **Use signals for loose coupling** - not direct function calls
3. **Document public methods** - with Doxygen-style comments
4. **Test after every change** - catch bugs early
5. **Update docs** - if you add features or change behavior
6. **Use composition** - Godot favors composition over inheritance

---

## Troubleshooting

### "Class not found" in Godot
- Check `register_types.cpp` for GDREGISTER_CLASS
- Rebuild the extension
- Restart Godot editor

### Extension not loading
- Check `game/urban_survivor.gdextension` paths
- Ensure DLL exists in `game/bin/`
- Check Godot output for errors

### Crash on startup
- Check `_bind_methods()` for errors
- Verify all method signatures match declarations
- Look for null pointer access in constructors

### Vulkan errors
- The dev machine uses D3D12 fallback
- This is expected, not an error
- Test on Vulkan before release

---

## File Quick Reference

| Need to... | Look at... |
|------------|------------|
| Add player feature | `src/player/player_controller.cpp` |
| Add enemy behavior | `src/ai/enemy_ai.cpp` |
| Add weapon | `src/combat/weapon.cpp` |
| Add item | `src/inventory/item.cpp`, `item_database.cpp` |
| Modify UI | `game/scenes/*.gd` |
| Change game flow | `src/core/game_manager.cpp` |
| Understand architecture | `docs/ARCHITECTURE.md` |
| Check game design | `docs/SPEC.md` |
| Code style questions | `docs/CODING_STANDARDS.md` |
| Past decisions | `docs/MEMORY.md` |

---

## Visual Studio 2026 Custom Agents & Prompts

This repo includes **specialized Copilot agents** and **task prompts** to execute the production roadmap with consistent standards.

> **Note**: These configurations work with Visual Studio 2026's integrated Copilot Chat.

### Agents
Location: `.github/agents/`

- `godot-cpp-expert.agent.md` — C++ GDExtension patterns, bindings, lifecycle
- `combat-systems.agent.md` — weapon firing/reload, hit detection, DamageSystem integration
- `enemy-ai.agent.md` — FSM AI, perception, navigation, combat behaviors
- `gdscript-ui.agent.md` — HUD/menus in GDScript wired via signals
- `game-architecture.agent.md` — architecture review and cross-system integration
- `sprint-planner.agent.md` — roadmap-aligned sprint planning and task breakdown
- `debug-helper.agent.md` — build/runtime crash debugging for GDExtension
- `code-reviewer.agent.md` — standards + architecture code review
- `doc-maintainer.agent.md` — updates to MEMORY/ARCHITECTURE/SPEC when decisions change

### Prompts
Location: `.github/prompts/`

Use these to drive repeatable workflows:
- `plan-sprint.prompt.md`
- `implement-weapon-raycast.prompt.md`
- `implement-reload-state.prompt.md`
- `add-hit-zones.prompt.md`
- `implement-ai-attack-state.prompt.md`
- `implement-ai-cover-seek.prompt.md`
- `wire-hud-health-ammo.prompt.md`
- `register-new-class.prompt.md`
- `bind-cpp-method.prompt.md`
- `update-cmake-sources.prompt.md`
- `debug-extension-not-loading.prompt.md`
- `code-review-changes.prompt.md`
- `update-memory-entry.prompt.md`
- `populate-level-1.prompt.md`

### Scoped Instructions
Location: `.github/instructions/`

- `cpp-gdextension.instructions.md` (applies to `**/*.{cpp,hpp}`)
- `gdscript.instructions.md` (applies to `**/*.gd`)
- `scene-files.instructions.md` (applies to `**/*.tscn`)

### Recommended SDLC Flow
1) Plan: use `plan-sprint.prompt.md` (agent: Sprint Planner)
2) Implement: pick the specialist agent for the feature area
3) Debug: use Debug Helper when builds/crashes occur
4) Review: use Code Reviewer before merging
5) Document: use Documentation Maintainer for decisions/known issues

---

## Code Style & Naming Conventions

### Naming Standards
| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `PlayerController`, `AIPerception` |
| Files | snake_case (matching class) | `player_controller.hpp` |
| Methods | snake_case | `get_velocity()`, `apply_damage()` |
| Member Variables | snake_case | `move_speed`, `current_health` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_HEALTH`, `DEFAULT_SPEED` |
| Enums | PascalCase (scoped) | `enum class MovementState { IDLE }` |

### Documentation Standards
```cpp
/**
 * Brief description of the class/method.
 * 
 * Detailed explanation of purpose and usage.
 * 
 * @param param1 Description of parameter
 * @return Description of return value
 */
```

---

## Team Workflow

### Before Implementing ANY Feature
1. **Ask clarifying questions** about requirements
2. Review integration points with existing systems
3. Confirm approach with developer
4. Check `docs/` for relevant documentation

### Code Review Checklist
- [ ] Asked clarifying questions before implementing
- [ ] Follows naming conventions
- [ ] Proper documentation added
- [ ] Error handling in place
- [ ] No compiler warnings
- [ ] Godot bindings correct
- [ ] Tested functionality

---

## Remember

> **⚠️ ALWAYS ask clarifying questions before implementing. NEVER assume. CONFIRM with the developer.**
