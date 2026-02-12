extends Node3D
## Level 1: "The Heights" - Broadway, Washington Heights
## Linear southbound progression through 3 zones

# Zone boundaries (Z coordinates, player moves in -Z direction)
const ZONE_1_START := 0.0
const ZONE_2_START := -100.0
const ZONE_3_START := -180.0
const LEVEL_END := -280.0

@export_group("Level Settings")
@export var player_scene: PackedScene
@export var enable_debug_markers := true

@export_group("Atmosphere")
@export var sunset_color := Color(1.0, 0.7, 0.4)
@export var ambient_intensity := 0.3
@export var fog_density := 0.02

# Node references
@onready var player_spawn: Marker3D = $Markers/PlayerSpawn
@onready var level_exit: Marker3D = $Markers/LevelExit
@onready var level_exit_trigger: Area3D = $LevelExitTrigger
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var sun_light: DirectionalLight3D = $DirectionalLight3D

# State tracking
var current_zone := 1
var player: Node3D = null
var level_complete := false

signal zone_entered(zone_number: int)
signal level_completed()


func _ready() -> void:
	_setup_atmosphere()
	_spawn_player()
	_setup_zones()
	_setup_enemies()
	_setup_exit_trigger()
	
	if enable_debug_markers:
		_create_debug_markers()
	
	print("[Level1] 'The Heights' loaded - Starting in Zone 1: Traffic Jam")


func _process(_delta: float) -> void:
	if player and not level_complete:
		_check_zone_transition()
		_check_level_exit()


func _input(event: InputEvent) -> void:
	# ESC returns to main menu or quits
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		get_tree().quit()
		return
	
	# Click to recapture mouse
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _setup_atmosphere() -> void:
	# Configure the late afternoon sunset atmosphere
	if sun_light:
		sun_light.light_color = sunset_color
		sun_light.light_energy = 1.2
		# Angle for long dramatic shadows (sun setting behind GW Bridge)
		sun_light.rotation_degrees = Vector3(-15, 45, 0)
	
	# Environment settings would be configured in the WorldEnvironment node
	# This includes: fog, volumetrics, ambient light
	print("[Level1] Atmosphere configured: Late afternoon sunset")


func _spawn_player() -> void:
	if player_scene:
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = player_spawn.global_position
		print("[Level1] Player spawned at: ", player_spawn.global_position)
	else:
		# Find existing player in scene (for testing)
		player = get_tree().get_first_node_in_group("player")
		if player:
			player.global_position = player_spawn.global_position


func _setup_zones() -> void:
	# Zone-specific setup
	# Zone 1: Tutorial area - lots of car cover
	# Zone 2: Combat encounter - flanking required
	# Zone 3: Commercial strip - destructible cover
	pass


func _setup_enemies() -> void:
	# Configure enemy groups for zone activation
	# Zone 2 enemies (Blockade_47th, Killzone) start deactivated until zone is entered
	# Zone 3 enemies (TSCenter, Hideouts) are deactivated until player enters
	
	var enemies_node := get_node_or_null("Enemies")
	if not enemies_node:
		print("[Level1] Warning: No Enemies node found")
		return
	
	# Zone 2 enemy containers
	var zone2_containers := ["Blockade_47th", "Killzone"]
	var zone2_count := 0
	for container_name in zone2_containers:
		var container := enemies_node.get_node_or_null(container_name)
		if container:
			for enemy in container.get_children():
				enemy.add_to_group("zone2_enemies")
				if enemy.has_method("set_ai_active"):
					enemy.set_ai_active(false)
				zone2_count += 1
	
	# Zone 3 enemy containers
	var zone3_containers := ["TSCenter", "Hideouts"]
	var zone3_count := 0
	for container_name in zone3_containers:
		var container := enemies_node.get_node_or_null(container_name)
		if container:
			for enemy in container.get_children():
				enemy.add_to_group("zone3_enemies")
				if enemy.has_method("set_ai_active"):
					enemy.set_ai_active(false)
				zone3_count += 1
	
	print("[Level1] Enemies configured: ", zone2_count, " in Zone 2, ", zone3_count, " in Zone 3")


