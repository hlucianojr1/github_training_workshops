# Milestone 1.5: Hardening — Agentic Workflow Guide

**Version**: 1.0  
**Created**: 2026-02-10  
**Branch**: `dev_advance`  
**Total Estimate**: 24 hours across 12 tasks  
**IDE**: Visual Studio 2022 with GitHub Copilot Chat (Agent Mode)

---

## Purpose

This document is the **single source of truth** for executing Milestone 1.5.  
Each task has a dedicated prompt file in `.github/prompts/` that a developer invokes  
inside Visual Studio ? Copilot Chat ? Agent Mode. The prompts are designed so that  
an AI agent can execute each task with minimal human intervention, then hand off  
cleanly to the next task.

---

## How to Use This Workflow

### Prerequisites

1. Branch `dev_advance` checked out and up to date.
2. Build succeeds before starting: `cmake --build build --config Debug`.
3. Visual Studio 2022 open with the solution loaded.
4. GitHub Copilot Chat available in Agent Mode.

### Executing a Task

1. Open **Copilot Chat** (Ctrl+\, Ctrl+C or View ? GitHub Copilot Chat).
2. Switch to **Agent Mode** (click the mode selector at bottom of chat panel).
3. Type `/` and select the prompt file for the task (e.g., `hardening-fix-range-falloff`).
4. The agent will load context, make changes, and provide a build/test plan.
5. **Build**: Close Godot ? `cmake --build build --config Debug` ? Reopen Godot.
6. **Test**: Follow the test plan in the prompt output.
7. **Handoff**: The prompt's completion section tells you which prompt to invoke next.

### Context Engineering Principles (CORE Framework)

Every prompt in this workflow follows the **CORE** pattern:

| Element | Purpose | How It's Applied |
|---------|---------|------------------|
| **C**ontext | Ground the agent in project reality | `#file:` references to exact source files, SPEC.md sections, MEMORY.md decisions |
| **O**bjective | Single, measurable goal per prompt | One task ID, one acceptance criteria checklist |
| **R**ules | Guardrails preventing common mistakes | Godot 4.3 API rules, null-check patterns, signal conventions |
| **E**xamples | Concrete before/after code patterns | Exact line numbers, current code ? expected code |

---

## Architecture: System Dependency Map

The following diagram shows which C++ systems are touched by M1.5 and how they connect.  
Each colored block maps to an Epic.

```
???????????????????????????????????????????????????????????????????????
?                          GAME LOOP                                  ?
?                                                                     ?
?  ????????????????????    ????????????????????    ????????????????? ?
?  ?  PlayerController ??????  SurvivalStats   ??????     HUD       ? ?
?  ?  (Epic 1.7)       ?    ?  (Epic 1.7)       ?    ?  (signals)    ? ?
?  ?                    ?    ?                    ?    ?               ? ?
?  ?  • sprint?stamina  ?    ?  • drain/regen    ?    ?  • health bar ? ?
?  ?  • crouch hitbox   ?    ?  • exhaustion     ?    ?  • stamina bar? ?
?  ?  • fall damage     ?    ?  • death signal   ?    ?  • ammo count ? ?
?  ?  • reload signal   ?    ?                    ?    ?               ? ?
?  ?  • interact mask   ?    ?                    ?    ?               ? ?
?  ??????????????????????    ????????????????????    ????????????????? ?
?           ?                                                          ?
?           ? fires weapon                                             ?
?           ?                                                          ?
?  ????????????????????    ????????????????????                       ?
?  ?     Weapon        ??????   DamageSystem   ?                       ?
?  ?  (Epic 1.6)       ?    ?  (Epic 1.6)       ?                       ?
?  ?                    ?    ?                    ?                       ?
?  ?  • mag cap 8?7    ?    ?  • tiered falloff ?                       ?
?  ?                    ?    ?  • hit_zone signal?                       ?
?  ?                    ?    ?  • fall damage    ?                       ?
?  ????????????????????    ??????????????????????                       ?
?                                   ? apply_damage                     ?
?                                   ?                                  ?
?  ????????????????????    ????????????????????                       ?
?  ?    EnemyAI        ??????  LevelManager    ?                       ?
?  ?  (Epic 1.8)       ?    ?  (Epic 1.8)       ?                       ?
?  ?                    ?    ?                    ?                       ?
?  ?  • weapon reload   ?    ?  • auto-register  ?                       ?
?  ?  • AI accuracy     ?    ?  • enemy_defeated ?                       ?
?  ?                    ?    ?  • all_defeated   ?                       ?
?  ????????????????????    ????????????????????                       ?
?                                                                     ?
?  ????????????????????????????????????????????????????????????????????
?  ?  Epic 1.9: Code Quality                                         ??
?  ?  • debug_macros.hpp gate all verbose logging                    ??
?  ?  • smoke test validates full loop                               ??
?  ????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????
```

