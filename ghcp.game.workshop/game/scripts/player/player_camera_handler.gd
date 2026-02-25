## Player Camera Handler
## Manages camera mode switching and visibility updates
extends ThirdPersonCamera

@onready var player = get_parent() as Node3D
@onready var fps_viewport = player.get_node_or_null("FPSWeaponViewport") as Control
@onready var player_mesh = player.get_node_or_null("SavageModel") as Node3D

func _ready() -> void:
	# Note: C++ base class _ready() is called automatically in Godot 4.x
	# No need to call super._ready() explicitly
	
	# Connect camera mode change signal
	camera_mode_changed.connect(_on_camera_mode_changed)
	
	# Initial state
	_on_camera_mode_changed(get_camera_mode(), is_first_person())

func _process(delta: float) -> void:
	# Check for camera toggle input
	if GlobalInput.is_toggle_camera():
		toggle_camera_mode()

func _on_camera_mode_changed(mode: int, is_fps: bool) -> void:
	print("Camera mode changed: ", "FPS" if is_fps else "TPS")
	
	# Show/hide FPS weapon viewport
	if fps_viewport:
		fps_viewport.visible = is_fps
	
	# Hide player mesh in FPS mode (TODO: proper head hiding when mesh has skeleton)
	if player_mesh:
		# For now, hide the entire mesh in FPS
		# In production, you'd hide only the head bone via Skeleton3D
		player_mesh.visible = not is_fps
	
	# Emit to signal bus for HUD updates
	SignalBus.camera_mode_changed.emit(is_fps)
