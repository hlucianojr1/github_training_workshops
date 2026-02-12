---
mode: 'agent'
description: 'Task 1.6.1 — Replace linear distance falloff with SPEC §5.2 tiered damage curve in DamageSystem.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.6.1** of Milestone 1.5 (Hardening).

**Load these files before making changes:**
- #file:src/combat/damage_system.hpp
- #file:src/combat/damage_system.cpp
- #file:docs/SPEC.md (Section 5.2: Damage Calculation — Range Falloff)
- #file:docs/CODING_STANDARDS.md

**Current state:** `apply_distance_falloff()` uses a linear curve `1.0 - (distance / max_range)`.
This does NOT match the SPEC, which defines a 4-tier step function.

# Objective

Replace the linear falloff in `DamageSystem::apply_distance_falloff()` with the SPEC §5.2 tiered curve:

| Range % of max_range | Damage Multiplier |
|----------------------|-------------------|
| 0 – 50%             | 1.0×              |
| 50 – 75%            | 0.8×              |
| 75 – 100%           | 0.5×              |
| > 100%              | 0.25×             |

# Rules

- Do NOT change the method signature — `float apply_distance_falloff(float damage, float distance, float max_range) const`.
- Guard against `max_range <= 0` to avoid division by zero.
- The method must remain `const` with no side effects.
- Do not use `Vector3::ZERO` or any removed Godot 4.3 constants.
- Use `ERR_FAIL_COND_V(max_range <= 0.0f, damage)` as the guard.

# Example — Before (Current Code)

```cpp
// damage_system.cpp lines 97-105
float DamageSystem::apply_distance_falloff(float damage, float distance, float max_range) const {
    if (distance >= max_range) {
        return 0.0f;
    }
    // Linear falloff - could use quadratic or other curves
    float falloff = 1.0f - (distance / max_range);
    return damage * Math::max(0.0f, falloff);
}
```

# Example — After (Expected Code)

```cpp
float DamageSystem::apply_distance_falloff(float damage, float distance, float max_range) const {
    if (max_range <= 0.0f) {
        return damage;
    }

    float range_ratio = distance / max_range;

    // SPEC §5.2 tiered falloff
    float multiplier;
    if (range_ratio <= 0.5f) {
        multiplier = 1.0f;
    } else if (range_ratio <= 0.75f) {
        multiplier = 0.8f;
    } else if (range_ratio <= 1.0f) {
        multiplier = 0.5f;
    } else {
        multiplier = 0.25f;
    }

    return damage * multiplier;
}
```

# Steps

1. Open `src/combat/damage_system.cpp`.
2. Locate `apply_distance_falloff()` (around line 97).
3. Replace the method body with the tiered implementation above.
4. Build: `cmake --build build --config Debug`.
5. Verify: no compile errors.

# Acceptance Criteria

- [ ] `apply_distance_falloff(100, 10, 50)` ? 100 (20% range = 1.0×)
- [ ] `apply_distance_falloff(100, 30, 50)` ? 80 (60% range = 0.8×)
- [ ] `apply_distance_falloff(100, 40, 50)` ? 50 (80% range = 0.5×)
- [ ] `apply_distance_falloff(100, 60, 50)` ? 25 (120% range = 0.25×)
- [ ] `apply_distance_falloff(100, 10, 0)` ? 100 (guard: max_range = 0)
- [ ] Method signature unchanged, still `const`.

# Test Plan

1. Build Debug.
2. In test scene, place a target at 4 distances from player (M1911 range = 30m):
   - 10m ? expect full 25 damage (33% range)
   - 18m ? expect 20 damage (60% range)
   - 25m ? expect 12.5 damage (83% range)
   - 35m ? expect 6.25 damage (117% range)
3. Fire single shot at each, verify via `DamageSystem.damage_dealt` signal.

# Handoff

? When complete ? invoke `/hardening-wire-sprint-stamina` (Task 1.7.1)