---

## Execution Phases & Dependency Graph

Tasks are grouped into 4 phases. Within a phase, tasks are independent and can  
run in parallel. Each phase must complete (build + verify) before the next begins.

```
?????????????????????????????????????????????????????????????????????????????
?  PHASE 1: Quick Fixes (~4h)                                             ?
?                                                                         ?
?  ???????????????  ???????????????  ???????????????                     ?
?  ? T-1.6.2     ?  ? T-1.6.3     ?  ? T-1.7.3     ?                     ?
?  ? Mag Cap 8?7 ?  ? Hit Zone    ?  ? Reload Sig   ?                     ?
?  ? (0.5h)      ?  ? Signal      ?  ? Fix          ?                     ?
?  ?             ?  ? (1.5h)      ?  ? (1h)         ?                     ?
?  ???????????????  ???????????????  ???????????????                     ?
?         ?                ?                ?                             ?
?         ???????????????????????????????????                             ?
?                          ?                                              ?
?                   BUILD + VERIFY                                        ?
?????????????????????????????????????????????????????????????????????????????
?  PHASE 2: System Wiring (~8h)                                           ?
?                                                                         ?
?  ???????????????  ???????????????  ???????????????  ???????????????   ?
?  ? T-1.6.1     ?  ? T-1.7.1     ?  ? T-1.7.4     ?  ? T-1.8.2     ?   ?
?  ? Range       ?  ? Sprint ?    ?  ? Interaction  ?  ? Enemy ?     ?   ?
?  ? Falloff     ?  ? Stamina     ?  ? Mask         ?  ? LevelMgr    ?   ?
?  ? (2h)        ?  ? (2h)        ?  ? (1h)         ?  ? (2h)        ?   ?
?  ???????????????  ???????????????  ???????????????  ???????????????   ?
?         ?                ?                ?                ?           ?
?         ????????????????????????????????????????????????????           ?
?                          ?                ?                            ?
?                      BUILD + VERIFY                                    ?
?????????????????????????????????????????????????????????????????????????????
?  PHASE 3: New Features (~5h)                                            ?
?                                                                         ?
?  ???????????????  ???????????????                                      ?
?  ? T-1.6.4     ?  ? T-1.7.2     ?                                      ?
?  ? Fall Damage  ?  ? Crouch      ?                                      ?
?  ? (2h)        ?  ? Collision   ?                                      ?
?  ?             ?  ? (3h)        ?                                      ?
?  ???????????????  ???????????????                                      ?
?         ?                ?                                              ?
?         ??????????????????                                              ?
?                ?                                                        ?
?          BUILD + VERIFY                                                 ?
?????????????????????????????????????????????????????????????????????????????
?  PHASE 4: Cleanup + Validation (~5h)                                    ?
?                                                                         ?
?  ???????????????  ???????????????                                      ?
?  ? T-1.8.1     ?  ? T-1.9.1     ?                                      ?
?  ? AI Weapon   ?  ? Debug Log   ?                                      ?
?  ? Reload      ?  ? Gating      ?                                      ?
?  ? (1h)        ?  ? (2h)        ?                                      ?
?  ???????????????  ???????????????                                      ?
?         ?                ?                                              ?
?         ??????????????????                                              ?
?                ?                                                        ?
?          BUILD + VERIFY                                                 ?
?                ?                                                        ?
?  ????????????????????????????                                           ?
?  ? T-1.9.2                  ?                                           ?
?  ? End-to-End Smoke Test    ?                                           ?
?  ? (3h)                     ?                                           ?
?  ????????????????????????????                                           ?
?                ?                                                        ?
?     UPDATE docs/MEMORY.md                                               ?
?????????????????????????????????????????????????????????????????????????????
```

