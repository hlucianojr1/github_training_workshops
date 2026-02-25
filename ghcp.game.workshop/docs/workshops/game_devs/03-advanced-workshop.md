# Workshop 3: Advanced
## Instruction Files, Agents, Code Review, and Planning

**Duration**: 1 Hour  
**Level**: Advanced  
**Prerequisites**: Foundational + Intermediate Workshops  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)

---

## Workshop Objectives

By the end of this workshop, participants will:
- Master Chain-of-Thought prompting for complex problems
- Create and maintain Instruction Files for consistent AI behavior
- Build reusable Prompt Files for team workflows
- Use Copilot Code Review for quality assurance
- Leverage Copilot Plan Mode for multi-file changes
- Delegate complex tasks to Copilot Coding Agent
- Organize agents and prompts in Copilot Agent HQ
- Generate architecture and tech stack documentation

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:08 | Chain-of-Thought Prompting | Presentation + Demo |
| 0:08 - 0:18 | Instruction Files | Live Creation |
| 0:18 - 0:28 | Prompt Files | Workshop Exercise |
| 0:28 - 0:36 | Copilot Code Review | Demo + Practice |
| 0:36 - 0:44 | Copilot Plan Mode | Live Demo |
| 0:44 - 0:52 | Copilot Coding Agent | Hands-On |
| 0:52 - 0:56 | Copilot Agent HQ | Tour |
| 0:56 - 1:00 | Architecture Generation | Quick Demo |

---

## Session 1: Chain-of-Thought Prompting (8 min)

### Learning Objectives
- Break down complex problems into reasoning steps
- Guide AI through multi-step implementations
- Debug by reasoning through expected behavior

### What is Chain-of-Thought?

**Standard Prompt:**
```
Implement enemy flanking behavior
```

**Chain-of-Thought Prompt:**
```
I need to implement enemy flanking behavior for Urban Survivor. Let's reason through this step by step:

Step 1: What triggers flanking?
- Player is behind cover
- Multiple enemies are engaging
- Enemy is not the closest to player

Step 2: How do we find a flank position?
- Get perpendicular direction to player-enemy line
- Check both left and right options
- Validate position is navigable and has line of sight to player

Step 3: How do we coordinate with other enemies?
- Check if another enemy is already flanking
- Communicate via AIManager to avoid same flank side
- Stagger flank timing

Step 4: What's the state machine flow?
CHASE → FLANKING (if conditions met) → ATTACK (from flank) → CHASE (if spotted)

Now implement Step 1: the flanking trigger conditions in EnemyAI::should_attempt_flank()
```

### Demo: Complex AI Behavior

**Problem**: Implement cover-seeking when taking damage

```
Let's implement cover-seeking behavior when the enemy takes damage.

Analysis:
1. TRIGGER: Enemy receives damage
   - Health dropped by > 20% in last 2 seconds
   - OR received 3+ hits rapidly

2. FINDING COVER:
   - Query NavigationServer3D for nearby points
   - Filter: must block line-of-sight to damage source
   - Rank by: distance (closer = better) + protection angle

3. MOVEMENT:
   - Set navigation target to best cover point
   - Sprint to cover (1.5x normal speed)
   - If taking damage while moving, pick alternate cover

4. AT COVER:
   - Enter COVER state
   - Peek/shoot behavior with 2-second intervals
   - Exit if health > 50% OR cover destroyed

5. EDGE CASES:
   - No valid cover found → enter FLEE state
   - Cover already occupied → find next best
   - Player flanks cover → react and reposition

Let's start with the trigger logic in Step 1...
```

### Practice Exercise (3 min)

**Task**: Use Chain-of-Thought for weapon switching:

```
I need to implement weapon switching (number keys 1-5).

Think through:
1. Input handling (how do we capture 1-5 keys?)
2. Weapon slot validation (is weapon equipped in slot?)
3. Current action interruption (reload? can't switch)
4. Animation (holster current → draw new)
5. State update (what signals to emit?)
6. Edge cases to consider?

Start with Step 1...
```

---

