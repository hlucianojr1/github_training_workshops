---
agent: 'model-spec-writer'
description: 'Generate prop model specifications for weapons, items, and interactive objects.'
---

Create a prop model specification document.

## Load Context First
- docs/ART_GUIDELINES.md (poly budgets, texture specs)
- docs/SPEC.md Section 4-5 (Inventory, Combat)

## Input Parameters
Specify prop category:
- **Category**: weapon | item | furniture | street_prop | building_element
- **Prop Name**: [specific item]
- **Interactive**: yes | no
- **Priority**: P1 | P2 | P3

## Prop Categories

### Weapons
| Weapon | Poly Budget (1st) | Poly Budget (3rd) | Texture |
|--------|-------------------|-------------------|---------|
| M1911 Pistol | 3,000-5,000 | 500-800 | 1024 |
| Combat Shotgun | 4,000-5,000 | 800-1,000 | 1024 |
| M14 Rifle | 4,000-5,000 | 800-1,000 | 1024 |
| Thompson SMG | 4,000-5,000 | 800-1,000 | 1024 |
| Melee (bat, pipe) | 500-1,000 | 200-400 | 512 |

### Items (Pickups)
| Item | Poly Budget | Texture |
|------|-------------|---------|
| Medkit | 200-400 | 512 |
| Bandage | 100-200 | 256 |
| Ammo box | 100-300 | 512 |
| Food can | 100-200 | 256 |
| Water bottle | 100-200 | 256 |

### Street Props
| Prop | Poly Budget | Texture |
|------|-------------|---------|
| Fire hydrant | 300-500 | 512 |
| Street lamp | 500-800 | 512 |
| Mailbox | 200-400 | 512 |
| Phone booth | 800-1,200 | 1024 |
| Trash can | 200-400 | 512 |
| Park bench | 400-600 | 512 |
| Newspaper stand | 500-800 | 512 |

### Furniture (Interior)
| Prop | Poly Budget | Texture |
|------|-------------|---------|
| Chair | 300-500 | 512 |
| Table | 200-400 | 512 |
| Couch | 600-1,000 | 1024 |
| Bed | 500-800 | 1024 |
| Desk | 400-600 | 512 |
| Filing cabinet | 200-400 | 512 |

### Building Elements
| Element | Poly Budget | Texture |
|---------|-------------|---------|
| Door | 100-200 | 512 |
| Window frame | 100-200 | 512 |
| Fire escape section | 500-800 | 512 |
| Awning | 200-400 | 512 |
| Neon sign | 300-600 | 512 |

## Output
Create `docs/models/PROP_[NAME]_SPEC.md` with:

1. **Overview**
   - Prop name and purpose
   - Category and priority
   - Gameplay interaction (if any)

2. **Technical Specifications**
   - Polygon budget
   - Texture resolution
   - LOD requirements (if visible at distance)
   - Collision requirements

3. **Dimensions**
   - Real-world accurate size
   - Scale in Godot units (meters)

4. **Visual Design**
   - 1960s era accuracy
   - Materials and colors
   - Weathering level
   - Damage states (if applicable)

5. **Materials**
   - PBR map requirements
   - Material types (metal, wood, glass, fabric)
   - Roughness/metallic values

6. **Interaction (If Interactive)**
   - Interaction type (pickup, open, use)
   - Animation requirements
   - Sound triggers
   - Loot contents (if container)

7. **Variants**
   - Color variants
   - Damage variants
   - Open/closed states

8. **Placement Notes**
   - Where this prop appears
   - Density guidelines
   - Grouping with other props

## Weapon-Specific Sections

For weapons, also include:

### First-Person View
- High detail requirements
- Hand grip positions
- Iron sight alignment
- Muzzle flash point

### Third-Person View
- Simplified LOD
- Attachment points on character
- Silhouette readability

### Animations
- Idle sway
- Fire recoil
- Reload (multi-part)
- Inspect (optional)

### Effects
- Muzzle flash position
- Shell ejection point
- Magazine position
- Attachment rails (if any)

## Acceptance Criteria
- [ ] Spec document created
- [ ] 1960s era accurate
- [ ] Poly budget defined
- [ ] Interaction documented (if any)
- [ ] Placement context included
