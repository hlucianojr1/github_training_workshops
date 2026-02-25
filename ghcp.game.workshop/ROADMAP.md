# Atomic Winter '60: Unified Development Roadmap

## Executive Summary

This roadmap consolidates the **Phase 1 Development Plan** with the **Game Design Document** to create a unified vision for "Atomic Winter '60." The analysis revealed significant gaps between the technical implementation plan and the creative vision. This document provides a complete development roadmap with milestones, tasks, and acceptance criteria.

---

## Gap Analysis Summary

### Features in GDD NOT Covered by Phase 1

| Priority | Feature | Impact |
|----------|---------|--------|
| 🔴 CRITICAL | Car Crawl Stealth System | Core gameplay pillar |
| 🔴 CRITICAL | Geiger Counter / Radiation Scanning | Unique selling point |
| 🔴 CRITICAL | Cold/Temperature Survival | Core survival mechanic |
| 🔴 CRITICAL | Panic Focus Combat Mechanic | Combat differentiator |
| 🟠 HIGH | Ankle Pull Stealth Takedowns | Stealth depth |
| 🟠 HIGH | Bus Ledge Verticality | Level design variety |
| 🟠 HIGH | Campfire/Sanctuary System | Progression hub |
| 🟠 HIGH | The Stalker Boss | Boss encounter |
| 🟡 MEDIUM | Corner Lean Mechanic | Combat polish |
| 🟡 MEDIUM | M3 Grease Gun Weapon | Period-accurate arsenal |
| 🟡 MEDIUM | Faction AI (NYPD, MPs) | World building |
| 🟢 LOW | Times Square Level Layout | Can be Phase 2 |

---

## Unified Development Phases

### Phase Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    ATOMIC WINTER '60 ROADMAP                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PHASE 1: FOUNDATION (Weeks 1-6)                                │
│  ├── Core Systems & Technical Framework                          │
│  └── Milestone: Playable combat prototype                        │
│                                                                  │
│  PHASE 2: STEALTH SYSTEMS (Weeks 7-12)                          │
│  ├── Car Crawl, Ankle Pull, Verticality                         │
│  └── Milestone: Stealth gameplay loop complete                   │
│                                                                  │
│  PHASE 3: SURVIVAL MECHANICS (Weeks 13-18)                      │
│  ├── Radiation, Cold, Geiger Counter, Campfire                  │
│  └── Milestone: Full survival loop integrated                    │
│                                                                  │
│  PHASE 4: CONTENT & POLISH (Weeks 19-24)                        │
│  ├── Art, Audio, Level Population, Boss                         │
│  └── Milestone: Vertical Slice Complete                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## PHASE 1: FOUNDATION (Weeks 1-6)

### Milestone 1.1: Combat System Complete (Week 2)

**Objective**: Fully functional shooting, damage, and weapon handling

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 1.1.1 | Implement recoil system | HIGH | 8 | Camera kick, pattern per weapon |
| 1.1.2 | Add spread mechanics | HIGH | 6 | Increases with fire, decreases at rest |
| 1.1.3 | Create M1911 Pistol data | HIGH | 4 | 7-round mag, 45 damage, 25m range |
| 1.1.4 | Create Remington 870 data | MEDIUM | 4 | 6-shell tube, 80 damage, pump action |
| 1.1.5 | **Create M3 Grease Gun data** | HIGH | 4 | 30-round mag, 30 damage, high recoil |
| 1.1.6 | Implement hit feedback | HIGH | 6 | Hitmarkers, audio cues |
| 1.1.7 | Add muzzle flash VFX | MEDIUM | 4 | Illuminates surroundings in snow |

**Deliverables**:
- [ ] 3 functional weapons (M1911, 870, M3)
- [ ] Recoil and spread systems
- [ ] Hit registration and feedback

---

### Milestone 1.2: Player Animation Integration (Week 4)

**Objective**: Integrate skeletal animations with PlayerController

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 1.2.1 | Implement animation state machine | HIGH | 12 | All states defined and transitioning |
| 1.2.2 | Create idle/walk/run animations | HIGH | 8 | Smooth blending, root motion |
| 1.2.3 | Create crouch animations | HIGH | 6 | Crouch idle, crouch walk |
| 1.2.4 | Create aim/fire animations | HIGH | 8 | Per-weapon variations |
| 1.2.5 | Create reload animations | HIGH | 8 | 3 sec for pistol, 4 sec for shotgun |
| 1.2.6 | **Add "Recoil Struggle" animation** | HIGH | 6 | Shoulders shake, lean forward (GDD spec) |
| 1.2.7 | Death and ragdoll transition | MEDIUM | 6 | Blends to physics |

