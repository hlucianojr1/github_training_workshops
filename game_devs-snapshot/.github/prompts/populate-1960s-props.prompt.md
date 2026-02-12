---
agent: 'environment-artist'
description: 'Populate level with period-accurate 1960s NYC environmental props and destruction elements.'
---

Populate level with 1960s NYC period-accurate props and destruction.

## Load Context First
- docs/ART_GUIDELINES.md (1960s reference)
- docs/SPEC.md Section 7 (World Design)
- game/assets/models/ (available props)
- game/scenes/level_1.tscn

## Requirements
- Period-accurate 1960s American props
- Appropriate destruction and decay
- Gameplay-readable environment
- Visual storytelling through props
- Performance-conscious placement

## 1960s NYC Props Checklist

### Vehicles (Destroyed/Abandoned)
```
Essential:
- [ ] 1950s-60s American sedans (rounded, chrome, tail fins)
- [ ] Yellow taxi cabs (Checker Marathon style)
- [ ] Delivery trucks (rounded cab, wooden bed)
- [ ] City buses (rounded, two-tone paint)

Placement:
- Crashed into buildings
- Burned out shells
- Overturned, used as cover
- Rusted, flat tires, broken glass
```

### Street Furniture
```
Essential:
- [ ] Fire hydrants (classic red/silver)
- [ ] Street lamps (ornate metal, broken glass)
- [ ] Mailboxes (rounded top, blue)
- [ ] Newspaper stands (metal frame, glass front)
- [ ] Phone booths (glass and metal, classic design)
- [ ] Trash cans (metal cylinder)
- [ ] Park benches (wooden slats, iron frame)

Destruction states:
- Knocked over
- Bullet holes
- Rust and weathering
- Partial collapse
```

### Signage (1960s Typography)
```
Essential:
- [ ] Neon signs (broken, some flickering)
- [ ] Hand-painted shop signs
- [ ] Metal street signs
- [ ] Movie theater marquees
- [ ] Diner signs (chrome, bulbs)
- [ ] "Fallout Shelter" signs (yellow/black)

Style notes:
- Serif and script fonts common
- No digital/LED style
- Faded, weather-worn
```

### Building Elements
```
Essential:
- [ ] Fire escapes (zig-zag metal)
- [ ] Brownstone stoops
- [ ] Art Deco details
- [ ] Awnings (striped canvas, torn)
- [ ] Apartment AC units (window-mounted)
- [ ] Water towers (wooden, rooftop)
- [ ] Rooftop antennas (TV aerials)

Destruction:
- Collapsed sections
- Exposed interiors
- Rubble piles
- Broken windows (all or partial)
```

### Interior Props (for accessible buildings)
```
Living spaces:
- [ ] Tube television sets
- [ ] Rotary dial telephones
- [ ] Radios (wooden cabinet style)
- [ ] Refrigerators (rounded, chrome handles)
- [ ] Furniture (mid-century modern)
- [ ] Magazines/newspapers (period)
- [ ] Record players

Commercial:
- [ ] Cash registers (mechanical)
- [ ] Display cases
- [ ] Counter stools (chrome, vinyl)
- [ ] Jukeboxes
```

## Destruction Elements

### Rubble Types
```
- Concrete chunks (various sizes)
- Brick piles
- Twisted rebar
- Shattered glass
- Wooden debris
- Fallen masonry
- Collapsed ceiling material
```

### Environmental Storytelling
```
Place props to tell stories:
- Abandoned evacuation (suitcases, overturned stroller)
- Military presence (sandbags, barriers, spent casings)
- Scavenger activity (opened containers, stripped vehicles)
- Time passage (overgrown weeds, rust, decay)
- Violence (bullet holes, blood stains, bodies optional)
```

## Placement Guidelines

### Gameplay Readability
```
- Clear paths through rubble
- Cover objects at appropriate heights (0.8-1.2m)
- Interactable items visually distinct
- Enemy spawn areas visible but defensible
```

### Performance
```
- LOD models for distant props
- Combine static meshes where possible
- Use instancing for repeated props
- Limit unique materials per area
- Max draw distance: 100m for props
```

### Density by Area Type
```
Street: Medium density
- Vehicles every 20-30m
- Street furniture clusters
- Rubble concentrated at building bases

Interior: High density
- Props on surfaces
- Furniture arrangements
- Personal items for atmosphere

Open area: Low density
- Scattered debris
- Focal point props (vehicle, statue)
- Navigation landmarks
```

## Prop Instances to Place (Level 1 Manhattan)

### Required Minimum
```
Vehicles: 8-12
- 4 sedans (various damage states)
- 2 taxis
- 1 bus (major landmark)
- 1 delivery truck

Street furniture: 20-30 instances
- Fire hydrants: 4-6
- Street lamps: 8-10 (mix working/broken)
- Mailboxes: 2-3
- Phone booths: 2-3
- Benches: 4-6
- Trash cans: 6-8

Signage: 10-15
- Neon signs: 3-4 (one flickering if possible)
- Shop signs: 4-5
- Street signs: 3-4

Rubble piles: 15-20
- Small: 10-12
- Medium: 4-6
- Large: 2-3
```

## Validation Checklist

### Period Accuracy
- [ ] No modern vehicles/props
- [ ] Typography is 1960s appropriate
- [ ] Technology is pre-digital
- [ ] Fashion/advertising references correct era

### Gameplay
- [ ] Player path navigable
- [ ] Cover available in combat areas
- [ ] Scavenge points accessible
- [ ] No invisible collision issues

### Performance
- [ ] Runs at 60 FPS
- [ ] No excessive draw calls
- [ ] LODs functioning
- [ ] Occlusion culling effective

### Visual Quality
- [ ] No floating objects
- [ ] Consistent weathering/decay
- [ ] Proper lighting/shadows on props
- [ ] Materials match art guidelines

## Acceptance Criteria
- [ ] Level feels like 1960s NYC ruins
- [ ] Props support gameplay (cover, navigation)
- [ ] Environmental storytelling present
- [ ] Performance targets met
- [ ] No anachronistic elements
