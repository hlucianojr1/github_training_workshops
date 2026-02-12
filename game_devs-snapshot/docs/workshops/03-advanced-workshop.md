# Workshop 3: Advanced
## Instruction Files, Agents, Code Review, and Planning

**Duration**: 1 Hour  
**Level**: Advanced  
**IDE**: Visual Studio 2022 (17.14+) / Visual Studio 2026 Preview with GitHub Copilot  
**Prerequisites**: Foundational + Intermediate Workshops  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)  
**Date**: January 2026

> **Prerequisite:** This workshop assumes you have completed the Foundational and Intermediate Workshops and have Visual Studio 2022 (17.14+) or Visual Studio 2026 Preview installed. GitHub Copilot and Copilot Chat are first-party components of the IDE — no separate extension is required. You must be signed in with a GitHub account that has an active Copilot license.

> **Visual Studio vs. VS Code Feature Parity Note:** Most features in this workshop are fully supported in Visual Studio 2026. Where a capability is **VS Code-only** or works differently in Visual Studio, this document calls it out with a ⚠️ icon and provides the Visual Studio alternative.

---

## Workshop Objectives

By the end of this workshop, participants will:
- Master Chain-of-Thought prompting for complex problems
- Create and maintain Instruction Files for consistent AI behavior
- Build reusable Prompt Files for team workflows
- Use Copilot Chat and Inline Chat for code review
- Leverage Copilot Agent Mode for planned, multi-file changes
- Delegate complex tasks to Copilot Coding Agent (in-IDE and GitHub remote)
- Understand custom agent configuration and platform availability
- Generate architecture and tech stack documentation

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:08 | Chain-of-Thought Prompting | Presentation + Demo |
| 0:08 - 0:18 | Instruction Files | Live Creation |
| 0:18 - 0:28 | Prompt Files | Workshop Exercise |
| 0:28 - 0:36 | Code Review with Copilot Chat | Demo + Practice |
| 0:36 - 0:44 | Copilot Agent Mode (Plan + Execute) | Live Demo |
| 0:44 - 0:52 | Copilot Coding Agent (In-IDE + Remote) | Hands-On |
| 0:52 - 0:56 | Custom Agents & Agent HQ | Tour + Discussion |
| 0:56 - 1:00 | Architecture Generation | Quick Demo |

---

## Session 1: Chain-of-Thought Prompting (8 min)

### Learning Objectives
- Break down complex problems into reasoning steps
- Guide AI through multi-step implementations
- Debug by reasoning through expected behavior

### What is Chain-of-Thought?

Chain-of-Thought (CoT) prompting asks the model to reason through a problem step-by-step before generating code. In Visual Studio, open **Copilot Chat** (`Ctrl+\, Ctrl+C`) and type the prompt directly — the chat window has full solution context, so there is no need for an `@workspace` prefix.

**Standard Prompt:**
```
Implement enemy flanking behavior
```

**Chain-of-Thought Prompt (type in Copilot Chat):**
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

Open **Copilot Chat** in Visual Studio and paste the following Chain-of-Thought prompt:

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

**Task**: Open Copilot Chat (`Ctrl+\, Ctrl+C`) and use Chain-of-Thought for weapon switching:

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

### Additional Chain-of-Thought Examples (from the Urban Survivor Roadmap)

The following examples show how CoT applies to different categories of work from the actual project. Each demonstrates a different prompting pattern — use these as templates for your own tasks.

---

**CoT Example 1: Inventory Weight-Limit Enforcement** *(System Integration — SPEC Section 4)*

This example targets the Phase 2 roadmap task "Complete player controller" and demonstrates reasoning through a system that touches `Inventory`, `PlayerController`, and `SurvivalStats`.