---

## Task Reference Table

| Phase | Task ID | Title | Est | Prompt File | Agent | Depends On |
|-------|---------|-------|-----|-------------|-------|------------|
| 1 | 1.6.2 | Fix M1911 magazine capacity | 0.5h | `hardening-fix-mag-capacity` | `combat-specialist` | — |
| 1 | 1.6.3 | Enrich damage_dealt signal | 1.5h | `hardening-enrich-damage-signal` | `combat-specialist` | — |
| 1 | 1.7.3 | Fix premature reload signal | 1h | `hardening-fix-reload-signal` | `combat-specialist` | — |
| 2 | 1.6.1 | Fix range falloff to SPEC | 2h | `hardening-fix-range-falloff` | `combat-specialist` | — |
| 2 | 1.7.1 | Wire sprint ? stamina | 2h | `hardening-wire-sprint-stamina` | `combat-specialist` | — |
| 2 | 1.7.4 | Fix interaction collision mask | 1h | `hardening-fix-interaction-mask` | `combat-specialist` | — |
| 2 | 1.8.2 | Wire enemy death ? LevelManager | 2h | `hardening-wire-enemy-levelmanager` | `ai-specialist` | — |
| 3 | 1.6.4 | Implement fall damage | 2h | `hardening-implement-fall-damage` | `combat-specialist` | 1.6.1 |
| 3 | 1.7.2 | Crouch collision shape | 3h | `hardening-crouch-collision` | `combat-specialist` | 1.7.1 |
| 4 | 1.8.1 | AI weapon reload gap | 1h | `hardening-ai-weapon-reload` | `ai-specialist` | 1.8.2 |
| 4 | 1.9.1 | Gate debug logging | 2h | `hardening-gate-debug-logging` | `godot-cpp-expert` | — |
| 4 | 1.9.2 | End-to-end smoke test | 3h | `hardening-smoke-test` | `code-reviewer` | ALL |

---

## Signal Flow Changes (Before ? After)

### Current (Broken) Signal Wiring

```
PlayerController._input("sprint")
    ??? get_current_speed() checks can_sprint   ? ? can_sprint is always true
    ??? SurvivalStats.set_sprinting() NEVER CALLED

PlayerController.reload()
    ??? Weapon.start_reload()
    ??? emit_signal("weapon_reloaded")          ? ? Fires immediately, before reload completes

EnemyAI.take_damage() ? health ? 0
    ??? emit_signal("enemy_died")               ? ? Nobody listening

DamageSystem.apply_damage()
    ??? emit_signal("damage_dealt", target, amount, type, source)
                                                 ? ? Missing hit_zone parameter
```

### After Hardening (Fixed) Signal Wiring

```
PlayerController.handle_movement()
    ??? survival_stats->set_sprinting(wants_sprint && can_sprint)  ? Every frame
    ??? can_sprint = survival_stats->can_sprint()                  ? Reads exhaustion
    ??? survival_stats->drain_stamina(5.0f)                       ? On jump

PlayerController.reload()
    ??? Weapon.start_reload()
        ??? [timer completes] ? emit "reload_finished"
            ??? PlayerController.on_reload_finished()
                ??? emit_signal("weapon_reloaded")                ? After ammo transfers

LevelManager._ready() [deferred]
    ??? auto_register_enemies()
        ??? find all EnemyAI nodes
        ??? register_enemy() for each
        ??? connect("enemy_died") ? enemy_defeated()              ? Auto-wired
            ??? enemies_remaining == 0 ? emit "all_enemies_defeated"

DamageSystem.apply_damage()
    ??? emit_signal("damage_dealt", target, amount, type, source, hit_zone)
                                                                   ? Includes zone
```

