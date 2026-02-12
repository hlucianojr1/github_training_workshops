---
agent: 'model-spec-writer'
description: 'Generate enemy character model specifications for 3D artists.'
---

Create an enemy character model specification document.

## Load Context First
- docs/ART_GUIDELINES.md (poly budgets, texture specs)
- docs/SPEC.md Section 6 (Enemy AI, enemy types)
- docs/models/PLAYER_MODEL_SPEC.md (for skeleton compatibility)

## Input Parameters
Specify which enemy type:
- **Enemy Type**: scavenger | raider | veteran | boss
- **Priority**: P1 (critical) | P2 (important) | P3 (future)

## Enemy Type Profiles

### Scavenger (P1 - First enemy type)
- **Role**: Weak, flees when hurt, prefers looting
- **Silhouette**: Hunched, carrying bags
- **Colors**: Brown/tan, ragged
- **Armor**: None or minimal
- **Weapons**: Melee improvised, rarely pistol
- **Poly Budget**: 8,000-10,000 triangles
- **Texture**: 1024x1024

### Raider (P1 - Core enemy)
- **Role**: Aggressive, uses cover
- **Silhouette**: Bulky, spikes/armor
- **Colors**: Black/red, intimidating
- **Armor**: Improvised (sports pads, metal)
- **Weapons**: Shotguns, melee
- **Poly Budget**: 10,000-12,000 triangles
- **Texture**: 1024x1024

### Veteran (P2 - Later game)
- **Role**: Tactical, flanks, uses grenades
- **Silhouette**: Upright, military posture
- **Colors**: Green/camo, organized
- **Armor**: Military surplus gear
- **Weapons**: Rifles, tactical loadout
- **Poly Budget**: 10,000-12,000 triangles
- **Texture**: 1024x1024

### Boss (P3 - Per level)
- **Role**: Unique per level, high threat
- **Silhouette**: Imposing, distinctive
- **Colors**: Unique, memorable
- **Armor**: Heavy, custom
- **Weapons**: Unique
- **Poly Budget**: 15,000-20,000 triangles
- **Texture**: 2048x2048

## Output
Create `docs/models/ENEMY_[TYPE]_SPEC.md` with:

1. **Overview**
   - Enemy type and role
   - Threat level and behavior
   - Visual distinctiveness requirements

2. **Body Specifications**
   - Height and build (type-specific)
   - Polygon budget
   - Distinguishing physical features

3. **Clothing/Armor**
   - Type-specific outfit
   - 1960s era accuracy
   - Post-apocalyptic modifications
   - Damage states (if needed)

4. **Skeleton Requirements**
   - Simplified from player (50-55 bones)
   - Compatible with player animations (shared)
   - Enemy-specific animations

5. **Material Requirements**
   - PBR specs
   - Weathering and damage
   - Color coding for threat recognition

6. **Animation List (Enemy-Specific)**
   - Locomotion: idle, walk, run
   - Combat: attack_melee, attack_ranged, hit_react
   - States: alert, cover_idle, cover_peek
   - Death: death_front, death_back

7. **Variants**
   - Weapon loadout variants
   - Clothing/armor variants
   - Damage state variants

8. **Readability at Distance**
   - Silhouette requirements
   - Color coding
   - Readable at 30-50m

## Acceptance Criteria
- [ ] Spec document created
- [ ] Distinct from other enemy types
- [ ] Threat level visually clear
- [ ] 1960s era accurate
- [ ] Animation sharing notes included
