# Player Animations

This folder contains animation assets for the player character.

## Expected Files

After running the animation creation workflow:

| File | Description |
|------|-------------|
| `player_anims.glb` | All player animations in one file |

## Animation List (15 animations)

| Animation | Frames | Loop | Priority |
|-----------|--------|------|----------|
| player_idle | 60 | Yes | P1 |
| player_walk | 30 | Yes | P1 |
| player_run | 20 | Yes | P1 |
| player_sprint | 20 | Yes | P1 |
| player_crouch_idle | 60 | Yes | P2 |
| player_crouch_walk | 40 | Yes | P2 |
| player_jump_start | 10 | No | P1 |
| player_jump_loop | 20 | Yes | P1 |
| player_jump_land | 15 | No | P1 |
| player_aim_idle | 60 | Yes | P1 |
| player_recoil | 10 | No | P1 |
| player_reload | 60 | No | P1 |
| player_melee_attack | 25 | No | P2 |
| player_death | 45 | No | P1 |
| player_hit_react | 20 | No | P1 |

## Frame Markers

| Animation | Marker | Frame | Description |
|-----------|--------|-------|-------------|
| player_reload | mag_out | 18 | Magazine removed |
| player_reload | mag_in | 42 | Magazine inserted |

## Godot Import Settings

```
Skeleton3D → Retarget:
  BoneMap: SkeletonProfileHumanoid
  Bone Renamer → Rename Bones: ON
  Rest Fixer → Overwrite Axis: ON
```

## Creation Workflow

Use `@animation-artist` agent with `create-character-animations.prompt.md`
