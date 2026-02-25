# Urban Survivor - Game Design Specification

## Document Control
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-30 | Initial | Core game design document |

---

## 1. Game Overview

### 1.1 Concept
**Urban Survivor** is a third-person survival shooter set in a post-apocalyptic 1960s America following World War III. Players must traverse devastated urban landscapes, scavenging for supplies while evading or fighting other survivors.

### 1.2 Genre
- Third-Person Shooter
- Survival
- Action-Adventure

### 1.3 Target Platform
- PC (Windows primary, Linux/macOS secondary)
- Godot 4.3+ with GDExtension (C++)

### 1.4 Target Audience
- Age: 17+ (Mature themes, violence)
- Players who enjoy: The Last of Us, Metro series, DayZ

---

## 2. Core Gameplay

### 2.1 Primary Loop
```
Enter City Level
      ↓
Explore & Scavenge
      ↓
Encounter Enemies (fight/flee/sneak)
      ↓
Manage Resources
      ↓
Reach Exit Point
      ↓
Progress to Next Level
```

### 2.2 Win/Loss Conditions
| Condition | Outcome |
|-----------|---------|
| Reach level exit | Progress to next city |
| Complete all levels | Game victory |
| Health reaches 0 | Game over (checkpoint restart) |
| Critical resources depleted | Weakened state → likely death |

### 2.3 Difficulty Scaling
- **Easy**: More loot, fewer enemies, enemies deal less damage
- **Normal**: Balanced resource/enemy ratio
- **Hard**: Scarce resources, aggressive AI, permadeath optional

---

## 3. Player Character

### 3.1 Movement
| Action | Input | Speed | Stamina Cost |
|--------|-------|-------|--------------|
| Walk | WASD | 5 m/s | None |
| Sprint | Shift + WASD | 8 m/s | 10/sec |
| Crouch | Ctrl | 2.5 m/s | None |
| Jump | Space | 4.5 m/s vertical | 5 per jump |

### 3.2 Combat Actions
| Action | Input | Description |
|--------|-------|-------------|
| Aim | Right Mouse (hold) | Raise weapon, reduce spread |
| Fire | Left Mouse | Fire equipped weapon |
| Reload | R | Reload current weapon |
| Melee | V | Emergency melee attack |
| Throw | G | Throw equipped throwable |

### 3.3 Interaction
| Action | Input | Range |
|--------|-------|-------|
| Interact | E | 2 meters |
| Pickup | E (on items) | 2 meters |
| Open container | E (on containers) | 2 meters |

### 3.4 Survival Stats
| Stat | Max | Regen | Depletion Effect |
|------|-----|-------|------------------|
| Health | 100 | None (needs items) | Death at 0 |
| Stamina | 100 | 15/sec (when not sprinting) | Cannot sprint/jump |

---

## 4. Inventory System

### 4.1 Inventory Slots
| Slot Type | Count | Contents |
|-----------|-------|----------|
| Primary Weapon | 1 | Rifles, shotguns |
| Secondary Weapon | 1 | Pistols, SMGs |
| Quick Slots | 4 | Consumables, throwables |
| Backpack | 12 | Any items |

### 4.2 Item Categories
| Category | Examples | Stack Size |
|----------|----------|------------|
| Weapons | Pistol, Rifle, Shotgun | 1 |
| Ammo | 9mm, .45, 12ga, 5.56 | 60/30/20/30 |
| Medical | Bandage, Medkit, Painkillers | 5/3/5 |
| Food | Canned food, Water | 5/5 |
| Throwables | Molotov, Smoke grenade | 3 |
| Crafting | Scrap, Cloth, Chemicals | 20 |

### 4.3 Item Definitions
```
Item: Bandage
- Type: Medical
- Effect: Heal 25 HP over 3 seconds
- Weight: 0.1
- Rarity: Common

Item: Medkit
- Type: Medical
- Effect: Heal 75 HP instantly
- Weight: 0.5
- Rarity: Rare

Item: Pistol (M1911)
- Type: Weapon
- Damage: 25
- Fire Rate: 2/sec
- Magazine: 7
- Ammo Type: .45 ACP
- Range: 30m effective
```

---

## 5. Combat System

### 5.1 Weapon Stats
| Weapon | Damage | RPM | Mag | Range | Accuracy |
|--------|--------|-----|-----|-------|----------|
| M1911 Pistol | 25 | 120 | 7 | 30m | 85% |
| Combat Shotgun | 15x8 | 60 | 6 | 15m | 60% |
| M14 Rifle | 45 | 90 | 20 | 100m | 90% |
| Thompson SMG | 20 | 600 | 30 | 25m | 70% |

