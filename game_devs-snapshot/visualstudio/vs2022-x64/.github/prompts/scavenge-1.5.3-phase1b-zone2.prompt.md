# Phase 1B: Zone 2 Scavenge Points (Ammo Caches)

## Context
- **Task**: 1.5.3 - Add 10 scavenge points across Level 1
- **Phase**: 1B (Parallelizable with 1A, 1C)
- **Agent Type**: Background/Cloud Agent
- **Zone**: "The Checkpoint" (Combat Area)
- **Count**: 3 scavenge points

## Prerequisites
- Phase 0 must be PASS
- ScavengePoint class registered
- Item IDs defined

## Zone Purpose
Zone 2 is the **first combat encounter**. The player faces 5 enemies (3 Scavengers + 2 Raiders). These points:
1. Provide ammo resupply before/after combat
2. Reward flanking maneuvers (east bunker)
3. Are placed in **tactically risky** locations (near enemies)

## Scavenge Point Specifications

### SP-Z2-01: Sandbag Bunker (East Flank)
| Property | Value |
|----------|-------|
| **Node Name** | `SP_SandbagBunker` |
| **Position** | `Vector3(8, 0.5, 100)` |
| **Visual** | Ammo crate behind sandbags |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "ammo_45acp", "quantity": 14}]` |
| **Rationale** | Rewards player for flanking east (avoiding MG nest) |
| **Danger Level** | Medium (Scavenger patrol nearby) |

### SP-Z2-02: Military Crate (Near Tank)
| Property | Value |
|----------|-------|
| **Node Name** | `SP_MilitaryCrate` |
| **Position** | `Vector3(-3, 0.5, 90)` |
| **Visual** | Green military supply crate |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "ammo_45acp", "quantity": 14}, {"item_id": "bandage", "quantity": 1}]` |
| **Rationale** | High-risk/high-reward near Raider patrol |
| **Danger Level** | HIGH (Raider_Tank patrols here) |

### SP-Z2-03: Guard Shack (West Side)
| Property | Value |
|----------|-------|
| **Node Name** | `SP_GuardShack` |
| **Position** | `Vector3(-7, 0.5, 85)` |
| **Visual** | Small guard booth interior |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "ammo_12ga", "quantity": 8}]` |
| **Rationale** | Teases shotgun ammo for future weapon |
| **Danger Level** | Low (cleared after combat) |

## Implementation Instructions

### Scene Tree Structure
```
ScavengePoints (Node3D)
??? Zone2_AmmoCaches (Node3D)
    ??? SP_SandbagBunker (ScavengePoint)
    ?   ??? CollisionShape3D (BoxShape3D: 1m × 0.8m × 0.8m)
    ??? SP_MilitaryCrate (ScavengePoint)
    ?   ??? CollisionShape3D (BoxShape3D: 1.2m × 0.6m × 0.6m)
    ??? SP_GuardShack (ScavengePoint)
        ??? CollisionShape3D (BoxShape3D: 1m × 1m × 1m)
```

### Per-Node Setup (Inspector Properties)
For each ScavengePoint node:
1. Set `is_randomized = false`
2. Set `min_items = 1`
3. Set `max_items = 2` (MilitaryCrate has 2 items)
4. Configure `item_pool` array per specification above

## Placement Rationale (Combat Flow)

```
Zone 2 Layout (Player approaches from North):

    N (from Zone 1)
    |
    |     [Sandbag Bunker - SP_SandbagBunker] ??? East flank reward
    |           ?
    |   [MG Nest]????????[Sandbags]
    |           |
    |   [M48 Tank]
    |     ?
    |   [Military Crate - SP_MilitaryCrate] ??? Risky: Raider patrols here
    |           |
    |   [Guard Shack - SP_GuardShack] ??? Safe after clearing
    |
    S (toward Zone 3)
```

## Deliverables
- [ ] 3 ScavengePoint nodes added to scene
- [ ] All positions match specifications
- [ ] item_pool configured for each
- [ ] CollisionShape3D added for interaction detection
- [ ] Positions avoid blocking enemy patrol routes

## Zone 2 Resource Summary
| Item | Total Quantity |
|------|----------------|
| .45 ACP Ammo | 28 rounds (2 full magazines) |
| 12ga Shells | 8 rounds |
| Bandages | 1 |

## Combat Resource Math
- Player enters Zone 2 with: ~14 rounds (from Zone 1)
- Zone 2 provides: +28 rounds
- **Total available for combat**: 42 rounds
- **Required to kill 5 enemies**: ~15-20 rounds (at ~3-4 hits each)
- **Margin**: 22+ rounds (allows 52% miss rate)

## Notes for Integration
- Positions relative to enemy placements from Task 1.5.1
- MilitaryCrate is intentionally dangerous (risk/reward design)
- Guard Shack loot is "post-combat reward" pattern
