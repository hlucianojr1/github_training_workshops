## Crosshair - Dynamic reticle that responds to player state
## 
## Features:
## - Expands during movement and firing
## - Changes color when hovering over enemies
## - Supports spread adjustment

extends Control

## Crosshair appearance
@export var default_color: Color = Color.WHITE
@export var enemy_color: Color = Color.RED
@export var line_thickness: float = 2.0
@export var base_gap: float = 10.0
@export var line_length: float = 8.0

## Dynamic spread
var current_spread: float = 0.0
var target_spread: float = 0.0
@export var spread_smoothing: float = 10.0
var is_fps_mode: bool = false

## Crosshair properties (settable from C++)
var spread: float = 0.0:
	set(value):
		spread = value
		target_spread = value

func _ready() -> void:
	# Make sure we're on top
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	# Connect to SignalBus
	if SignalBus:
		SignalBus.camera_mode_changed.connect(_on_camera_mode_changed)
		SignalBus.weapon_fired.connect(_on_weapon_fired)

func _process(delta: float) -> void:
	# Smooth spread changes
	current_spread = lerp(current_spread, target_spread, spread_smoothing * delta)
	
	# Auto-decay spread when not firing
	if target_spread > 0:
		target_spread = max(0, target_spread - delta * 15.0)
	
	queue_redraw()

func _on_camera_mode_changed(is_fps: bool) -> void:
	is_fps_mode = is_fps
	# Crosshair is more important in FPS mode
	modulate.a = 1.0 if is_fps else 0.7

func _on_weapon_fired(_weapon_name: String) -> void:
	# Expand crosshair on fire
	target_spread += 5.0

func _draw() -> void:
	var center := Vector2.ZERO
	var gap := base_gap + current_spread
	var length := line_length
	
	# Draw four lines forming a cross
	# Top
	draw_line(Vector2(center.x, center.y - gap), 
	          Vector2(center.x, center.y - gap - length),
	          modulate, line_thickness)
	
	# Bottom
	draw_line(Vector2(center.x, center.y + gap), 
	          Vector2(center.x, center.y + gap + length),
	          modulate, line_thickness)
	
	# Left
	draw_line(Vector2(center.x - gap, center.y), 
	          Vector2(center.x - gap - length, center.y),
	          modulate, line_thickness)
	
	# Right
	draw_line(Vector2(center.x + gap, center.y), 
	          Vector2(center.x + gap + length, center.y),
	          modulate, line_thickness)
