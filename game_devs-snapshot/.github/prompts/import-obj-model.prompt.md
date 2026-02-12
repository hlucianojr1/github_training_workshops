# Import OBJ Model into Urban Survivor Project

## Purpose
This prompt automates the process of importing new .obj 3D models into the Urban Survivor Godot project, ensuring consistent naming, proper organization, and correct import settings.

## When to Use
- You have a new .obj model file (character, vehicle, prop, weapon, enemy)
- You need to add it to the Godot project with proper configuration
- You want to replace an existing model with a new version
- You need to update the asset tracker documentation

## Prerequisites
- .obj file in the project root directory (or provide full path)
- (Optional) .mtl material file with the same base name
- Know the model category: `props`, `vehicles`, `characters`, `enemies`, or `weapons`
- Choose a descriptive `snake_case` name for the asset

---

## Prompt Template

```
I have a new .obj model to import into the Urban Survivor project:

**File**: [filename.obj]
**Category**: [props/vehicles/characters/enemies/weapons]
**Asset Name**: [descriptive_snake_case_name]
**Description**: [Brief description of what this model represents]

Please:
1. Use the import_obj_model.sh script to import this model
2. Update the ASSET_TRACKER.md to mark this asset as complete
3. If this replaces an existing model, note the replacement
4. Verify the model statistics (vertex/face count) are reasonable
5. Provide instructions for adding it to level_1.tscn if appropriate

Additional context:
[Any special requirements, scale considerations, or placement notes]
```

---

## Example Usage

### Example 1: Phone Booth Prop
```
I have a new .obj model to import into the Urban Survivor project:

**File**: phonbooth.obj
**Category**: props
**Asset Name**: phone_booth
**Description**: 1960s-style Superman phone booth with glass panels

Please:
1. Use the import_obj_model.sh script to import this model
2. Update the ASSET_TRACKER.md to mark this asset as complete
3. This replaces the existing phone booth model
4. Verify the model statistics (vertex/face count) are reasonable
5. Provide instructions for adding it to level_1.tscn in Zone 3 (commercial district)

Additional context:
This should be usable as cover in combat. Place multiple instances along Broadway.
```

### Example 2: Vehicle
```
I have a new .obj model to import into the Urban Survivor project:

**File**: car.obj
**Category**: vehicles
**Asset Name**: chevy_belair_1957_wrecked
**Description**: 1957 Chevrolet Bel Air in wrecked/rusted condition

Please:
1. Use the import_obj_model.sh script to import this model
2. Update the ASSET_TRACKER.md to mark this asset as complete
3. This is a replacement for the existing wrecked Bel Air
4. Verify the model statistics (vertex/face count) are reasonable
5. Provide instructions for adding it to level_1.tscn

Additional context:
This is period-accurate for the 1960s setting. It should have visible rust and damage.
Place instances throughout all three zones as abandoned vehicles.
```

### Example 3: Enemy Character
```
I have a new .obj model to import into the Urban Survivor project:

**File**: scavenger_enemy.obj
**Category**: enemies
**Asset Name**: scavenger_hostile
**Description**: Hostile scavenger character with tattered 1960s clothing

Please:
1. Use the import_obj_model.sh script to import this model
2. Update the ASSET_TRACKER.md to mark this asset as complete
3. This is a new asset (no replacement)
4. Verify the model statistics (vertex/face count) are reasonable
5. Note that this will be used with the EnemyAI system

Additional context:
This model needs to be compatible with animation rigging. Scale should match the player character height.
```

---

## Script Reference

### Manual Import Command
```bash
./import_obj_model.sh <source_obj_file> <category> <asset_name>
```

### Categories
- **props** - Street furniture, environment objects
- **vehicles** - Cars, buses, tanks, trucks
- **characters** - Player models, civilian NPCs
- **enemies** - Hostile characters
- **weapons** - Guns, melee weapons

### Naming Convention
Use `snake_case` with descriptive names:
- ✅ Good: `phone_booth`, `chevy_belair_1957_wrecked`, `scavenger_hostile`
- ❌ Bad: `PhoneBooth`, `car1`, `enemy`

### Output Naming
The script automatically generates:
- File: `prop_[category-singular]_[asset_name]_lod0.obj`
- Examples:
  - `prop_prop_phone_booth_lod0.obj`
  - `prop_vehicle_chevy_belair_1957_wrecked_lod0.obj`
  - `prop_enemy_scavenger_hostile_lod0.obj`

---

## Workflow Steps

### 1. Pre-Import Checks
- Verify .obj file exists in project root
- Check for accompanying .mtl file
- Confirm model category and asset name

### 2. Run Import Script
```bash
./import_obj_model.sh [file.obj] [category] [asset_name]
```

### 3. Post-Import Tasks
- Update `docs/ASSET_TRACKER.md` status to ✅ Complete
- Add notes about vertex/face counts
- Document any special properties (destructible, animated, etc.)

### 4. Scene Integration (if needed)
- Open `game/scenes/level_1.tscn`
- Add instances with proper Transform3D values
- Set collision layers if needed
- Test in-game visibility and scale

### 5. Version Control
```bash
git add game/assets/models/[category]/
git add docs/ASSET_TRACKER.md
git commit -m "Add [asset_name] model to [category]"
```

---

## Troubleshooting

### Model Not Appearing in Godot
1. Check the bottom-right of Godot for import progress
2. Verify the .import file was created
3. Reimport: Right-click asset → "Reimport"

### Wrong Scale in Scene
- Modify the model in Blender and re-export
- Or adjust `root_scale` in the .import file

### Missing Materials
- Ensure .mtl file is in the same directory as .obj
- Check .mtl references texture files that also exist
- Textures should be in `game/assets/textures/`

### High Poly Count Warning
- Target poly counts (from ASSET_TRACKER.md):
  - Small props: 200-800 tris
  - Large props: 1,500-6,000 tris
  - Vehicles: 2,500-5,000 tris
  - Characters: 3,000-8,000 tris
- Optimize in Blender if counts exceed targets

---

## Related Documentation
- [docs/ASSET_TRACKER.md](../../docs/ASSET_TRACKER.md) - Track asset completion status
- [docs/ART_GUIDELINES.md](../../docs/ART_GUIDELINES.md) - Art style and technical specs
- [docs/LEVEL_1_DESIGN.md](../../docs/LEVEL_1_DESIGN.md) - Where assets are used

---

## Notes
- The import script creates Godot 4.3+ compatible .import files
- LOD0 suffix indicates highest detail level (for future LOD system)
- All paths use `res://` for Godot project-relative addressing
- Models are imported as PackedScene for easy instantiation
