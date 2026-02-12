---
mode: 'agent'
description: 'Task 1.7.1 — Wire PlayerController sprint state to SurvivalStats stamina drain/regen system.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.7.1** of Milestone 1.5 (Hardening) — Phase 2 System Wiring.

**Load these files before making changes:**
- #file:src/player/player_controller.hpp
- #file:src/player/player_controller.cpp
- #file:src/survival/survival_stats.hpp (set_sprinting, can_sprint, drain_stamina)
- #file:src/survival/survival_stats.cpp (_process stamina logic)
- #file:docs/SPEC.md (Section 3.1: Movement — stamina costs)

**Current state:** `PlayerController::handle_movement()` checks `is_action_pressed("sprint")`
for speed calculation but NEVER calls `survival_stats->set_sprinting()`. The `can_sprint` flag
is always `true`. Stamina bar never depletes. Jump costs no stamina.

**SurvivalStats already implements:** `set_sprinting(bool)`, `can_sprint()`, `drain_stamina(float)`,
stamina drain at 15/sec, regen at 10/sec, exhaustion at 0, recovery at 30%.

# Objective

Wire `PlayerController::handle_movement()` to call `SurvivalStats` every frame so that:
1. Sprint actually drains stamina.
2. `can_sprint` reflects exhaustion state.
3. Jump costs 5 stamina per SPEC §3.1.

# Rules

- Add wiring code at the TOP of `handle_movement()`, after `input_direction` read, BEFORE gravity.
- Do NOT modify `SurvivalStats` — it already has all the methods needed.
- Do NOT change `get_current_speed()` — it already reads `can_sprint`.
- Null-check `survival_stats` before every call.
- Sprint should be blocked while aiming (`is_aiming`) or crouching (`is_crouching`).

# Example — Current handle_movement() top (lines 189-204)

```cpp
void PlayerController::handle_movement(double delta) {
    Input* input = Input::get_singleton();
    input_direction = input->get_vector("move_left", "move_right", "move_forward", "move_backward");

    Vector3 velocity = get_velocity();
    if (!is_on_floor()) {
        velocity.y -= gravity * delta;
    }

    if (input->is_action_just_pressed("jump") && is_on_floor()) {
        velocity.y = jump_velocity;
    }
```

# Example — After (insert between input_direction and gravity)

```cpp
void PlayerController::handle_movement(double delta) {
    Input* input = Input::get_singleton();
    input_direction = input->get_vector("move_left", "move_right", "move_forward", "move_backward");

    // Wire sprint state to SurvivalStats
    if (survival_stats) {
        bool wants_sprint = input->is_action_pressed("sprint") && !is_aiming && !is_crouching;
        survival_stats->set_sprinting(wants_sprint && survival_stats->can_sprint());
        can_sprint = survival_stats->can_sprint();
    }

    Vector3 velocity = get_velocity();
    if (!is_on_floor()) {
        velocity.y -= gravity * delta;
    }

    // Handle jump — drain 5 stamina per SPEC §3.1
    if (input->is_action_just_pressed("jump") && is_on_floor()) {
        if (survival_stats) {
            survival_stats->drain_stamina(5.0f);
        }
        velocity.y = jump_velocity;
    }
```

# Steps

1. Open `src/player/player_controller.cpp`.
2. Locate `handle_movement()` (around line 189).
3. Insert the sprint wiring block between `input_direction` read and gravity application.
4. Add the `drain_stamina(5.0f)` call before `velocity.y = jump_velocity`.
5. Build: `cmake --build build --config Debug`.

# Acceptance Criteria

- [ ] Holding Shift to sprint ? stamina bar depletes at 15/sec.
- [ ] Sprint until exhausted ? `can_sprint` becomes false, speed drops to walk.
- [ ] Release Shift ? stamina regenerates at 10/sec.
- [ ] Exhaustion recovery triggers at 30% stamina ? `can_sprint` becomes true again.
- [ ] HUD stamina bar pulses warning at 20% (existing `is_low_stamina` logic).
- [ ] Jump costs 5 stamina ? 20 jumps ? 100 stamina consumed.
- [ ] Sprint blocked while aiming (right mouse held).
- [ ] Sprint blocked while crouching.

# Test Plan

1. Build Debug, open Godot, press F5.
2. Hold Shift — watch stamina bar drain.
3. Sprint until exhausted — player slows to walk speed.
4. Release Shift — stamina regenerates, bar refills.
5. Jump rapidly 20 times — stamina should drop ~100 points.
6. Hold right mouse (aim) + Shift — should NOT sprint.

# Handoff

? When complete ? invoke `/hardening-fix-interaction-mask` (Task 1.7.4)
