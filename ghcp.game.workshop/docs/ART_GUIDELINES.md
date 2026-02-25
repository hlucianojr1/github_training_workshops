# Urban Survivor - Art & Asset Guidelines

## Overview
This document provides guidelines for graphic designers and artists creating assets for Urban Survivor. Following these guidelines ensures visual consistency and technical compatibility.

---

## 1. Art Direction

### 1.1 Visual Style
- **Era**: 1960s American aesthetic
- **Mood**: Grim, desperate, hopeful undertones
- **Color Palette**: Muted, desaturated, earth tones
- **Lighting**: Dramatic, high contrast, volumetric

### 1.2 Color Palette

#### Primary Colors
| Name | Hex | Use |
|------|-----|-----|
| Dust Brown | `#8B7355` | Environment, decay |
| Rust Orange | `#B7410E` | Accents, danger |
| Military Green | `#4B5320` | Player, friendly |
| Concrete Gray | `#808080` | Buildings, urban |
| Blood Red | `#8B0000` | Damage, enemies |

#### Environmental
| Name | Hex | Use |
|------|-----|-----|
| Sky Overcast | `#778899` | Skybox base |
| Rubble Tan | `#D2B48C` | Debris |
| Asphalt Black | `#2F4F4F` | Roads |
| Brick Red | `#CB4154` | Buildings |
| Window Blue | `#4169E1` | Reflections |

#### UI Colors
| Name | Hex | Use |
|------|-----|-----|
| Health Green | `#228B22` | Health bar |
| Stamina Yellow | `#DAA520` | Stamina bar |
| Danger Red | `#DC143C` | Low health, warnings |
| Ammo White | `#F5F5F5` | Text, counters |
| Background Dark | `#1C1C1C` | UI backgrounds |

### 1.3 Reference Material
- **Architecture**: 1960s New York, Philadelphia, Washington D.C.
- **Vehicles**: Pre-1965 American cars
- **Fashion**: 1960s civilian and military clothing
- **Technology**: Tube radios, rotary phones, analog equipment
- **Destruction**: Reference Hiroshima, London Blitz, Berlin 1945

---

## 2. 3D Models

### 2.1 Technical Requirements

| Asset Type | Triangle Budget | Texture Size |
|------------|----------------|--------------|
| Player Character | 15,000-20,000 | 2048x2048 |
| Enemy Characters | 8,000-12,000 | 1024x1024 |
| Weapons (1st person) | 3,000-5,000 | 1024x1024 |
| Weapons (3rd person) | 500-1,000 | 512x512 |
| Props (large) | 1,000-3,000 | 1024x1024 |
| Props (small) | 100-500 | 512x512 |
| Buildings (hero) | 5,000-10,000 | 2048x2048 |
| Buildings (background) | 500-2,000 | 1024x1024 |
| Vehicles | 3,000-6,000 | 1024x1024 |

### 2.2 Modeling Standards

#### Scale
- **1 Godot unit = 1 meter**
- Average human height: 1.75 units
- Door height: 2.1 units
- Standard room: 3.0 units ceiling

#### Orientation
- **Up**: +Y axis
- **Forward**: -Z axis
- Origin at base center (feet for characters)

#### Geometry
- Quads preferred, triangulate before export
- No N-gons (5+ sided faces)
- No isolated vertices or edges
- Weld vertices at seams
- Consistent face normals (outward)

#### LOD Requirements
| Distance | LOD Level | Triangle % |
|----------|-----------|------------|
| 0-10m | LOD0 | 100% |
| 10-25m | LOD1 | 50% |
| 25-50m | LOD2 | 25% |
| 50m+ | LOD3/Billboard | 10% |

### 2.3 Export Settings

#### GLTF 2.0 (Preferred)
```
Format: glTF Separate (.gltf + .bin + textures)
Transform: +Y Up
Include:
  ✓ Cameras (if applicable)
  ✓ Punctual Lights (if applicable)
  ✓ Custom Properties
Geometry:
  ✓ Apply Modifiers
  ✓ UVs
  ✓ Normals
  ✓ Tangents
  ✓ Vertex Colors (if used)
Animation:
  ✓ Animations (if applicable)
  ✓ Shape Keys (if applicable)
  ✓ Skinning (if applicable)
Compression:
  ✗ Draco (import issues in Godot)
```

