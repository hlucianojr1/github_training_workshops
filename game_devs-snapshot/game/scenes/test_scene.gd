extends Node3D

func _ready() -> void:
	# PlayerController handles movement + mouse capture.
	pass

func _input(event: InputEvent) -> void:
	# ESC quits the test scene.
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		get_tree().quit()
		return
	
	# Click to recapture mouse
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
