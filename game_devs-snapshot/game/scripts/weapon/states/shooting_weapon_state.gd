## Shooting weapon state
## Handles firing logic and transitions
extends WeaponStateBase

var fire_timer: float = 0.0
var can_fire_next: bool = true

func _enter(_msg: Dictionary = {}) -> void:
	fire_timer = 0.0
	can_fire_next = true
	_fire()

func _exit() -> void:
	fire_timer = 0.0
	can_fire_next = true

func _update(delta: float) -> void:
	var resource = get_weapon_resource()
	if not resource:
		transition_to("idle")
		return
	
	fire_timer += delta
	
	# Check fire rate
	if fire_timer >= resource.fire_rate:
		can_fire_next = true
		fire_timer = 0.0
	
	# Handle fire mode
	match resource.fire_mode:
		WeaponResource.FireMode.SEMI_AUTO:
			_handle_semi_auto()
		WeaponResource.FireMode.FULL_AUTO:
			_handle_full_auto()
		WeaponResource.FireMode.BURST:
			_handle_burst()

func _handle_semi_auto() -> void:
	# Return to idle after single shot
	if not GlobalInput.is_shooting():
		transition_to("idle")
	elif GlobalInput.start_shooting() and can_fire_next:
		if _can_fire():
			_fire()
		else:
			transition_to("idle")

func _handle_full_auto() -> void:
	if not GlobalInput.is_shooting():
		transition_to("idle")
		return
	
	if can_fire_next:
		if _can_fire():
			_fire()
		else:
			transition_to("idle")

func _handle_burst() -> void:
	# TODO: Implement burst fire
	_handle_semi_auto()

func _fire() -> void:
	can_fire_next = false
	
	var controller = get_weapon_controller()
	if controller and controller.has_method("fire"):
		controller.fire()
	
	# Play fire animation
	var anim = get_animation_player()
	if anim and anim.has_animation("shoot"):
		anim.play("shoot")
	
	# Emit signal for other systems
	var resource = get_weapon_resource()
	if resource:
		SignalBus.weapon_fired.emit(resource.display_name)

func _can_fire() -> bool:
	var controller = get_weapon_controller()
	if controller and controller.has_method("can_fire"):
		return controller.can_fire()
	return true
