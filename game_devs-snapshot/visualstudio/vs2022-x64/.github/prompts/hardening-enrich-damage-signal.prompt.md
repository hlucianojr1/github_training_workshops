---
mode: 'agent'
description: 'Task 1.6.3 — Add hit_zone parameter to DamageSystem damage_dealt signal for HUD hitmarker support.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.6.3** of Milestone 1.5 (Hardening) — Phase 1 Quick Fix.

**Load these files before making changes:**
- #file:src/combat/damage_system.hpp
- #file:src/combat/damage_system.cpp
- #file:docs/ARCHITECTURE.md (Signal Architecture section)

**Current state:** `damage_dealt` signal emits `(target, amount, type, source)` — 4 params.
The HUD and future hitmarker system need the `hit_zone` to show headshot indicators.

# Objective

Add a 5th parameter `hit_zone` (int) to the `damage_dealt` signal so subscribers can distinguish HEAD/TORSO/LIMBS hits.

# Rules

- Godot ignores extra signal parameters when a subscriber expects fewer args — this is a safe additive change.
- Update the signal definition in `_bind_methods()` AND both `emit_signal` call sites.
- Do NOT change the `apply_damage()` method signature — it already accepts `hit_zone`.
- Verify `hud_controller.gd` or other GDScript subscribers still work (they will — Godot ignores extras).

# Example — Before

```cpp
// _bind_methods() signal definition
ADD_SIGNAL(MethodInfo("damage_dealt",
    PropertyInfo(Variant::OBJECT, "target"),
    PropertyInfo(Variant::FLOAT, "amount"),
    PropertyInfo(Variant::INT, "type"),
    PropertyInfo(Variant::OBJECT, "source")));

// emit sites (lines 202 and 211)
emit_signal("damage_dealt", target, final_damage, type_int, source);
```

# Example — After

```cpp
// _bind_methods() signal definition
ADD_SIGNAL(MethodInfo("damage_dealt",
    PropertyInfo(Variant::OBJECT, "target"),
    PropertyInfo(Variant::FLOAT, "amount"),
    PropertyInfo(Variant::INT, "type"),
    PropertyInfo(Variant::OBJECT, "source"),
    PropertyInfo(Variant::INT, "hit_zone")));

// emit sites (both occurrences)
emit_signal("damage_dealt", target, final_damage, type_int, source, hit_zone);
```

# Steps

1. Open `src/combat/damage_system.cpp`.
2. In `_bind_methods()`, add the 5th PropertyInfo to `damage_dealt` signal.
3. Find both `emit_signal("damage_dealt", ...)` calls (lines ~202 and ~211).
4. Add `hit_zone` as the 5th argument to both calls.
5. Build: `cmake --build build --config Debug`.
6. Verify no GDScript errors in Godot output.

# Acceptance Criteria

- [ ] `damage_dealt` signal definition includes `PropertyInfo(Variant::INT, "hit_zone")`.
- [ ] Both `emit_signal` calls pass `hit_zone` as 5th argument.
- [ ] Build succeeds.
- [ ] Existing GDScript subscribers (e.g., `hud_controller.gd`) still work without errors.
- [ ] Connecting to the signal with 5 params in GDScript receives hit_zone correctly.

# Test Plan

1. Build Debug, open Godot.
2. Add temporary GDScript subscriber: `DamageSystem.damage_dealt.connect(func(t,a,ty,s,hz): print("hit_zone=", hz))`.
3. Headshot ? prints `hit_zone=1` (HEAD enum).
4. Body shot ? prints `hit_zone=2` (TORSO enum).
5. Remove temporary test code.

# Handoff

? When complete ? invoke `/hardening-fix-reload-signal` (Task 1.7.3)
