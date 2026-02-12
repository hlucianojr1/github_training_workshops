## Reloading weapon state
## Handles reload animation and ammo replenishment
## Works with C++ Weapon reload state machine
extends WeaponStateBase

## Reload state enum (mirrors C++ ReloadState)
enum ReloadState {
	IDLE = 0,
	EJECTING_MAG = 1,
	INSERTING_MAG = 2,
	CHAMBERING = 3,
	READY = 4
}

var reload_timer: float = 0.0
var reload_duration: float = 1.5
var reload_complete: bool = false
var is_dry_reload: bool = false

func _enter(_msg: Dictionary = {}) -> void:
	reload_timer = 0.0
	reload_complete = false
	
	var resource = get_weapon_resource()
	if resource:
		reload_duration = resource.reload_time
	
	# Check if this is a dry reload (empty mag) from C++ weapon
	var controller = get_weapon_controller()
	if controller and controller.cpp_weapon:
		var cpp_weapon = controller.cpp_weapon
		if cpp_weapon.has_method("is_dry_reload"):
			is_dry_reload = cpp_weapon.is_dry_reload()
		# Start reload in C++ weapon (manages state machine)
		if cpp_weapon.has_method("start_reload"):
			cpp_weapon.start_reload()
	
	# Play reload animation (use dry_reload animation if available and needed)
	var anim = get_animation_player()
	if anim:
		var anim_name = "reload_dry" if is_dry_reload and anim.has_animation("reload_dry") else "reload"
		if anim.has_animation(anim_name):
			anim.play(anim_name)
	
	# Play reload sound
	if resource and resource.sound_reload:
		if controller and controller.has_method("play_sound"):
			controller.play_sound(resource.sound_reload)

func _exit() -> void:
	reload_timer = 0.0
	is_dry_reload = false

func _update(delta: float) -> void:
	reload_timer += delta
	
	# Check if reload is complete (C++ handles the actual state transitions)
	if reload_timer >= reload_duration and not reload_complete:
		reload_complete = true
		_complete_reload()
		state_finished.emit("idle")

func _complete_reload() -> void:
	# C++ weapon handles the actual ammo transfer via its state machine
	# We just emit signals for UI/audio feedback
	var resource = get_weapon_resource()
	if resource:
		SignalBus.weapon_reloaded.emit(resource.display_name)

## Allow canceling reload with fire (for some games)
func _handle_input(event: InputEvent) -> void:
	# Optional: allow sprint to cancel reload
	if GlobalInput.is_sprinting():
		_cancel_reload()
		transition_to("idle")

func _cancel_reload() -> void:
	var controller = get_weapon_controller()
	if controller and controller.cpp_weapon:
		var cpp_weapon = controller.cpp_weapon
		if cpp_weapon.has_method("cancel_reload"):
			cpp_weapon.cancel_reload()
