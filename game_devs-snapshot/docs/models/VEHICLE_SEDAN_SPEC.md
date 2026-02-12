# Vehicle Model Specification: 1960s Sedan

## Document Control
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-18 | AI Agent | Initial specification |

---

## 1. Overview

### Vehicle Type
**Civilian Sedan** — 1955-1965 American full-size automobile

### Role in Gameplay
- Most common vehicle prop in all levels
- Provides player cover in combat
- Environmental storytelling (abandoned, crashed)
- Lootable (trunk, glove box)
- Navigation landmarks

### Visual Identity
- **Era**: Late 1950s to early 1960s American automotive design
- **Style**: Chrome-heavy, tail fins, rounded body
- **Condition**: Post-apocalyptic decay and damage

### Priority
**P1 - Critical** (Required for Vertical Slice)

---

## 2. Technical Specifications

| Property | Requirement |
|----------|-------------|
| Polygon Budget | 3,000 - 5,000 triangles (per damage state) |
| Texture Resolution | 1024x1024 |
| UV Channels | 1 |
| LOD Levels | 3 (LOD0: 100%, LOD1: 50%, LOD2: 25%) |
| Collision Mesh | Simplified convex shapes |
| Driveable | No (prop only) |

### Geometry Rules
- Clean quad topology
- Separate meshes for: body, windows, wheels, interior
- Destructible elements as separate objects
- Chrome trim as geometry (not just texture)

### Dimensions (Based on 1959 Chevrolet Impala)
| Property | Value |
|----------|-------|
| Length | 5.4 meters |
| Width | 2.0 meters |
| Height | 1.4 meters |
| Wheelbase | 3.0 meters |
| Ground Clearance | 0.2 meters |

### Origin & Orientation
- **Origin**: Base center (between wheels, ground level)
- **Forward**: -Z axis
- **Up**: +Y axis

---

## 3. Visual Design

### Era-Accurate Features (1955-1965)
```
Body Style:
├── Rounded body panels (not angular)
├── Chrome bumpers (front and rear, substantial)
├── Chrome grille (horizontal bars or mesh)
├── Tail fins (subtle to dramatic)
├── Wrap-around windshield
├── Whitewall tires (optional)
└── Two-tone paint (optional)

Details:
├── Round or horizontal headlights
├── Chrome trim along sides
├── Hood ornament
├── Trunk-mounted spare tire (hidden)
├── Antenna on rear fender
└── Side mirrors (small, chrome)
```

### Reference Vehicles
| Make/Model | Years | Key Features |
|------------|-------|--------------|
| Chevrolet Bel Air | 1955-57 | Iconic 50s style, chrome |
| Chevrolet Impala | 1958-64 | Tail fins, wide body |
| Ford Fairlane | 1955-61 | Clean lines, chrome |
| Plymouth Fury | 1956-61 | Forward look, fins |
| Dodge Coronet | 1955-59 | Bold grille, fins |

### Color Palette
| Color | Hex | Era Name |
|-------|-----|----------|
| Two-tone Turquoise/White | #40E0D0 / #FFFFFF | Common 50s combo |
| Black | #1C1C1C | Classic |
| Coral Pink | #F88379 | 1950s popular |
| Seafoam Green | #93E9BE | 1960s |
| Cream/Beige | #F5F5DC | Conservative |
| Red/White | #DC143C / #FFFFFF | Sporty two-tone |

---

## 4. Damage States

### State 1: Abandoned (Light Damage)
```
Condition: Recently abandoned, minimal damage
Visuals:
├── Flat tires (1-2)
├── Dust/dirt accumulation
├── Faded paint
├── Minor rust spots
├── Windows intact or 1-2 cracked
├── All body panels present
└── Chrome tarnished but visible

Polygon Budget: 4,000-5,000 tris
Use: Less-destroyed areas, recent abandonment
```

### State 2: Damaged (Medium Damage)
```
Condition: Years of neglect, some destruction
Visuals:
├── All tires flat
├── Heavy dust and debris
├── Significant rust
├── Several broken windows
├── Dents and scratches
├── Chrome partially missing
├── Doors may be ajar
└── Interior visible, weathered

Polygon Budget: 4,000-5,000 tris
Use: Common street prop, cover positions
```

