# Shared Animations

This folder contains animations used by multiple character types (player and enemies).

## Expected Files

| File | Description |
|------|-------------|
| `humanoid_locomotion.glb` | Basic locomotion shared across all humanoids |
| `humanoid_reactions.glb` | Hit reactions, deaths shared across all |

## Shared Animation List

These animations can be retargeted to any humanoid with SkeletonProfileHumanoid:

| Animation | Frames | Loop | Used By |
|-----------|--------|------|---------|
| idle | 60 | Yes | All |
| walk | 30 | Yes | All |
| run | 20 | Yes | All |
| crouch_idle | 60 | Yes | All |
| death | 45 | No | All |
| hit_react | 20 | No | All |

## Retargeting Workflow

1. Import shared animation GLB
2. Apply BoneMap in Godot import settings
3. Use AnimationLibrary to share across characters

## Godot AnimationLibrary Setup

```gdscript
# Load shared library
var shared_lib = preload("res://assets/animations/shared/humanoid_locomotion.glb")

# Add to character's AnimationPlayer
animation_player.add_animation_library("shared", shared_lib)

# Access animations as "shared/idle", "shared/walk", etc.
```

## Creation Workflow

Use `@animation-artist` agent with Mixamo imports for high-quality base animations.
