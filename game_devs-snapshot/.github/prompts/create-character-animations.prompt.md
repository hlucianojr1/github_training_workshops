---
agent: 'animation-artist'
description: 'Batch-apply all character animations using MCP Animation System presets and export as GLB for Godot.'
---

Create complete animation sets for player and enemy characters using MCP presets.

## Load Context First
- docs/ART_GUIDELINES.md (animation list, skeleton)
- game/assets/animations/player/README.md (output spec)
- game/assets/animations/enemies/README.md (output spec)

## Prerequisites
- Character model open in Blender with rigged armature
- Blender MCP Animation System with 25 presets available
- Bone mapping validated (mixamo, rigify, or generic)

## Workflow Overview

1. Validate armature and bone mapping
2. Apply all required animation presets
3. Verify animations play correctly
4. Export as GLB for Godot

---

## Step 1: Validate Armature

```python
# Check armature exists
await get_armature_info(ctx, armature_name="Armature")

# Validate bone mapping - try different mappings if needed
await get_armature_bones(ctx, armature_name="Armature", bone_mapping="mixamo")
# OR: bone_mapping="generic" for SkeletonProfileHumanoid naming
# OR: bone_mapping="rigify" for Blender Rigify rigs
```

---

## Step 2: Apply Player Animations (15 animations)

```python
# Player animation set matching ART_GUIDELINES.md
player_animations = [
    # Locomotion (10)
    ("idle", "player_idle"),
    ("walk", "player_walk"),
    ("run", "player_run"),
    ("sprint", "player_sprint"),
    ("crouch_idle", "player_crouch_idle"),
    ("crouch_walk", "player_crouch_walk"),
    ("jump_start", "player_jump_start"),
    ("jump_loop", "player_jump_loop"),
    ("jump_land", "player_jump_land"),
    ("limp", "player_limp"),
    
    # Combat (3)
    ("aim_idle", "player_aim_idle"),
    ("recoil", "player_recoil"),
    ("reload", "player_reload"),
    
    # Actions (2)
    ("melee_attack", "player_melee"),
    ("death", "player_death"),
    ("hit_react", "player_hit_react"),
]

# Apply each preset
for preset_name, action_name in player_animations:
    await apply_animation_preset(
        ctx,
        preset_name=preset_name,
        armature_name="Armature",
        bone_mapping="mixamo",  # Adjust based on Step 1
        action_name=action_name
    )
    print(f"Applied: {action_name}")
```

---

## Step 3: Apply Enemy Animations (14 animations)

```python
# Enemy animation set matching ART_GUIDELINES.md
enemy_animations = [
    # Locomotion (5)
    ("idle", "enemy_idle"),
    ("walk", "enemy_walk"),
    ("run", "enemy_run"),
    ("crouch_idle", "enemy_crouch_idle"),
    ("limp", "enemy_limp"),
    
    # Combat (6)
    ("aim_weapon", "enemy_aim_weapon"),
    ("recoil", "enemy_recoil"),
    ("cover_enter", "enemy_cover_enter"),
    ("cover_idle", "enemy_cover_idle"),
    ("cover_peek", "enemy_cover_peek"),
    ("melee_attack", "enemy_melee_attack"),
    
    # Reactions (3)
    ("death", "enemy_death"),
    ("hit_react", "enemy_hit_react"),
]

for preset_name, action_name in enemy_animations:
    await apply_animation_preset(
        ctx,
        preset_name=preset_name,
        armature_name="Armature",
        bone_mapping="mixamo",
        action_name=action_name
    )
    print(f"Applied: {action_name}")
```

---

## Step 4: Verify Animations

```python
# List all created actions
await list_actions(ctx, armature_name="Armature")

# Preview key animations
test_animations = ["player_idle", "player_walk", "player_run", "player_aim_idle", "player_reload"]

for anim in test_animations:
    await set_active_action(ctx, armature_name="Armature", action_name=anim)
    await play_animation(ctx, loop=True)
    # Visual inspection pause
    await stop_animation(ctx)
```

