---
mode: 'agent'
description: 'Task 1.8.1 — Add ammo check and reload trigger to EnemyAI::perform_attack() for weapon-based enemies.'
---

# Context

You are the enemy AI specialist for Urban Survivor.
This is **Task 1.8.1** of Milestone 1.5 (Hardening) — Phase 4 Cleanup.

**Load these files before making changes:**
- #file:src/ai/enemy_ai.hpp
- #file:src/ai/enemy_ai.cpp (perform_attack method, lines ~459-491)
- #file:src/combat/weapon.hpp (can_fire, can_reload, start_reload)

**Current state:** `perform_attack()` already uses the Weapon system (`equipped_weapon->fire()`)
with an AI accuracy spread penalty, and falls back to melee if no weapon. However, when the
weapon runs out of ammo, the AI falls through to melee instead of reloading. This means
Raider enemies (who have ranged weapons) switch to melee permanently after their first magazine.

# Objective

Add an ammo check at the top of `perform_attack()`: if the weapon can't fire but CAN reload,
trigger `start_reload()` and skip the current attack cycle. This creates a vulnerable reload
window — the AI misses one attack cycle while reloading.

# Rules

- Insert the check BEFORE the existing weapon fire logic.
- Do NOT change the existing weapon fire or melee fallback logic.
- Only call `start_reload()` if `can_reload()` returns true (has reserve ammo).
- The weapon's reload timer will complete asynchronously — no special timer needed in EnemyAI.
- After reloading, the next `perform_attack()` call will find `can_fire() == true` and fire normally.

# Example — Current perform_attack() top (lines 459-468)

```cpp
void EnemyAI::perform_attack() {
    attack_timer = attack_cooldown;
    emit_signal("attack_performed");

    if (!target) {
        return;
    }

    // If enemy has a weapon, use it
    if (equipped_weapon && equipped_weapon->can_fire()) {
```

# Example — After (insert ammo check block)

```cpp
void EnemyAI::perform_attack() {
    attack_timer = attack_cooldown;
    emit_signal("attack_performed");

    if (!target) {
        return;
    }

    // If weapon is out of ammo, trigger reload and skip this attack cycle
    if (equipped_weapon && !equipped_weapon->can_fire() && equipped_weapon->can_reload()) {
        equipped_weapon->start_reload();
        return;
    }

    // If enemy has a weapon, use it
    if (equipped_weapon && equipped_weapon->can_fire()) {
```

# Steps

1. Open `src/ai/enemy_ai.cpp`.
2. Locate `perform_attack()` (around line 459).
3. Insert the ammo check block between the `!target` guard and the weapon fire block.
4. Build: `cmake --build build --config Debug`.
5. Test with a Raider enemy.

# Acceptance Criteria

- [ ] Raider enemy fires until magazine empty.
- [ ] When magazine empty, AI triggers `start_reload()` instead of switching to melee.
- [ ] AI skips one attack cycle during reload (brief vulnerable window).
- [ ] After reload completes, AI resumes firing with replenished ammo.
- [ ] Scavenger enemy (no weapon) still falls through to melee attack.
- [ ] Build succeeds.

# Test Plan

1. Build Debug, open Godot.
2. Observe a Raider enemy in Zone 2 attacking.
3. Count shots — should fire magazine, then pause briefly (reload), then resume firing.
4. Watch for Weapon debug lines during reload pause — no lines (not firing).
5. After reload completes — debug lines resume (firing again).

# Handoff

? When complete ? invoke `/hardening-gate-debug-logging` (Task 1.9.1)