```
I need to enforce inventory weight limits so the player slows down when
carrying too much. Let's think through how the existing systems connect.

Current state (what we already have):
- Inventory tracks current_weight and max_weight (inventory.hpp:31-32)
- Inventory has is_overweight() and get_weight_ratio() helpers
- PlayerController has walk_speed (5 m/s), sprint_speed (8 m/s) (player_controller.hpp:34-35)
- SurvivalStats has stamina_drain_rate (survival_stats.hpp:28)

Step 1: When should we check weight?
- On item add/remove → Inventory already emits signals (item_added, item_removed)
- PlayerController subscribes in _ready()
- Recalculate speed modifier when weight changes

Step 2: How does weight affect movement?
- 0–70% capacity → no penalty (normal gameplay shouldn't punish)
- 70–100% capacity → linear slowdown to 70% speed
- >100% capacity → 50% speed, cannot sprint, stamina drain +50%
- Formula: speed_multiplier = clamp(1.0 - (ratio - 0.7) / 0.3, 0.5, 1.0) when ratio > 0.7

Step 3: What about sprinting?
- Over 100% weight → can_sprint = false
- Between 70–100% → sprint allowed but stamina drains faster
- drain_modifier = 1.0 + (ratio - 0.7) * 1.67  → gives 1.5x at 100%

Step 4: How does the HUD show this?
- Emit "weight_changed(current, max)" signal from Inventory
- HUD shows weight bar with color coding: green → yellow → red
- Flash warning when crossing 70% threshold

Step 5: What signals already exist vs. need creation?
- Inventory has item_added/item_removed → EXIST
- Need: "weight_changed(float current, float max)" on Inventory
- Need: "movement_penalty_changed(float multiplier)" on PlayerController

Now implement Step 2: the speed modifier calculation in PlayerController.
```

---

**CoT Example 2: Save/Load System Architecture** *(Architecture Design — Phase 3 Roadmap)*

This example targets the Phase 3 Alpha task "Save/load system" and demonstrates CoT for architectural decisions where no code exists yet.

```
The roadmap calls for a save/load system in Phase 3 Alpha. Let's design
this before writing any code.

Step 1: What data needs saving?
- Player: position, rotation, health, stamina (SurvivalStats)
- Inventory: all items + quantities + equipped slots
- World state: which ScavengePoints have been looted (has_been_looted flags)
- Enemy state: alive/dead, current position, alert state
- Game progress: current level, objectives completed
- Settings: separate file (not part of game save)

Step 2: What format should we use?
- Option A: JSON via Godot's JSON class → human-readable, easy to debug
- Option B: Binary via Godot's FileAccess → smaller, faster, harder to cheat
- Decision: JSON for dev/debug, with option to switch to binary for release
- Godot path: "user://saves/save_[slot].json"

Step 3: Who owns serialization?
- Each system serializes itself via to_dict() / from_dict() methods
- SaveManager (new singleton) coordinates the process
- Pattern: SaveManager calls system.to_dict() → merges into root dict → writes file

Step 4: Save flow (what order)?
1. Pause game (prevent state changes during save)
2. SaveManager.save_game(slot):
   a. GameManager.to_dict() → game state + level info
   b. PlayerController.to_dict() → position, rotation
   c. SurvivalStats.to_dict() → health, stamina
   d. Inventory.to_dict() → items, quantities
   e. LevelManager.to_dict() → scavenge points, enemy states
3. Write JSON to disk
4. Emit "game_saved" signal
5. Unpause

Step 5: Load flow (what order matters)?
1. GameManager loads first (sets game state, determines which level)
2. LevelManager loads level scene
3. PlayerController applies position/rotation
4. SurvivalStats applies health/stamina
5. Inventory restores items (depends on ItemDatabase being ready)
6. World state restores ScavengePoint/enemy states
- Critical: ItemDatabase must be loaded BEFORE Inventory (autoload order)

Step 6: Edge cases?
- Save file corruption → validate JSON structure, fallback to last good save
- Version mismatch → include save_version field, migration logic
- Save during combat → queue save until combat ends, or checkpoint-only saves
- Missing items in database → skip unknown items, log warning

Now implement Step 3: the to_dict()/from_dict() interface on SurvivalStats.
```

---

**CoT Example 3: Stealth Detection System** *(Gameplay Mechanic — SPEC Section 5.3 + 6.3)*

This example targets the Phase 2 task "AI combat behavior" and demonstrates CoT that cross-references multiple SPEC sections.

