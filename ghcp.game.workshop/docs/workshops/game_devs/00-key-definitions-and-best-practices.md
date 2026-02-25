# GitHub Copilot Workshop Series
## Key Definitions & Best Practices for AI-Assisted Game Development

**Workshop Series**: AI-Assisted Game Development with GitHub Copilot  
**Project Reference**: Urban Survivor (Godot 4.3+ / C++ GDExtension)  
**Date**: January 2026

---

## Table of Contents
1. [Key Definitions](#key-definitions)
2. [Best Practices for AI-Assisted Game Development](#best-practices-for-ai-assisted-game-development)
3. [Workshop Series Overview](#workshop-series-overview)

---

## Key Definitions

### What is GitHub Copilot?

**GitHub Copilot** is an AI-powered coding assistant developed by GitHub and OpenAI that provides real-time code suggestions directly in your IDE. It acts as a "pair programmer" that understands context from your codebase, comments, and file structures to generate relevant code completions.

**Key Capabilities:**
- Inline code completions (single line to entire functions)
- Chat-based interactions for explanations and debugging
- Code review and refactoring suggestions
- Multi-file context awareness
- Support for 100+ programming languages including C++, GDScript, and Python

**In Game Development Context (Urban Survivor Example):**
```cpp
// Copilot understands Godot patterns when you write:
void PlayerController::_bind_methods() {
    // Copilot suggests appropriate ClassDB bindings
    ClassDB::bind_method(D_METHOD("get_health"), &PlayerController::get_health);
    ClassDB::bind_method(D_METHOD("set_health", "value"), &PlayerController::set_health);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "health"), "set_health", "get_health");
}
```

---

### What is an MCP Server?

**MCP (Model Context Protocol) Server** is an open standard that allows AI assistants like GitHub Copilot to connect to external tools, APIs, and data sources. MCP Servers extend Copilot's capabilities beyond code generation.

**Architecture:**
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  GitHub Copilot │◄───►│   MCP Server    │◄───►│ External Service│
│     (Host)      │     │   (Bridge)      │     │  (Data/Tools)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

**Examples of MCP Servers for Game Development:**
- **Azure MCP**: Deploy game builds to cloud infrastructure
- **Blender MCP**: Generate 3D models programmatically
- **Database MCP**: Query game analytics and player data
- **Docker MCP**: Manage containerized game servers

**Game Dev Use Case:**
```
User: "Deploy the latest Urban Survivor build to Azure PlayFab"
Copilot → Azure MCP Server → Azure PlayFab API → Deployment
```

---

### What are Custom Agents?

**Custom Agents** are specialized AI personas defined in markdown files that provide domain-specific expertise. They act as virtual team members with focused knowledge areas.

**Structure** (`.github/agents/` folder):
```markdown
---
name: 'combat-systems'
description: 'Expert in weapon mechanics, damage calculation, and hit detection'
---

You are a combat systems specialist for the Urban Survivor game.

**Expertise:**
- Weapon firing, reload mechanics, and ammunition
- DamageSystem integration
- Hit zone detection (HEAD 2.5x, TORSO 1.0x, LIMBS 0.7x)
- Raycast/hitscan weapon implementation

**Reference Files:**
- src/combat/weapon.cpp
- src/combat/damage_system.cpp
- docs/SPEC.md (Section 5: Combat)
```

**Urban Survivor Agents:**
| Agent | Expertise |
|-------|-----------|
| `@combat-systems` | Weapons, damage, hit detection |
| `@enemy-ai` | FSM AI, navigation, perception |
| `@godot-cpp-expert` | GDExtension bindings, lifecycle |
| `@gdscript-ui` | HUD, menus, UI signals |
| `@debug-helper` | Build errors, runtime crashes |

---

### What are Prompt Files?

**Prompt Files** are reusable templates (`.prompt.md`) that define structured workflows for common development tasks. They ensure consistency and encode best practices.

**Structure** (`.github/prompts/` folder):
```markdown
---
agent: 'agent'
description: 'Implement raycast weapon firing for Urban Survivor'
---

You are implementing weapon firing mechanics.

**Context to load:**
- src/combat/weapon.hpp
- src/combat/damage_system.hpp
- docs/SPEC.md (Section 5.2: Weapons)

**Implementation requirements:**
1. Cast ray from camera through crosshair
2. Apply damage via DamageSystem.apply_damage()
3. Spawn muzzle flash and impact particles
4. Play audio: fire sound, impact sound
5. Emit "weapon_fired" signal for HUD ammo update

**Test plan:**
- [ ] Fire hits static target at 10m
- [ ] Fire hits moving enemy
- [ ] Ammo decrements correctly
```

**Example Prompts for Game Development:**
- `implement-weapon-raycast.prompt.md`
- `implement-ai-attack-state.prompt.md`
- `wire-hud-health-ammo.prompt.md`
- `debug-extension-not-loading.prompt.md`

---

### What and Why is an Instruction File?

**Instruction Files** (`.instructions.md`) are persistent rules that automatically apply to specific file patterns. Unlike prompt files (invoked manually), instructions are **always active** when editing matching files.

**Why Use Instruction Files?**
1. **Consistency**: Every C++ file follows the same patterns
2. **Error Prevention**: Rules prevent common mistakes
3. **Onboarding**: New developers (and AI) learn standards automatically
4. **Language-Specific**: Different rules for C++, GDScript, shaders

**Structure** (`.github/instructions/` folder):
```markdown
---
description: 'C++ GDExtension rules for Urban Survivor'
applyTo: '**/*.{cpp,hpp}'
---

**Must read before edits:**
- docs/ARCHITECTURE.md
- docs/CODING_STANDARDS.md

**Godot lifecycle rules:**
- Do not create nodes in constructors; use `_ready()`
- Cache node references; never call `get_node()` every frame

**Binding requirements:**
- Every exposed class needs GDCLASS() and _bind_methods()
- Use snake_case for exposed method names

**Safety:**
- Always null-check pointers: ERR_FAIL_NULL(ptr)
- Never modify external/godot-cpp/
```

---

### What is Chain of Thought Prompting?

**Chain of Thought (CoT) Prompting** is a technique where you guide the AI to reason through a problem step-by-step before generating code. This improves accuracy for complex tasks.

**Without CoT (Direct Request):**
```
"Add cover-seeking behavior to EnemyAI"
```

**With CoT (Step-by-Step Reasoning):**
```
"I need to add cover-seeking behavior to EnemyAI. Let's think through this:

1. First, what triggers cover-seeking? (Taking damage, seeing armed player)
2. How do we find cover points? (Raycast to nearby NavigationRegion3D)
3. What makes a valid cover point? (Blocks line-of-sight to player)
4. How do we navigate there? (NavigationAgent3D.set_target_position)
5. What state do we enter? (COVER state with peek/shoot behavior)

Now implement step 1: the trigger conditions in the CHASE state."
```

**Benefits for Game Development:**
- Complex AI behaviors become tractable
- Algorithm design before implementation
- Debugging by reasoning through expected vs. actual behavior

---

### What is Few-Shot Prompting?

**Few-Shot Prompting** provides examples of the desired input→output pattern before making your actual request. This teaches the AI the expected format and style.

**Zero-Shot (No Examples):**
```
"Create a signal for when the player takes damage"
```

**Few-Shot (With Examples):**
```
"Here's how we define signals in Urban Survivor:

Example 1 - Weapon fired:
ADD_SIGNAL(MethodInfo("weapon_fired",
    PropertyInfo(Variant::INT, "ammo_remaining")));

Example 2 - Item collected:
ADD_SIGNAL(MethodInfo("item_collected",
    PropertyInfo(Variant::STRING, "item_id"),
    PropertyInfo(Variant::INT, "quantity")));

Now create a signal for when the player takes damage.
Include: damage amount, damage type, and attacker reference."
```

**Result:**
```cpp
ADD_SIGNAL(MethodInfo("damage_taken",
    PropertyInfo(Variant::FLOAT, "amount"),
    PropertyInfo(Variant::INT, "damage_type"),
    PropertyInfo(Variant::OBJECT, "attacker")));
```

---

### What is Tree of Thoughts Prompting?

**Tree of Thoughts (ToT) Prompting** explores multiple solution paths simultaneously, evaluating each before selecting the best approach. It's ideal for design decisions with trade-offs.

**Example - AI Pathfinding Strategy:**
```
"I need to decide how EnemyAI should navigate around obstacles.

Branch A: Pure NavigationAgent3D
- Pros: Built-in, handles dynamic obstacles
- Cons: Can look robotic, expensive for many agents

Branch B: Custom steering behaviors
- Pros: More natural movement, flocking possible
- Cons: More code to maintain, collision issues

Branch C: Hybrid (Navigation for long paths, steering for local)
- Pros: Best of both worlds
- Cons: Integration complexity

Evaluate each branch against Urban Survivor's requirements:
- Up to 15 simultaneous enemies
- Performance target: 60 FPS
- Behavior: Tactical, cover-seeking

Recommendation: Branch C is best because..."
```

---

### What is Self-Consistency Prompting?

**Self-Consistency Prompting** generates multiple independent solutions to the same problem, then selects the most common or highest-quality answer. This reduces errors on complex tasks.

**Example - Damage Calculation Validation:**
```
"Calculate the damage output for the following scenario three different ways:

Weapon: Pistol (base damage: 25)
Range: 15 meters (falloff starts at 10m)
Hit zone: HEAD (2.5x multiplier)
Target armor: Light (0.8x reduction)

Method 1: Step-by-step calculation
Method 2: Using the DamageSystem.calculate_final_damage() formula
Method 3: Working backwards from expected behavior

Compare results. If they differ, identify the error."
```

**Why Use Self-Consistency?**
- Catches calculation errors
- Validates complex algorithms
- Increases confidence in critical game mechanics

---

## Best Practices for AI-Assisted Game Development

### 1. Project Structure & Context

#### Establish Clear Documentation Hierarchy
```
docs/
├── ARCHITECTURE.md    # System design (read first)
├── SPEC.md            # Game design document
├── MEMORY.md          # Decisions & known issues
├── CODING_STANDARDS.md # Style guidelines
└── models/            # Asset specifications
```

#### Maintain a Living Memory File
Update `MEMORY.md` with every significant decision:
```markdown
## 2026-01-08: Enemy Cover-Seeking

**Decision**: Use NavigationServer3D.map_get_closest_point_to_segment()
**Rationale**: Better performance than custom raycasting
**Trade-off**: Less control over cover quality scoring
**Affected files**: src/ai/enemy_ai.cpp, src/ai/ai_perception.cpp
```

---

### 2. Prompt Engineering for Game Dev

#### Be Specific About Game Engine Patterns
❌ Vague: "Create a player controller"
✅ Specific: "Create a CharacterBody3D-based PlayerController for Godot 4.3 with WASD movement, sprint (Shift), crouch (Ctrl), and jump (Space). Use _physics_process for movement. Emit signals for stamina changes."

#### Include File Context in Prompts
```
"Looking at src/combat/weapon.cpp and src/combat/damage_system.hpp,
implement the reload_weapon() method that:
1. Checks current ammo vs magazine size
2. Plays reload animation via AnimationPlayer
3. Transfers ammo from inventory to magazine
4. Emits 'reload_complete' signal when done"
```

#### Reference Your SPEC.md for Accuracy
```
"According to docs/SPEC.md Section 3.1, player sprint speed is 8 m/s
and costs 10 stamina/sec. Implement the sprint logic matching these values."
```

---

### 3. Code Generation Patterns

#### Use Instruction Files for Language-Specific Rules
Create `.github/instructions/` files for each language:
- `cpp-gdextension.instructions.md` → `**/*.{cpp,hpp}`
- `gdscript.instructions.md` → `**/*.gd`
- `shader.instructions.md` → `**/*.gdshader`

#### Leverage Custom Agents for Specialized Tasks
```
@combat-systems implement the reload_weapon() method
@enemy-ai add flanking behavior to the CHASE state
@gdscript-ui create the inventory quick-slot UI
```

#### Create Prompt Files for Repeatable Tasks
Common game dev prompts:
- `implement-weapon-*.prompt.md` (per weapon type)
- `add-enemy-state.prompt.md` (FSM state template)
- `create-interactable.prompt.md` (world objects)
- `wire-signal-*.prompt.md` (UI connections)

---

### 4. Testing & Validation

#### Always Include Test Plans in Prompts
```
**Test Plan:**
- [ ] Player takes 10 damage → health bar updates
- [ ] Player health reaches 0 → game over triggered
- [ ] Damage number popup appears at hit location
- [ ] Damage sound plays with correct attenuation
```

#### Use Self-Consistency for Critical Systems
For damage calculations, economy balancing, or physics:
```
"Calculate the expected behavior THREE ways and compare.
If results differ, identify the discrepancy."
```

#### Validate Generated Code Against Standards
After generation, run:
```
@code-reviewer review the changes in src/combat/weapon.cpp
against docs/CODING_STANDARDS.md
```

---

### 5. Iterative Development

#### Start Small, Expand Gradually
1. Generate a skeleton with method signatures
2. Implement one method at a time
3. Test each method before proceeding
4. Refactor once all methods work

#### Use Chain of Thought for Complex Features
```
"Let's implement AI cover-seeking step by step:
Step 1: Define what triggers cover-seeking
Step 2: Find valid cover points
Step 3: Evaluate cover quality
Step 4: Navigate to best cover
Step 5: Implement peek/shoot behavior

Start with Step 1..."
```

#### Maintain Session Continuity
Reference previous decisions:
```
"Earlier we decided to use raycasting for cover detection.
Now implement the cover quality scoring based on:
- Distance to cover
- Angle of protection
- Line of sight to player"
```

---

### 6. Security & Privacy

#### Never Include Secrets in Context
- API keys, passwords, tokens
- Player personal data
- Proprietary algorithms

#### Review Generated Code for Vulnerabilities
Watch for:
- Unbounded loops in `_process()`
- Missing null checks (`ERR_FAIL_NULL()`)
- Unsafe file paths (use `res://` not absolute paths)

---

### 7. Performance Optimization

#### Profile Before Optimizing
```
"The Godot profiler shows _physics_process in EnemyAI
takes 2ms per frame with 10 enemies.
Identify the bottleneck and suggest optimizations."
```

#### Request Game-Specific Optimizations
```
"Optimize this code for Godot 4.3:
- Use object pooling for bullets
- Cache node references in _ready()
- Avoid per-frame allocations"
```

---

### 8. Collaboration Workflow

#### Use Prompt Files for Team Consistency
Team members invoke the same prompts:
```
/implement-weapon-raycast.prompt.md
```

#### Document Decisions in MEMORY.md
```
@doc-maintainer add entry for the new reload system:
- Reload cancels on damage taken
- Magazine size varies by weapon type
- Partial reloads supported
```

#### Review Before Merge
```
@code-reviewer review all changed files
Focus on: thread safety, signal connections, null checks
```

---

## Workshop Series Overview

| Level | Duration | Focus |
|-------|----------|-------|
| **[Foundational](01-foundational-workshop.md)** | 1 hour | Copilot basics, context, security |
| **[Intermediate](02-intermediate-workshop.md)** | 1 hour | Prompting, chat, testing |
| **[Advanced](03-advanced-workshop.md)** | 1 hour | Instruction files, agents, code review |
| **[Expert](04-expert-workshop.md)** | 1 hour | MCP servers, enterprise, certification |

---

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Model Context Protocol Spec](https://modelcontextprotocol.io)
- [Godot 4.3 GDExtension Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/)
- [Urban Survivor Architecture](../ARCHITECTURE.md)
- [Urban Survivor Spec](../SPEC.md)

---

*Last Updated: January 2026*