**Animation List (From GDD + Phase 1)**:
```
Required Animations:
├── idle_stand (60 frames, loop) - subtle breathing
├── walk_forward (30 frames, loop) - 3.5 m/s
├── run_forward (20 frames, loop) - 6.0 m/s
├── crouch_idle (60 frames, loop)
├── crouch_walk (40 frames, loop)
├── aim_pistol (15 frames, blend pose)
├── aim_smg (15 frames, blend pose) - M3 Grease Gun
├── fire_pistol (8 frames)
├── fire_smg (8 frames) - with "recoil struggle"
├── reload_pistol (90 frames, 3 sec)
├── reload_smg (120 frames, 4 sec)
├── melee_swing (20 frames)
└── death_front (45 frames, ragdoll transition)
```

---

### Milestone 1.3: AI Combat Behavior (Week 6)

**Objective**: Enemies that feel threatening and period-appropriate

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 1.3.1 | Implement burst fire behavior | HIGH | 6 | Fire in bursts, not continuous |
| 1.3.2 | Add cover seeking AI | HIGH | 10 | Evaluate and move to cover |
| 1.3.3 | Implement flanking behavior | MEDIUM | 8 | Flank when player suppressed |
| 1.3.4 | Add 1960s voice barks | LOW | 4 | Period-appropriate callouts |
| 1.3.5 | **Create Scavenger enemy type** | HIGH | 6 | 60 HP, melee, flees at 30% |
| 1.3.6 | **Create NYPD enemy type** | HIGH | 6 | 80 HP, pistol, flashlight |
| 1.3.7 | **Create MP enemy type** | HIGH | 6 | 100 HP, rifle, gas mask |

**Enemy Types (From GDD)**:
| Type | Health | Weapon | Behavior | Visual |
|------|--------|--------|----------|--------|
| Scavenger | 60 | Pipe/Knife/Bow | Aggressive melee, flees at 30% | Ragged fur, makeshift mask |
| NYPD (Blue Coat) | 80 | Pistol | Patrol, flashlight search | Winter coat, tattered uniform |
| MP | 100 | Rifle | Suppressive fire, gas mask | M65 jacket, M1 helmet, gas mask |
| Raider | 100 | Pistol/Shotgun | Uses cover, flanks | Military surplus |

---

## PHASE 2: STEALTH SYSTEMS (Weeks 7-12)

### Milestone 2.1: Car Crawl System (Week 8)

**Objective**: Implement the core "Car Crawl" stealth mechanic from GDD

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 2.1.1 | Design crawlspace detection system | HIGH | 8 | Detect valid crawl areas under vehicles |
| 2.1.2 | Implement prone movement state | HIGH | 10 | Player can go prone and crawl |
| 2.1.3 | Create "Low-Profile Peek" animation | HIGH | 6 | Head lifts above tire rim to scan |
| 2.1.4 | Add prone enter/exit animations | HIGH | 6 | Smooth transitions |
| 2.1.5 | Configure vehicle collision for crawl | HIGH | 4 | Proper clearance detection |
| 2.1.6 | Add crawl sound (noise system) | MEDIUM | 4 | Oil puddles increase noise |
| 2.1.7 | AI detection while prone | HIGH | 8 | Reduced detection radius |

**Technical Spec**:
```cpp
// Car Crawl System
enum class ProneState {
    STANDING,
    ENTERING_PRONE,
    PRONE_IDLE,
    PRONE_CRAWLING,
    PRONE_PEEKING,
    EXITING_PRONE
};

struct CrawlSpace {
    Vector3 entry_point;
    Vector3 exit_point;
    float clearance_height; // Must be < 0.6m
    bool is_under_vehicle;
    float noise_modifier; // Oil puddles = 1.5x
};
```

---

### Milestone 2.2: Stealth Takedowns (Week 10)

**Objective**: Implement "Ankle Pull" and other stealth takedowns

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 2.2.1 | Design takedown detection system | HIGH | 6 | Detect valid takedown positions |
| 2.2.2 | **Implement "Ankle Pull" mechanic** | HIGH | 10 | Grab ankle from prone under car |
| 2.2.3 | Create ankle pull animation | HIGH | 8 | Player pulls, enemy falls |
| 2.2.4 | Create standing choke takedown | MEDIUM | 6 | From behind, standing |
| 2.2.5 | Add takedown prompt UI | MEDIUM | 4 | Context-sensitive prompt |
| 2.2.6 | Enemy awareness during takedown | HIGH | 6 | Other enemies can detect |

