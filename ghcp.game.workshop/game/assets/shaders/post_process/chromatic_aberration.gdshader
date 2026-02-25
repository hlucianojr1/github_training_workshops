shader_type canvas_item;

// Chromatic Aberration Post-Process Shader
// Urban Survivor - 1960s NYC Aesthetic
// Simulates color fringing from vintage lenses

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Aberration controls
uniform float intensity : hint_range(0.0, 0.02) = 0.003;
uniform bool radial = true; // Radial (lens-like) or linear

// For linear mode
uniform vec2 direction = vec2(1.0, 0.0);

void fragment() {
	vec2 uv = SCREEN_UV;
	
	vec2 offset;
	if (radial) {
		// Radial chromatic aberration (more realistic)
		vec2 centered = uv - 0.5;
		float dist = length(centered);
		offset = centered * dist * intensity;
	} else {
		// Linear chromatic aberration
		offset = direction * intensity;
	}
	
	// Sample RGB channels at different offsets
	float r = texture(SCREEN_TEXTURE, uv + offset).r;
	float g = texture(SCREEN_TEXTURE, uv).g;
	float b = texture(SCREEN_TEXTURE, uv - offset).b;
	
	COLOR = vec4(r, g, b, 1.0);
}
