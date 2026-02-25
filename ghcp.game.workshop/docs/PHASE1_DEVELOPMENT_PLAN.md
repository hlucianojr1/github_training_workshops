# Urban Survivor: Phase 1 Development Plan
## "New York City, 1960s"

---

## Executive Summary

This plan outlines the complete development of **Phase 1: NYC 1960s**, transforming the current prototype into a polished, production-ready vertical slice. The phase delivers **Level 1: "The Heights"** (Washington Heights) with full 1960s period authenticity, complete gameplay systems, and AAA-quality presentation standards.

**Timeline**: 16 weeks  
**Team Simulation**: Solo developer with AI assistance  
**Deliverable**: Fully playable Level 1 with period-accurate art, audio, and polished gameplay

---

## Current State Assessment

### Completed Systems ✓
| System | Status | Quality |
|--------|--------|---------|
| `PlayerController` | Implemented | Good - needs animation integration |
| `ThirdPersonCamera` | Implemented | Good - spring arm, collision, aim mode |
| `EnemyAI` | Implemented | Good - FSM with 7 states |
| `AIPerception` | Implemented | Functional |
| `Inventory` | Implemented | Structure complete |
| `Weapon` | Implemented | Needs VFX/audio |
| `SurvivalStats` | Implemented | Basic |
| Level 1 Script | Greyboxed | Zone logic working |

### Gaps Requiring Work
1. **Art**: 0% complete - all placeholders
2. **Audio**: 0% implemented
3. **UI/HUD**: Structure exists, no visual design
4. **Animations**: None integrated
5. **VFX**: None implemented
6. **Polish**: No post-processing, lighting passes

---

## Phase 1 Architecture

### Sprint Structure (16 Weeks)

```
Week 1-4:   Foundation & Core Polish
Week 5-8:   Art Pipeline & Asset Creation
Week 9-12:  Audio, VFX, & Level Population
Week 13-16: Polish, QA, & Optimization
```

---

## Sprint 1-2: Foundation (Weeks 1-4)

### 1.1 Combat System Completion

**Goal**: Fully functional shooting, damage, and weapon handling

```cpp
// Enhancements needed:

// Add recoil system
void Weapon::apply_recoil() {
    // Vertical kick based on weapon type
    // Spread increase during sustained fire
    // Recovery over time
}

// Add reload state machine
enum class ReloadState {
    IDLE,
    EJECTING_MAG,
    INSERTING_MAG,
    CHAMBERING,
    READY
};
```

**Tasks**:
| ID | Task | Acceptance Criteria |
|----|------|---------------------|
| 1.1.1 | Implement recoil system | Camera kick, pattern per weapon |
| 1.1.2 | Add spread mechanics | Increases with fire, decreases at rest |
| 1.1.3 | Create M1911 Pistol data | 7-round mag, 45 damage, 25m range |
| 1.1.4 | Create Remington 870 data | 6-shell tube, 80 damage (close), pump action |
| 1.1.5 | Implement hit feedback | Hitmarkers, damage numbers (optional), audio |

### 1.2 Player Animation System

**Goal**: Integrate skeletal animations with PlayerController

```cpp
// Add animation state machine

private:
    enum class AnimationState {
        IDLE,
        WALK,
        RUN,
        CROUCH_IDLE,
        CROUCH_WALK,
        AIM,
        FIRE,
        RELOAD,
        MELEE,
        DEATH
    };
    
    AnimationState current_anim_state = AnimationState::IDLE;
    AnimationPlayer* anim_player = nullptr;
    
    void update_animation_state();
    void blend_animations(double delta);
```

**Animation List Required**:
| Animation | Frames | Loop | Notes |
|-----------|--------|------|-------|
| idle_stand | 60 | Yes | Subtle breathing |
| walk_forward | 30 | Yes | 3.5 m/s |
| run_forward | 20 | Yes | 6.0 m/s |
| crouch_idle | 60 | Yes | |
| crouch_walk | 40 | Yes | |
| aim_pistol | 15 | No | Blend pose |
| fire_pistol | 8 | No | |
| reload_pistol | 90 | No | 3 sec |
| melee_swing | 20 | No | |
| death_front | 45 | No | Ragdoll transition |

### 1.3 AI Combat Behavior Enhancement