---

## Step 5: Export Player Animations

```python
# Export all player animations in one GLB
await export_animation_gltf(
    ctx,
    filepath="/Users/hluciano/projects/cpp_game/game/assets/animations/player/player_anims.glb",
    armature_name="Armature",
    include_mesh=True,
    export_format="GLB"
)
```

---

## Step 6: Export Enemy Animations

```python
# For enemies, you can either:

# Option A: Export all to one file (if same armature)
await export_animation_gltf(
    ctx,
    filepath="/Users/hluciano/projects/cpp_game/game/assets/animations/enemies/enemy_anims.glb",
    armature_name="Armature",
    include_mesh=True,
    export_format="GLB"
)

# Option B: Export per enemy type (if different models)
# Load scavenger model, apply presets, export
# Load raider model, apply presets, export
# etc.
```

---

## Frame Marker Reference

Important frame markers for gameplay sync:

| Animation | Marker | Frame | C++ Usage |
|-----------|--------|-------|-----------|
| player_reload | mag_out | 18 | Disable firing |
| player_reload | mag_in | 42 | Restore ammo count |
| enemy_cover_peek | can_fire | 15 | Enable AI shooting |
| enemy_cover_peek | return_start | 22 | Transition back to cover_idle |

### C++ Integration Example

```cpp
// In Weapon::reload() or PlayerController
void PlayerController::handle_reload_animation(int frame) {
    if (frame >= 18 && !reload_mag_removed) {
        // Magazine physically removed
        reload_mag_removed = true;
        can_fire = false;
    }
    if (frame >= 42 && reload_mag_removed) {
        // Magazine inserted
        current_ammo = max_ammo;
        reload_mag_removed = false;
        // can_fire restored when animation completes
    }
}
```

---

## Quick Reference: All 25 Presets

| Preset | Frames | Loop | Player | Enemy |
|--------|--------|------|--------|-------|
| idle | 60 | ✓ | ✓ | ✓ |
| walk | 30 | ✓ | ✓ | ✓ |
| run | 20 | ✓ | ✓ | ✓ |
| sprint | 20 | ✓ | ✓ | - |
| crouch_idle | 60 | ✓ | ✓ | ✓ |
| crouch_walk | 40 | ✓ | ✓ | - |
| jump_start | 10 | ✗ | ✓ | - |
| jump_loop | 20 | ✓ | ✓ | - |
| jump_land | 15 | ✗ | ✓ | - |
| aim_weapon | 15 | ✗ | - | ✓ |
| aim_idle | 60 | ✓ | ✓ | - |
| recoil | 10 | ✗ | ✓ | ✓ |
| reload | 60 | ✗ | ✓ | - |
| cover_enter | 20 | ✗ | - | ✓ |
| cover_idle | 60 | ✓ | - | ✓ |
| cover_peek | 30 | ✗ | - | ✓ |
| melee_attack | 25 | ✗ | ✓ | ✓ |
| limp | 40 | ✓ | ✓ | ✓ |
| death | 45 | ✗ | ✓ | ✓ |
| hit_react | 20 | ✗ | ✓ | ✓ |
| jump | 45 | ✗ | - | - |
| crouch | 20 | ✗ | - | - |
| roll | 30 | ✗ | ✓ | - |
| t_pose | 1 | ✗ | utility | utility |
| a_pose | 1 | ✗ | utility | utility |

---

## Acceptance Criteria

- [ ] Armature validated with correct bone mapping
- [ ] All 15 player animations applied
- [ ] All 14 enemy animations applied  
- [ ] Animations preview correctly (no bone issues)
- [ ] Looping animations verified (idle, walk, run)
- [ ] Frame markers documented for reload, cover_peek
- [ ] Player GLB exported to `game/assets/animations/player/`
- [ ] Enemy GLB exported to `game/assets/animations/enemies/`
- [ ] Export confirmed successful (check file size > 0)
