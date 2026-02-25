# Urban Survivor - Production Plan

**Document Version**: 1.1  
**Created**: December 1, 2025  
**Updated**: February 10, 2026  
**Project**: Urban Survivor (Third-Person Survival Shooter)  
**Engine**: Godot 4.3+ with C++ GDExtension

---

## Executive Summary

This document outlines the complete production plan to deliver **Urban Survivor** as a production-ready game. The plan spans **7 milestones** over an estimated **12-month timeline**, covering all disciplines: Engineering, Art, Design, Audio, QA, and Marketing.

### Current Status
| Metric | Value |
|--------|-------|
| Phase | **1.5: Hardening** (0% complete) |
| Milestone 1 | ✅ 100% Complete |
| C++ Classes | 14 registered, structures complete |
| Levels | 1 populated (of 6 planned) |
| Assets | ~40% (vehicles, characters, props imported) |
| Playable | Full combat loop — needs hardening |

---

## Resource Allocation Key

| Assignee Code | Description |
|---------------|-------------|
| `🤖 AI` | AI-assisted development (Copilot, asset generation) |
| `👨‍💻 ENG` | Engineering team (C++, GDScript) |
| `🎨 ART` | Art team (3D modeling, textures, VFX) |
| `🎵 AUDIO` | Audio team (SFX, music, ambience) |
| `🎮 DESIGN` | Game design team (levels, balance) |
| `🧪 QA` | Quality assurance team |
| `📣 MARKETING` | Marketing and community |
| `📐 ARCH` | Architecture lead |

---

## Milestone 1: Vertical Slice (Weeks 1-6) ✅ COMPLETE

**Goal**: One fully playable level demonstrating all core mechanics.

### Epic 1.1: Combat System Completion
**Owner**: `👨‍💻 ENG` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 1.1.1 | Implement weapon raycast firing | `👨‍💻 ENG` | - Weapon fires on mouse click<br>- Raycast hits registered on collision layers<br>- Debug line shows trajectory |
| 1.1.2 | Implement hit detection and damage | `👨‍💻 ENG` | - DamageSystem.apply_damage() called on hit<br>- Hit zone multipliers work (HEAD 2.5x, TORSO 1.0x, LIMBS 0.7x)<br>- Damage numbers emit signal |
| 1.1.3 | Create weapon reload system | `👨‍💻 ENG` | - R key triggers reload<br>- Animation state blocks firing<br>- Ammo transfers from inventory to magazine |
| 1.1.4 | Implement recoil and spread | `👨‍💻 ENG` | - Camera kick on fire<br>- Spread increases during sustained fire<br>- Spread resets after pause |
| 1.1.5 | Create M1911 Pistol data | `🤖 AI` + `🎮 DESIGN` | - Weapon stats match SPEC.md<br>- 7-round magazine, 45 damage<br>- Effective range 25m |

### Epic 1.2: Player Assembly
**Owner**: `👨‍💻 ENG` | **Duration**: 1 week

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 1.2.1 | Create player.tscn prefab | `👨‍💻 ENG` | - PlayerController as root<br>- ThirdPersonCamera attached<br>- Inventory node attached<br>- SurvivalStats node attached |
| 1.2.2 | Implement player death flow | `👨‍💻 ENG` | - Health <= 0 triggers death state<br>- Input disabled on death<br>- Death animation plays<br>- Game Over signal emitted |
| 1.2.3 | Add melee attack | `👨‍💻 ENG` | - V key triggers melee<br>- Short-range sphere cast<br>- 30 damage, 1s cooldown |
| 1.2.4 | Implement interaction system | `👨‍💻 ENG` | - E key interacts<br>- Raycast 2m forward<br>- Calls interact() on target |