### State 3: Destroyed (Heavy Damage)
```
Condition: Major damage, likely from impact/conflict
Visuals:
├── All windows broken
├── Tires missing or shredded
├── Heavy body damage (crushed panels)
├── Doors missing or hanging open
├── Hood/trunk open or missing
├── Exposed engine bay
├── Interior gutted
├── Heavy rust and decay
└── Debris inside and around

Polygon Budget: 3,500-4,500 tris
Use: Combat areas, roadblocks
```

### State 4: Burned (Fire Damage)
```
Condition: Destroyed by fire
Visuals:
├── Charred paint (black, gray)
├── Melted components (lights, trim)
├── No glass remaining
├── Skeletal frame visible
├── Tires melted or missing
├── Interior completely destroyed
├── Warped body panels
└── Rust and corrosion throughout

Polygon Budget: 3,000-4,000 tris
Use: Violent conflict areas, checkpoints
```

---

## 5. Component Breakdown

### Separate Meshes
```
Sedan
├── Body_Exterior
│   ├── Body_Main (unified body shell)
│   ├── Bumper_Front (chrome)
│   ├── Bumper_Rear (chrome)
│   ├── Grille (chrome)
│   ├── Trim_Chrome (side strips)
│   └── Hood_Ornament (chrome)
├── Doors (4x, for open variants)
│   ├── Door_FL, Door_FR
│   └── Door_RL, Door_RR
├── Hood (for open variant)
├── Trunk (for open/loot variant)
├── Glass
│   ├── Windshield
│   ├── Rear_Window
│   └── Side_Windows (4x)
├── Wheels (4x)
│   ├── Wheel_FL, Wheel_FR
│   └── Wheel_RL, Wheel_RR
├── Interior
│   ├── Seats_Front
│   ├── Seats_Rear
│   ├── Dashboard
│   └── Steering_Wheel
└── Collision
    ├── Collision_Body (convex hull)
    └── Collision_Wheels (cylinders)
```

### LOD Strategy
| LOD | Distance | Triangles | Details |
|-----|----------|-----------|---------|
| LOD0 | 0-15m | 4,000-5,000 | Full detail, all chrome |
| LOD1 | 15-40m | 2,000-2,500 | Merged chrome, simple interior |
| LOD2 | 40m+ | 800-1,200 | Billboard or simplified shell |

---

## 6. Material Requirements

### PBR Workflow
**Metallic/Roughness** workflow

### Texture Maps
| Map | Resolution | Format | Notes |
|-----|------------|--------|-------|
| Albedo | 1024x1024 | PNG | Paint colors, rust, dirt |
| Normal | 1024x1024 | PNG | Panel lines, dents, damage |
| ORM | 1024x1024 | PNG | Rust=rough, chrome=metallic |

### Material Zones
| Material | Roughness | Metallic | Notes |
|----------|-----------|----------|-------|
| Paint (clean) | 0.2 - 0.4 | 0.0 | Glossy automotive |
| Paint (weathered) | 0.5 - 0.7 | 0.0 | Faded, oxidized |
| Paint (burned) | 0.9 - 1.0 | 0.0 | Charred, matte |
| Chrome (clean) | 0.1 - 0.2 | 1.0 | Mirror finish |
| Chrome (tarnished) | 0.3 - 0.5 | 0.8 | Oxidized |
| Rust | 0.8 - 1.0 | 0.3 | Corroded metal |
| Glass (intact) | 0.0 - 0.1 | 0.0 | Transparent |
| Glass (dirty) | 0.2 - 0.4 | 0.0 | Dusty, opaque |
| Rubber (tire) | 0.8 - 1.0 | 0.0 | Black, worn |
| Interior fabric | 0.7 - 0.9 | 0.0 | Weathered upholstery |
| Interior leather | 0.5 - 0.7 | 0.0 | Cracked, faded |

