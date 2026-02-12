# Enemy Model Specification: Scavenger

## Document Control
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-18 | AI Agent | Initial specification |

---

## 1. Overview

### Enemy Type
**Scavenger** — The weakest and most common enemy type

### Role in Gameplay
- First enemy type encountered (Level 1)
- Low threat, teaches basic combat mechanics
- Flees when health drops below 20%
- Prefers looting over fighting
- Often found alone or in pairs

### Visual Identity
- **Archetype**: Desperate survivor, not a fighter
- **Posture**: Hunched, wary, nervous
- **Silhouette**: Carrying bags/pouches, thin build
- **Mood**: Frightened, opportunistic

### Priority
**P1 - Critical** (Required for Vertical Slice)

---

## 2. Technical Specifications

| Property | Requirement |
|----------|-------------|
| Polygon Budget | 8,000 - 10,000 triangles |
| Texture Resolution | 1024x1024 |
| UV Channels | 1 |
| LOD Levels | 2 (LOD0: 100%, LOD1: 50%) |
| Rigged | Yes |
| Animated | Yes (shared player anims + unique) |

### Geometry Rules
- Simplified topology compared to player
- Edge loops at major joints only
- No finger bones required (mitten hands acceptable)
- Silhouette-focused detail

### Dimensions
| Property | Value |
|----------|-------|
| Height | 1.65 - 1.75m (varies) |
| Build | Thin, malnourished |
| Posture | Slightly hunched |

### Origin & Orientation
- **Origin**: Base center (between feet)
- **Forward**: -Z axis
- **Up**: +Y axis
- **Rest Pose**: T-pose or A-pose

---

## 3. Visual Design

### Silhouette Requirements
```
Key Recognition Features:
├── Hunched posture (not upright like Veteran)
├── Bags/pouches hanging from body
├── No visible armor
├── Thin limbs
└── Often carrying loot bag

Readable at: 30+ meters
Distinguishing from Player: Different posture, ragged clothing
Distinguishing from Raider: No bulk, no armor, no spikes
```

### Color Palette
| Element | Color | Hex | Notes |
|---------|-------|-----|-------|
| Primary clothing | Tan/Brown | #C4A77D | Dusty, faded |
| Secondary | Dirty Gray | #8B8682 | Patches |
| Accent | Rust Orange | #B7410E | Stains, patches |
| Skin | Weathered | #D2A679 | Dirty, sun-damaged |

### Threat Recognition
- **Color coding**: Neutral browns/tans (not aggressive reds/blacks)
- **No intimidating features**: No spikes, armor, or trophies
- **Body language**: Nervous, ready to flee

---

## 4. Clothing & Equipment

### Head
```
Hair: Unkempt, dirty, possibly matted
Options:
- Balding/thinning hair
- Messy medium-length
- Covered with cloth wrap
No hats/helmets (distinguish from other types)
```

### Upper Body
```
Layer 1 - Undershirt:
- Torn, stained t-shirt or tank top
- Holes visible
- Originally white/gray, now brown-stained

Layer 2 - Outer:
- Oversized coat or jacket (scavenged)
- Too big for frame (emphasizes thin build)
- Pockets bulging with scavenged items
- Patched with mismatched fabric
- Missing buttons, held closed with rope/wire
```

### Lower Body
```
Pants:
- Ill-fitting work pants or slacks
- Frayed at cuffs
- Held up with rope belt
- Knee patches
- Stained and worn

Feet:
- Worn sneakers OR
- Cloth wrappings OR
- Mismatched shoes
- No proper boots (scavengers get leftovers)
```

### Accessories
```
Required:
- Shoulder bag or satchel (for loot)
- Multiple pouches/pockets
- Visible scavenged items (cans, bottles, cloth)

Optional:
- Cloth face covering (bandana around neck)
- Makeshift gloves (cloth wraps)
- Canteen or water container
```

### Weathering Level
- **Heavy weathering**: Dirt, sweat stains, tears
- **Patchwork repairs**: Mismatched fabric patches
- **Fading**: Sun-bleached in spots
- **No blood/gore**: They avoid fights

---

## 5. Skeleton Requirements