```
I need to implement the stealth detection modifiers from SPEC Section 5.3
into AIPerception (Section 6.3). Let's trace the data flow.

Step 1: What detection factors exist? (from SPEC)
- Player crouching → -50% detection range
- Player sprinting → +100% detection range
- Line of sight blocked → no visual detection
- Gunfire → alerts enemies within 50m
- Suppressed weapon → alerts within 15m

Step 2: Where does this data live right now?
- PlayerController knows: is_crouching (player_controller.hpp:49),
  movement_state (SPRINTING enum)
- AIPerception has: sight range 30m, 60° FOV, hearing 20m/50m (SPEC 6.3)
- Weapon has: (need to add) is_suppressed property

Step 3: How should detection range be calculated?
- Base sight range: 30m
- Modified: base * get_player_visibility_modifier()
- get_player_visibility_modifier():
  - if crouching: return 0.5
  - if sprinting: return 2.0
  - if walking: return 1.0
  - (future: lighting, weather multipliers)

Step 4: How should sound propagation work?
- On weapon_fired signal → create sound event with:
  - position (world space)
  - radius (50m normal, 15m suppressed)
  - type (GUNFIRE, FOOTSTEP, EXPLOSION)
- All AIPerception nodes check distance to sound event
- If within radius → set investigate_position, transition to INVESTIGATE

Step 5: How do we avoid every enemy reacting at once?
- Add reaction_delay: random(0.5, 2.0) seconds per enemy
- Enemies within 15m react immediately (close range)
- Enemies 15-50m have staggered reaction times
- Only enemies in IDLE or PATROL states react to distant sounds

Step 6: Integration with existing EnemyAI states?
- IDLE/PATROL + sound event → INVESTIGATE (after reaction_delay)
- IDLE/PATROL + visual detection → CHASE (immediate)
- INVESTIGATE + visual confirmation → CHASE
- INVESTIGATE + no detection for 10s → return to PATROL

Start with Step 3: implementing get_player_visibility_modifier() in AIPerception.
```

---

**CoT Example 4: HUD Interaction Prompt System** *(UI Integration — SPEC Section 10.2)*

This example targets the Phase 2 task "Basic UI/HUD" and demonstrates CoT for a feature that bridges C++ and GDScript.

```
I need to implement context-sensitive interaction prompts on the HUD
(SPEC 10.2: "E to Open", "E to Pickup", item preview on hover).

Step 1: Who detects what the player is looking at?
- PlayerController already has interaction_range (2.0m)
  (player_controller.hpp:69)
- Need: a raycast from camera center, 2m forward
- Raycast in _physics_process → check collision layer for "interactable"
- Return: the Node3D hit (or null)

Step 2: How do interactable objects identify themselves?
- Option A: check for group "interactable" → simple but no metadata
- Option B: interface pattern — all interactable nodes implement
  get_interaction_text() → "Open Container", "Pickup Bandage"
- Decision: Group + method. Check group first (fast), then call method.
- ScavengePoint → "Search [container name]"
- Item pickup → "Pickup [item name]"
- Door → "Open" / "Locked (need key)"

Step 3: What data flows to the HUD?
- Signal: "interaction_target_changed(String text, bool is_available)"
- When raycast hits interactable: emit with text from get_interaction_text()
- When raycast hits nothing: emit with "" and false
- HUD subscribes, shows/hides the prompt label

Step 4: What does the HUD display look like?
- Centered bottom-third of screen
- "[E] Search Supply Crate" with key icon
- Fade in/out (0.2s tween) — not instant pop
- Item preview: show icon + name + quantity (if pickup)
- Red text if cannot interact (locked, already looted)

Step 5: C++ vs. GDScript split?
- C++ (PlayerController): raycast, detect target, emit signal
- C++ (ScavengePoint, etc.): implement get_interaction_text()
- GDScript (HUD): subscribe to signal, animate label, show preview
- This follows the architecture split: C++ for logic, GDScript for UI

Step 6: What about overlapping interactables?
- Raycast returns closest hit → only one prompt at a time
- If multiple objects at same distance → prefer the one closer to screen center
- ScavengePoints with has_been_looted → show "Empty" in gray, no [E] prompt

Start with Step 1: adding the interaction raycast to PlayerController._physics_process().
```

### Complex Multi-Layer Chain-of-Thought: Phase 2 Vertical Slice End-to-End

This advanced example demonstrates how to use CoT for a **cross-system, multi-milestone task** — delivering the Phase 2 Vertical Slice "first playable combat encounter." It spans 5 systems (AI, combat, inventory, HUD, world) and is the kind of prompt that benefits most from structured reasoning.

Open **Copilot Chat** in Agent Mode and paste the following. The model will use this reasoning structure to plan and execute across many files.