### Color Variants (Material Swaps)
| Variant | Primary Color | Secondary Color |
|---------|---------------|-----------------|
| TwoTone_Turquoise | #40E0D0 | #FFFFFF |
| TwoTone_Red | #DC143C | #FFFFFF |
| Solid_Black | #1C1C1C | - |
| Solid_Cream | #F5F5DC | - |
| TwoTone_Green | #93E9BE | #1C1C1C |

---

## 7. Gameplay Integration

### Cover System
```
Cover Points:
├── Hood (crouch cover, 1.0m height)
├── Trunk (crouch cover, 0.9m height)
├── Doors (standing cover when open, 1.2m height)
├── Engine block (best ballistic protection)
└── Wheels (low cover, 0.4m height)

Cover Quality:
- Engine block: High protection (stops most rounds)
- Doors: Low protection (pistol only)
- Body panels: Very low (cosmetic only)
```

### Loot Points
```
Lootable Areas:
├── Glove Box (small items: ammo, meds)
├── Trunk (larger items: weapons, supplies)
├── Under Seat (hidden items)
└── Fuel Tank (fuel, if implemented)

Interaction:
- E to open trunk/glove box
- Visual change when looted (door stays open)
```

### Navigation
- Cannot be moved by player
- Blocks direct paths (forces tactical movement)
- Can be used for elevated positions (climb on hood)

---

## 8. Placement Guidelines

### Street Placement
```
Spacing: 
- Urban streets: Every 15-25 meters
- Highway: Clusters of 3-5 with gaps

Orientation:
- Parked: Parallel to curb, slight angle variation
- Crashed: Angled, sometimes on sidewalk
- Roadblock: Perpendicular, multiple vehicles

Variation:
- Mix damage states
- Alternate colors
- Vary door/hood open states
```

### Combat Areas
```
Placement for Gameplay:
- Pairs for flanking cover
- Lines for advancing cover
- Clusters for holdout points
- Strategic gaps for movement
```

### Environmental Storytelling
```
Scenarios:
- Traffic jam (multiple cars, same direction)
- Evacuation (doors open, belongings visible)
- Firefight (bullet holes, burned vehicles)
- Checkpoint (military vehicles nearby)
- Accident (impact damage, debris field)
```

---

## 9. 1960s Era Accuracy

### Appropriate Features
- [ ] Chrome bumpers (substantial, not thin)
- [ ] Round or horizontal headlights
- [ ] Tail fins (era-appropriate size)
- [ ] Whitewall tires or hubcaps
- [ ] Hood ornaments
- [ ] Side mirror design (small, chrome)
- [ ] Antenna placement (rear fender)
- [ ] Bench seats (front and rear)
- [ ] Column shifter (steering column gear shift)
- [ ] Analog gauges on dashboard

### What to Avoid
- ❌ Modern aerodynamic shapes
- ❌ Plastic bumpers or body panels
- ❌ Wedge-shaped bodies
- ❌ Pop-up headlights
- ❌ Bucket seats with center console
- ❌ Digital displays
- ❌ Modern wheel designs
- ❌ Disc brakes visible (use hub caps)
- ❌ Modern rear spoilers

---

## 10. Export Requirements

### Format
- **Primary**: GLTF 2.0 Separate
- **Fallback**: FBX 2014

### File Naming
```
Vehicles (per damage state):
prop_vehicle_sedan_abandoned_lod0.gltf
prop_vehicle_sedan_damaged_lod0.gltf
prop_vehicle_sedan_destroyed_lod0.gltf
prop_vehicle_sedan_burned_lod0.gltf

LOD variants:
prop_vehicle_sedan_damaged_lod1.gltf
prop_vehicle_sedan_damaged_lod2.gltf

Color variants (if separate):
prop_vehicle_sedan_damaged_turquoise.gltf
prop_vehicle_sedan_damaged_black.gltf
```

### Godot Import Settings
```
Root Type: Node3D
Root Scale: 1.0
Collision: Generate (Trimesh for complex, Convex for simple)
Static Body: Yes (not physics simulated)
```

