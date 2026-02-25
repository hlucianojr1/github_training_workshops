shader_type canvas_item;

// Film Grain Post-Process Shader
// Urban Survivor - 1960s NYC Aesthetic
// Emulates ISO 400 film stock grain characteristics

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Grain controls
uniform float intensity : hint_range(0.0, 0.5) = 0.15;
uniform float grain_size : hint_range(1.0, 4.0) = 2.0;
uniform bool colored_grain = false;

// Optional film damage
uniform bool enable_scratches = false;
uniform float scratch_intensity : hint_range(0.0, 1.0) = 0.3;

// Film grain - ISO 400 emulation
float film_grain(vec2 uv, float time) {
	// Temporal variation at 24fps
	float t = floor(time * 24.0) / 24.0;
	
	// Multi-octave grain for realistic texture
	vec2 grain_uv = uv * 1000.0 / grain_size;
	float grain = 0.0;
	
	// Large grain clusters
	grain += fract(sin(dot(grain_uv + t, vec2(12.9898, 78.233))) * 43758.5453) * 0.6;
	
	// Medium grain
	grain += fract(sin(dot(grain_uv * 2.0 + t * 1.3, vec2(39.346, 11.135))) * 43758.5453) * 0.3;
	
	// Fine grain
	grain += fract(sin(dot(grain_uv * 4.0 + t * 1.7, vec2(73.156, 52.235))) * 43758.5453) * 0.1;
	
	// Apply gamma for natural grain distribution
	grain = pow(grain, 2.2);
	
	return (grain - 0.5) * intensity;
}

// Colored film grain (RGB channels have different patterns)
vec3 film_grain_color(vec2 uv, float time) {
	float t = floor(time * 24.0) / 24.0;
	vec2 grain_uv = uv * 1000.0 / grain_size;
	
	float r = fract(sin(dot(grain_uv + t, vec2(12.9898, 78.233))) * 43758.5453);
	float g = fract(sin(dot(grain_uv + t, vec2(39.346, 11.135))) * 43758.5453);
	float b = fract(sin(dot(grain_uv + t, vec2(73.156, 52.235))) * 43758.5453);
	
	vec3 grain = vec3(r, g, b);
	grain = pow(grain, vec3(2.2));
	
	return (grain - 0.5) * intensity;
}

// Vertical film scratches
float film_scratches(vec2 uv, float time) {
	float scratch = 0.0;
	float t = floor(time * 24.0);
	
	for (float i = 0.0; i < 3.0; i++) {
		float seed = t + i * 7.3;
		float x_pos = fract(sin(seed * 12.9898) * 43758.5453) * 0.8 + 0.1;
		float width = 0.0005 + fract(sin(seed * 39.346) * 43758.5453) * 0.001;
		float opacity = fract(sin(seed * 73.156) * 43758.5453) * scratch_intensity;
		
		scratch += smoothstep(width, 0.0, abs(uv.x - x_pos)) * opacity;
	}
	
	return clamp(scratch, 0.0, 0.4);
}

void fragment() {
	vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	// Apply film grain
	if (colored_grain) {
		screen += film_grain_color(SCREEN_UV, TIME);
	} else {
		float grain = film_grain(SCREEN_UV, TIME);
		screen += vec3(grain);
	}
	
	// Optional scratches
	if (enable_scratches) {
		float scratches = film_scratches(SCREEN_UV, TIME);
		screen += vec3(scratches);
	}
	
	COLOR = vec4(screen, 1.0);
}
