---
mode: 'agent'
description: 'Task 1.9.1 — Create debug_macros.hpp and gate verbose per-frame/per-shot logging behind OS::is_debug_build().'
---

# Context

You are the Godot C++ GDExtension expert for Urban Survivor.
This is **Task 1.9.1** of Milestone 1.5 (Hardening) — Phase 4 Cleanup.

**Load these files to find verbose logging:**
- #file:src/combat/weapon.cpp (fire() has verbose prints)
- #file:src/player/player_controller.cpp (shoot, interact have verbose prints)
- #file:src/ai/enemy_ai.cpp (perform_attack has verbose prints)
- #file:docs/CODING_STANDARDS.md

**Current state:** Multiple `UtilityFunctions::print()` calls fire per-shot and per-frame,
spamming the Godot output console. Examples:
- `[Weapon::fire] Called. can_fire=...` — every shot
- `[PlayerController] Shoot input detected` — every click
- `[EnemyAI] Fired weapon at target (accuracy: ...)` — every AI shot
- `[EnemyAI] Melee attacking target for ...` — every AI melee

These slow down Release builds and make real diagnostic logs hard to find.

# Objective

1. Create `src/core/debug_macros.hpp` with gated logging macros.
2. Replace verbose per-shot/per-frame `print()` calls with gated macros.
3. Keep one-time `_ready()` prints (useful for diagnostics).

# Rules

- Use `OS::get_singleton()->is_debug_build()` for runtime gating.
- Create three macros: `US_LOG_VERBOSE`, `US_LOG`, `US_LOG_ERROR`.
- Do NOT remove `_ready()` prints — they fire once and help diagnose loading issues.
- Only replace prints that fire per-shot, per-frame, or per-action.
- Include the new header in files that use the macros.

# Steps

1. Create `src/core/debug_macros.hpp`:
   ```cpp
   #ifndef DEBUG_MACROS_HPP
   #define DEBUG_MACROS_HPP

   #include <godot_cpp/classes/os.hpp>
   #include <godot_cpp/variant/utility_functions.hpp>

   // Verbose logging — only in debug builds (per-frame, per-shot)
   #define US_LOG_VERBOSE(...) \
       if (godot::OS::get_singleton()->is_debug_build()) { \
           godot::UtilityFunctions::print(__VA_ARGS__); \
       }

   // Standard logging — always emits (startup, important events)
   #define US_LOG(...) godot::UtilityFunctions::print(__VA_ARGS__)

   // Error logging — always emits
   #define US_LOG_ERROR(...) godot::UtilityFunctions::printerr(__VA_ARGS__)

   #endif
   ```

2. In `src/combat/weapon.cpp`:
   - Add `#include "../core/debug_macros.hpp"`.
   - Replace `UtilityFunctions::print("[Weapon::fire] Called...")` ? `US_LOG_VERBOSE(...)`.
   - Replace `UtilityFunctions::print("[Weapon::fire] Cannot fire...")` ? `US_LOG_VERBOSE(...)`.
   - Keep `UtilityFunctions::print("Weapon ready: ...")` as `US_LOG(...)` (fires once).

3. In `src/player/player_controller.cpp`:
   - Add `#include "../core/debug_macros.hpp"`.
   - Replace `UtilityFunctions::print("[PlayerController] Shoot input detected")` ? `US_LOG_VERBOSE(...)`.
   - Replace verbose interact prints ? `US_LOG_VERBOSE(...)`.
   - Keep `_ready()` prints as `US_LOG(...)`.

4. In `src/ai/enemy_ai.cpp`:
   - Add `#include "../core/debug_macros.hpp"`.
   - Replace `UtilityFunctions::print("[EnemyAI] Fired weapon...")` ? `US_LOG_VERBOSE(...)`.
   - Replace `UtilityFunctions::print("[EnemyAI] Melee attacking...")` ? `US_LOG_VERBOSE(...)`.
   - Keep `_ready()` print as `US_LOG(...)`.

5. Build Debug AND Release:
   ```powershell
   cmake --build build --config Debug
   cmake --build build --config Release
   ```

# Acceptance Criteria

- [ ] `src/core/debug_macros.hpp` exists with US_LOG_VERBOSE, US_LOG, US_LOG_ERROR macros.
- [ ] Per-shot/per-action prints in weapon.cpp, player_controller.cpp, enemy_ai.cpp use US_LOG_VERBOSE.
- [ ] One-time `_ready()` prints use US_LOG (always visible).
- [ ] Error prints (`printerr`) use US_LOG_ERROR.
- [ ] Debug build: verbose logging visible in output.
- [ ] Release build: minimal console output, no per-shot spam.
- [ ] Both Debug and Release builds succeed.

# Test Plan

1. Build Debug ? fire weapon ? verbose output visible.
2. Build Release ? fire weapon ? no per-shot output.
3. Both builds: `_ready()` prints visible on startup (e.g., "Weapon ready: M1911").

# Handoff

? When complete ? **Build Phase 4** ? then invoke `/hardening-smoke-test` (Task 1.9.2)
