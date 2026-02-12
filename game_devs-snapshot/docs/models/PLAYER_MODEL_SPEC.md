# Player Character Model Specification

## Document Control
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-18 | AI Agent | Initial specification |

---

## 1. Overview

### Purpose
The player character is the main playable character in Urban Survivor, visible at all times in third-person view. This model must support:
- 8-directional movement animation
- Combat animations (aiming, firing, reloading)
- Modular clothing customization
- 1960s post-apocalyptic American aesthetic

### Visual Identity
- **Era**: 1960s American everyman/everywoman
- **Archetype**: Resourceful survivor, not military super-soldier
- **Age**: 28-40 years old (weathered but capable)
- **Build**: Athletic, practical physique

### Priority
**P1 - Critical** (Required for Vertical Slice)

---

## 2. Technical Specifications

| Property | Requirement |
|----------|-------------|
| Polygon Budget | 15,000 - 20,000 triangles (dressed) |
| Base Body | 8,000 - 10,000 triangles |
| Clothing (total) | 5,000 - 10,000 triangles |
| Texture Resolution | 2048x2048 (body), 1024x1024 (per clothing piece) |
| UV Channels | 1 (lightmap baking not required) |
| LOD Levels | 3 (LOD0: 100%, LOD1: 50%, LOD2: 25%) |
| Rigged | Yes |
| Animated | Yes (full animation set) |

### Geometry Rules
- Clean quad-based topology for deformation
- Edge loops at joints (elbows, knees, shoulders, fingers)
- No n-gons (5+ sided polygons)
- Manifold geometry (watertight mesh)
- Consistent normals (outward facing)

### Dimensions
| Variant | Height | Shoulder Width | Hip Width |
|---------|--------|----------------|-----------|
| Male | 1.75m | 0.45m | 0.35m |
| Female | 1.65m | 0.40m | 0.38m |

### Origin & Orientation
- **Origin**: Base center (between feet)
- **Forward**: -Z axis
- **Up**: +Y axis
- **Rest Pose**: T-pose or A-pose

---

## 3. Body Specifications

### Male Body
```
Height: 1.75 meters
Build: Athletic, lean muscle
Shoulders: Broad but not exaggerated
Proportions: Realistic human (not stylized)
Age indicators: Slight weathering, minor scars

Polygon Distribution:
- Head/Face: 3,000 tris
- Torso: 2,500 tris
- Arms: 1,500 tris (750 each)
- Hands: 1,500 tris (750 each, detailed fingers)
- Legs: 1,500 tris
```

### Female Body
```
Height: 1.65 meters
Build: Athletic, practical
Proportions: Realistic human
Age indicators: Slight weathering

Polygon Distribution:
- Head/Face: 3,000 tris
- Torso: 2,500 tris
- Arms: 1,500 tris
- Hands: 1,500 tris
- Legs: 1,500 tris
```

### Face Requirements
- Neutral expression base
- Blend shapes for basic expressions (optional for v1):
  - Blink
  - Brow furrow
  - Mouth open
- Eye bones for look-at targeting
- Jaw bone for future dialogue (optional)

---

## 4. Default Outfit (1960s Survivor)

### Head_Hair
```
Style: Short, practical cut
Male: Side-parted, slightly greased OR short crew cut
Female: Short bob OR practical ponytail
Polygon Budget: 1,000-1,500 tris
Notes: 
- Hair cards with alpha transparency
- Must fit under hats
```

### Torso_Under (T-Shirt)
```
Description: Dirty white t-shirt
Details:
- Crew neck
- Visible wear and minor tears
- Sweat stains under arms
- Wrinkles at waist
Polygon Budget: 500-800 tris
Color: Off-white #F5F5DC with dirt stains
```

### Torso_Over (Bomber Jacket)
```
Description: 1950s-style leather bomber jacket
Details:
- Brown leather
- Ribbed collar, cuffs, and hem
- Front zipper
- Two front pockets
- Worn and scuffed leather
- Minor repairs/patches visible
Polygon Budget: 3,000-4,000 tris
Color: Saddle Brown #8B4513
Reference: A-2 or G-1 flight jacket style
```

### Legs (Slacks)
```
Description: 1960s high-waisted slacks
Details:
- High waist (above navel)
- Straight leg cut (not skinny)
- Belt loops, simple belt
- Knee wear
- Dirt stains at cuffs
Polygon Budget: 2,000-3,000 tris
Color: Dark Gray #4A4A4A
```

### Feet (Work Boots)
```
Description: Brown leather work boots
Details:
- Ankle height
- Round toe
- Practical lacing (6-8 eyelets)
- Scuffed and worn
- Rubber sole visible
Polygon Budget: 1,000-1,500 tris
Color: Dark Brown #654321
Reference: Red Wing / Chippewa work boot style
```

