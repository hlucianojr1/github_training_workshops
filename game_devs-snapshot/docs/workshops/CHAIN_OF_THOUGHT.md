# Chain of Thought (CoT) - Explanation and Examples

**Date**: February 10, 2026  
**Context**: Urban Survivor - Production Plan, Epic 1.5: Level 1 Population  
**Engine**: Godot 4.3+ with C++ GDExtension

---

## What is Chain of Thought?

Chain of Thought (CoT) is a prompting technique where you explicitly show the reasoning steps that lead to a solution, rather than just providing the final answer. It helps break down complex problems into manageable pieces and makes the thinking process transparent.

**Think of it like showing your work in math class** - you don't just write "42", you show:
1. The equation: `2x + 6 = 90`
2. Subtract 6: `2x = 84`
3. Divide by 2: `x = 42`

---

## Examples Based on Epic 1.5: Level 1 Population

> **Epic 1.5** from `docs/PRODUCTION_PLAN.md` covers populating Level 1 ("The Heights") with enemies, scavenge points, a level exit trigger, and the player spawn. The level spans Broadway from 181st St to 175th St through three zones: *The Traffic Jam*, *The Checkpoint*, and *The Commercial Strip*.

### **Example 1: Without Chain of Thought (Direct Answer)**

> **📝 Developer Prompt (Poor):**
> ```
> Add 5 enemies to Zone 2 of Level 1.
> ```

**Task 1.5.1** — Place 5 enemies in Zone 2

❌ **Poor approach:**
> "Add 5 EnemyAI nodes to the Zone 2 area of the level."

**Problems with this approach:**
- No reasoning about enemy mix (3 Scavengers + 2 Raiders per the acceptance criteria)
- Skips patrol route design — enemies just stand there
- Ignores the MG nest manned by a Raider (key level design requirement)
- Doesn't address cover positions or line-of-sight sightlines
- No consideration for player difficulty curve from Zone 1 tutorial area

---

### **Example 2: With Chain of Thought (Reasoning Shown)**

> **📝 Developer Prompt (Better):**
> ```
> I need to implement Task 1.5.1 from docs/PRODUCTION_PLAN.md: Place 5 enemies in Zone 2 ("The Checkpoint").
> 
> Before implementing, please:
> 1. Review the zone layout in docs/LEVEL_1_DESIGN.md
> 2. Check the acceptance criteria (3 Scavengers + 2 Raiders, patrol routes, MG nest)
> 3. Reference enemy stats from docs/SPEC.md
> 4. Design placement considering cover positions, sightlines, and the player's approach from Zone 1
> 5. Balance difficulty so players learn flanking before Zone 3
> 
> Show your reasoning for each enemy's position, patrol route, and behavior settings.
> Provide the scene tree structure and property values for each EnemyAI node.
> ```

✅ **Better approach:**

**Task 1.5.1** — Place 5 enemies in Zone 2 ("The Checkpoint")

#### **Step 1: Understand the Zone**
1. Zone 2 is "The Checkpoint" — a military blockade with sandbags, barbed wire, and a destroyed M48 Patton tank
2. The `docs/LEVEL_1_DESIGN.md` says: *"Flanking required. The direct path is covered by a heavy machine gun nest (manned by AI)."*
3. Cover objects: concrete barriers, sandbag walls, the tank itself
4. The player arrives from Zone 1 (tutorial area) with basic skills — this is their first real combat encounter

#### **Step 2: Analyze the Acceptance Criteria**
From `docs/PRODUCTION_PLAN.md` Task 1.5.1:
- 3 Scavengers, 2 Raiders
- Patrol routes defined
- MG nest manned by Raider

From `docs/SPEC.md` enemy types:
| Type | Health | Damage | Behavior |
|------|--------|--------|----------|
| Scavenger | 75 HP | 15 dmg | Flees when hurt, prefers looting |
| Raider | 100 HP | 20 dmg | Aggressive, uses cover |

#### **Step 3: Design Enemy Placement**
1. **Raider #1 (MG Nest)**: Static position behind sandbags facing north (toward player approach). Does NOT patrol — anchored to the machine gun. This is the "gatekeeper" that forces the player to flank.
2. **Raider #2 (Tank)**: Patrols around the M48 tank. Uses the tank as cover. Calls for backup (signals other enemies via `AIPerception` hearing range).
3. **Scavenger #1 (East flank)**: Patrols east side of the blockade. Flee threshold 25% HP. Drops ammo loot.
4. **Scavenger #2 (West flank)**: Patrols behind the western sandbag line. Investigates sounds. Flees early.
5. **Scavenger #3 (Rear)**: Positioned behind the blockade scavenging. Only activates when alerted by gunfire within 50m (as per `docs/SPEC.md` stealth mechanics).