### Bone Count
| Category | Count |
|----------|-------|
| Spine Chain | 5 (Hips through Head) |
| Arms (per side) | 3 (Shoulder, Arm, ForeArm, Hand) |
| Fingers | 0 (mitten hands) OR 5 per hand (simplified) |
| Legs (per side) | 4 (UpLeg, Leg, Foot, ToeBase) |
| **Total** | **50-55 bones** |

### Skeleton Compatibility
- Compatible with player skeleton for animation sharing
- Can use player locomotion animations
- Unique animations for scavenger-specific behaviors

### IK Requirements
- Hand IK for weapon holding
- Foot IK for terrain adaptation
- No finger IK needed

---

## 6. Material Requirements

### PBR Workflow
**Metallic/Roughness** workflow

### Texture Maps
| Map | Resolution | Format | Notes |
|-----|------------|--------|-------|
| Albedo | 1024x1024 | PNG | Heavy dirt/staining |
| Normal | 1024x1024 | PNG | Fabric wrinkles, patches |
| ORM | 1024x1024 | PNG | High roughness overall |

### Material Zones
| Material | Roughness | Metallic | Notes |
|----------|-----------|----------|-------|
| Fabric (cotton) | 0.8 - 1.0 | 0.0 | Very rough, worn |
| Skin | 0.5 - 0.7 | 0.0 | Dirty, weathered |
| Leather (bag) | 0.6 - 0.8 | 0.0 | Old, cracked |
| Metal (buckles) | 0.4 - 0.6 | 0.8 | Tarnished, rusty |

---

## 7. Animation Requirements

### Shared with Player (Reuse)
| Animation | Notes |
|-----------|-------|
| walk_forward | Slightly hunched variant |
| run_forward | Panicked variation |
| idle | More nervous shifting |

### Scavenger-Specific
| Animation | Frames | FPS | Loop | Priority | Notes |
|-----------|--------|-----|------|----------|-------|
| idle_nervous | 90 | 30 | Yes | P1 | Looking around, fidgeting |
| walk_cautious | 36 | 30 | Yes | P1 | Slow, careful steps |
| run_flee | 20 | 30 | Yes | P1 | Panicked sprint |
| loot_ground | 60 | 30 | No | P1 | Bending to pick up items |
| attack_melee | 24 | 30 | No | P1 | Weak swing with improvised weapon |
| attack_pistol | 12 | 30 | No | P2 | Shaky aim, poor stance |
| hit_react | 15 | 30 | No | P1 | Exaggerated flinch |
| death_front | 45 | 30 | No | P1 | Collapse forward |
| death_back | 45 | 30 | No | P1 | Fall backward |
| surrender | 60 | 30 | No | P2 | Hands up, cowering |
| spotted_player | 20 | 30 | No | P1 | Startle reaction |

### Animation Notes
- All movements slightly more nervous/twitchy than player
- Less confident weapon handling
- Quick, jerky head movements (always looking around)
- Hunched posture maintained in all animations

---

## 8. Variants

### Required Variants (Phase 2)
| Variant | Differences |
|---------|-------------|
| Scavenger_Male_A | Default, tan coat |
| Scavenger_Male_B | Gray coat, different bag |
| Scavenger_Female_A | Smaller build, headscarf |

### Weapon Loadouts
| Loadout | Probability | Weapon |
|---------|-------------|--------|
| Unarmed | 30% | Fists only (flees) |
| Melee | 50% | Pipe, stick, or improvised |
| Pistol | 20% | Cheap revolver (rare) |

### Color Variants
Support via material tinting:
- Coat: Tan, Gray, Brown, Olive
- Undershirt: White (dirty), Gray, Brown

---

## 9. Behavioral Visual Cues

### Idle State
- Constantly looking around
- Shifting weight nervously
- Clutching bag protectively

### Alert State
- Freezing momentarily
- Wide eyes (if visible)
- Ready to run posture

### Combat State
- Poor fighting stance
- Weapon held uncertainly
- Backing away while attacking

### Fleeing State
- Full sprint, panicked
- Looking over shoulder
- Dropping items (optional)

---

## 10. 1960s Era Accuracy

