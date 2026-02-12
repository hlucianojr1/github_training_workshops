---
mode: 'agent'
description: 'Task 1.7.4 — Replace 0xFFFFFFFF interaction collision mask with a dedicated editor-configurable property.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.7.4** of Milestone 1.5 (Hardening) — Phase 2 System Wiring.

**Load these files before making changes:**
- #file:src/player/player_controller.hpp
- #file:src/player/player_controller.cpp (interact() method)
- #file:docs/CODING_STANDARDS.md

**Current state:** `PlayerController::interact()` uses `query->set_collision_mask(0xFFFFFFFF)`
which hits ALL physics layers — projectiles, triggers, AI navigation, everything. This causes
false positive interactions with unrelated physics bodies.

# Objective

Add an `interaction_collision_mask` property to PlayerController, expose it to the Godot editor
with `PROPERTY_HINT_LAYERS_3D_PHYSICS`, and use it in the interaction raycast.

# Rules

- Default mask should be `1` (layer 1 only) — safe default.
- Use `PROPERTY_HINT_LAYERS_3D_PHYSICS` for checkbox-style layer editing in inspector.
- Add getter/setter as inline methods in the header.
- Replace the `0xFFFFFFFF` in `interact()` with the new member.

# Steps

1. In `player_controller.hpp`, add private member after `interaction_range`:
   ```cpp
   uint32_t interaction_collision_mask = 1;
   ```
2. In `player_controller.hpp`, add public getter/setter:
   ```cpp
   void set_interaction_collision_mask(uint32_t mask) { interaction_collision_mask = mask; }
   uint32_t get_interaction_collision_mask() const { return interaction_collision_mask; }
   ```
3. In `player_controller.cpp` `_bind_methods()`, add property binding:
   ```cpp
   ClassDB::bind_method(D_METHOD("set_interaction_collision_mask", "mask"), &PlayerController::set_interaction_collision_mask);
   ClassDB::bind_method(D_METHOD("get_interaction_collision_mask"), &PlayerController::get_interaction_collision_mask);
   ADD_PROPERTY(PropertyInfo(Variant::INT, "interaction_collision_mask", PROPERTY_HINT_LAYERS_3D_PHYSICS), "set_interaction_collision_mask", "get_interaction_collision_mask");
   ```
4. In `interact()`, replace `query->set_collision_mask(0xFFFFFFFF)` with:
   ```cpp
   query->set_collision_mask(interaction_collision_mask);
   ```
5. Build and test.

# Acceptance Criteria

- [ ] `interaction_collision_mask` appears in PlayerController inspector as layer checkboxes.
- [ ] Default is layer 1 only.
- [ ] E key interaction works with ScavengePoint on matching layer.
- [ ] E key near non-interactable physics body ? no interaction.
- [ ] Build succeeds.

# Test Plan

1. Build Debug, open Godot, select PlayerController in scene.
2. Verify `interaction_collision_mask` appears in inspector with layer checkboxes.
3. Set it to match ScavengePoint's physics layer.
4. Press E near ScavengePoint ? interaction works.
5. Press E near a plain StaticBody3D on a different layer ? no interaction.

# Handoff

? When complete ? invoke `/hardening-wire-enemy-levelmanager` (Task 1.8.2)