---

## 5. Modular Clothing System

### Slot Architecture
```
Character
├── Body (always visible base)
├── Head_Hair (hair mesh)
├── Head_Hat (optional: fedora, cap, helmet)
├── Face_Accessory (optional: glasses, bandana, mask)
├── Torso_Under (t-shirt, undershirt)
├── Torso_Over (jacket, vest, coat - can be hidden)
├── Hands (gloves or bare)
├── Legs (pants)
├── Feet (shoes, boots)
└── Back_Accessory (backpack, nothing)
```

### Slot Requirements
| Slot | Always Visible | Weighted to Skeleton | Swappable |
|------|----------------|---------------------|-----------|
| Body | Yes (under clothes) | Yes | No |
| Head_Hair | Yes (unless hat) | Yes | Yes |
| Head_Hat | No | Yes | Yes |
| Face_Accessory | No | Yes | Yes |
| Torso_Under | Yes | Yes | Yes |
| Torso_Over | No | Yes | Yes |
| Hands | Yes | Yes | Yes |
| Legs | Yes | Yes | Yes |
| Feet | Yes | Yes | Yes |
| Back_Accessory | No | Yes | Yes |

### Clothing Layer Rules
- Each clothing piece is a separate mesh
- All pieces weighted to the same skeleton
- Pieces can be shown/hidden via script
- Color variants via material parameter, not separate meshes
- Clothing should not intersect when layered

---

## 6. Skeleton Requirements

### Bone Hierarchy
```
Root
└── Hips
    ├── Spine
    │   └── Spine1
    │       └── Spine2
    │           ├── Neck
    │           │   └── Head
    │           │       ├── Jaw (optional)
    │           │       ├── LeftEye
    │           │       └── RightEye
    │           ├── LeftShoulder
    │           │   └── LeftArm
    │           │       └── LeftForeArm
    │           │           └── LeftHand
    │           │               ├── LeftHandThumb1-3
    │           │               ├── LeftHandIndex1-3
    │           │               ├── LeftHandMiddle1-3
    │           │               ├── LeftHandRing1-3
    │           │               └── LeftHandPinky1-3
    │           └── RightShoulder
    │               └── [Mirror of Left]
    ├── LeftUpLeg
    │   └── LeftLeg
    │       └── LeftFoot
    │           └── LeftToeBase
    └── RightUpLeg
        └── [Mirror of Left]
```

### Bone Count
| Category | Count |
|----------|-------|
| Spine Chain | 6 (Hips through Head) |
| Arms (per side) | 4 (Shoulder, Arm, ForeArm, Hand) |
| Fingers (per hand) | 15 (5 fingers × 3 bones) |
| Legs (per side) | 4 (UpLeg, Leg, Foot, ToeBase) |
| Eyes | 2 |
| Jaw | 1 (optional) |
| **Total** | **65-67 bones** |

### IK Requirements
```
IK Chains:
├── LeftArm_IK (LeftHand target, elbow pole)
├── RightArm_IK (RightHand target, elbow pole)
├── LeftLeg_IK (LeftFoot target, knee pole)
├── RightLeg_IK (RightFoot target, knee pole)
└── Head_LookAt (Head target)

Pole Vectors:
- Elbows: Point backward
- Knees: Point forward
```

### Godot Compatibility
- Use Godot's Humanoid bone naming convention
- Root bone at origin
- Skeleton3D compatible hierarchy
- All bones properly oriented (local Y down bone, Z forward)

---

## 7. Material Requirements

### PBR Workflow
**Metallic/Roughness** workflow (Godot 4 standard)

### Texture Maps Per Asset

| Map | Resolution | Format | Color Space | Notes |
|-----|------------|--------|-------------|-------|
| Albedo | 2048/1024 | PNG | sRGB | Base color, no lighting |
| Normal | 2048/1024 | PNG | Linear | OpenGL format (Y+ up) |
| ORM | 2048/1024 | PNG | Linear | R=AO, G=Roughness, B=Metallic |

### Material Zones

**Body:**
| Zone | Roughness | Metallic |
|------|-----------|----------|
| Skin | 0.4 - 0.6 | 0.0 |
| Hair | 0.6 - 0.8 | 0.0 |
| Nails | 0.3 - 0.4 | 0.0 |

**Clothing:**
| Material | Roughness | Metallic |
|----------|-----------|----------|
| Leather (jacket) | 0.4 - 0.6 | 0.0 |
| Cotton (t-shirt) | 0.7 - 0.9 | 0.0 |
| Denim/Wool (pants) | 0.7 - 0.9 | 0.0 |
| Rubber (boot sole) | 0.8 - 1.0 | 0.0 |
| Metal (buckles, zippers) | 0.2 - 0.4 | 1.0 |