### Epic 1.3: AI Combat Behavior
**Owner**: `👨‍💻 ENG` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 1.3.1 | Implement AI attack state | `👨‍💻 ENG` | - Enemy fires weapon at player<br>- Uses same weapon system as player<br>- Attack cooldown implemented |
| 1.3.2 | Add cover-seeking behavior | `👨‍💻 ENG` + `🤖 AI` | - AI queries NavigationServer for cover points<br>- Moves to cover when health < 50%<br>- Peeks and fires from cover |
| 1.3.3 | Implement enemy death | `👨‍💻 ENG` | - Health <= 0 triggers DEAD state<br>- Ragdoll or death animation<br>- Drops loot on death |
| 1.3.4 | Create Scavenger enemy variant | `🎮 DESIGN` | - 50 HP, M1911 pistol<br>- Low aggression, flees at 25% HP<br>- Patrols waypoints |
| 1.3.5 | Create Raider enemy variant | `🎮 DESIGN` | - 80 HP, shotgun<br>- Aggressive, rushes player<br>- Calls for backup |

### Epic 1.4: Basic HUD
**Owner**: `👨‍💻 ENG` | **Duration**: 1 week

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 1.4.1 | Implement health bar | `👨‍💻 ENG` | - Displays current/max health<br>- Updates on damage signal<br>- Red flash on damage |
| 1.4.2 | Implement stamina bar | `👨‍💻 ENG` | - Depletes during sprint<br>- Regenerates when not sprinting<br>- Visual warning at 20% |
| 1.4.3 | Implement ammo counter | `👨‍💻 ENG` | - Shows current mag / reserve<br>- Updates on fire/reload<br>- Flashes when empty |
| 1.4.4 | Create crosshair | `👨‍💻 ENG` | - Center screen reticle<br>- Expands during movement/fire<br>- Changes color on enemy hover |
| 1.4.5 | Add interaction prompt | `👨‍💻 ENG` | - "Press E to..." appears near interactables<br>- Shows item name<br>- Fades based on distance |

### Epic 1.5: Level 1 Population
**Owner**: `🎮 DESIGN` | **Duration**: 1 week

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 1.5.1 | Place 5 enemies in Zone 2 | `🎮 DESIGN` | - 3 Scavengers, 2 Raiders<br>- Patrol routes defined<br>- MG nest manned by Raider |
| 1.5.2 | Place 3 enemies in Zone 3 | `🎮 DESIGN` | - 2 Scavengers, 1 Raider<br>- Ambush positions near storefronts |
| 1.5.3 | Add 10 scavenge points | `🎮 DESIGN` | - 5 in Zone 1 (tutorial loot)<br>- 3 in Zone 2 (ammo caches)<br>- 2 in Zone 3 (medical) |
| 1.5.4 | Implement level exit trigger | `👨‍💻 ENG` | - Area3D at subway entrance<br>- Triggers level_completed signal<br>- Loads victory screen |
| 1.5.5 | Add player spawn + link player scene | `🎮 DESIGN` | - Player spawns at Zone 1 start<br>- Camera initialized correctly |

---

## Milestone 1.5: Hardening (Weeks 7-8)

**Goal**: Fix SPEC mismatches, wire disconnected cross-system signals, and verify the full gameplay loop end-to-end.

**Workflow Guide**: See `docs/M1_5_HARDENING_WORKFLOW.md` for detailed agentic execution workflow with prompt files.

**Context**: Code review of all M1 systems revealed 12 issues ranging from spec drift (wrong falloff curve, wrong magazine capacity) to completely disconnected subsystems (sprint never drains stamina, enemy deaths never notify LevelManager). This milestone exists to harden M1 before building on top of it in M2+.

### Epic 1.6: Combat Math Alignment
**Owner**: `👨‍💻 ENG` | **Duration**: 0.5 weeks

