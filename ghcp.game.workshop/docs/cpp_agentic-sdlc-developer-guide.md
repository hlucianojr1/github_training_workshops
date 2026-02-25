# C++ Agentic SDLC — Developer Guide

> How to use the agentic prompt chain to plan, implement, review, test,
> and track C++ work in Visual Studio 2026.

---

## The Agentic SDLC Loop

The `urban_survivor` project uses a chain of five Copilot agent prompts
that form a continuous development loop. Each agent has a single
responsibility and generates the exact handoff prompt for the next agent.

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│   sprint-planner ──▸ cpp-planner ──▸ cpp-engineer        │
│        ▲                                   │             │
│        │                                   ▼             │
│   cpp-test-engineer ◂──────────── cpp-reviewer           │
│        │                                                 │
│        ▼                                                 │
│   [user approval gate]                                   │
│        │                                                 │
│        └────────────▸ sprint-planner (loop)              │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

| Agent | Prompt File | Role |
|-------|-------------|------|
| **Sprint Planner** | `/sprint-planner` | Updates `PRODUCTION_PLAN.md`, selects next task |
| **C++ Planner** | `/cpp-planner` | Researches and creates implementation plan |
| **C++ Engineer** | `/cpp-engineer` | Implements the plan step-by-step |
| **C++ Reviewer** | `/cpp-reviewer` | Validates against conventions + acceptance criteria |
| **C++ Test Engineer** | `/cpp-test-engineer` | Writes and runs tests, requests user approval |

### How the Loop Works

1. **Sprint Planner** reads `docs/PRODUCTION_PLAN.md`, picks the next task,
   and generates a planning prompt.
2. **C++ Planner** researches via Context7 + Microsoft Learn, produces a
   detailed plan, and iterates with the user until approved.
3. **C++ Engineer** implements the approved plan step-by-step, building
   after each step, and presents a completion summary.
4. **C++ Reviewer** validates the work against conventions and acceptance
   criteria. Approves (→ test) or rejects (→ engineer fix prompt).
5. **C++ Test Engineer** writes static + runtime tests, presents a report,
   and asks the user for final approval.
6. On **user approval**, generates a sprint-planner handoff to update the
   roadmap and start the next task.

### Starting the Loop

To begin the loop from scratch:
```
/sprint-planner What's the next task?
```

To start mid-loop with a specific task:
```
/cpp-planner Plan implementing {feature} for {module}
```

---

## What Is cpp-planner?

The **cpp-planner** is a reusable Copilot prompt file (`.prompt.md`) that turns
GitHub Copilot into a dedicated C++ planning agent for the `urban_survivor`
project. Instead of jumping straight into code, it forces a structured workflow:

1. **Research** — Looks up godot-cpp, MSVC, and library docs via Context7 MCP
   and Microsoft Learn before making any decisions.
2. **Plan** — Produces a structured, reviewable plan with steps, risks, and
   verification commands.
3. **Iterate** — Loops on your feedback until you approve the plan.
4. **Hand off** — Generates a ready-to-paste prompt for the implementation agent.

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **IDE** | Visual Studio 2026 (v18.0+) |
| **Copilot** | GitHub Copilot subscription with agent mode enabled |
| **MCP Server** | Context7 MCP configured in VS 2026 (Tools → Copilot → MCP Servers) |
| **Repository** | `urban_survivor` cloned with `.github/prompts/cpp-planner.prompt.md` present |
| **Custom instructions** | Verify `.github/copilot-instructions.md` exists at the repo root |

### Enabling Custom Instructions in VS 2026

1. Open **Tools → Options**
2. Navigate to **GitHub → Copilot → Copilot Chat**
3. Check **"Enable custom instructions to be loaded from .github/copilot-instructions.md files and added to requests"**
4. Restart the Copilot Chat window

### Enabling Context7 MCP

1. Open the **Copilot Chat** window
2. Switch to **Agent** mode (click the mode dropdown)
3. Click the **Tools** icon (🔧)
4. Ensure **Context7** is listed and enabled
5. If missing, add it via **Tools → Options → GitHub → Copilot → MCP Servers**

---

## How to Invoke the Planner

### Method 1 — Slash Command (Recommended)

In the Copilot Chat window (Agent mode), type:

```
/cpp-planner Plan adding a health regeneration system to PlayerController
```

The `/` prefix triggers IntelliSense, and custom prompts appear at the top
with a bookmark icon.

### Method 2 — Hash Reference

Type `#prompt:cpp-planner` in the chat input, then add your request:

```
#prompt:cpp-planner Plan an inventory weight system for the survival module
```

### Method 3 — Plus Button

1. Click the **➕** icon in the chat input area
2. Browse to **cpp-planner** in the prompt picker
3. Type your planning request after attaching it

---

## The Planning Workflow

### Step 1 — You Submit a Request

Write a clear, C++ focused task description. Good examples:

