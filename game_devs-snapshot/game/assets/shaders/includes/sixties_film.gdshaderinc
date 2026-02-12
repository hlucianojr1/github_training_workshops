// sixties_film.gdshaderinc
// Urban Survivor - 1960s NYC Shader Include Library
// Film grain, scratches, gate weave, and projector effects
// Emulates ISO 400 film stock characteristics

// ============================================================================
// FILM GRAIN
// ============================================================================

// Simple film grain - fast, suitable for real-time
float film_grain_simple(vec2 uv, float time, float intensity) {
	float x = (uv.x + 4.0) * (uv.y + 4.0) * (mod(time, 100.0) + 10.0) * 10.0;
	float grain = mod((mod(x, 13.0) + 1.0) * (mod(x, 123.0) + 1.0), 0.01) - 0.005;
	return grain * intensity * 100.0;
}

// High-quality film grain - ISO 400 emulation
float film_grain(vec2 uv, float time, float intensity) {
	// Temporal variation
	float t = floor(time * 24.0) / 24.0; // 24fps grain update
	
	// Multi-octave grain for realistic texture
	vec2 grain_uv = uv * 1000.0;
	float grain = 0.0;
	
	// Large grain clusters
	grain += fract(sin(dot(grain_uv + t, vec2(12.9898, 78.233))) * 43758.5453) * 0.6;
	
	// Medium grain
	grain += fract(sin(dot(grain_uv * 2.0 + t * 1.3, vec2(39.346, 11.135))) * 43758.5453) * 0.3;
	
	// Fine grain
	grain += fract(sin(dot(grain_uv * 4.0 + t * 1.7, vec2(73.156, 52.235))) * 43758.5453) * 0.1;
	
	// Normalize and apply gamma for natural grain distribution
	grain = pow(grain, 2.2);
	
	return (grain - 0.5) * intensity;
}

// Colored film grain (RGB channels have different grain patterns)
vec3 film_grain_color(vec2 uv, float time, float intensity) {
	float t = floor(time * 24.0) / 24.0;
	vec2 grain_uv = uv * 1000.0;
	
	float r = fract(sin(dot(grain_uv + t, vec2(12.9898, 78.233))) * 43758.5453);
	float g = fract(sin(dot(grain_uv + t, vec2(39.346, 11.135))) * 43758.5453);
	float b = fract(sin(dot(grain_uv + t, vec2(73.156, 52.235))) * 43758.5453);
	
	vec3 grain = vec3(r, g, b);
	grain = pow(grain, vec3(2.2));
	
	return (grain - 0.5) * intensity;
}

// ============================================================================
// FILM SCRATCHES
// ============================================================================

// Vertical film scratches (transport damage)
float film_scratches(vec2 uv, float time, float count) {
	float scratch = 0.0;
	float t = floor(time * 24.0); // Update per frame
	
	for (float i = 0.0; i < count; i++) {
		// Random x position per frame
		float seed = t + i * 7.3;
		float x_pos = fract(sin(seed * 12.9898) * 43758.5453) * 0.8 + 0.1;
		
		// Random width
		float width = 0.0005 + fract(sin(seed * 39.346) * 43758.5453) * 0.001;
		
		// Random opacity
		float opacity = fract(sin(seed * 73.156) * 43758.5453) * 0.3;
		
		// Scratch line
		scratch += smoothstep(width, 0.0, abs(uv.x - x_pos)) * opacity;
	}
	
	return clamp(scratch, 0.0, 0.4);
}

// Horizontal scratches (rare, from debris)
float film_scratches_horizontal(vec2 uv, float time, float count) {
	float scratch = 0.0;
	float t = floor(time * 6.0); // Less frequent update
	
	for (float i = 0.0; i < count; i++) {
		float seed = t + i * 11.7;
		float y_pos = fract(sin(seed * 12.9898) * 43758.5453);
		float width = 0.0003 + fract(sin(seed * 39.346) * 43758.5453) * 0.0005;
		float length_start = fract(sin(seed * 73.156) * 43758.5453) * 0.5;
		float length_end = length_start + fract(sin(seed * 52.235) * 43758.5453) * 0.3;
		
		float in_range = step(length_start, uv.x) * step(uv.x, length_end);
		scratch += smoothstep(width, 0.0, abs(uv.y - y_pos)) * in_range * 0.2;
	}
	
	return clamp(scratch, 0.0, 0.2);
}

// ============================================================================
// GATE WEAVE & INSTABILITY
// ============================================================================

// Gate weave (vertical/horizontal frame instability)
vec2 gate_weave(vec2 uv, float time, float intensity) {
	// Organic, non-periodic motion
	float offset_x = sin(time * 11.0 + sin(time * 7.0) * 2.0) * intensity * 0.003;
	float offset_y = sin(time * 8.0 + cos(time * 5.0) * 1.5) * intensity * 0.002;
	
	// Occasional larger jumps
	float jump_trigger = step(0.98, fract(sin(floor(time * 24.0) * 12.9898) * 43758.5453));
	offset_y += jump_trigger * intensity * 0.01;
	
	return uv + vec2(offset_x, offset_y);
}