### Weathering Guidelines
- Dirt accumulation at folds and seams
- Wear at high-contact areas (elbows, knees, cuffs)
- Faded color in sun-exposed areas
- Minor tears and repairs
- Sweat stains where appropriate

---

## 8. Animation Requirements

### Animation List

#### Locomotion (Priority 1)
| Animation | Frames | FPS | Loop | Notes |
|-----------|--------|-----|------|-------|
| idle | 60-90 | 30 | Yes | Subtle breathing, weight shifts |
| walk_forward | 30 | 30 | Yes | 5 m/s |
| walk_backward | 30 | 30 | Yes | 3 m/s |
| walk_left | 30 | 30 | Yes | Strafe |
| walk_right | 30 | 30 | Yes | Strafe |
| run_forward | 20-24 | 30 | Yes | 8 m/s |
| run_backward | 24 | 30 | Yes | 5 m/s |
| run_left | 24 | 30 | Yes | Strafe run |
| run_right | 24 | 30 | Yes | Strafe run |

#### Crouch (Priority 1)
| Animation | Frames | FPS | Loop | Notes |
|-----------|--------|-----|------|-------|
| crouch_idle | 60 | 30 | Yes | Lower stance |
| crouch_walk_forward | 40 | 30 | Yes | 2.5 m/s |
| crouch_walk_backward | 40 | 30 | Yes | |
| crouch_walk_left | 40 | 30 | Yes | |
| crouch_walk_right | 40 | 30 | Yes | |

#### Jump (Priority 1)
| Animation | Frames | FPS | Loop | Notes |
|-----------|--------|-----|------|-------|
| jump_start | 10 | 30 | No | Launch |
| jump_loop | 15-20 | 30 | Yes | Airborne |
| jump_land | 15 | 30 | No | Impact, recovery |

#### Combat (Priority 1)
| Animation | Frames | FPS | Loop | Notes |
|-----------|--------|-----|------|-------|
| aim_idle | 60 | 30 | Yes | Weapon raised |
| fire_pistol | 8 | 30 | No | Recoil |
| fire_rifle | 10 | 30 | No | Heavier recoil |
| fire_shotgun | 12 | 30 | No | Heavy recoil |
| reload_pistol | 45-60 | 30 | No | Mag swap |
| reload_rifle | 60-75 | 30 | No | Mag swap |
| reload_shotgun | 30 per shell | 30 | No | Shell by shell |
| melee_attack | 20 | 30 | No | Swing |

#### Actions (Priority 2)
| Animation | Frames | FPS | Loop | Notes |
|-----------|--------|-----|------|-------|
| interact | 30 | 30 | No | Reach out |
| pickup | 25 | 30 | No | Bend, grab |
| use_item | 40 | 30 | No | Consume/apply |
| hit_react_front | 15 | 30 | No | Flinch |
| hit_react_back | 15 | 30 | No | Stumble |
| death | 45-60 | 30 | No | Collapse |

### Animation Notes
- All locomotion animations must blend seamlessly
- Walk/run start/end in same pose for blending
- Upper body layer for aim/fire during movement
- No foot sliding (root motion or IK adjustment)
- Weapon hand positions consistent across animations

---

## 9. 1960s Era Reference Checklist

### Clothing Accuracy
- [ ] High-waisted pants (waist at navel, not hips)
- [ ] Bomber/leather jacket style (not modern slim-fit)
- [ ] Work boots (round toe, not modern tactical)
- [ ] No synthetic/technical fabric appearance
- [ ] Colors are muted, period-appropriate

### Hair Accuracy
- [ ] Short, practical cuts
- [ ] Slightly greased/pomade look acceptable
- [ ] No modern styled/gelled looks
- [ ] No undercuts or modern fades

### Accessories
- [ ] Analog wristwatch (if visible)
- [ ] Dog tags (optional, military background variant)
- [ ] Period-appropriate eyeglass frames (if any)
- [ ] No digital watches or modern jewelry

### What to Avoid
- ❌ Modern sneakers or athletic shoes
- ❌ Low-rise pants
- ❌ Synthetic/tech fabrics (Gore-tex look)
- ❌ Modern haircuts (undercuts, man-buns)
- ❌ Tattoos (rare in 1960s mainstream)
- ❌ Piercings (except simple earrings for women)

---

## 10. Export Requirements

### Format
- **Primary**: GLTF 2.0 Separate (.gltf + .bin + textures)
- **Fallback**: FBX 2014 (if GLTF issues)