```
I need to deliver the Phase 2 Vertical Slice milestone: a complete,
playable combat encounter in Level 1 (Manhattan). This requires multiple
systems working together end-to-end. Let's reason through the full stack.

═══════════════════════════════════════════════════════
LAYER 1: WORLD SETUP — What does the encounter area look like?
═══════════════════════════════════════════════════════

1a. Level structure (from SPEC 7.1, 7.2):
   - Level 1 = Manhattan, NYC — Tutorial difficulty
   - Need: Entry point → exploration area → combat zone → exit point
   - Combat zone: a city block with 2-3 buildings for cover

1b. Scavenge points (from SPEC 7.3):
   - Place 3 small containers (1-2 common items each) before combat zone
   - Player should find: Bandage, Ammo (.45 ACP) — enough to survive encounter
   - Use ScavengePoint class (scavenge_point.hpp) with item_pool setup

1c. Environmental setup:
   - Cover objects (concrete barriers, cars, dumpsters) — use StaticBody3D with collision
   - Sight lines: player should be able to see enemies at 20-30m range
   - NavigationRegion3D must cover the combat area for enemy pathfinding

═══════════════════════════════════════════════════════
LAYER 2: ENEMY PLACEMENT — Who does the player fight?
═══════════════════════════════════════════════════════

2a. Enemy composition (from SPEC 6.1):
   - Tutorial encounter: 2 Scavengers (75 HP, 15 dmg, flee when hurt)
   - Placed at medium range (15-20m from likely player approach)
   - One patrolling, one idle near a loot container

2b. AI behavior requirements (from SPEC 6.2):
   - Must demonstrate state transitions: IDLE → INVESTIGATE → CHASE → ATTACK
   - Scavenger type should FLEE when health < 20% (flee_health_threshold = 0.2)
   - Both enemies communicate player position (SPEC 6.4 group behavior)

2c. Perception setup (from SPEC 6.3):
   - Sight: 30m, 60° FOV
   - Hearing: gunfire alerts within 50m
   - When player enters combat zone → patrolling enemy should spot player
   - When player fires → idle enemy hears and investigates

═══════════════════════════════════════════════════════
LAYER 3: COMBAT FLOW — What happens when fighting starts?
═══════════════════════════════════════════════════════

3a. Player weapons (from SPEC 5.1):
   - Player starts with M1911 Pistol (25 dmg, 7 mag, 30m range, 85% accuracy)
   - 21 rounds total (7 loaded + 14 reserve) — enough for encounter but not wasteful
   - Weapon already implemented in weapon.hpp

3b. Damage calculation (from SPEC 5.2):
   - Base Damage × Range Falloff × Hit Zone = Final Damage
   - At 15m (mid-range): M1911 does 25 × 1.0 × 1.0 = 25 to torso
   - Headshot: 25 × 1.0 × 2.5 = 62.5 → kills Scavenger (75 HP) in 2 headshots
   - Body shots: need 3 shots → forces player to aim carefully

3c. Enemy combat (from SPEC 6.1, 6.2):
   - Scavengers deal 15 damage per hit
   - Player has 100 HP → can take ~6 hits before death
   - Enemy attack_cooldown = 1.5s → player has time to react
   - At 20% HP enemy flees → teaches player that enemies retreat

═══════════════════════════════════════════════════════
LAYER 4: HUD FEEDBACK — What does the player see/know?
═══════════════════════════════════════════════════════

4a. Required HUD elements (from SPEC 10.1):
   - Health bar (top-left) — connected to SurvivalStats.health_changed signal
   - Stamina bar (below health) — connected to SurvivalStats.stamina_changed
   - Ammo counter (bottom-right) — "7 / 14" format
   - Crosshair (center) — already exists
   - Quick slots (bottom-left) — show Bandage in slot 1

4b. Combat-specific HUD:
   - Damage indicator: red flash on screen edges (direction of damage source)
   - Hit marker: brief crosshair flash when player hits enemy
   - Kill notification: "Enemy Eliminated" text
   - Low ammo warning: ammo counter turns red when mag < 30%

4c. Signal wiring needed:
   - SurvivalStats → HUD: health_changed, stamina_changed
   - Weapon → HUD: ammo_changed, weapon_fired
   - DamageSystem → HUD: damage_dealt (for hit markers), player_damaged (for flash)
   - EnemyAI → HUD: (via DamageSystem entity_killed signal)

═══════════════════════════════════════════════════════
LAYER 5: INTEGRATION & TEST — How do we verify it all works?
═══════════════════════════════════════════════════════

5a. Integration order (respecting dependencies):
   1. World: NavigationRegion3D + cover geometry (no code deps)
   2. Enemies: Place EnemyAI nodes, configure stats (depends on nav mesh)
   3. Scavenge: Place ScavengePoint nodes, configure loot tables (no code deps)
   4. HUD signals: Wire all signals listed in 4c (depends on existing C++ signals)
   5. Player spawn: Set entry point with starting weapon + ammo
   6. Play test: walk through the full encounter

5b. Test plan — things to verify:
   - [ ] Player spawns with M1911 + 21 rounds
   - [ ] 3 scavenge points give Bandage and .45 ammo
   - [ ] Patrolling enemy detects player at ~25m
   - [ ] Gunfire alerts second enemy from 50m away
   - [ ] Enemies chase and attack (damage player for 15 HP)
   - [ ] 3 body shots kill a Scavenger (75 HP)
   - [ ] Enemy flees at 20% HP (15 HP remaining)
   - [ ] HUD shows health, stamina, ammo correctly
   - [ ] Hit markers + damage flash work
   - [ ] Player can heal with Bandage from quick slot
   - [ ] Encounter is survivable but challenging

5c. Known risks:
   - Navigation mesh may not cover cover objects → test pathfinding
   - Signal connections may fail silently → check Godot output log
   - Enemy accuracy too high/low → tune ai_accuracy_modifier (currently 0.7)
   - Frame rate in combat area → profile if > 3 enemies

Now start with Layer 1a: describe the scene tree hierarchy for the combat
zone area in Level 1, then proceed to Layer 2a enemy placement.
```

