## HUD Controller - GDScript signal bridge for C++ HUD class
##
## Connects signals from DamageSystem, Weapon, and SurvivalStats to the HUD C++ update methods.
## This script extends the HUD C++ class and wires up all real-time updates for the Vertical Slice.

extends HUD

## References to game systems
var player: Node = null
var weapon: Node = null
var survival_stats: Node = null
var damage_system: Node = null

func _ready() -> void:
	print("[HUD Controller] Initializing signal connections...")
	
	# Wait a frame for the scene tree to be fully ready
	await get_tree().process_frame
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("[HUD Controller] No player found in 'player' group. Health/ammo updates won't work.")
		return
	
	print("[HUD Controller] Player found: ", player.name)
	
	# Connect to SurvivalStats (child of player)
	survival_stats = player.get_node_or_null("SurvivalStats")
	if survival_stats:
		if survival_stats.has_signal("health_changed"):
			survival_stats.health_changed.connect(_on_health_changed)
			print("[HUD Controller] Connected to SurvivalStats.health_changed")
			
			# Initialize with current values
			var current_health: float = survival_stats.get_health()
			var max_health: float = survival_stats.get_max_health()
			update_health(current_health, max_health)
			print("[HUD Controller] Initial health: ", current_health, "/", max_health)
		else:
			push_warning("[HUD Controller] SurvivalStats doesn't have 'health_changed' signal")
		
		if survival_stats.has_signal("stamina_changed"):
			survival_stats.stamina_changed.connect(_on_stamina_changed)
			print("[HUD Controller] Connected to SurvivalStats.stamina_changed")
			
			# Initialize with current values
			var current_stamina: float = survival_stats.get_stamina()
			var max_stamina: float = survival_stats.get_max_stamina()
			update_stamina(current_stamina, max_stamina)
			print("[HUD Controller] Initial stamina: ", current_stamina, "/", max_stamina)
		else:
			push_warning("[HUD Controller] SurvivalStats doesn't have 'stamina_changed' signal")
	else:
		push_warning("[HUD Controller] No SurvivalStats found on player")
	
	# Connect to equipped weapon (assumes player has an equipped_weapon variable or getter)
	# Try multiple common patterns for weapon access
	weapon = _find_player_weapon()
	
	if weapon:
		if weapon.has_signal("ammo_changed"):
			weapon.ammo_changed.connect(_on_ammo_changed)
			print("[HUD Controller] Connected to Weapon.ammo_changed")
			
			# Initialize with current values
			var mag_ammo: int = weapon.get_current_mag_ammo()
			var reserve_ammo: int = weapon.get_reserve_ammo()
			update_ammo(mag_ammo, reserve_ammo)
			print("[HUD Controller] Initial ammo: ", mag_ammo, "/", reserve_ammo)
		else:
			push_warning("[HUD Controller] Weapon doesn't have 'ammo_changed' signal")
	else:
		push_warning("[HUD Controller] No weapon found on player. Ammo display won't update.")
	
	# Connect to SignalBus for weapon events
	if SignalBus:
		SignalBus.ammo_changed.connect(_on_signalbus_ammo_changed)
		SignalBus.weapon_fired.connect(_on_weapon_fired)
		SignalBus.weapon_reloaded.connect(_on_weapon_reloaded)
		print("[HUD Controller] Connected to SignalBus weapon events")
	
	# Try to get DamageSystem singleton/autoload
	damage_system = _find_damage_system()
	
	if damage_system:
		if damage_system.has_signal("damage_dealt"):
			damage_system.damage_dealt.connect(_on_damage_dealt)
			print("[HUD Controller] Connected to DamageSystem.damage_dealt")
		else:
			push_warning("[HUD Controller] DamageSystem doesn't have 'damage_dealt' signal")
	else:
		push_warning("[HUD Controller] DamageSystem not found. Won't listen for damage events.")
	
	print("[HUD Controller] Setup complete.")

## Find the player's equipped weapon using multiple strategies
func _find_player_weapon() -> Node:
	if not player:
		return null
	
	# Strategy 1: Check for weapon child node
	var weapon_node = player.get_node_or_null("Weapon")
	if weapon_node:
		print("[HUD Controller] Found weapon as child 'Weapon'")
		return weapon_node
	
	# Strategy 2: Search in player's children for Weapon type
	for child in player.get_children():
		if child.is_class("Weapon") or child.get_class() == "Weapon":
			print("[HUD Controller] Found weapon child: ", child.name)
			return child
	
	# Strategy 3: Look in a typical weapon holder path
	var weapon_holder = player.get_node_or_null("WeaponHolder/Weapon")
	if weapon_holder:
		print("[HUD Controller] Found weapon via WeaponHolder")
		return weapon_holder
	
	return null

## Find DamageSystem using multiple strategies
func _find_damage_system() -> Node:
	# Strategy 1: Check for autoload named DamageSystem
	var autoload_ds := get_node_or_null("/root/DamageSystem")
	if autoload_ds:
		print("[HUD Controller] Found DamageSystem autoload")
		return autoload_ds
	
	# Strategy 2: Search in scene tree
	var found = get_tree().get_first_node_in_group("damage_system")
	if found:
		print("[HUD Controller] Found DamageSystem in 'damage_system' group")
		return found
	
	return null

## Called when the player's health changes
func _on_health_changed(current: float, maximum: float) -> void:
	update_health(current, maximum)

## Called when the player's stamina changes
func _on_stamina_changed(current: float, maximum: float) -> void:
	update_stamina(current, maximum)

## Called when the weapon's ammo changes
func _on_ammo_changed(mag_ammo: int, reserve: int) -> void:
	update_ammo(mag_ammo, reserve)

## Called via SignalBus when FPS weapon ammo changes
func _on_signalbus_ammo_changed(current: int, reserve: int, _max_mag: int) -> void:
	update_ammo(current, reserve)

## Called when weapon fires (for visual feedback)
func _on_weapon_fired(_weapon_name: String) -> void:
	# Optional: Trigger muzzle flash indicator or crosshair expansion
	pass

## Called when weapon reloads (for visual feedback)
func _on_weapon_reloaded(_weapon_name: String) -> void:
	# Optional: Show reload indicator
	pass

## Called when any entity takes damage (filter for player)
func _on_damage_dealt(target: Node, amount: float, type: int, source: Node) -> void:
	# Only update HUD if the player is the target
	if target == player:
		# Health will be updated via SurvivalStats.health_changed signal
		# This is just for debug feedback
		print("[HUD Controller] Player took ", amount, " damage from ", source.name if source else "unknown")
		
		# Optional: Could trigger visual damage feedback here
		# _flash_damage_indicator()