| ID | Task | Assignee | Est | Prompt File | Acceptance Criteria |
|----|------|----------|-----|-------------|---------------------|
| 1.6.1 | Fix range falloff to SPEC tiered curve | `👨‍💻 ENG` | 2h | `hardening-fix-range-falloff` | - `apply_distance_falloff()` implements 4-tier curve per SPEC S5.2<br>- Replaces linear falloff |
| 1.6.2 | Fix M1911 magazine capacity | `👨‍💻 ENG` | 0.5h | `hardening-fix-mag-capacity` | - Default `mag_capacity` changed from 8 to 7 per SPEC S4.3 |
| 1.6.3 | Enrich `damage_dealt` signal with hit zone | `👨‍💻 ENG` | 1.5h | `hardening-enrich-damage-signal` | - Signal adds `hit_zone` (int) parameter<br>- Both emit sites updated |
| 1.6.4 | Implement fall damage | `👨‍💻 ENG` | 2h | `hardening-implement-fall-damage` | - Falls > 5m deal `(distance - 5) x 10` damage<br>- Falls >= 15m are lethal<br>- Uses `DamageType::FALL` |

### Epic 1.7: Player System Wiring
**Owner**: `👨‍💻 ENG` | **Duration**: 1 week

| ID | Task | Assignee | Est | Prompt File | Acceptance Criteria |
|----|------|----------|-----|-------------|---------------------|
| 1.7.1 | Wire sprint state to SurvivalStats | `👨‍💻 ENG` | 2h | `hardening-wire-sprint-stamina` | - `handle_movement()` calls `set_sprinting()` each frame<br>- `can_sprint` reads from `SurvivalStats`<br>- Jump costs 5 stamina |
| 1.7.2 | Implement crouch collision shape | `👨‍💻 ENG` | 3h | `hardening-crouch-collision` | - Capsule height adjusts on crouch<br>- Ceiling raycast prevents uncrouching<br>- Camera pivot Y adjusts |
| 1.7.3 | Fix premature `weapon_reloaded` signal | `👨‍💻 ENG` | 1h | `hardening-fix-reload-signal` | - Signal fires only after `Weapon::reload_finished`<br>- Not on R key press |
| 1.7.4 | Fix interaction collision mask | `👨‍💻 ENG` | 1h | `hardening-fix-interaction-mask` | - New `interaction_collision_mask` editor property<br>- Replaces `0xFFFFFFFF` |

### Epic 1.8: AI System Hardening
**Owner**: `👨‍💻 ENG` | **Duration**: 0.5 weeks

| ID | Task | Assignee | Est | Prompt File | Acceptance Criteria |
|----|------|----------|-----|-------------|---------------------|
| 1.8.1 | Add AI weapon reload | `👨‍💻 ENG` | 1h | `hardening-ai-weapon-reload` | - `perform_attack()` triggers `start_reload()` when ammo empty<br>- AI skips one attack cycle during reload |
| 1.8.2 | Wire enemy death to LevelManager | `👨‍💻 ENG` | 2h | `hardening-wire-enemy-levelmanager` | - `auto_register_enemies()` connects `enemy_died` to `enemy_defeated`<br>- New `all_enemies_defeated` signal |

### Epic 1.9: Code Quality
**Owner**: `📐 ARCH` | **Duration**: 0.5 weeks

| ID | Task | Assignee | Est | Prompt File | Acceptance Criteria |
|----|------|----------|-----|-------------|---------------------|
| 1.9.1 | Gate debug logging behind build flag | `📐 ARCH` | 2h | `hardening-gate-debug-logging` | - `src/core/debug_macros.hpp` created<br>- Verbose prints use `US_LOG_VERBOSE()`<br>- Release builds have minimal output |
| 1.9.2 | End-to-end smoke test | `🧪 QA` | 3h | `hardening-smoke-test` | - 18-point checklist verified<br>- Results documented in MEMORY.md |

### Milestone 1.5 Summary

| Epic | Focus | Est Hours |
|------|-------|-----------|
| 1.6 | Combat math alignment | 6h |
| 1.7 | Player system wiring | 7h |
| 1.8 | AI system hardening | 3h |
| 1.9 | Code quality | 5h |
| **Total** | | **24h** |

### Milestone 1.5 Execution Phases