#### **Step 4: Define Patrol Routes**
```
Zone 2 Layout (top-down, player approaches from North):

     N (Player comes from Zone 1)
     |
  [Building]  ~~~road~~~  [Building]
     |                        |
     |   Scav#1 patrol -->    |
     |        ↓               |
     |   [Sandbags]──[MG Nest - Raider#1]
     |        |               |
     |   [Tank - Raider#2]    |
     |     ↕ patrol           |
     |   [Barriers]           |
     |        |               |
     |   <-- Scav#2 patrol    |
     |                        |
     |     Scav#3 (rear)      |
     |                        |
     S (toward Zone 3)
```

#### **Step 5: Implementation in Scene**
```
# Zone_2_Enemies (Node3D group in test_scene.tscn)
├── Raider_MGNest (EnemyAI)
│   ├── AIPerception
│   ├── NavigationAgent3D
│   └── Weapon (configured as mounted MG or rifle)
│   Properties:
│     ai_state = IDLE (activates on player detection)
│     max_health = 100
│     attack_damage = 20
│     flee_health_threshold = 0.0  # Never flees - defends position
│
├── Raider_Tank (EnemyAI)
│   ├── AIPerception
│   ├── NavigationAgent3D
│   └── Weapon (Shotgun — per SPEC: Raider uses cover, rushes)
│   Properties:
│     patrol_points = [tank_east, tank_west, tank_south]
│     max_health = 100
│     cover_health_threshold = 0.5
│
├── Scavenger_East (EnemyAI)
│   ├── AIPerception
│   ├── NavigationAgent3D
│   └── Weapon (M1911 Pistol)
│   Properties:
│     patrol_points = [east_1, east_2, east_3]
│     max_health = 75
│     flee_health_threshold = 0.25
│     loot_table = ["ammo_45acp"]
│
├── Scavenger_West (EnemyAI)
│   └── ... (similar, west patrol)
│
└── Scavenger_Rear (EnemyAI)
    Properties:
      ai_active = false  # Activates when gunfire heard
      max_health = 75
      flee_health_threshold = 0.25
      loot_table = ["bandage"]
```

