---
agent: 'model-spec-writer'
description: 'Generate a complete player character model specification for 3D artists.'
---

Create a player character model specification document.

## Load Context First
- docs/ART_GUIDELINES.md (poly budgets, texture specs)
- docs/SPEC.md Section 8 (character design)
- Existing character specs in docs/ (if any)

## Input Parameters
Customize based on user request:
- **Gender**: male | female | both
- **Outfit Style**: default | military | civilian | scavenger
- **Animation Set**: full | locomotion_only | minimal

## Output
Create `docs/models/PLAYER_MODEL_SPEC.md` with:

1. **Overview**
   - Purpose (main playable character)
   - Visual style (1960s American everyman/everywoman)
   - Gameplay role (third-person survival shooter)

2. **Body Specifications**
   - Height: 1.75m (male), 1.65m (female)
   - Build: Athletic survivor
   - Age appearance: 28-40
   - Polygon budget: 15,000-20,000 triangles

3. **Default Outfit (1960s Survivor)**
   - Head: Short practical hair
   - Torso_Under: Dirty white t-shirt
   - Torso_Over: Brown leather bomber jacket
   - Legs: Dark gray high-waisted slacks
   - Feet: Brown leather work boots

4. **Modular Clothing System**
   - 8 slots: Head_Hair, Head_Hat, Face, Torso_Under, Torso_Over, Hands, Legs, Feet
   - Each slot as separate mesh
   - All weighted to shared skeleton

5. **Skeleton Requirements**
   - 65-70 bones total
   - Godot Humanoid compatible
   - Full finger bones (3 joints each)
   - IK targets for hands/feet

6. **Material Requirements**
   - PBR Metallic/Roughness
   - 2048x2048 body texture
   - 1024x1024 per clothing piece
   - Albedo, Normal, ORM maps

7. **Animation List**
   - Locomotion: idle, walk (8-dir), run (8-dir)
   - Crouch: idle, walk (8-dir)
   - Jump: start, loop, land
   - Combat: aim, fire, reload (per weapon type)
   - Actions: interact, melee, death, hit_react

8. **Export Settings**
   - GLTF 2.0 Separate format
   - Scale: 1.0 (1 unit = 1 meter)
   - T-pose or A-pose rest position
   - Forward: -Z, Up: +Y

9. **1960s Reference Checklist**
   - High-waisted pants (not modern)
   - Period-appropriate jacket styles
   - Work boots (not sneakers)
   - Short, practical haircuts
   - No synthetic fabric appearance

10. **File Naming**
    - char_player_male_lod0.gltf
    - char_player_female_lod0.gltf
    - anim_player_idle.gltf
    - etc.

## Acceptance Criteria
- [ ] Spec document created in docs/models/
- [ ] All sections filled with specific values
- [ ] Reference images/links included
- [ ] Artist checklist included
- [ ] File naming conventions documented
