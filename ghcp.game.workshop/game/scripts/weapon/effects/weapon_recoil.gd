## Weapon recoil effect for FPS viewmodel
## Kicks weapon back on fire and recovers
extends Node3D
class_name WeaponRecoil

@export var enabled: bool = true

@export_group("Position Recoil")
@export var recoil_vertical: float = 0.03
@export var recoil_horizontal: float = 0.01

@export_group("Rotation Recoil")
@export var rotation_recoil_x: float = 2.0  # Degrees
@export var rotation_recoil_y: float = 1.0  # Degrees

@export_group("Recovery")
@export var recovery_speed: float = 8.0
@export var snap_speed: float = 15.0

var target_position: Vector3 = Vector3.ZERO
var target_rotation: Vector3 = Vector3.ZERO
var current_recoil_pos: Vector3 = Vector3.ZERO
var current_recoil_rot: Vector3 = Vector3.ZERO

func _ready() -> void:
	target_position = position
	target_rotation = rotation

func _process(delta: float) -> void:
	if not enabled:
		position = target_position
		rotation = target_rotation
		return
	
	# Recover position recoil
	current_recoil_pos = current_recoil_pos.lerp(Vector3.ZERO, delta * recovery_speed)
	
	# Recover rotation recoil
	current_recoil_rot = current_recoil_rot.lerp(Vector3.ZERO, delta * recovery_speed)
	
	# Apply recoil offset
	position = target_position + current_recoil_pos
	rotation = target_rotation + current_recoil_rot

## Apply recoil kick (call when firing)
func apply_recoil() -> void:
	if not enabled:
		return
	
	# Random horizontal variance
	var h_variance = randf_range(-1.0, 1.0) * recoil_horizontal
	
	# Position kick (backward and up)
	current_recoil_pos.z += recoil_vertical * 2.0  # Backward
	current_recoil_pos.y -= recoil_vertical * 0.5  # Slight down
	current_recoil_pos.x += h_variance
	
	# Rotation kick (tilt up)
	current_recoil_rot.x -= deg_to_rad(rotation_recoil_x)
	current_recoil_rot.y += deg_to_rad(randf_range(-rotation_recoil_y, rotation_recoil_y))

## Configure from weapon resource
func configure(resource: WeaponResource) -> void:
	if resource:
		recoil_vertical = resource.recoil_vertical
		recoil_horizontal = resource.recoil_horizontal
		rotation_recoil_x = resource.recoil_snap_amount * 20.0  # Scale for degrees
		recovery_speed = resource.recoil_recovery_speed