#### **Step 6: Verify Against Acceptance Criteria**
- [x] 3 Scavengers, 2 Raiders
- [x] Patrol routes defined (East, West, Tank-orbit)
- [x] MG nest manned by Raider (Raider#1, static position)
- [x] Scavengers have loot drops
- [x] Difficulty curve: forced flanking teaches player to use cover before Zone 3

---

### **Example 3: Chain of Thought for Scavenge Point Placement (Task 1.5.3)**

> **📝 Developer Prompt:**
> ```
> Implement Task 1.5.3: Add 10 scavenge points across Level 1's three zones.
> 
> Requirements from PRODUCTION_PLAN.md:
> - 5 in Zone 1 (tutorial loot)
> - 3 in Zone 2 (ammo caches)
> - 2 in Zone 3 (medical)
> 
> Please:
> 1. First review the ScavengePoint class in src/world/ and item categories in docs/SPEC.md
> 2. Design placement by zone purpose (tutorial → combat → recovery)
> 3. For each scavenge point, specify: location, item type, quantity, and the design rationale
> 4. Calculate total resources and verify the player can survive 8 enemy encounters
> 5. Ensure loot placement is thematically consistent (e.g., ammo at military checkpoint, medicine at drugstore)
> 
> Show the resource balance math to prove the level is beatable on Normal difficulty.
> ```

**Task**: Add 10 scavenge points across all 3 zones

#### **Step 1: Understand the Scavenging System**
From `src/world/level_manager.hpp`:
- `LevelManager` tracks `items_collected` count
- `item_collected()` method increments the counter
- The `ScavengePoint` class (in `src/world/`) represents a lootable container

From `docs/SPEC.md` Item Categories:
- Medical: Bandage (heals 25 HP), Medkit (heals 75 HP)
- Ammo: .45 ACP (stack 30), 12ga (stack 20)
- Food: Canned food, Water

#### **Step 2: Analyze Acceptance Criteria**
From Task 1.5.3:
- 5 in Zone 1 (tutorial loot) — teach player to loot, generous resources
- 3 in Zone 2 (ammo caches) — prepare for and reward combat
- 2 in Zone 3 (medical) — heal up after checkpoint fight

#### **Step 3: Design by Zone Purpose**

**Zone 1 — "The Traffic Jam" (Tutorial, 5 scavenge points)**

The player has just started. These points teach the mechanic and provide a loadout.

| # | Location | Item | Rationale |
|---|----------|------|-----------|
| 1 | Open car trunk (first car) | Bandage x2 | Visible, teaches "press E to loot" |
| 2 | Overturned suitcase | .45 ACP ammo x14 | Half a magazine — teaches ammo is scarce |
| 3 | Bus interior | Canned Food x1 | Optional exploration reward |
| 4 | Car glove box | Bandage x1 | Reinforces looting cars |
| 5 | Under bus bench | M1911 Pistol | Player's starting weapon pickup |

**Zone 2 — "The Checkpoint" (Combat ammo, 3 scavenge points)**

Player is about to fight or just fought 5 enemies. Ammo resupply is critical.

| # | Location | Item | Rationale |
|---|----------|------|-----------|
| 6 | Sandbag bunker (east) | .45 ACP ammo x14 | Reward for flanking east |
| 7 | Military crate near tank | .45 ACP ammo x14 + Bandage x1 | High-risk/high-reward (near Raider patrol) |
| 8 | Guard shack | 12ga Shotgun Shells x6 | Tease shotgun ammo before player finds one |

**Zone 3 — "The Commercial Strip" (Medical, 2 scavenge points)**

Post-combat healing. Player likely took damage at the checkpoint.

| # | Location | Item | Rationale |
|---|----------|------|-----------|
| 9 | Rexall Drugs counter | Medkit x1 | Thematic (drugstore → medicine) |
| 10 | Diner kitchen | Bandage x2 + Canned Food x1 | Exploration reward |

#### **Step 4: Verify Resource Balance**
**Total loot from all 10 scavenge points:**
- Bandages: 6 (heals 150 HP total over 18 seconds)
- Medkit: 1 (heals 75 HP instantly)
- .45 ACP Ammo: 42 rounds (6 full M1911 magazines)
- 12ga Shells: 6 rounds
- Canned Food: 2
- M1911 Pistol: 1

**Is this enough to survive 8 enemies (5 in Zone 2 + 3 in Zone 3)?**
- Player starts with 100 HP
- Enemies deal 15-20 damage per hit
- 5-6 hits kill the player without healing
- 225 HP in healing available (generous for Normal difficulty)
- 42 pistol rounds vs 8 enemies × ~3-4 hits to kill each = 24-32 rounds needed
- **Margin**: ~10 spare rounds, good — rewards accuracy without punishing misses

#### **Step 5: Implementation Pattern**
```cpp
// Each ScavengePoint in the scene tree:
// ScavengePoint (Node3D)
//   ├── InteractionArea (Area3D) — detects player proximity
//   ├── MeshInstance3D — visual (car trunk, crate, etc.)
//   └── CollisionShape3D

// Properties set in the Godot editor per-instance:
// scavenge_point.item_id = "bandage"
// scavenge_point.item_count = 2
// scavenge_point.interaction_prompt = "Search trunk"
```

#### **Step 6: Success Criteria**
- [x] 5 Zone 1 points (tutorial loot)
- [x] 3 Zone 2 points (ammo caches)
- [x] 2 Zone 3 points (medical supplies)
- [x] Resource balance supports completing the level on Normal difficulty
- [x] Loot placement encourages exploration (not all on critical path)
- [x] Thematic consistency (drugs at the drugstore, ammo at military checkpoint)

---

### **Example 4: Chain of Thought for Level Exit Trigger (Task 1.5.4)**

> **📝 Developer Prompt:**
> ```
> Implement Task 1.5.4: Create a level exit trigger at the subway entrance for Level 1.
> 
> Per PRODUCTION_PLAN.md, it should:
> - Use an Area3D at the subway entrance
> - Trigger the level_completed signal
> - Load the victory screen
> 
> Before implementing:
> 1. Research how LevelManager tracks completion (check src/world/level_manager.hpp)
> 2. Determine what signals need to fire and how they connect to GameManager
> 3. Review docs/LEVEL_1_DESIGN.md for the exact exit location
> 4. Evaluate options: GDScript vs C++ class vs extending LevelManager
> 5. Choose the approach that follows docs/CODING_STANDARDS.md patterns
> 
> Provide the full implementation including:
> - C++ class files (if applicable)
> - register_types.cpp registration
> - CMakeLists.txt updates
> - Scene tree structure with properties
> - Validation/test plan for edge cases
> ```

**Task**: Implement level exit trigger at subway entrance

#### **Step 1: Define Research Questions**
- How does `LevelManager` currently track completion?
- What signal needs to fire?
- Where exactly does the player exit?
- Does Zone 3 have a clear endpoint in the level design?

#### **Step 2: Analyze Existing Code**
From `src/world/level_manager.hpp`:
- `complete_level()` method exists
- Signals declared: `level_completed(float time, int items)`
- Tracks `enemies_remaining` and `items_collected`
- `level_exit_point` property exists but needs to be set

From `docs/LEVEL_1_DESIGN.md`:
> *"Objective: Reach the subway entrance at 168th St to transition to the next level (or a safe house)."*

From `docs/PRODUCTION_PLAN.md` Task 1.5.4:
- Area3D at subway entrance
- Triggers `level_completed` signal
- Loads victory screen

#### **Step 3: Evaluate Implementation Options**

| Option | Approach | Pros | Cons |
|--------|----------|------|------|
| **A** | Pure GDScript Area3D | Fast to prototype, easy to tweak | Inconsistent with C++ architecture pattern |
| **B** | C++ class `LevelExitTrigger` | Matches project patterns, reusable for all 6 levels | Build step required, more upfront work |
| **C** | Extend LevelManager to detect Area3D | Minimal new code, leverages existing class | Couples level layout to C++ class |

**Decision**: **Option B** — Create a `LevelExitTrigger` C++ class

**Rationale:**
- `docs/CODING_STANDARDS.md` says C++ for gameplay systems, GDScript for UI
- We need this trigger for ALL 6 levels — reusability matters
- Clean separation: LevelExitTrigger detects entry, LevelManager handles flow

#### **Step 4: Design the Solution**

```
LevelExitTrigger (Area3D)
├── body_entered(Node* body) → check if player
├── Properties:
│   ├── required_enemies_cleared: int = 0  (optional: must clear enemies first)
│   ├── exit_prompt: String = "Enter Subway"
│   └── transition_delay: float = 1.0  (dramatic pause)
├── Signals:
│   └── player_reached_exit()
└── Behavior:
    1. Player enters Area3D
    2. Check prerequisites (enemies cleared, etc.)
    3. Show "Enter Subway" prompt via HUD
    4. Player presses E to confirm
    5. Emit player_reached_exit()
    6. LevelManager.complete_level() called
    7. GameManager transitions to victory/next level
```

#### **Step 5: Implementation Walkthrough**

**New files needed:**
```
src/world/level_exit_trigger.hpp
src/world/level_exit_trigger.cpp
```

**Registration in `src/register_types.cpp`:**
```cpp
#include "world/level_exit_trigger.hpp"
// ...
GDREGISTER_CLASS(LevelExitTrigger);
```

**CMakeLists.txt addition:**
```cmake
set(SOURCES
    # ... existing ...
    src/world/level_exit_trigger.cpp
)
```

**Core Implementation:**
```cpp
void LevelExitTrigger::_on_body_entered(Node* body) {
    // Step 1: Is it the player?
    PlayerController* player = Object::cast_to<PlayerController>(body);
    if (!player) return;

    // Step 2: Are prerequisites met?
    if (required_enemies_cleared > 0) {
        LevelManager* lm = Object::cast_to<LevelManager>(
            get_tree()->get_current_scene()->find_child("LevelManager"));
        if (lm && lm->get_enemies_remaining() > required_enemies_cleared) {
            // Show "Clear the area first" on HUD
            emit_signal("prerequisites_not_met");
            return;
        }
    }

    // Step 3: Show interaction prompt
    player_in_zone = true;
    emit_signal("exit_available", exit_prompt);
}

void LevelExitTrigger::_input(const Ref<InputEvent>& event) {
    if (!player_in_zone) return;
    if (event->is_action_pressed("interact")) {  // "E" key
        emit_signal("player_reached_exit");
    }
}
```

#### **Step 6: Scene Integration**
```
# In test_scene.tscn, at the south end of Zone 3:
SubwayEntrance (Node3D)
├── LevelExitTrigger (Area3D)
│   └── CollisionShape3D (BoxShape3D, ~3m wide × 3m tall × 1m deep)
├── SubwayStairs_Mesh (MeshInstance3D — or CSG placeholder)
└── SubwaySign_Mesh (MeshInstance3D — "168th St" sign)

# LevelExitTrigger properties:
#   required_enemies_cleared = 0  (not required for Level 1)
#   exit_prompt = "Enter 168th St Subway"
#   transition_delay = 2.0
```

#### **Step 7: Validation Plan**
1. Walk player into the Area3D → verify `exit_available` signal fires
2. Press E → verify `player_reached_exit` signal fires
3. Verify `LevelManager.complete_level()` is called → `level_completed` signal emits
4. Confirm GameManager receives the signal and transitions state
5. Test edge case: walk in and back out → prompt disappears
6. Test edge case: die inside the trigger zone → no completion

---

### **Example 5: Chain of Thought for Player Spawn Design (Task 1.5.5)**

> **📝 Developer Prompt:**
> ```
> Implement Task 1.5.5: Add player spawn point and link the player scene to Level 1.
> 
> Context:
> - PlayerController exists in src/player/player_controller.hpp
> - ThirdPersonCamera exists in src/camera/third_person_camera.hpp
> - LevelManager has spawn point properties
> 
> Please:
> 1. First check if player.tscn prefab exists (Task 1.2.1 dependency)
> 2. Determine the spawn flow: GameManager → LevelManager → Player instantiation
> 3. Evaluate spawn approaches: pre-placed vs runtime instantiation vs teleport-to-marker
> 4. Design camera initialization so the player faces south toward gameplay (not at the GWB)
> 5. Ensure the first scavenge point is visible from spawn to teach looting
> 
> Provide:
> - The chosen approach with rationale
> - Scene tree layout with SpawnPoints group
> - Camera initialization code
> - Success criteria checklist (spawn position, camera angle, HUD state, etc.)
> ```

**Task**: Add player spawn + link player scene

#### **Step 1: Analyze Current State**
From the codebase:
- `PlayerController` (CharacterBody3D) exists in `src/player/player_controller.hpp`
- `ThirdPersonCamera` exists in `src/camera/third_person_camera.hpp`
- `Inventory` and `SurvivalStats` exist as child node classes
- Task 1.2.1 requires a `player.tscn` prefab (may or may not exist yet)
- `LevelManager` has `set_player_spawn_point(Vector3)` and `get_player_spawn_point()`

**Key question**: Does `player.tscn` exist yet?

#### **Step 2: Determine Dependencies**
```
Task 1.5.5 depends on:
├── Task 1.2.1 (player.tscn prefab)      → Must exist first
├── ThirdPersonCamera attached            → Camera must initialize at spawn
├── LevelManager spawn point              → spawn position must be set
└── Zone 1 geometry                       → player needs ground to stand on
```

If `player.tscn` doesn't exist, we must create it as part of or before 1.5.5.

#### **Step 3: Design Spawn Flow**

```
Game Start Sequence:
1. GameManager transitions to PLAYING state
2. LevelManager._ready() reads player_spawn_point
3. LevelManager instantiates player.tscn (or finds existing player node)
4. Player.global_position = player_spawn_point
5. ThirdPersonCamera initializes (looks south down Broadway)
6. HUD connects to PlayerController signals
7. Input enabled → player can move
```

#### **Step 4: Choose Spawn Approach**

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| **A** | Pre-placed in scene | Simple, visible in editor | Can't change spawn per-checkpoint |
| **B** | Marker3D + runtime instantiation | Flexible, reusable | More code, harder to preview |
| **C** | Pre-placed + teleport to Marker3D | Best of both, visible in editor AND relocatable | Slight initial "pop" |

**Decision**: **Option C** — Pre-place `player.tscn` in the scene, but teleport to a `Marker3D` spawn point on `_ready()`

**Rationale:**
- Editor visibility: designers can see the player in the scene tree
- Flexibility: move the Marker3D to change spawn without touching the player node
- Checkpoint support: add multiple Marker3D nodes for future save/load

#### **Step 5: Scene Layout**
```
# test_scene.tscn additions:
Level1_TheHeights
├── LevelManager
│   Properties:
│     level_name = "The Heights"
│     player_spawn_point = Vector3(0, 1, 180)  # North end of Zone 1
│
├── SpawnPoints (Node3D)
│   ├── PlayerSpawn_Start (Marker3D)
│   │   Position: (0, 1, 180)    # Zone 1 north — facing south
│   │   Rotation: (0, 180, 0)    # Looking south down Broadway
│   └── PlayerSpawn_Checkpoint (Marker3D)  # Future: mid-level save
│       Position: (0, 1, 90)     # Zone 2 entrance
│
├── Player (player.tscn instance)
│   ├── PlayerController (CharacterBody3D)
│   ├── ThirdPersonCamera (Camera3D)
│   ├── Inventory (Node)
│   ├── SurvivalStats (Node)
│   └── WeaponMount (Node3D)
│
└── ... (zones, enemies, etc.)
```

#### **Step 6: Camera Initialization**
**Problem**: Where should the camera face at spawn?

- Player spawns at the NORTH end of Broadway, facing SOUTH
- The George Washington Bridge is behind the player (a visual landmark but not gameplay direction)
- The first scavenge point (open car trunk) should be visible immediately
- Camera distance: default orbit distance from `ThirdPersonCamera` (3-5m back)

```cpp
// In LevelManager or a spawn script:
void on_player_spawned() {
    // Teleport player to spawn marker
    player->set_global_position(spawn_marker->get_global_position());
    player->set_global_rotation(spawn_marker->get_global_rotation());

    // Orient camera to face south (down Broadway)
    ThirdPersonCamera* cam = player->get_node<ThirdPersonCamera>("ThirdPersonCamera");
    cam->set_yaw(Math::deg_to_rad(180.0f));  // Face south
    cam->set_pitch(Math::deg_to_rad(-10.0f)); // Slight downward angle
}
```

#### **Step 7: Success Criteria**
- [x] Player spawns at Zone 1 start (north end of Broadway)
- [x] Camera initialized correctly (facing south toward gameplay)
- [x] First scavenge point visible from spawn (teaches looting)
- [x] No enemies visible from spawn (Zone 1 is tutorial/safe)
- [x] Player can immediately move (WASD) after spawn
- [x] HUD displays initial health (100), stamina (100), ammo (0 — no weapon yet)

---

## Why Chain of Thought Matters for Epic 1.5

### **Without Chain of Thought:**
- ❌ Place enemies randomly without considering sightlines or flanking routes
- ❌ Put loot wherever there's space without balancing resource economy
- ❌ Create an exit trigger that doesn't connect to LevelManager signals
- ❌ Spawn the player facing a wall
- ❌ No verification that the level is actually beatable

### **With Chain of Thought:**
1. ✅ Analyze zone purpose (tutorial → combat → recovery)
2. ✅ Design enemy placement around level geometry and cover
3. ✅ Balance resources against enemy threat (enough ammo? enough healing?)
4. ✅ Wire systems together through signals (exit → LevelManager → GameManager)
5. ✅ Consider the player's first-second experience (camera angle, first visible objective)
6. ✅ Verify each task against its acceptance criteria

### **Result:**
- **Coherent level design** — enemies, loot, and pacing work together
- **Testable implementation** — each task has specific success criteria
- **Maintainable code** — follows existing C++/signal architecture patterns
- **Balanced difficulty** — resource math validates the player can survive
- **Reusable systems** — LevelExitTrigger works for all 6 planned levels

---

## How to Write Prompts That Trigger Chain of Thought

### The Key Principles

| Principle | Poor Prompt | Better Prompt |
|-----------|-------------|---------------|
| **Be specific** | "Add enemies" | "Add 5 enemies: 3 Scavengers + 2 Raiders per Task 1.5.1" |
| **Reference docs** | "Make it work" | "Review docs/SPEC.md for enemy stats, docs/LEVEL_1_DESIGN.md for zone layout" |
| **Ask for reasoning** | (silent) | "Show your reasoning for each decision" |
| **Request verification** | (silent) | "Verify against the acceptance criteria in PRODUCTION_PLAN.md" |
| **Include constraints** | (silent) | "Follow docs/CODING_STANDARDS.md patterns (C++ for gameplay, GDScript for UI)" |

### Prompt Structure Template

```markdown
Implement [Task ID]: [Brief description].

Context from [doc file]:
- [Key requirement 1]
- [Key requirement 2]
- [Key requirement 3]

Before implementing, please:
1. Review [relevant files/systems to understand]
2. Check [acceptance criteria location]
3. Reference [spec files for data/stats]
4. Design [what needs to be designed, considering X, Y, Z]
5. Evaluate options and choose based on [coding standards/architecture patterns]

Show your reasoning for [specific decisions you want explained].

Provide:
- [Deliverable 1: e.g., scene tree structure]
- [Deliverable 2: e.g., C++ implementation]
- [Deliverable 3: e.g., verification checklist]
```

### Anti-Patterns to Avoid

| ❌ Don't | ✅ Do Instead |
|----------|--------------|
| "Add some enemies" | "Add 5 enemies matching the Task 1.5.1 composition" |
| "Make it balanced" | "Calculate resource math: player needs X ammo to defeat Y enemies" |
| "Put loot around" | "Place loot thematically (drugs at drugstore, ammo at checkpoint)" |
| "Just make it work" | "Follow the signal flow: Trigger → LevelManager → GameManager" |
| "Figure it out" | "First check if player.tscn exists (dependency on Task 1.2.1)" |

---

## Chain of Thought Template for Any Game Development Problem

```markdown
### Problem: [Describe the task from PRODUCTION_PLAN.md]

#### Step 1: Understand Current State
- What exists in the codebase already? (check src/, game/scenes/)
- What does SPEC.md say about this feature?
- What does LEVEL_1_DESIGN.md say about the environment?
- What are the acceptance criteria from the production plan?

#### Step 2: Identify Dependencies
- What tasks must be completed first?
- What C++ classes are needed?
- What scene nodes need to exist?
- What signals connect this to other systems?

#### Step 3: Design the Solution
- Option A: [Approach + pros/cons]
- Option B: [Approach + pros/cons]
- Decision: [Chosen option] because [rationale from CODING_STANDARDS.md]

#### Step 4: Implementation Plan
1. [File to create/modify]
2. [C++ class or scene node changes]
3. [Registration in register_types.cpp]
4. [CMakeLists.txt updates]
5. [Scene tree additions]

#### Step 5: Verify Against Acceptance Criteria
- [ ] Criterion 1 from PRODUCTION_PLAN.md
- [ ] Criterion 2
- [ ] Criterion 3

#### Step 6: Test Plan
- Build: cmake --build build --config Debug
- Open Godot: game/project.godot
- Run scene and verify [specific behavior]
- Edge cases: [what could go wrong]
```

---

## Key Takeaway

**Chain of Thought = Show your reasoning work**, just like in math class.

For Epic 1.5, this means:
1. **Why** does Zone 2 need exactly 3 Scavengers and 2 Raiders?
2. **Where** should enemies patrol relative to cover geometry?
3. **How much** loot does the player need to survive 8 enemy encounters?
4. **How** does the exit trigger connect to `LevelManager` → `GameManager`?
5. **What** should the player see in their first 3 seconds after spawn?

This structured thinking prevents rushing into solutions that don't fit the game design and ensures every placed enemy, loot point, and trigger serves the player experience.

---

## Additional Resources

- **Production Plan**: `docs/PRODUCTION_PLAN.md` — Full acceptance criteria for Epic 1.5
- **Level Design**: `docs/LEVEL_1_DESIGN.md` — Zone layouts, asset requirements, color palette
- **Game Spec**: `docs/SPEC.md` — Weapon stats, enemy types, damage calculations
- **Architecture**: `docs/ARCHITECTURE.md` — System hierarchy and signal flow
- **Memory**: `docs/MEMORY.md` — Past decisions (singleton patterns, scene composition)
- **Weapon System**: `src/combat/weapon.hpp` — Weapon stats, fire/reload implementation
- **Enemy AI**: `src/ai/enemy_ai.hpp` — FSM states, cover/flee thresholds
- **Level Manager**: `src/world/level_manager.hpp` — Level completion tracking

---

**Author**: GitHub Copilot  
**Context**: Urban Survivor - Production Plan, Milestone 1 (Vertical Slice), Epic 1.5  
**Last Updated**: February 10, 2026
