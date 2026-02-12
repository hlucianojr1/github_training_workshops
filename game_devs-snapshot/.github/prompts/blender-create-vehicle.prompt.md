---
agent: 'blender-artist'
description: 'Generate a 1960s vehicle model in Blender from specification using MCP server commands.'
---

Generate a 1960s vehicle model in Blender from specification.

## Load Context First
- Target spec: `docs/models/VEHICLE_SEDAN_SPEC.md`
- Art guidelines: `docs/ART_GUIDELINES.md`
- Existing models in: `game/assets/models/vehicles/`

## Input Parameters
- **Vehicle Type**: sedan | taxi | bus | truck | military
- **Damage State**: abandoned | damaged | destroyed | burned
- **Color Variant**: turquoise | black | cream | red

## Workflow

### Phase 1: Setup

Clear scene using `mcp_blender_execute_code`:
```python
code="import bpy; bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.delete()"
```

Get scene info using `mcp_blender_get_scene_info`.

### Phase 2: Body Construction

Build 1960s sedan shape using `mcp_blender_create_object`:

```
Main Body:
  type="cube", name="Body_Main", location=[0, 0, 0.7], scale=[2.7, 1.0, 0.6]

Roof:
  type="cube", name="Roof", location=[0, 0, 1.2], scale=[1.4, 0.9, 0.4]

Hood:
  type="cube", name="Hood", location=[1.8, 0, 0.6], scale=[1.2, 0.95, 0.35]

Trunk:
  type="cube", name="Trunk", location=[-2.0, 0, 0.5], scale=[1.0, 0.9, 0.4]

Tail Fin Left:
  type="cube", name="TailFin_L", location=[-2.4, 0.8, 0.8], scale=[0.45, 0.06, 0.3]

Tail Fin Right:
  type="cube", name="TailFin_R", location=[-2.4, -0.8, 0.8], scale=[0.45, 0.06, 0.3]
```

### Phase 3: Chrome Details

```
Front Bumper:
  type="cylinder", name="Bumper_Front", location=[2.6, 0, 0.3], scale=[0.08, 0.08, 0.95], rotation=[1.57, 0, 0]

Rear Bumper:
  type="cylinder", name="Bumper_Rear", location=[-2.7, 0, 0.35], scale=[0.08, 0.08, 0.95], rotation=[1.57, 0, 0]

Grille:
  type="cube", name="Grille", location=[2.65, 0, 0.55], scale=[0.04, 0.8, 0.4]

Headlight Left:
  type="sphere", name="Headlight_L", location=[2.6, 0.6, 0.6], scale=[0.1, 0.1, 0.1]

Headlight Right:
  type="sphere", name="Headlight_R", location=[2.6, -0.6, 0.6], scale=[0.1, 0.1, 0.1]
```

### Phase 4: Wheels

```
Wheel Front Left:
  type="cylinder", name="Wheel_FL", location=[1.5, 1.0, 0.35], scale=[0.35, 0.35, 0.1], rotation=[1.57, 0, 0]

Wheel Front Right:
  type="cylinder", name="Wheel_FR", location=[1.5, -1.0, 0.35], scale=[0.35, 0.35, 0.1], rotation=[1.57, 0, 0]

Wheel Rear Left:
  type="cylinder", name="Wheel_RL", location=[-1.5, 1.0, 0.35], scale=[0.35, 0.35, 0.1], rotation=[1.57, 0, 0]

Wheel Rear Right:
  type="cylinder", name="Wheel_RR", location=[-1.5, -1.0, 0.35], scale=[0.35, 0.35, 0.1], rotation=[1.57, 0, 0]
```

### Phase 5: Windows

```
Windshield:
  type="plane", name="Windshield", location=[0.9, 0, 1.1], scale=[1.2, 0.8, 1.0], rotation=[1.22, 0, 0]

Rear Window:
  type="plane", name="RearWindow", location=[-0.8, 0, 1.1], scale=[1.0, 0.7, 1.0], rotation=[1.92, 0, 0]
```

### Phase 6: Materials

Use `mcp_blender_set_material` for each part:

**Body Paint (Turquoise Two-Tone):**
```
Body_Main: color="#40E0D0", metallic=0.0, roughness=0.3
Hood: color="#40E0D0", metallic=0.0, roughness=0.3
Trunk: color="#40E0D0", metallic=0.0, roughness=0.3
Roof: color="#FFFFFF", metallic=0.0, roughness=0.3
```

**Chrome:**
```
Bumper_Front: color="#C0C0C0", metallic=1.0, roughness=0.1
Bumper_Rear: color="#C0C0C0", metallic=1.0, roughness=0.1
Grille: color="#C0C0C0", metallic=1.0, roughness=0.1
```

**Rubber (Tires):**
```
Wheel_FL: color="#1C1C1C", metallic=0.0, roughness=0.9
Wheel_FR: color="#1C1C1C", metallic=0.0, roughness=0.9
Wheel_RL: color="#1C1C1C", metallic=0.0, roughness=0.9
Wheel_RR: color="#1C1C1C", metallic=0.0, roughness=0.9
```

**Glass:**
```
Windshield: color="#87CEEB", metallic=0.0, roughness=0.05
RearWindow: color="#87CEEB", metallic=0.0, roughness=0.05
```

**Taillights:**
```
Taillight_L: color="#DC143C", metallic=0.0, roughness=0.2
Taillight_R: color="#DC143C", metallic=0.0, roughness=0.2
```

### Phase 7: Enhance Materials (CRITICAL!)

After basic materials, apply PBR presets for photorealistic vehicle rendering.

**Option A: Auto-Enhance**
```
Tool: mcp_blender_auto_enhance_materials
Parameters: aggressive=True
```