**Ankle Pull Flow (From GDD)**:
```
1. Player is prone under vehicle
2. Enemy patrol walks past
3. Prompt appears: [E] Ankle Pull
4. Player grabs ankle, pulls enemy down
5. Silent kill or drag under car
6. Other enemies unaware unless they see
```

---

### Milestone 2.3: Verticality System (Week 12)

**Objective**: Implement "Bus Ledge" traversal and high-ground mechanics

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 2.3.1 | Design ledge detection system | HIGH | 8 | Identify climbable surfaces |
| 2.3.2 | **Implement "Bus Ledge" climbing** | HIGH | 10 | Climb onto bus roofs |
| 2.3.3 | Create "Belly Slide" animation | HIGH | 6 | Flat slide on bus roof |
| 2.3.4 | Add ledge grab mechanic | MEDIUM | 8 | Hanging, pull-up |
| 2.3.5 | Implement high-ground AI awareness | HIGH | 6 | AI doesn't detect on rooftops |
| 2.3.6 | Add searchlight evasion | MEDIUM | 6 | Stay in light >2 sec = detected |

---

### Milestone 2.4: Corner Lean & Panic Focus (Week 12)

**Objective**: Implement combat transition mechanics from GDD

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 2.4.1 | **Implement "Corner Lean" system** | HIGH | 10 | Peek and fire from cover |
| 2.4.2 | Create High/Low swap animations | HIGH | 6 | Standing lean, kneeling lean |
| 2.4.3 | **Implement "Panic Focus" meter** | HIGH | 12 | Fills when detected, slows time |
| 2.4.4 | Add stealth-to-combat state change | HIGH | 8 | HUD glitch, audio shift |
| 2.4.5 | Create Panic Focus UI elements | HIGH | 6 | Visual filter, highlighted threats |
| 2.4.6 | Add heartbeat audio layer | MEDIUM | 4 | 120 BPM rhythmic thumping |

**Panic Focus System (From GDD)**:
```cpp
class PanicFocus {
    float meter = 0.0f; // 0-100
    bool is_active = false;
    
    // Activation triggers
    void on_enemy_detection();  // +50 meter
    void on_gunshot_nearby();   // +30 meter
    void on_player_hit();       // +20 meter
    
    // Effects when meter > 80
    void activate() {
        Engine::set_time_scale(0.5); // Slow-mo
        apply_visual_filter();       // Desaturation
        highlight_enemy_silhouettes();
    }
};
```

---

## PHASE 3: SURVIVAL MECHANICS (Weeks 13-18)

### Milestone 3.1: Radiation System (Week 14)

**Objective**: Implement Geiger counter and radiation hazards

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 3.1.1 | **Create Radiation meter HUD element** | HIGH | 6 | 0-100% display |
| 3.1.2 | **Implement Geiger counter tool** | HIGH | 12 | Arm-mounted, scans items |
| 3.1.3 | Add radiation zone volumes | HIGH | 8 | Hot zones damage over time |
| 3.1.4 | Create "Black Snow" hazard | MEDIUM | 6 | Falling radiation particles |
| 3.1.5 | Implement item radiation levels | HIGH | 8 | Clean vs irradiated loot |
| 3.1.6 | Add Iodine tablets consumable | HIGH | 4 | Reduces radiation exposure |
| 3.1.7 | Geiger counter audio (clicks) | HIGH | 4 | Frequency = radiation level |

**Geiger Counter Integration (From GDD)**:
```cpp
class GeigerCounter {
    float scan_range = 2.0f;
    
    enum class ItemRadiation {
        PRISTINE,    // Safe, high value
        LOW,         // Usable, minor risk
        MODERATE,    // Risk vs reward
        HIGH,        // Dangerous
        LETHAL       // Avoid
    };
    
    ItemRadiation scan_item(Item* item);
    void update_audio(float radiation_level);
};
```

---

### Milestone 3.2: Temperature System (Week 16)

**Objective**: Implement Cold meter and nuclear winter survival

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 3.2.1 | **Create Cold/Temperature meter** | HIGH | 6 | Decreases in blizzard |
| 3.2.2 | Add temperature zones | HIGH | 8 | Outdoor = cold, shelter = warm |
| 3.2.3 | Implement hypothermia effects | HIGH | 6 | Screen frost, slow movement |
| 3.2.4 | Create warming mechanics | HIGH | 4 | Fire barrels, campfires |
| 3.2.5 | Add clothing warmth values | MEDIUM | 4 | Gear affects cold resistance |
| 3.2.6 | Snow storm VFX | MEDIUM | 8 | Heavy snow, wind |

