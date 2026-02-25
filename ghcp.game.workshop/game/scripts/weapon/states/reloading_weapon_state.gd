## Reloading weapon state
## Handles reload animation and ammo replenishment
extends WeaponStateBase

var reload_timer: float = 0.0
var reload_duration: float = 1.5
var reload_complete: bool = false

func _enter(_msg: Dictionary = {}) -> void:
	reload_timer = 0.0
	reload_complete = false
	
	var resource = get_weapon_resource()
	if resource:
		reload_duration = resource.reload_time
	
	# Play reload animation
	var anim = get_animation_player()
	if anim and anim.has_animation("reload"):
		anim.play("reload")
	
	# Play reload sound
	if resource and resource.sound_reload:
		var controller = get_weapon_controller()
		if controller and controller.has_method("play_sound"):
			controller.play_sound(resource.sound_reload)

func _exit() -> void:
	reload_timer = 0.0

func _update(delta: float) -> void:
	reload_timer += delta
	
	# Check if reload is complete
	if reload_timer >= reload_duration and not reload_complete:
		reload_complete = true
		_complete_reload()
		state_finished.emit("idle")

func _complete_reload() -> void:
	var controller = get_weapon_controller()
	if controller and controller.has_method("reload"):
		controller.reload()
	
	var resource = get_weapon_resource()
	if resource:
		SignalBus.weapon_reloaded.emit(resource.display_name)

## Allow canceling reload with fire (for some games)
func _handle_input(event: InputEvent) -> void:
	# Optional: allow sprint to cancel reload
	pass
