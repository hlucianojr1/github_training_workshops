# Phase 1C: Zone 3 Scavenge Points (Medical Supplies)

## Context
- **Task**: 1.5.3 - Add 10 scavenge points across Level 1
- **Phase**: 1C (Parallelizable with 1A, 1B)
- **Agent Type**: Background/Cloud Agent
- **Zone**: "The Commercial Strip" (Recovery Area)
- **Count**: 2 scavenge points

## Prerequisites
- Phase 0 must be PASS
- ScavengePoint class registered
- Item IDs defined

## Zone Purpose
Zone 3 is the **post-combat recovery** area. The player has likely taken damage at the checkpoint. These points:
1. Provide healing to continue toward the exit
2. Are **thematically placed** (medicine at drugstore)
3. Reward exploration before the level exit

## Scavenge Point Specifications

### SP-Z3-01: Rexall Drugs Counter
| Property | Value |
|----------|-------|
| **Node Name** | `SP_RexallDrugs` |
| **Position** | `Vector3(5, 1.0, 45)` |
| **Visual** | Behind pharmacy counter |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "medkit", "quantity": 1}]` |
| **Rationale** | **Thematic**: Drugstore = medicine (world-building) |
| **Healing Value** | 75 HP instant |

### SP-Z3-02: Diner Kitchen
| Property | Value |
|----------|-------|
| **Node Name** | `SP_DinerKitchen` |
| **Position** | `Vector3(-6, 0.5, 30)` |
| **Visual** | Kitchen storage area |
| **is_randomized** | `false` |
| **item_pool** | `[{"item_id": "bandage", "quantity": 2}, {"item_id": "canned_food", "quantity": 1}]` |
| **Rationale** | Exploration reward, optional before exit |
| **Healing Value** | 50 HP over time |

## Implementation Instructions

### Scene Tree Structure
```
ScavengePoints (Node3D)
??? Zone3_Medical (Node3D)
    ??? SP_RexallDrugs (ScavengePoint)
    ?   ??? CollisionShape3D (BoxShape3D: 1.5m × 1m × 0.8m)
    ??? SP_DinerKitchen (ScavengePoint)
        ??? CollisionShape3D (BoxShape3D: 1m × 1m × 1m)
```

### Per-Node Setup (Inspector Properties)
For each ScavengePoint node:
1. Set `is_randomized = false`
2. Set `min_items = 1`
3. Set `max_items = 2` (DinerKitchen has 2 item types)
4. Configure `item_pool` array per specification above

## Placement Rationale (Recovery Flow)

```
Zone 3 Layout (Player approaches from North):

    N (from Zone 2, after combat)
    |
    |   [Woolworth's]     [Rexall Drugs]
    |                          |
    |                     [SP_RexallDrugs] ??? Primary healing (Medkit)
    |                          |
    |   [Diner]???????????????[Kitchen]
    |                          |
    |                     [SP_DinerKitchen] ??? Secondary healing + food
    |                          |
    |   ???????????????????????????????????
    |          [SUBWAY ENTRANCE - EXIT]
    |
    S (Level Exit at 168th St)
```

## Deliverables
- [ ] 2 ScavengePoint nodes added to scene
- [ ] All positions match specifications
- [ ] item_pool configured for each
- [ ] CollisionShape3D added for interaction detection
- [ ] Rexall Drugs positioned near storefront (thematic)

## Zone 3 Resource Summary
| Item | Total Quantity |
|------|----------------|
| Medkit | 1 (75 HP instant) |
| Bandages | 2 (50 HP over time) |
| Canned Food | 1 |

## Total Healing Available (Zone 3)
- Medkit: 75 HP instant
- Bandages: 50 HP (25 HP × 2)
- **Total**: 125 HP healing in Zone 3

## Thematic Consistency Check
| Location | Item | Real-World Logic |
|----------|------|------------------|
| Rexall Drugs (Pharmacy) | Medkit | ? Medicine at drugstore |
| Diner Kitchen | Food + Bandages | ? Food storage, first aid kit in kitchen |

## Notes for Integration
- Zone 3 has 3 enemies (Task 1.5.2) - player may take additional damage
- Healing is generous here because it's near the exit (reward for surviving)
- Diner Kitchen is "off the main path" - rewards exploration
- Level exit (subway) is just past Zone 3 - player should heal before entering
