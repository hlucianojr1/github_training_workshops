extends CanvasLayer
class_name PostProcessController
## Post-Processing Controller for Urban Survivor
## Manages the 1960s NYC film-like post-processing effect stack.
## Add this as a child to your main scene or autoload.

# Effect node references
@onready var film_grain: ColorRect = $FilmGrain
@onready var vignette: ColorRect = $Vignette
@onready var color_grading: ColorRect = $ColorGrading
@onready var chromatic_aberration: ColorRect = $ChromaticAberration

# Master toggle
@export var effects_enabled: bool = true:
	set(value):
		effects_enabled = value
		_update_all_visibility()

# Individual effect toggles
@export_group("Effect Toggles")
@export var film_grain_enabled: bool = true:
	set(value):
		film_grain_enabled = value
		if film_grain:
			film_grain.visible = value and effects_enabled

@export var vignette_enabled: bool = true:
	set(value):
		vignette_enabled = value
		if vignette:
			vignette.visible = value and effects_enabled

@export var color_grading_enabled: bool = true:
	set(value):
		color_grading_enabled = value
		if color_grading:
			color_grading.visible = value and effects_enabled

@export var chromatic_aberration_enabled: bool = true:
	set(value):
		chromatic_aberration_enabled = value
		if chromatic_aberration:
			chromatic_aberration.visible = value and effects_enabled

# Effect intensity controls
@export_group("Film Grain")
@export_range(0.0, 0.5) var grain_intensity: float = 0.15:
	set(value):
		grain_intensity = value
		_update_film_grain()

@export_range(1.0, 4.0) var grain_size: float = 2.0:
	set(value):
		grain_size = value
		_update_film_grain()

@export var colored_grain: bool = false:
	set(value):
		colored_grain = value
		_update_film_grain()

@export var enable_scratches: bool = false:
	set(value):
		enable_scratches = value
		_update_film_grain()

@export_group("Vignette")
@export_range(0.0, 1.0) var vignette_intensity: float = 1.0:
	set(value):
		vignette_intensity = value
		_update_vignette()

@export_range(0.3, 1.0) var vignette_radius: float = 0.7:
	set(value):
		vignette_radius = value
		_update_vignette()

@export_range(0.1, 0.6) var vignette_softness: float = 0.4:
	set(value):
		vignette_softness = value
		_update_vignette()

@export_group("Color Grading")
## 0=Kodachrome, 1=Ektachrome, 2=CrossProcess, 3=Agfacolor
@export_range(0, 3) var color_preset: int = 0:
	set(value):
		color_preset = value
		_update_color_grading()

@export_range(0.0, 1.0) var color_grading_intensity: float = 0.7:
	set(value):
		color_grading_intensity = value
		_update_color_grading()

@export_range(-0.5, 0.5) var brightness: float = 0.0:
	set(value):
		brightness = value
		_update_color_grading()

@export_range(0.5, 1.5) var contrast: float = 1.0:
	set(value):
		contrast = value
		_update_color_grading()

@export_range(0.0, 2.0) var saturation: float = 1.0:
	set(value):
		saturation = value
		_update_color_grading()

@export_group("Chromatic Aberration")
@export_range(0.0, 0.02) var aberration_intensity: float = 0.003:
	set(value):
		aberration_intensity = value
		_update_chromatic_aberration()

@export var radial_aberration: bool = true:
	set(value):
		radial_aberration = value
		_update_chromatic_aberration()


func _ready() -> void:
	layer = 100  # Ensure we render on top
	_update_all_visibility()
	_update_all_parameters()


func _update_all_visibility() -> void:
	if film_grain:
		film_grain.visible = film_grain_enabled and effects_enabled
	if vignette:
		vignette.visible = vignette_enabled and effects_enabled
	if color_grading:
		color_grading.visible = color_grading_enabled and effects_enabled
	if chromatic_aberration:
		chromatic_aberration.visible = chromatic_aberration_enabled and effects_enabled


func _update_all_parameters() -> void:
	_update_film_grain()
	_update_vignette()
	_update_color_grading()
	_update_chromatic_aberration()


func _update_film_grain() -> void:
	if not film_grain or not film_grain.material:
		return
	var mat := film_grain.material as ShaderMaterial
	mat.set_shader_parameter("intensity", grain_intensity)
	mat.set_shader_parameter("grain_size", grain_size)
	mat.set_shader_parameter("colored_grain", colored_grain)
	mat.set_shader_parameter("enable_scratches", enable_scratches)


func _update_vignette() -> void:
	if not vignette or not vignette.material:
		return
	var mat := vignette.material as ShaderMaterial
	mat.set_shader_parameter("intensity", vignette_intensity)
	mat.set_shader_parameter("radius", vignette_radius)
	mat.set_shader_parameter("softness", vignette_softness)


func _update_color_grading() -> void:
	if not color_grading or not color_grading.material:
		return
	var mat := color_grading.material as ShaderMaterial
	mat.set_shader_parameter("preset", color_preset)
	mat.set_shader_parameter("intensity", color_grading_intensity)
	mat.set_shader_parameter("brightness", brightness)
	mat.set_shader_parameter("contrast", contrast)
	mat.set_shader_parameter("saturation", saturation)


func _update_chromatic_aberration() -> void:
	if not chromatic_aberration or not chromatic_aberration.material:
		return
	var mat := chromatic_aberration.material as ShaderMaterial
	mat.set_shader_parameter("intensity", aberration_intensity)
	mat.set_shader_parameter("radial", radial_aberration)


# ============================================================================
# PUBLIC API - Call these from gameplay code
# ============================================================================

## Temporarily boost grain (e.g., during flashbacks or trauma)
func set_trauma_effect(trauma_amount: float) -> void:
	grain_intensity = lerp(0.15, 0.4, trauma_amount)
	vignette_intensity = lerp(1.0, 0.7, trauma_amount)
	vignette_radius = lerp(0.7, 0.5, trauma_amount)
	saturation = lerp(1.0, 0.5, trauma_amount)


## Reset to default 1960s look
func reset_to_default() -> void:
	grain_intensity = 0.15
	grain_size = 2.0
	colored_grain = false
	enable_scratches = false
	vignette_intensity = 1.0
	vignette_radius = 0.7
	vignette_softness = 0.4
	color_preset = 0  # Kodachrome
	color_grading_intensity = 0.7
	brightness = 0.0
	contrast = 1.0
	saturation = 1.0
	aberration_intensity = 0.003
	radial_aberration = true


## Fade to black effect (for scene transitions)
func fade_to_black(duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "brightness", -1.0, duration)


## Fade from black effect (for scene transitions)
func fade_from_black(duration: float) -> void:
	brightness = -1.0
	var tween := create_tween()
	tween.tween_property(self, "brightness", 0.0, duration)


## Apply damage flash effect
func damage_flash() -> void:
	# Temporarily boost vignette and desaturate
	var original_vignette := vignette_intensity
	var original_radius := vignette_radius
	var original_saturation := saturation
	vignette_radius = 0.4
	saturation = 0.3
	
	var tween := create_tween()
	tween.tween_property(self, "vignette_radius", original_radius, 0.3)
	tween.parallel().tween_property(self, "saturation", original_saturation, 0.3)
