---
mode: 'agent'
description: 'Task 1.6.4 — Implement fall damage tracking in PlayerController using DamageType::FALL.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.6.4** of Milestone 1.5 (Hardening) — Phase 3 New Feature.

**Load these files before making changes:**
- #file:src/player/player_controller.hpp
- #file:src/player/player_controller.cpp
- #file:src/combat/damage_system.hpp (DamageType::FALL enum)
- #file:src/combat/damage_system.cpp (apply_damage method)
- #file:src/survival/survival_stats.hpp (take_damage, get_max_health)
- #file:docs/SPEC.md (Section 3.1: Player Movement)

**Current state:** `DamageType::FALL` exists in `DamageSystem` but is never triggered.
No Y-velocity tracking exists in `PlayerController`.

# Objective

Add fall damage detection to PlayerController: track airborne state, compute fall distance on landing, apply scaled damage through DamageSystem.

# Rules

- Only trigger fall damage on `was_in_air ? is_on_floor()` transitions.
- Falls ? 5m deal zero damage (jumping from ground should be safe).
- Falls > 5m deal `(distance - 5) × 10` damage.
- Falls ? 15m are lethal (apply max_health as damage).
- Use `DamageSystem::apply_damage()` with `DamageType::FALL` — do NOT call `take_damage()` directly.
- Add fall tracking members to the header, not local variables.
- Place the detection code AFTER `move_and_slide()` in `handle_movement()`.
- Do NOT trigger on slopes or stairs — only on air?ground transitions where fall_start_y > current_y.

# Steps

1. In `player_controller.hpp`, add private members:
   ```cpp
   bool was_in_air = false;
   float fall_start_y = 0.0f;
   float fall_damage_min_distance = 5.0f;
   float fall_damage_lethal_distance = 15.0f;
   float fall_damage_per_meter = 10.0f;
   ```
2. In `player_controller.cpp` `handle_movement()`, AFTER `move_and_slide()`, add:
   - If `!is_on_floor()` and `!was_in_air`: set `was_in_air = true`, record `fall_start_y`.
   - If `is_on_floor()` and `was_in_air`: compute `fall_distance = fall_start_y - get_global_position().y`.
     - If `fall_distance > fall_damage_min_distance`: apply damage via DamageSystem.
     - Reset `was_in_air = false`.
3. Include `damage_system.hpp` if not already included (it is — verify).
4. Build and test.

# Acceptance Criteria

- [ ] Jumping from ground (< 5m fall) ? zero damage.
- [ ] Falling ~8m ? ~30 damage applied via DamageSystem with DamageType::FALL.
- [ ] Falling ? 15m ? lethal damage (player dies).
- [ ] Walking down stairs ? no fall damage triggered.
- [ ] HUD health bar flashes red on fall damage (existing damage_taken signal wiring).
- [ ] Fall damage does NOT trigger when moving upward (ascending, fall_distance < 0).

# Test Plan

1. Build Debug, open Godot.
2. Jump from ground level ? no damage (fall_start_y ? current_y).
3. Find or place a platform ~8m high, walk off ? ~30 HP damage, HUD flash.
4. Find or place a platform ~16m high, walk off ? death, `player_died` signal.
5. Walk down a ramp ? no false positive fall damage.

# Handoff

? When complete ? invoke `/hardening-crouch-collision` (Task 1.7.2)