## Session 2: Instruction Files (10 min)

### Learning Objectives
- Create instruction files for different file types
- Understand `applyTo` patterns
- Build a complete instruction file hierarchy

### Instruction File Structure

**Location**: `.github/instructions/`

**Format**:
```markdown
---
description: 'Brief description of these instructions'
applyTo: '**/*.{extensions}'
---

# Content follows...
```

### Urban Survivor Instruction Files

**1. C++ GDExtension** (`cpp-gdextension.instructions.md`):
```markdown
---
description: 'C++ GDExtension implementation rules for Urban Survivor (Godot 4.3+).'
applyTo: '**/*.{cpp,hpp}'
---

Follow these rules when editing C++ sources for Urban Survivor.

**Must read before edits:**
- docs/ARCHITECTURE.md
- docs/SPEC.md
- docs/CODING_STANDARDS.md

**Godot lifecycle:**
- Do not access the scene tree from constructors
- Do not create nodes in constructors; use `_ready()`
- Prefer `_physics_process()` for movement/AI ticks

**Binding requirements:**
- Every exposed class must have `GDCLASS()` and implement `_bind_methods()`
- Exposed names should be `snake_case`
- Declare signals using `ADD_SIGNAL(MethodInfo(...))`

**Safety & correctness:**
- Always null-check pointers: `ERR_FAIL_NULL(ptr)`
- Do not call `get_node()` every frame; cache references
- Avoid per-frame allocations

**Godot 4.3 API note:**
- Do not use Vector3::ZERO, Vector3::UP, Vector3::FORWARD

**Repo constraints:**
- Never modify `external/godot-cpp/`
- Use `res://` paths only; never hardcode OS paths
```

**2. GDScript** (`gdscript.instructions.md`):
```markdown
---
description: 'GDScript rules for Urban Survivor UI and scene scripting.'
applyTo: '**/*.gd'
---

**Style:**
- Use snake_case for variables and functions
- Use PascalCase for class names
- Prefix private members with underscore

**Signals:**
- Connect signals in _ready()
- Use typed signal parameters
- Disconnect in _exit_tree() if connecting to singletons

**Performance:**
- Cache $NodePath lookups in _ready()
- Use @onready for node references
- Avoid yield() in hot paths
```

**3. Scene Files** (`scene-files.instructions.md`):
```markdown
---
description: 'Rules for editing Godot scene files (.tscn).'
applyTo: '**/*.tscn'
---

**DO NOT directly edit .tscn files** - use Godot editor instead.

If you must suggest scene changes:
- Describe the node hierarchy to create
- Specify node types and properties
- List signal connections needed
- Reference existing scene patterns
```

### Live Creation Exercise (5 min)

**Task**: Create an instruction file for shaders:

```markdown
---
description: 'Godot shader rules for Urban Survivor visual effects.'
applyTo: '**/*.gdshader'
---

**Performance:**
- Avoid branching in fragment shaders
- Use uniform parameters for runtime tweaking
- Comment complex math operations

**Naming:**
- Use descriptive uniform names (e.g., rim_light_intensity)
- Prefix internal functions with underscore

**Integration:**
- All shaders should support the global TIME uniform
- Include comments for expected texture formats
```

---

## Session 3: Prompt Files (10 min)

### Learning Objectives
- Create reusable prompt files for common tasks
- Structure prompts with context, requirements, and test plans
- Build a library of team-shared prompts

### Prompt File Structure

**Location**: `.github/prompts/`

**Format**:
```markdown
---
agent: 'agent'  # or specific agent name
description: 'What this prompt accomplishes'
---

# Prompt content with placeholders...
```

### Urban Survivor Prompt Examples

**1. Implement Weapon Raycast** (`implement-weapon-raycast.prompt.md`):
```markdown
---
agent: '@combat-systems'
description: 'Implement raycast-based weapon firing'
---

You are implementing weapon firing mechanics for Urban Survivor.

**Context to load:**
- src/combat/weapon.hpp
- src/combat/damage_system.hpp
- docs/SPEC.md (Section 5.2: Weapons)

