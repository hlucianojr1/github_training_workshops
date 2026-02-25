## Test script to verify ThirdPersonCamera C++ class is accessible
## Run this from the command line or attach to a Node to test
extends Node

func _ready() -> void:
	print("=== Testing ThirdPersonCamera C++ Class ===")
	
	# Test 1: Can we instantiate it?
	var camera = ThirdPersonCamera.new()
	if camera:
		print("✓ ThirdPersonCamera instantiated successfully")
	else:
		print("✗ Failed to instantiate ThirdPersonCamera")
		return
	
	# Test 2: Can we call methods?
	var mode = camera.get_camera_mode()
	print("✓ get_camera_mode() works, returned: ", mode)
	
	var is_fps = camera.is_first_person()
	print("✓ is_first_person() works, returned: ", is_fps)
	
	# Test 3: Can we connect to signals?
	camera.camera_mode_changed.connect(_on_camera_mode_changed)
	print("✓ camera_mode_changed signal connected")
	
	# Test 4: Toggle mode
	camera.toggle_camera_mode()
	print("✓ toggle_camera_mode() called")
	
	camera.queue_free()
	print("=== All tests passed! ===")

func _on_camera_mode_changed(mode: int, is_fps: bool) -> void:
	print("Signal received: mode=", mode, " is_fps=", is_fps)