#### FBX (Alternative)
```
Version: FBX 2014/2015
Scale: 1.0
Apply Scalings: FBX All
Forward: -Z Forward
Up: Y Up
Apply Transform: ✓
Geometry:
  Smoothing: Face
  Export Tangent Space: ✓
Armatures:
  Only Deform Bones: ✓
  Add Leaf Bones: ✗
```

### 2.4 Format Selection Guide

Use the appropriate export format based on asset type:

| Asset Type | Format | Reason |
|------------|--------|--------|
| **Static Props** | GLB | Single file, compact, fast loading |
| **Vehicles (static)** | GLB | No skeleton, optimized for static placement |
| **Vehicles (animated)** | FBX | Doors, wheels with bone animations |
| **Rigged Characters** | FBX | Better skeletal mesh support in Godot |
| **Animated Assets** | FBX | Animation data preserves better |
| **Buildings** | GLB | Static geometry, no animations |
| **Weapons (1st person)** | FBX | Often rigged for animations |
| **Weapons (pickup)** | GLB | Static prop on ground |
| **Complex Scenes** | GLTF Separate | Easier debugging, texture management |

**Blender MCP Export Tool:**
```python
# Use export_object for multi-format support
export_object(
    object_names=["MyAsset"],
    filepath="/path/to/asset.glb",
    export_format="GLB",  # or "FBX", "OBJ", "GLTF"
    include_materials=True,
    include_textures=True,
    apply_modifiers=True
)
```

### 2.5 Material Library Workflow

Reusable materials are stored in `game/assets/materials/library/` organized by category.

#### Material Naming Convention

```
us_mat_[category]_[name].json

Categories:
- metal      (rust, chrome, brushed, etc.)
- glass      (window, frosted, tinted)
- fabric     (leather, cotton, canvas)
- paint      (wall, weathered, glossy)
- architectural (brick, concrete, plaster)
- organic    (skin, wood, vegetation)
- vehicle    (car_paint, chrome, rubber)

Examples:
us_mat_metal_rust_heavy.json
us_mat_glass_window_dirty.json
us_mat_fabric_leather_worn.json
us_mat_paint_wall_peeling.json
us_mat_architectural_brick_aged.json
us_mat_organic_skin_caucasian.json
us_mat_vehicle_chrome_dirty.json
```

#### Folder Structure

```
game/assets/materials/library/
├── metal/
│   ├── us_mat_metal_rust_heavy.json
│   ├── us_mat_metal_chrome_clean.json
│   └── us_mat_metal_brushed_steel.json
├── glass/
│   ├── us_mat_glass_window_dirty.json
│   └── us_mat_glass_frosted.json
├── fabric/
│   ├── us_mat_fabric_leather_worn.json
│   └── us_mat_fabric_canvas_military.json
├── paint/
│   ├── us_mat_paint_wall_peeling.json
│   └── us_mat_paint_weathered_blue.json
├── architectural/
│   ├── us_mat_architectural_brick_aged.json
│   └── us_mat_architectural_concrete_cracked.json
├── organic/
│   ├── us_mat_organic_skin_caucasian.json
│   └── us_mat_organic_wood_weathered.json
└── vehicle/
    ├── us_mat_vehicle_paint_turquoise.json
    ├── us_mat_vehicle_chrome_dirty.json
    └── us_mat_vehicle_rubber_tire.json
```

#### Exporting Materials (Blender MCP)

```python
# Export material to library
export_material(
    material_name="Weathered_Chrome",
    filepath="/path/to/game/assets/materials/library/metal/us_mat_metal_chrome_weathered.json",
    export_format="JSON",
    include_textures=True,
    pack_textures=True
)
```

#### Importing Materials (Blender MCP)

