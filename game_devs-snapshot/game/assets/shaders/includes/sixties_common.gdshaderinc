// sixties_common.gdshaderinc
// Urban Survivor - 1960s NYC Shader Include Library
// Common utility functions for all shaders

// ============================================================================
// HASH FUNCTIONS
// ============================================================================

// 1D hash from 1D input
float hash11(float p) {
	p = fract(p * 0.1031);
	p *= p + 33.33;
	p *= p + p;
	return fract(p);
}

// 1D hash from 2D input
float hash21(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

// 2D hash from 2D input
vec2 hash22(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.xx + p3.yz) * p3.zy);
}

// 3D hash from 3D input
vec3 hash33(vec3 p3) {
	p3 = fract(p3 * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yxz + 33.33);
	return fract((p3.xxy + p3.yxx) * p3.zyx);
}

// ============================================================================
// NOISE FUNCTIONS
// ============================================================================

// Value noise (2D)
float value_noise(vec2 uv) {
	vec2 i = floor(uv);
	vec2 f = fract(uv);
	
	float a = hash21(i);
	float b = hash21(i + vec2(1.0, 0.0));
	float c = hash21(i + vec2(0.0, 1.0));
	float d = hash21(i + vec2(1.0, 1.0));
	
	// Smooth interpolation
	vec2 u = f * f * (3.0 - 2.0 * f);
	
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion (2D)
float fbm(vec2 uv, int octaves, float lacunarity, float gain) {
	float value = 0.0;
	float amplitude = 0.5;
	float frequency = 1.0;
	
	for (int i = 0; i < octaves; i++) {
		value += amplitude * value_noise(uv * frequency);
		frequency *= lacunarity;
		amplitude *= gain;
	}
	
	return value;
}

// Worley/Cellular noise (2D) - returns distance to nearest point
float worley_noise(vec2 uv, float scale) {
	vec2 p = uv * scale;
	vec2 i = floor(p);
	vec2 f = fract(p);
	
	float min_dist = 1.0;
	
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x), float(y));
			vec2 point = hash22(i + neighbor);
			vec2 diff = neighbor + point - f;
			float dist = length(diff);
			min_dist = min(min_dist, dist);
		}
	}
	
	return min_dist;
}

// ============================================================================
// FRESNEL & LIGHTING UTILITIES
// ============================================================================

// Schlick fresnel approximation
float fresnel_schlick(float cos_theta, float f0) {
	return f0 + (1.0 - f0) * pow(1.0 - cos_theta, 5.0);
}

// Simple fresnel for rim lighting
float fresnel(vec3 normal, vec3 view, float power) {
	return pow(1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0), power);
}

// ============================================================================
// UV UTILITIES
// ============================================================================

// Rotate UV around center
vec2 rotate_uv(vec2 uv, float angle) {
	vec2 centered = uv - 0.5;
	float s = sin(angle);
	float c = cos(angle);
	vec2 rotated = vec2(centered.x * c - centered.y * s, centered.x * s + centered.y * c);
	return rotated + 0.5;
}

// Triplanar UV projection
vec3 triplanar_weights(vec3 normal) {
	vec3 w = abs(normal);
	w = pow(w, vec3(4.0)); // Sharpen blend
	return w / (w.x + w.y + w.z);
}

// Parallax offset for fake depth
vec2 parallax_offset(vec2 uv, vec3 view_dir, float height, float scale) {
	float h = height * scale;
	vec2 offset = view_dir.xy / view_dir.z * h;
	return uv - offset;
}

// ============================================================================
// COLOR UTILITIES
// ============================================================================

// Convert RGB to HSV
vec3 rgb_to_hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// Convert HSV to RGB
vec3 hsv_to_rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// Luminance (Rec. 709)
float luminance(vec3 color) {
	return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

// Luminance (Rec. 601 - more period-accurate for 1960s)
float luminance_601(vec3 color) {
	return dot(color, vec3(0.299, 0.587, 0.114));
}

// ============================================================================
// BLEND MODES
// ============================================================================

vec3 blend_overlay(vec3 base, vec3 blend) {
	return mix(
		2.0 * base * blend,
		1.0 - 2.0 * (1.0 - base) * (1.0 - blend),
		step(0.5, base)
	);
}

vec3 blend_soft_light(vec3 base, vec3 blend) {
	return mix(
		2.0 * base * blend + base * base * (1.0 - 2.0 * blend),
		sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend),
		step(0.5, blend)
	);
}

// ============================================================================
// SHAPE FUNCTIONS
// ============================================================================

// Signed distance to box
float sd_box(vec2 p, vec2 b) {
	vec2 d = abs(p) - b;
	return length(max(d, vec2(0.0))) + min(max(d.x, d.y), 0.0);
}

// Signed distance to circle
float sd_circle(vec2 p, float r) {
	return length(p) - r;
}

// ============================================================================
// CONSTANTS
// ============================================================================

const float PI = 3.14159265359;
const float TAU = 6.28318530718;
const float E = 2.71828182846;