| ✅ Good Prompts | ❌ Bad Prompts |
|-----------------|----------------|
| "Plan adding fall damage to PlayerController" | "Add fall damage" (too vague) |
| "Plan a weapon attachment system for the combat module" | "Make weapons better" (no specifics) |
| "Plan refactoring EnemyAI to use a behavior tree pattern" | "Fix AI" (no direction) |

### Step 2 — The Agent Researches

The planner will:

- Call **Context7 MCP** with `resolve-library-id` → `query-docs` for:
  - `/godotengine/godot-cpp` — GDExtension patterns, node types, signals
  - `/assimp/assimp` — model import (if relevant)
  - Microsoft Learn — MSVC STL, compiler conformance, Windows APIs
- **Scan your codebase** — reads relevant `.hpp`/`.cpp` files in `src/`
- Report findings in a **Research Findings** section

### Step 3 — The Agent Produces a Plan

You'll receive a structured plan with these sections:

| Section | Purpose |
|---------|---------|
| **Summary** | One-paragraph goal and approach |
| **Research Findings** | Bullet list of facts from Context7 / Microsoft docs |
| **Steps** | Numbered action items with file paths and descriptions |
| **New Types to Register** | `ClassDB::register_class<T>()` lines for `src/register_types.cpp` |
| **CMake Changes** | Any `CMakeLists.txt` additions |
| **Risk Assessment** | What could break, ordering concerns, MSVC pitfalls |
| **Verification** | Build and test commands |
| **Suggestions** | 2-3 research-backed best practices |

### Step 4 — You Provide Feedback

The agent asks:

> **"Feedback? Reply with changes, 'approved' to proceed, or 'done' to finish."**

Your options:

| Reply | What Happens |
|-------|--------------|
| Free-text feedback | Agent revises the plan and presents it again |
| `approved` | Agent generates an implementation prompt (Step 5) |
| `done` | Agent stops — use if you only needed the plan |

You can iterate as many times as needed. The agent won't stop until you say
**"approved"** or **"done"**.

### Step 5 — You Get an Implementation Prompt

After approval, the agent outputs a ready-to-paste prompt like:

```
📋 Next Prompt — Paste into Agent Mode:

> Implement health regeneration for PlayerController per the approved plan
> steps 1-5. Add `regen_rate` (float, default 2.0), `regen_delay` (float,
> default 5.0), and a Timer node to `src/player/player_controller.hpp/.cpp`.
> #file:src/player/player_controller.hpp
> #file:src/player/player_controller.cpp
> #file:src/register_types.cpp
> Build with `cmake --build visualstudio/vs2026-x64 --config Debug`.
> use context7
```

Copy this prompt, paste it into a **new** Agent mode chat with `/cpp-engineer`
attached, and the C++ Engineer agent will implement the code changes with
full best-practice enforcement, step-by-step builds, and acceptance criteria.

> **Tip:** Use `#prompt:cpp-engineer` when pasting the implementation prompt
> to automatically load the engineer's conventions and Context7 research
> workflow. See `.github/prompts/cpp-engineer.prompt.md` for details.

---

## Tips for Better Results

### Attach Context with `#file:` References

You can pre-load files into the planner's context:

```
/cpp-planner Plan adding stamina drain to sprint
#file:src/player/player_controller.hpp
#file:src/survival/survival_stats.hpp
```

This helps the agent skip the codebase scan and go straight to planning with
full context.

### Use `#solution` for Broad Awareness

For cross-cutting changes, add `#solution` so the agent sees the full project
structure:

```
/cpp-planner Plan a global event bus system for cross-module communication
#solution
```

### Chain Multiple Prompts

For large features, plan in phases:

1. `/cpp-planner Plan phase 1: data model for crafting system`
2. Get approved → paste implementation prompt → implement
3. `/cpp-planner Plan phase 2: crafting UI integration` (in new chat)
4. Repeat

### Use `/savePrompt` to Capture Good Plans

If you've typed a particularly good planning request, use VS 2026's built-in
`/savePrompt` command to save it as a reusable prompt file:

```
/savePrompt
```

This creates a new `.prompt.md` file in `.github/prompts/` for future reuse.

---

## What the Planner Won't Do

