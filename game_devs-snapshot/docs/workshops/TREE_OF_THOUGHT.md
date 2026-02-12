# Tree of Thought (ToT) - Explanation and Examples

**Date**: February 10, 2026  
**Context**: Urban Survivor - Production Plan, Epic 1.5: Level 1 Population  
**Engine**: Godot 4.3+ with C++ GDExtension

---

## What is Tree of Thought?

Tree of Thought (ToT) is a prompting technique where you explore **multiple reasoning branches in parallel**, evaluate each branch, prune the weak ones, and converge on the best solution. Unlike Chain of Thought (which follows a single linear path), ToT builds a **branching decision tree** — testing several ideas simultaneously before committing.

**Think of it like a chess player** — you don't just calculate one move ahead. You consider several candidate moves, mentally play out each one a few turns deep, then pick the line that leads to the best position:

```
          [Current Position]
         /        |         \
     Move A    Move B     Move C
      /   \      |         /   \
   A1     A2    B1       C1    C2
   ✗      ✓     ✓        ✗     ✓
         Best → B1 (strongest after evaluation)
```

### CoT vs ToT at a Glance

| | Chain of Thought | Tree of Thought |
|---|---|---|
| **Structure** | Linear (Step 1 → 2 → 3) | Branching (explore → evaluate → prune) |
| **When to use** | Problem has one clear path | Problem has competing valid approaches |
| **Risk** | May lock into a suboptimal path early | More upfront work, but avoids dead ends |
| **Analogy** | Walking a trail | Scouting multiple trails, choosing the best |

---

## How to Use These Prompts

Each example below includes a **copy-paste prompt** in a blockquote. These are the exact words you'd type into GitHub Copilot Chat (or any LLM) to trigger Tree of Thought reasoning.

**Key patterns in the prompts:**
- **"Generate 3 candidate approaches"** — forces branching instead of a single answer
- **"Evaluate each against these criteria"** — forces structured comparison
- **"Consider what happens when we scale to..."** — forces lookahead
- **"Prune the weakest, explain why"** — forces elimination with rationale
- **"Deepen the winning branch"** — transitions from ToT into CoT for implementation

You can adapt these prompts to any task — just swap the task description and criteria.

---

## Examples Based on Epic 1.5: Level 1 Population

> **Epic 1.5** from `docs/PRODUCTION_PLAN.md` covers populating Level 1 ("The Heights") with enemies, scavenge points, a level exit trigger, and the player spawn. The level spans Broadway from 181st St to 175th St through three zones: *The Traffic Jam*, *The Checkpoint*, and *The Commercial Strip*.

---

### **Example 1: Without Tree of Thought (Single Path)**

**Task 1.5.2** — Place 3 enemies in Zone 3

#### The Prompt (❌ no ToT)

> Place 2 Scavengers and 1 Raider in Zone 3 of Level 1 near ambush positions by the storefronts.

❌ **What you get back:**
> "Put 2 Scavengers and 1 Raider inside the storefronts in Zone 3, near ambush positions."

**Problems:**
- Only considers one arrangement — no alternatives evaluated
- "Near ambush positions" is vague — which storefronts? What sightlines?
- Doesn't explore whether enemies should be inside, outside, or on rooftops
- No evaluation of how this feels from the player's perspective after Zone 2 combat
- Misses the opportunity to create a different combat mood from Zone 2

---

### **Example 2: With Tree of Thought (Branching Evaluation)**

✅ **Better approach:**

**Task 1.5.2** — Place 3 enemies in Zone 3 ("The Commercial Strip")

#### The Prompt (✅ ToT)

> I need to place 3 enemies in Zone 3 ("The Commercial Strip") for Task 1.5.2.
> The acceptance criteria from `docs/PRODUCTION_PLAN.md` are: 2 Scavengers, 1 Raider, ambush positions near storefronts.
>
> **Use Tree of Thought reasoning:**
> 1. Generate 3 distinctly different enemy placement arrangements (vary position types: inside buildings, street-level, multi-elevation)
> 2. Evaluate each against these criteria:
>    - Is it distinct from Zone 2's checkpoint firefight?
>    - Does it use the storefront assets from `docs/LEVEL_1_DESIGN.md`?
>    - Does it teach the player a new skill?
>    - What does implementation require (NavMesh, vertical placement)?
> 3. Prune the weakest branch and explain why
> 4. If two branches are both strong, merge their best elements
> 5. Produce a final layout with specific EnemyAI property values from `src/ai/enemy_ai.hpp`

#### **Step 1: Generate Candidate Branches**

