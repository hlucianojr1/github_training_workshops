# FPS Feature Integration Plan for cpp_game

## Overview
Import FPS capabilities from Godot-FPS-Template into cpp_game's level_1.tscn. This plan implements:
- ✅ Optional FPS/TPS camera toggle via C++ ThirdPersonCamera modification
- ✅ TPS body with separate FPS weapon arms viewport
- ✅ GDScript wrapper layer for weapon states and effects

---

## Implementation Status

### Phase 1: C++ Camera Mode Toggle ✅ COMPLETE

**Modified Files:**
- [third_person_camera.hpp](../src/camera/third_person_camera.hpp)
  - Added `CameraMode` enum: `CAMERA_MODE_THIRD_PERSON`, `CAMERA_MODE_FIRST_PERSON`
  - New properties: `fps_head_height`, `mode_transition_speed`, `hide_player_in_fps`
  - Signal: `camera_mode_changed(int new_mode, bool is_first_person)`
  
- [third_person_camera.cpp](../src/camera/third_person_camera.cpp)
  - `update_camera_position()` - Smooth FPS/TPS transition with lerp
  - `handle_collision()` - Disabled in FPS mode
  - `set_camera_mode()`, `toggle_camera_mode()` methods
  - Full property bindings for editor exposure

**Usage in GDScript:**
```gdscript
# Toggle camera mode (bind to T key)
camera.toggle_camera_mode()

# Or set directly
camera.set_camera_mode(ThirdPersonCamera.CAMERA_MODE_FIRST_PERSON)

# Listen for changes
camera.camera_mode_changed.connect(_on_camera_mode_changed)
```

---

### Phase 2: GDScript Autoloads ✅ COMPLETE

**Created Files:**
| File | Purpose |
|------|---------|
| [scripts/autoload/constants.gd](../game/scripts/autoload/constants.gd) | Game constants (speeds, damage multipliers, sway/bob settings) |
| [scripts/autoload/global_input.gd](../game/scripts/autoload/global_input.gd) | Input helper functions |
| [scripts/autoload/signal_bus.gd](../game/scripts/autoload/signal_bus.gd) | Global event signals |

**Registered in project.godot as autoloads**

---

### Phase 3: Weapon State Machine ✅ COMPLETE

**Created Files:**
| File | Purpose |
|------|---------|
| [scripts/weapon/weapon_resource.gd](../game/scripts/weapon/weapon_resource.gd) | Resource class for weapon definitions |
| [scripts/weapon/weapon_state_machine.gd](../game/scripts/weapon/weapon_state_machine.gd) | State machine manager |
| [scripts/weapon/states/weapon_state_base.gd](../game/scripts/weapon/states/weapon_state_base.gd) | Base state class |
| [scripts/weapon/states/idle_weapon_state.gd](../game/scripts/weapon/states/idle_weapon_state.gd) | Ready/idle state |
| [scripts/weapon/states/shooting_weapon_state.gd](../game/scripts/weapon/states/shooting_weapon_state.gd) | Fire handling |
| [scripts/weapon/states/reloading_weapon_state.gd](../game/scripts/weapon/states/reloading_weapon_state.gd) | Reload sequence |

---

### Phase 4: Weapon Effects ✅ COMPLETE

**Created Files:**
| File | Purpose |
|------|---------|
| [scripts/weapon/effects/weapon_sway.gd](../game/scripts/weapon/effects/weapon_sway.gd) | Mouse + idle sway |
| [scripts/weapon/effects/weapon_bob.gd](../game/scripts/weapon/effects/weapon_bob.gd) | Movement bob |
| [scripts/weapon/effects/weapon_recoil.gd](../game/scripts/weapon/effects/weapon_recoil.gd) | Fire recoil + recovery |
| [scripts/weapon/effects/muzzle_flash.gd](../game/scripts/weapon/effects/muzzle_flash.gd) | Flash light + particles |

---

### Phase 5: FPS Weapon Controller ✅ COMPLETE

**Created Files:**
| File | Purpose |
|------|---------|
| [scripts/weapon/fps_weapon_controller.gd](../game/scripts/weapon/fps_weapon_controller.gd) | Main FPS weapon coordinator |
| [scripts/camera/weapon_camera.gd](../game/scripts/camera/weapon_camera.gd) | SubViewport camera sync |
| [scenes/player/fps_weapon_viewport.tscn](../game/scenes/player/fps_weapon_viewport.tscn) | Viewport scene for FPS arms |

---

## Remaining Tasks

### Phase 6: Integration into level_1.tscn ✅ COMPLETE

1. **Update player.tscn hierarchy:** ✅
   ```
   Player (PlayerController)
   ├── ThirdPersonCamera (C++ with player_camera_handler.gd)
   │   └── Camera3D (in group "main_camera", cull_mask excludes layer 10)
   ├── FPSWeaponViewport (SubViewportContainer)
   │   └── SubViewport/WeaponCamera/WeaponRig
   │       └── PistolFPS (with weapon_resource)
   ├── WeaponBridge (connects FPS controller to C++ weapon)
   ├── CharacterMesh (SavageModel, hidden in FPS)
   └── Weapon (C++ - keeps logic)
   ```