### Appropriate Elements
- [ ] Work pants style (high waist, straight leg)
- [ ] Cotton/wool fabrics (no synthetics)
- [ ] Canvas bags (no nylon)
- [ ] Leather or canvas shoes
- [ ] Natural fiber rope (not nylon)

### Post-Apocalyptic Modifications
- [ ] Patchwork repairs
- [ ] Makeshift pouches from repurposed items
- [ ] Cloth wrappings as improvised gear
- [ ] Scavenged mixed-era clothing

### What to Avoid
- ❌ Modern backpacks (nylon, plastic clips)
- ❌ Synthetic fabrics (fleece, polyester look)
- ❌ Modern sneaker designs
- ❌ Tactical/military gear (that's for Veterans)
- ❌ Sports padding or armor (that's for Raiders)

---

## 11. Export Requirements

### Format
- **Primary**: GLTF 2.0 Separate
- **Fallback**: FBX 2014

### File Naming
```
Characters:
char_enemy_scavenger_male_a_lod0.gltf
char_enemy_scavenger_male_b_lod0.gltf
char_enemy_scavenger_female_a_lod0.gltf

Animations (if separate):
anim_scavenger_idle_nervous.gltf
anim_scavenger_run_flee.gltf
anim_scavenger_loot_ground.gltf
```

### Godot Import Settings
```
Root Type: Node3D
Root Scale: 1.0
Skeleton: Create (share with player if possible)
Animation:
  ✓ Import
  FPS: 30
```

---

## 12. Gameplay Integration

### AI Behavior Reference
From `docs/SPEC.md` Section 6:
- Health: 75 HP
- Damage: 15
- Behavior: Flees when hurt, prefers looting
- States: IDLE, PATROL, INVESTIGATE, FLEE, DEAD

### Detection by Player
- Readable silhouette at 30m minimum
- Distinct from player (posture, clothing)
- Distinct from other enemy types

### Audio Cues
- Nervous muttering
- Startled yelps when spotted
- Footsteps (lighter than armored enemies)

---

## 13. Artist Checklist

### Before Starting
- [ ] Read full specification
- [ ] Review player model for skeleton compatibility
- [ ] Gather homeless/scavenger reference images
- [ ] Study 1960s working class clothing

### During Modeling
- [ ] Check hunched posture reads correctly
- [ ] Verify silhouette differs from player
- [ ] Include bag/pouch for recognition
- [ ] Keep within poly budget

### Before Export
- [ ] Test with player animations
- [ ] Verify scavenger-specific animations
- [ ] Check all material zones
- [ ] Create LOD1

### After Export
- [ ] Test in Godot with AI system
- [ ] Verify readability at distance
- [ ] Check in game lighting conditions

---

## 14. Reference Images

### Character Archetype
- Depression-era photographs (homeless, poor)
- Post-war refugee images
- Disaster survivor photography

### Clothing Reference
- 1940s-60s work wear
- Military surplus (worn, faded)
- Patched and repaired clothing

### Posture Reference
- Hunched, defensive body language
- Nervous, wary stance
- Ready-to-flee positioning

---

## 15. Delivery

### Deliverables
1. Scavenger Male A (rigged mesh)
2. Scavenger Male B (variant)
3. Scavenger Female A (variant)
4. Scavenger-specific animations
5. Texture maps (Albedo, Normal, ORM)
6. LOD meshes (LOD0, LOD1)

### File Structure
```
delivery/
├── characters/
│   ├── char_enemy_scavenger_male_a_lod0.gltf
│   ├── char_enemy_scavenger_male_a_lod1.gltf
│   ├── char_enemy_scavenger_male_b_lod0.gltf
│   └── char_enemy_scavenger_female_a_lod0.gltf
├── animations/
│   ├── anim_scavenger_idle_nervous.gltf
│   ├── anim_scavenger_run_flee.gltf
│   └── ...
└── textures/
    ├── char_scavenger_male_a_albedo.png
    ├── char_scavenger_male_a_normal.png
    └── char_scavenger_male_a_orm.png
```

---

## Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Art Director | | | |
| Technical Artist | | | |
| Project Lead | | | |