---

### Milestone 3.3: Campfire Sanctuary System (Week 18)

**Objective**: Implement the "Sanctuary" progression hub

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 3.3.1 | **Design Sanctuary system** | HIGH | 8 | Safe zone, upgrade hub |
| 3.3.2 | Implement campfire interaction | HIGH | 6 | Warmth restoration |
| 3.3.3 | Add decontamination mechanic | HIGH | 6 | Remove radiation at fire |
| 3.3.4 | Create Sanctuary save point | HIGH | 4 | Auto-save at campfire |
| 3.3.5 | Implement Scanner upgrade system | HIGH | 10 | Upgrade Geiger counter |
| 3.3.6 | Add "Menu Mode" HUD state | MEDIUM | 6 | Inventory/upgrade interface |
| 3.3.7 | Create Sanctuary ambience | LOW | 4 | Crackling fire, safe music |

**Sanctuary Features (From GDD)**:
```
The Campfire Sanctuary provides:
├── Warmth restoration (Cold meter refill)
├── Decontamination (Radiation reduction)
├── Save point
├── Item repair/crafting
├── Scanner upgrades
└── Story exposition (found documents)
```

---

### Milestone 3.4: Complete Loot System (Week 18)

**Objective**: Implement all 10 loot items from GDD

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 3.4.1 | Civil Defense Medkit | HIGH | 2 | Full health restore |
| 3.4.2 | Canned Peaches | HIGH | 2 | Hunger restoration |
| 3.4.3 | **Iodine Tablets** | HIGH | 2 | -20% radiation |
| 3.4.4 | Water Flask | HIGH | 2 | Stamina boost |
| 3.4.5 | Hershey's Bar | MEDIUM | 2 | Quick energy |
| 3.4.6 | Tire Iron | HIGH | 3 | Melee weapon + tool |
| 3.4.7 | **Geiger Counter (upgrade)** | HIGH | 4 | Scanner enhancement |
| 3.4.8 | Scrap Metal | LOW | 2 | Trade junk |
| 3.4.9 | Empty Fire Extinguisher | MEDIUM | 3 | Distraction tool |
| 3.4.10 | Ammunition (.38/.45) | HIGH | 2 | Weapon ammo |

---

## PHASE 4: CONTENT & POLISH (Weeks 19-24)

### Milestone 4.1: Times Square Level (Week 20)

**Objective**: Build the "Broadway Push" vertical slice level

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 4.1.1 | Grand Central subway entrance | HIGH | 12 | Starting area |
| 4.1.2 | 42nd Street "Wind Tunnel" | HIGH | 10 | Black Snow hazard zone |
| 4.1.3 | Frozen Transit Bus sanctuary | HIGH | 8 | Campfire location |
| 4.1.4 | Times Square "Bowtie" blockade | HIGH | 16 | Combat arena |
| 4.1.5 | Signal Tower destination | HIGH | 8 | Level exit |
| 4.1.6 | Crawlspace network | HIGH | 12 | Under vehicles |
| 4.1.7 | Bus Ledge routes | HIGH | 8 | Vertical paths |

**Zone Layout (From GDD)**:
```
Zone 1: The Awakening (00:00 - 02:00)
├── Grand Central subway mouth
├── Blizzard introduction
└── HUD tutorial

Zone 2: First Contact (02:00 - 05:00)
├── Scavenger encounter
├── '64 Impala crawlspace
└── Stealth tutorial

Zone 3: The Wind Tunnel (05:00 - 08:00)
├── 42nd St crosswind
├── Black Snow hazard
└── Squeeze Gap tutorial

Zone 4: The Sanctuary (08:00 - 11:00)
├── Frozen Transit Bus
├── Campfire mechanics
└── M3 Grease Gun acquisition

Zone 5: The Escalation (11:00 - 13:00)
├── Times Square approach
├── MP patrol witness
└── Ankle Pull opportunity

Zone 6: Combat Peak (13:00 - 15:00)
├── Blockade firefight
├── Panic Focus engagement
└── Signal Tower escape
```

---

### Milestone 4.2: The Stalker Boss (Week 22)

**Objective**: Implement the boss encounter from GDD

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 4.2.1 | **Design Stalker AI behavior** | HIGH | 16 | Hunts through crawlspaces |
| 4.2.2 | Create Stalker character model | HIGH | 12 | Lead-lined diving suit |
| 4.2.3 | Implement radiation aura | HIGH | 6 | +80% radiation when near |
| 4.2.4 | Add sound-based hunting | HIGH | 8 | Hears movement on metal |
| 4.2.5 | Create boss arena | HIGH | 10 | Multiple escape routes |
| 4.2.6 | Add boss music/audio | MEDIUM | 6 | Tension escalation |

