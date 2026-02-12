---
mode: 'agent'
description: 'Task 1.8.2 — Auto-wire EnemyAI enemy_died signals to LevelManager enemy_defeated counter with all_enemies_defeated signal.'
---

# Context

You are the enemy AI specialist for Urban Survivor.
This is **Task 1.8.2** of Milestone 1.5 (Hardening) — Phase 2 System Wiring.

**Load these files before making changes:**
- #file:src/world/level_manager.hpp
- #file:src/world/level_manager.cpp
- #file:src/ai/enemy_ai.hpp (enemy_died signal)
- #file:src/ai/enemy_ai.cpp (take_damage ? emit enemy_died)
- #file:docs/ARCHITECTURE.md (System Hierarchy — LevelManager)

**Current state:** `EnemyAI` emits `enemy_died` signal on death (line 579 of enemy_ai.cpp).
`LevelManager` has `register_enemy()` and `enemy_defeated()` methods. But NOTHING connects
them — `enemies_remaining` is always 0 and never changes.

# Objective

1. Add `auto_register_enemies()` to LevelManager that finds all EnemyAI nodes in the scene
   and connects their `enemy_died` signals to `enemy_defeated()`.
2. Add `all_enemies_defeated` signal that fires when `enemies_remaining` reaches 0.
3. Call `auto_register_enemies()` deferred from `_ready()`.

# Rules

- Use `call_deferred()` for registration so all nodes are in the tree.
- Include `enemy_ai.hpp` in `level_manager.cpp`.
- Use a recursive helper to find all EnemyAI nodes in the scene tree.
- Guard against double-connection with `is_connected()`.
- Add the helper as a private method, not exposed to GDScript.
- `enemy_defeated()` must be bound in `_bind_methods()` since it's a signal callback target.
- Add `all_enemies_defeated` signal to `_bind_methods()`.

# Steps

1. In `level_manager.hpp`, add:
   - Private method: `void _find_enemies(Node* node, Array& results);`
   - Public method: `void auto_register_enemies();`
   - Signal comment: `// all_enemies_defeated()`

2. In `level_manager.cpp`:
   - Add `#include "../ai/enemy_ai.hpp"` at top.
   - Add `ADD_SIGNAL(MethodInfo("all_enemies_defeated"))` in `_bind_methods()`.
   - Bind `auto_register_enemies` method.
   - Implement `_find_enemies()` — recursive scan for EnemyAI nodes.
   - Implement `auto_register_enemies()` — iterate results, `register_enemy()`, connect signals.
   - Update `enemy_defeated()` — add `all_enemies_defeated` emit when count reaches 0.
   - Update `_ready()` — add `call_deferred("auto_register_enemies")`.

3. Build and test.

# Acceptance Criteria

- [ ] On level start, LevelManager prints "registered N enemies" (should be 8 for Level 1).
- [ ] Killing an enemy ? `enemies_remaining` decrements, `objective_updated` fires.
- [ ] Killing all enemies ? `all_enemies_defeated` signal fires.
- [ ] `enemy_defeated()` is safe to call multiple times (clamped to 0).
- [ ] Build succeeds.

# Test Plan

1. Build Debug, open Godot, press F5.
2. Check output: "LevelManager: registered 8 enemies" (5 Zone 2 + 3 Zone 3).
3. Kill one enemy ? output shows "Enemies remaining: 7".
4. Kill all enemies ? output shows "All enemies defeated!".

# Handoff

? When complete ? **Build Phase 2** ? then start Phase 3 with `/hardening-implement-fall-damage` (Task 1.6.4)
