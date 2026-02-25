# AnimationTree State Machine Setup Guide
# ========================================
# 
# After importing char_player_survivor_lod0.glb into Godot:
#
# 1. The GLB contains these animations:
#    - player_idle (60 frames, loop)
#    - player_walk (30 frames, loop)
#    - player_run (20 frames, loop)
#    - player_sprint (20 frames, loop)
#    - player_crouch_idle (60 frames, loop)
#    - player_crouch_walk (40 frames, loop)
#    - player_jump_start (10 frames, one-shot)
#    - player_jump_loop (20 frames, loop)
#    - player_jump_land (15 frames, one-shot)
#    - player_aim_idle (60 frames, loop)
#    - player_recoil (10 frames, one-shot)
#    - player_reload (60 frames, one-shot) [markers: mag_out=18, mag_in=42]
#    - player_melee_attack (25 frames, one-shot)
#    - player_hit_react (20 frames, one-shot)
#    - player_death (45 frames, one-shot)
#
# 2. Create AnimationTree with StateMachine:
#    - Root node: AnimationNodeStateMachine
#    - Add states for each animation
#
# 3. State Machine Layout:
#
#    ┌─────────────────────────────────────────────────────────────┐
#    │                      LOCOMOTION                              │
#    │   [idle] ←→ [walk] ←→ [run] ←→ [sprint]                     │
#    │     ↑↓                                                       │
#    │   [crouch_idle] ←→ [crouch_walk]                            │
#    └─────────────────────────────────────────────────────────────┘
#                          ↑↓
#    ┌─────────────────────────────────────────────────────────────┐
#    │                        JUMP                                  │
#    │   [jump_start] → [jump_loop] → [jump_land] → (back to idle) │
#    └─────────────────────────────────────────────────────────────┘
#                          ↑↓
#    ┌─────────────────────────────────────────────────────────────┐
#    │                       COMBAT                                 │
#    │   [aim_idle] ←→ [recoil]                                    │
#    │       ↑↓                                                     │
#    │   [reload]    [melee]                                        │
#    └─────────────────────────────────────────────────────────────┘
#                          ↑↓
#    ┌─────────────────────────────────────────────────────────────┐
#    │                       STATUS                                 │
#    │   [hit_react] → (back to previous)                          │
#    │   [death] → (final state)                                   │
#    └─────────────────────────────────────────────────────────────┘
#
# 4. Transition Settings:
#    - Locomotion: Immediate transitions, blend time 0.1s
#    - Jump: Auto-advance after jump_start/jump_land complete
#    - Combat: One-shot animations return to aim_idle
#    - Death: No outgoing transitions (final state)
#
# 5. Parameters to bind from PlayerController:
#    - parameters/StateMachine/playback (get for state control)
#    - Use state_machine.travel("state_name") to change states