**Stalker Behavior Tree (From GDD)**:
```
The Stalker:
├── Patrol Mode
│   ├── Slow movement through zone
│   └── Radiation aura glows green
├── Alert Mode (on player noise)
│   ├── Move toward sound
│   └── Check crawlspaces
├── Hunt Mode (player spotted)
│   ├── Relentless pursuit
│   └── Can follow through tight spaces
└── Attack
    ├── Grab attack (one-hit near kill)
    └── Radiation burst (area damage)
```

---

### Milestone 4.3: Art & Audio Polish (Week 24)

**Objective**: Complete all art assets and audio implementation

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 4.3.1 | Player character model | HIGH | 20 | 15K triangles, PBR |
| 4.3.2 | NYPD/MP/Scavenger models | HIGH | 24 | 8-10K each |
| 4.3.3 | 1960s vehicles (6 types) | HIGH | 30 | Checker Taxi, Impala, etc. |
| 4.3.4 | Times Square environment | HIGH | 40 | Buildings, signs, debris |
| 4.3.5 | Weapon audio (M1911, 870, M3) | HIGH | 8 | Fire, reload, empty |
| 4.3.6 | Ambient soundscape | HIGH | 12 | Wind, Geiger, debris |
| 4.3.7 | Jazz-noir music tracks | MEDIUM | 16 | Adaptive layers |
| 4.3.8 | 1960s post-process filter | HIGH | 8 | Film grain, warm tint |

---

### Milestone 4.4: QA & Release (Week 24)

| Task ID | Task | Priority | Est. Hours | Acceptance Criteria |
|---------|------|----------|------------|---------------------|
| 4.4.1 | Full playthrough testing | HIGH | 16 | Complete 15-min slice |
| 4.4.2 | Performance optimization | HIGH | 12 | 60 FPS target |
| 4.4.3 | Bug fixing (Critical/High) | HIGH | 20 | Zero blockers |
| 4.4.4 | Save system verification | HIGH | 8 | Reliable save/load |
| 4.4.5 | Build packaging | MEDIUM | 4 | Windows/Mac/Linux |

---

## Success Metrics

### Vertical Slice Completion Criteria

| Metric | Target | Minimum Acceptable |
|--------|--------|-------------------|
| Playtime | 15 minutes | 12 minutes |
| Frame Rate | 60 FPS | 30 FPS |
| Load Time | < 5 sec | < 10 sec |
| Crash Rate | 0% | < 1% |
| All GDD Mechanics | 100% | 80% |

### Key Gameplay Moments Verified

- [ ] Player exits subway into blizzard (HUD tutorial)
- [ ] Player uses Car Crawl to bypass Scavengers
- [ ] Player scans item with Geiger counter
- [ ] Player performs Ankle Pull takedown
- [ ] Player reaches Campfire Sanctuary
- [ ] Player acquires M3 Grease Gun
- [ ] Player uses Bus Ledge to bypass patrol
- [ ] Panic Focus activates during combat
- [ ] Player survives Combat Peak firefight
- [ ] Player reaches Signal Tower

---

## Risk Register

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Stealth AI complexity | HIGH | HIGH | Prototype early, iterate |
| Panic Focus balance | MEDIUM | HIGH | Playtest extensively |
| Art pipeline bottleneck | HIGH | MEDIUM | Use AI-generated concepts |
| Stalker boss too hard/easy | MEDIUM | MEDIUM | Multiple difficulty tuning |
| Scope creep | HIGH | HIGH | Lock features at Week 12 |

---

## Appendix: Weekly Gantt Overview

```
Week  | 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
------+------------------------------------------------------------------------
Combat|████████
Anim  |      ████████
AI    |            ████████
Crawl |                  ████████
Stealth               |        ████████
Vertical                       |    ████████
Panic |                              ████████
Rad   |                                    ████████
Cold  |                                          ████████
Camp  |                                                ████████
Level |                                                      ████████████
Boss  |                                                            ████████
Art   |                                                                  ████
QA    |                                                                  ████
```

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-27 | Development Team | Initial unified roadmap |

---

**This roadmap ensures the Phase 1 technical foundation supports the complete vision outlined in the Game Design Document, delivering a cohesive 15-minute vertical slice of "Atomic Winter '60."**
