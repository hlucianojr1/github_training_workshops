## Muzzle flash effect
## Spawns particles and light on weapon fire
extends Node3D
class_name MuzzleFlash

@export var enabled: bool = true

@export_group("Flash Light")
@export var light_energy: float = 3.0
@export var light_color: Color = Color(1.0, 0.8, 0.4)
@export var light_range: float = 5.0
@export var flash_duration: float = 0.05

@export_group("Particles")
@export var particle_scene: PackedScene

var flash_light: OmniLight3D
var flash_timer: float = 0.0
var is_flashing: bool = false

func _ready() -> void:
	# Create or find flash light
	flash_light = get_node_or_null("FlashLight") as OmniLight3D
	if not flash_light:
		flash_light = OmniLight3D.new()
		flash_light.name = "FlashLight"
		add_child(flash_light)
	
	flash_light.light_energy = 0.0
	flash_light.light_color = light_color
	flash_light.omni_range = light_range
	flash_light.shadow_enabled = false  # Performance

func _process(delta: float) -> void:
	if is_flashing:
		flash_timer -= delta
		if flash_timer <= 0:
			is_flashing = false
			flash_light.light_energy = 0.0
		else:
			# Fade out
			var fade = flash_timer / flash_duration
			flash_light.light_energy = light_energy * fade

## Trigger flash effect (call when firing)
func trigger() -> void:
	if not enabled:
		return
	
	is_flashing = true
	flash_timer = flash_duration
	flash_light.light_energy = light_energy
	flash_light.light_color = light_color
	
	# Spawn particles if configured
	if particle_scene:
		var particles = particle_scene.instantiate() as GPUParticles3D
		if particles:
			add_child(particles)
			particles.emitting = true
			# Auto-cleanup
			var cleanup_timer = get_tree().create_timer(particles.lifetime * 2.0)
			cleanup_timer.timeout.connect(func(): particles.queue_free())

## Configure from weapon resource
func configure(resource: WeaponResource) -> void:
	if resource:
		flash_duration = resource.muzzle_flash_duration
		light_energy = resource.muzzle_light_energy
		light_color = resource.muzzle_light_color
		if resource.muzzle_flash_scene:
			particle_scene = resource.muzzle_flash_scene