```
Phase 1 (Quick Fixes)  : T-1.6.2, T-1.6.3, T-1.7.3           (~3h)  --> BUILD
Phase 2 (System Wiring): T-1.6.1, T-1.7.1, T-1.7.4, T-1.8.2  (~7h)  --> BUILD
Phase 3 (New Features) : T-1.6.4, T-1.7.2                      (~5h)  --> BUILD
Phase 4 (Cleanup+Test) : T-1.8.1, T-1.9.1, T-1.9.2            (~5h)  --> BUILD + SMOKE TEST
```

### Milestone 1.5 Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Crouch ceiling check adds per-frame physics queries | Medium | Low | Only raycast when uncrouch is requested, not every frame |
| AI weapon integration changes attack timing balance | High | Medium | Keep direct-damage as fallback; A/B test with weapon system |
| Signal signature change breaks GDScript subscribers | Low | Low | Godot ignores extra params - verify hud_controller.gd |
| Fall damage false positives on slopes/stairs | Medium | Medium | Only trigger on was_in_air to is_on_floor() transition |
| Magazine change (8 to 7) affects pacing | Low | Low | Easily revertible; document decision in MEMORY.md |

---

## Milestone 2: Art Pipeline (Weeks 9-14)

**Goal**: Replace all placeholders with production assets.

### Epic 2.1: Vehicle Assets
**Owner**: `🎨 ART` | **Duration**: 3 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 2.1.1 | Model Checker Marathon Taxi | `🎨 ART` | - < 3,000 tris<br>- 1024x1024 PBR textures<br>- 3 damage LODs (clean, damaged, wrecked) |
| 2.1.2 | Model 1957 Chevy Bel Air | `🎨 ART` | - < 3,000 tris<br>- Wrecked variant only<br>- Rusted metal materials |
| 2.1.3 | Model GMC City Bus | `🎨 ART` | - < 5,000 tris (hero prop)<br>- 2048x2048 textures<br>- Interior visible through windows |
| 2.1.4 | Model M48 Patton Tank | `🎨 ART` | - < 6,000 tris (hero prop)<br>- Battle-damaged variant<br>- Destroyed turret |
| 2.1.5 | Create vehicle material library | `🎨 ART` + `🤖 AI` | - Rusted metal shader<br>- Broken glass material<br>- Faded paint variants |
| 2.1.6 | Import and test vehicles in Godot | `👨‍💻 ENG` | - Collision shapes generated<br>- Cover points tagged<br>- LOD system working |

### Epic 2.2: Architecture Assets
**Owner**: `🎨 ART` | **Duration**: 4 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 2.2.1 | Model modular apartment building | `🎨 ART` | - 6-story, < 8,000 tris per section<br>- Modular facades (window, fire escape, brick variants)<br>- 2048x2048 atlas |
| 2.2.2 | Model Loew's Theatre facade | `🎨 ART` | - Hero asset, < 10,000 tris<br>- 1930s ornate details<br>- Barricaded entrance variant |
| 2.2.3 | Model Woolworth's storefront | `🎨 ART` | - < 4,000 tris<br>- Looted interior (shelves, debris)<br>- Broken signage |
| 2.2.4 | Model Rexall Drugs storefront | `🎨 ART` | - < 4,000 tris<br>- Neon sign (emissive material)<br>- Glass display windows |
| 2.2.5 | Model Chrome Diner | `🎨 ART` | - < 5,000 tris<br>- 1950s chrome and glass aesthetic<br>- Counter, stools visible |
| 2.2.6 | Create building trim sheet | `🎨 ART` | - 2048x2048 trim texture<br>- Brick, concrete, window frames<br>- Weathered variants |