func _check_zone_transition() -> void:
	if not player:
		return
	
	var player_z := player.global_position.z
	var new_zone := current_zone
	
	if player_z < ZONE_3_START:
		new_zone = 3
	elif player_z < ZONE_2_START:
		new_zone = 2
	else:
		new_zone = 1
	
	if new_zone != current_zone:
		current_zone = new_zone
		_on_zone_entered(current_zone)


func _on_zone_entered(zone: int) -> void:
	zone_entered.emit(zone)
	
	match zone:
		1:
			print("[Level1] Zone 1: Traffic Jam - Use cars for cover")
		2:
			print("[Level1] Zone 2: The Checkpoint - Flank the MG nest!")
			_trigger_checkpoint_encounter()
		3:
			print("[Level1] Zone 3: Commercial Strip - Reach the subway!")
			_trigger_strip_ambush()
			_trigger_strip_ambiance()


func _trigger_checkpoint_encounter() -> void:
	# Activate AI enemies at the checkpoint
	# The MG nest blocks direct approach - player must flank
	var enemies := get_tree().get_nodes_in_group("zone2_enemies")
	for enemy in enemies:
		if enemy.has_method("set_ai_active"):
			enemy.set_ai_active(true)
			print("[Level1] Activated enemy: ", enemy.name)


func _trigger_strip_ambush() -> void:
	# Activate Zone 3 enemies when player enters the commercial strip
	var enemies := get_tree().get_nodes_in_group("zone3_enemies")
	for enemy in enemies:
		if enemy.has_method("set_ai_active"):
			enemy.set_ai_active(true)
			print("[Level1] Activated Zone 3 enemy: ", enemy.name)


func _trigger_strip_ambiance() -> void:
	# Enable flickering neon signs, ambient sounds
	var neon_signs := get_tree().get_nodes_in_group("neon_signs")
	for sign in neon_signs:
		if sign.has_method("start_flicker"):
			sign.start_flicker()


func _check_level_exit() -> void:
	# Fallback distance check if Area3D signal not triggered
	if not player:
		return
	
	# Only use distance as a fallback - primary detection is via Area3D signal
	var distance_to_exit := player.global_position.distance_to(level_exit.global_position)
	if distance_to_exit < 2.0:
		_complete_level()


func _setup_exit_trigger() -> void:
	# Connect the Area3D body_entered signal for level exit detection
	if level_exit_trigger:
		level_exit_trigger.body_entered.connect(_on_exit_trigger_body_entered)
		print("[Level1] Level exit trigger configured")


func _on_exit_trigger_body_entered(body: Node3D) -> void:
	# Check if the body is the player
	if body == player or body.is_in_group("player"):
		_complete_level()


func _complete_level() -> void:
	if level_complete:
		return
	
	level_complete = true
	level_completed.emit()
	print("[Level1] Level Complete! Transitioning to subway...")
	
	# Transition to next level or safe house
	# get_tree().change_scene_to_file("res://scenes/level_2.tscn")


func _create_debug_markers() -> void:
	# Visual markers for zone boundaries (debug only)
	var zone_markers := [
		{"pos": Vector3(0, 0.5, ZONE_2_START), "label": "ZONE 2"},
		{"pos": Vector3(0, 0.5, ZONE_3_START), "label": "ZONE 3"},
		{"pos": Vector3(0, 0.5, LEVEL_END), "label": "EXIT"},
	]
	
	for marker in zone_markers:
		var debug_box := CSGBox3D.new()
		debug_box.size = Vector3(20, 0.1, 0.5)
		debug_box.position = marker["pos"]
		$Greybox.add_child(debug_box)


# Public API for GameManager integration
func get_player_spawn_point() -> Vector3:
	return player_spawn.global_position if player_spawn else Vector3.ZERO


func get_current_zone() -> int:
	return current_zone


func is_complete() -> bool:
	return level_complete