### Scene Structure in Godot
```
Sedan_Damaged (StaticBody3D)
├── MeshInstance3D (body)
├── MeshInstance3D (glass - if intact)
├── CollisionShape3D (body collision)
├── InteractionArea (Area3D for loot)
│   ├── Trunk_Loot (Marker3D)
│   └── GloveBox_Loot (Marker3D)
└── CoverPoints (Node3D)
    ├── Cover_Hood (Marker3D)
    └── Cover_Trunk (Marker3D)
```

---

## 11. Variants

### Damage State Variants (Required)
| Variant | Priority | Use Case |
|---------|----------|----------|
| Abandoned | P1 | Light damage areas |
| Damaged | P1 | Most common |
| Destroyed | P1 | Combat areas |
| Burned | P2 | Violence indicators |

### Color Variants (Required)
| Color | Priority |
|-------|----------|
| Two-tone Turquoise/White | P1 |
| Solid Black | P1 |
| Solid Cream | P1 |
| Two-tone Red/White | P2 |
| Seafoam Green | P2 |

### Door/Hood States
| State | Notes |
|-------|-------|
| All closed | Default |
| Driver door open | Abandoned look |
| All doors open | Evacuation |
| Hood open | Engine access |
| Trunk open | Already looted |

---

## 12. Artist Checklist

### Before Starting
- [ ] Study 1955-1965 American car design
- [ ] Gather reference images (Bel Air, Impala, Fairlane)
- [ ] Understand chrome trim patterns
- [ ] Review damage state requirements

### During Modeling
- [ ] Verify dimensions match spec
- [ ] Keep chrome as separate geometry
- [ ] Model destructible elements separately
- [ ] Check silhouette recognition

### Before Texturing
- [ ] UV layout optimized
- [ ] Separate UV islands for color swap areas
- [ ] Rust and damage in vertex colors or masks

### Before Export
- [ ] All damage states complete
- [ ] LODs created and tested
- [ ] Collision meshes simplified
- [ ] Named correctly per convention

### After Export
- [ ] Test in Godot with cover system
- [ ] Verify loot interaction points
- [ ] Check all damage states
- [ ] Test LOD transitions

---

## 13. Reference Images

### Vehicle Design Reference
- **1959 Chevrolet Impala**: Quintessential late-50s design
- **1957 Chevrolet Bel Air**: Iconic chrome and fins
- **1960 Ford Galaxie**: Clean early-60s lines
- **1959 Plymouth Fury**: Dramatic fins

### Decay Reference
- Barn find restoration photos
- Abandoned vehicle photography
- Junkyard reference
- Post-disaster vehicle images

### Color Reference
- 1950s-60s automotive advertisements
- Period car dealership photos
- Two-tone paint combinations of era

---

## 14. Delivery

### Deliverables
1. Four damage state models (Abandoned, Damaged, Destroyed, Burned)
2. Three LOD levels per state
3. Five color variants (material swaps)
4. Collision meshes
5. Texture maps (Albedo, Normal, ORM)

### File Structure
```
delivery/
├── models/
│   ├── prop_vehicle_sedan_abandoned_lod0.gltf
│   ├── prop_vehicle_sedan_abandoned_lod1.gltf
│   ├── prop_vehicle_sedan_abandoned_lod2.gltf
│   ├── prop_vehicle_sedan_damaged_lod0.gltf
│   ├── prop_vehicle_sedan_damaged_lod1.gltf
│   ├── prop_vehicle_sedan_damaged_lod2.gltf
│   ├── prop_vehicle_sedan_destroyed_lod0.gltf
│   ├── prop_vehicle_sedan_destroyed_lod1.gltf
│   ├── prop_vehicle_sedan_destroyed_lod2.gltf
│   ├── prop_vehicle_sedan_burned_lod0.gltf
│   └── prop_vehicle_sedan_burned_lod1.gltf
├── textures/
│   ├── vehicle_sedan_albedo_turquoise.png
│   ├── vehicle_sedan_albedo_black.png
│   ├── vehicle_sedan_albedo_cream.png
│   ├── vehicle_sedan_normal.png
│   └── vehicle_sedan_orm.png
└── collision/
    └── vehicle_sedan_collision.gltf
```

---

## Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Art Director | | | |
| Technical Artist | | | |
| Project Lead | | | |