**Goal**: Enemies that feel threatening and period-appropriate

Enhancements to `EnemyAI`:

```cpp
// Add tactical behaviors

void EnemyAI::state_attack(double delta) {
    // Fire in bursts, not continuous
    // Seek cover after firing
    // Reload behind cover
    // Flank when player is suppressed
}

void EnemyAI::evaluate_cover() {
    // Find cover nodes in range
    // Evaluate cover quality (height, angle to player)
    // Move to optimal cover
}

// Add 1960s-appropriate callouts
const char* COMBAT_BARKS[] = {
    "He's over there!",
    "Take him down!",
    "Cover me!",
    "I'm reloading!"
};
```

**Enemy Types for Level 1**:
| Type | Health | Weapon | Behavior |
|------|--------|--------|----------|
| Scavenger | 60 | Pipe/Knife | Aggressive melee, flees at 30% HP |
| Raider | 100 | Pistol/Shotgun | Uses cover, flanks |
| Heavy | 150 | Rifle | Suppressive fire, rarely moves |

---

## Sprint 3-4: Art Pipeline (Weeks 5-8)

### 2.1 Character Art

#### Player Character

**Reference**: 1960s working-class American male

```
Polycount: 15,000 triangles
Texture: 2048x2048 PBR (Albedo, Normal, ORM)

Clothing (Modular):
- White undershirt (always visible)
- Brown leather jacket (1950s bomber style)
- Dark work pants (high-waisted, pleated)
- Brown oxford shoes
- Optional: Newsboy cap
```

**Topology Requirements**:
- Face: Quad-based, deformation loops around eyes/mouth
- Hands: Full finger articulation
- Clothing: Separate meshes for modular system

#### Enemy Characters

**Scavenger**:
```
Polycount: 8,000 triangles
Appearance:
- Ragged civilian clothes (torn suits, dirty shirts)
- Improvised armor (pot lids, car doors strapped on)
- Bandanas, goggles
- 3 head variants, 3 body variants
```

**Raider**:
```
Polycount: 10,000 triangles
Appearance:
- Military surplus (M65 field jackets, combat boots)
- Helmets (M1 steel pot)
- Tactical gear (webbing, pouches)
- More organized, uniformed look
```

### 2.2 Weapon Art

**M1911 Pistol** (Starting weapon):
```
1st Person LOD: 4,000 triangles
3rd Person LOD: 800 triangles
Texture: 1024x1024

Details:
- Worn bluing on edges
- Wood grips (period-accurate)
- Visible serial number (weathered)
- Muzzle flash attachment point
```

**Remington 870 Shotgun**:
```
1st Person LOD: 5,000 triangles
3rd Person LOD: 1,000 triangles

Details:
- Wood stock and forend
- Pump action animation
- Shell ejection port modeled
- Police riot configuration
```

### 2.3 Environment Art - Level 1

Based on Level 1 Design:

#### Zone 1: Traffic Jam

**Hero Props**:

| Asset | Triangles | Texture | Priority |
|-------|-----------|---------|----------|
| Checker Marathon Taxi | 3,000 | 1024 | HIGH |
| 1957 Chevy Bel Air (wrecked) | 3,000 | 1024 | HIGH |
| GMC City Bus | 5,000 | 2048 | MEDIUM |
| Scattered suitcases | 500 | 512 | LOW |

**Vehicle Damage States**:
```
State 0: Clean (rare, story purposes)
State 1: Dusty, minor dents
State 2: Broken windows, flat tires
State 3: Burned out, rusted hulk
```

#### Zone 2: Checkpoint

**Military Props**:

| Asset | Triangles | Texture | Priority |
|-------|-----------|---------|----------|
| M48 Patton Tank (destroyed) | 6,000 | 2048 | HIGH |
| Sandbag wall (modular) | 500/unit | 512 | HIGH |
| Concertina wire | 300 | 256 | MEDIUM |
| MG nest (tripod + gun) | 2,000 | 1024 | HIGH |
| Military truck (deuce-and-a-half) | 4,000 | 1024 | MEDIUM |

#### Zone 3: Commercial Strip

**Storefronts**:

