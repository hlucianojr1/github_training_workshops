---
agent: 'model-spec-writer'
description: 'Generate vehicle model specifications for 1960s era cars, trucks, and military vehicles.'
---

Create a vehicle model specification document.

## Load Context First
- docs/ART_GUIDELINES.md (poly budgets, 1960s reference)
- docs/SPEC.md Section 7 (World Design, Manhattan/Brooklyn)

## Input Parameters
Specify vehicle type:
- **Vehicle Type**: sedan | taxi | bus | truck | military
- **Damage State**: pristine | damaged | destroyed | burned
- **Driveable**: yes | no (prop only)

## 1960s Vehicle Reference

### Sedan (Civilian Car)
- **Era Models**: 1955-1965 American full-size
- **Features**: Chrome bumpers, tail fins, rounded body
- **Examples**: Chevrolet Bel Air, Ford Galaxie, Plymouth Fury
- **Poly Budget**: 3,000-5,000 triangles
- **Texture**: 1024x1024

### Taxi (Yellow Cab)
- **Era Models**: Checker Marathon style
- **Features**: Boxy body, roof light, yellow paint
- **Distinctive**: Checkered stripe, taxi markings
- **Poly Budget**: 3,000-5,000 triangles
- **Texture**: 1024x1024

### Bus (City Transit)
- **Era Models**: 1950s-60s transit bus
- **Features**: Rounded front, two-tone paint, large windows
- **Examples**: GM "Old Look" bus
- **Poly Budget**: 5,000-6,000 triangles
- **Texture**: 1024x1024

### Truck (Delivery)
- **Era Models**: 1950s-60s panel truck
- **Features**: Rounded cab, wooden/metal bed
- **Examples**: Ford F-100, Chevrolet Apache
- **Poly Budget**: 3,000-5,000 triangles
- **Texture**: 1024x1024

### Military
- **Era Models**: Korean War / early Cold War
- **Types**: Jeep (M38/M151), Deuce-and-a-half, Tank (M48)
- **Features**: Olive drab, white star markings
- **Poly Budget**: 4,000-6,000 triangles
- **Texture**: 1024x1024

## Damage States

### Pristine
- Pre-apocalypse condition
- Minor wear/dust
- All parts intact

### Damaged
- Broken windows (some)
- Dents and scratches
- Flat tires (1-2)
- Faded paint

### Destroyed
- All windows broken
- Major body damage
- All tires flat/missing
- Debris inside

### Burned
- Charred paint
- Melted components
- Rust and corrosion
- Skeletal frame visible

## Output
Create `docs/models/VEHICLE_[TYPE]_SPEC.md` with:

1. **Overview**
   - Vehicle type and purpose
   - Era and model references
   - Gameplay use (cover, landmark, driveable)

2. **Technical Specifications**
   - Polygon budget (per damage state)
   - Texture resolution
   - LOD requirements
   - Collision mesh requirements

3. **Dimensions**
   - Length, width, height (realistic 1960s)
   - Ground clearance
   - Door/trunk positions (for cover)

4. **Visual Design**
   - Period-accurate features
   - Chrome and metal work
   - Paint schemes (two-tone common)
   - Interior visibility requirements

5. **Damage State Details**
   - Per-state visual requirements
   - Shared vs unique geometry
   - Material/texture changes

6. **Materials**
   - Body paint (multiple colors)
   - Chrome (high metallic)
   - Glass (transparent, breakable)
   - Rubber (tires, trim)
   - Interior (leather, fabric)

7. **Variants**
   - Color variants
   - Damage state variants
   - Optional accessories

8. **Gameplay Integration**
   - Cover points (hood, trunk, doors)
   - Destructible elements
   - Loot spawn points (trunk, glove box)

## Acceptance Criteria
- [ ] Spec document created
- [ ] 1960s era accurate (no modern features)
- [ ] Damage states defined
- [ ] Cover/gameplay use documented
- [ ] LOD requirements included
