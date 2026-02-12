## Weapon resource definition for Urban Survivor
## Defines all properties for a weapon type
@tool
extends Resource
class_name WeaponResource

@export_group("Identity")
@export var weapon_id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D

@export_group("Scenes")
@export var fps_scene: PackedScene  # First-person viewmodel
@export var tps_scene: PackedScene  # Third-person world model
@export var pickup_scene: PackedScene  # World pickup

@export_group("Positioning - FPS")
@export var fps_position: Vector3 = Vector3(0.2, -0.15, -0.4)
@export var fps_rotation: Vector3 = Vector3.ZERO
@export var fps_scale: Vector3 = Vector3.ONE

@export_group("Positioning - ADS")
@export var aim_position: Vector3 = Vector3(0, -0.1, -0.3)
@export var aim_rotation: Vector3 = Vector3.ZERO
@export var aim_speed: float = 8.0
@export var aim_fov: float = 55.0

@export_group("Sway Settings")
@export var sway_enabled: bool = true
@export var sway_amount: float = 0.02
@export var sway_max: float = 0.08
@export var sway_speed: float = 5.0
@export var idle_sway_enabled: bool = true
@export var idle_sway_amount: float = 0.002
@export var idle_sway_speed: float = 1.0

@export_group("Bob Settings")
@export var bob_enabled: bool = true
@export var bob_frequency: float = 2.0
@export var bob_amplitude: float = 0.03

@export_group("Recoil")
@export var recoil_vertical: float = 0.03
@export var recoil_horizontal: float = 0.01
@export var recoil_snap_amount: float = 0.1  # Camera kick
@export var recoil_recovery_speed: float = 8.0

@export_group("Combat Stats")
@export var damage: float = 25.0
@export var fire_rate: float = 0.1  # Seconds between shots
@export var range_distance: float = 100.0
@export var spread_base: float = 0.5  # Degrees
@export var spread_max: float = 5.0
@export var spread_increase: float = 0.5
@export var spread_recovery: float = 2.0

@export_group("Ammo")
@export var magazine_size: int = 12
@export var reserve_ammo: int = 60
@export var reload_time: float = 1.5
@export var ammo_type: String = "pistol"

@export_group("Fire Mode")
enum FireMode { SEMI_AUTO, FULL_AUTO, BURST }
@export var fire_mode: FireMode = FireMode.SEMI_AUTO
@export var burst_count: int = 3

@export_group("Audio")
@export var sound_fire: AudioStream
@export var sound_reload: AudioStream
@export var sound_empty: AudioStream
@export var sound_equip: AudioStream

@export_group("Muzzle Flash")
@export var muzzle_flash_scene: PackedScene
@export var muzzle_flash_duration: float = 0.05
@export var muzzle_light_energy: float = 3.0
@export var muzzle_light_color: Color = Color(1.0, 0.8, 0.4)