**Option B: Apply Specific Vehicle Presets (Recommended)**

Use `mcp_blender_apply_material_preset` for precise vehicle materials:

**Body Paint (1960s Car Paint with Clearcoat):**
```
object_name="Body_Main", material_preset="car_paint", color=[0.25, 0.88, 0.82, 1.0]  (turquoise)
object_name="Hood", material_preset="car_paint", color=[0.25, 0.88, 0.82, 1.0]
object_name="Trunk", material_preset="car_paint", color=[0.25, 0.88, 0.82, 1.0]
object_name="Roof", material_preset="car_paint", color=[1.0, 1.0, 1.0, 1.0]  (white)
object_name="TailFin_L", material_preset="car_paint", color=[0.25, 0.88, 0.82, 1.0]
object_name="TailFin_R", material_preset="car_paint", color=[0.25, 0.88, 0.82, 1.0]
```

**Chrome Trim (Mirror-like):**
```
object_name="Bumper_Front", material_preset="chrome"
object_name="Bumper_Rear", material_preset="chrome"
object_name="Grille", material_preset="chrome"
object_name="Headlight_L", material_preset="chrome"
object_name="Headlight_R", material_preset="chrome"
```

**Tires (Rubber):**
```
object_name="Wheel_FL", material_preset="rubber"
object_name="Wheel_FR", material_preset="rubber"
object_name="Wheel_RL", material_preset="rubber"
object_name="Wheel_RR", material_preset="rubber"
```

**Glass (Tinted/Frosted):**
```
object_name="Windshield", material_preset="frosted_glass"
object_name="RearWindow", material_preset="frosted_glass"
```

**Taillights (Glowing):**
```
Tool: mcp_blender_create_custom_pbr_material
Parameters: object_name="Taillight_L", base_color=[0.86, 0.08, 0.24, 1.0], emission_strength=2.0
Parameters: object_name="Taillight_R", base_color=[0.86, 0.08, 0.24, 1.0], emission_strength=2.0
```

**Verify Results:**
```
Tool: mcp_blender_get_viewport_screenshot
```

### Phase 8: Apply Bevel Modifiers (Optional)

For rounded 1960s look, use `mcp_blender_execute_code`:
```python
code="import bpy; obj=bpy.data.objects['Body_Main']; mod=obj.modifiers.new('Bevel', 'BEVEL'); mod.width=0.1; mod.segments=2"
```

### Phase 9: Apply Transforms

Use `mcp_blender_execute_code`:
```python
code="import bpy; bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)"
```

### Phase 10: Export

Use `mcp_blender_export_object` with **GLB format for static vehicles**:
```python
export_object(
    object_names=["Body_Main", "Roof", "Hood", "Trunk", "TailFin_L", "TailFin_R", 
                  "Bumper_Front", "Bumper_Rear", "Grille", "Headlight_L", "Headlight_R",
                  "Wheel_FL", "Wheel_FR", "Wheel_RL", "Wheel_RR", 
                  "Windshield", "RearWindow"],
    filepath="/Users/hluciano/projects/cpp_game/game/assets/models/vehicles/prop_vehicle_sedan_turquoise_lod0.glb",
    export_format="GLB",  # GLB for static vehicles, FBX if animated (doors, wheels)
    include_materials=True,
    include_textures=True,
    apply_modifiers=True
)
```

> **Format Note**: Use GLB for static scene vehicles. Use FBX if the vehicle has animated parts (opening doors, spinning wheels, etc.).

### Phase 11: Export Car Paint Materials

Save car paint materials to the library for color variants:
```python
# Export turquoise car paint
export_material(
    material_name="CarPaint_Turquoise",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/vehicle/us_mat_vehicle_paint_turquoise.json",
    export_format="JSON",
    pack_textures=True
)

# Export chrome trim material
export_material(
    material_name="Chrome",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/vehicle/us_mat_vehicle_chrome_clean.json",
    export_format="JSON",
    pack_textures=True
)

# Export rubber tire material
export_material(
    material_name="Rubber_Tire",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/vehicle/us_mat_vehicle_rubber_tire.json",
    export_format="JSON",
    pack_textures=True
)
```

## Color Variants

| Variant | Body Color | Roof Color |
|---------|------------|------------|
| Turquoise | #40E0D0 | #FFFFFF |
| Black | #1C1C1C | #1C1C1C |
| Cream | #F5F5DC | #F5F5DC |
| Red/White | #DC143C | #FFFFFF |
| Green | #93E9BE | #1C1C1C |

## Damage State Modifications

Use `mcp_blender_execute_code` for damage effects:

**Abandoned:**
```python
code="import bpy; [setattr(bpy.data.objects[f'Wheel_{w}'], 'scale', (0.35, 0.15, 0.35)) for w in ['FL','FR','RL','RR']]"
```

**Damaged (delete windows, add dents):**
```python
code="import bpy; bpy.data.objects.remove(bpy.data.objects['Windshield'])"
```

## Acceptance Criteria
- [ ] Vehicle dimensions ~5.4m × 2.0m × 1.4m
- [ ] 1960s features present (chrome, fins, rounded body)
- [ ] Materials correctly assigned
- [ ] **Exported using GLB format** (static) or **FBX** (animated)
- [ ] **Car paint materials exported to library** (for color variants)
- [ ] Opens in Godot without errors
- [ ] 1960s features present (chrome, fins, rounded body)
- [ ] Materials correctly assigned
- [ ] **Materials enhanced** (car_paint, chrome, rubber presets applied)
- [ ] **Screenshot verified** (get_viewport_screenshot reviewed)
- [ ] Damage state accurately represented
- [ ] Exported to correct path
- [ ] Opens in Godot without errors
