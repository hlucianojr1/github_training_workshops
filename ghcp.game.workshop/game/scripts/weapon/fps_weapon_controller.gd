## FPS Weapon Controller
## Manages the first-person weapon view, effects, and state machine
extends Node3D
class_name FPSWeaponController

signal weapon_fired(weapon_id: String)
signal weapon_reloaded(weapon_id: String)
signal ammo_changed(current: int, reserve: int)

@export var weapon_resource: WeaponResource
@export var cpp_weapon: Node  # Reference to C++ Weapon node

@export_group("Components")
@export var weapon_model: Node3D
@export var animation_player: AnimationPlayer
@export var audio_player: AudioStreamPlayer3D

# Effect nodes (auto-created if not assigned)
var sway_node: WeaponSway
var bob_node: WeaponBob
var recoil_node: WeaponRecoil
var muzzle_flash: MuzzleFlash

# State machine
var state_machine: WeaponStateMachine

# Aiming
var is_aiming: bool = false
var aim_lerp: float = 0.0
var default_position: Vector3
var default_rotation: Vector3

func _ready() -> void:
	_setup_effects()
	_setup_state_machine()
	_configure_from_resource()
	
	default_position = position
	default_rotation = rotation
	
	# Connect to camera mode changes
	if SignalBus:
		SignalBus.camera_mode_changed.connect(_on_camera_mode_changed)

func _process(delta: float) -> void:
	_update_aim(delta)
	_update_movement_state()

func _setup_effects() -> void:
	# Create sway node
	sway_node = get_node_or_null("Sway") as WeaponSway
	if not sway_node:
		sway_node = WeaponSway.new()
		sway_node.name = "Sway"
		add_child(sway_node)
	
	# Create bob node as child of sway
	bob_node = sway_node.get_node_or_null("Bob") as WeaponBob
	if not bob_node:
		bob_node = WeaponBob.new()
		bob_node.name = "Bob"
		sway_node.add_child(bob_node)
	
	# Create recoil node as child of bob
	recoil_node = bob_node.get_node_or_null("Recoil") as WeaponRecoil
	if not recoil_node:
		recoil_node = WeaponRecoil.new()
		recoil_node.name = "Recoil"
		bob_node.add_child(recoil_node)
	
	# Move weapon model under recoil
	if weapon_model and weapon_model.get_parent() != recoil_node:
		var old_transform = weapon_model.global_transform
		weapon_model.reparent(recoil_node)
		weapon_model.global_transform = old_transform

func _setup_state_machine() -> void:
	state_machine = get_node_or_null("WeaponStateMachine") as WeaponStateMachine
	if state_machine:
		state_machine.weapon_controller = self
		state_machine.weapon_resource = weapon_resource
		state_machine.animation_player = animation_player

func _configure_from_resource() -> void:
	if not weapon_resource:
		return
	
	sway_node.configure(weapon_resource)
	bob_node.configure(weapon_resource)
	recoil_node.configure(weapon_resource)
	
	# Setup muzzle flash
	if weapon_model:
		var muzzle_point = weapon_model.get_node_or_null("MuzzlePoint")
		if muzzle_point:
			muzzle_flash = muzzle_point.get_node_or_null("MuzzleFlash") as MuzzleFlash
			if not muzzle_flash:
				muzzle_flash = MuzzleFlash.new()
				muzzle_flash.name = "MuzzleFlash"
				muzzle_point.add_child(muzzle_flash)
			muzzle_flash.configure(weapon_resource)

func _update_aim(delta: float) -> void:
	if not weapon_resource:
		return
	
	is_aiming = GlobalInput.is_aiming()
	
	var target_lerp = 1.0 if is_aiming else 0.0
	aim_lerp = lerp(aim_lerp, target_lerp, delta * weapon_resource.aim_speed)
	
	# Lerp position/rotation for ADS
	var aim_pos = weapon_resource.aim_position
	var aim_rot = weapon_resource.aim_rotation
	
	position = default_position.lerp(aim_pos, aim_lerp)
	rotation = default_rotation.lerp(aim_rot, aim_lerp)
	
	# Reduce sway when aiming
	if sway_node:
		sway_node.sway_amount = weapon_resource.sway_amount * (1.0 - aim_lerp * 0.7)

func _update_movement_state() -> void:
	if bob_node:
		bob_node.set_movement_state(
			GlobalInput.is_moving(),
			GlobalInput.is_sprinting(),
			GlobalInput.is_crouching()
		)

## Called by shooting state to fire weapon
func fire() -> void:
	# Call C++ weapon if available
	if cpp_weapon and cpp_weapon.has_method("fire"):
		cpp_weapon.fire()
	
	# Apply effects
	if recoil_node:
		recoil_node.apply_recoil()
	
	if muzzle_flash:
		muzzle_flash.trigger()
	
	# Play sound
	if weapon_resource and weapon_resource.sound_fire:
		play_sound(weapon_resource.sound_fire)
	
	weapon_fired.emit(weapon_resource.weapon_id if weapon_resource else "unknown")
	
	# Emit ammo update
	_emit_ammo_update()

## Check if can fire (delegates to C++ weapon)
func can_fire() -> bool:
	if cpp_weapon and cpp_weapon.has_method("can_fire"):
		return cpp_weapon.can_fire()
	return true

## Check if needs reload
func needs_reload() -> bool:
	if cpp_weapon and cpp_weapon.has_method("get_current_ammo"):
		var current = cpp_weapon.get_current_ammo()
		var max_ammo = weapon_resource.magazine_size if weapon_resource else 0
		return current < max_ammo
	return false

## Perform reload (delegates to C++ weapon)
func reload() -> void:
	if cpp_weapon and cpp_weapon.has_method("reload"):
		cpp_weapon.reload()
	
	weapon_reloaded.emit(weapon_resource.weapon_id if weapon_resource else "unknown")
	
	# Emit ammo update
	_emit_ammo_update()

## Play audio
func play_sound(stream: AudioStream) -> void:
	if audio_player and stream:
		audio_player.stream = stream
		audio_player.play()

func _on_camera_mode_changed(is_fps: bool) -> void:
	# Show/hide FPS weapon based on camera mode
	visible = is_fps

## Emit ammo update to SignalBus
func _emit_ammo_update() -> void:
	var current = 0
	var reserve = 0
	var max_mag = weapon_resource.magazine_size if weapon_resource else 0
	
	if cpp_weapon:
		if cpp_weapon.has_method("get_current_ammo"):
			current = cpp_weapon.get_current_ammo()
		if cpp_weapon.has_method("get_reserve_ammo"):
			reserve = cpp_weapon.get_reserve_ammo()
	
	ammo_changed.emit(current, reserve)
	SignalBus.ammo_changed.emit(current, reserve, max_mag)