| Asset | Triangles | Texture | Priority |
|-------|-----------|---------|----------|
| Woolworth's facade | 4,000 | 1024 | HIGH |
| Rexall Drugs facade | 4,000 | 1024 | HIGH |
| Chrome Diner | 5,000 | 1024 | MEDIUM |
| Phone booth | 800 | 512 | HIGH |
| Neon signs (flickering) | 200 | 256 | HIGH |

### 2.4 Texture & Material Standards

**PBR Material Setup**:
```
Albedo: Base color, no baked lighting
Normal: OpenGL format (Y+ green up)
ORM: Occlusion (R), Roughness (G), Metallic (B)
Emission: For neon signs, fires
```

**1960s Color Palette**:
```gdshader
// Urban decay palette
const vec3 PALETTE_BRICK = vec3(0.45, 0.25, 0.20);
const vec3 PALETTE_CONCRETE = vec3(0.55, 0.53, 0.50);
const vec3 PALETTE_RUST = vec3(0.50, 0.30, 0.15);
const vec3 PALETTE_TAXI_YELLOW = vec3(0.95, 0.85, 0.30);
const vec3 PALETTE_MILITARY_OD = vec3(0.30, 0.35, 0.25);
```

### 2.5 Modular Architecture System

**Apartment Building Kit**:
```
Base module: 4m x 4m x 3m (floor height)
Pieces:
- Corner piece (exterior)
- Window module (3 variants: intact, broken, boarded)
- Fire escape section
- Roof parapet
- Entry doorway
- Ground floor retail
```

---

## Sprint 5-6: Audio & VFX (Weeks 9-12)

### 3.1 Audio System Architecture

```cpp
#ifndef AUDIO_MANAGER_HPP
#define AUDIO_MANAGER_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/audio_stream_player.hpp>
#include <godot_cpp/classes/audio_stream_player3d.hpp>

namespace godot {

class AudioManager : public Node {
    GDCLASS(AudioManager, Node)

public:
    enum class SoundCategory {
        WEAPON,
        FOOTSTEP,
        VOICE,
        AMBIENT,
        UI,
        MUSIC
    };

private:
    // Audio buses
    static constexpr const char* BUS_MASTER = "Master";
    static constexpr const char* BUS_SFX = "SFX";
    static constexpr const char* BUS_MUSIC = "Music";
    static constexpr const char* BUS_AMBIENT = "Ambient";
    static constexpr const char* BUS_VOICE = "Voice";
    
    // Pooled audio players for performance
    Vector<AudioStreamPlayer3D*> sfx_pool_3d;
    Vector<AudioStreamPlayer*> sfx_pool_2d;
    
    AudioStreamPlayer* music_player = nullptr;
    AudioStreamPlayer* ambient_player = nullptr;

protected:
    static void _bind_methods();

public:
    AudioManager();
    ~AudioManager();
    
    void play_sound_3d(const String& sound_name, Vector3 position, float volume = 1.0f);
    void play_sound_2d(const String& sound_name, float volume = 1.0f);
    void play_music(const String& track_name, float fade_time = 1.0f);
    void play_ambient(const String& ambient_name);
    
    void set_bus_volume(const String& bus_name, float volume);
};

} // namespace godot

#endif
```

### 3.2 Sound Design - 1960s Authenticity

**Weapon Sounds**:
| Weapon | Fire | Reload | Empty | Notes |
|--------|------|--------|-------|-------|
| M1911 | Sharp crack, echo | Magazine click, slide rack | Dry click | Period recordings preferred |
| 870 Shotgun | Deep boom, pump action | Shell insert x6, pump | Click | Pump sound iconic |
| Melee | Whoosh, impact | N/A | N/A | Varies by target |

**Ambient Soundscape (Level 1)**:
```
Layer 1 (Constant):
- Wind through urban canyon
- Distant traffic (none nearby)
- Metal creaking (bridge cables)

Layer 2 (Zone-specific):
- Zone 1: Car door creaking, papers rustling
- Zone 2: Radio static, distant commands
- Zone 3: Neon buzz, broken glass underfoot

Layer 3 (Dynamic):
- Distant gunfire (random, 30-90 sec intervals)
- Crows/pigeons disturbed
- Collapsing debris (rare)
```

**Music Direction**:
```
Style: 1960s-influenced tension music
- Jazz-noir undertones (saxophone, muted trumpet)
- Sparse, atmospheric
- Tension builds with proximity to enemies
- Combat: Percussion-driven, urgent

Adaptive layers:
- Exploration: Ambient + light melody
- Tension: Add bass, minor key shift
- Combat: Full instrumentation
- Victory: Resolution, major key
```

