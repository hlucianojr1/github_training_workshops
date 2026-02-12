---
mode: 'agent'
description: 'Task 1.9.2 — Execute 18-point end-to-end smoke test of the full Milestone 1.5 hardened gameplay loop and document results.'
---

# Context

You are the code reviewer for Urban Survivor.
This is **Task 1.9.2** of Milestone 1.5 (Hardening) — Final Validation.

**Prerequisites:** ALL other M1.5 tasks (1.6.1–1.6.4, 1.7.1–1.7.4, 1.8.1–1.8.2, 1.9.1) must be completed and building.

**Load these files for reference:**
- #file:docs/SPEC.md (expected behavior for each system)
- #file:docs/MEMORY.md (append results here)
- #file:docs/M1_5_HARDENING_WORKFLOW.md (task definitions and acceptance criteria)
- #file:src/combat/weapon.hpp (verify mag_capacity = 7)
- #file:src/combat/damage_system.cpp (verify tiered falloff)
- #file:src/player/player_controller.cpp (verify sprint wiring, fall damage, crouch)

# Objective

Execute a structured 18-point gameplay test covering every M1.5 change.
Document pass/fail results as a MEMORY.md entry.

# Rules

- Build BOTH Debug and Release before testing.
- Test in Debug first (verbose logging helps diagnose failures).
- Test Release for logging verification only (point 18).
- Document ALL results — pass or fail — in MEMORY.md.
- If a test fails, note the symptom and which task likely regressed.

# Smoke Test Checklist

Execute in order. Each test builds on previous state.

| # | Area | Test | Expected Result | Pass? |
|---|------|------|-----------------|-------|
| 1 | Spawn | Player appears in Zone 1 | HUD: 100 HP, 100 Stamina, **7**/24 ammo | ? |
| 2 | Sprint | Hold Shift to sprint | Stamina bar drains at ~15/sec | ? |
| 3 | Exhaustion | Sprint until stamina = 0 | Speed drops to walk, HUD pulses at 20% | ? |
| 4 | Recovery | Release Shift, wait | Stamina regens, recovery at ~30% threshold | ? |
| 5 | Jump Stamina | Jump 10× rapidly | Stamina decreases by ~50 (5 per jump) | ? |
| 6 | Crouch | Press Ctrl | Camera lowers, hitbox shrinks to ~1.0m | ? |
| 7 | Crouch Block | Crouch under low geo, press Ctrl | Stays crouched (ceiling blocked) | ? |
| 8 | Magazine | Fire M1911 counting shots | Empty after 7 shots, HUD ammo flash | ? |
| 9 | Reload Signal | Press R, observe timing | `weapon_reloaded` fires AFTER timer, not on R press | ? |
| 10 | Close Damage | Shoot enemy at < 50% range | 1.0× falloff ? full damage applied | ? |
| 11 | Far Damage | Shoot enemy at > 75% range | 0.5× falloff ? reduced damage | ? |
| 12 | Headshot | Aim for head | 2.5× multiplier, `damage_dealt` has hit_zone=HEAD | ? |
| 13 | Enemy Death | Kill one enemy | `enemy_died` ? LevelManager objective updates | ? |
| 14 | All Enemies | Kill all zone enemies | `all_enemies_defeated` fires, objective shows 0 | ? |
| 15 | Player Death | Take lethal damage | Input disabled, `player_died` fires, game_over | ? |
| 16 | Fall Damage | Fall from ~8m height | ~30 damage, HUD health flash | ? |
| 17 | Level Exit | Walk to subway exit (z ? -275) | `level_completed` signal fires | ? |
| 18 | Release Logs | Build Release, run | Minimal console output, no per-shot spam | ? |

# Steps

1. Build Debug:
   ```powershell
   cmake --build build --config Debug
   ```
2. Open Godot, load `game/project.godot`, press F5.
3. Execute tests 1–17 in order, noting results.
4. Build Release:
   ```powershell
   cmake --build build --config Release
   ```
5. Open Godot with Release DLL, execute test 18.
6. Document results in `docs/MEMORY.md`.

# MEMORY.md Entry Format

Append the following template to `docs/MEMORY.md`:

```markdown
### 2026-02-10: Milestone 1.5 Hardening — Smoke Test Results

**Decision**: [All passed / X of 18 passed, Y failed]

**Results**:
| # | Test | Result | Notes |
|---|------|--------|-------|
| 1 | Spawn | ?/? | ... |
...

**Failed Tests** (if any):
- Test N: [symptom] — likely regression in Task X.Y.Z

**Rationale**: M1.5 Hardening verified/partially verified. [Next steps if failures.]

**Files Touched**: docs/MEMORY.md (this entry)
```

# Acceptance Criteria

- [ ] All 18 tests executed and documented.
- [ ] 0 critical failures (tests 1, 8, 13, 15, 17 are critical).
- [ ] MEMORY.md updated with full results table.
- [ ] Any failures have clear notes and task attribution.

# Handoff

? When complete ? invoke `/update-docs` to update PRODUCTION_PLAN.md M1.5 status.
Then mark Milestone 1.5 as ? COMPLETE in docs/PRODUCTION_PLAN.md.
