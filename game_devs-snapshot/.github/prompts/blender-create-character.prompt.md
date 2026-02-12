---
agent: 'blender-artist'
description: 'Generate a character model in Blender from specification using MCP server commands.'
---

Generate a character model in Blender from specification.

## Load Context First
- Target spec file: `docs/models/[CHARACTER]_SPEC.md`
- Art guidelines: `docs/ART_GUIDELINES.md`
- Existing models in: `game/assets/models/characters/`

## Input Parameters
- **Spec File**: Path to character specification (e.g., PLAYER_MODEL_SPEC.md)
- **Detail Level**: placeholder | basic | detailed
- **Variant**: Which variant to create (e.g., male_a, female_a)

## Workflow

### Phase 1: Setup

Clear the scene using `mcp_blender_execute_code`:
```python
code="import bpy; bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.delete()"
```

Get scene info using `mcp_blender_get_scene_info` to confirm clean state.

### Phase 2: Create Character

**Option A: Use Template Script (Recommended)**

For a proper humanoid with edge loops, use `mcp_blender_execute_code`:
```python
# Male Player (1.75m)
code="HEIGHT=1.75; GENDER='male'; NAME='char_player_male'; SUBDIVISIONS=1; exec(open('/Users/hluciano/projects/cpp_game/game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"

# Female Player (1.65m)
code="HEIGHT=1.65; GENDER='female'; NAME='char_player_female'; SUBDIVISIONS=1; exec(open('/Users/hluciano/projects/cpp_game/game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"

# Scavenger Enemy (1.70m, low poly)
code="HEIGHT=1.70; GENDER='male'; NAME='char_enemy_scavenger'; SUBDIVISIONS=0; exec(open('/Users/hluciano/projects/cpp_game/game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"
```

**Option B: Build from Primitives (Simple Placeholder)**

Use `mcp_blender_create_object` for each body part:

```
Head:
  type="sphere", name="Head", location=[0, 0, 1.6], scale=[0.12, 0.12, 0.12]

Torso:
  type="cube", name="Torso", location=[0, 0, 1.2], scale=[0.4, 0.25, 0.6]

Hips:
  type="cube", name="Hips", location=[0, 0, 0.85], scale=[0.35, 0.18, 0.2]

Left Arm:
  type="cylinder", name="Arm_L", location=[-0.35, 0, 1.2], scale=[0.05, 0.05, 0.3], rotation=[0, 1.57, 0]

Right Arm:
  type="cylinder", name="Arm_R", location=[0.35, 0, 1.2], scale=[0.05, 0.05, 0.3], rotation=[0, -1.57, 0]

Left Leg:
  type="cylinder", name="Leg_L", location=[-0.1, 0, 0.45], scale=[0.07, 0.07, 0.45]

Right Leg:
  type="cylinder", name="Leg_R", location=[0.1, 0, 0.45], scale=[0.07, 0.07, 0.45]

Left Foot:
  type="cube", name="Foot_L", location=[-0.1, 0.05, 0.05], scale=[0.08, 0.15, 0.04]

Right Foot:
  type="cube", name="Foot_R", location=[0.1, 0.05, 0.05], scale=[0.08, 0.15, 0.04]
```

### Phase 3: Apply Materials

Use `mcp_blender_set_material` for each material zone:

```
Head (Skin):
  object_name="Head", material_name="Skin", color="#D2A679", metallic=0.0, roughness=0.5

Torso (Jacket):
  object_name="Torso", material_name="LeatherBomber", color="#8B4513", metallic=0.0, roughness=0.5

Hips (Pants):
  object_name="Hips", material_name="Slacks", color="#4A4A4A", metallic=0.0, roughness=0.8

Legs (Pants):
  object_name="Leg_L", material_name="Slacks", color="#4A4A4A", metallic=0.0, roughness=0.8
  object_name="Leg_R", material_name="Slacks", color="#4A4A4A", metallic=0.0, roughness=0.8

Feet (Boots):
  object_name="Foot_L", material_name="Boots", color="#654321", metallic=0.0, roughness=0.6
  object_name="Foot_R", material_name="Boots", color="#654321", metallic=0.0, roughness=0.6
```

