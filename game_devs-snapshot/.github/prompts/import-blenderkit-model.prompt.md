```prompt
---
agent: 'blenderkit-asset-scout'
description: 'Complete workflow for downloading BlenderKit assets, reviewing quality, enhancing materials, and updating asset tracking.'
---

# Import BlenderKit Model

Full workflow from BlenderKit download to Godot-ready asset with documentation.

## Prerequisites

- BlenderKit integration configured (see `setup-blenderkit.prompt.md`)
- Asset ID from search results (via `search-blenderkit-asset.prompt.md`)
- Review poly budgets in `docs/ART_GUIDELINES.md`

---

## Input Parameters

- **Asset ID**: BlenderKit asset UUID from search results
- **Asset Name**: Descriptive name for the asset
- **Category**: `vehicles` | `props` | `architecture` | `characters` | `weapons`
- **Placement Location**: [X, Y, Z] coordinates in Blender (default: [0, 0, 0])

---

## Workflow

### Phase 1: Download Asset

#### Step 1.1: Verify BlenderKit Ready

```python
get_blenderkit_status()
```

#### Step 1.2: Clear Scene (Optional)

For clean review environment:

```python
mcp_blender_execute_blender_code(code='''
import bpy
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()
''')
```

#### Step 1.3: Download Asset

```python
result = download_blenderkit_asset(
    asset_id="[ASSET_ID]",
    location=[0, 0, 0],
    link=False  # Append data for full control
)
```

#### Step 1.4: Handle Background Download (If Large File)

If `result["status"] == "downloading"`:

```python
# Poll until complete
poll_blenderkit_download(download_id=result["download_id"])
```

See `poll-blenderkit-download.prompt.md` for detailed polling workflow.

---

### Phase 2: Quality Review

Hand off to **GLB Import Reviewer** agent or perform manual review:

#### Step 2.1: Setup Review Lighting

```python
mcp_blender_auto_setup_scene_lighting(
    scene_description="asset review studio",
    target_object="[IMPORTED_OBJECT_NAME]"
)
```

#### Step 2.2: Frame Asset

```python
mcp_blender_auto_frame_with_composition(
    target_object="[OBJECT_NAME]",
    shot_type="medium",
    composition_rule="center"
)
```

#### Step 2.3: Capture Preview

```python
mcp_blender_get_viewport_screenshot(max_size=1200)
```

#### Step 2.4: Analyze Mesh

```python
mcp_blender_analyze_mesh(object_name="[OBJECT_NAME]")
```

**Check against poly budgets:**

| Asset Type | Target | Action if Over |
|------------|--------|----------------|
| Vehicles | 3,000 - 6,000 | Decimate or find alternative |
| Props | 150 - 1,500 | Decimate if >2x target |
| Buildings | 8,000 - 10,000 | May be acceptable |

#### Step 2.5: Inspect Materials

```python
mcp_blender_list_materials(object_name="[OBJECT_NAME]")
```

---

### Phase 3: Material Enhancement (If Needed)

Hand off to **Texture Artist** agent or apply presets:

#### Step 3.1: Auto-Enhance Materials

```python
mcp_blender_auto_enhance_materials(object_name="[OBJECT_NAME]", aggressive=True)
```

#### Step 3.2: Apply Period-Specific Materials

For 1960s accuracy:

```python
# Example: Vehicle materials
mcp_blender_apply_material_preset("[BODY_OBJECT]", "glossy_paint")
mcp_blender_apply_material_preset("[CHROME_OBJECT]", "chrome")
mcp_blender_apply_material_preset("[GLASS_OBJECT]", "clear_glass")
```

#### Step 3.3: Add Weathering (Post-Apocalyptic)

```python
mcp_blender_apply_material_preset("[METAL_PARTS]", "weathered_metal")
```

---

### Phase 4: Export for Godot

#### Step 4.1: Export as GLB

```python
mcp_blender_execute_blender_code(code='''
import bpy

# Select all mesh objects
bpy.ops.object.select_all(action='DESELECT')
for obj in bpy.context.scene.objects:
    if obj.type == 'MESH':
        obj.select_set(True)

# Export GLB
bpy.ops.export_scene.gltf(
    filepath="/Users/hluciano/projects/cpp_game/game/models/[CATEGORY]/[ASSET_NAME].glb",
    export_format='GLB',
    use_selection=True,
    export_materials='EXPORT'
)
''')
```

**Naming Convention**: `[category]_[descriptive_name]_lod0.glb`

Examples:
- `vehicle_sedan_vintage_lod0.glb`
- `prop_street_lamppost_lod0.glb`
- `building_storefront_diner_lod0.glb`

---

### Phase 5: Update Documentation

#### Step 5.1: Update ASSET_TRACKER.md

Add entry with Source and License columns:

```markdown
| [Asset Name] | [Poly Target] | [Texture Size] | ✅ | BlenderKit | CC0 | asset_id: [ID], [additional notes] |
```

#### Step 5.2: Record Asset Details

```markdown
**Asset**: [Name]
**Source**: BlenderKit
**Asset ID**: [UUID]
**License**: [CC0 / Royalty-Free]
**Poly Count**: [X,XXX]
**Exported To**: game/models/[category]/[filename].glb
**Materials**: [List of materials applied]
**Notes**: [Any special considerations]
```

---

## Quick Reference: BlenderKit License Types

| License | Status | Usage |
|---------|--------|-------|
| CC0 | ✅ Preferred | Public domain, no restrictions |
| Royalty Free | ✅ Acceptable | Commercial use allowed |
| Editorial | ⚠️ Caution | Check specific restrictions |

**Default assumption**: If `free_only=True` was used, asset is likely CC0 or Royalty-Free.

---

## Agent Handoffs

| Phase | Agent | Purpose |
|-------|-------|---------|
| Quality Review | `@glb-import-reviewer` | Mesh topology, UV, material assessment |
| Material Work | `@texture-artist` | PBR enhancement, weathering |
| Level Placement | `@level-populator` | Add to Godot scenes |
| Documentation | `@doc-maintainer` | Update ASSET_TRACKER.md |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Download failed | Check BlenderKit status, retry |
| Asset too high-poly | Apply decimation modifier |
| Missing materials | Use auto_enhance_materials or manual setup |
| Wrong scale | Scale in Blender, apply transforms |
| Export failed | Check file path, permissions |
| Textures missing in Godot | Ensure GLB export includes materials |

---

## Example Complete Workflow

```python
# 1. Download
result = download_blenderkit_asset(asset_id="abc123-uuid", location=[0, 0, 0])

# 2. Setup lighting and capture preview
mcp_blender_auto_setup_scene_lighting(scene_description="asset review", target_object="Vintage_Car")
mcp_blender_get_viewport_screenshot()

# 3. Analyze
mcp_blender_analyze_mesh(object_name="Vintage_Car")
mcp_blender_list_materials(object_name="Vintage_Car")

# 4. Enhance materials
mcp_blender_auto_enhance_materials(object_name="Vintage_Car", aggressive=True)

# 5. Verify with screenshot
mcp_blender_get_viewport_screenshot()

# 6. Export GLB
# (Use execute_blender_code with export script)

# 7. Update ASSET_TRACKER.md
```

---

## Related Prompts

- `setup-blenderkit.prompt.md` — First-time configuration
- `search-blenderkit-asset.prompt.md` — Find assets
- `poll-blenderkit-download.prompt.md` — Large file downloads
```
