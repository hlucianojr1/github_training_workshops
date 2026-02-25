## Global signal bus for Urban Survivor
## Allows decoupled communication between systems
extends Node

# Player signals
signal player_health_changed(current: float, max_health: float)
signal player_stamina_changed(current: float, max_stamina: float)
signal player_died()
signal player_respawned()

# Camera signals
signal camera_mode_changed(is_first_person: bool)

# Weapon signals
signal weapon_fired(weapon_name: String)
signal weapon_reloaded(weapon_name: String)
signal weapon_switched(old_weapon: String, new_weapon: String)
signal ammo_changed(current: int, reserve: int, max_mag: int)
signal weapon_state_changed(state_name: String)

# Combat signals
signal damage_dealt(target: Node, amount: float, is_critical: bool)
signal damage_taken(source: Node, amount: float)
signal enemy_killed(enemy: Node)

# Interaction signals
signal interaction_available(target: Node, prompt: String)
signal interaction_unavailable()
signal item_picked_up(item_id: String, quantity: int)

# UI signals
signal show_notification(message: String, duration: float)
signal show_damage_indicator(direction: Vector3)
signal update_crosshair(state: String)  # "default", "hit", "enemy"

# Game state signals
signal game_paused()
signal game_resumed()
signal level_loaded(level_name: String)
