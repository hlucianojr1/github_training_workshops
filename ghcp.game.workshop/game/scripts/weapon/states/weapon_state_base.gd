## Base class for weapon states
## Extend this for each weapon state (idle, shooting, reloading)
extends Node
class_name WeaponStateBase

signal state_finished(next_state: String)

var state_machine: WeaponStateMachine

## Called when entering this state
func _enter(_msg: Dictionary = {}) -> void:
	pass

## Called when exiting this state
func _exit() -> void:
	pass

## Called every frame
func _update(_delta: float) -> void:
	pass

## Called every physics frame
func _physics_update(_delta: float) -> void:
	pass

## Handle input events
func _handle_input(_event: InputEvent) -> void:
	pass

## Convenience accessors
func get_weapon_resource() -> WeaponResource:
	return state_machine.weapon_resource

func get_weapon_controller() -> Node3D:
	return state_machine.weapon_controller

func get_animation_player() -> AnimationPlayer:
	return state_machine.animation_player

func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	state_machine.transition_to(state_name, msg)
