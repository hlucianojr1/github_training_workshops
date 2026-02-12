---
agent: 'character-artist'
description: 'Define complete player character model specification for 1960s post-apocalyptic survivor aesthetic.'
---

Create player character model specification document.

## Load Context First
- docs/ART_GUIDELINES.md (technical specs, skeleton)
- docs/SPEC.md Section 8 (Character Design)
- docs/CODING_STANDARDS.md

## Requirements
- 1960s American everyman/everywoman aesthetic
- Modular clothing system for customization
- Animation-ready rig compatible with Godot 4
- Post-apocalyptic wear and weathering
- Readable silhouette in third-person view

## Deliverable: Player Model Spec Document

Create `docs/PLAYER_MODEL_SPEC.md` with:

### 1. Body Specifications
```
Base Mesh:
- Height: 1.75m (male), 1.65m (female)
- Build: Athletic survivor, not bodybuilder
- Age appearance: 28-40 (weathered)
- Polygon budget: 8,000-10,000 triangles

Proportions:
- Realistic human proportions
- Slightly broadened shoulders (heroic subtle)
- Practical, capable physique

UV Layout:
- Single 2048x2048 body texture
- Head/face priority for detail
- Separate UV island for hands
```

### 2. Default Outfit (1960s Survivor)
```
Head:
- Hair: Short practical cut (multiple styles)
- Face: Tired but determined expression
- Optional: 5 o'clock shadow (male), minimal makeup (female)

Torso_Under:
- Dirty white t-shirt
- Visible wear and minor tears
- Sweat stains under arms

Torso_Over:
- Brown leather bomber jacket (1950s military surplus style)
- Worn collar and cuffs
- Patches or minor repairs visible
- Polycount: 3,000-4,000 triangles

Legs:
- Dark gray high-waisted slacks
- 1960s cut (not modern slim fit)
- Knee wear and dirt stains
- Polycount: 2,000-3,000 triangles

Feet:
- Brown leather work boots
- Scuffed and worn
- Practical lacing
- Polycount: 1,000-1,500 triangles
```

### 3. Clothing Slot System
```
Slots (independent meshes):
├── Head_Hair
├── Head_Hat (optional: fedora, cap, helmet)
├── Face_Accessory (optional: glasses, bandana)
├── Torso_Under (always visible)
├── Torso_Over (can be hidden)
├── Hands (gloves or bare)
├── Legs (pants)
├── Feet (shoes/boots)
└── Back_Accessory (backpack)

Each slot:
- Separate mesh weighted to shared skeleton
- Can be shown/hidden via script
- Color/material variants supported
```

### 4. Skeleton Requirements
```
Standard humanoid rig:
- Total bones: 65-70
- Godot Humanoid compatible
- IK targets for hands/feet
- Proper pole vectors for elbows/knees

Required bones:
- Full spine chain (Hips → Head)
- Full arm chains with fingers (3 joints each)
- Full leg chains with toes
- Optional: Jaw, eye bones for expressions
```

### 5. Material Requirements
```
PBR Metallic/Roughness workflow:
- Albedo: Base colors, no baked lighting
- Normal: Fabric detail, wrinkles, seams
- ORM: Combined Occlusion/Roughness/Metallic
  - Cloth: Roughness 0.7-0.9
  - Leather: Roughness 0.4-0.6
  - Metal (buckles): Roughness 0.2-0.4, Metallic 1.0

Color palette (from ART_GUIDELINES):
- Jacket: #8B4513 (saddle brown)
- Shirt: #F5F5DC (dirty beige)
- Pants: #4A4A4A (dark gray)
- Boots: #654321 (dark brown)
- Skin: Realistic, weathered
```

### 6. Animation Requirements
```
Rest pose: T-pose or A-pose
Forward: -Z axis
Up: +Y axis

Required animations:
- idle (60 frames, loop)
- walk_forward/back/left/right (30 frames, loop)
- run_forward/back/left/right (24 frames, loop)
- crouch_idle, crouch_walk (loop)
- jump_start, jump_loop, jump_land
- aim_idle, fire, reload (per weapon type)
- melee_attack
- interact
- hit_react_front/back
- death
```

### 7. 1960s Reference Checklist
```
Clothing accuracy:
- [ ] High-waisted pants (not low-rise)
- [ ] Bomber/leather jacket style (not modern)
- [ ] Work boots (not sneakers)
- [ ] No synthetic fabrics look
- [ ] Period-appropriate colors (muted)

Hair accuracy:
- [ ] Short practical cuts
- [ ] No modern styled looks
- [ ] Greased or natural (not gel-styled)

Accessories:
- [ ] Analog wristwatch (if visible)
- [ ] Dog tags (optional, military background)
- [ ] Period-appropriate glasses frames
```

## Acceptance Criteria
- [ ] Spec document created at docs/PLAYER_MODEL_SPEC.md
- [ ] Technical requirements clearly defined
- [ ] 1960s aesthetic requirements documented
- [ ] Modular clothing system specified
- [ ] Animation requirements listed
- [ ] File naming conventions included