---

## Phase 1: Quick Fixes — Walkthrough

### Step 1: Fix Magazine Capacity (Task 1.6.2)

**Invoke**: Copilot Chat ? Agent Mode ? `/hardening-fix-mag-capacity`

**What it does**: Changes 2 default values in `weapon.hpp` (lines 51-52) from 8 ? 7.

**Handoff**: When done, invoke `/hardening-enrich-damage-signal`.

---

### Step 2: Enrich damage_dealt Signal (Task 1.6.3)

**Invoke**: Copilot Chat ? Agent Mode ? `/hardening-enrich-damage-signal`

**What it does**: Adds `hit_zone` parameter to the `damage_dealt` signal definition and both
`emit_signal` call sites in `damage_system.cpp`.

**Handoff**: When done, invoke `/hardening-fix-reload-signal`.

---

### Step 3: Fix Reload Signal Timing (Task 1.7.3)

**Invoke**: Copilot Chat ? Agent Mode ? `/hardening-fix-reload-signal`

**What it does**: Removes premature `weapon_reloaded` emit from `PlayerController::reload()`,
adds `on_reload_finished` callback wired to `Weapon::reload_finished` signal.

**Handoff**: **Build Phase 1** ? then start Phase 2 with `/hardening-fix-range-falloff`.

---

### Phase 1 Build Gate

```powershell
# Close Godot editor first
cmake --build build --config Debug
# Reopen Godot, press F5
# Verify: fire 7 shots ? empty, reload completes before signal, headshot logs hit_zone=1
```

---

## Phase 2: System Wiring — Walkthrough

### Step 4: Fix Range Falloff (Task 1.6.1)

**Invoke**: `/hardening-fix-range-falloff`

**What it does**: Replaces linear `apply_distance_falloff()` with SPEC §5.2 tiered curve.

**Handoff**: `/hardening-wire-sprint-stamina`

---

### Step 5: Wire Sprint ? Stamina (Task 1.7.1)

**Invoke**: `/hardening-wire-sprint-stamina`

**What it does**: Adds `survival_stats->set_sprinting()` call in `handle_movement()`,
reads `can_sprint()` each frame, adds 5 stamina cost per jump.

**Handoff**: `/hardening-fix-interaction-mask`

---

### Step 6: Fix Interaction Mask (Task 1.7.4)

**Invoke**: `/hardening-fix-interaction-mask`

**What it does**: Adds `interaction_collision_mask` property, replaces `0xFFFFFFFF` mask.

**Handoff**: `/hardening-wire-enemy-levelmanager`

---

### Step 7: Wire Enemy ? LevelManager (Task 1.8.2)

**Invoke**: `/hardening-wire-enemy-levelmanager`

**What it does**: Adds `auto_register_enemies()` to LevelManager, connects `enemy_died` signals,
adds `all_enemies_defeated` signal.

**Handoff**: **Build Phase 2** ? then start Phase 3 with `/hardening-implement-fall-damage`.

---

### Phase 2 Build Gate

```powershell
cmake --build build --config Debug
# Verify: sprint drains stamina, E key only hits interaction layer,
# kill enemy ? objective text updates with remaining count
```

---

## Phase 3: New Features — Walkthrough

### Step 8: Implement Fall Damage (Task 1.6.4)

**Invoke**: `/hardening-implement-fall-damage`

**What it does**: Adds fall tracking to `PlayerController`, applies damage via
`DamageSystem::FALL` on landing after > 5m fall.

**Handoff**: `/hardening-crouch-collision`

---

### Step 9: Crouch Collision Shape (Task 1.7.2)

**Invoke**: `/hardening-crouch-collision`

**What it does**: Adjusts capsule height on crouch, adds ceiling raycast to prevent
uncrouching under geometry, adjusts camera pivot Y.

**Handoff**: **Build Phase 3** ? then start Phase 4 with `/hardening-ai-weapon-reload`.

---

### Phase 3 Build Gate

```powershell
cmake --build build --config Debug
# Verify: fall from height ? damage, crouch under obstacle ? stays crouched
```

