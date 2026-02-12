---
mode: 'agent'
description: 'Task 1.7.2 — Implement crouch collision shape adjustment with ceiling detection to prevent uncrouching under geometry.'
---

# Context

You are the combat systems specialist for Urban Survivor.
This is **Task 1.7.2** of Milestone 1.5 (Hardening) — Phase 3 New Feature.

**Load these files before making changes:**
- #file:src/player/player_controller.hpp
- #file:src/player/player_controller.cpp
- #file:docs/SPEC.md (Section 3.1: Movement — crouch speed 2.5 m/s)
- #file:docs/MEMORY.md (search "Savage Character Integration" for collision shape specs)

**Current state:** `toggle_crouch()` flips `is_crouching` flag but has a `// TODO: Adjust collision shape height for crouching` comment. The hitbox stays at standing height (1.75m capsule).

# Objective

1. Store the CollisionShape3D reference in `_ready()`.
2. On crouch: shrink capsule from 1.75m ? 1.0m, adjust Y offset and camera pivot.
3. On uncrouch: raycast upward to check for ceiling before standing up.

# Rules

- Only raycast when UNCROUCHING, not every frame.
- If ceiling blocks uncrouch, stay crouched (return early, do not toggle).
- Add new includes: `collision_shape3d.hpp`, `capsule_shape3d.hpp`.
- Store standing height/offset as members (not hardcoded in toggle logic).
- Camera pivot Y should adjust proportionally: standing = `height × 0.85`, crouching = `height × 0.85`.
- Use `ERR_FAIL_NULL()` guards on collision_shape and capsule.

# Steps

1. In `player_controller.hpp`, add private members:
   ```cpp
   class CollisionShape3D* collision_shape = nullptr;
   float standing_height = 1.75f;
   float crouch_height = 1.0f;
   ```
2. In `player_controller.cpp`, add includes at top:
   ```cpp
   #include <godot_cpp/classes/collision_shape3d.hpp>
   #include <godot_cpp/classes/capsule_shape3d.hpp>
   ```
3. In `_ready()`, find the collision shape:
   ```cpp
   collision_shape = Object::cast_to<CollisionShape3D>(get_node_or_null(NodePath("CollisionShape3D")));
   ```
4. Replace `toggle_crouch()` with the full implementation that:
   - On uncrouch attempt: raycasts upward from crouch height to standing height.
   - If blocked: returns without toggling.
   - If clear: restores standing capsule height and camera.
   - On crouch: shrinks capsule and lowers camera.
5. Build and test.

# Acceptance Criteria

- [ ] Pressing Ctrl ? capsule shrinks to 1.0m, camera lowers.
- [ ] Pressing Ctrl again (in open space) ? capsule restores to 1.75m, camera raises.
- [ ] Crouching under low geometry, then pressing Ctrl ? stays crouched (ceiling blocked).
- [ ] Moving out from under obstacle, pressing Ctrl ? successfully uncrouches.
- [ ] Enemy raycast at standing head height ? misses crouched player.
- [ ] No per-frame physics queries for ceiling detection.

# Test Plan

1. Build Debug, open Godot.
2. Stand in open area ? Ctrl to crouch ? camera lowers, capsule visible in debug.
3. Ctrl again ? stands up normally.
4. Find/place a low ceiling (1.2m) ? crouch under it ? Ctrl to uncrouch ? stays crouched.
5. Walk out from under ceiling ? Ctrl ? successfully stands.

# Handoff

? When complete ? **Build Phase 3** ? then invoke `/hardening-ai-weapon-reload` (Task 1.8.1)
