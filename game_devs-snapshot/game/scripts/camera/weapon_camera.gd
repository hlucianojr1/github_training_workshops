## Weapon Camera - Syncs with main camera for FPS weapon rendering
## Used in SubViewport setup for separate weapon rendering layer
extends Camera3D

@export var main_camera: Camera3D
@export var auto_find_main_camera: bool = true

func _ready() -> void:
	if auto_find_main_camera and not main_camera:
		# Try to find main camera in scene
		var cameras = get_tree().get_nodes_in_group("main_camera")
		if cameras.size() > 0:
			main_camera = cameras[0] as Camera3D

func _process(_delta: float) -> void:
	if main_camera:
		global_transform = main_camera.global_transform
		fov = main_camera.fov