---

## Phase 4: Cleanup + Validation — Walkthrough

### Step 10: AI Weapon Reload (Task 1.8.1)

**Invoke**: `/hardening-ai-weapon-reload`

**What it does**: Adds ammo check + `start_reload()` call at top of `perform_attack()`.

**Handoff**: `/hardening-gate-debug-logging`

---

### Step 11: Gate Debug Logging (Task 1.9.1)

**Invoke**: `/hardening-gate-debug-logging`

**What it does**: Creates `src/core/debug_macros.hpp`, replaces verbose per-frame logging
with `US_LOG_VERBOSE()` macro gated behind `OS::is_debug_build()`.

**Handoff**: **Build Phase 4** ? then `/hardening-smoke-test`.

---

### Phase 4 Build Gate

```powershell
cmake --build build --config Debug
# Quick verify: AI reloads, release build has minimal console output
```

---

### Step 12: End-to-End Smoke Test (Task 1.9.2)

**Invoke**: `/hardening-smoke-test`

**What it does**: Provides a structured 18-point checklist covering the entire gameplay loop.
Documents results in `docs/MEMORY.md`.

**Handoff**: Invoke `/update-docs` to finalize MEMORY.md with M1.5 results, then
update `docs/PRODUCTION_PLAN.md` status to mark M1.5 complete.

---

## Post-Completion Checklist

- [ ] All 12 tasks completed and verified
- [ ] Build succeeds in both Debug and Release
- [ ] `docs/MEMORY.md` updated with M1.5 Hardening Results
- [ ] `docs/PRODUCTION_PLAN.md` M1.5 status updated to ? COMPLETE
- [ ] Branch `dev_advance` committed with descriptive messages
- [ ] No regressions in M1 functionality

---

## Prompt File Inventory

| Prompt File | Task | New? | Agent |
|-------------|------|------|-------|
| `hardening-fix-mag-capacity.prompt.md` | 1.6.2 | ? New | combat-specialist |
| `hardening-enrich-damage-signal.prompt.md` | 1.6.3 | ? New | combat-specialist |
| `hardening-fix-reload-signal.prompt.md` | 1.7.3 | ? New | combat-specialist |
| `hardening-fix-range-falloff.prompt.md` | 1.6.1 | ? New | combat-specialist |
| `hardening-wire-sprint-stamina.prompt.md` | 1.7.1 | ? New | combat-specialist |
| `hardening-fix-interaction-mask.prompt.md` | 1.7.4 | ? New | combat-specialist |
| `hardening-wire-enemy-levelmanager.prompt.md` | 1.8.2 | ? New | ai-specialist |
| `hardening-implement-fall-damage.prompt.md` | 1.6.4 | ? New | combat-specialist |
| `hardening-crouch-collision.prompt.md` | 1.7.2 | ? New | combat-specialist |
| `hardening-ai-weapon-reload.prompt.md` | 1.8.1 | ? New | ai-specialist |
| `hardening-gate-debug-logging.prompt.md` | 1.9.1 | ? New | godot-cpp-expert |
| `hardening-smoke-test.prompt.md` | 1.9.2 | ? New | code-reviewer |
| `update-docs.prompt.md` | Post | Existing | doc-maintainer |
| `code-review-changes.prompt.md` | Post | Existing | code-reviewer |

---

## Risk Mitigation Quick Reference

| If this happens... | Do this... |
|---------------------|-----------|
| Build fails after Phase N | Fix compile errors before moving to Phase N+1. Use `/debug-extension-not-loading` prompt. |
| Crouch ceiling check causes physics lag | Only raycast on uncrouch request, not per-frame. |
| AI weapon reload breaks encounter pacing | Revert `perform_attack()` change; keep direct damage fallback. |
| Signal signature change breaks GDScript | Godot ignores extra params — but check `hud_controller.gd` connections. |
| Fall damage triggers on stairs/slopes | Increase `fall_damage_min_distance` to 6m or add slope angle check. |

---

*Document maintained by: Sprint Planner Agent*  
*Last updated: 2026-02-10*
