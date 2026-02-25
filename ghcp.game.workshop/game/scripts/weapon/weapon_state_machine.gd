## Weapon state machine for Urban Survivor
## Manages weapon states and transitions
extends Node
class_name WeaponStateMachine

signal state_changed(old_state: String, new_state: String)

@export var initial_state: WeaponStateBase
@export var debug_mode: bool = false

var current_state: WeaponStateBase
var states: Dictionary = {}

# Weapon references (set by weapon controller)
var weapon_controller: Node3D
var weapon_resource: WeaponResource
var animation_player: AnimationPlayer

func _ready() -> void:
	# Collect all state children
	for child in get_children():
		if child is WeaponStateBase:
			states[child.name.to_lower()] = child
			child.state_machine = self
			child.state_finished.connect(_on_state_finished)
	
	# Set initial state
	if initial_state:
		current_state = initial_state
		current_state._enter()

func _process(delta: float) -> void:
	if current_state:
		current_state._update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state._handle_input(event)

## Transition to a new state by name
func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	var new_state = states.get(state_name.to_lower())
	if not new_state:
		push_warning("WeaponStateMachine: State '%s' not found" % state_name)
		return
	
	if new_state == current_state:
		return
	
	var old_state_name = current_state.name if current_state else "none"
	
	if debug_mode:
		print("WeaponState: %s -> %s" % [old_state_name, state_name])
	
	if current_state:
		current_state._exit()
	
	current_state = new_state
	current_state._enter(msg)
	
	state_changed.emit(old_state_name, state_name)
	SignalBus.weapon_state_changed.emit(state_name)

## Called when a state finishes (e.g., reload complete)
func _on_state_finished(next_state: String) -> void:
	transition_to(next_state)

## Check if in a specific state
func is_in_state(state_name: String) -> bool:
	if not current_state:
		return false
	return current_state.name.to_lower() == state_name.to_lower()

## Get current state name
func get_current_state_name() -> String:
	if current_state:
		return current_state.name
	return ""
