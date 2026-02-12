---
agent: 'model-spec-writer'
description: 'Generate building and environment model specifications for level geometry.'
---

Create a building/environment model specification document.

## Load Context First
- docs/ART_GUIDELINES.md (poly budgets, 1960s reference)
- docs/SPEC.md Section 7 (World Design, level locations)

## Input Parameters
Specify building type:
- **Building Type**: residential | commercial | industrial | landmark
- **Location**: manhattan | brooklyn | other
- **Role**: hero (close-up) | mid-ground | background
- **Destruction Level**: intact | damaged | ruined | collapsed

## 1960s NYC Architecture Reference

### Residential
- **Brownstones**: 3-5 stories, brick, stoops, fire escapes
- **Tenements**: 5-7 stories, brick, lots of windows
- **Apartments**: Art Deco lobbies, decorative cornices

### Commercial
- **Storefronts**: Display windows, awnings, neon signs
- **Diners**: Chrome exterior, large windows, neon
- **Office buildings**: Art Deco, stone facade, lobby entrance
- **Department stores**: Large display windows, marquee

### Industrial
- **Warehouses**: Brick, loading docks, few windows
- **Factories**: Smokestacks, large doors, water towers
- **Docks**: Wooden piers, cranes, shipping containers

### Landmarks
- **Subway entrances**: Green railings, globe lights
- **Churches**: Gothic or Romanesque, steeples
- **Movie theaters**: Marquee, vertical sign, ticket booth

## Destruction Levels

### Intact
- Pre-war condition
- Minor weathering
- Windows intact
- Signs readable

### Damaged
- Some broken windows
- Bullet holes, scorch marks
- Debris at base
- Signs partially damaged

### Ruined
- Major structural damage
- Collapsed sections
- Exposed interiors
- Rubble piles

### Collapsed
- Mostly rubble
- Few standing walls
- Navigation obstacle
- Cover opportunities

## Output
Create `docs/models/BUILDING_[TYPE]_SPEC.md` with:

1. **Overview**
   - Building type and purpose
   - NYC location reference
   - Gameplay role (traversable, background, landmark)

2. **Technical Specifications**
   | Role | Poly Budget | Texture | LODs |
   |------|-------------|---------|------|
   | Hero | 5,000-10,000 | 2048 | 3 |
   | Mid-ground | 2,000-5,000 | 1024 | 2 |
   | Background | 500-2,000 | 1024 | 1-2 |

3. **Dimensions**
   - Typical floor height (3.0m)
   - Building footprint
   - Total height
   - Street setback

4. **Architectural Elements**
   - Period-accurate features
   - Windows (style, size, pattern)
   - Doors and entrances
   - Roof elements (water tower, antenna, AC units)
   - Fire escapes (if residential)

5. **Facade Details**
   - Material (brick, stone, concrete)
   - Decorative elements (cornices, trim)
   - Signage positions
   - Awning/canopy positions

6. **Destruction Details**
   - Damage pattern guidelines
   - Exposed interior requirements
   - Rubble generation
   - Traversable paths through ruins

7. **Interior (If Accessible)**
   - Floor plan notes
   - Key rooms/areas
   - Furniture density
   - Loot spawn areas
   - Cover positions

8. **Materials**
   - Exterior: Brick, stone, concrete variations
   - Windows: Glass (broken/intact states)
   - Metal: Fire escapes, railings, signs
   - Wood: Doors, window frames

9. **Modular Pieces**
   - Wall sections (for kitbashing)
   - Window variations
   - Door variations
   - Roof sections
   - Corner pieces

10. **Integration**
    - Ground contact (rubble, debris)
    - Adjacent building connections
    - Street furniture placement
    - Light source positions

## Acceptance Criteria
- [ ] Spec document created
- [ ] 1960s NYC architecture accurate
- [ ] Destruction states defined
- [ ] Modular pieces identified
- [ ] Gameplay integration documented
