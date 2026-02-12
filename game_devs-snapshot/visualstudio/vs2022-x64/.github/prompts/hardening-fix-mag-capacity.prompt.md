---
mode: 'agent'
description: 'Task 1.6.2 — Fix M1911 default magazine capacity from 8 to 7 per SPEC §4.3.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.6.2** of Milestone 1.5 (Hardening) — Phase 1 Quick Fix.

**Load these files before making changes:**
- #file:src/combat/weapon.hpp
- #file:docs/SPEC.md (Section 4.3: Item Definitions — M1911 Pistol)
- #file:docs/MEMORY.md (search for "spec says 7, using 8")

**Current state:** `weapon.hpp` line 51 has `mag_capacity = 8` and line 52 has `current_mag_ammo = 8`.
SPEC §4.3 defines the M1911 as a 7-round magazine weapon. MEMORY.md notes the deviation without justification.

# Objective

Change the default M1911 magazine capacity from 8 to 7 rounds to align with SPEC §4.3.

# Rules

- Only change the two default values in `weapon.hpp`.
- Do NOT change constructor logic in `weapon.cpp`.
- The `Weapon()` constructor sets `current_mag_ammo = mag_capacity` — verify this still works correctly.

# Example — Before

```cpp
// weapon.hpp lines 50-53
    String ammo_type = "ammo_45acp";
    int mag_capacity = 8;
    int current_mag_ammo = 8;
    int reserve_ammo = 24;
```

# Example — After

```cpp
    String ammo_type = "ammo_45acp";
    int mag_capacity = 7;
    int current_mag_ammo = 7;
    int reserve_ammo = 24;
```

# Steps

1. Open `src/combat/weapon.hpp`.
2. Change `mag_capacity = 8` ? `mag_capacity = 7` (line 51).
3. Change `current_mag_ammo = 8` ? `current_mag_ammo = 7` (line 52).
4. Verify `Weapon()` constructor in `weapon.cpp` — it sets `current_mag_ammo = mag_capacity`, which will now be 7. ?
5. Build: `cmake --build build --config Debug`.

# Acceptance Criteria

- [ ] `weapon.hpp` default `mag_capacity` is 7.
- [ ] `weapon.hpp` default `current_mag_ammo` is 7.
- [ ] Build succeeds with no warnings.
- [ ] In-game: fire M1911 — goes empty after 7 shots, not 8.

# Test Plan

1. Build Debug, open Godot, press F5.
2. Fire M1911 counting shots: 1, 2, 3, 4, 5, 6, 7 ? `weapon_empty` signal.
3. HUD ammo counter shows `7 / 24` at start.

# Handoff

? When complete ? invoke `/hardening-enrich-damage-signal` (Task 1.6.3)
