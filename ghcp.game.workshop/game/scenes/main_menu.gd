extends Control

func _ready() -> void:
	# Connect button signals
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
	# Grab focus for keyboard/controller navigation
	$VBoxContainer/StartButton.grab_focus()

func _on_start_pressed() -> void:
	print("Starting game...")
	# Load the test scene
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_options_pressed() -> void:
	print("Options pressed - not implemented yet")
	# TODO: Show options menu

func _on_quit_pressed() -> void:
	print("Quitting game...")
	get_tree().quit()
