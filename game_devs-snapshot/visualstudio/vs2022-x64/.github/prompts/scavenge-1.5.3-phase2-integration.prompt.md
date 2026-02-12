# Phase 2: Integration Script for Scavenge Points

## Context
- **Task**: 1.5.3 - Add 10 scavenge points across Level 1
- **Phase**: 2 (Sequential - after Phase 1A, 1B, 1C complete)
- **Agent Type**: Background/Cloud Agent
- **Deliverable**: GDScript setup script + signal wiring

## Prerequisites
- Phase 1A (Zone 1): 5 nodes created ?
- Phase 1B (Zone 2): 3 nodes created ?
- Phase 1C (Zone 3): 2 nodes created ?

## Objective
Create a GDScript that:
1. Configures all 10 scavenge points on level load
2. Wires `looted` signals to LevelManager for tracking
3. Provides debug logging for testing

## Implementation

### File: `game/scripts/level_1_scavenge_setup.gd`

```gdscript
extends Node
class_name Level1ScavengeSetup

## Level 1 Scavenge Point Configuration
## Task 1.5.3: Configures all 10 scavenge points per zone
## 
## Zone Distribution:
##   - Zone 1 (Tutorial): 5 points
##   - Zone 2 (Combat):   3 points  
##   - Zone 3 (Medical):  2 points

signal all_points_configured()
signal point_looted(point_name: String, items: Array)

@export var debug_logging: bool = true

var _level_manager: Node = null
var _total_points: int = 0
var _points_looted: int = 0

func _ready() -> void:
    _level_manager = get_node_or_null("../LevelManager")
    _configure_all_zones()
    emit_signal("all_points_configured")
    
    if debug_logging:
        print("[ScavengeSetup] Configured %d scavenge points" % _total_points)

## Zone 1: Tutorial Loot (5 points)
## Purpose: Teach looting, provide starting gear
func _configure_zone1() -> void:
    var zone1 = get_node_or_null("../ScavengePoints/Zone1_TutorialLoot")
    if not zone1:
        push_warning("[ScavengeSetup] Zone1_TutorialLoot node not found")
        return
    
    # SP_CarTrunk - First visible loot
    _configure_point(zone1, "SP_CarTrunk", [
        {"item_id": "bandage", "quantity": 2}
    ])
    
    # SP_Suitcase - Ammo introduction
    _configure_point(zone1, "SP_Suitcase", [
        {"item_id": "ammo_45acp", "quantity": 14}
    ])
    
    # SP_BusInterior - Exploration reward
    _configure_point(zone1, "SP_BusInterior", [
        {"item_id": "canned_food", "quantity": 1}
    ])
    
    # SP_GloveBox - Reinforces car looting
    _configure_point(zone1, "SP_GloveBox", [
        {"item_id": "bandage", "quantity": 1}
    ])
    
    # SP_UnderBusBench - CRITICAL: Starting weapon
    _configure_point(zone1, "SP_UnderBusBench", [
        {"item_id": "weapon_m1911", "quantity": 1}
    ])

## Zone 2: Ammo Caches (3 points)
## Purpose: Resupply for checkpoint combat
func _configure_zone2() -> void:
    var zone2 = get_node_or_null("../ScavengePoints/Zone2_AmmoCaches")
    if not zone2:
        push_warning("[ScavengeSetup] Zone2_AmmoCaches node not found")
        return
    
    # SP_SandbagBunker - East flank reward
    _configure_point(zone2, "SP_SandbagBunker", [
        {"item_id": "ammo_45acp", "quantity": 14}
    ])
    
    # SP_MilitaryCrate - High-risk near tank
    _configure_point(zone2, "SP_MilitaryCrate", [
        {"item_id": "ammo_45acp", "quantity": 14},
        {"item_id": "bandage", "quantity": 1}
    ])
    
    # SP_GuardShack - Shotgun ammo teaser
    _configure_point(zone2, "SP_GuardShack", [
        {"item_id": "ammo_12ga", "quantity": 8}
    ])

## Zone 3: Medical Supplies (2 points)
## Purpose: Post-combat recovery
func _configure_zone3() -> void:
    var zone3 = get_node_or_null("../ScavengePoints/Zone3_Medical")
    if not zone3:
        push_warning("[ScavengeSetup] Zone3_Medical node not found")
        return
    
    # SP_RexallDrugs - Thematic drugstore medicine
    _configure_point(zone3, "SP_RexallDrugs", [
        {"item_id": "medkit", "quantity": 1}
    ])
    
    # SP_DinerKitchen - Exploration reward
    _configure_point(zone3, "SP_DinerKitchen", [
        {"item_id": "bandage", "quantity": 2},
        {"item_id": "canned_food", "quantity": 1}
    ])

func _configure_all_zones() -> void:
    _configure_zone1()
    _configure_zone2()
    _configure_zone3()

func _configure_point(zone: Node, point_name: String, items: Array) -> void:
    var point = zone.get_node_or_null(point_name)
    if not point:
        push_warning("[ScavengeSetup] Point not found: %s/%s" % [zone.name, point_name])
        return
    
    # Configure the ScavengePoint
    point.is_randomized = false
    point.item_pool = items
    point.min_items = items.size()
    point.max_items = items.size()
    
    # Wire looted signal to LevelManager
    if not point.is_connected("looted", _on_point_looted):
        point.looted.connect(_on_point_looted.bind(point_name))
    
    _total_points += 1
    
    if debug_logging:
        print("[ScavengeSetup] Configured: %s with %d item types" % [point_name, items.size()])

func _on_point_looted(items: Array, point_name: String) -> void:
    _points_looted += 1
    emit_signal("point_looted", point_name, items)
    
    # Notify LevelManager
    if _level_manager and _level_manager.has_method("item_collected"):
        for item in items:
            _level_manager.item_collected()
    
    if debug_logging:
        print("[ScavengeSetup] Looted: %s (%d/%d)" % [point_name, _points_looted, _total_points])

## Debug: Get current loot status
func get_loot_status() -> Dictionary:
    return {
        "total_points": _total_points,
        "points_looted": _points_looted,
        "percent_complete": (_points_looted / float(_total_points)) * 100.0 if _total_points > 0 else 0.0
    }
```

