---
agent: 'animation-artist'
description: 'Setup AnimationTree for player character with locomotion blend spaces, combat states, and smooth transitions.'
---

Setup player AnimationTree for body movement and combat.

## Load Context First
- src/player/player_controller.hpp/cpp
- docs/ART_GUIDELINES.md (animation list, skeleton)
- game/assets/animations/player/README.md (animation files)
- game/scenes/player.tscn (if exists)

## Prerequisites
- Animation GLB files exported from Blender MCP Animation System
- Player animations at: `res://assets/animations/player/player_anims.glb`
- Enemy animations at: `res://assets/animations/enemies/enemy_anims.glb`

## Requirements
- Smooth locomotion blending (8-direction movement)
- Crouch locomotion variant
- Combat state machine (aim, fire, reload)
- One-shot actions (interact, melee)
- Proper transition timing
- Frame marker sync for reload phases

## Steps

1) Create AnimationTree node as child of player:
   ```
   Player (PlayerController)
   └── AnimationTree
       ├── AnimationPlayer (sibling, holds clips)
       └── Tree Root: AnimationNodeStateMachine
   ```

2) Setup Locomotion BlendSpace2D:
   ```
   BlendSpace2D: "Locomotion"
   
   Points:
   (0, 0)   → idle
   (0, 1)   → walk_forward
   (0, -1)  → walk_backward
   (-1, 0)  → walk_left
   (1, 0)   → walk_right
   (-1, 1)  → walk_forward_left
   (1, 1)   → walk_forward_right
   (-1, -1) → walk_backward_left
   (1, -1)  → walk_backward_right
   
   Blend mode: Continuous
   X axis: strafe (-1 to 1)
   Y axis: forward/back (-1 to 1)
   ```

3) Setup Run BlendSpace (similar structure):
   ```
   BlendSpace2D: "Run_Locomotion"
   - Same layout with run_ animations
   - Blend between walk and run based on speed
   ```

4) Setup Crouch BlendSpace:
   ```
   BlendSpace2D: "Crouch_Locomotion"
   - crouch_idle at center
   - crouch_walk variants at edges
   - Slower movement, lower stance
   ```

5) Create State Machine Structure:
   ```
   AnimationNodeStateMachine: "Root"
   ├── Locomotion (BlendSpace2D)
   ├── Crouch_Locomotion (BlendSpace2D)
   ├── Jump (StateMachine)
   │   ├── jump_start
   │   ├── jump_loop
   │   └── jump_land
   ├── Combat (StateMachine)
   │   ├── aim_idle
   │   ├── fire
   │   └── reload
   └── Actions (OneShot container)
       ├── interact
       ├── melee
       └── death
   ```

6) Configure Transitions:
   ```
   Locomotion ↔ Crouch_Locomotion:
   - Trigger: is_crouching parameter
   - Blend time: 0.2s
   - Xfade: Linear
   
   Locomotion → Jump:
   - Trigger: jump_trigger
   - Blend time: 0.1s
   
   Any → Combat:
   - Trigger: is_aiming parameter
   - Blend time: 0.15s
   - Priority: High
   
   Any → Death:
   - Trigger: death_trigger
   - Blend time: 0.0s (immediate)
   - Priority: Highest
   ```

7) Setup Animation Parameters:
   ```gdscript
   # Parameters to expose
   parameters/Locomotion/blend_position  # Vector2
   parameters/is_crouching               # bool
   parameters/is_aiming                  # bool
   parameters/jump_trigger               # trigger
   parameters/fire_trigger               # trigger
   parameters/reload_trigger             # trigger
   parameters/interact_trigger           # trigger
   parameters/melee_trigger              # trigger
   parameters/death_trigger              # trigger
   ```

8) Connect to PlayerController (C++):
   ```cpp
   void PlayerController::_physics_process(double delta) {
       // Update locomotion blend
       Vector2 move_input = get_movement_input();
       animation_tree->set("parameters/Locomotion/blend_position", move_input);
       
       // Update states
       animation_tree->set("parameters/is_crouching", is_crouching);
       animation_tree->set("parameters/is_aiming", is_aiming);
       
       // Triggers set on events (fire(), reload(), etc.)
   }
   ```

9) Add Root Motion (optional):
   ```
   AnimationTree:
   - Root motion track: Hips bone
   - Apply in _physics_process for movement
   - OR: Use animation for rotation only, code for position
   ```

10) Setup Reload Frame Sync:
    ```cpp
    // Connect AnimationPlayer's animation_changed signal
    // Reload animation: 60 frames at 30 FPS = 2 seconds
    // Frame markers from MCP preset:
    //   mag_out: frame 18 (0.6s) - magazine removed
    //   mag_in:  frame 42 (1.4s) - magazine inserted
    
    void PlayerController::_ready() {
        // Get AnimationPlayer reference
        animation_player = get_node<AnimationPlayer>("AnimationPlayer");
        animation_player->connect("animation_started", callable_mp(this, &PlayerController::on_animation_started));
    }
    
    void PlayerController::on_animation_started(StringName anim_name) {
        if (anim_name == "player_reload") {
            is_reloading = true;
            reload_start_time = Time::get_singleton()->get_ticks_msec();
        }
    }
    
    void PlayerController::_process(double delta) {
        if (is_reloading) {
            double elapsed = (Time::get_singleton()->get_ticks_msec() - reload_start_time) / 1000.0;
            
            // mag_out at 0.6s (frame 18/60 at 30fps)
            if (elapsed >= 0.6 && !reload_mag_removed) {
                reload_mag_removed = true;
                can_fire = false;
                // Visual: hide magazine from weapon model
            }
            
            // mag_in at 1.4s (frame 42/60 at 30fps)
            if (elapsed >= 1.4 && reload_mag_removed) {
                current_ammo = max_ammo;
                reload_mag_removed = false;
                // Visual: show magazine on weapon
            }
            
            // Reload complete at 2.0s
            if (elapsed >= 2.0) {
                is_reloading = false;
                can_fire = true;
            }
        }
    }
    ```

11) Import Animation Files:
    ```gdscript
    # In player scene setup script or editor
    
    # Load animation library from GLB
    var player_anims = preload("res://assets/animations/player/player_anims.glb")
    
    # AnimationPlayer should auto-import animations from GLB
    # Verify animation names match expected:
    #   player_idle, player_walk, player_run, player_sprint
    #   player_crouch_idle, player_crouch_walk
    #   player_jump_start, player_jump_loop, player_jump_land
    #   player_aim_idle, player_recoil, player_reload
    #   player_melee, player_death, player_hit_react
    ```

## Acceptance Criteria
- [ ] 8-direction locomotion blending works smoothly
- [ ] Walk/run transition based on speed
- [ ] Crouch transitions smoothly
- [ ] Jump sequence plays correctly
- [ ] Combat animations override locomotion
- [ ] One-shot actions play and return to locomotion
- [ ] No foot sliding during movement
- [ ] Parameters accessible from C++ PlayerController
- [ ] Reload frame markers sync with gameplay (mag_out/mag_in)
- [ ] Animation GLB files loaded correctly from assets folder