### 5.2 Damage Calculation
```
Base Damage × Range Falloff × Hit Zone Multiplier = Final Damage

Hit Zones:
- Head: 2.5x
- Torso: 1.0x
- Limbs: 0.7x

Range Falloff:
- 0-50%: 1.0x
- 50-75%: 0.8x
- 75-100%: 0.5x
- >100%: 0.25x
```

### 5.3 Stealth Mechanics
| Detection Factor | Impact |
|------------------|--------|
| Player crouching | -50% detection range |
| Player sprinting | +100% detection range |
| Line of sight blocked | No visual detection |
| Gunfire | Alerts enemies within 50m |
| Suppressed weapon | Alerts enemies within 15m |

---

## 6. Enemy AI

### 6.1 Enemy Types
| Type | Health | Damage | Behavior |
|------|--------|--------|----------|
| Scavenger | 75 | 15 | Flees when hurt, prefers looting |
| Raider | 100 | 20 | Aggressive, uses cover |
| Veteran | 150 | 30 | Tactical, flanks, uses grenades |
| Boss | 300 | 40 | Unique per level |

### 6.2 AI States (Finite State Machine)
```
IDLE ←→ PATROL
  ↓       ↓
  └──→ INVESTIGATE
           ↓
      ┌────┴────┐
      ↓         ↓
   CHASE    TAKE_COVER
      ↓         ↓
   ATTACK ←────┘
      ↓
 FLEE (if health < 20%)
      ↓
    DEAD
```

### 6.3 AI Perception
| Sense | Range | Cooldown |
|-------|-------|----------|
| Sight (cone) | 30m, 60° FOV | 0.2s |
| Hearing | 20m (footsteps), 50m (gunfire) | 0.5s |
| Memory | Remembers last seen position | 10s |

### 6.4 Group Behavior
- Enemies communicate player position
- Flanking maneuvers when 2+ enemies
- One enemy suppresses, others advance
- Retreat and regroup if outnumbered

---

## 7. World Design

### 7.1 Level Progression
| Level | Location | Theme | Difficulty |
|-------|----------|-------|------------|
| 1 | Manhattan, NYC | Urban ruins | Tutorial |
| 2 | Brooklyn | Industrial | Easy |
| 3 | New Jersey | Suburbs | Normal |
| 4 | Philadelphia | Downtown | Normal |
| 5 | Baltimore | Harbor | Hard |
| 6 | Washington D.C. | Government ruins | Hard |
| 7+ | (Expansion) | TBD | Expert |

### 7.2 Level Structure
Each level contains:
- **Entry Point**: Where player spawns
- **Exit Point**: Goal to reach
- **Safe Zones**: Optional rest areas (save points)
- **High-Value Areas**: Good loot, heavy enemy presence
- **Shortcuts**: Risk/reward alternate paths

### 7.3 Scavenge Point Types
| Type | Contents | Respawn |
|------|----------|---------|
| Container (small) | 1-2 common items | Never |
| Container (large) | 2-4 items, chance of rare | Never |
| Body | Ammo, sometimes weapon | Never |
| Supply Cache | Guaranteed rare item | Never |

### 7.4 Environmental Hazards
- Collapsed structures (falling debris)
- Radiation zones (constant damage)
- Tripwires (alerts enemies)
- Gas leaks (explosive if shot)

---

## 8. Visual Style

### 8.1 Art Direction
- **Era**: 1960s American aesthetic
- **Palette**: Muted colors, rust, decay, dust
- **Lighting**: Dramatic shadows, volumetric fog
- **Weather**: Overcast, occasional rain, dust storms

### 8.2 Character Design
- **Player**: Anonymous everyman, customizable outfit
- **Enemies**: Ragged clothing, improvised armor, distinct silhouettes
- **NPCs**: (Future) Traders, quest givers

### 8.3 Environment Design
- Period-accurate architecture (1960s buildings)
- Destruction and decay layered on top
- Readable landmarks for navigation
- Clear visual language for interactables

---

## 9. Audio Design

### 9.1 Sound Categories
| Category | Examples |
|----------|----------|
| Ambient | Wind, distant explosions, creaking |
| Player | Footsteps, breathing, inventory |
| Weapons | Gunfire, reload, impact |
| Enemies | Footsteps, dialogue, alerts |
| UI | Menu clicks, notifications |
| Music | Dynamic tension system |