> **Why this works well:** By decomposing a multi-system milestone into labeled layers, you give the AI a mental map of the entire feature. Each layer references specific SPEC sections and source files, so the model can verify its work against the design document. The numbered test plan at the end becomes a checklist you can actually use.

---

## Session 2: Instruction Files (10 min)

### Learning Objectives
- Create instruction files for different file types
- Understand `applyTo` patterns
- Build a complete instruction file hierarchy

### What Are Instruction Files?

Instruction files let you give Copilot persistent, file-type-scoped rules that are applied automatically — every time Copilot generates code for a matching file, these rules are included in context. This replaces having to repeat coding standards in every prompt.

### Visual Studio Support

| Feature | Visual Studio 2022 | Visual Studio 2026 |
|---------|--------------------|--------------------|
| Repo-level instructions (`.github/copilot-instructions.md`) | 17.12+ | ✅ |
| Scoped instruction files (`.github/instructions/*.md`) | 17.13+ | ✅ |
| View active instructions | **Tools > Options > GitHub Copilot** | ✅ |

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

### How to Create Instruction Files in Visual Studio

1. In **Solution Explorer**, right-click the `.github` folder (create it if it doesn't exist)
2. **Add > New Folder** → name it `instructions`
3. **Add > New Item** → choose **Text File**, name it `my-rules.instructions.md`
4. Add the YAML front matter with `description` and `applyTo` fields
5. Write your rules in Markdown below the front matter
6. Save — Copilot picks up the file automatically for matching file types

> **Tip:** You can also ask Copilot Chat to create instruction files for you: *"Create an instruction file for our C++ GDExtension code that enforces the rules in docs/CODING_STANDARDS.md"*

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

### What Are Prompt Files?

Prompt files are reusable, parameterized prompt templates stored in your repo. They let your team share consistent workflows — any developer can invoke the same prompt to perform a task the same way every time.

### Visual Studio Support

Prompt files are supported in **Visual Studio 2022 (17.14+)** and **Visual Studio 2026 Preview**.

**How to invoke a prompt file in Visual Studio:**
1. Open **Copilot Chat** (`Ctrl+\, Ctrl+C`)
2. Click the **Attach Context** (📎) button at the bottom of the chat input
3. Select **Prompt Files** from the menu
4. Browse and select the `.prompt.md` file from `.github/prompts/`
5. Fill in any placeholder values and send

> **Tip:** You can also type `#` in the Copilot Chat input box and select a prompt file from the auto-complete list.

### Prompt File Structure

**Location**: `.github/prompts/`

**Format**:
```markdown
---
mode: 'agent'
description: 'What this prompt accomplishes'
---

# Prompt content with placeholders...
```

> ⚠️ **VS Code vs. Visual Studio:** In VS Code, prompt files support an `agent:` front matter field to route to custom agents (e.g., `agent: '@combat-systems'`). Visual Studio 2026 does **not** support custom `@agent-name` routing. Use `mode: 'agent'` instead to run the prompt in agent mode, which enables multi-file editing and tool use.

### Urban Survivor Prompt Examples

**1. Implement Weapon Raycast** (`implement-weapon-raycast.prompt.md`):
```markdown
---
mode: 'agent'
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
mode: 'agent'
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
mode: 'agent'
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

## Session 4: Code Review with Copilot Chat (8 min)

### Learning Objectives
- Use Copilot Chat and Inline Chat for code review
- Configure review criteria with structured prompts
- Integrate review into development workflow

### Code Review in Visual Studio 2026

> ⚠️ **VS Code vs. Visual Studio:** VS Code offers a dedicated **"Copilot: Review Selection"** right-click command and a `/review` slash command. These are **not available** in Visual Studio 2026. Instead, use the methods below — they are equally effective and give you more control over review criteria.

### Invoking Code Review

**Method 1: Inline Chat Review**
1. Select the code block you want reviewed in the editor
2. Press **Alt+/** to open Inline Chat
3. Type: `Review this code for bugs, performance issues, and safety`
4. Copilot responds with inline suggestions and explanations

**Method 2: Copilot Chat with File Context**
1. Open **Copilot Chat** (`Ctrl+\, Ctrl+C`)
2. Use `#file:src/combat/weapon.cpp` to attach the file as context
3. Type your review request with specific criteria

```
Review #file:src/combat/weapon.cpp for:
- Null pointer safety
- Per-frame allocation issues
- Godot lifecycle correctness
- Compliance with docs/CODING_STANDARDS.md
```

**Method 3: GitHub Pull Request Review (on GitHub.com)**
1. Open your pull request on GitHub.com
2. Click **Copilot** in the review toolbar
3. Copilot reviews the entire diff and posts comments
4. This works for all IDEs — it runs on GitHub, not in the editor

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

**Review Prompt (type in Copilot Chat):**
```
Review this damage calculation from #file:src/combat/damage_system.cpp:

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

**Review this AI perception code** — select it in the editor, press **Alt+/** (Inline Chat), and ask Copilot to review for null safety, angle calculation correctness, and missing raycast implementation:

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

## Session 5: Copilot Agent Mode — Plan and Execute (8 min)

### Learning Objectives
- Use Agent Mode for planned, multi-file changes
- Review and modify generated plans
- Execute plans safely with checkpoints

### What is Agent Mode?

Agent Mode is an autonomous Copilot capability that can:
1. Analyze a complex request across your entire solution
2. Create a step-by-step implementation plan
3. Show which files will be created or modified
4. Execute changes iteratively, fixing its own errors
5. Run builds and terminal commands to verify results

> ⚠️ **VS Code vs. Visual Studio:** VS Code has a dedicated **Plan Mode toggle** and a `/plan` slash command. Visual Studio 2026 does **not** have a separate plan mode or `/plan` command. Instead, **Agent Mode** in Copilot Chat automatically plans multi-step work when you describe a complex task. The behavior is equivalent — you get a plan, review it, and approve execution.

### Invoking Agent Mode in Visual Studio

1. Open **Copilot Chat** (`Ctrl+\, Ctrl+C`)
2. In the chat input area, select **Agent Mode** from the mode dropdown (look for the mode selector at the top of the chat window)
3. Describe your multi-file task — Copilot will automatically generate a plan

**Example — type in Agent Mode chat:**
```
Add a new INVESTIGATE state to EnemyAI that:
- Triggers when enemy hears gunfire but doesn't see player
- Navigates to last known sound location
- Searches area for 10 seconds
- Returns to patrol if player not found
```

> **Tip:** You don't need an `@workspace` prefix in Visual Studio — Agent Mode already has full solution context.

### Demo: Multi-File Feature Addition

**Request (type in Agent Mode chat):**
```
Add radiation zones to the game that:
1. Are defined by Area3D nodes in levels
2. Damage players inside based on zone intensity
3. Show visual warning when player enters
4. Display radiation level on HUD
5. Apply damage over time using SurvivalStats
```

**Agent Mode Output (Visual Studio Copilot Chat):**
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

Copilot will now begin implementing Step 1. Review each proposed change and click **Accept** or **Discard** in the diff preview.
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
- Understand in-IDE Agent Mode vs. GitHub remote Coding Agent
- Monitor agent progress and review output

### Two Forms of Copilot Coding Agent

| Capability | Where It Runs | How to Invoke |
|-----------|---------------|---------------|
| **Agent Mode (in-IDE)** | Inside Visual Studio | Copilot Chat → Agent Mode dropdown |
| **GitHub Coding Agent (remote)** | On GitHub.com (cloud) | Assign an issue to `@copilot` on GitHub |

### Agent Mode in Visual Studio (In-IDE)

Agent Mode is the autonomous Copilot experience inside Visual Studio. It can:
- Read and understand your entire solution
- Make multiple file changes across projects
- Run terminal commands (build, test)
- Iterate on its own errors automatically
- Request your approval before applying changes

**How to invoke:**
1. Open **Copilot Chat** (`Ctrl+\, Ctrl+C`)
2. Select **Agent Mode** from the mode dropdown at the top of the chat window
3. Describe your complete task

**Example (type in Agent Mode chat):**
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

### GitHub Coding Agent (Remote)

The GitHub remote Coding Agent runs in the cloud and creates a pull request with the implementation. This works regardless of your IDE.

**How to invoke:**
1. Create a GitHub Issue describing the task
2. Assign the issue to **@copilot**
3. Copilot spins up a cloud environment, implements the changes, and opens a PR
4. Review the PR as you would any other code contribution

> **When to use which:** Use **Agent Mode (in-IDE)** for iterative, interactive work where you want to guide the process. Use the **GitHub remote agent** for well-defined tasks you can describe in an issue and review asynchronously.

**Agent Mode Progress (Visual Studio):**
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
✓ All checks pass
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

## Session 7: Custom Agents & Agent HQ (4 min)

### Learning Objectives
- Understand custom agent configuration and platform support
- Know the difference between custom agents, Copilot Extensions, and prompt files
- Access Agent HQ on GitHub.com

### ⚠️ Custom Agents: VS Code Only (as of January 2026)

Custom agent files (`.github/agents/*.agent.md`) and the `@agent-name` invocation syntax are **VS Code features only**. Visual Studio 2026 does **not** support custom agent files or the `@` agent routing syntax.

| Feature | VS Code | Visual Studio 2026 |
|---------|---------|-------------------|
| `.github/agents/*.agent.md` files | ✅ Supported | ❌ Not supported |
| `@agent-name` in chat | ✅ Supported | ❌ Not supported |
| Copilot Extensions (GitHub Marketplace) | ✅ Supported | ✅ Supported |
| Prompt files (`.github/prompts/`) | ✅ Supported | ✅ Supported |
| Agent HQ (GitHub.com web interface) | ✅ Via browser | ✅ Via browser |

### Visual Studio Alternatives to Custom Agents

Since Visual Studio doesn't support `.github/agents/` files, use these equivalent approaches:

**1. Prompt Files as Agent Replacements**

Instead of a `@combat-systems` agent, create a prompt file that includes the same system prompt and context:

```markdown
---
mode: 'agent'
description: 'Combat systems specialist prompt for weapon and damage work'
---

You are the combat systems specialist for Urban Survivor.

**Your expertise:** Weapon firing, reload, ammunition, DamageSystem, hit detection, hit zones, and multipliers.

**Always reference:**
- #file:src/combat/weapon.cpp
- #file:src/combat/damage_system.cpp
- #file:docs/SPEC.md (Section 5: Combat)
- #file:docs/CODING_STANDARDS.md

**Response rules:**
- Cite line numbers for all suggestions
- Include test cases for every change
- Follow CODING_STANDARDS.md strictly

Now complete the following task:
{{TASK_DESCRIPTION}}
```

**2. Instruction Files for Persistent Rules**

Rules that should always apply (like coding standards) belong in instruction files, not agents:
- `.github/instructions/cpp-gdextension.instructions.md` → applies to all `.cpp`/`.hpp` files
- These are automatically included — no need to reference an agent

**3. Copilot Extensions (GitHub Marketplace)**

For third-party or organization-built agents, use **Copilot Extensions** which work in both VS Code and Visual Studio:
- Install from the GitHub Marketplace
- Invoke via `@extension-name` in Copilot Chat
- These are different from the `.github/agents/` local agent files

### Agent HQ on GitHub.com

Agent HQ is a **web-based** management interface on GitHub.com for organizing Copilot Extensions and agent permissions. It is not an IDE feature.

**To access:** Navigate to **github.com** → **Settings** → **Copilot** → **Extensions & Agents**

### Urban Survivor: Recommended Configuration for Visual Studio

Since custom agent files don't work in Visual Studio, here is how the Urban Survivor project maps its agent roster to Visual Studio-compatible features:

| Original Agent (VS Code) | Visual Studio Alternative | Location |
|--------------------------|--------------------------|----------|
| `@godot-cpp-expert` | Instruction file + prompt file | `.github/instructions/cpp-gdextension.instructions.md` |
| `@combat-systems` | Prompt file (agent mode) | `.github/prompts/combat-specialist.prompt.md` |
| `@enemy-ai` | Prompt file (agent mode) | `.github/prompts/ai-specialist.prompt.md` |
| `@gdscript-ui` | Instruction file + prompt file | `.github/instructions/gdscript.instructions.md` |
| `@debug-helper` | Copilot Chat (agent mode) | Direct chat — describe the error |
| `@code-reviewer` | Copilot Chat + Inline Chat | Select code → Alt+/ → "Review this" |
| `@doc-maintainer` | Prompt file | `.github/prompts/update-docs.prompt.md` |
| `@sprint-planner` | Prompt file | `.github/prompts/plan-sprint.prompt.md` |

> **✅ These prompt files are included in the repo.** The following prompt files were created specifically as Visual Studio alternatives to the VS Code-only custom agents:
> - `.github/prompts/combat-specialist.prompt.md` — replaces `@combat-systems` agent
> - `.github/prompts/ai-specialist.prompt.md` — replaces `@enemy-ai` agent
> - `.github/prompts/update-docs.prompt.md` — replaces `@doc-maintainer` agent
> - `.github/prompts/plan-sprint.prompt.md` — replaces `@sprint-planner` agent (already existed)
>
> To use them: open **Copilot Chat** → click 📎 **Attach Context** → select **Prompt Files** → choose the prompt → fill in `{{TASK_DESCRIPTION}}` and send.

---

## Session 8: Architecture & Tech Stack Generation (4 min)

### Learning Objectives
- Generate architecture documentation using Copilot Chat
- Create tech stack diagrams
- Document system interactions

### Architecture Generation

Open **Copilot Chat** (`Ctrl+\, Ctrl+C`) and type:

**Prompt:**
```
Generate an architecture diagram for Urban Survivor's combat system.
Include:
- Class relationships
- Signal flow
- Data dependencies
- Integration points with other systems
```

> **Tip:** Copilot Chat in Visual Studio has full solution context. You can also attach specific files with `#file:src/combat/weapon.cpp` to focus the analysis.

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
Document the complete tech stack for Urban Survivor
with version numbers and purpose of each component.
```

---

## Workshop Summary

### Key Takeaways

1. **Chain-of-Thought** breaks complex problems into solvable steps — type structured reasoning in Copilot Chat
2. **Instruction Files** ensure consistent AI behavior per file type — supported in Visual Studio 2022 17.13+ and 2026
3. **Prompt Files** create reusable, team-shared workflows — invoke via 📎 Attach Context or `#` in Copilot Chat
4. **Code Review** via Copilot Chat and Inline Chat (`Alt+/`) catches bugs and style issues
5. **Agent Mode** in Copilot Chat plans and executes multi-file changes autonomously
6. **Coding Agent** works both in-IDE (Agent Mode) and remotely (assign issues to `@copilot` on GitHub)
7. **Custom agents** (`.github/agents/`) are VS Code-only — use prompt files and instruction files as the Visual Studio equivalent
8. **Architecture generation** via Copilot Chat documents system design from your solution context

### Visual Studio 2026 Feature Availability Summary

| Feature | Available in VS 2026? | Notes |
|---------|----------------------|-------|
| Chain-of-Thought prompting | ✅ Yes | Use Copilot Chat |
| Instruction files | ✅ Yes | `.github/instructions/*.md` |
| Prompt files | ✅ Yes | `.github/prompts/*.prompt.md` |
| Code review (in-IDE) | ✅ Yes | Via Copilot Chat / Inline Chat |
| Code review (PR) | ✅ Yes | Via GitHub.com |
| Agent Mode (plan + execute) | ✅ Yes | Mode dropdown in Copilot Chat |
| GitHub remote Coding Agent | ✅ Yes | Assign issues to `@copilot` |
| Custom agent files | ❌ No | VS Code only — use prompt files instead |
| `@workspace` / `@agent-name` | ❌ No | VS has automatic solution context |
| `/plan` slash command | ❌ No | Agent Mode plans automatically |

### Homework Before Expert Workshop

1. Create an instruction file for a new file type in your project (e.g., shaders, config files)
2. Write 3 prompt files for common tasks (use `mode: 'agent'` in front matter)
3. Use Agent Mode in Copilot Chat for a multi-file refactoring
4. Try the GitHub remote Coding Agent — create an issue and assign it to `@copilot`

---

## Resources

- [Copilot Customization Docs](https://docs.github.com/copilot/customizing-copilot)
- [Prompt Engineering Best Practices](https://docs.github.com/copilot/using-github-copilot/best-practices)
- [Copilot in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/copilot-chat-context)
- [GitHub Copilot Coding Agent](https://docs.github.com/copilot/using-github-copilot/using-copilot-coding-agent)
- [Urban Survivor Prompts](../../.github/prompts/)
- [Urban Survivor Instructions](../../.github/instructions/)

---

*Next Workshop: [Expert - MCP Servers, Enterprise, and Certification](04-expert-workshop.md)*