```python
# Import from library
import_material(
    filepath="/path/to/game/assets/materials/library/metal/us_mat_metal_chrome_weathered.json",
    material_name="Weathered_Chrome"
)
```

#### Material Inspection

```python
# List all materials in scene
list_materials()

# Get detailed material data
get_material_data(material_name="MyMaterial")
```

### 2.6 Naming Convention

```
[category]_[name]_[variant]_[lod].[ext]

Examples:
prop_barrel_rusted_lod0.gltf
char_player_male_lod1.gltf
wpn_pistol_m1911_lod0.gltf
env_building_apartment_lod2.gltf
veh_car_sedan_destroyed.gltf
```

---

## 3. Textures

### 3.1 Technical Requirements

| Map Type | Format | Bit Depth | sRGB |
|----------|--------|-----------|------|
| Albedo/Diffuse | PNG/JPG | 8-bit | Yes |
| Normal | PNG | 8-bit | No |
| Roughness | PNG | 8-bit | No |
| Metallic | PNG | 8-bit | No |
| AO | PNG | 8-bit | No |
| Emission | PNG | 8-bit | Yes |
| Height | PNG | 16-bit | No |

### 3.2 Resolution Guidelines

| Asset Type | Albedo | Normal | ORM |
|------------|--------|--------|-----|
| Characters | 2048 | 2048 | 2048 |
| Weapons | 1024 | 1024 | 1024 |
| Props | 512-1024 | 512-1024 | 512-1024 |
| Environment | 1024-2048 | 1024-2048 | 1024-2048 |
| UI Elements | Power of 2 | N/A | N/A |

### 3.3 PBR Workflow

We use **Metallic/Roughness** workflow:

| Map | Channel | Description |
|-----|---------|-------------|
| Albedo | RGB | Base color (no lighting baked in!) |
| Normal | RGB | Tangent-space normal map (OpenGL: Y+ up) |
| ORM | R | Ambient Occlusion |
| ORM | G | Roughness (0=smooth, 1=rough) |
| ORM | B | Metallic (0=dielectric, 1=metal) |

### 3.4 Texture Naming

```
[asset]_[maptype].[ext]

Map Type Suffixes:
_albedo, _diffuse, _color   - Base color
_normal, _nrm               - Normal map
_roughness, _rough          - Roughness
_metallic, _metal           - Metallic
_ao, _occlusion             - Ambient occlusion
_orm                        - Combined ORM
_emission, _emissive        - Emission
_height, _displacement      - Height map

Examples:
barrel_rusted_albedo.png
barrel_rusted_normal.png
barrel_rusted_orm.png
```

### 3.5 UV Guidelines

- No overlapping UVs (except mirrored symmetry)
- 2-4 pixel padding between UV islands
- Consistent texel density across similar assets
- Pack efficiently (>70% UV space usage)
- Straighten edges where possible for better compression

---

## 4. Characters

### 4.1 Player Character

#### Requirements
- Modular clothing system (separate meshes)
- Full body visible (third-person)
- Clean topology for deformation
- Facial expressions (basic)

#### Skeleton (SkeletonProfileHumanoid Standard)

> **Note**: Bone names follow Godot 4's `SkeletonProfileHumanoid` standard for seamless
> animation retargeting. This enables sharing animations between player and enemy characters.

```
Root
└── Hips
    ├── Spine
    │   ├── Chest
    │   │   └── UpperChest
    │   │       ├── Neck
    │   │       │   └── Head
    │   │       │       └── [Facial bones: Jaw, LeftEye, RightEye]
    │   │       ├── LeftShoulder
    │   │       │   └── LeftUpperArm
    │   │       │       └── LeftLowerArm
    │   │       │           └── LeftHand
    │   │       │               └── [Finger bones: Thumb, Index, Middle, Ring, Little]
    │   │       └── RightShoulder
    │   │           └── [Mirror of left]
    │   └── [Pelvis accessories]
    ├── LeftUpperLeg
    │   └── LeftLowerLeg
    │       └── LeftFoot
    │           └── LeftToes
    └── RightUpperLeg
        └── [Mirror of left]
```

