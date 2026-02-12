# Enemy Animations

This folder contains animation assets for enemy characters.

## Expected Files

After running the animation creation workflow:

| File | Description |
|------|-------------|
| `scavenger_anims.glb` | Scavenger enemy animations |
| `raider_anims.glb` | Raider enemy animations |
| `veteran_anims.glb` | Veteran enemy animations |
| `shared_enemy_anims.glb` | Animations shared by all enemy types |

## Animation List (14 animations)

| Animation | Frames | Loop | Description |
|-----------|--------|------|-------------|
| enemy_idle | 60 | Yes | Standing idle |
| enemy_walk | 30 | Yes | Patrol walking |
| enemy_run | 20 | Yes | Chase running |
| enemy_aim_weapon | 15 | No | Transition to aiming |
| enemy_recoil | 10 | No | Weapon recoil |
| enemy_cover_enter | 20 | No | Transition into cover |
| enemy_cover_idle | 60 | Yes | Crouched behind cover |
| enemy_cover_peek | 30 | No | Peek and aim from cover |
| enemy_melee_attack | 25 | No | Melee attack |
| enemy_death | 45 | No | Death fall forward |
| enemy_death_back | 45 | No | Death fall backward |
| enemy_hit_react | 20 | No | Hit reaction/flinch |
| enemy_limp | 40 | Yes | Injured walking |
| enemy_crouch_idle | 60 | Yes | Crouched idle |

## Frame Markers

| Animation | Marker | Frame | Description |
|-----------|--------|-------|-------------|
| enemy_cover_peek | can_fire | 15 | Aiming stable, can shoot |
| enemy_cover_peek | return_start | 22 | Returning to cover |

## Enemy Types

### Scavenger
- Uses all standard enemy animations
- Ragged, desperate movement style
- Higher hit_react frequency

### Raider
- More aggressive attack timing
- Faster cover transitions
- Armored death reactions

### Veteran
- Tactical movement patterns
- Precise weapon handling
- Disciplined cover usage

## Godot Import Settings

```
Skeleton3D → Retarget:
  BoneMap: SkeletonProfileHumanoid
  Bone Renamer → Rename Bones: ON
  Rest Fixer → Overwrite Axis: ON
```

## Creation Workflow

Use `@animation-artist` agent with `create-character-animations.prompt.md`
