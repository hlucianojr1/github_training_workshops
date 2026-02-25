extends AnimationTree
## Player Animation Tree Setup
## 
## This script sets up the AnimationTree state machine for the player character.
## Attach to an AnimationTree node that references the player's AnimationPlayer.

# Animation parameters to control from PlayerController
var movement_blend := Vector2.ZERO
var movement_speed := 0.0
var is_crouching := false
var is_aiming := false
var is_jumping := false
var is_on_ground := true

# State machine references
@onready var state_machine: AnimationNodeStateMachinePlayback

func _ready() -> void:
    state_machine = get("parameters/StateMachine/playback")
    active = true

func _process(_delta: float) -> void:
    # Update blend parameters
    set("parameters/Locomotion/blend_position", movement_blend)
    set("parameters/movement_speed", movement_speed)
    
    # Handle state transitions
    _update_state_machine()

func _update_state_machine() -> void:
    if not state_machine:
        return
    
    var current := state_machine.get_current_node()
    
    # Death state is final
    if current == "death":
        return
    
    # Jump states
    if is_jumping and is_on_ground:
        state_machine.travel("jump_start")
    elif not is_on_ground and current != "jump_loop":
        if current == "jump_start":
            # Wait for jump_start to finish, then go to loop
            pass
        else:
            state_machine.travel("jump_loop")
    elif is_on_ground and (current == "jump_loop" or current == "jump_start"):
        state_machine.travel("jump_land")
    
    # Ground movement states
    elif is_on_ground:
        if is_crouching:
            if movement_speed > 0.1:
                state_machine.travel("crouch_walk")
            else:
                state_machine.travel("crouch_idle")
        elif is_aiming:
            state_machine.travel("aim_idle")
        else:
            if movement_speed > 0.8:
                state_machine.travel("sprint")
            elif movement_speed > 0.5:
                state_machine.travel("run")
            elif movement_speed > 0.1:
                state_machine.travel("walk")
            else:
                state_machine.travel("idle")

# Called by combat system
func play_recoil() -> void:
    set("parameters/combat_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func play_reload() -> void:
    set("parameters/combat_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    # Switch to reload action

func play_melee() -> void:
    set("parameters/combat_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func play_hit_react() -> void:
    set("parameters/hit_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func play_death() -> void:
    if state_machine:
        state_machine.travel("death")
