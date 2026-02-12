---
agent: 'animation-artist'
description: 'Import Mixamo animations, retarget to project skeleton, and export as GLB for Godot.'
---

Import and retarget Mixamo animations for Urban Survivor characters.

## Load Context First
- docs/ART_GUIDELINES.md (skeleton hierarchy, bone naming)
- game/assets/animations/player/README.md (expected output)
- game/assets/animations/enemies/README.md (expected output)

## Prerequisites
- Mixamo FBX animation file(s) downloaded
- Target character model open in Blender with armature
- Blender MCP Animation System available

## Input Parameters
- `mixamo_fbx_path`: Path to downloaded Mixamo FBX file
- `target_armature`: Name of target armature in Blender (e.g., "Armature")
- `animation_name`: Name for the imported animation (e.g., "walk", "run")
- `output_path`: Export path for GLB file

## Workflow Steps

### Step 1: Validate Target Armature

```python
# Check target armature exists and get bone info
await get_armature_info(ctx, armature_name="Armature")

# List bones with Mixamo mapping
await get_armature_bones(ctx, armature_name="Armature", bone_mapping="mixamo")
```

### Step 2: Import Mixamo FBX

```python
# Import the Mixamo FBX file
# Note: Mixamo exports with "mixamorig:" prefix on all bones
import_code = """
import bpy

# Import FBX
bpy.ops.import_scene.fbx(
    filepath="{mixamo_fbx_path}",
    use_anim=True,
    ignore_leaf_bones=True,
    automatic_bone_orientation=True
)

# Get imported armature (usually named "Armature" or character name)
imported_armature = bpy.context.selected_objects[0]
print(f"Imported: {imported_armature.name}")
"""
await execute_blender_code(ctx, import_code)
```

### Step 3: Transfer Animation to Target

```python
# Option A: If same skeleton structure, copy action directly
transfer_code = """
import bpy

# Get source (Mixamo imported) and target armatures
source = bpy.data.objects["Armature.001"]  # Imported
target = bpy.data.objects["Armature"]       # Project character

# Get the action from source
if source.animation_data and source.animation_data.action:
    action = source.animation_data.action
    
    # Rename action to project naming convention
    action.name = "{animation_name}"
    
    # Assign to target
    if not target.animation_data:
        target.animation_data_create()
    target.animation_data.action = action
    
    print(f"Transferred action: {action.name}")

# Delete imported armature (keep action)
bpy.data.objects.remove(source, do_unlink=True)
"""
await execute_blender_code(ctx, transfer_code)
```

### Step 4: Validate Animation

```python
# Check action was transferred
await list_actions(ctx, armature_name="Armature")

# Set as active action
await set_active_action(ctx, armature_name="Armature", action_name="{animation_name}")

# Preview
await play_animation(ctx, loop=True)
await stop_animation(ctx)
```

### Step 5: Export as GLB

```python
# Export with animation
await export_animation_gltf(
    ctx,
    filepath="{output_path}",
    armature_name="Armature",
    action_name="{animation_name}",
    include_mesh=True,
    export_format="GLB"
)
```

---

## Batch Import Workflow

For importing multiple Mixamo animations at once:

```python
# List of Mixamo FBX files to import
mixamo_files = [
    ("/path/to/Walking.fbx", "walk"),
    ("/path/to/Running.fbx", "run"),
    ("/path/to/Idle.fbx", "idle"),
    ("/path/to/Jump.fbx", "jump"),
]

for fbx_path, anim_name in mixamo_files:
    # Import
    import_code = f"""
import bpy
bpy.ops.import_scene.fbx(filepath="{fbx_path}", use_anim=True, ignore_leaf_bones=True)
imported = bpy.context.selected_objects[0]

# Transfer action
if imported.animation_data and imported.animation_data.action:
    action = imported.animation_data.action
    action.name = "player_{anim_name}"
    
    target = bpy.data.objects["Armature"]
    if not target.animation_data:
        target.animation_data_create()
    target.animation_data.action = action

# Cleanup
bpy.data.objects.remove(imported, do_unlink=True)
"""
    await execute_blender_code(ctx, import_code)
    print(f"Imported: player_{anim_name}")

# Export all animations in one GLB
await export_animation_gltf(
    ctx,
    filepath="/Users/hluciano/projects/cpp_game/game/assets/animations/player/player_mixamo.glb",
    armature_name="Armature",
    include_mesh=True,
    export_format="GLB"
)
```

---

## Godot Import Configuration

After exporting GLB, configure Godot import settings:

```
1. Select GLB file in Godot FileSystem
2. Click "Reimport" or "Advanced..."
3. Navigate to: Skeleton3D → Retarget

Settings:
  Skeleton Profile: SkeletonProfileHumanoid
  
  Remove Tracks:
    Except Bone Transform: OFF
    Unimportant Positions: ON
    Unmapped Bones: ON
  
  Bone Renamer:
    Rename Bones: ON
    Unique Node: ON
  
  Rest Fixer:
    Apply Node Transform: ON
    Normalize Position Tracks: ON
    Overwrite Axis: ON  ← CRITICAL
    Fix Silhouette: ON (if A-pose source)

4. Click "Reimport"
```

---

## Mixamo Download Tips

When downloading from Mixamo.com:

| Setting | Recommended Value |
|---------|-------------------|
| Format | FBX Binary (.fbx) |
| Skin | Without Skin (animations only) |
| Frames per Second | 30 |
| Keyframe Reduction | None (for quality) |

**Recommended Mixamo Animations for Urban Survivor:**

| Category | Mixamo Animation Name |
|----------|----------------------|
| Idle | "Idle", "Breathing Idle" |
| Walk | "Walking", "Walk Strafe" |
| Run | "Running", "Jogging" |
| Sprint | "Sprint", "Fast Run" |
| Crouch | "Crouch Idle", "Crouch Walk" |
| Jump | "Jump", "Running Jump" |
| Combat | "Rifle Aiming Idle", "Firing Rifle" |
| Cover | "Take Cover", "Peek A Boo" |
| Death | "Dying", "Death From Front" |
| Hit | "Hit Reaction", "Stumble Backwards" |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Bones don't match | Use `get_armature_bones()` to compare; adjust bone mapping |
| Animation plays wrong | Check "Overwrite Axis" is ON in Godot import |
| Character deforms badly | Ensure source is T-pose; enable "Fix Silhouette" |
| Animation too fast | Verify FPS matches (30 FPS in both Blender and Godot) |
| Multiple armatures | Delete imported armature after copying action |

## Acceptance Criteria
- [ ] Mixamo FBX imported successfully
- [ ] Animation transferred to target armature
- [ ] Action renamed to project convention
- [ ] Animation previews correctly in Blender
- [ ] GLB exported to animations folder
- [ ] Godot import settings configured
- [ ] No bone rotation issues in Godot
