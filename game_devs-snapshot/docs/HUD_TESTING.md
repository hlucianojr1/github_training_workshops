## Testing HUD Integration - Quick Start Guide

### Prerequisites
1. **Build completed**: Debug build successful with updated `DamageSystem` and `Weapon` classes
2. **HUD scene updated**: [game/scenes/ui/hud.tscn](game/scenes/ui/hud.tscn) now uses C++ HUD class with controller script attached

### Test Setup in Godot Editor

#### 1. Verify HUD Scene Structure
Open `game/scenes/ui/hud.tscn` in Godot and verify:
- Root node is type `HUD` (C++ class)
- Script `hud_controller.gd` is attached
- Child nodes exist: `AmmoLabel`, `HealthLabel`, `HealthBar`, `StaminaBar`, `ObjectiveLabel`

#### 2. Set Up Player Node for Testing
In your test scene (`test_scene.tscn` or `level_1.tscn`), ensure the player has:

**Option A: Use C++ PlayerController (recommended)**
```
PlayerController (type: PlayerController)
├─ CollisionShape3D
├─ MeshInstance3D (visual representation)
├─ CameraPivot (Node3D)
│  └─ Camera3D
├─ SurvivalStats (type: SurvivalStats)
├─ Inventory (type: Inventory)
└─ Weapon (type: Weapon)
   └─ MuzzlePoint (Marker3D)
```

Add the player to the **"player"** group:
- Select PlayerController node
- Go to Node tab > Groups
- Add to group: `player`

**Option B: Quick Test with Simple Node**
If C++ player isn't ready, create a minimal test:
```gdscript
extends CharacterBody3D

func _ready():
    add_to_group("player")
    
    # Add SurvivalStats
    var stats = Node.new()
    stats.name = "SurvivalStats"
    stats.set_script(preload("res://path_to_survival_stats.gd")) # if GDScript wrapper exists
    add_child(stats)
    
    # Add test weapon
    var weapon = Node.new()
    weapon.name = "Weapon"
    # Configure weapon signals
    add_child(weapon)
```

#### 3. Set Up DamageSystem Singleton
Add DamageSystem as an autoload:
- Project > Project Settings > Autoload
- Click folder icon, navigate to the scene/script containing DamageSystem
- Node Name: `DamageSystem`
- Enable

**OR** add DamageSystem to the scene:
- Add a `DamageSystem` node to the scene root
- Add it to group `damage_system`

### Running the Test

#### 1. Launch Test Scene
- Open `game/scenes/test_scene.tscn` or your test level
- Press F5 or click Play Scene

#### 2. Watch Console Output
You should see:
```
[HUD Controller] Initializing signal connections...
[HUD Controller] Player found: PlayerController
[HUD Controller] Connected to SurvivalStats.health_changed
[HUD Controller] Initial health: 100/100
[HUD Controller] Found weapon via player.equipped_weapon
[HUD Controller] Connected to Weapon.ammo_changed
[HUD Controller] Initial ammo: 8/24
[HUD Controller] Found DamageSystem autoload
[HUD Controller] Connected to DamageSystem.damage_dealt
[HUD Controller] Setup complete.
```

#### 3. Test Weapon Firing
- **Left Click** to shoot
- Console should show:
  ```
  [HUD Controller] Ammo updated: 7/24
  ```
- HUD ammo counter should update in real-time

#### 4. Test Damage (if enemies present)
- Shoot at enemy or trigger damage on player
- Console should show:
  ```
  [HUD Controller] Player took 10 damage from EnemyAI
  [HUD Controller] Health updated: 90/100
  ```
- Health bar should update

#### 5. Test Reload
- Press R to reload
- Console should show multiple ammo updates as reload completes

### Troubleshooting

#### ❌ "No player found in 'player' group"
**Fix**: Add the player node to the "player" group in the scene

#### ❌ "No weapon found on player"
**Fix**: 
- Ensure player has an `equipped_weapon` property (C++ PlayerController)
- OR add Weapon as child node named "Weapon"
- OR create weapon at path "WeaponHolder/Weapon"

#### ❌ "DamageSystem not found"
**Fix**: 
- Add DamageSystem as autoload in Project Settings
- OR add DamageSystem node to scene and put in "damage_system" group

#### ❌ "SurvivalStats doesn't have 'health_changed' signal"
**Check**: Verify SurvivalStats class emits `health_changed(float, float)` signal in C++

#### ❌ HUD displays but doesn't update
**Debug**:
1. Check console for connection messages
2. Verify signals are being emitted (add debug prints to C++ Weapon/SurvivalStats)
3. Test manually: In scene tree, call `HUD.update_ammo(5, 20)` to verify method works

### Expected Results ✅

- **HUD initializes** with current health/ammo values
- **Ammo counter updates** when weapon fires/reloads
- **Health bar updates** when player takes damage
- **Console shows** all signal connections and updates

### Next Steps After Successful Test

Once HUD is working:
1. ✅ **Vertical Slice complete** - Player can shoot, damage applies, HUD updates
2. 🎯 **Next task**: Implement AI ATTACK state (enemies return fire)
3. 🎨 **Polish**: Add visual feedback (crosshair hit markers, damage flash, etc.)

---

**Note**: This test focuses on verifying the signal pipeline works end-to-end. Visual polish and HUD layout refinement comes later.