2. **Create M1911 weapon resource:** ✅
   - `game/assets/weapons/pistol/pistol_resource.tres` - configured
   - `game/assets/weapons/pistol/pistol_fps.tscn` - FPS scene with arms

3. **Import FPS arms from FPS-Template:** ✅
   - `assets/weapons/arms/arm.glb` and textures imported
   - `assets/weapons/arms/fps_arms.tscn` created
   - Pistol and AK-47 weapon scenes created with arms

4. **Wire camera mode toggle:** ✅
   - `player_camera_handler.gd` handles T key press
   - Connects to `camera_mode_changed` signal
   - Hides player mesh in FPS mode

5. **Update HUD:** ✅
   - Crosshair responds to camera mode and weapon fire
   - Ammo counter wired to `SignalBus.ammo_changed`
   - HUD controller connects to SignalBus weapon events

---

## Input Actions

| Action | Key | Status |
|--------|-----|--------|
| `shoot` | LMB | ✅ Exists |
| `aim` | RMB | ✅ Exists |
| `reload` | R | ✅ Exists |
| `toggle_camera` | T | ✅ Added |
| `interact` | E | ✅ Exists |

---

## Testing Checklist

- [x] Build C++ extension (Debug) - **PASSED**
- [ ] Camera smoothly transitions TPS↔FPS with T key
- [ ] Player mesh hidden in FPS mode
- [ ] FPS weapon viewport renders on layer 10
- [ ] Weapon sway responds to mouse movement
- [ ] Weapon bob responds to WASD movement
- [ ] Weapon recoil kicks on fire, recovers
- [ ] Muzzle flash triggers on fire
- [ ] State machine transitions: idle → shooting → idle
- [ ] Reload state plays and refills ammo
- [ ] HUD shows current ammo
- [ ] Crosshair expands on fire

---

## Next Steps for Testing

1. **Open Godot Editor** - Load `game/project.godot`
2. **Test in Editor** - Run the game (F5) with level_1.tscn
3. **Test Camera Toggle** - Press **T** to switch TPS ↔ FPS
4. **Test Weapon** - In FPS mode:
   - Left-click to fire
   - Watch ammo counter update
   - Press R to reload
   - Observe crosshair expansion on fire
5. **Verify Effects**:
   - Weapon sway when moving mouse
   - Weapon bob when walking (WASD)
   - Recoil kick on fire
   - Muzzle flash visible

---

## Known Limitations

- **No animations yet** - Arms are static (AnimationPlayer exists but no animations imported)
- **C++ Weapon integration** - FPS controller calls C++ methods, ensure Weapon class has proper methods
- **Player mesh hiding** - Currently hides entire mesh in FPS; ideally should only hide head bone
- **Audio positioning** - AudioStreamPlayer3D on FPS weapon may need adjustment

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      PlayerController (C++)                  │
│  - Movement, rotation, physics                               │
│  - Emits state signals (walking, sprinting, crouching)       │
└──────────────┬───────────────────────────────────────────────┘
               │
    ┌──────────┴──────────┐
    │                     │
    ▼                     ▼
┌────────────────┐   ┌────────────────────────────────────────┐
│ ThirdPersonCam │   │         FPSWeaponController (GD)       │
│ (C++ hybrid)   │   │                                        │
│                │   │  ┌─────────────────────────────────┐   │
│ - camera_mode  │   │  │ WeaponStateMachine              │   │
│ - fps_head_ht  │───│  │  └─ Idle / Shooting / Reloading │   │
│ - transition   │   │  └─────────────────────────────────┘   │
└────────────────┘   │                                        │
                     │  ┌─────────────────────────────────┐   │
                     │  │ Effects: Sway, Bob, Recoil      │   │
                     │  └─────────────────────────────────┘   │
                     │                                        │
                     │  ┌─────────────────────────────────┐   │
                     │  │ WeaponResource (.tres)          │   │
                     │  │  - Stats, positions, sounds     │   │
                     │  └─────────────────────────────────┘   │
                     │                    │                   │
                     │                    ▼                   │
                     │  ┌─────────────────────────────────┐   │
                     │  │ C++ Weapon (fire, ammo, damage) │◄──┤
                     │  └─────────────────────────────────┘   │
                     └────────────────────────────────────────┘
```

---

## File Summary

### C++ Modified
- `src/camera/third_person_camera.hpp` (+40 lines)
- `src/camera/third_person_camera.cpp` (+60 lines)

### GDScript Created (15 files)
- 3 autoloads
- 1 weapon resource class
- 4 state machine files
- 4 effect scripts
- 1 fps controller
- 1 camera script
- 1 viewport scene

### project.godot Updated
- Added 3 autoloads
- Added `toggle_camera` input action (T key)
