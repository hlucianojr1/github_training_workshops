## Player Weapon Bridge
## Connects the FPS weapon viewport to the C++ weapon logic
extends Node

@onready var player = get_parent()
@onready var cpp_weapon = player.get_node_or_null("Weapon")
@onready var fps_viewport = player.get_node_or_null("FPSWeaponViewport")
var fps_weapon_controller: Node3D

func _ready() -> void:
	# Wait for scene to be fully ready
	await get_tree().process_frame
	
	# Find FPS weapon controller
	if fps_viewport:
		var weapon_rig = fps_viewport.get_node_or_null("SubViewport/WeaponCamera/WeaponRig")
		if weapon_rig:
			for child in weapon_rig.get_children():
				if child.has_method("fire"):  # Duck typing check for FPSWeaponController
					fps_weapon_controller = child
					break
	
	if fps_weapon_controller and cpp_weapon:
		# Link the two together
		fps_weapon_controller.cpp_weapon = cpp_weapon
		print("[Player Weapon Bridge] Linked FPS controller to C++ weapon")
	else:
		if not fps_weapon_controller:
			push_warning("[Player Weapon Bridge] FPS weapon controller not found")
		if not cpp_weapon:
			push_warning("[Player Weapon Bridge] C++ weapon not found")
