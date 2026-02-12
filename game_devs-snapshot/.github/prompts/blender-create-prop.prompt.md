---
agent: 'blender-artist'
description: 'Generate a prop model in Blender from specification using MCP server commands.'
---

Generate a prop model in Blender from specification.

## Load Context First
- Target spec: `docs/models/PROP_[NAME]_SPEC.md` (if exists)
- Art guidelines: `docs/ART_GUIDELINES.md`
- Prop budgets from `docs/ART_GUIDELINES.md` Section 2

## Input Parameters
- **Prop Category**: street_furniture | item | weapon | building_element
- **Prop Name**: Specific prop (e.g., fire_hydrant, mailbox, medkit)
- **Damage State**: pristine | weathered | damaged (optional)

## Quick Reference: Common Props

### Street Furniture

#### Fire Hydrant (300-500 tris)

**Step 1: Clear scene** using `mcp_blender_execute_code`:
```python
code="import bpy; bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.delete()"
```

**Step 2: Create parts** using `mcp_blender_create_object`:
```
Main Body:
  type="cylinder", name="Hydrant_Body", location=[0, 0, 0.3], scale=[0.15, 0.15, 0.3]

Top Cap:
  type="cylinder", name="Hydrant_Cap", location=[0, 0, 0.65], scale=[0.12, 0.12, 0.05]

Outlet Left:
  type="cylinder", name="Hydrant_Outlet_L", location=[0.18, 0, 0.35], scale=[0.06, 0.06, 0.08], rotation=[0, 1.57, 0]

Outlet Right:
  type="cylinder", name="Hydrant_Outlet_R", location=[-0.18, 0, 0.35], scale=[0.06, 0.06, 0.08], rotation=[0, 1.57, 0]

Base:
  type="cylinder", name="Hydrant_Base", location=[0, 0, 0.04], scale=[0.18, 0.18, 0.04]
```

**Step 3: Apply material** using `mcp_blender_set_material`:
```
All parts: color="#CC0000", metallic=0.0, roughness=0.6
```

**Step 4: Export** using `mcp_blender_export_object` (GLB for static props):
```python
export_object(
    object_names=["Hydrant_Body", "Hydrant_Cap", "Hydrant_Outlet_L", "Hydrant_Outlet_R", "Hydrant_Base"],
    filepath="/Users/hluciano/projects/cpp_game/game/assets/models/props/prop_street_fire_hydrant.glb",
    export_format="GLB",
    include_materials=True,
    apply_modifiers=True
)
```

**Step 5: Export Reusable Materials** (Optional - save to material library):
```python
# Export weathered paint material for reuse on other props
export_material(
    material_name="WeatheredPaint_Red",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/paint/us_mat_paint_weathered_red.json",
    export_format="JSON",
    pack_textures=True
)
```

#### Mailbox (200-400 tris)

Using `mcp_blender_create_object`:
```
Body:
  type="cube", name="Mailbox_Body", location=[0, 0, 1.0], scale=[0.3, 0.18, 0.36]

Top:
  type="sphere", name="Mailbox_Top", location=[0, 0, 1.25], scale=[0.15, 0.09, 0.075]

Post:
  type="cylinder", name="Mailbox_Post", location=[0, 0, 0.4], scale=[0.05, 0.05, 0.6]
```

Material: `color="#00308F", metallic=0.0, roughness=0.5`

Export: `export_object(filepath=".../props/prop_street_mailbox.glb", export_format="GLB")`

#### Trash Can (200-400 tris)

```
Body:
  type="cylinder", name="TrashCan_Body", location=[0, 0, 0.4], scale=[0.25, 0.25, 0.4]

Lid:
  type="cylinder", name="TrashCan_Lid", location=[0, 0, 0.82], scale=[0.27, 0.27, 0.025]
```

Material: `color="#708090", metallic=0.8, roughness=0.4`

For handle, use `mcp_blender_execute_code`:
```python
code="import bpy; bpy.ops.mesh.primitive_torus_add(major_radius=0.08, minor_radius=0.015, location=(0, 0, 0.9)); bpy.context.active_object.name='TrashCan_Handle'"
```

#### Street Lamp (500-800 tris)

