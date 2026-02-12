---
mode: 'agent'
description: 'Task 1.7.3 — Fix premature weapon_reloaded signal by wiring it to Weapon::reload_finished instead of emitting on R press.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.7.3** of Milestone 1.5 (Hardening) — Phase 1 Quick Fix.

**Load these files before making changes:**
- #file:src/player/player_controller.hpp
- #file:src/player/player_controller.cpp
- #file:src/combat/weapon.hpp (reload_finished signal)
- #file:src/combat/weapon.cpp (reload state machine)

**Current state:** `PlayerController::reload()` emits `weapon_reloaded` signal immediately when
R is pressed — BEFORE the reload timer completes and ammo is transferred. This gives false
information to any subscriber (HUD, game logic) listening for reload completion.

# Objective

Move the `weapon_reloaded` signal emission to fire ONLY after `Weapon::reload_finished` signal
is received, meaning ammo has actually been transferred.

# Rules

- Do NOT change the Weapon class — it already emits `reload_finished` correctly.
- Add a new private method `on_reload_finished()` to PlayerController.
- Register it with `ClassDB::bind_method` so it can be used as a Callable target.
- Connect the signal in `_ready()` alongside the existing `weapon_recoil` connection.
- Guard against double-connection with `is_connected()` check.

# Steps

1. In `player_controller.hpp`, add private method declaration:
   ```cpp
   void on_reload_finished();
   ```
2. In `player_controller.cpp` `_bind_methods()`, register the method:
   ```cpp
   ClassDB::bind_method(D_METHOD("on_reload_finished"), &PlayerController::on_reload_finished);
   ```
3. In `_ready()`, after the `weapon_recoil` connection block, add:
   ```cpp
   if (!equipped_weapon->is_connected("reload_finished", Callable(this, "on_reload_finished"))) {
       equipped_weapon->connect("reload_finished", Callable(this, "on_reload_finished"));
   }
   ```
4. Add the handler implementation:
   ```cpp
   void PlayerController::on_reload_finished() {
       emit_signal("weapon_reloaded");
   }
   ```
5. In `reload()`, REMOVE the `emit_signal("weapon_reloaded")` line.
6. Build and test.

# Acceptance Criteria

- [ ] Pressing R does NOT immediately emit `weapon_reloaded`.
- [ ] After reload timer completes ? `weapon_reloaded` signal fires.
- [ ] Cancelling reload mid-way ? no `weapon_reloaded` emitted.
- [ ] HUD ammo counter updates correctly (after ammo transfers, not before).
- [ ] Build succeeds with no warnings.

# Test Plan

1. Build Debug, open Godot.
2. Fire some shots, press R to reload.
3. Watch Godot output — `weapon_reloaded` should appear AFTER reload timer completes, not immediately.
4. Start reload, press fire to cancel — no `weapon_reloaded` emitted.

# Handoff

? When complete ? **Build Phase 1** ? then start Phase 2 with `/hardening-fix-range-falloff` (Task 1.6.1)
