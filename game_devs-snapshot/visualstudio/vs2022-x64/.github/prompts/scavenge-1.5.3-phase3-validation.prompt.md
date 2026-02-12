# Phase 3: Validation - Resource Balance & Smoke Test

## Context
- **Task**: 1.5.3 - Add 10 scavenge points across Level 1
- **Phase**: 3 (Final - after Phase 2 complete)
- **Agent Type**: Background/Cloud Agent
- **Purpose**: Verify implementation meets acceptance criteria

## Prerequisites
- Phase 1A, 1B, 1C: All 10 nodes created
- Phase 2: Integration script deployed
- Build successful

## Validation Checklist

### ? Acceptance Criteria (from PRODUCTION_PLAN.md)

| Criterion | Expected | Verification Method |
|-----------|----------|---------------------|
| Zone 1 scavenge points | 5 | Count nodes under Zone1_TutorialLoot |
| Zone 2 scavenge points | 3 | Count nodes under Zone2_AmmoCaches |
| Zone 3 scavenge points | 2 | Count nodes under Zone3_Medical |
| Tutorial loot (Zone 1) | Starting gear | Verify weapon + ammo in item_pool |
| Ammo caches (Zone 2) | Combat resupply | Verify ammo items in item_pool |
| Medical (Zone 3) | Healing items | Verify bandage/medkit in item_pool |

### ? Resource Balance Verification

**Total Resources Available:**

| Item | Zone 1 | Zone 2 | Zone 3 | **TOTAL** |
|------|--------|--------|--------|-----------|
| Bandages | 3 | 1 | 2 | **6** |
| Medkit | 0 | 0 | 1 | **1** |
| .45 ACP Ammo | 14 | 28 | 0 | **42 rounds** |
| 12ga Shells | 0 | 8 | 0 | **8 rounds** |
| Canned Food | 1 | 0 | 1 | **2** |
| M1911 Pistol | 1 | 0 | 0 | **1** |

**Healing Capacity:**
- Bandages: 6 × 25 HP = 150 HP
- Medkit: 1 × 75 HP = 75 HP
- **Total Healing: 225 HP**

**Combat Math (Normal Difficulty):**
```
ENEMIES:
- Zone 2: 5 enemies (3 Scavengers @ 75 HP + 2 Raiders @ 100 HP)
- Zone 3: 3 enemies (2 Scavengers @ 75 HP + 1 Raider @ 100 HP)
- Total: 8 enemies, 700 HP combined

PLAYER DAMAGE OUTPUT:
- M1911: 25 damage per hit
- Hits to kill all enemies: 700 / 25 = 28 hits minimum
- Ammo available: 42 rounds
- Hit rate allowed: 28 / 42 = 67% (33% miss rate OK)
? PASS: Ammo sufficient

ENEMY DAMAGE TO PLAYER:
- Scavengers: 15 damage per hit
- Raiders: 20 damage per hit
- Assuming 2-3 hits taken per enemy: 8 × 2.5 × 17.5 avg = 350 potential damage
- Realistic with cover: ~120-180 damage taken

HEALING AVAILABLE: 225 HP
- Player starts: 100 HP
- Damage taken: ~150 HP (with cover play)
- Healing needed: 150 HP
- Healing available: 225 HP
? PASS: Healing sufficient (50% buffer)

VERDICT: Level beatable on Normal difficulty
```

### ? Placement Verification

| Point | Visibility | Thematic | Risk/Reward |
|-------|------------|----------|-------------|
| SP_CarTrunk | Visible from spawn | ? Cars have trunks | Tutorial (safe) |
| SP_Suitcase | On main path | ? Evacuation debris | Tutorial (safe) |
| SP_BusInterior | Off main path | ? People left items | Exploration reward |
| SP_GloveBox | Near cars | ? Cars have glove boxes | Tutorial (safe) |
| SP_UnderBusBench | Requires search | ? Hidden weapon | Critical pickup |
| SP_SandbagBunker | After flank route | ? Military supplies | Combat reward |
| SP_MilitaryCrate | Near patrol | ? Supply crate | HIGH RISK |
| SP_GuardShack | After clear | ? Guard supplies | Post-combat |
| SP_RexallDrugs | In drugstore | ? **Pharmacy = Medicine** | Recovery |
| SP_DinerKitchen | In diner | ? Kitchen = Food/Aid | Exploration |

### ? Smoke Test Procedure

**Build Verification:**
```powershell
# Build the project
cmake --build build --config Debug

# Expected: Build succeeded
```

**Runtime Test:**
1. Open Godot: `game/project.godot`
2. Load Level 1 scene (test_scene.tscn or level_1.tscn)
3. Run scene (F5)

**Test Cases:**

| Test | Action | Expected Result |
|------|--------|-----------------|
| T1 | Spawn and look around | SP_CarTrunk visible from spawn |
| T2 | Walk to SP_CarTrunk, press E | Loot 2× Bandage, point marked as looted |
| T3 | Check debug output | `[ScavengeSetup] Looted: SP_CarTrunk (1/10)` |
| T4 | Loot SP_UnderBusBench | Receive M1911 Pistol |
| T5 | Walk to Zone 2, loot SP_MilitaryCrate | Receive ammo + bandage |
| T6 | Walk to Zone 3, loot SP_RexallDrugs | Receive Medkit |
| T7 | Loot all 10 points | `get_loot_status()` returns 100% complete |
| T8 | Try to loot same point twice | No items received (already looted) |

**Console Verification:**
```gdscript
# After looting all points:
var setup = get_node("Level1ScavengeSetup")
print(setup.get_loot_status())

# Expected:
# {"total_points": 10, "points_looted": 10, "percent_complete": 100.0}
```

## Final Checklist

### Implementation Complete
- [ ] 10 ScavengePoint nodes in scene tree
- [ ] Zone1_TutorialLoot: 5 points configured
- [ ] Zone2_AmmoCaches: 3 points configured
- [ ] Zone3_Medical: 2 points configured
- [ ] level_1_scavenge_setup.gd script attached
- [ ] Signals wired to LevelManager

### Balance Verified
- [ ] 42 rounds .45 ACP available (sufficient for 8 enemies)
- [ ] 225 HP healing available (sufficient buffer)
- [ ] M1911 Pistol obtainable in Zone 1
- [ ] Medkit available in Zone 3

### Quality Verified
- [ ] First loot visible from spawn
- [ ] Thematic consistency (drugstore ? medicine)
- [ ] Risk/reward placement (MilitaryCrate is dangerous)
- [ ] No points block patrol routes

### Smoke Test Passed
- [ ] Build succeeds
- [ ] All 10 points lootable
- [ ] Signals fire correctly
- [ ] LevelManager tracks items_collected
- [ ] Cannot loot same point twice

## Task 1.5.3 Status

```
???????????????????????????????????????????????????????????
?              TASK 1.5.3 VALIDATION RESULT               ?
???????????????????????????????????????????????????????????
?                                                         ?
?  Acceptance Criteria:  [ ] PASS  [ ] FAIL               ?
?  Resource Balance:     [ ] PASS  [ ] FAIL               ?
?  Smoke Test:           [ ] PASS  [ ] FAIL               ?
?                                                         ?
?  ?????????????????????????????????????????????????????  ?
?                                                         ?
?  FINAL STATUS:  [ ] COMPLETE  [ ] NEEDS WORK            ?
?                                                         ?
?  Notes: ____________________________________________    ?
?                                                         ?
???????????????????????????????????????????????????????????
```