```
Pole:
  type="cylinder", name="Lamp_Pole", location=[0, 0, 2.0], scale=[0.08, 0.08, 2.0]

Arm:
  type="cylinder", name="Lamp_Arm", location=[0.4, 0, 3.8], scale=[0.04, 0.04, 0.5], rotation=[0, 1.05, 0]

Housing:
  type="sphere", name="Lamp_Housing", location=[0.7, 0, 3.5], scale=[0.2, 0.2, 0.3]

Base:
  type="cylinder", name="Lamp_Base", location=[0, 0, 0.15], scale=[0.15, 0.15, 0.15]
```

Materials:
- Pole: `color="#2F4F4F", metallic=0.7, roughness=0.5`
- Housing: `color="#FFFAF0", metallic=0.0, roughness=0.1`

#### Phone Booth (800-1200 tris)

```
Frame:
  type="cube", name="Booth_Frame", location=[0, 0, 1.1], scale=[0.8, 0.8, 2.0]

Roof:
  type="cube", name="Booth_Roof", location=[0, 0, 2.25], scale=[0.94, 0.94, 0.13]

Glass Front:
  type="plane", name="Booth_Glass", location=[0.41, 0, 1.2], scale=[0.7, 1.26, 1.0], rotation=[1.57, 0, 1.57]
```

Materials:
- Frame: `color="#C0C0C0", metallic=0.6, roughness=0.4`
- Glass: `color="#87CEEB", metallic=0.0, roughness=0.05`

### Items (Pickups)

#### Medkit (200-400 tris)

```
Box:
  type="cube", name="Medkit_Box", location=[0, 0, 0.125], scale=[0.375, 0.25, 0.15]
```

Material: `color="#F5F5F5", metallic=0.0, roughness=0.7`

#### Ammo Box (100-300 tris)

```
Box:
  type="cube", name="AmmoBox", location=[0, 0, 0.075], scale=[0.225, 0.12, 0.12]
```

Material: `color="#4B5320", metallic=0.3, roughness=0.6`

## Phase 5: Material Enhancement (CRITICAL!)

After applying basic materials, enhance with PBR presets for photorealistic results.

### Auto-Enhance (Recommended)

Use `mcp_blender_auto_enhance_materials` to automatically apply appropriate materials:
```
Tool: mcp_blender_auto_enhance_materials
Parameters: aggressive=True
```

### Apply Specific Presets

For precise control, use `mcp_blender_apply_material_preset`:

**Fire Hydrant:**
```
object_name="Hydrant_Body", material_preset="weathered_paint", color=[0.8, 0.1, 0.1, 1.0]
object_name="Hydrant_Cap", material_preset="weathered_metal"
```

**Mailbox:**
```
object_name="Mailbox_Body", material_preset="weathered_paint", color=[0.0, 0.19, 0.56, 1.0]
object_name="Mailbox_Post", material_preset="brushed_metal"
```

**Trash Can:**
```
object_name="TrashCan_Body", material_preset="brushed_metal"
object_name="TrashCan_Lid", material_preset="weathered_metal"
```

**Street Lamp:**
```
object_name="Lamp_Pole", material_preset="weathered_metal"
object_name="Lamp_Housing", material_preset="frosted_glass"
object_name="Lamp_Bulb", material_preset="emission"
```

**Phone Booth:**
```
object_name="Booth_Frame", material_preset="brushed_metal"
object_name="Booth_Glass", material_preset="frosted_glass"
object_name="Booth_Phone", material_preset="glossy_plastic"
```

### Verify Results

Always take a screenshot to verify material quality:
```
Tool: mcp_blender_get_viewport_screenshot
```

## Weathering for Post-Apocalyptic Look

Use `mcp_blender_execute_code` to increase roughness:
```python
code="import bpy\nfor mat in bpy.data.materials:\n    if mat.node_tree:\n        for node in mat.node_tree.nodes:\n            if node.type == 'BSDF_PRINCIPLED':\n                node.inputs['Roughness'].default_value = min(node.inputs['Roughness'].default_value + 0.2, 1.0)"
```

## Acceptance Criteria
- [ ] Prop within polygon budget
- [ ] Materials correctly assigned
- [ ] **Materials enhanced** (auto_enhance_materials or presets applied)
- [ ] **Screenshot verified** (get_viewport_screenshot reviewed)
- [ ] Origin at base center
- [ ] Scale correct (real-world dimensions)
- [ ] **Exported using GLB format** (static props)
- [ ] **Reusable materials exported to library** (if applicable)
- [ ] Opens in Godot without errors