The acceptance criteria say: *2 Scavengers, 1 Raider — ambush positions near storefronts.* But "ambush" can mean many things. Let's explore three distinct arrangements:

```
              [Place 3 enemies in Zone 3]
              /           |              \
        Branch A      Branch B        Branch C
      "Storefront    "Street         "Layered
       Interior       Ambush"         Defense"
       Lurkers"
```

**Branch A — Storefront Interior Lurkers**
- All 3 enemies start INSIDE buildings (Woolworth's, Rexall Drugs, Diner)
- Player walks past, enemies burst out behind them
- Creates a "horror ambush" feel — enemies emerge from dark interiors

**Branch B — Street-Level Ambush**
- Enemies positioned BEHIND cover on the street: phone booths, mailboxes, newsstand
- They wait in IDLE state until `AIPerception` detects the player
- Creates a "firefight in the open" feel — similar to Zone 2

**Branch C — Layered Defense**
- Raider on a fire escape or 2nd-floor balcony (elevated, has range advantage)
- 1 Scavenger in the street behind a mailbox (visible, draws player attention)
- 1 Scavenger inside Rexall Drugs (flanks from the side when player engages street enemy)
- Creates a "multi-angle threat" feel — player must check vertical + lateral

#### **Step 2: Evaluate Each Branch**

| Criteria | Branch A (Interior) | Branch B (Street) | Branch C (Layered) |
|----------|---------------------|--------------------|--------------------|
| **Distinct from Zone 2?** | ✅ Yes — interior vs exterior | ❌ No — feels like Checkpoint 2.0 | ✅ Yes — vertical + lateral |
| **Uses storefront assets?** | ✅ Fully | ❌ Partially | ✅ Partially |
| **Matches "ambush" criteria?** | ✅ Surprise from interiors | ⚠️ More like a firefight | ✅ Layered surprise |
| **Teaches new skill?** | ✅ Check interiors before passing | ❌ Same as Zone 2 cover combat | ✅ Check elevated positions |
| **Implementation complexity** | ⚠️ Needs interior NavMesh | ✅ Simple — reuses Zone 2 patterns | ⚠️ Needs vertical positioning |
| **Player flow after Zone 2** | ✅ Tension shift (quiet → surprise) | ❌ Feels repetitive | ✅ Good escalation |

#### **Step 3: Prune and Decide**

```
              [Place 3 enemies in Zone 3]
              /           |              \
        Branch A      Branch B        Branch C
        ⭐ Best       ✗ Pruned        ⭐ Co-best
```

- **Branch B pruned** — too similar to Zone 2, doesn't use storefront assets well, teaches nothing new
- **Branch A and C both strong** — can we combine?

#### **Step 4: Merge Best Elements → Final Design**

Take the best of A (interior ambush surprise) and C (layered multi-angle):

```
Zone 3 Final Layout:

     N (Player arrives from Zone 2)
     |
  [Woolworth's]  ~~~road~~~  [Rexall Drugs]
     |                           |
     |                     Scav#2 INSIDE ←── flanks from doorway
     |                           |
     |   [Newsstand] Scav#1     |
     |     behind cover          |
     |                           |
  [Diner]         ~~~road~~~    |
     |                          |
     | Raider on fire escape ←── elevated, covers the street
     |     (2nd floor)          |
     |                          |
     S (Subway entrance — level exit)
```

**Scavenger #1 (Street Bait)**
- Position: behind newsstand, visible to the approaching player
- Role: draws attention forward — the "obvious" threat
- Behavior: IDLE → ATTACK when player is close, flees at 25% HP
- `max_health = 75`, `flee_health_threshold = 0.25`

**Scavenger #2 (Interior Flanker)**
- Position: inside Rexall Drugs, near the doorway
- Role: exits when Scavenger #1 engages (triggered by gunfire within 50m)
- Behavior: `ai_active = false`, activates on hearing → CHASE → ATTACK from the side
- `max_health = 75`, `loot_table = ["bandage", "bandage"]` (thematic: drugstore)

**Raider (Elevated Overwatch)**
- Position: fire escape on building west of the street, 2nd floor
- Role: fires down at player while they're engaged with Scavenger #1
- Behavior: ATTACK from elevated position, `cover_health_threshold = 0.5` (ducks behind railing)
- `max_health = 100`, `attack_damage = 20`
- **Design note**: teaches player to look UP — a skill needed for later levels

#### **Step 5: Verify Against Acceptance Criteria**
- [x] 2 Scavengers, 1 Raider
- [x] Ambush positions near storefronts (interior + elevated)
- [x] Distinct from Zone 2 (layered multi-angle vs frontal checkpoint)
- [x] Teaches new skill (check interiors, look up)
- [x] Thematic loot (bandages from the drugstore Scavenger)

---

### **Example 3: Tree of Thought for Scavenge Point Pacing (Task 1.5.3)**

**Task**: Decide the loot distribution model for 10 scavenge points

#### The Prompt

> Task 1.5.3 requires placing 10 scavenge points in Level 1. The acceptance criteria specify:
> - 5 in Zone 1 (tutorial loot)
> - 3 in Zone 2 (ammo caches)
> - 2 in Zone 3 (medical)
>
> **Use Tree of Thought reasoning:**
> 1. Generate 3 different loot distribution philosophies (e.g., front-loaded, combat-adjacent, evenly paced) — all deliver the same total loot but vary *when* the player finds it relative to combat
> 2. Evaluate each against: acceptance criteria match, tension in Zone 2, new player learning curve, pacing feel
> 3. Prune branches that violate the spec or create poor pacing
> 4. For the winning branch, list all 10 scavenge points with specific item contents from `docs/SPEC.md` and locations from `docs/LEVEL_1_DESIGN.md`
> 5. Do a resource balance check: is the total loot enough to survive 8 enemies?

#### **Step 1: Generate Three Distribution Philosophies**

All three branches deliver the same total loot. The question is *when* the player finds it relative to combat.

```
           [Distribute 10 scavenge points across 3 zones]
           /                  |                    \
     Branch A            Branch B              Branch C
    "Front-loaded"     "Combat-adjacent"     "Breadcrumb trail"
```

**Branch A — Front-Loaded**
- 7 points in Zone 1 (all loot before combat), 2 in Zone 2, 1 in Zone 3
- Player arrives at Zone 2 fully stocked
- Philosophy: "prepare, then execute"

**Branch B — Combat-Adjacent**
- 3 in Zone 1 (basics), 5 in Zone 2 (mixed into combat area), 2 in Zone 3
- Player scavenges *during* fights in Zone 2
- Philosophy: "risk and reward are co-located"

**Branch C — Breadcrumb Trail**
- 5 in Zone 1 (tutorial), 3 in Zone 2 (ammo resupply), 2 in Zone 3 (medical)
- Even pacing — new loot every ~30 seconds of gameplay
- Philosophy: "steady drip of progression"

#### **Step 2: Evaluate Each Branch**

| Criteria | A (Front-Loaded) | B (Combat-Adjacent) | C (Breadcrumb) |
|----------|-------------------|---------------------|----------------|
| **Teaches looting in Zone 1?** | ✅ 7 points, lots of practice | ⚠️ Only 3, minimal | ✅ 5 points, solid |
| **Tension in Zone 2?** | ❌ No risk — already stocked | ✅ High — scavenge under fire | ⚠️ Moderate — ammo as reward |
| **Matches acceptance criteria?** | ❌ Violates "5 Zone 1 / 3 Zone 2 / 2 Zone 3" | ❌ Violates distribution | ✅ Matches exactly |
| **Pacing feel** | Frontloaded then boring | Exciting but punishing | Steady, rewarding |
| **Survival tension** | ❌ Low — overprepared | ✅ High — always scrounging | ✅ Medium — feels earned |
| **New player experience** | Safe but unexciting | Confusing — combat + looting | Natural learning curve |

#### **Step 3: Prune and Decide**

```
           [Distribute 10 scavenge points]
           /                  |                    \
     Branch A            Branch B              Branch C
     ✗ Pruned            ✗ Pruned              ⭐ Best
   (violates spec,     (violates spec,        (matches spec,
    poor tension)       too punishing)         best pacing)
```

**Branch C wins** — it matches the acceptance criteria *and* delivers the best player experience:
- Zone 1 (5 points): teach looting, build confidence
- Zone 2 (3 points): ammo resupply as combat reward
- Zone 3 (2 points): medical recovery after the big fight

#### **Step 4: Refine Branch C with Specific Placements**

Now apply Chain of Thought *within* the winning branch to determine exact items:

| # | Zone | Location | Contents | Purpose |
|---|------|----------|----------|---------|
| 1 | 1 | Open car trunk (first car) | Bandage x2 | Teaches "press E to loot" |
| 2 | 1 | Overturned suitcase | .45 ACP x14 | Half a magazine — ammo is scarce |
| 3 | 1 | Bus interior | Canned Food x1 | Exploration reward |
| 4 | 1 | Car glove box | Bandage x1 | Reinforces car looting |
| 5 | 1 | Under bus bench | M1911 Pistol | Starting weapon pickup |
| 6 | 2 | Sandbag bunker (east) | .45 ACP x14 | Flanking reward |
| 7 | 2 | Military crate near tank | .45 ACP x14 + Bandage x1 | High-risk / high-reward |
| 8 | 2 | Guard shack | 12ga Shells x6 | Tease future weapon ammo |
| 9 | 3 | Rexall Drugs counter | Medkit x1 | Thematic (drugstore) |
| 10 | 3 | Diner kitchen | Bandage x2 + Canned Food x1 | Exploration reward |

#### **Step 5: Resource Balance Check**
- Total healing: 225 HP (6 Bandages × 25 HP + 1 Medkit × 75 HP)
- Total .45 ACP: 42 rounds (6 full M1911 magazines)
- 8 enemies × ~3-4 shots to kill = 24-32 rounds needed
- **Surplus of ~10 rounds** → rewards accuracy, doesn't punish mistakes

---

### **Example 4: Tree of Thought for Level Exit Implementation (Task 1.5.4)**

**Task**: Implement the level exit trigger at the subway entrance

#### The Prompt

> Task 1.5.4: Implement a level exit trigger at the subway entrance in Zone 3.
> Acceptance criteria: Area3D at subway entrance, triggers `level_completed` signal, loads victory screen.
>
> **Use Tree of Thought with 2-step lookahead:**
> 1. Generate 3 implementation approaches:
>    - A: Pure GDScript Area3D script
>    - B: New C++ `LevelExitTrigger` class (extending Area3D)
>    - C: Extend the existing `LevelManager` class in `src/world/level_manager.hpp`
> 2. Evaluate each against: `docs/CODING_STANDARDS.md` compliance, reusability across all 6 planned levels, signal integration with `GameManager`
> 3. **Lookahead**: For each branch, what happens when we implement Level 6's boss-gated exit? What about Milestone 5 Save/Load?
> 4. Score and prune. Select the winner.
> 5. Within the winning branch, generate 3 scope levels (minimal, full, cinematic) and pick the one that matches acceptance criteria without overscoping
> 6. Output the final class header and list of files to create/modify

#### **Step 1: Generate Three Implementation Branches**

```
         [Implement level exit trigger]
         /            |               \
    Branch A      Branch B         Branch C
   "GDScript    "C++ class        "Hybrid:
    Area3D"     LevelExitTrigger"  LevelManager
                                   extension"
```

**Branch A — Pure GDScript Area3D**
```
game/scripts/level_exit.gd  (new file)
├── extends Area3D
├── @export var exit_prompt: String
├── @export var required_enemies: int = 0
├── _on_body_entered(body) → check if PlayerController
├── _input(event) → listen for "interact" action
└── emit signal → level_completed
```

**Branch B — C++ LevelExitTrigger Class**
```
src/world/level_exit_trigger.hpp  (new file)
src/world/level_exit_trigger.cpp  (new file)
├── class LevelExitTrigger : public Area3D
├── Properties: exit_prompt, required_enemies, transition_delay
├── _on_body_entered() → detect PlayerController
├── _input() → interact key
├── Signals: exit_available, player_reached_exit, prerequisites_not_met
└── register in register_types.cpp + CMakeLists.txt
```

**Branch C — Extend Existing LevelManager**
```
src/world/level_manager.hpp  (modify existing)
├── Add Area3D* exit_zone pointer
├── Add _on_exit_zone_body_entered()
├── Trigger complete_level() internally
└── No new files — everything in LevelManager
```

#### **Step 2: Evaluate Each Branch (Depth 2 — look 2 steps ahead)**

For ToT, we don't just compare surface-level pros/cons. We **look ahead** — what happens *after* we implement each option? What does Level 2 look like? Level 6?

| Criteria | A (GDScript) | B (C++ Class) | C (Extend LevelManager) |
|----------|--------------|---------------|-------------------------|
| **Speed to implement** | ✅ Fast, no cmake rebuild | ⚠️ Medium, new class + rebuild | ✅ Fast, modify existing |
| **Matches architecture?** | ❌ Gameplay logic in GDScript violates `CODING_STANDARDS.md` | ✅ C++ for gameplay systems | ⚠️ Overloads LevelManager responsibility |
| **Reusable for 6 levels?** | ✅ Drag onto any scene | ✅ Drag onto any scene | ❌ Coupled to LevelManager internals |
| **Look ahead: Level 2** | ⚠️ Duplicate script or make generic | ✅ Just add node to scene | ❌ Must modify LevelManager for bridge-specific exit |
| **Look ahead: Level 6 boss** | ❌ Complex prerequisites in GDScript gets messy | ✅ `required_enemies_cleared` property handles this | ❌ Boss + exit logic tangled in one class |
| **Look ahead: Save/Load (MS 5)** | ⚠️ GDScript save serialization is fragile | ✅ C++ properties serialize cleanly | ⚠️ Save/load for LevelManager already complex |
| **Signal integration** | ⚠️ Must connect manually in each scene | ✅ `player_reached_exit` signal → LevelManager | ❌ Internal call, no signal for other systems |
| **Testability** | ✅ Rapid iteration | ⚠️ Requires build | ⚠️ Requires build + risk breaking LevelManager |

#### **Step 3: Score and Prune**

```
         [Implement level exit trigger]
         /            |               \
    Branch A      Branch B         Branch C
    Score: 5      Score: 9         Score: 4
    ✗ Pruned      ⭐ Best          ✗ Pruned
```

**Scoring** (1-2 points per criterion, 7 criteria):
- **Branch A (5/14)**: Fast but violates coding standards, messy at scale
- **Branch B (9/14)**: Matches architecture, scales to all 6 levels, clean save/load
- **Branch C (4/14)**: Couples exit to level management, breaks single responsibility

#### **Step 4: Deepen the Winning Branch**

Now that Branch B is selected, we do a **second-level expansion** within it:

```
       [Branch B: C++ LevelExitTrigger]
       /               |                \
   B1: Minimal      B2: Full           B3: Full +
   (detect + signal) (prereqs +        cinematic
                      prompt)           (camera +
                                        fade)
```

**Sub-Branch B1 — Minimal**
- Just detect player entry and emit signal
- 30 minutes to implement
- Missing: no interaction prompt, no prerequisites check

**Sub-Branch B2 — Full**
- Detect + prerequisites + interaction prompt + signal
- 1-2 hours to implement
- Covers acceptance criteria completely

**Sub-Branch B3 — Full + Cinematic**
- Everything in B2 + camera pan to subway entrance + screen fade
- 3-4 hours to implement
- Beyond acceptance criteria (polish, not scope)

**Decision**: **B2** — fully meets acceptance criteria without overscoping

#### **Step 5: Final Implementation Spec**

```cpp
// src/world/level_exit_trigger.hpp
class LevelExitTrigger : public Area3D {
    GDCLASS(LevelExitTrigger, Area3D)

private:
    String exit_prompt = "Enter Subway";
    int required_enemies_cleared = 0;
    float transition_delay = 1.0f;
    bool player_in_zone = false;

    void _on_body_entered(Node* body);
    void _on_body_exited(Node* body);

protected:
    static void _bind_methods();

public:
    LevelExitTrigger();
    ~LevelExitTrigger();

    void _ready() override;
    void _input(const Ref<InputEvent>& event);

    // Signals:
    // exit_available(String prompt)
    // exit_unavailable()
    // player_reached_exit()
    // prerequisites_not_met()
};
```

**Files to create/modify:**
1. `src/world/level_exit_trigger.hpp` — new
2. `src/world/level_exit_trigger.cpp` — new
3. `src/register_types.cpp` — add `GDREGISTER_CLASS(LevelExitTrigger)`
4. `CMakeLists.txt` — add `src/world/level_exit_trigger.cpp` to SOURCES

#### **Step 6: Verify**
- [x] Area3D at subway entrance
- [x] Triggers `player_reached_exit` signal (wired to `LevelManager.complete_level()`)
- [x] Loads victory screen (via `GameManager` state transition)
- [x] Reusable for all 6 levels
- [x] Scales to Level 6 boss (use `required_enemies_cleared` property)

---

### **Example 5: Tree of Thought for Enemy Activation Strategy (Task 1.5.1 + 1.5.2)**

**Task**: How should 8 enemies across Zone 2 and Zone 3 activate as the player progresses?

This is a cross-cutting concern that affects both 1.5.1 and 1.5.2. The `EnemyAI` class has an `ai_active` bool and a hearing-based activation model — but *when* should each enemy wake up?

#### The Prompt

> I've placed 5 enemies in Zone 2 and 3 enemies in Zone 3 for Tasks 1.5.1 and 1.5.2.
> Now I need to decide the activation strategy — when does each enemy's AI turn on?
>
> `EnemyAI` in `src/ai/enemy_ai.hpp` has:
> - `ai_active` bool (dormant enemies skip state processing)
> - `alert_to_position(Vector3)` (wakes enemy toward a sound)
> - `AIPerception` for sight/hearing detection
>
> `docs/SPEC.md` says gunfire alerts enemies within 50m.
>
> **Use Tree of Thought with 3-step lookahead:**
> 1. Generate 3 activation strategies: all-on-from-start, proximity-trigger zones, event-driven cascade
> 2. Evaluate each against: performance (how many AI tick at once), player experience (can enemies bleed into the tutorial zone?), stealth viability, and backtracking behavior
> 3. **Lookahead**: Level 2 has 15 enemies — does each strategy still work? What if the player backtracks to Zone 1?
> 4. Prune the weakest, select the winner
> 5. For the winning strategy, produce a detailed activation cascade diagram showing which enemies are always-on vs dormant, and what event wakes each dormant enemy
> 6. Show how this uses existing code (`ai_active`, `alert_to_position`) with minimal new wiring

#### **Step 1: Generate Branches**

```
          [Enemy activation strategy for Level 1]
          /              |                \
     Branch A        Branch B          Branch C
    "Always On"    "Proximity         "Event-Driven
     (all active    Trigger"           Cascade"
      from start)
```

**Branch A — Always On**
- All 8 enemies have `ai_active = true` at level start
- They patrol from the beginning, even if the player is in Zone 1

**Branch B — Proximity Trigger**
- Each enemy has `ai_active = false`
- An invisible Area3D per zone activates enemies when the player enters
- Zone 2 enemies activate as a group; Zone 3 enemies as a separate group

**Branch C — Event-Driven Cascade**
- Zone 2 enemies: some always active (patrolling), some activate on gunfire
- Zone 3 enemies: all `ai_active = false`, activate when Zone 2's last enemy dies or when player enters Zone 3 (whichever first)
- Creates a "ripple" — combat in one area alerts the next

#### **Step 2: Evaluate with 3-Step Lookahead**

| Criteria | A (Always On) | B (Proximity) | C (Cascade) |
|----------|---------------|---------------|-------------|
| **Performance** | ❌ 8 AI running NavMesh queries from start | ✅ Only active zone AI runs | ✅ Minimal AI until needed |
| **Player experience** | ❌ Zone 2 Raider may wander into Zone 1 tutorial | ✅ Clean zone boundaries | ✅ Natural — gunfire wakes neighbors |
| **Stealth viability** | ❌ Everyone alert, stealth impossible | ⚠️ Whole zone alert at once | ✅ Can sneak past dormant enemies |
| **Lookahead: 15 enemies in Level 2** | ❌ 15 AI ticking constantly | ✅ Scales — only active zone | ✅ Scales — cascade is local |
| **Lookahead: Player backtracks** | ⚠️ All still active, no reset | ❌ Re-entering zone re-triggers? | ✅ Already active, no re-trigger |
| **Implementation cost** | ✅ Zero — default behavior | ⚠️ Need trigger Area3D per zone | ⚠️ Need trigger + signal wiring |
| **Matches existing code** | ✅ Uses `ai_active = true` default | ✅ Uses `ai_active` flag | ✅ Uses `ai_active` + `alert_to_position()` |

#### **Step 3: Prune**

```
          [Enemy activation strategy]
          /              |                \
     Branch A        Branch B          Branch C
     ✗ Pruned        ⚠️ Simple         ⭐ Best
   (perf + bleed)   (good baseline)   (immersive + scalable)
```

- **Branch A pruned** — enemies bleeding into Zone 1 ruins the tutorial, and 8 active AI from the start is wasteful
- **Branch B is viable** but feels "gamey" — enemies magically activate when you cross an invisible line
- **Branch C is best** — feels natural (gunfire wakes people up), supports stealth, scales to larger levels

#### **Step 4: Deepen Branch C — Design the Cascade**

```
Player in Zone 1 (tutorial, no enemies)
      |
      ↓ enters Zone 2
      |
  ┌───┴──────────────────────────────────────┐
  │  Zone 2 Activation                        │
  │                                            │
  │  Always active (patrolling):               │
  │    • Raider #1 (MG Nest) — IDLE, waits    │
  │    • Scavenger #1 (East) — PATROL         │
  │                                            │
  │  Activated by gunfire (ai_active = false): │
  │    • Raider #2 (Tank) — hears shots        │
  │    • Scavenger #2 (West) — hears shots     │
  │    • Scavenger #3 (Rear) — hears shots     │
  │                                            │
  │  Cascade trigger: gunfire within 50m       │
  │  (SPEC.md: "Gunfire alerts within 50m")    │
  └────────────────────────────────────────────┘
      |
      ↓ gunfire or player enters Zone 3
      |
  ┌───┴──────────────────────────────────────┐
  │  Zone 3 Activation                        │
  │                                            │
  │  Trigger: ZoneEntryArea3D OR enemy_died    │
  │  signal from last Zone 2 enemy             │
  │                                            │
  │  Activated:                                │
  │    • Scavenger #1 (Street) — IDLE→PATROL  │
  │    • Scavenger #2 (Rexall interior) — wait│
  │    • Raider (fire escape) — IDLE→ATTACK   │
  │                                            │
  │  Sub-cascade: Scav#2 activates when       │
  │  Scav#1 fires (hearing range)              │
  └────────────────────────────────────────────┘
```

#### **Step 5: Implementation Using Existing Code**

The cascade uses **two mechanisms already in `EnemyAI`**:

1. **`ai_active` flag** — dormant enemies don't process states
2. **`alert_to_position(Vector3)`** — wakes an enemy toward a sound source

```cpp
// Zone activation script (GDScript for rapid iteration — this is level-specific logic)
# zone_2_activator.gd
extends Area3D

@export var dormant_enemies: Array[NodePath] = []

func _on_body_entered(body):
    if body is PlayerController:
        # Only activate patrol enemies — combat ones wake on gunfire
        for path in dormant_enemies:
            var enemy = get_node(path) as EnemyAI
            if enemy:
                enemy.set_ai_active(true)

# Meanwhile, gunfire-activated enemies use AIPerception hearing:
# When any Weapon fires, it creates an audio event at 50m radius
# Dormant enemies with ai_active=false SKIP this
# So we need a lightweight "zone alert" that flips ai_active 
# when gunfire occurs in the zone
```

```cpp
// In EnemyAI::alert_to_position — already handles this:
void EnemyAI::alert_to_position(Vector3 position) {
    if (!ai_active) {
        ai_active = true;  // Wake up!
    }
    investigate_position = position;
    if (current_state == AIState::IDLE || current_state == AIState::PATROL) {
        change_state(AIState::INVESTIGATE);
    }
}
```

#### **Step 6: Verify**
- [x] Zone 1 has no enemies (tutorial safe zone)
- [x] Zone 2 has 2 always-active enemies (Raider MG + Scavenger patrol) — immediate threat
- [x] Zone 2 has 3 dormant enemies that activate on gunfire — escalating pressure
- [x] Zone 3 enemies sleep until Zone 2 is resolved or player enters — clean progression
- [x] Stealth is viable: crouching through Zone 2 without firing keeps dormant enemies asleep
- [x] Performance: maximum 5 active AI at any time (Zone 2 fight), not 8

---

## Why Tree of Thought Matters for Epic 1.5

### **Without Tree of Thought:**
- ❌ Pick the first idea that comes to mind (always-on enemies)
- ❌ Never discover better alternatives (cascade activation)
- ❌ Implementation choice locks you into a path that doesn't scale (GDScript exit trigger on Level 6)
- ❌ No systematic evaluation — just gut feeling
- ❌ Surprised by problems 3 steps later

### **With Tree of Thought:**
1. ✅ Generate 3+ candidate approaches before committing
2. ✅ Evaluate with multi-step lookahead (what does Level 2 look like? Level 6?)
3. ✅ Prune bad branches early (save time, avoid rework)
4. ✅ Merge best ideas from different branches when possible
5. ✅ Arrive at a decision with documented rationale
6. ✅ Future developers understand *why* alternatives were rejected

### **Result:**
- **Better design decisions** — compared 3 options, picked the strongest
- **Fewer rewrites** — looked ahead 2-3 steps before committing
- **Documented rationale** — team knows why GDScript exit trigger was rejected
- **Combinable with CoT** — once the best branch is selected, use Chain of Thought to implement it step-by-step

---

## When to Use ToT vs CoT

| Scenario | Use |
|----------|-----|
| Problem has one obvious approach | **CoT** — show steps linearly |
| Multiple valid architectures compete | **ToT** — branch, evaluate, prune |
| Balancing game design tradeoffs | **ToT** — explore feel/pacing variants |
| Implementing a chosen design | **CoT** — step-by-step implementation |
| Cross-cutting concerns (activation, spawning) | **ToT** — affects multiple systems |
| Single-class implementation | **CoT** — straightforward coding |

**Best practice**: Use **ToT to decide WHAT to build**, then **CoT to decide HOW to build it**.

---

## Prompt Cheat Sheet

Here are the 5 prompts stripped to their reusable skeleton. Copy, fill in the blanks, paste.

### Quick Prompt — Game Design Decision (Examples 2, 3)

```
I need to [TASK DESCRIPTION] for [TASK ID].
Acceptance criteria: [PASTE FROM PRODUCTION_PLAN.md]

Use Tree of Thought reasoning:
1. Generate 3 distinctly different approaches to [WHAT VARIES]
2. Evaluate each against: [CRITERION 1], [CRITERION 2], [CRITERION 3]
3. Prune the weakest branch and explain why
4. If two branches are strong, merge their best elements
5. Produce a final design with specific values from [RELEVANT SOURCE FILE]
```

### Quick Prompt — Architecture / Implementation Decision (Example 4)

```
Task [ID]: [DESCRIPTION]
Acceptance criteria: [PASTE]

Use Tree of Thought with 2-step lookahead:
1. Generate 3 implementation approaches (list them: A, B, C)
2. Evaluate each against: coding standards, reusability across [SCOPE], signal/API integration
3. Lookahead: what happens at [FUTURE MILESTONE]? At [FULL SCALE]?
4. Score and prune. Select the winner.
5. Within the winner, generate 3 scope levels (minimal, full, over-engineered)
   Pick the one matching acceptance criteria.
6. Output final class/file list.
```

### Quick Prompt — Cross-Cutting Concern (Example 5)

```
I've completed [TASK A] and [TASK B]. Now I need to decide [CROSS-CUTTING CONCERN].

Relevant code:
- [CLASS] in [FILE] has [RELEVANT API]
- [SPEC RULE from docs/SPEC.md]

Use Tree of Thought with 3-step lookahead:
1. Generate 3 strategies: [NAME_A], [NAME_B], [NAME_C]
2. Evaluate: performance, player experience, [DOMAIN-SPECIFIC CRITERION]
3. Lookahead: does each strategy work at [LARGER SCALE]?
   What if [EDGE CASE]?
4. Prune and select.
5. Produce a detailed diagram for the winning strategy.
6. Show how it uses existing code with minimal new wiring.
```

---

## Tree of Thought Template for Game Development

```markdown
### Problem: [Task from PRODUCTION_PLAN.md]

#### Step 1: Generate Candidate Branches
         [Problem]
         /    |    \
    Branch A  B     C
    "name"  "name" "name"

Describe each branch in 2-3 sentences.

#### Step 2: Evaluate with Lookahead
| Criteria | Branch A | Branch B | Branch C |
|----------|----------|----------|----------|
| Matches acceptance criteria? | | | |
| Distinct from other zones/levels? | | | |
| Matches CODING_STANDARDS.md? | | | |
| Lookahead: next milestone? | | | |
| Lookahead: Level 6 / full game? | | | |
| Implementation cost? | | | |
| Performance? | | | |

#### Step 3: Score and Prune
- Branch [X] pruned because...
- Branch [Y] selected because...
- (Optional) Merge elements from pruned branches

#### Step 4: Deepen Winning Branch
Expand the chosen branch one more level.
Apply CoT within this branch for implementation details.

#### Step 5: Verify Against Acceptance Criteria
- [ ] Criterion from PRODUCTION_PLAN.md
- [ ] Lookahead criterion (does it scale?)
- [ ] Architecture criterion (matches docs/ARCHITECTURE.md?)
```

---

## Key Takeaway

**Tree of Thought = Explore before you commit**, like a chess player considering multiple moves.

For Epic 1.5, this means:
1. **Branch** — "What are 3 ways to place Zone 3 enemies?"
2. **Evaluate** — "Which creates the best player experience AND matches the spec?"
3. **Prune** — "Street ambush is too similar to Zone 2 — cut it."
4. **Merge** — "Combine interior lurkers with elevated overwatch."
5. **Deepen** — "Now use CoT to implement the winning design step-by-step."

The power of ToT is avoiding the trap of the first idea. In game development, the first layout you sketch, the first architecture you consider, and the first activation model you imagine are rarely the best. **Branching before committing** leads to stronger, more considered designs.

---

## Additional Resources

- **Chain of Thought doc**: `docs/workshops/CHAIN_OF_THOUGHT.md` — linear reasoning companion
- **Production Plan**: `docs/PRODUCTION_PLAN.md` — Epic 1.5 acceptance criteria
- **Level Design**: `docs/LEVEL_1_DESIGN.md` — Zone layouts, assets, sightlines
- **Game Spec**: `docs/SPEC.md` — Enemy types, weapon stats, stealth mechanics
- **Architecture**: `docs/ARCHITECTURE.md` — System hierarchy, signal flow
- **Enemy AI**: `src/ai/enemy_ai.hpp` — FSM states, `ai_active`, `alert_to_position()`
- **Level Manager**: `src/world/level_manager.hpp` — Level completion, enemy tracking
- **Memory**: `docs/MEMORY.md` — Past decisions on singletons, composition patterns

---

**Author**: GitHub Copilot  
**Context**: Urban Survivor - Production Plan, Milestone 1 (Vertical Slice), Epic 1.5  
**Last Updated**: February 10, 2026
