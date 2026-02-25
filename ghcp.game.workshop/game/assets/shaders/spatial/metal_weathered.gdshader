shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

// Weathered Metal Shader
// Urban Survivor - 1960s NYC Aesthetic
// For abandoned vehicles, debris, industrial props

// Base metal properties
uniform vec3 base_color : source_color = vec3(0.4, 0.38, 0.35);
uniform float roughness : hint_range(0.0, 1.0) = 0.6;
uniform float metallic : hint_range(0.0, 1.0) = 0.9;

// Rust properties
uniform vec3 rust_color : source_color = vec3(0.5, 0.25, 0.1);
uniform float rust_amount : hint_range(0.0, 1.0) = 0.4;
uniform float rust_scale : hint_range(1.0, 20.0) = 5.0;

// Grime/dirt overlay
uniform vec3 grime_color : source_color = vec3(0.2, 0.18, 0.15);
uniform float grime_amount : hint_range(0.0, 1.0) = 0.2;

// UV scale
uniform float uv_scale : hint_range(0.1, 10.0) = 1.0;

// Hash function
float hash21(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

// Value noise
float value_noise(vec2 uv) {
	vec2 i = floor(uv);
	vec2 f = fract(uv);
	
	float a = hash21(i);
	float b = hash21(i + vec2(1.0, 0.0));
	float c = hash21(i + vec2(0.0, 1.0));
	float d = hash21(i + vec2(1.0, 1.0));
	
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal noise
float fbm(vec2 uv, int octaves) {
	float value = 0.0;
	float amplitude = 0.5;
	float frequency = 1.0;
	
	for (int i = 0; i < octaves; i++) {
		value += amplitude * value_noise(uv * frequency);
		frequency *= 2.0;
		amplitude *= 0.5;
	}
	
	return value;
}

void fragment() {
	vec2 uv = UV * uv_scale;
	
	// Base metal color with slight variation
	float metal_var = value_noise(uv * 3.0) * 0.2;
	vec3 albedo = base_color * (0.9 + metal_var);
	
	// Rust pattern using fractal noise
	float rust_noise = fbm(uv * rust_scale, 4);
	float rust_pattern = smoothstep(0.5 - rust_amount * 0.5, 0.5 + rust_amount * 0.3, rust_noise);
	
	// Edge rust (higher on edges - approximated with noise derivative)
	float edge_rust = value_noise(uv * rust_scale * 2.0 + 0.5);
	rust_pattern = max(rust_pattern, edge_rust * rust_amount * 0.5);
	
	// Apply rust
	albedo = mix(albedo, rust_color, rust_pattern);
	float final_roughness = mix(roughness, 0.95, rust_pattern);
	float final_metallic = mix(metallic, 0.2, rust_pattern);
	
	// Grime accumulation (in crevices - high frequency noise)
	float grime_noise = fbm(uv * 8.0, 3);
	float grime_pattern = smoothstep(0.4, 0.6, grime_noise) * grime_amount;
	
	// Apply grime
	albedo = mix(albedo, grime_color, grime_pattern);
	final_roughness = mix(final_roughness, 1.0, grime_pattern);
	
	ALBEDO = albedo;
	ROUGHNESS = final_roughness;
	METALLIC = final_metallic;
}