**Requirements:**
1. Cast ray from camera through crosshair center
2. Max range: weapon.effective_range (from weapon data)
3. On hit:
   - Determine hit zone (HEAD/TORSO/LIMBS) from collision point
   - Call DamageSystem::apply_damage() with appropriate parameters
   - Spawn impact particle at hit point
   - Play impact sound based on surface material
4. On miss:
   - Spawn tracer particle to max range
5. Emit "weapon_fired" signal with remaining ammo

**Test Plan:**
- [ ] Fire hits static target at 10m
- [ ] Fire hits moving enemy at 20m
- [ ] Headshots register correctly
- [ ] Ammo decrements on fire
- [ ] Impact particles spawn on surfaces
- [ ] Miss tracers visible

**Files to modify:**
- src/combat/weapon.cpp (add fire_raycast method)
- src/combat/weapon.hpp (declare method)
```

**2. Add Enemy State** (`implement-ai-state.prompt.md`):
```markdown
---
agent: '@enemy-ai'
description: 'Add a new state to the enemy FSM'
---

Add the {{STATE_NAME}} state to EnemyAI.

**Context:**
- src/ai/enemy_ai.cpp (existing state machine)
- docs/SPEC.md (Section 6: Enemy AI)
- docs/MEMORY.md (recent AI decisions)

**State Machine Pattern:**
```cpp
void EnemyAI::enter_{{state_name}}_state() {
    current_state = {{STATE_ENUM}};
    // Setup code
    emit_signal("state_changed", "{{state_name}}", previous_state_name);
}

void EnemyAI::update_{{state_name}}_state(float delta) {
    // Per-frame logic
    // Transition conditions
}

void EnemyAI::exit_{{state_name}}_state() {
    // Cleanup code
}
```

**Requirements:**
1. Add state enum value
2. Implement enter/update/exit methods
3. Add transitions TO this state from existing states
4. Add transitions FROM this state
5. Update state switch in main update()

**Test Plan:**
- [ ] State triggers under correct conditions
- [ ] Animation plays correctly
- [ ] Transitions work in both directions
- [ ] No stuck states or infinite loops
```

### Workshop Exercise (5 min)

**Task**: Create a prompt file for wiring HUD signals:

```markdown
---
agent: '@gdscript-ui'
description: 'Connect a game signal to HUD update'
---

Wire the {{SIGNAL_NAME}} signal to update the HUD.

**Context:**
- game/scenes/hud.gd (existing HUD script)
- src/{{SOURCE_CLASS}}.cpp (signal source)
- docs/SPEC.md (Section 8: HUD)

**Requirements:**
1. Connect signal in HUD._ready():
   - Get source node via path or singleton
   - Connect with proper callable

2. Create handler method _on_{{signal_name}}(params):
   - Update relevant UI element
   - Play feedback animation if applicable
   - Handle edge cases (max values, zero, etc.)

3. Handle disconnection in _exit_tree()

**Example Pattern:**
```gdscript
func _ready():
    var player = get_node("/root/Main/Player")
    player.{{signal_name}}.connect(_on_{{signal_name}})

func _on_{{signal_name}}(value, max_value):
    {{ui_element}}.value = value
    {{ui_element}}.max_value = max_value
```

