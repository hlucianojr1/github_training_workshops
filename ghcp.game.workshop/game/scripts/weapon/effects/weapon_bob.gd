## Weapon bob effect for FPS viewmodel
## Moves weapon up/down based on player movement
extends Node3D
class_name WeaponBob

@export var enabled: bool = true

@export_group("Walk Bob")
@export var bob_frequency: float = 2.0
@export var bob_amplitude: float = 0.03

@export_group("Sprint Bob")
@export var sprint_frequency: float = 2.8
@export var sprint_amplitude: float = 0.05

@export_group("Crouch Bob")
@export var crouch_frequency: float = 1.5
@export var crouch_amplitude: float = 0.015

@export_group("Smoothing")
@export var bob_speed: float = 8.0

var bob_time: float = 0.0
var target_position: Vector3 = Vector3.ZERO
var is_moving: bool = false
var is_sprinting: bool = false
var is_crouching: bool = false

func _ready() -> void:
	target_position = position

func _process(delta: float) -> void:
	if not enabled:
		position = position.lerp(target_position, delta * bob_speed)
		return
	
	var bob_offset = Vector3.ZERO
	
	if is_moving:
		# Select frequency and amplitude based on movement state
		var freq: float
		var amp: float
		
		if is_crouching:
			freq = crouch_frequency
			amp = crouch_amplitude
		elif is_sprinting:
			freq = sprint_frequency
			amp = sprint_amplitude
		else:
			freq = bob_frequency
			amp = bob_amplitude
		
		bob_time += delta * freq * TAU
		
		# Figure-8 bob pattern
		bob_offset.x = sin(bob_time * 0.5) * amp * 0.5
		bob_offset.y = abs(sin(bob_time)) * amp
	else:
		# Slowly return to center when not moving
		bob_time = lerp(bob_time, 0.0, delta * 2.0)
	
	# Apply bob
	var final_position = target_position + bob_offset
	position = position.lerp(final_position, delta * bob_speed)

## Update movement state (call from player controller)
func set_movement_state(moving: bool, sprinting: bool = false, crouching: bool = false) -> void:
	is_moving = moving
	is_sprinting = sprinting
	is_crouching = crouching

## Configure from weapon resource
func configure(resource: WeaponResource) -> void:
	if resource:
		enabled = resource.bob_enabled
		bob_frequency = resource.bob_frequency
		bob_amplitude = resource.bob_amplitude