// Frame jitter (rapid micro-movements)
vec2 frame_jitter(vec2 uv, float time, float intensity) {
	float t = floor(time * 24.0);
	float jx = (fract(sin(t * 12.9898) * 43758.5453) - 0.5) * intensity * 0.001;
	float jy = (fract(sin(t * 78.233) * 43758.5453) - 0.5) * intensity * 0.001;
	return uv + vec2(jx, jy);
}

// ============================================================================
// PROJECTOR EFFECTS
// ============================================================================

// Projector flicker (brightness variation)
float projector_flicker(float time, float intensity) {
	float t = floor(time * 24.0);
	
	// Base flicker
	float flicker = 1.0 - fract(sin(t * 12.9898) * 43758.5453) * intensity * 0.08;
	
	// Occasional deeper dips
	float deep_flicker = step(0.95, fract(sin(t * 39.346) * 43758.5453));
	flicker -= deep_flicker * intensity * 0.15;
	
	return clamp(flicker, 0.75, 1.0);
}

// Projector burn (bright spots from lamp inconsistency)
float projector_burn(vec2 uv, float time, float intensity) {
	// Slow-moving hot spots
	float t = time * 0.1;
	vec2 spot1 = vec2(0.3 + sin(t) * 0.1, 0.4 + cos(t * 0.7) * 0.1);
	vec2 spot2 = vec2(0.7 + sin(t * 0.8) * 0.1, 0.6 + cos(t * 1.1) * 0.1);
	
	float burn = smoothstep(0.3, 0.0, length(uv - spot1)) * 0.05;
	burn += smoothstep(0.25, 0.0, length(uv - spot2)) * 0.03;
	
	return burn * intensity;
}

// ============================================================================
// VIGNETTE (OPTICAL)
// ============================================================================

// Standard vignette
float film_vignette(vec2 uv, float radius, float softness) {
	vec2 centered = uv - 0.5;
	float dist = length(centered);
	return 1.0 - smoothstep(radius - softness, radius + softness, dist);
}

// Elliptical vignette (anamorphic lens simulation)
float film_vignette_anamorphic(vec2 uv, float radius, float softness, float aspect) {
	vec2 centered = uv - 0.5;
	centered.x *= aspect;
	float dist = length(centered);
	return 1.0 - smoothstep(radius - softness, radius + softness, dist);
}

// Uneven vignette (off-center, more realistic)
float film_vignette_uneven(vec2 uv, float radius, float softness) {
	vec2 centered = uv - vec2(0.52, 0.48); // Slightly off-center
	float dist = length(centered * vec2(1.0, 0.9)); // Slight asymmetry
	return 1.0 - smoothstep(radius - softness, radius + softness, dist);
}

// ============================================================================
// FILM DAMAGE
// ============================================================================

// Dust and hair particles
float film_dust(vec2 uv, float time, float density) {
	float dust = 0.0;
	float t = floor(time * 24.0);
	
	// Several dust particles
	for (float i = 0.0; i < 5.0; i++) {
		float seed = t * 0.1 + i * 13.7;
		vec2 pos = vec2(
			fract(sin(seed * 12.9898) * 43758.5453),
			fract(sin(seed * 78.233) * 43758.5453)
		);
		float size = 0.001 + fract(sin(seed * 39.346) * 43758.5453) * 0.003;
		float show = step(1.0 - density, fract(sin(seed * 52.235) * 43758.5453));
		
		dust += smoothstep(size, 0.0, length(uv - pos)) * show;
	}
	
	return clamp(dust, 0.0, 1.0);
}

// Emulsion damage (blotches)
float film_emulsion_damage(vec2 uv, float time, float intensity) {
	float t = floor(time * 2.0); // Slow update
	float damage = 0.0;
	
	for (float i = 0.0; i < 3.0; i++) {
		float seed = t + i * 7.3;
		vec2 pos = vec2(
			fract(sin(seed * 12.9898) * 43758.5453),
			fract(sin(seed * 78.233) * 43758.5453)
		);
		float size = 0.02 + fract(sin(seed * 39.346) * 43758.5453) * 0.05;
		float show = step(0.9, fract(sin(seed * 52.235) * 43758.5453));
		
		damage += smoothstep(size, size * 0.5, length(uv - pos)) * show * 0.3;
	}
	
	return damage * intensity;
}

// ============================================================================
// COMPOSITE EFFECTS
// ============================================================================

// Apply full 1960s film look
vec3 apply_film_look(vec3 color, vec2 uv, float time, float grain_intensity, float damage_intensity) {
	// Film grain
	float grain = film_grain(uv, time, grain_intensity);
	color += vec3(grain);
	
	// Scratches
	float scratches = film_scratches(uv, time, 3.0);
	color += vec3(scratches) * damage_intensity;
	
	// Flicker
	float flicker = projector_flicker(time, damage_intensity);
	color *= flicker;
	
	// Vignette
	float vignette = film_vignette_uneven(uv, 0.75, 0.4);
	color *= vignette;
	
	return color;
}
