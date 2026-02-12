shader_type canvas_item;

// Vignette Post-Process Shader
// Urban Survivor - 1960s NYC Aesthetic
// Darkens edges to focus attention and add period film look

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Vignette controls
uniform float radius : hint_range(0.3, 1.0) = 0.7;
uniform float softness : hint_range(0.1, 0.6) = 0.4;
uniform vec3 vignette_color : source_color = vec3(0.0, 0.0, 0.0);
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

// Asymmetry for realistic lens vignette
uniform bool asymmetric = true;
uniform vec2 center_offset = vec2(0.02, -0.02);

// Standard circular vignette
float vignette_circular(vec2 uv) {
	vec2 centered = uv - 0.5;
	if (asymmetric) {
		centered -= center_offset;
	}
	float dist = length(centered);
	return 1.0 - smoothstep(radius - softness, radius + softness, dist);
}

// Elliptical vignette (anamorphic lens simulation)
float vignette_anamorphic(vec2 uv, float aspect) {
	vec2 centered = uv - 0.5;
	if (asymmetric) {
		centered -= center_offset;
	}
	centered.x *= aspect;
	float dist = length(centered);
	return 1.0 - smoothstep(radius - softness, radius + softness, dist);
}

void fragment() {
	vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	// Calculate vignette
	float vignette = vignette_circular(SCREEN_UV);
	
	// Apply vignette (darken edges)
	vec3 result = mix(vignette_color, screen, mix(1.0, vignette, intensity));
	
	COLOR = vec4(result, 1.0);
}