**Test Plan:**
- [ ] Signal connected without errors
- [ ] UI updates when signal fires
- [ ] Edge cases handled (0, max, negative)
- [ ] No errors on scene exit
```

---

## Session 4: Copilot Code Review (8 min)

### Learning Objectives
- Use Copilot for automated code review
- Configure review criteria
- Integrate review into development workflow

### Invoking Code Review

**Method 1: Selection Review**
1. Select code block
2. Right-click → "Copilot: Review Selection"

**Method 2: Chat Command**
```
@workspace /review src/combat/weapon.cpp
```

**Method 3: Custom Agent Review**
```
@code-reviewer review the changes in src/ai/enemy_ai.cpp
Focus on: thread safety, null checks, performance
```

### Review Criteria for Game Dev

**Urban Survivor Code Review Checklist:**

| Category | Checks |
|----------|--------|
| **Correctness** | Logic matches SPEC.md, edge cases handled |
| **Safety** | Null checks, bounds checks, ERR_FAIL_* macros |
| **Performance** | No per-frame allocations, cached references |
| **Godot Patterns** | Correct lifecycle, proper signals |
| **Style** | Matches CODING_STANDARDS.md |
| **Integration** | Works with existing systems |

### Demo: Reviewing Damage Calculation

**Code to Review:**
```cpp
float DamageSystem::calculate_final_damage(float base, HitZone zone, 
                                            float armor, float distance) {
    float result = base;
    
    // Zone multiplier
    if (zone == HEAD) result *= 2.5;
    else if (zone == TORSO) result *= 1.0;
    else result *= 0.7;
    
    // Armor
    result *= (1.0 - armor / 100.0);
    
    // Distance falloff  
    if (distance > 10.0) {
        result *= 1.0 - (distance - 10.0) / 40.0;
    }
    
    return result;
}
```

**Review Prompt:**
```
@code-reviewer Review this damage calculation:

Check for:
1. Does it match SPEC.md Section 5.3 (Damage System)?
2. Are all values clamped appropriately?
3. Could armor or falloff result in negative damage?
4. Any integer division issues?
5. Should use Math::clamp from Godot?
```

**Review Output:**
```
## Code Review: calculate_final_damage

### Issues Found:

1. **CRITICAL: No minimum damage clamp**
   - High armor + distance = negative damage possible
   - Fix: `return Math::max(result, 1.0f);`

2. **MEDIUM: Armor reduction unclamped**
   - armor=150 gives 1.5x BONUS damage
   - Fix: `Math::clamp(1.0 - armor/100.0, 0.2, 1.0)`

3. **MEDIUM: Distance falloff unclamped**
   - At 60m, falloff = -0.25 (negative!)
   - Fix: `Math::clamp(falloff, 0.5, 1.0)`

4. **LOW: Magic numbers**
   - Extract: HEAD_MULTIPLIER, MIN_ARMOR_EFFECTIVENESS, etc.

### Suggested Fix:
[code suggestion provided]
```

### Practice Exercise (3 min)

**Review this AI perception code:**

```cpp
bool AIPerception::can_see_target(Node3D* target) {
    Vector3 to_target = target->get_global_position() - owner->get_global_position();
    float distance = to_target.length();
    
    if (distance > sight_range) return false;
    
    float angle = owner->get_global_transform().basis.get_rotation_quaternion()
                       .get_euler().y;
    float target_angle = atan2(to_target.x, to_target.z);
    
    if (abs(angle - target_angle) > sight_cone / 2) return false;
    
    // Raycast check
    auto space_state = owner->get_world_3d()->get_direct_space_state();
    // ... raycast ...
    
    return true;
}
```

---

## Session 5: Copilot Plan Mode (8 min)

### Learning Objectives
- Use Plan Mode for multi-file changes
- Review and modify generated plans
- Execute plans safely with checkpoints

### What is Plan Mode?

Plan Mode allows Copilot to:
1. Analyze a complex request
2. Create a step-by-step implementation plan
3. Show which files will be modified
4. Execute changes with your approval at each step

### Invoking Plan Mode

**In Chat:**
```
@workspace /plan Add a new INVESTIGATE state to EnemyAI that:
- Triggers when enemy hears gunfire but doesn't see player
- Navigates to last known sound location
- Searches area for 10 seconds
- Returns to patrol if player not found
```

### Demo: Multi-File Feature Addition

**Request:**
```
@workspace /plan Add radiation zones to the game that:
1. Are defined by Area3D nodes in levels
2. Damage players inside based on zone intensity
3. Show visual warning when player enters
4. Display radiation level on HUD
5. Apply damage over time using SurvivalStats
```

**Generated Plan:**
```
## Plan: Add Radiation Zones

### Files to Create:
1. src/world/radiation_zone.cpp/.hpp - RadiationZone class