#### Bone Naming Reference

| Body Part | Standard Name | Mixamo Equivalent |
|-----------|---------------|-------------------|
| Hip | `Hips` | `mixamorig:Hips` |
| Spine | `Spine` | `mixamorig:Spine` |
| Chest | `Chest` | `mixamorig:Spine1` |
| Upper Chest | `UpperChest` | `mixamorig:Spine2` |
| Neck | `Neck` | `mixamorig:Neck` |
| Head | `Head` | `mixamorig:Head` |
| Shoulder | `LeftShoulder` | `mixamorig:LeftShoulder` |
| Upper Arm | `LeftUpperArm` | `mixamorig:LeftArm` |
| Lower Arm | `LeftLowerArm` | `mixamorig:LeftForeArm` |
| Hand | `LeftHand` | `mixamorig:LeftHand` |
| Upper Leg | `LeftUpperLeg` | `mixamorig:LeftUpLeg` |
| Lower Leg | `LeftLowerLeg` | `mixamorig:LeftLeg` |
| Foot | `LeftFoot` | `mixamorig:LeftFoot` |
| Toes | `LeftToes` | `mixamorig:LeftToeBase` |

#### Clothing Layers
1. Body (base mesh, always visible)
2. Underwear/Base layer
3. Shirt/Jacket
4. Pants
5. Shoes
6. Accessories (hat, glasses, backpack)

### 4.2 Enemy Characters

| Type | Distinguishing Features |
|------|------------------------|
| Scavenger | Ragged clothes, improvised gear |
| Raider | Leather, spikes, intimidating |
| Veteran | Military surplus, tactical gear |

- Clear silhouettes for identification
- Readable at 30+ meters
- Color coding for threat level

---

## 5. Animations

### 5.1 Animation List

#### Player
| Animation | Frames | Loop | Priority |
|-----------|--------|------|----------|
| idle | 60 | Yes | P1 |
| walk | 30 | Yes | P1 |
| run | 24 | Yes | P1 |
| sprint | 20 | Yes | P1 |
| crouch_idle | 60 | Yes | P2 |
| crouch_walk | 40 | Yes | P2 |
| jump_start | 10 | No | P1 |
| jump_loop | 20 | Yes | P1 |
| jump_land | 15 | No | P1 |
| aim_idle | 60 | Yes | P1 |
| fire | 8 | No | P1 |
| reload | 60 | No | P1 |
| melee | 20 | No | P2 |
| interact | 30 | No | P2 |
| death | 45 | No | P1 |

#### Enemy
| Animation | Frames | Loop |
|-----------|--------|------|
| idle | 60 | Yes |
| walk | 30 | Yes |
| run | 24 | Yes |
| attack_melee | 24 | No |
| attack_ranged | 15 | No |
| hit_react | 15 | No |
| death_front | 45 | No |
| death_back | 45 | No |
| cover_enter | 20 | No |
| cover_idle | 60 | Yes |
| cover_peek | 30 | No |

### 5.2 Animation Standards

- **Frame Rate**: 30 FPS
- **Root Motion**: Optional (code-driven preferred)
- **IK Ready**: Proper pole vectors for arm/leg IK
- **Blend Friendly**: Start/end poses match idle

### 5.3 Export Settings

```
Format: GLTF with embedded animations
  OR: Separate .gltf per animation

Animation Settings:
  - All Actions: ✓ (if combined)
  - NLA Strips: ✗
  - Sampling Rate: 1 (every frame)
  - Always Sample Animations: ✓
```

---

## 6. UI Assets

### 6.1 Resolution
- Design at **1920x1080** (1080p reference)
- Export at **2x** for 4K support
- Use 9-slice for scalable elements

### 6.2 Format
- **PNG** for all UI elements
- Transparent backgrounds where needed
- Pre-multiplied alpha

### 6.3 Icon Sizes
| Type | Size | Padding |
|------|------|---------|
| Inventory slots | 64x64 | 4px |
| Weapon icons | 128x64 | 8px |
| Status icons | 32x32 | 2px |
| Button icons | 24x24 | 2px |

