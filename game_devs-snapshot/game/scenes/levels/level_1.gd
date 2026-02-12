extends Node3D

@onready var camera: Camera3D = $Camera3D

var move_speed: float = 10.0
var look_sensitivity: float = 0.003
var pitch: float = -20.0  # Starting pitch (looking down)
var yaw: float = 0.0

func _ready():
	print("Level 1: Washington Heights Loaded")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().quit()
	
	# Mouse look
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * look_sensitivity
		pitch -= event.relative.y * look_sensitivity
		pitch = clamp(pitch, -89.0, 89.0)
		camera.rotation_degrees = Vector3(pitch, yaw, 0)

func _process(delta: float) -> void:
	var input_dir := Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	
	# Move up/down with jump/crouch
	if Input.is_action_pressed("jump"):
		input_dir.y += 1
	if Input.is_action_pressed("crouch"):
		input_dir.y -= 1
	
	# Sprint modifier
	var speed = move_speed
	if Input.is_action_pressed("sprint"):
		speed *= 2.0
	
	# Transform direction relative to camera orientation
	input_dir = input_dir.normalized()
	var direction = camera.global_transform.basis * input_dir
	camera.global_position += direction * speed * delta