### Epic 2.3: Props and Street Furniture
**Owner**: `🎨 ART` + `🤖 AI` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 2.3.1 | Model street furniture kit | `🎨 ART` | - Lamppost (500 tris), trash can (300 tris)<br>- Fire alarm box (200 tris)<br>- Mailbox (400 tris) |
| 2.3.2 | Model phone booth | `🎨 ART` | - < 800 tris<br>- Glass panels (shatterable)<br>- Superman style full enclosure |
| 2.3.3 | Model newsstand | `🎨 ART` | - < 1,500 tris<br>- Magazines, newspapers decals<br>- Destructible |
| 2.3.4 | Generate debris assets | `🤖 AI` + `🎨 ART` | - Suitcases, papers, glass shards<br>- < 500 tris each<br>- Randomizable scatter system |
| 2.3.5 | Model military fortifications | `🎨 ART` | - Sandbags (modular, 500 tris)<br>- Barbed wire (300 tris)<br>- Jersey barriers (200 tris) |

### Epic 2.4: Character Assets
**Owner**: `🎨 ART` | **Duration**: 3 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 2.4.1 | Model player character | `🎨 ART` | - < 8,000 tris<br>- 1960s civilian clothing<br>- Rigged for Godot skeleton |
| 2.4.2 | Create player animations | `🎨 ART` | - Idle, walk, run, crouch, jump<br>- Aim, fire, reload (pistol, rifle, shotgun)<br>- Death, melee |
| 2.4.3 | Model Scavenger enemy | `🎨 ART` | - < 5,000 tris<br>- Ragged civilian clothes<br>- 3 head/body variants |
| 2.4.4 | Model Raider enemy | `🎨 ART` | - < 5,000 tris<br>- Military surplus gear<br>- Armored variant |
| 2.4.5 | Create enemy animations | `🎨 ART` | - Idle, patrol, run, crouch<br>- Fire, reload, take cover<br>- Death (3 variants) |

### Epic 2.5: Weapon Assets
**Owner**: `🎨 ART` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 2.5.1 | Model M1911 Pistol | `🎨 ART` | - < 2,000 tris<br>- First and third person variants<br>- Reload animation |
| 2.5.2 | Model Remington 870 Shotgun | `🎨 ART` | - < 2,500 tris<br>- Pump action animation<br>- Shell ejection |
| 2.5.3 | Model M14 Rifle | `🎨 ART` | - < 3,000 tris<br>- Semi-auto fire animation<br>- Magazine swap |
| 2.5.4 | Model Thompson SMG | `🎨 ART` | - < 3,000 tris<br>- Drum magazine<br>- Full-auto muzzle flash |
| 2.5.5 | Create weapon VFX | `🎨 ART` | - Muzzle flash (GPU particles)<br>- Shell casings<br>- Impact sparks, blood splatter |

---

## Milestone 3: Audio Integration (Weeks 12-16)

**Goal**: Full audio landscape for immersive gameplay.

### Epic 3.1: Weapon and Combat Audio
**Owner**: `🎵 AUDIO` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 3.1.1 | Record/source weapon fire SFX | `🎵 AUDIO` | - Unique sound per weapon type<br>- Near and distant variants<br>- Interior/exterior reverb |
| 3.1.2 | Create reload SFX | `🎵 AUDIO` | - Magazine insert/remove<br>- Slide/bolt action<br>- Shotgun pump |
| 3.1.3 | Create impact SFX | `🎵 AUDIO` | - Metal, concrete, flesh variants<br>- Randomized pitch/selection<br>- 3D positional audio |
| 3.1.4 | Implement audio manager | `👨‍💻 ENG` | - Pool audio players<br>- Priority system<br>- Distance-based culling |

### Epic 3.2: Ambient Audio
**Owner**: `🎵 AUDIO` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 3.2.1 | Create urban canyon wind loop | `🎵 AUDIO` | - 2-minute seamless loop<br>- Dynamic intensity<br>- Stereo width |
| 3.2.2 | Create distant city sounds | `🎵 AUDIO` | - Distant gunshots (random triggers)<br>- Metal creaking (bridge)<br>- Dogs barking |
| 3.2.3 | Create neon sign buzz | `🎵 AUDIO` | - Electrical hum loop<br>- Flicker correlation<br>- 3D spatialized |
| 3.2.4 | Implement ambient zones | `👨‍💻 ENG` | - AudioStreamPlayer3D placement<br>- Volume/filter by zone<br>- Crossfade between zones |