| Rejected Request | Why |
|------------------|-----|
| Non-C++ tasks (GDScript, Python, C#) | Gate rule — responds with ⛔ |
| Direct code implementation | Plans only — use the output prompt for implementation |
| Skip research | Research is mandatory before every plan |
| Plans that break the build | Every step must leave the project compilable |

---

## Project Conventions the Planner Enforces

These rules come from `.github/copilot-instructions.md` and the planner itself:

| Convention | Detail |
|------------|--------|
| **Naming** | `snake_case` files, `PascalCase` classes, `camelCase` locals |
| **Registration** | Every new class → `ClassDB::register_class<T>()` in `src/register_types.cpp` |
| **Compiler** | MSVC `/W4 /permissive- /std:c++17 /bigobj` — no GCC/Clang extensions |
| **godot-cpp** | `GDCLASS` macro, `_bind_methods()`, `ClassDB::bind_method()`, `ADD_PROPERTY` / `ADD_SIGNAL` |
| **Build** | `cmake --build visualstudio/vs2026-x64 --config Debug` |
| **Solution format** | `.slnx` (VS 2026) — not `.sln` |

---

## File Locations

### SDLC Agent Prompts

| File | Agent | Role in Loop |
|------|-------|--------------|
| `.github/prompts/sprint-planner.prompt.md` | Sprint Planner | Updates roadmap, selects next task |
| `.github/prompts/cpp-planner.prompt.md` | C++ Planner | Researches and plans implementation |
| `.github/prompts/cpp-engineer.prompt.md` | C++ Engineer | Implements plan step-by-step |
| `.github/prompts/cpp-reviewer.prompt.md` | C++ Reviewer | Validates against conventions + criteria |
| `.github/prompts/cpp-test-engineer.prompt.md` | C++ Test Engineer | Writes and runs tests |

### Project Files

| File | Purpose |
|------|---------|
| `.github/copilot-instructions.md` | Global Copilot instructions for the repo |
| `docs/PRODUCTION_PLAN.md` | Roadmap — tracked by sprint-planner |
| `src/register_types.cpp` | GDExtension class registration — updated by every plan that adds types |
| `CMakeLists.txt` | Build configuration — updated when plans add source files |
| `visualstudio/vs2026-x64/urban_survivor.slnx` | VS 2026 solution file |
| `game/tests/` | Runtime test harnesses generated by cpp-test-engineer |

---

## Troubleshooting

### Planner doesn't appear in `/` commands

- Verify the file exists at `.github/prompts/cpp-planner.prompt.md`
- Check that custom instructions are enabled in **Tools → Options → GitHub → Copilot**
- Restart the Copilot Chat window

### Context7 MCP calls fail

- Verify MCP is enabled in the Tools icon (🔧) in Agent mode
- Check network connectivity to the Context7 service
- The planner has fallback guidance: it will use Microsoft Learn docs directly

### Agent responds with ⛔

You submitted a non-C++ request. The planner is C++ only by design. Use
a different Copilot mode or prompt for other languages.

### Plan seems generic or doesn't cite sources

- Ensure Context7 MCP is enabled and reachable
- Try adding `#file:` references to the specific source files related to your task
- Rephrase your request with more specifics about what C++ classes and systems
  are involved

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────┐
│  AGENTIC SDLC — QUICK REFERENCE                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  START LOOP:  /sprint-planner What's the next task? │
│                                                     │
│  AGENTS:                                            │
│    /sprint-planner  → picks task from roadmap       │
│    /cpp-planner     → researches + plans            │
│    /cpp-engineer    → implements step-by-step       │
│    /cpp-reviewer    → validates + approves/rejects  │
│    /cpp-test-engineer → tests + user approval       │
│                                                     │
│  FEEDBACK: Type changes → agent revises             │
│            "approved"   → advance to next agent     │
│            "done"       → stop current agent        │
│                                                     │
│  CONTEXT:  #file:src/path/to/file.hpp               │
│            #solution                                 │
│            use context7                              │
│                                                     │
│  BUILD:    cmake --build visualstudio/vs2026-x64    │
│            --config Debug                            │
│                                                     │
│  ROADMAP:  docs/PRODUCTION_PLAN.md                  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Appendix A: SDLC Examples — Milestone 1.5 Hardening

This appendix walks through every task in Milestone 1.5 using the full Agentic SDLC
loop. Each prompt example follows the **CORE** framework:

| Element | Purpose |
|---------|---------|
| **C**ontext | `#file:` references, SPEC sections, MEMORY decisions that ground the agent |
| **O**bjective | A single, measurable goal with clear acceptance criteria |
| **R**ules | Guardrails that prevent regressions and enforce conventions |
| **E**xamples | Concrete before/after code patterns with line references |

### How to Read These Examples

Each task below shows:

1. **The planning prompt** — paste into `/cpp-planner` to produce an implementation plan.
2. **The engineering prompt** — paste into `/cpp-engineer` after the plan is approved.
3. **Build gate** — the verification step before moving to the next task.

> **Tip:** Within a phase, tasks are independent. You can run them in parallel
> in separate Copilot Chat windows.

---

### Phase 1: Quick Fixes

---

#### Task 1.6.2 — Fix M1911 Magazine Capacity (0.5h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan fixing the M1911 magazine capacity from 8 to 7.

## Context
#file:src/combat/weapon.hpp
#file:src/combat/weapon.cpp
#file:docs/SPEC.md
The SPEC §5.1 defines the M1911 with a 7+1 capacity (7-round magazine).
The current defaults in weapon.hpp set magazine_capacity = 8 and current_ammo = 8.

## Objective
Change the two default values (magazine_capacity and current_ammo) from 8 → 7
so the weapon matches the SPEC. No other files should change.

## Rules
- Only modify default member values; do not change property bindings or hints.
- The PROPERTY_HINT_RANGE max for magazine_capacity must also update to reflect 7.
- Build must succeed after the change.
- Do not alter any other weapon stats (damage, fire_rate, range).

## Examples
Current (weapon.hpp):
  int magazine_capacity = 8;
  int current_ammo = 8;

Expected:
  int magazine_capacity = 7;
  int current_ammo = 7;

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.6.2: change M1911 magazine
defaults from 8 → 7 in weapon.hpp. Update PROPERTY_HINT_RANGE max accordingly.
#file:src/combat/weapon.hpp
#file:src/combat/weapon.cpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
```

---

#### Task 1.6.3 — Enrich damage_dealt Signal (1.5h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan adding a hit_zone parameter to the damage_dealt signal.

## Context
#file:src/combat/damage_system.hpp
#file:src/combat/damage_system.cpp
#file:docs/SPEC.md
SPEC §5.2 requires hit-zone-aware damage reporting. The current damage_dealt
signal emits (target, amount, type, source) but is missing the hit_zone parameter.
There are two emit_signal("damage_dealt", ...) call sites in damage_system.cpp.

## Objective
Add a fifth parameter "hit_zone" (int, default 0) to the damage_dealt signal
definition in _bind_methods() and to both emit_signal call sites. Document zone
values: 0=body, 1=head, 2=limb.

## Rules
- Signal signature changes must use PropertyInfo with Variant::INT for hit_zone.
- Both emit_signal call sites must be updated — missing one breaks zone reporting.
- Godot ignores extra signal params for existing connections, so GDScript listeners
  won't break, but verify hud_controller.gd connections still work.
- apply_damage() must accept and forward the hit_zone parameter.

## Examples
Current signal definition:
  ADD_SIGNAL(MethodInfo("damage_dealt",
      PropertyInfo(Variant::OBJECT, "target"),
      PropertyInfo(Variant::FLOAT, "amount"),
      PropertyInfo(Variant::INT, "type"),
      PropertyInfo(Variant::OBJECT, "source")));

Expected:
  ADD_SIGNAL(MethodInfo("damage_dealt",
      PropertyInfo(Variant::OBJECT, "target"),
      PropertyInfo(Variant::FLOAT, "amount"),
      PropertyInfo(Variant::INT, "type"),
      PropertyInfo(Variant::OBJECT, "source"),
      PropertyInfo(Variant::INT, "hit_zone")));

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.6.3: add hit_zone parameter
to damage_dealt signal definition and both emit_signal call sites.
#file:src/combat/damage_system.hpp
#file:src/combat/damage_system.cpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: headshot should log hit_zone=1 in debug output.
```

---

#### Task 1.7.3 — Fix Premature Reload Signal (1h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan fixing the premature weapon_reloaded signal in PlayerController.

## Context
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/combat/weapon.hpp
#file:src/combat/weapon.cpp
The reload() method in PlayerController emits "weapon_reloaded" immediately when
reload starts. It should only fire AFTER the reload animation/timer completes.
Weapon already has (or needs) a "reload_finished" signal that fires on completion.

## Objective
Remove the premature emit_signal("weapon_reloaded") from PlayerController::reload().
Add an on_reload_finished() callback connected to Weapon's reload_finished signal.
The callback transfers ammo and then emits weapon_reloaded.

## Rules
- Never emit weapon_reloaded before ammo is actually transferred to the magazine.
- Connect the signal in _ready() with CONNECT_DEFERRED to avoid physics-frame issues.
- Null-check the weapon pointer before connecting.
- If Weapon does not yet emit reload_finished, add it at the end of the reload timer.

## Examples
Current (broken):
  void PlayerController::reload() {
      weapon->start_reload();
      emit_signal("weapon_reloaded");  // ← fires immediately, before reload completes
  }

Expected:
  void PlayerController::reload() {
      weapon->start_reload();
      // No signal here — wait for callback
  }

  void PlayerController::on_reload_finished() {
      // ammo transfer happens in Weapon::start_reload timer callback
      emit_signal("weapon_reloaded");
  }

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.7.3: remove premature
weapon_reloaded emit, add on_reload_finished callback wired to Weapon's
reload_finished signal.
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/combat/weapon.hpp
#file:src/combat/weapon.cpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: reload animation completes before HUD updates ammo count.
```

**Phase 1 Build Gate:**

```powershell
cmake --build visualstudio/vs2026-x64 --config Debug
# Open Godot, press F5
# Verify: fire 7 shots → empty, reload completes before signal, headshot logs hit_zone=1
```

---

### Phase 2: System Wiring

---

#### Task 1.6.1 — Fix Range Falloff to SPEC (2h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan replacing the linear range falloff with the SPEC §5.2 tiered curve.

## Context
#file:src/combat/damage_system.hpp
#file:src/combat/damage_system.cpp
#file:docs/SPEC.md
SPEC §5.2 defines a tiered damage falloff:
  0–15m = 100%, 15–30m = 70%, 30–50m = 40%, 50m+ = 0%.
The current apply_distance_falloff() uses a simple linear lerp from full damage
at 0m to zero damage at max_range, which doesn't match the SPEC.

## Objective
Replace apply_distance_falloff() with a tiered implementation matching the four
SPEC ranges. Expose the tier thresholds and multipliers as exported properties
so designers can tune them without recompiling.

## Rules
- Use std::clamp for all multiplier values (0.0–1.0 range).
- The tier boundaries must be configurable via ADD_PROPERTY with PROPERTY_HINT_RANGE.
- Preserve the method signature so callers don't need to change.
- Group the new properties under ADD_GROUP("Range Falloff", "falloff_").
- Add a unit test scenario comment describing expected values at 10m, 20m, 40m, 60m.

## Examples
Current:
  float DamageSystem::apply_distance_falloff(float base, float dist, float max_range) {
      return Math::lerp(base, 0.0f, dist / max_range);
  }

Expected (tiered):
  float DamageSystem::apply_distance_falloff(float base, float dist, float max_range) {
      if (dist <= falloff_tier1_range) return base * falloff_tier1_mult;
      if (dist <= falloff_tier2_range) return base * falloff_tier2_mult;
      if (dist <= falloff_tier3_range) return base * falloff_tier3_mult;
      return 0.0f;
  }

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.6.1: replace linear falloff
with SPEC §5.2 tiered curve in DamageSystem. Expose tier properties.
#file:src/combat/damage_system.hpp
#file:src/combat/damage_system.cpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: shoot target at 10m (full damage), 20m (~70%), 40m (~40%), 60m (0).
```

---

#### Task 1.7.1 — Wire Sprint → Stamina (2h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan wiring sprint to stamina drain in PlayerController.

## Context
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/survival/survival_stats.hpp
#file:src/survival/survival_stats.cpp
#file:docs/SPEC.md
Currently PlayerController checks can_sprint but never calls
survival_stats->set_sprinting(), so stamina never drains. SPEC §4.2 requires:
- Sprint drains stamina at sprint_stamina_cost per second while sprinting.
- When stamina hits 0, player enters exhaustion (can_sprint returns false).
- Jumping costs 5 stamina points per jump.

## Objective
Add survival_stats->set_sprinting(wants_sprint && can_sprint) in
handle_movement() every frame. Read can_sprint() to gate sprint speed.
Add 5.0f stamina drain on each jump event.

## Rules
- Null-check survival_stats before every call (it may not be assigned in editor testing).
- Use the existing drain_stamina() and set_sprinting() API — do not duplicate logic.
- The exhaustion state must prevent sprinting until stamina recovers above a threshold.
- Do not modify SurvivalStats internals — only call its public API from PlayerController.
- Match existing code style: camelCase locals, snake_case members.

## Examples
Current handle_movement() (broken):
  if (input->is_action_pressed("sprint")) {
      current_speed = sprint_speed;  // ← no stamina check
  }

Expected:
  bool wantsSprint = input->is_action_pressed("sprint");
  if (survival_stats) {
      survival_stats->set_sprinting(wantsSprint && survival_stats->can_sprint());
  }
  current_speed = (survival_stats && survival_stats->is_sprinting())
      ? sprint_speed : walk_speed;

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.7.1: wire sprint → stamina
drain in PlayerController::handle_movement(). Add 5.0f stamina cost per jump.
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/survival/survival_stats.hpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: sprint → stamina bar drains, exhaustion stops sprint, jump costs stamina.
```

---

#### Task 1.7.4 — Fix Interaction Collision Mask (1h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan adding an interaction_collision_mask property to PlayerController.

## Context
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:docs/SPEC.md
The interaction raycast currently uses 0xFFFFFFFF (all layers), which causes
false positives against enemies, projectiles, and world geometry. SPEC §4.4
requires interactions to only hit layer 6 (interactable objects).

## Objective
Add an interaction_collision_mask property (uint32_t, default 0x20 = layer 6).
Replace the hardcoded 0xFFFFFFFF in the interact raycast with this property.
Expose it via ADD_PROPERTY with PROPERTY_HINT_LAYERS_3D_PHYSICS.

## Rules
- Use PROPERTY_HINT_LAYERS_3D_PHYSICS so the editor shows layer checkboxes.
- Group under ADD_GROUP("Interaction", "interaction_").
- Only change the mask for interaction raycasts — do not affect movement or combat casts.
- Default must be 0x20 (bit 5 set = layer 6 in Godot's 0-indexed system).

## Examples
Current:
  params->set_collision_mask(0xFFFFFFFF);  // hits everything

Expected:
  params->set_collision_mask(interaction_collision_mask);  // default 0x20 = layer 6

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.7.4: add interaction_collision_mask
property, replace hardcoded 0xFFFFFFFF in interact raycast.
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: E key only picks up interactable objects, ignores enemies and walls.
```

---

#### Task 1.8.2 — Wire Enemy Death → LevelManager (2h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan wiring enemy death signals to LevelManager for objective tracking.

## Context
#file:src/ai/enemy_ai.hpp
#file:src/ai/enemy_ai.cpp
#file:src/world/level_manager.hpp
#file:src/world/level_manager.cpp
#file:docs/SPEC.md
EnemyAI emits "enemy_died" when health reaches 0, but no system listens to it.
LevelManager needs to track remaining enemies and emit "all_enemies_defeated"
when the count reaches zero (SPEC §6.3).

## Objective
Add auto_register_enemies() to LevelManager that runs in _ready() (deferred).
It finds all EnemyAI nodes in the scene tree, calls register_enemy() for each,
and connects their "enemy_died" signal to enemy_defeated(). When
enemies_remaining hits 0, emit "all_enemies_defeated".

## Rules
- Use call_deferred for auto_register_enemies() so all nodes are initialized.
- Null-check each found node before connecting signals.
- Store enemies_remaining as an int property exposed to the editor.
- The "all_enemies_defeated" signal must include zero parameters.
- Do not modify EnemyAI — only connect to its existing signals from LevelManager.

## Examples
Expected LevelManager additions:
  void LevelManager::auto_register_enemies() {
      TypedArray<Node> enemies = get_tree()->get_nodes_in_group("enemies");
      for (int i = 0; i < enemies.size(); i++) {
          EnemyAI *enemy = Object::cast_to<EnemyAI>(enemies[i]);
          if (enemy) {
              register_enemy(enemy);
          }
      }
  }

  void LevelManager::enemy_defeated() {
      enemies_remaining--;
      if (enemies_remaining <= 0) {
          emit_signal("all_enemies_defeated");
      }
  }

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.8.2: add auto_register_enemies()
to LevelManager, connect enemy_died signals, emit all_enemies_defeated on zero.
#file:src/world/level_manager.hpp
#file:src/world/level_manager.cpp
#file:src/ai/enemy_ai.hpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: kill all enemies → "all_enemies_defeated" signal fires.
```

**Phase 2 Build Gate:**

```powershell
cmake --build visualstudio/vs2026-x64 --config Debug
# Verify: sprint drains stamina, E key only hits interaction layer,
# kill enemy → objective text updates with remaining count
```

---

### Phase 3: New Features

---

#### Task 1.6.4 — Implement Fall Damage (2h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan implementing fall damage in PlayerController via DamageSystem.

## Context
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/combat/damage_system.hpp
#file:src/combat/damage_system.cpp
#file:docs/SPEC.md
SPEC §4.5 requires fall damage: falls greater than 5 meters deal damage
proportional to distance. DamageSystem has a FALL damage type. PlayerController
needs to track the Y position when leaving the ground and calculate distance
on landing.

## Objective
Add fall tracking (fall_start_y, is_falling) to PlayerController. On landing,
calculate fall distance. If distance > fall_damage_min_distance (default 5.0m),
apply damage via DamageSystem using damage type FALL. Expose
fall_damage_min_distance and fall_damage_multiplier as editor properties.

## Rules
- Depends on Task 1.6.1 (DamageSystem range falloff) being complete.
- Use is_on_floor() to detect landing — record fall_start_y when leaving floor.
- Apply damage = (fall_distance - fall_damage_min_distance) * fall_damage_multiplier.
- Use std::clamp to prevent negative damage.
- Guard against false triggers on stairs/slopes: only trigger if vertical distance
  exceeds the threshold. Consider adding a slope angle check if needed.
- Group properties under ADD_GROUP("Fall Damage", "fall_damage_").

## Examples
Expected flow:
  // In _physics_process:
  if (was_on_floor && !is_on_floor()) {
      fall_start_y = get_global_position().y;
      is_falling = true;
  }
  if (!was_on_floor && is_on_floor() && is_falling) {
      float fallDist = fall_start_y - get_global_position().y;
      if (fallDist > fall_damage_min_distance) {
          float dmg = (fallDist - fall_damage_min_distance) * fall_damage_multiplier;
          damage_system->apply_damage(this, std::clamp(dmg, 0.0f, 100.0f),
                                      DamageSystem::FALL, nullptr, 0);
      }
      is_falling = false;
  }
  was_on_floor = is_on_floor();

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.6.4: add fall tracking to
PlayerController, apply FALL damage via DamageSystem on landing after > 5m fall.
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/combat/damage_system.hpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: fall from height > 5m → health decreases, short falls → no damage.
```

---

#### Task 1.7.2 — Crouch Collision Shape (3h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan implementing crouch collision shape adjustment with ceiling detection.

## Context
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/camera/third_person_camera.hpp
#file:docs/SPEC.md
SPEC §4.3 requires crouching to reduce the capsule height and prevent
uncrouching when under low geometry. Currently crouch only changes speed —
the collision shape stays full height, letting the player clip through geometry.

## Objective
On crouch: reduce CollisionShape3D capsule height (e.g., 1.8 → 0.9), adjust
camera pivot Y downward. On uncrouch: raycast upward to check for ceiling
clearance; if blocked, stay crouched. Expose standing_height, crouch_height,
and camera_crouch_offset as editor properties.

## Rules
- Depends on Task 1.7.1 (sprint-stamina wiring) being complete.
- Ceiling raycast only fires on uncrouch REQUEST, not every frame (performance).
- Null-check the CollisionShape3D node before modifying it.
- Camera pivot offset should use Math::lerp for smooth transition over ~0.2s.
- Group properties under ADD_GROUP("Crouch", "crouch_").
- Do not modify ThirdPersonCamera internals — only adjust the pivot node Y position.

## Examples
Expected uncrouch check:
  bool PlayerController::can_uncrouch() {
      // Raycast from crouch position upward by (standing_height - crouch_height)
      PhysicsDirectSpaceState3D *space = get_world_3d()->get_direct_space_state();
      Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(
          get_global_position(),
          get_global_position() + Vector3(0, standing_height - crouch_height, 0));
      query->set_exclude({get_rid()});
      Dictionary result = space->intersect_ray(query);
      return result.is_empty();  // true = safe to stand
  }

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.7.2: adjust capsule height
on crouch, add ceiling raycast for uncrouch, adjust camera pivot Y.
#file:src/player/player_controller.hpp
#file:src/player/player_controller.cpp
#file:src/camera/third_person_camera.hpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: crouch under obstacle → stays crouched, open area → uncrouches normally.
```

**Phase 3 Build Gate:**

```powershell
cmake --build visualstudio/vs2026-x64 --config Debug
# Verify: fall from height → damage, crouch under obstacle → stays crouched
```

---

### Phase 4: Cleanup + Validation

---

#### Task 1.8.1 — AI Weapon Reload (1h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan adding ammo check and reload to EnemyAI::perform_attack().

## Context
#file:src/ai/enemy_ai.hpp
#file:src/ai/enemy_ai.cpp
#file:src/combat/weapon.hpp
#file:docs/SPEC.md
SPEC §6.2 requires AI enemies to reload their weapons. Currently EnemyAI
calls perform_attack() without checking ammo, leading to infinite firing.
The Weapon class already has start_reload() and get_current_ammo().

## Objective
At the top of perform_attack(), check if the equipped weapon has ammo.
If current_ammo == 0, call weapon->start_reload() and return early (skip
the attack this frame). The AI resumes attacking once reload completes.

## Rules
- Null-check the weapon pointer before accessing ammo.
- Do not add a reload timer to EnemyAI — use Weapon's existing reload mechanism.
- If the reload change breaks encounter pacing, it should be easily revertable
  (keep the change minimal and isolated to perform_attack).
- Do not change the Weapon class.

## Examples
Expected perform_attack() addition:
  void EnemyAI::perform_attack() {
      if (!weapon) return;
      if (weapon->get_current_ammo() <= 0) {
          weapon->start_reload();
          return;  // Skip attack this frame, wait for reload
      }
      // ... existing attack logic
  }

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.8.1: add ammo check +
start_reload() call at top of EnemyAI::perform_attack().
#file:src/ai/enemy_ai.hpp
#file:src/ai/enemy_ai.cpp
#file:src/combat/weapon.hpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: AI stops firing when out of ammo, reloads, then resumes.
```

---

#### Task 1.9.1 — Gate Debug Logging (2h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan creating debug_macros.hpp and gating all verbose logging.

## Context
#file:src/core/game_manager.hpp
#file:src/player/player_controller.cpp
#file:src/combat/damage_system.cpp
#file:src/ai/enemy_ai.cpp
Multiple source files use UtilityFunctions::print() for per-frame debug logging
that floods the console in release builds. SPEC §9.1 requires verbose logging
to be gated behind a debug flag.

## Objective
Create src/core/debug_macros.hpp with a US_LOG_VERBOSE() macro that wraps
UtilityFunctions::print() behind an OS::get_singleton()->is_debug_build() check.
Replace all per-frame verbose print calls across the codebase with US_LOG_VERBOSE().
Keep one-time initialization prints (e.g., in _ready) as regular prints.

## Rules
- The macro must short-circuit: zero overhead when is_debug_build() returns false.
- Use #ifndef/#define/#endif include guard matching project style.
- The macro must live in namespace godot or use fully qualified names.
- Only replace per-frame prints (_process, _physics_process, handle_movement, etc.).
- Do not replace error/warning prints or one-time initialization prints.
- Add debug_macros.hpp to CMakeLists.txt if the build requires explicit header listing.

## Examples
debug_macros.hpp:
  #ifndef URBAN_SURVIVOR_DEBUG_MACROS_HPP
  #define URBAN_SURVIVOR_DEBUG_MACROS_HPP

  #include <godot_cpp/classes/os.hpp>
  #include <godot_cpp/variant/utility_functions.hpp>

  #define US_LOG_VERBOSE(...)                                       \
      do {                                                          \
          if (godot::OS::get_singleton()->is_debug_build()) {       \
              godot::UtilityFunctions::print(__VA_ARGS__);          \
          }                                                         \
      } while (0)

  #endif // URBAN_SURVIVOR_DEBUG_MACROS_HPP

Replacement example:
  // Before (per-frame):
  UtilityFunctions::print("Player position: ", get_global_position());
  // After:
  US_LOG_VERBOSE("Player position: ", get_global_position());

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.9.1: create
src/core/debug_macros.hpp with US_LOG_VERBOSE macro, replace per-frame
verbose prints across all source files.
#file:src/core/debug_macros.hpp (new file)
#file:src/player/player_controller.cpp
#file:src/combat/damage_system.cpp
#file:src/ai/enemy_ai.cpp
Build with: cmake --build visualstudio/vs2026-x64 --config Debug
Verify: release build has minimal console output, debug build still logs.
```

**Phase 4 Build Gate:**

```powershell
cmake --build visualstudio/vs2026-x64 --config Debug
# Quick verify: AI reloads, release build has minimal console output
```

---

#### Task 1.9.2 — End-to-End Smoke Test (3h)

**Planning Prompt** — paste into `/cpp-planner`:

```
/cpp-planner Plan an end-to-end smoke test covering all M1.5 hardening changes.

## Context
#file:docs/M1_5_HARDENING_WORKFLOW.md
#file:docs/SPEC.md
#file:docs/MEMORY.md
All 11 implementation tasks (1.6.1–1.9.1) are complete. This task produces
a structured test checklist that validates every change from Milestone 1.5
in a single play session.

## Objective
Create an 18-point smoke test checklist covering:
- Magazine capacity (7 rounds)
- Damage signal includes hit_zone
- Reload signal timing
- Tiered range falloff at 4 distances
- Sprint → stamina drain + exhaustion
- Jump stamina cost
- Interaction mask (only hits layer 6)
- Enemy → LevelManager death tracking
- Fall damage above 5m threshold
- Crouch collision + ceiling detection
- AI weapon reload behavior
- Debug log gating in release
Document results in docs/MEMORY.md under "M1.5 Hardening Results".

## Rules
- Depends on ALL previous tasks being complete.
- Each checklist item must have: test action, expected result, pass/fail column.
- Test must be reproducible from a clean game launch.
- Any failure should reference the task ID for targeted re-investigation.
- Update docs/PRODUCTION_PLAN.md M1.5 status to ✅ COMPLETE on full pass.

## Examples
Checklist format:
  | # | Test Action | Expected Result | Task | Pass? |
  |---|-------------|-----------------|------|-------|
  | 1 | Fire M1911 until empty | Empty after 7 shots | 1.6.2 | |
  | 2 | Check headshot console output | Shows hit_zone=1 | 1.6.3 | |
  | 3 | Reload and watch HUD ammo | Updates only after animation | 1.7.3 | |
  ...

use context7
```

**Engineering Prompt** — paste into `/cpp-engineer` after plan approval:

```
/cpp-engineer Implement the approved plan for Task 1.9.2: create the 18-point
smoke test checklist, execute it, and document results in docs/MEMORY.md.
Update docs/PRODUCTION_PLAN.md M1.5 status to complete if all tests pass.
#file:docs/MEMORY.md
#file:docs/PRODUCTION_PLAN.md
#file:docs/M1_5_HARDENING_WORKFLOW.md
```

---

### Post-Completion — Closing the SDLC Loop

After all 12 tasks pass the smoke test, close the Agentic SDLC loop:

```
/sprint-planner All M1.5 Hardening tasks are complete and verified.
Update PRODUCTION_PLAN.md to mark Milestone 1.5 as ✅ COMPLETE.
Summarize what was accomplished and recommend the next milestone to start.
#file:docs/PRODUCTION_PLAN.md
#file:docs/MEMORY.md
```

This brings the loop back to the Sprint Planner, which updates the roadmap
and selects the next milestone — completing the full Agentic SDLC cycle.

---

### CORE Framework Quick Reference for Prompt Authors

When writing new task prompts for future milestones, follow this template:

```markdown
/cpp-planner Plan {verb} {target feature} in {module}.

## Context
#file:{primary_header}
#file:{primary_source}
#file:docs/SPEC.md
{1-3 sentences grounding the agent: what exists today, what SPEC section applies,
what decisions from MEMORY.md are relevant.}

## Objective
{Single measurable goal. What changes, what the acceptance criteria are.}

## Rules
- {Guardrail 1: what NOT to do}
- {Guardrail 2: dependency on other tasks}
- {Guardrail 3: Godot/MSVC constraint}
- {Guardrail 4: performance or safety concern}

## Examples
{Before/after code with line references. Concrete, copy-pasteable.}

use context7
```

Each element maps directly to the CORE acronym:

| Element | Maps To | Why It Matters |
|---------|---------|----------------|
| `## Context` | **C** — Context | Prevents hallucinated file paths, wrong API versions, missed decisions |
| `## Objective` | **O** — Objective | One goal = one plan = no scope creep |
| `## Rules` | **R** — Rules | Blocks the top failure modes for this specific task |
| `## Examples` | **E** — Examples | Anchors the agent to exact code patterns, not guesses |