### 3.3 Visual Effects

**Weapon VFX**:
```gdshader
// Muzzle flash shader
shader_type spatial;
render_mode unshaded, depth_draw_never;

uniform sampler2D flash_texture;
uniform float intensity = 1.0;
uniform float lifetime = 0.05;

void fragment() {
    vec4 flash = texture(flash_texture, UV);
    float fade = 1.0 - (TIME / lifetime);
    ALBEDO = flash.rgb * intensity * fade;
    ALPHA = flash.a * fade;
}
```

**Environmental VFX**:
| Effect | Type | Performance |
|--------|------|-------------|
| Dust motes | GPU Particles | 500 particles, LOD |
| Steam from manholes | GPU Particles | 200 particles |
| Paper/debris wind | GPU Particles | 100 particles |
| Neon flicker | Shader | Negligible |
| Muzzle flash | Sprite3D | Per-shot |
| Blood splatter | Decals | Pooled, fade |
| Bullet impacts | Decals + Particles | Pooled |

### 3.4 Post-Processing Stack

```gdshader
// 1960s film look
// filepath: game/shaders/post_process_1960s.gdshader

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float grain_intensity = 0.05;
uniform float vignette_strength = 0.3;
uniform float desaturation = 0.2;
uniform vec3 color_tint = vec3(1.0, 0.95, 0.85); // Warm film stock

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = texture(SCREEN_TEXTURE, uv);
    
    // Desaturate slightly
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(color.rgb, vec3(luminance), desaturation);
    
    // Color grade (warm 1960s film)
    color.rgb *= color_tint;
    
    // Film grain
    float grain = fract(sin(dot(uv * TIME, vec2(12.9898, 78.233))) * 43758.5453);
    color.rgb += (grain - 0.5) * grain_intensity;
    
    // Vignette
    float vignette = 1.0 - length(uv - 0.5) * vignette_strength;
    color.rgb *= vignette;
    
    COLOR = color;
}
```

---

## Sprint 7-8: Level Population & Polish (Weeks 13-16)

### 4.1 Level Layout Finalization

Based on Level 1 Design, update `game/scenes/level_1.gd`:

**Zone Metrics**:
| Zone | Length (m) | Enemies | Scavenge Points | Cover Objects |
|------|------------|---------|-----------------|---------------|
| Traffic Jam | 100m | 0 (tutorial) | 5 | 20+ vehicles |
| Checkpoint | 80m | 5-7 | 3 | Sandbags, barriers |
| Commercial Strip | 100m | 3-5 | 2 | Storefronts, booths |

**Enemy Placement Strategy**:
```
Zone 2 - Checkpoint:
- MG nest (center) - blocks direct approach
- 2 Raiders flanking left/right
- 2 Scavengers patrolling rear
- Player MUST flank

Zone 3 - Commercial Strip:
- 2 Scavengers looting stores
- 1 Raider sniper in upper window
- 2 Scavengers ambush near exit
```

### 4.2 Scavenge Point Population

```cpp
// Loot tables per zone
// filepath: game/data/loot_tables.tres (Resource file)

Zone 1 (Tutorial):
- Health Kit (common)
- Pistol Ammo x12 (common)
- Bandages (common)
- Food (common)

Zone 2 (Military):
- Shotgun Ammo x6 (uncommon)
- Rifle Ammo x20 (rare)
- Grenades (rare)
- Military Rations (uncommon)

Zone 3 (Commercial):
- Medical Supplies (uncommon)
- Trade Goods (common)
- Hidden Cache: Better weapon (rare)
```

### 4.3 Lighting Pass

**Time of Day**: Late afternoon (4:30 PM, October)

```gdshader
// Lighting configuration
Sun Direction: (-0.3, -0.5, 0.3) normalized
Sun Color: RGB(255, 180, 120) // Warm sunset
Sun Energy: 1.2
Shadow Bias: 0.02

Ambient Light:
- Sky contribution: 0.3
- Ground color: RGB(80, 70, 65) // Warm bounce
- Energy: 0.4

Volumetric Fog:
- Density: 0.02
- Color: RGB(150, 140, 130)
- Sun scatter: 0.3
```