### Phase 4: Enhance Materials (CRITICAL!)

After basic materials, enhance with PBR presets for photorealistic results.

**Option A: Auto-Enhance (Recommended for hero characters)**
```
Tool: mcp_blender_auto_enhance_materials
Parameters: aggressive=True
```

**Option B: Apply Specific Presets**

Use `mcp_blender_apply_material_preset` for precise control:
```
object_name="Torso", material_preset="weathered_paint", color=[0.55, 0.27, 0.07, 1.0]
object_name="Foot_L", material_preset="rubber"
object_name="Foot_R", material_preset="rubber"
object_name="Belt_Buckle", material_preset="chrome"  (if present)
object_name="Watch", material_preset="brushed_metal"  (if present)
```

**Verify Results:**
```
Tool: mcp_blender_get_viewport_screenshot
```

### Phase 5: Join and Prepare (Optional)

Use `mcp_blender_execute_code` to join all objects:
```python
code="import bpy; bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.join(); bpy.context.active_object.name='char_player_male'; bpy.ops.object.origin_set(type='ORIGIN_GEOMETRY', center='BOUNDS')"
```

### Phase 6: UV Unwrap

Use `mcp_blender_execute_code`:
```python
code="import bpy; bpy.ops.object.mode_set(mode='EDIT'); bpy.ops.mesh.select_all(action='SELECT'); bpy.ops.uv.smart_project(angle_limit=66, island_margin=0.02); bpy.ops.object.mode_set(mode='OBJECT')"
```

### Phase 7: Apply Transforms

Use `mcp_blender_execute_code`:
```python
code="import bpy; bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)"
```

### Phase 8: Export

Use `mcp_blender_export_object` with **FBX format for rigged characters**:
```python
export_object(
    object_names=["char_player_male"],
    filepath="/Users/hluciano/projects/cpp_game/game/assets/models/characters/char_player_male_lod0.fbx",
    export_format="FBX",  # FBX recommended for rigged/animated characters
    include_materials=True,
    include_textures=True,
    apply_modifiers=False  # Keep armature modifiers
)
```

> **Format Note**: Use FBX for rigged characters as it better preserves skeletal mesh data and animations in Godot. Use GLB only for static character props.

### Phase 9: Export Reusable Materials

Save character materials to the library for reuse:
```python
# Export skin material
export_material(
    material_name="Skin",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/organic/us_mat_organic_skin_caucasian.json",
    export_format="JSON",
    pack_textures=True
)

# Export leather jacket material
export_material(
    material_name="LeatherBomber",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/fabric/us_mat_fabric_leather_bomber.json",
    export_format="JSON",
    pack_textures=True
)
```

## Verification

After export, verify:
- [ ] File exists at export path
- [ ] **Exported using FBX format** (for rigged characters)
- [ ] Open in Godot to check import
- [ ] Materials appear correctly
- [ ] **Materials enhanced** (auto_enhance_materials or presets applied)
- [ ] **Screenshot verified** (get_viewport_screenshot reviewed)
- [ ] **Reusable materials exported to library** (skin, fabric, leather)
- [ ] Scale is correct (1.75m height for male player)

## Detail Level Variations

### Placeholder
- Primitive shapes only (cubes, cylinders, spheres)
- Simple materials with flat colors
- No rigging
- Quick iteration (~2 minutes)

### Basic (Use Template Script)
- Proper humanoid topology with edge loops
- Subdivision surface modifier
- Better proportions
- Ready for simple animations

### Detailed
- Full body topology
- Proper edge flow
- Ready for rigging
- May need external sculpt import

## Acceptance Criteria
- [ ] Model matches spec dimensions
- [ ] Materials match spec colors
- [ ] Exported to correct path
- [ ] Opens in Godot without errors