### Files to Modify:
2. src/register_types.cpp - Register RadiationZone
3. CMakeLists.txt - Add source files
4. src/survival/survival_stats.cpp - Add radiation damage method
5. game/scenes/hud.gd - Add radiation indicator
6. game/scenes/level_1.tscn - Add test zone

### Implementation Steps:

**Step 1: Create RadiationZone class**
- Extends Area3D
- Properties: intensity (float), damage_rate (float)
- On body_entered: start damaging if PlayerController
- On body_exited: stop damaging

**Step 2: Register in GDExtension**
- Add GDREGISTER_CLASS(RadiationZone)

**Step 3: Add to SurvivalStats**
- apply_radiation_damage(float intensity, float delta)
- Emit "radiation_level_changed" signal

**Step 4: Update HUD**
- Connect to radiation_level_changed
- Show Geiger counter UI element
- Flash red at critical levels

**Step 5: Add test zone to level**
- Create Area3D with CollisionShape3D
- Set intensity property
- Add visual indicator (particles)

Shall I proceed with Step 1?
```

### Practice: Review a Plan (3 min)

**Given this plan output, identify potential issues:**

```
## Plan: Add Weapon Attachments

Step 1: Create Attachment base class
Step 2: Create ScopeAttachment, SilencerAttachment subclasses
Step 3: Modify Weapon class to hold attachment slots
Step 4: Add attachment UI to inventory screen
Step 5: Implement stat modifiers (accuracy, damage, range)
```

**Questions to consider:**
- Is the plan missing any integration steps?
- What about saving/loading attached items?
- How do attachments affect animations?

---

## Session 6: Copilot Coding Agent (8 min)

### Learning Objectives
- Delegate complex tasks to Coding Agent
- Monitor agent progress
- Review and refine agent output

### What is Copilot Coding Agent?

A more autonomous mode where Copilot:
- Understands the entire task scope
- Makes multiple file changes
- Runs tests to verify changes
- Iterates on its own errors

### Invoking Coding Agent

**Method 1: Agent Mode in Chat**
```
@workspace Use agent mode to implement the complete loot drop system:
- LootTable class with weighted random selection
- Integration with EnemyAI death event
- Item spawning at death location
- Pickup interaction for player
```

**Method 2: Dedicated Agent Panel**
- Open Copilot panel
- Select "Agent" tab
- Describe task in detail

### Demo: Agent Implementation

**Task for Agent:**
```
Implement a complete scavenging system for Urban Survivor:

1. ScavengePoint class (Node3D):
   - Has loot table and respawn timer
   - Player interacts with E key
   - Plays scavenge animation
   - Adds items to player inventory

2. Integration:
   - Register in GDExtension
   - Add interaction prompt to HUD
   - Create sample scavenge points in level

3. Testing:
   - Verify item pickup works
   - Check inventory updates
   - Confirm respawn timer functions

Reference: docs/SPEC.md Section 4.3 (Scavenging)
```

**Agent Progress:**
```
[1/6] Reading docs/SPEC.md for scavenging requirements...
[2/6] Creating src/world/scavenge_point.hpp...
[3/6] Creating src/world/scavenge_point.cpp...
[4/6] Updating register_types.cpp...
[5/6] Adding interaction handling to PlayerController...
[6/6] Creating test scene with scavenge points...

✓ All changes complete. Running verification...
⚠ Found issue: Missing null check in line 45
  Auto-fixing...
