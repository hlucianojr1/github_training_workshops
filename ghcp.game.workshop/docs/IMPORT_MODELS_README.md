# OBJ Model Import Workflow - Quick Reference

## Quick Start

### Import a New Model
```bash
./import_obj_model.sh <model_file.obj> <category> <asset_name>
```

**Example**:
```bash
./import_obj_model.sh phonbooth.obj props phone_booth
./import_obj_model.sh car.obj vehicles chevy_belair_1957_wrecked
```

## Categories
- `props` - Street furniture, environment objects
- `vehicles` - Cars, buses, tanks, trucks  
- `characters` - Player models, civilian NPCs
- `enemies` - Hostile characters
- `weapons` - Guns, melee weapons

## File Naming
Input: `phonbooth.obj`  
Output: `prop_prop_phone_booth_lod0.obj`

Pattern: `prop_[category-singular]_[asset_name]_lod0.obj`

## What the Script Does
1. ✅ Validates input file and category
2. ✅ Shows vertex/face count statistics
3. ✅ Copies .obj to `game/assets/models/[category]/`
4. ✅ Copies .mtl file if present
5. ✅ Creates Godot `.import` file with proper settings
6. ✅ Outputs next steps instructions

## After Import
1. Open Godot Editor
2. Wait for import progress (bottom-right)
3. Find asset: `res://assets/models/[category]/[filename]`
4. Add to scene by dragging or instantiating
5. Update `docs/ASSET_TRACKER.md` with ✅ status

## Full Documentation
See [.github/prompts/import-obj-model.prompt.md](.github/prompts/import-obj-model.prompt.md) for:
- Detailed usage examples
- Troubleshooting guide
- Scene integration instructions
- Prompt templates for AI assistance

## Model Requirements
Follow specs in `docs/ART_GUIDELINES.md`:
- Small props: 200-800 tris
- Large props: 1,500-6,000 tris
- Vehicles: 2,500-5,000 tris
- Characters: 3,000-8,000 tris

## Recently Imported
- ✅ Phone Booth (Superman style) - 9,182 verts, 20,000 faces
- ✅ 1957 Chevrolet Bel Air (Wrecked) - 9,182 verts, 20,000 faces