**Zone-Specific Lighting**:
| Zone | Key Light | Fill | Accent |
|------|-----------|------|--------|
| Traffic Jam | Setting sun (long shadows) | Ambient sky | Chrome reflections on cars |
| Checkpoint | Same sun | Darker fill (tension) | Fire barrel lights |
| Commercial | Dusk (dimmer sun) | Neon glow | Flickering shop signs |

### 4.4 UI/HUD Implementation

Based on existing `HUD` class:

**Visual Design - 1960s Aesthetic**:
```
Font: Sans-serif, clean (Helvetica-inspired)
Colors: 
- Health: Red on dark, white text
- Ammo: Yellow on dark
- Objectives: White on translucent black

Layout:
┌─────────────────────────────────────────────────┐
│ [Health Bar]                        [Ammo: 7/42]│
│ [Stamina]                                       │
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│                      [ + ]                      │  ← Crosshair
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│ [Objective: Reach the Subway at 168th St]      │
└─────────────────────────────────────────────────┘
```

**HUD Elements Implementation**:
```gdscript
extends Control

@onready var health_bar: ProgressBar = $MarginContainer/VBox/HealthBar
@onready var stamina_bar: ProgressBar = $MarginContainer/VBox/StaminaBar
@onready var ammo_label: Label = $MarginContainer/AmmoContainer/AmmoLabel
@onready var objective_label: Label = $MarginContainer/ObjectiveContainer/ObjectiveLabel
@onready var crosshair: TextureRect = $Crosshair

# 1960s damage vignette
@onready var damage_vignette: ColorRect = $DamageVignette

func _ready() -> void:
    # Connect to player signals
    var player = get_tree().get_first_node_in_group("player")
    if player:
        player.connect("health_changed", _on_health_changed)
        player.connect("ammo_changed", _on_ammo_changed)
```

### 4.5 Save System

```cpp
#ifndef SAVE_MANAGER_HPP
#define SAVE_MANAGER_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/resource.hpp>

namespace godot {

class SaveData : public Resource {
    GDCLASS(SaveData, Resource)
    
private:
    // Player state
    float health;
    float stamina;
    Vector3 position;
    
    // Inventory
    Dictionary inventory_data;
    String equipped_weapon;
    
    // Level state
    int current_level;
    int current_zone;
    Array killed_enemies;  // IDs of eliminated enemies
    Array looted_containers;  // IDs of opened scavenge points
    
    // Stats
    float play_time;
    int kills;
    int deaths;

protected:
    static void _bind_methods();
};

class SaveManager : public Node {
    GDCLASS(SaveManager, Node)
    
private:
    static constexpr const char* SAVE_PATH = "user://saves/";
    
public:
    Error save_game(int slot);
    Error load_game(int slot);
    bool has_save(int slot);
    void delete_save(int slot);
    
    Dictionary get_save_metadata(int slot);
};

} // namespace godot

#endif
```

---

## Quality Assurance Plan

### 5.1 Testing Checklists

**Core Gameplay**:
- [ ] Player can complete level from start to exit
- [ ] All weapons fire, reload, deal correct damage
- [ ] Enemies respond correctly to player detection
- [ ] Cover system functions (player and AI)
- [ ] Scavenge points provide loot
- [ ] Health/stamina systems work correctly
- [ ] Player can die and respawn
- [ ] Save/load preserves game state

**Performance Targets**:
| Metric | Target | Minimum |
|--------|--------|---------|
| Frame Rate | 60 FPS | 30 FPS |
| Load Time | < 5 sec | < 10 sec |
| Memory | < 2 GB | < 4 GB |
| Draw Calls | < 500 | < 1000 |

**Platform Testing**:
- Windows 10/11 (Primary)
- Linux (Steam Deck compatibility)
- macOS (Secondary)

### 5.2 Bug Categories

| Severity | Definition | Response Time |
|----------|------------|---------------|
| Critical | Game crash, data loss | Immediate fix |
| High | Gameplay blocked, exploit | 24 hours |
| Medium | Visual/audio glitch | Next sprint |
| Low | Polish issue | Backlog |

---

## Optimization Strategy

### 6.1 GPU Optimization