### 6.4 Style Guide
- **Font**: Sans-serif, military/industrial feel
- **Borders**: Subtle, 1-2px
- **Corners**: Slightly rounded (4px radius)
- **Shadows**: Subtle drop shadows for readability

---

## 7. Audio Assets

### 7.1 Technical Specs

| Type | Format | Sample Rate | Channels |
|------|--------|-------------|----------|
| Sound Effects | WAV/OGG | 44100 Hz | Mono |
| 3D Audio | WAV/OGG | 44100 Hz | Mono |
| Music | OGG | 44100 Hz | Stereo |
| Voice | OGG | 44100 Hz | Mono |
| Ambience | OGG | 44100 Hz | Stereo |

### 7.2 Volume Guidelines
- Peak at **-6 dB** maximum
- Average at **-18 dB** for mixing headroom
- No clipping

### 7.3 Sound Categories

| Category | Examples | 3D | Priority |
|----------|----------|-----|----------|
| Player | Footsteps, breathing, actions | Some | High |
| Weapons | Gunfire, reload, impacts | Yes | High |
| Enemies | Footsteps, voices, alerts | Yes | High |
| Environment | Wind, debris, machinery | Yes | Medium |
| Ambience | Background loops | No | Low |
| UI | Clicks, notifications | No | Medium |
| Music | Dynamic score | No | Medium |

---

## 8. File Organization

### 8.1 Asset Folder Structure
```
game/assets/
├── models/
│   ├── characters/
│   │   ├── player/
│   │   └── enemies/
│   ├── weapons/
│   ├── props/
│   ├── vehicles/
│   └── environment/
├── textures/
│   ├── characters/
│   ├── weapons/
│   ├── props/
│   ├── environment/
│   └── ui/
├── animations/
│   ├── player/
│   └── enemies/
├── audio/
│   ├── sfx/
│   │   ├── player/
│   │   ├── weapons/
│   │   ├── enemies/
│   │   └── environment/
│   ├── music/
│   └── voice/
└── ui/
    ├── icons/
    ├── backgrounds/
    └── fonts/
```

### 8.2 Import Files
- Keep source files (`.blend`, `.psd`) in separate `source/` folder
- Only commit game-ready exports to main repo
- Use Git LFS for large binary files

---

## 9. Quality Checklist

### Before Submitting Assets

#### 3D Models
- [ ] Triangle count within budget
- [ ] Correct scale (1 unit = 1 meter)
- [ ] Proper orientation (+Y up, -Z forward)
- [ ] Clean geometry (no N-gons, isolated verts)
- [ ] LODs created (if required)
- [ ] Colliders defined or requested
- [ ] UV mapped, no overlaps
- [ ] Named correctly

#### Textures
- [ ] Power of 2 dimensions
- [ ] Correct format (PNG for quality, JPG for photos)
- [ ] sRGB set correctly
- [ ] Normal map is OpenGL format (Y+)
- [ ] No baked lighting in albedo
- [ ] Named correctly

#### Animations
- [ ] Correct frame rate (30 FPS)
- [ ] Loops seamlessly (if looping)
- [ ] No foot sliding (root motion or baked)
- [ ] Named correctly

#### Audio
- [ ] Correct sample rate (44100 Hz)
- [ ] Mono for 3D, Stereo for music
- [ ] Proper normalization (-6 dB peak)
- [ ] No clipping
- [ ] Named correctly

---

## 10. Communication

### Requesting Assets
Use the standard asset request template:
```
Asset Type: [Model/Texture/Animation/Audio]
Name: [Descriptive name]
Description: [What it is, how it's used]
Reference: [Links to reference images/sounds]
Priority: [P1/P2/P3]
Deadline: [Date if applicable]
Technical Notes: [Poly budget, size, special requirements]
```

### Feedback Format
```
Asset: [Asset name]
Status: [Approved/Needs Changes]
Feedback:
- [Specific, actionable feedback]
- [Include screenshots if visual]
```
