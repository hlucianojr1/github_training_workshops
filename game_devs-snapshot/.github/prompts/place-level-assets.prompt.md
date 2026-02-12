---
agent: 'level-populator'
description: 'Place building models and props into Level 1 scene with proper transforms and hierarchy.'
---

Place building and prop models into Level 1 for city block population.

## Load Context First
- game/scenes/level_1.tscn (current scene)
- game/assets/models/buildings/ (available buildings)
- game/assets/models/city/ (city block models)
- game/assets/models/props/ (available props)
- game/assets/models/vehicles/ (available vehicles)
- docs/SPEC.md Section 7 (World Design)

## Requirements
- Organize assets under proper parent nodes (Buildings, Props, etc.)
- Configure transforms for realistic placement
- Follow naming conventions
- Maintain performance budgets
- Ensure navigable paths for player

## Workflow

1. **Audit Assets**
   - List available models in each category
   - Note which models are ready for placement

2. **Inspect Current Scene**
   - Review existing node hierarchy
   - Identify where new assets should be added
   - Check existing transform patterns

3. **Plan Placement**
   - Sketch grid layout mentally
   - Identify building positions along streets
   - Plan prop clusters (hydrants, lamps, debris)
   - Mark vehicle placement for cover

4. **Add External Resources**
   - Add `[ext_resource]` entries for each model
   - Use proper `res://` paths

5. **Create Node Hierarchy**
   - Add parent groups if missing (Buildings, Props/Vehicles, etc.)
   - Add individual asset nodes under correct parents

6. **Configure Transforms**
   - Set position (origin x, y, z)
   - Set rotation (90°, 180° as needed)
   - Set scale if required

7. **Validate**
   - Open scene in Godot
   - Check 3D viewport
   - Test player navigation
   - Verify no overlapping collision

## Acceptance Criteria
- [ ] All placed assets visible in scene
- [ ] Node hierarchy properly organized
- [ ] Transforms create realistic layout
- [ ] Player can navigate through level
- [ ] Scene loads without errors
- [ ] Performance acceptable (check FPS)