### Export Settings (Blender)
```
Format: glTF Separate
Transform: +Y Up
Include:
  ✓ Custom Properties
  ✓ Cameras (if applicable)
Geometry:
  ✓ Apply Modifiers
  ✓ UVs
  ✓ Normals
  ✓ Tangents
  ✓ Vertex Colors (if used)
  ✓ Skinning
Animation:
  ✓ Animations
  ✓ Shape Keys
  ✓ Skinning
```

### File Naming Convention
```
Characters:
char_player_male_lod0.gltf
char_player_female_lod0.gltf
char_player_male_lod1.gltf

Clothing:
cloth_jacket_bomber_brown.gltf
cloth_pants_slacks_gray.gltf
cloth_boots_work_brown.gltf

Animations:
anim_player_idle.gltf
anim_player_walk_forward.gltf
anim_player_run_forward.gltf
anim_player_fire_pistol.gltf
```

### Godot Import Settings
```
Root Type: Node3D
Root Name: <Use filename>
Root Scale: 1.0
Skeleton: Create (or Reuse for shared anims)
Animation:
  ✓ Import
  FPS: 30
  Trimming: On
  Loop Mode: Detect (or per-animation)
```

---

## 11. Variants

### Required Variants (Phase 2)
| Variant | Gender | Notes |
|---------|--------|-------|
| Default Male | M | Bomber jacket, slacks |
| Default Female | F | Same outfit style |

### Future Variants (Phase 3+)
| Variant | Description |
|---------|-------------|
| Military | M-1951 jacket, cargo pants |
| Civilian Formal | Suit jacket, dress pants |
| Worker | Coveralls, work shirt |
| Scavenger | Ragged version, improvised repairs |

### Color Variants
Support via material parameters (not separate models):
- Jacket: Brown, Black, Olive
- Pants: Gray, Brown, Black
- Shirt: White, Gray, Blue

---

## 12. Artist Checklist

### Before Starting
- [ ] Read full specification
- [ ] Gather 1960s reference images
- [ ] Review existing character specs (if any)
- [ ] Confirm poly budget with team

### During Modeling
- [ ] Check scale (1 unit = 1 meter)
- [ ] Verify edge loops at joints
- [ ] Test deformation with quick rig
- [ ] Keep clothing as separate meshes

### Before Rigging
- [ ] Clean mesh (no doubles, proper normals)
- [ ] Apply transforms
- [ ] Set origin at base center
- [ ] Name meshes properly

### During Rigging
- [ ] Follow bone naming convention
- [ ] Test full range of motion
- [ ] Weight paint all clothing pieces
- [ ] Verify IK pole vectors

### Before Texturing
- [ ] UV layout optimized (>70% usage)
- [ ] Consistent texel density
- [ ] 2-4 pixel padding between islands

### During Texturing
- [ ] No baked lighting in albedo
- [ ] Normal map is OpenGL format
- [ ] Weathering matches spec
- [ ] Colors match palette

### Before Export
- [ ] All transforms applied
- [ ] Named correctly per convention
- [ ] LODs created (if required)
- [ ] Test animations play correctly

### After Export
- [ ] Test import in Godot 4.3
- [ ] Verify materials assign correctly
- [ ] Test all animations
- [ ] Check in all lighting conditions

---

## 13. Reference Images

### 1960s Fashion Reference
- **Men's Casual**: Mad Men (TV show) casual scenes
- **Military Surplus**: Korean War field jackets, A-2 bomber jackets
- **Work Wear**: Period factory workers, mechanics

### 1960s Hairstyles
- **Men**: Side parts, crew cuts, slight pomade
- **Women**: Short bobs, practical ponytails

### Suggested Reference Sources
- Getty Images: 1960s street photography
- LIFE Magazine archives
- Period film stills: Bullitt (1968), The French Connection (1971)
- Military: Korean War uniform photos

---

## 14. Delivery

### Deliverables
1. Male character body (rigged, base mesh)
2. Female character body (rigged, base mesh)
3. Default outfit pieces (5 clothing items)
4. Full animation set (or priority subset)
5. Texture maps (Albedo, Normal, ORM per asset)
6. LOD meshes (LOD0, LOD1, LOD2)

### File Structure
```
delivery/
├── characters/
│   ├── char_player_male_lod0.gltf
│   ├── char_player_male_lod1.gltf
│   ├── char_player_male_lod2.gltf
│   ├── char_player_female_lod0.gltf
│   └── ...
├── clothing/
│   ├── cloth_jacket_bomber_brown.gltf
│   ├── cloth_pants_slacks_gray.gltf
│   └── ...
├── animations/
│   ├── anim_player_idle.gltf
│   ├── anim_player_walk_forward.gltf
│   └── ...
└── textures/
    ├── char_player_male_albedo.png
    ├── char_player_male_normal.png
    ├── char_player_male_orm.png
    └── ...
```

---

## Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Art Director | | | |
| Technical Artist | | | |
| Project Lead | | | |