### Epic 3.3: Player Audio
**Owner**: `🎵 AUDIO` | **Duration**: 1 week

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 3.3.1 | Create footstep SFX | `🎵 AUDIO` | - Concrete, metal, glass surfaces<br>- Walk and run variants<br>- Randomized selection |
| 3.3.2 | Create player vocal SFX | `🎵 AUDIO` | - Damage grunts (3+ variants)<br>- Death sound<br>- Exertion (jumping, sprinting) |
| 3.3.3 | Create UI audio | `🎵 AUDIO` | - Menu navigation clicks<br>- Inventory open/close<br>- Item pickup confirmation |

### Epic 3.4: Music
**Owner**: `🎵 AUDIO` | **Duration**: 3 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 3.4.1 | Compose main menu theme | `🎵 AUDIO` | - 1960s melancholic tone<br>- 2-minute loop<br>- Builds tension |
| 3.4.2 | Compose exploration music | `🎵 AUDIO` | - Ambient, low intensity<br>- Layered for dynamic mixing<br>- 4-minute loop minimum |
| 3.4.3 | Compose combat music | `🎵 AUDIO` | - High energy, percussion-driven<br>- Seamless transition from exploration<br>- Victory sting |
| 3.4.4 | Implement adaptive music system | `👨‍💻 ENG` | - Crossfade based on combat state<br>- Layer in/out instruments<br>- Stinger triggers |

---

## Milestone 4: Additional Levels (Weeks 14-24)

**Goal**: Complete 6 levels as specified in SPEC.md.

### Epic 4.1: Level 2 - Brooklyn Bridge
**Owner**: `🎮 DESIGN` + `🎨 ART` | **Duration**: 3 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 4.1.1 | Design Level 2 layout | `🎮 DESIGN` | - Bridge crossing + Brooklyn shore<br>- 3 zones with distinct encounters<br>- Written design doc |
| 4.1.2 | Greybox Level 2 | `🎮 DESIGN` | - CSG blocking complete<br>- Cover positions marked<br>- Enemy spawn points |
| 4.1.3 | Create bridge assets | `🎨 ART` | - Bridge section (modular)<br>- Abandoned vehicles<br>- Military barricade |
| 4.1.4 | Populate Level 2 | `🎮 DESIGN` | - 10-15 enemies placed<br>- Scavenge points<br>- Environmental hazards |
| 4.1.5 | QA Level 2 | `🧪 QA` | - Playtest 10+ runs<br>- Bug report filed<br>- Balance feedback |

### Epic 4.2: Levels 3-6 Production
**Owner**: `🎮 DESIGN` + `🎨 ART` | **Duration**: 8 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 4.2.1 | Design and build Level 3 (Queens) | `🎮 DESIGN` + `🎨 ART` | - Suburban environment<br>- New enemy type introduced<br>- QA approved |
| 4.2.2 | Design and build Level 4 (Bronx) | `🎮 DESIGN` + `🎨 ART` | - Industrial zone<br>- Vehicle combat section<br>- QA approved |
| 4.2.3 | Design and build Level 5 (Staten Island) | `🎮 DESIGN` + `🎨 ART` | - Coastal/port environment<br>- Boss encounter prep<br>- QA approved |
| 4.2.4 | Design and build Level 6 (D.C.) | `🎮 DESIGN` + `🎨 ART` | - Final level, government buildings<br>- Final boss fight<br>- Ending cinematics |

---

## Milestone 5: Polish and QA (Weeks 22-28)

**Goal**: Production-quality stability and user experience.

### Epic 5.1: Save/Load System
**Owner**: `👨‍💻 ENG` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 5.1.1 | Implement save game serialization | `👨‍💻 ENG` | - Player position, health, inventory saved<br>- Level progress saved<br>- JSON or binary format |
| 5.1.2 | Implement load game deserialization | `👨‍💻 ENG` | - Restores exact game state<br>- Handles missing/corrupted saves gracefully<br>- Version migration support |
| 5.1.3 | Create save slot UI | `👨‍💻 ENG` | - 3 save slots<br>- Shows level, playtime, date<br>- Delete confirmation |
| 5.1.4 | Add autosave | `👨‍💻 ENG` | - Saves at zone transitions<br>- Non-blocking (background thread)<br>- Visual indicator |

