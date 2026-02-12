# Task 1.5.3 - Background Agent Orchestration Guide

## Overview

This document describes how to execute **Task 1.5.3** (Add 10 scavenge points) using background or cloud agents for parallel execution.

## Agent Execution Order

```
???????????????????????????????????????????????????????????????????????
?                    TASK 1.5.3 AGENT ORCHESTRATION                   ?
???????????????????????????????????????????????????????????????????????
?                                                                     ?
?  PHASE 0: GATE CHECK (Sequential - Blocking)                        ?
?  ???????????????????????????????????????????????????????????????   ?
?  ? Agent: scavenge-1.5.3-phase0-prereq-check.prompt.md         ?   ?
?  ? Duration: ~2 min                                             ?   ?
?  ? Output: PASS/BLOCKED status                                  ?   ?
?  ???????????????????????????????????????????????????????????????   ?
?           ?                                                         ?
?           ? (PASS required)                                         ?
?                                                                     ?
?  PHASE 1: ZONE IMPLEMENTATION (Parallel - 3 Agents)                 ?
?  ?????????????????  ?????????????????  ?????????????????           ?
?  ? Agent 1A      ?  ? Agent 1B      ?  ? Agent 1C      ?           ?
?  ? Zone 1 (5 pts)?  ? Zone 2 (3 pts)?  ? Zone 3 (2 pts)?           ?
?  ? ~5 min        ?  ? ~4 min        ?  ? ~3 min        ?           ?
?  ?????????????????  ?????????????????  ?????????????????           ?
?          ?                  ?                  ?                    ?
?          ???????????????????????????????????????                    ?
?                             ?                                       ?
?                             ? (all 3 must complete)                 ?
?                                                                     ?
?  PHASE 2: INTEGRATION (Sequential)                                  ?
?  ???????????????????????????????????????????????????????????????   ?
?  ? Agent: scavenge-1.5.3-phase2-integration.prompt.md          ?   ?
?  ? Duration: ~5 min                                             ?   ?
?  ? Output: GDScript setup + signal wiring                       ?   ?
?  ???????????????????????????????????????????????????????????????   ?
?           ?                                                         ?
?           ?                                                         ?
?                                                                     ?
?  PHASE 3: VALIDATION (Sequential - Final)                           ?
?  ???????????????????????????????????????????????????????????????   ?
?  ? Agent: scavenge-1.5.3-phase3-validation.prompt.md           ?   ?
?  ? Duration: ~10 min (includes build + smoke test)              ?   ?
?  ? Output: PASS/FAIL + completion checklist                     ?   ?
?  ???????????????????????????????????????????????????????????????   ?
?                                                                     ?
?  TOTAL ESTIMATED TIME: ~24 min (sequential) / ~17 min (parallel)    ?
?                                                                     ?
???????????????????????????????????????????????????????????????????????
```

## Prompt Files

| Phase | Prompt File | Parallelizable | Depends On |
|-------|-------------|----------------|------------|
| 0 | `scavenge-1.5.3-phase0-prereq-check.prompt.md` | No | - |
| 1A | `scavenge-1.5.3-phase1a-zone1.prompt.md` | **Yes** | Phase 0 |
| 1B | `scavenge-1.5.3-phase1b-zone2.prompt.md` | **Yes** | Phase 0 |
| 1C | `scavenge-1.5.3-phase1c-zone3.prompt.md` | **Yes** | Phase 0 |
| 2 | `scavenge-1.5.3-phase2-integration.prompt.md` | No | Phase 1A, 1B, 1C |
| 3 | `scavenge-1.5.3-phase3-validation.prompt.md` | No | Phase 2 |

## Agent Configuration

### Phase 0 Agent (Gate Check)
```yaml
agent_id: scavenge-prereq-check
prompt: .github/prompts/scavenge-1.5.3-phase0-prereq-check.prompt.md
type: validation
blocking: true
timeout: 5min
output:
  - prerequisite_status: PASS|BLOCKED
  - missing_items: []
```

### Phase 1 Agents (Parallel Zone Work)
```yaml
# Agent 1A - Zone 1
agent_id: scavenge-zone1
prompt: .github/prompts/scavenge-1.5.3-phase1a-zone1.prompt.md
type: implementation
blocking: false
depends_on: [scavenge-prereq-check]
timeout: 10min
output:
  - nodes_created: 5
  - scene_changes: [Zone1_TutorialLoot/*]

# Agent 1B - Zone 2
agent_id: scavenge-zone2
prompt: .github/prompts/scavenge-1.5.3-phase1b-zone2.prompt.md
type: implementation
blocking: false
depends_on: [scavenge-prereq-check]
timeout: 10min
output:
  - nodes_created: 3
  - scene_changes: [Zone2_AmmoCaches/*]

# Agent 1C - Zone 3
agent_id: scavenge-zone3
prompt: .github/prompts/scavenge-1.5.3-phase1c-zone3.prompt.md
type: implementation
blocking: false
depends_on: [scavenge-prereq-check]
timeout: 10min
output:
  - nodes_created: 2
  - scene_changes: [Zone3_Medical/*]
```