### 9.2 Music System
- **Exploration**: Minimal, atmospheric
- **Tension**: Building when enemies nearby
- **Combat**: Intense, percussion-heavy
- **Safe Zone**: Melancholic, period-appropriate

---

## 10. UI/UX

### 10.1 HUD Elements
```
┌─────────────────────────────────────────────┐
│ [Health Bar]                    [Compass]   │
│ [Stamina Bar]                               │
│                                             │
│                                             │
│                   [Crosshair]               │
│                                             │
│                                             │
│ [Quick Slots 1-4]         [Ammo: 30/120]   │
│                          [Weapon Icon]      │
└─────────────────────────────────────────────┘
```

### 10.2 Interaction Prompts
- Context-sensitive (E to Open, E to Pickup)
- Item preview on hover
- Warning indicators (enemy awareness)

### 10.3 Menus
| Menu | Access | Contents |
|------|--------|----------|
| Pause | ESC | Resume, Options, Quit |
| Inventory | TAB | Full inventory management |
| Map | M | Level overview, objectives |
| Options | Pause → Options | Graphics, Audio, Controls |

---

## 11. Technical Requirements

### 11.1 Minimum Specs (Target)
- OS: Windows 10
- CPU: Intel i5-4460 / AMD FX-6300
- RAM: 8 GB
- GPU: GTX 760 / R9 270
- Storage: 10 GB

### 11.2 Recommended Specs
- OS: Windows 11
- CPU: Intel i7-8700 / Ryzen 5 3600
- RAM: 16 GB
- GPU: GTX 1060 / RX 580
- Storage: 10 GB SSD

### 11.3 Performance Targets
| Setting | Target FPS |
|---------|------------|
| Low | 60 FPS @ 1080p |
| Medium | 60 FPS @ 1440p |
| High | 60 FPS @ 4K |

---

## 12. Development Milestones

### Phase 1: Prototype (Current) ✓
- [x] Project setup
- [x] GDExtension architecture
- [x] Basic player movement
- [x] Third-person camera
- [x] Basic AI framework
- [x] Inventory system structure

### Phase 2: Vertical Slice
- [ ] Complete player controller
- [ ] Working weapon system
- [ ] AI combat behavior
- [ ] One complete level
- [ ] Basic UI/HUD
- [ ] **1960s Visual Aesthetic**
  - [ ] WorldEnvironment with period color grading
  - [ ] Volumetric fog and atmospheric lighting
  - [ ] Overcast sky setup (nuclear winter)
  - [ ] Dramatic shadow configuration
- [ ] **Player Character Base**
  - [ ] Player model specification (1960s everyman)
  - [ ] Base body mesh and skeleton
  - [ ] Default outfit (bomber jacket, slacks, work boots)
  - [ ] AnimationTree for locomotion
- [ ] **Level 1 Environment Art**
  - [ ] 1960s NYC prop placement (vehicles, street furniture)
  - [ ] Destruction and decay elements
  - [ ] Ambient dust particles

### Phase 3: Alpha
- [ ] All core systems functional
- [ ] 3 playable levels
- [ ] Save/load system
- [ ] Audio integration
- [ ] Basic polish
- [ ] **Character Art Complete**
  - [ ] Full player clothing system (modular slots)
  - [ ] 1960s clothing variants (civilian, military surplus)
  - [ ] Enemy character models (Scavenger, Raider, Veteran)
  - [ ] All locomotion and combat animations
- [ ] **Environment Art Complete**
  - [ ] All level WorldEnvironment configurations
  - [ ] Weather effects (rain, dust storms)
  - [ ] Interior lighting (practical lights, light shafts)
  - [ ] Period-accurate props for all levels
- [ ] **Audio Ambience System**
  - [ ] Ambient soundscape zones per level
  - [ ] Dynamic music system (exploration/tension/combat)
  - [ ] 3D environmental audio sources
  - [ ] Period-appropriate music tracks

### Phase 4: Beta
- [ ] All planned levels
- [ ] Full UI implementation
- [ ] Balancing pass
- [ ] Performance optimization
- [ ] Bug fixing
- [ ] **Visual Polish**
  - [ ] Character animation polish and blending
  - [ ] Environmental storytelling props
  - [ ] Lighting consistency pass
  - [ ] Audio mix and balance

### Phase 5: Release
- [ ] Final polish
- [ ] Achievements
- [ ] Localization
- [ ] Marketing materials
- [ ] Launch
