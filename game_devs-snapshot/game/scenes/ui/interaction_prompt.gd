## InteractionPrompt - Shows context-sensitive interaction hints
##
## Features:
## - "Press E to..." prompts near interactables
## - Shows item name
## - Fades based on distance from interactable
## - Auto-hides when not looking at anything

extends Label

## Settings
@export var max_distance: float = 3.0  # Maximum interaction distance
@export var fade_start_distance: float = 2.0  # Distance where fade begins
@export var prompt_format: String = "Press [E] to {action}"

## References
var player: Node = null
var camera: Camera3D = null

## Current state
var current_interactable: Node = null
var is_showing: bool = false

func _ready() -> void:
	# Start hidden
	modulate.a = 0.0
	
	# Find player and camera
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		camera = _find_camera(player)
		if not camera:
			push_warning("[InteractionPrompt] No camera found on player")
	else:
		push_warning("[InteractionPrompt] No player found in 'player' group")

func _find_camera(node: Node) -> Camera3D:
	# Search for Camera3D in player's children
	for child in node.get_children():
		if child is Camera3D:
			return child
		var result = _find_camera(child)
		if result:
			return result
	return null

func _process(_delta: float) -> void:
	if not camera or not player:
		return
	
	# Raycast from camera to check for interactables
	var space_state := camera.get_world_3d().direct_space_state
	var from := camera.global_position
	var to := from + (-camera.global_transform.basis.z * max_distance)
	
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1  # Adjust based on your collision layers
	
	var result := space_state.intersect_ray(query)
	
	if result:
		var collider: Node3D = result.collider as Node3D
		if collider == null:
			_hide_prompt()
			return
		
		# Check if the collider is interactable (has interact method or is in interactable group)
		if collider.has_method("interact") or collider.is_in_group("interactable"):
			_show_prompt(collider, result.position)
			return
	
	# No interactable found
	_hide_prompt()

func _show_prompt(interactable: Node, position: Vector3) -> void:
	current_interactable = interactable
	
	# Get action text
	var action_text := "Interact"
	if interactable.has_method("get_interaction_text"):
		action_text = interactable.get_interaction_text()
	elif interactable.has_method("get_item_name"):
		action_text = "Pick up " + interactable.get_item_name()
	
	# Update prompt text
	text = prompt_format.format({"action": action_text})
	
	# Calculate distance fade
	var distance := camera.global_position.distance_to(position)
	var fade := 1.0
	
	if distance > fade_start_distance:
		var fade_range := max_distance - fade_start_distance
		var fade_progress := (distance - fade_start_distance) / fade_range
		fade = 1.0 - clamp(fade_progress, 0.0, 1.0)
	
	modulate.a = fade
	is_showing = true

func _hide_prompt() -> void:
	if is_showing:
		modulate.a = 0.0
		is_showing = false
		current_interactable = null

func force_hide() -> void:
	_hide_prompt()