### Phase 2 Agent (Integration)
```yaml
agent_id: scavenge-integration
prompt: .github/prompts/scavenge-1.5.3-phase2-integration.prompt.md
type: implementation
blocking: true
depends_on: [scavenge-zone1, scavenge-zone2, scavenge-zone3]
timeout: 10min
output:
  - files_created: [game/scripts/level_1_scavenge_setup.gd]
  - signals_wired: true
```

### Phase 3 Agent (Validation)
```yaml
agent_id: scavenge-validation
prompt: .github/prompts/scavenge-1.5.3-phase3-validation.prompt.md
type: validation
blocking: true
depends_on: [scavenge-integration]
timeout: 15min
output:
  - acceptance_criteria: PASS|FAIL
  - resource_balance: PASS|FAIL
  - smoke_test: PASS|FAIL
  - task_status: COMPLETE|NEEDS_WORK
```

## Execution Methods

### Method 1: Manual Sequential Execution
For developers executing prompts manually:

```bash
# Step 1: Run Phase 0
# Open: .github/prompts/scavenge-1.5.3-phase0-prereq-check.prompt.md
# Wait for PASS status

# Step 2: Run Phase 1 (can open 3 agents in parallel)
# Agent 1: .github/prompts/scavenge-1.5.3-phase1a-zone1.prompt.md
# Agent 2: .github/prompts/scavenge-1.5.3-phase1b-zone2.prompt.md
# Agent 3: .github/prompts/scavenge-1.5.3-phase1c-zone3.prompt.md
# Wait for all 3 to complete

# Step 3: Run Phase 2
# Open: .github/prompts/scavenge-1.5.3-phase2-integration.prompt.md
# Wait for completion

# Step 4: Run Phase 3
# Open: .github/prompts/scavenge-1.5.3-phase3-validation.prompt.md
# Wait for PASS status
```

### Method 2: GitHub Actions / Cloud Orchestration
For automated CI/CD execution:

```yaml
# .github/workflows/task-1.5.3-scavenge-points.yml
name: Task 1.5.3 - Scavenge Points

on:
  workflow_dispatch:

jobs:
  phase-0-prereq:
    runs-on: ubuntu-latest
    outputs:
      status: ${{ steps.check.outputs.status }}
    steps:
      - uses: actions/checkout@v4
      - id: check
        run: |
          # Execute prerequisite check prompt via AI agent
          # Output: PASS or BLOCKED

  phase-1-zones:
    needs: phase-0-prereq
    if: needs.phase-0-prereq.outputs.status == 'PASS'
    runs-on: ubuntu-latest
    strategy:
      matrix:
        zone: [zone1, zone2, zone3]
    steps:
      - uses: actions/checkout@v4
      - run: |
          # Execute zone-specific prompt in parallel

  phase-2-integration:
    needs: phase-1-zones
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          # Execute integration prompt

  phase-3-validation:
    needs: phase-2-integration
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          # Execute validation prompt
          # Report final status
```

### Method 3: VS Code Copilot Chat Sessions
For interactive development:

1. Open 4 VS Code windows (or use split terminals)
2. In each window, start a new Copilot Chat session
3. Reference the appropriate prompt file using `/file`
4. Coordinate timing based on dependencies

## Resource Summary

| Resource | Quantity | Validation |
|----------|----------|------------|
| Bandages | 6 | 150 HP healing |
| Medkit | 1 | 75 HP instant |
| .45 ACP Ammo | 42 rounds | 6 magazines |
| 12ga Shells | 8 rounds | Teaser for shotgun |
| Canned Food | 2 | Survival stat |
| M1911 Pistol | 1 | Starting weapon |

**Combat Balance**: 42 rounds vs 8 enemies = 67% hit rate OK  
**Healing Balance**: 225 HP vs ~150 expected damage = 50% buffer

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Nodes created | 10 | Count in scene tree |
| Build status | Success | `cmake --build` exit code |
| Smoke test | All pass | Manual verification |
| Resource math | Balanced | 67%+ ammo margin, 50%+ healing |
| Task status | COMPLETE | Phase 3 final checklist |

## Troubleshooting

### Phase 0 Blocked
- **Missing ScavengePoint class**: Check `register_types.cpp`
- **Missing items**: Create item definitions or use placeholders

### Phase 1 Conflicts
- **Merge conflicts**: Zone prompts edit different scene sections
- **Position overlaps**: Each zone has distinct Z-coordinate ranges

### Phase 2 Script Errors
- **Node not found**: Check scene tree paths in script
- **Signal errors**: Verify ScavengePoint has `looted` signal

### Phase 3 Failures
- **Build fails**: Check C++ syntax, CMakeLists.txt
- **Balance fails**: Recalculate with actual item values
- **Smoke test fails**: Debug specific test case