### Epic 5.2: UI Polish
**Owner**: `👨‍💻 ENG` + `🎨 ART` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 5.2.1 | Create pause menu | `👨‍💻 ENG` | - Resume, Save, Load, Options, Quit<br>- ESC key toggle<br>- Game paused while open |
| 5.2.2 | Create inventory screen | `👨‍💻 ENG` | - TAB key toggle<br>- Grid-based item display<br>- Drag-and-drop equip |
| 5.2.3 | Design UI theme | `🎨 ART` | - 1960s aesthetic (typewriter fonts, aged paper)<br>- Consistent color palette<br>- All UI elements styled |
| 5.2.4 | Add controller support | `👨‍💻 ENG` | - Full gamepad navigation<br>- Button prompts switch dynamically<br>- Aim assist option |

### Epic 5.3: Performance Optimization
**Owner**: `📐 ARCH` + `👨‍💻 ENG` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 5.3.1 | Profile and optimize C++ code | `📐 ARCH` | - No functions > 1ms per frame<br>- Memory allocations minimized<br>- Object pooling for projectiles |
| 5.3.2 | Implement LOD system | `👨‍💻 ENG` | - 3 LOD levels for props<br>- Distance-based switching<br>- Imposters for distant objects |
| 5.3.3 | Optimize draw calls | `👨‍💻 ENG` | - Batching static geometry<br>- GPU instancing for debris<br>- Occlusion culling enabled |
| 5.3.4 | Test on minimum spec | `🧪 QA` | - 30 FPS on GTX 1060<br>- 60 FPS on RTX 2060<br>- No memory leaks after 1hr play |

### Epic 5.4: Bug Fixing and QA
**Owner**: `🧪 QA` | **Duration**: 4 weeks (parallel)

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 5.4.1 | Create test plan | `🧪 QA` | - All features covered<br>- Regression test suite<br>- Platform matrix (Windows 10/11) |
| 5.4.2 | Execute smoke tests | `🧪 QA` | - Daily builds tested<br>- Blocker bugs filed within 24hr<br>- Build health dashboard |
| 5.4.3 | Playtest sessions | `🧪 QA` + `🎮 DESIGN` | - Weekly 2hr sessions<br>- 5+ testers per session<br>- Feedback documented |
| 5.4.4 | Bug triage and fix | `👨‍💻 ENG` | - Critical bugs fixed within 48hr<br>- Zero ship-blocking bugs<br>- Known issues documented |

---

## Milestone 6: Release (Weeks 26-30)

**Goal**: Ship the game and build community.

### Epic 6.1: Marketing Preparation
**Owner**: `📣 MARKETING` | **Duration**: 4 weeks (parallel)

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 6.1.1 | Create game trailer | `📣 MARKETING` + `🎨 ART` | - 90 seconds<br>- Gameplay footage + cinematic shots<br>- Music synced |
| 6.1.2 | Write store page copy | `📣 MARKETING` | - Steam description optimized<br>- Feature bullet points<br>- System requirements |
| 6.1.3 | Capture screenshots | `📣 MARKETING` | - 10 high-res screenshots<br>- Showcase each level<br>- Action and atmosphere shots |
| 6.1.4 | Build press kit | `📣 MARKETING` | - Logo, key art, screenshots<br>- Fact sheet<br>- Developer bios |
| 6.1.5 | Influencer outreach | `📣 MARKETING` | - 20+ streamers contacted<br>- Review codes sent<br>- Embargo date set |