**Level of Detail (LOD) System**:
```cpp
// Distance-based LOD switching
LOD0: 0-15m (full detail)
LOD1: 15-40m (50% triangles)
LOD2: 40-80m (25% triangles)
LOD3: 80m+ (billboard/impostor)
```

**Occlusion Culling**:
- Enable Godot 4's automatic occlusion
- Add manual occluder boxes for buildings
- Cull interior detail when outside

**Batching**:
- Static geometry batching for props
- GPU instancing for debris
- Material atlasing for similar surfaces

### 6.2 CPU Optimization

**AI Staggering**:
```cpp
// Don't update all AI same frame
void EnemyAI::_physics_process(double delta) {
    frame_counter++;
    if ((frame_counter + ai_id) % AI_UPDATE_INTERVAL != 0) {
        return;  // Skip this frame
    }
    // Full AI update
}
```

**Physics Optimization**:
- Collision layers properly configured
- Simple colliders for non-interactable props
- Physics queries cached where possible

### 6.3 Memory Optimization

**Asset Streaming**:
- Zone-based loading
- Unload Zone 1 when entering Zone 3
- Preload next zone during gameplay

**Object Pooling**:
- Bullet casings
- Blood decals
- Particle effects
- Audio players

---

## Asset Production Pipeline

### 7.1 3D Art Workflow

```
1. Reference Gathering
   - 1960s photo archives
   - Period films (Serpico, French Connection aesthetic)
   
2. Blockout
   - CSG in Godot for layout
   - Rough proportions
   
3. High Poly Modeling
   - Blender/Maya
   - Detail sculpting
   
4. Low Poly & Retopology
   - Meet triangle budgets
   - Clean UV layout
   
5. Baking
   - Normal maps from high poly
   - AO baking
   
6. Texturing
   - Substance Painter preferred
   - PBR workflow
   - Period-accurate weathering
   
7. Export
   - GLTF 2.0 format
   - Embedded textures
   - Test import in Godot
```

### 7.2 Audio Production Workflow

```
1. Sound Design
   - Record/source period-appropriate sounds
   - Layer and process in DAW
   
2. Implementation
   - Export: WAV (SFX), OGG (music/ambient)
   - 44.1kHz, mono for 3D, stereo for 2D
   
3. Integration
   - Import to Godot
   - Configure 3D attenuation
   - Bus routing
   
4. Mixing
   - Balance across all buses
   - Test with gameplay
   - Dynamic range appropriate
```

---

## Risk Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Art bottleneck | HIGH | HIGH | Use AI-generated concepts, outsource hero assets |
| Scope creep | HIGH | MEDIUM | Lock feature set at week 4 |
| Performance issues | MEDIUM | MEDIUM | Profile weekly, optimize early |
| Audio licensing | LOW | LOW | Use royalty-free or commission original |
| Godot bugs | MEDIUM | LOW | Pin to stable 4.3, test updates |

---

## Deliverables Checklist

### Week 4 Milestone
- [ ] Combat fully functional
- [ ] Player animations integrated
- [ ] AI combat behaviors working
- [ ] Basic weapon sounds implemented

### Week 8 Milestone
- [ ] Player character model complete
- [ ] 2 enemy types modeled
- [ ] All weapons modeled
- [ ] Zone 1 environment art 50%
- [ ] Zone 2 hero props complete

### Week 12 Milestone
- [ ] All environment art complete
- [ ] Full audio pass (SFX + music)
- [ ] VFX complete
- [ ] Post-processing stack finalized

### Week 16 (Release)
- [ ] QA pass complete
- [ ] Performance targets met
- [ ] Save system functional
- [ ] All critical bugs resolved
- [ ] Build packaged for distribution

---

## Next Steps (Immediate Actions)

1. **Today**: 
   - Set up project milestones in tracking system
   - Create art reference board (1960s NYC)
   - Audit current code for animation hooks

2. **This Week**:
   - Implement recoil system in `Weapon`
   - Add animation state machine to `PlayerController`
   - Source/create placeholder audio for weapons

3. **This Sprint**:
   - Complete combat system (1.1.1 - 1.1.5)
   - Begin character modeling
   - Create AudioManager class

---

This plan provides a complete roadmap to transform the current prototype into a polished Phase 1 vertical slice, with industry-standard practices for art production, audio implementation, optimization, and quality assurance.
