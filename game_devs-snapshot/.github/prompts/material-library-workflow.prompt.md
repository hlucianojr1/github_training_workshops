```prompt
---
agent: 'texture-artist'
description: 'Manage the Urban Survivor material library - export, organize, and import reusable PBR materials using Blender MCP tools.'
---

Manage the Urban Survivor material library for consistent, reusable PBR materials.

## Load Context First
- Art guidelines: `docs/ART_GUIDELINES.md` (Section 2.5: Material Library Workflow)
- Material presets: Review available presets with `list_material_presets()`

## Material Library Location
```
game/assets/materials/library/
├── metal/        # rust, chrome, brushed, weathered
├── glass/        # window, frosted, tinted, dirty
├── fabric/       # leather, canvas, cotton, wool
├── paint/        # wall, weathered, glossy, peeling
├── architectural/ # brick, concrete, plaster, tile
├── organic/      # skin, wood, vegetation
└── vehicle/      # car_paint, chrome, rubber, vinyl
```

## Naming Convention
```
us_mat_[category]_[name].json

Examples:
- us_mat_metal_rust_heavy.json
- us_mat_glass_window_dirty.json
- us_mat_fabric_leather_worn.json
- us_mat_vehicle_paint_turquoise.json
```

---

## Workflow 1: Audit Scene Materials

Before exporting, audit what materials exist:

```python
# List all materials in the current scene
list_materials()
# Returns: {"materials": ["CarPaint", "Chrome", "Rubber"], "count": 3}

# List materials on a specific object
list_materials(object_name="Car_Body")

# Get detailed material data (node graph, PBR values)
get_material_data(material_name="CarPaint")
```

---

## Workflow 2: Export Single Material

Export a specific material to the library:

```python
# 1. Verify material exists
get_material_data(material_name="Weathered_Chrome")

# 2. Determine category
# - Metal materials → metal/
# - Glass materials → glass/
# - Fabric/leather → fabric/
# - Paint materials → paint/
# - Brick/concrete → architectural/
# - Skin/wood → organic/
# - Vehicle-specific → vehicle/

# 3. Export with naming convention
export_material(
    material_name="Weathered_Chrome",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/metal/us_mat_metal_chrome_weathered.json",
    export_format="JSON",
    include_textures=True,
    pack_textures=True  # Copy texture files alongside JSON
)
```

---

## Workflow 3: Batch Export All Scene Materials

Export all materials from a completed asset:

```python
# Get all materials
materials = list_materials()

for mat_name in materials["materials"]:
    # Determine category from material name
    category = "metal"  # Default
    name_lower = mat_name.lower()
    
    if "paint" in name_lower or "wall" in name_lower:
        category = "paint"
    elif "glass" in name_lower or "window" in name_lower:
        category = "glass"
    elif "fabric" in name_lower or "leather" in name_lower or "cloth" in name_lower:
        category = "fabric"
    elif "brick" in name_lower or "concrete" in name_lower or "plaster" in name_lower:
        category = "architectural"
    elif "skin" in name_lower or "wood" in name_lower:
        category = "organic"
    elif "car" in name_lower or "vehicle" in name_lower or "tire" in name_lower or "rubber" in name_lower:
        category = "vehicle"
    elif "chrome" in name_lower or "rust" in name_lower or "metal" in name_lower:
        category = "metal"
    
    # Create safe filename
    safe_name = mat_name.lower().replace(" ", "_").replace(".", "_")
    
    export_material(
        material_name=mat_name,
        filepath=f"/Users/hluciano/projects/cpp_game/game/assets/materials/library/{category}/us_mat_{category}_{safe_name}.json",
        export_format="JSON",
        pack_textures=True
    )
    
    print(f"Exported: {mat_name} → {category}/us_mat_{category}_{safe_name}.json")
```

---

## Workflow 4: Import Material from Library

Import a saved material into a new project:

```python
# Import from JSON
import_material(
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/vehicle/us_mat_vehicle_paint_turquoise.json",
    material_name="CarPaint_Turquoise"  # Optional: rename on import
)

# Import from Blender library file
import_material(
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/metal/us_mat_metal_complex.blend",
    material_name="ComplexMetal"
)

# Apply imported material to object
apply_material_preset("Car_Body", "CarPaint_Turquoise")
```

---

## Workflow 5: Create Color Variants

Create and export color variants of a material:

```python
# Import base car paint material
import_material(
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/vehicle/us_mat_vehicle_paint_turquoise.json",
    material_name="CarPaint_Base"
)

# Modify color using execute_blender_code
mcp_blender_execute_blender_code(code='''
import bpy
mat = bpy.data.materials.get("CarPaint_Base")
if mat and mat.node_tree:
    for node in mat.node_tree.nodes:
        if node.type == 'BSDF_PRINCIPLED':
            node.inputs["Base Color"].default_value = (0.8, 0.1, 0.1, 1.0)  # Red
            break
mat.name = "CarPaint_Red"
''')

# Export the variant
export_material(
    material_name="CarPaint_Red",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/vehicle/us_mat_vehicle_paint_red.json",
    export_format="JSON",
    pack_textures=True
)
```

---

## Workflow 6: Export Complex Materials as BLEND

For materials with complex node setups, export as Blender library:

```python
# Export as BLEND file (preserves full node graph)
export_material(
    material_name="ComplexPBR_Weathered",
    filepath="/Users/hluciano/projects/cpp_game/game/assets/materials/library/metal/us_mat_metal_pbr_weathered.blend",
    export_format="BLEND"
)
```

---

## Material Categories Reference

| Category | Folder | Common Materials | 1960s Context |
|----------|--------|------------------|---------------|
| `metal` | `library/metal/` | rust, chrome, brushed, weathered, copper | Chrome trim, rust decay |
| `glass` | `library/glass/` | window, frosted, tinted, dirty, broken | Store windows, phone booths |
| `fabric` | `library/fabric/` | leather, canvas, cotton, wool, worn | Clothing, car interiors |
| `paint` | `library/paint/` | wall, weathered, glossy, peeling, faded | Building exteriors |
| `architectural` | `library/architectural/` | brick, concrete, plaster, tile, asphalt | NYC buildings, streets |
| `organic` | `library/organic/` | skin, wood, vegetation | Characters, furniture |
| `vehicle` | `library/vehicle/` | car_paint, chrome, rubber, vinyl, headlight | 1960s automobiles |

---

## Acceptance Criteria
- [ ] Material exported with correct naming convention (`us_mat_[category]_[name].json`)
- [ ] Material saved to correct category folder
- [ ] Textures packed alongside JSON (if `pack_textures=True`)
- [ ] Material imports correctly in new scene
- [ ] PBR values verified with `get_material_data()`
- [ ] Material matches 1960s Urban Survivor aesthetic
```