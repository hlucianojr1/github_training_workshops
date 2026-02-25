## Idle weapon state
## Default state when not shooting or reloading
extends WeaponStateBase

func _enter(_msg: Dictionary = {}) -> void:
	var anim = get_animation_player()
	if anim and anim.has_animation("idle"):
		anim.play("idle")

func _update(_delta: float) -> void:
	# Check for shoot input
	if GlobalInput.start_shooting():
		var resource = get_weapon_resource()
		if resource:
			if _can_fire():
				transition_to("shooting")
			else:
				_play_empty_sound()
	
	# Check for reload input
	if GlobalInput.is_reloading():
		if _should_reload():
			transition_to("reloading")

func _can_fire() -> bool:
	var controller = get_weapon_controller()
	if controller and controller.has_method("can_fire"):
		return controller.can_fire()
	return true

func _should_reload() -> bool:
	var controller = get_weapon_controller()
	if controller and controller.has_method("needs_reload"):
		return controller.needs_reload()
	return false

func _play_empty_sound() -> void:
	var resource = get_weapon_resource()
	if resource and resource.sound_empty:
		# Play empty click sound via weapon controller
		var controller = get_weapon_controller()
		if controller and controller.has_method("play_sound"):
			controller.play_sound(resource.sound_empty)
