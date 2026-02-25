## Weapon sway effect for FPS viewmodel
## Moves weapon based on mouse movement and idle breathing
extends Node3D
class_name WeaponSway

@export var enabled: bool = true

@export_group("Mouse Sway")
@export var sway_amount: float = 0.02
@export var sway_max: float = 0.08
@export var sway_speed: float = 5.0

@export_group("Idle Sway")
@export var idle_sway_enabled: bool = true
@export var idle_sway_amount: float = 0.002
@export var idle_sway_speed: float = 1.0

var target_position: Vector3 = Vector3.ZERO
var idle_time: float = 0.0

func _ready() -> void:
	target_position = position

func _process(delta: float) -> void:
	if not enabled:
		position = position.lerp(target_position, delta * sway_speed)
		return
	
	var sway_offset = Vector3.ZERO
	
	# Mouse sway
	var mouse_delta = Input.get_last_mouse_velocity() * 0.001
	sway_offset.x = clamp(-mouse_delta.x * sway_amount, -sway_max, sway_max)
	sway_offset.y = clamp(-mouse_delta.y * sway_amount, -sway_max, sway_max)
	
	# Idle sway (breathing effect)
	if idle_sway_enabled:
		idle_time += delta * idle_sway_speed
		var idle_x = sin(idle_time * 1.1) * idle_sway_amount
		var idle_y = sin(idle_time * 0.9) * idle_sway_amount * 0.5
		sway_offset.x += idle_x
		sway_offset.y += idle_y
	
	# Apply sway
	var final_position = target_position + sway_offset
	position = position.lerp(final_position, delta * sway_speed)

## Configure from weapon resource
func configure(resource: WeaponResource) -> void:
	if resource:
		enabled = resource.sway_enabled
		sway_amount = resource.sway_amount
		sway_max = resource.sway_max
		sway_speed = resource.sway_speed
		idle_sway_enabled = resource.idle_sway_enabled
		idle_sway_amount = resource.idle_sway_amount
		idle_sway_speed = resource.idle_sway_speed