### Epic 6.2: Platform Submission
**Owner**: `👨‍💻 ENG` + `📣 MARKETING` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 6.2.1 | Steam store setup | `📣 MARKETING` | - Store page live<br>- Wishlist enabled<br>- Coming Soon status |
| 6.2.2 | Steam build upload | `👨‍💻 ENG` | - Steamworks SDK integrated<br>- Achievements registered<br>- Cloud saves enabled |
| 6.2.3 | Create release build | `👨‍💻 ENG` | - Release configuration compiled<br>- Debug symbols stripped<br>- Installer tested |
| 6.2.4 | Final QA pass | `🧪 QA` | - Gold master candidate tested<br>- All critical bugs resolved<br>- Sign-off from leads |

### Epic 6.3: Launch and Post-Launch
**Owner**: `📣 MARKETING` + `👨‍💻 ENG` | **Duration**: 2 weeks

| ID | Task | Assignee | Acceptance Criteria |
|----|------|----------|---------------------|
| 6.3.1 | Launch day monitoring | `👨‍💻 ENG` | - Crash reporting active<br>- Community channels monitored<br>- Hotfix pipeline ready |
| 6.3.2 | Day-1 patch preparation | `👨‍💻 ENG` | - Known issues addressed<br>- Patch notes written<br>- Deployed within 48hr if needed |
| 6.3.3 | Community engagement | `📣 MARKETING` | - Discord server active<br>- Respond to reviews<br>- Announce update roadmap |
| 6.3.4 | Post-launch analytics | `📣 MARKETING` + `🎮 DESIGN` | - Playtime metrics collected<br>- Drop-off points identified<br>- Balance patches planned |

---

## Timeline Overview

```
Week:  1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30
       |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
M1:    [======= Vertical Slice =======]
M1.5:                              [Hard]
M2:                                  [============= Art Pipeline =============]
M3:                                                      [======= Audio ========]
M4:                                                          [=================== Additional Levels ===================]
M5:                                                                                  [============ Polish & QA ============]
M6:                                                                                                  [======== Release ========]
```

---

## Risk Register

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Art pipeline bottleneck | High | Medium | Use AI-generated placeholder assets; outsource hero models |
| Scope creep (more levels) | Medium | High | Lock feature set after M1; defer to DLC |
| Godot 4.3 breaking changes | High | Low | Pin engine version; test on updates |
| Single-person engineering | High | Medium | Document all systems; AI pair programming |
| Audio licensing issues | Medium | Low | Use royalty-free or commissioned audio only |
| M1 hardening reveals deeper issues | Medium | Medium | Time-box each task; defer non-critical fixes to M5 |

---

## Appendix A: Tool Requirements

| Discipline | Tool | Purpose |
|------------|------|---------|
| Engineering | Godot 4.3+, VS Code, CMake, Visual Studio 2022 | Game development |
| Art | Blender 4.0+, Substance Painter, GIMP/Photoshop | 3D modeling, texturing |
| Audio | Audacity, FMOD/Wwise (optional), DAW | Sound design |
| Design | Godot Editor, Miro/FigJam | Level design, documentation |
| QA | GitHub Issues, Test Rail (optional) | Bug tracking |
| Marketing | Canva, DaVinci Resolve, Steam Partner | Assets, video, distribution |

---

## Appendix B: Definition of Done

A task is considered **Done** when:

1. ✅ Code compiles without warnings
2. ✅ Feature matches acceptance criteria
3. ✅ Code reviewed (or AI-assisted review for solo dev)
4. ✅ No regressions in existing functionality
5. ✅ Documentation updated (if API changed)
6. ✅ Tested in editor and exported build

---

## Appendix C: Communication Cadence

| Meeting | Frequency | Attendees | Purpose |
|---------|-----------|-----------|---------|
| Daily Standup | Daily | All | Progress, blockers |
| Sprint Planning | Bi-weekly | All | Next 2 weeks work |
| Art Review | Weekly | Art, Design | Asset approval |
| Playtest | Weekly | QA, Design | Feedback collection |
| Milestone Review | Per milestone | All | Demo, retrospective |

---

*Document maintained by: Project Lead*  
*Last updated: February 10, 2026*