## Scene Integration

Add this script to the Level 1 scene:

```
Level1_TheHeights (Node3D)
??? LevelManager
??? Level1ScavengeSetup (Node) ??? Attach script here
?   Script: res://scripts/level_1_scavenge_setup.gd
?   debug_logging = true (dev) / false (release)
?
??? ScavengePoints (Node3D)
    ??? Zone1_TutorialLoot (Node3D)
    ?   ??? (5 ScavengePoint nodes from Phase 1A)
    ??? Zone2_AmmoCaches (Node3D)
    ?   ??? (3 ScavengePoint nodes from Phase 1B)
    ??? Zone3_Medical (Node3D)
        ??? (2 ScavengePoint nodes from Phase 1C)
```

## Signal Wiring Diagram

```
ScavengePoint.looted(items)
        ?
        ?
Level1ScavengeSetup._on_point_looted(items, point_name)
        ?
        ???? emit point_looted(point_name, items)
        ?
        ???? LevelManager.item_collected()
                    ?
                    ?
             items_collected++
```

## Deliverables
- [ ] `game/scripts/level_1_scavenge_setup.gd` created
- [ ] Script attached to Level 1 scene
- [ ] All 10 points configured on _ready()
- [ ] Signals wired to LevelManager
- [ ] Debug logging functional

## Testing Commands
```gdscript
# In-game console or debugger:
var setup = get_node("Level1ScavengeSetup")
print(setup.get_loot_status())

# Expected output at start:
# {"total_points": 10, "points_looted": 0, "percent_complete": 0.0}

# After looting all:
# {"total_points": 10, "points_looted": 10, "percent_complete": 100.0}
```
