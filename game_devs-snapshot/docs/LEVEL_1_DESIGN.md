# Level 1 Design: "The Heights"

## 1. Setting & Atmosphere
**Location**: Broadway, between 181st St and 175th St (Washington Heights).
**Time**: Late afternoon, overcast.
**Ambience**: The "Gateway to the City". This was the first line of defense that fell. The streets are clogged with abandoned evacuation vehicles.

### Visual Anchors
- **The George Washington Bridge**: Looming in the background, partially collapsed or blocked with military vehicles.
- **Loew's 175th Street Theatre**: A stunning example of 1930s/40s architecture (United Palace), now a fortress for survivors.
- **Pre-war Apartment Buildings**: 6-story brick buildings with fire escapes (verticality for enemies).

## 2. Gameplay Flow (Linear Southbound)
The player moves **South** down Broadway. The street is a "corridor" defined by the building facades on either side.

### Zone 1: The Traffic Jam (Start)
> [!NOTE]
> **Status**: In Progress. Initial blockout complete.

- **Environment**: A gridlock of abandoned 1950s/60s cars (Checker Marathons, Cadillacs, Ford Falcons).
- **Cover**: High density of low cover (car hoods, trunks).
- **Gameplay**: Tutorial area. Learning to crouch-move between cars.
- **Visuals**: Suitcases burst open, papers blowing in the wind, a "panic" frozen in time.

### Zone 2: The Checkpoint (Mid)
- **Environment**: A military blockade set up by the National Guard before they fell. Sandbags, barbed wire, and a destroyed M48 Patton tank as a centerpiece.
- **Cover**: Concrete barriers, sandbag walls.
- **Enemies**: "The Block Wardens" - Survivors using the military gear.
- **Mechanic**: Flanking required. The direct path is covered by a heavy machine gun nest (manned by AI).

### Zone 3: The Commercial Strip (End)
- **Environment**: 1960s storefronts. Neon signs buzzing and flickering.
    - *Woolworth's* (looted)
    - *Rexall Drugs*
    - *A local Diner* (chrome and glass)
- **Cover**: Telephone booths (glass shatters when hit), mailboxes (US Mail olive drab), newsstands.
- **Objective**: Reach the subway entrance at 168th St to transition to the next level (or a safe house).

## 3. Asset Requirements

### Environment Props (1960s Specific)
- **Street Furniture** (Prioritize placeholders if models unavailabe):
    - [ ] **Cast iron lampposts**: Tall, ornate style.
    - [ ] **Fire Alarm Box**: Red, pole-mounted.
    - [ ] **Pedestrian Signals**: "Walk/Don't Walk" text boxes.
    - [ ] **Trash Cans**: Wire mesh style.
    - [ ] **Phone Booths**: Superman style, full enclosure. *(Use box placeholder if needed)*.

> [!IMPORTANT]
> If 3D models are missing, use simple geometric shapes (e.g., grey cubes/cylinders) as placeholders to verify scale and cover mechanics. Create a task to import real models later.

### Vehicles
- 1957 Chevy Bel Air (wrecked)
- GMC "New Look" City Bus (blocking a side street)

### Enemy Fortifications
- **Jury-rigged Barricades**: Piles of furniture, car doors welded together, mattresses.
- **Traps**: Tripwires connected to soup cans (noise) or shotgun shells.

## 4. Lighting & Color Palette
> [!NOTE]
> Focused on Road and Buildings. Volumetrics and specific car colors have been deferred.

### Architecture (The Canyon)
- **Brick Red**: `#8B0000` (Aged, soot-stained brick for apartment buildings).
- **Concrete Grey**: `#708090` (Foundations, brutalist elements).
- **Limestone**: `#F5F5DC` (Ornamental details on theaters/banks).

### The Road (The path)
- **Asphalt Black**: `#2F4F4F` (Dark, cracked, wet look).
- **Faded White**: `#DCDCDC` (Lane markings, worn away).

### Street Shader Improvements
> [!IMPORTANT]
> Priority shader enhancement for visual authenticity.

#### A. Procedural Lane Markings
| Element | Visual | Implementation |
|---------|--------|----------------|
| Center Dashes | Faded yellow/white dashed line | UV-based `mod()` pattern |
| Edge Lines | Worn white lines at road edges | `smoothstep()` with noise erosion |
| Crosswalk Hints | Faded zebra patterns at intersections | Zone-triggered via uniform |

#### B. Normal Mapping (Surface Detail)
- **Asphalt Grain**: Low-frequency bump for overall texture
- **Crack Patterns**: Dark veins with depth illusion via normal perturbation
- **Potholes**: Circular depressions (optional, artist-controlled)

#### C. Puddle Integration Enhancements
- Current: Binary puddle mask ✓
- **Improvement**: Smooth puddle edges with `smoothstep()`
- **Improvement**: Environment reflection hints via specular
- **Improvement**: Ripple distortion (rain effect, deferred)

#### Shader Uniform Targets
```
lane_color = #DCDCDC (faded white)
lane_width = 0.04 (4% of road width)
dash_length = 2.0 (world units)
dash_gap = 1.5 (world units)
crack_intensity = 0.3
crack_scale = 15.0
normal_strength = 0.15
```

### Sidewalk Shader
> [!NOTE]
> Implemented procedural concrete slab pattern.

| Element | Visual | Implementation |
|---------|--------|----------------|
| Slab Grid | Large rectangular slabs | UV-based grid with offset rows |
| Grooves | Dark seam lines between slabs | `smoothstep()` edge detection |
| Surface Variation | Subtle color patches | Per-slab hash with noise |
| Weathering | Dirt in grooves, wear patterns | Edge proximity darkening |

#### Shader Uniform Targets
```
concrete_color = #A0A0A0 (medium gray)
slab_width = 1.5 (world units)
slab_length = 3.0 (world units)
groove_width = 0.015
groove_darkness = 0.45
```

### Future Polish (Deferred)
- [ ] Volumetric Fog
- [ ] Specific vehicle color grading (Faded Yellow Taxis)
