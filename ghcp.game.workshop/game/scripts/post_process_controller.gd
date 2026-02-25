# PostProcessController.gd
# Urban Survivor - Post-Processing Stack Controller
# Manages the 1960s film aesthetic effects

extends CanvasLayer

## Film Grain Settings
@export_group("Film Grain")
@export var film_grain_enabled := true
@export_range(0.0, 0.5) var film_grain_intensity := 0.15
@export_range(1.0, 4.0) var film_grain_size := 2.0
@export var colored_grain := false
@export var enable_scratches := false
@export_range(0.0, 1.0) var scratch_intensity := 0.3

## Vignette Settings
@export_group("Vignette")
@export var vignette_enabled := true
@export_range(0.3, 1.0) var vignette_radius := 0.7
@export_range(0.1, 0.6) var vignette_softness := 0.4
@export_range(0.0, 1.0) var vignette_intensity := 1.0

## Color Grading Settings
@export_group("Color Grading")
@export var color_grading_enabled := true
@export_enum("Kodachrome", "Ektachrome", "CrossProcess", "Agfacolor") var color_preset := 0
@export_range(0.0, 1.0) var grading_intensity := 1.0
@export_range(0.0, 2.0) var saturation := 1.0
@export_range(0.5, 1.5) var contrast := 1.0
@export_range(-0.5, 0.5) var brightness := 0.0
@export_range(-1.0, 1.0) var temperature := 0.0
@export_range(-1.0, 1.0) var tint := 0.0

## Chromatic Aberration Settings
@export_group("Chromatic Aberration")
@export var chromatic_aberration_enabled := false
@export_range(0.0, 0.02) var chromatic_aberration_intensity := 0.003

## Node References
@onready var film_grain: ColorRect = $FilmGrain
@onready var vignette: ColorRect = $Vignette
@onready var color_grading: ColorRect = $ColorGrading
@onready var chromatic_aberration: ColorRect = $ChromaticAberration


func _ready() -> void:
	# Set layer to render on top
	layer = 100
	
	_update_all_effects()


func _update_all_effects() -> void:
	_update_film_grain()
	_update_vignette()
	_update_color_grading()
	_update_chromatic_aberration()


func _update_film_grain() -> void:
	if not is_instance_valid(film_grain):
		return
	
	film_grain.visible = film_grain_enabled
	if film_grain_enabled and film_grain.material:
		var mat := film_grain.material as ShaderMaterial
		mat.set_shader_parameter("intensity", film_grain_intensity)
		mat.set_shader_parameter("grain_size", film_grain_size)
		mat.set_shader_parameter("colored_grain", colored_grain)
		mat.set_shader_parameter("enable_scratches", enable_scratches)
		mat.set_shader_parameter("scratch_intensity", scratch_intensity)


func _update_vignette() -> void:
	if not is_instance_valid(vignette):
		return
	
	vignette.visible = vignette_enabled
	if vignette_enabled and vignette.material:
		var mat := vignette.material as ShaderMaterial
		mat.set_shader_parameter("radius", vignette_radius)
		mat.set_shader_parameter("softness", vignette_softness)
		mat.set_shader_parameter("intensity", vignette_intensity)


func _update_color_grading() -> void:
	if not is_instance_valid(color_grading):
		return
	
	color_grading.visible = color_grading_enabled
	if color_grading_enabled and color_grading.material:
		var mat := color_grading.material as ShaderMaterial
		mat.set_shader_parameter("preset", color_preset)
		mat.set_shader_parameter("intensity", grading_intensity)
		mat.set_shader_parameter("saturation", saturation)
		mat.set_shader_parameter("contrast", contrast)
		mat.set_shader_parameter("brightness", brightness)
		mat.set_shader_parameter("temperature", temperature)
		mat.set_shader_parameter("tint", tint)


func _update_chromatic_aberration() -> void:
	if not is_instance_valid(chromatic_aberration):
		return
	
	chromatic_aberration.visible = chromatic_aberration_enabled
	if chromatic_aberration_enabled and chromatic_aberration.material:
		var mat := chromatic_aberration.material as ShaderMaterial
		mat.set_shader_parameter("intensity", chromatic_aberration_intensity)


# ============================================================================
# PUBLIC API - Call from game events
# ============================================================================

## Enable/disable all post-processing
func set_enabled(enabled: bool) -> void:
	visible = enabled


## Flash damage effect (red vignette pulse)
func damage_flash(duration: float = 0.3) -> void:
	if not is_instance_valid(vignette) or not vignette.material:
		return
	
	var mat := vignette.material as ShaderMaterial
	var original_color: Color = mat.get_shader_parameter("vignette_color")
	var original_intensity: float = vignette_intensity
	
	# Flash red
	mat.set_shader_parameter("vignette_color", Color(0.5, 0.0, 0.0))
	mat.set_shader_parameter("intensity", 1.0)
	vignette.visible = true
	
	# Restore after duration
	await get_tree().create_timer(duration).timeout
	mat.set_shader_parameter("vignette_color", original_color)
	mat.set_shader_parameter("intensity", original_intensity)
	vignette.visible = vignette_enabled


## Fear/tension distortion effect
func set_fear_distortion(amount: float) -> void:
	chromatic_aberration_enabled = amount > 0.01
	chromatic_aberration_intensity = amount * 0.01
	_update_chromatic_aberration()


## Low health desaturation
func set_low_health_effect(health_percent: float) -> void:
	# Desaturate as health drops below 30%
	var desaturation: float = clampf(1.0 - (health_percent - 0.1) / 0.2, 0.0, 1.0)
	saturation = 1.0 - desaturation * 0.6
	_update_color_grading()


## Flashback/memory effect (sepia, heavy grain)
func set_flashback_mode(enabled: bool) -> void:
	if enabled:
		color_preset = 0  # Kodachrome
		grading_intensity = 1.0
		saturation = 0.5  # Desaturated
		film_grain_intensity = 0.25  # Heavy grain
		enable_scratches = true
		vignette_intensity = 1.0
		vignette_radius = 0.5  # Stronger vignette
	else:
		# Restore defaults
		saturation = 1.0
		film_grain_intensity = 0.15
		enable_scratches = false
		vignette_intensity = 1.0
		vignette_radius = 0.7
	
	_update_all_effects()


## Explosion flash (bright, chromatic)
func explosion_flash(duration: float = 0.15) -> void:
	var original_brightness := brightness
	var original_chromatic := chromatic_aberration_enabled
	var original_chromatic_intensity := chromatic_aberration_intensity
	
	brightness = 0.3
	chromatic_aberration_enabled = true
	chromatic_aberration_intensity = 0.015
	_update_color_grading()
	_update_chromatic_aberration()
	
	await get_tree().create_timer(duration).timeout
	
	brightness = original_brightness
	chromatic_aberration_enabled = original_chromatic
	chromatic_aberration_intensity = original_chromatic_intensity
	_update_color_grading()
	_update_chromatic_aberration()
