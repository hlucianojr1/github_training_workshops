# Phase 1A: Zone 1 Scavenge Points (Tutorial Loot)

## Context
- **Task**: 1.5.3 - Add 10 scavenge points across Level 1
- **Phase**: 1A (Parallelizable with 1B, 1C)
- **Agent Type**: Background/Cloud Agent
- **Zone**: "The Traffic Jam" (Tutorial Area)
- **Count**: 5 scavenge points

## Prerequisites
- Phase 0 must be PASS
- ScavengePoint class registered
- Item IDs defined

## Zone Purpose
Zone 1 is the **tutorial area**. The player has just started and these points:
1. Teach the "press E to loot" mechanic
2. Provide starting gear (weapon, ammo, bandages)
3. Are **highly visible** to encourage exploration

## Scavenge Point Specifications

### SP-Z1-01: Car Trunk (First Loot)
| Property | Value |
|----------|-------|
| **Node Name** | `SP_CarTrunk` |
| **Position** | `Vector3(-3, 0.5, 175)` |
| **Visual** | Open car trunk (Checker Marathon) |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "bandage", "quantity": 2}]` |
| **Rationale** | First visible from spawn, teaches interaction |

### SP-Z1-02: Overturned Suitcase
| Property | Value |
|----------|-------|
| **Node Name** | `SP_Suitcase` |
| **Position** | `Vector3(2, 0.2, 170)` |
| **Visual** | Burst suitcase on ground |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "ammo_45acp", "quantity": 14}]` |
| **Rationale** | Introduces ammo scarcity (half magazine) |

### SP-Z1-03: Bus Interior
| Property | Value |
|----------|-------|
| **Node Name** | `SP_BusInterior` |
| **Position** | `Vector3(-5, 1.0, 160)` |
| **Visual** | Under bus seat |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "canned_food", "quantity": 1}]` |
| **Rationale** | Rewards exploration (not on main path) |

### SP-Z1-04: Car Glove Box
| Property | Value |
|----------|-------|
| **Node Name** | `SP_GloveBox` |
| **Position** | `Vector3(4, 0.8, 155)` |
| **Visual** | Open glove compartment |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "bandage", "quantity": 1}]` |
| **Rationale** | Reinforces car looting habit |

### SP-Z1-05: Under Bus Bench (Critical Weapon)
| Property | Value |
|----------|-------|
| **Node Name** | `SP_UnderBusBench` |
| **Position** | `Vector3(-2, 0.3, 150)` |
| **Visual** | Hidden under bench |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "weapon_m1911", "quantity": 1}]` |
| **Rationale** | **CRITICAL**: Player's starting weapon |

## Implementation Instructions

### Scene Tree Structure
```
ScavengePoints (Node3D)
??? Zone1_TutorialLoot (Node3D)
    ??? SP_CarTrunk (ScavengePoint)
    ?   ??? CollisionShape3D (BoxShape3D: 1m × 1m × 1m)
    ??? SP_Suitcase (ScavengePoint)
    ?   ??? CollisionShape3D
    ??? SP_BusInterior (ScavengePoint)
    ?   ??? CollisionShape3D
    ??? SP_GloveBox (ScavengePoint)
    ?   ??? CollisionShape3D
    ??? SP_UnderBusBench (ScavengePoint)
        ??? CollisionShape3D
```

### Per-Node Setup (Inspector Properties)
For each ScavengePoint node:
1. Set `is_randomized = false`
2. Set `min_items = 1`
3. Set `max_items = 1` (or item count)
4. Configure `item_pool` array per specification above

## Deliverables
- [ ] 5 ScavengePoint nodes added to scene
- [ ] All positions match specifications
- [ ] item_pool configured for each
- [ ] CollisionShape3D added to each for interaction detection

## Zone 1 Resource Summary
| Item | Total Quantity |
|------|----------------|
| Bandages | 3 |
| .45 ACP Ammo | 14 rounds |
| Canned Food | 1 |
| M1911 Pistol | 1 |

## Notes for Integration
- This data feeds into Phase 2 setup script
- Positions are approximate; adjust based on actual geometry
- First scavenge point (Car Trunk) MUST be visible from player spawn