✓ All tests pass
```

### Best Practices for Agent Tasks

| DO | DON'T |
|----|-------|
| Provide complete context | Give vague requirements |
| Reference documentation | Assume agent knows your patterns |
| Specify test criteria | Skip verification steps |
| Review all changes | Accept without reading |
| Break huge tasks into subtasks | Request entire game features |

---

## Session 7: Copilot Agent HQ (4 min)

### Learning Objectives
- Organize agents and prompts
- Manage agent permissions
- Access agent history and metrics

### Agent HQ Overview

**Location**: `.github/agents/` and GitHub web interface

**Urban Survivor Agent Roster:**

| Agent | Expertise | Files |
|-------|-----------|-------|
| `@godot-cpp-expert` | GDExtension, bindings | `src/**/*.{cpp,hpp}` |
| `@combat-systems` | Weapons, damage | `src/combat/**` |
| `@enemy-ai` | FSM, navigation | `src/ai/**` |
| `@gdscript-ui` | HUD, menus | `game/**/*.gd` |
| `@debug-helper` | Build errors, crashes | All |
| `@code-reviewer` | Quality assurance | All |
| `@doc-maintainer` | Documentation | `docs/**` |
| `@sprint-planner` | Task breakdown | Planning |

### Agent Configuration

**Agent File Example** (`.github/agents/combat-systems.agent.md`):
```markdown
---
name: 'combat-systems'
description: 'Expert in weapon mechanics and damage systems'
---

You are the combat systems specialist for Urban Survivor.

**Expertise:**
- Weapon firing, reload, and ammunition
- DamageSystem and hit detection
- Hit zones and multipliers
- Raycast/projectile weapons

**Reference Files:**
- src/combat/weapon.cpp
- src/combat/damage_system.cpp
- docs/SPEC.md (Section 5: Combat)
- docs/MEMORY.md (combat decisions)

**Response Style:**
- Always cite line numbers
- Include test cases
- Follow CODING_STANDARDS.md
```

---

## Session 8: Architecture & Tech Stack Generation (4 min)

### Learning Objectives
- Generate architecture documentation
- Create tech stack diagrams
- Document system interactions

### Architecture Generation

**Prompt:**
```
@workspace Generate an architecture diagram for Urban Survivor's combat system.
Include:
- Class relationships
- Signal flow
- Data dependencies
- Integration points with other systems
```

**Output:**
```
## Combat System Architecture

### Class Diagram
┌─────────────────┐     ┌─────────────────┐
│     Weapon      │────>│  DamageSystem   │
├─────────────────┤     ├─────────────────┤
│ - current_ammo  │     │ + apply_damage()│
│ - fire_rate     │     │ + calculate()   │
│ + fire()        │     └────────┬────────┘
│ + reload()      │              │
└────────┬────────┘              │
         │                       ▼
         │              ┌─────────────────┐
         │              │ Target (Player/ │
         │              │    EnemyAI)     │
         │              ├─────────────────┤
         │              │ - health        │
         │              │ - armor         │
         └─────────────>│ + take_damage() │
                        └─────────────────┘

### Signal Flow
Weapon.fire() 
  → emit("weapon_fired", ammo)
  → HUD updates ammo display

DamageSystem.apply_damage()
  → Target.take_damage()
  → emit("damage_dealt", amount)
  → emit("target_killed") if health <= 0
  → EnemyAI.enter_dead_state()
  → LootSpawner.spawn_loot()
```

### Tech Stack Documentation

**Prompt:**
```
@workspace Document the complete tech stack for Urban Survivor
with version numbers and purpose of each component.
```

---

## Workshop Summary

### Key Takeaways

1. **Chain-of-Thought** breaks complex problems into solvable steps
2. **Instruction Files** ensure consistent AI behavior per file type
3. **Prompt Files** create reusable, team-shared workflows
4. **Code Review** catches bugs and style issues automatically
5. **Plan Mode** safely handles multi-file changes
6. **Coding Agent** automates complete feature implementation
7. **Agent HQ** organizes your AI team
8. **Architecture generation** documents system design

### Homework Before Expert Workshop

1. Create an instruction file for a new file type in your project
2. Write 3 prompt files for common tasks
3. Use Plan Mode for a multi-file refactoring
4. Set up at least 2 custom agents for your domain

---

## Resources

- [Copilot Customization Docs](https://docs.github.com/copilot/customizing-copilot)
- [Prompt Engineering Best Practices](https://docs.github.com/copilot/using-github-copilot/best-practices)
- [Urban Survivor Agents](../../.github/agents/)
- [Urban Survivor Prompts](../../.github/prompts/)

---

*Next Workshop: [Expert - MCP Servers, Enterprise, and Certification](04-expert-workshop.md)*
