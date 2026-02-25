## Global input helper for Urban Survivor
## Adapted from Godot-FPS-Template pattern
extends Node

# Movement
func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

func is_moving() -> bool:
	return get_move_vector().length() > 0.1

# Actions
func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump")

func is_released_jump() -> bool:
	return Input.is_action_just_released("jump")

func is_sprinting() -> bool:
	return Input.is_action_pressed("sprint")

func stop_sprinting() -> bool:
	return Input.is_action_just_released("sprint")

func is_crouching() -> bool:
	return Input.is_action_pressed("crouch")

func stop_crouching() -> bool:
	return Input.is_action_just_released("crouch")

# Combat
func is_shooting() -> bool:
	return Input.is_action_pressed("shoot")

func start_shooting() -> bool:
	return Input.is_action_just_pressed("shoot")

func stop_shooting() -> bool:
	return Input.is_action_just_released("shoot")

func is_aiming() -> bool:
	return Input.is_action_pressed("aim")

func start_aiming() -> bool:
	return Input.is_action_just_pressed("aim")

func stop_aiming() -> bool:
	return Input.is_action_just_released("aim")

func is_reloading() -> bool:
	return Input.is_action_just_pressed("reload")

# Interaction
func is_interacting() -> bool:
	return Input.is_action_just_pressed("interact")

# Camera
func is_toggle_camera() -> bool:
	return Input.is_action_just_pressed("toggle_camera")

# UI
func is_pausing() -> bool:
	return Input.is_action_just_pressed("pause")

func is_inventory() -> bool:
	return Input.is_action_just_pressed("inventory")
