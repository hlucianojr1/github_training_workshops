// sixties_atmosphere.gdshaderinc
// Urban Survivor - 1960s NYC Shader Include Library
// Urban smog, industrial haze, dust, and atmospheric effects
// Recreates the polluted 1960s New York City atmosphere

// ============================================================================
// ATMOSPHERE COLOR CONSTANTS
// ============================================================================

// 1960s NYC was heavily polluted - smog, industrial emissions, car exhaust
const vec3 SMOG_COLOR = vec3(0.55, 0.50, 0.45);         // Brownish-gray
const vec3 HAZE_COLOR = vec3(0.65, 0.62, 0.58);         // Light gray-brown
const vec3 DUST_COLOR = vec3(0.60, 0.55, 0.48);         // Dusty tan
const vec3 FOG_COLOR = vec3(0.70, 0.68, 0.65);          // Neutral gray
const vec3 SMOG_ORANGE = vec3(0.65, 0.50, 0.35);        // Sunset smog

// Post-apocalyptic additions
const vec3 ASH_COLOR = vec3(0.45, 0.43, 0.42);          // Gray ash
const vec3 SMOKE_COLOR = vec3(0.35, 0.33, 0.32);        // Dark smoke
const vec3 RADIATION_TINT = vec3(0.55, 0.58, 0.50);     // Sickly green-gray

// ============================================================================
// DISTANCE FOG
// ============================================================================

// Simple exponential fog
vec3 apply_fog_exp(vec3 color, vec3 fog_color, float distance, float density) {
	float fog_amount = 1.0 - exp(-distance * density);
	return mix(color, fog_color, fog_amount);
}

// Exponential squared fog (denser at distance)
vec3 apply_fog_exp2(vec3 color, vec3 fog_color, float distance, float density) {
	float fog_amount = 1.0 - exp(-pow(distance * density, 2.0));
	return mix(color, fog_color, fog_amount);
}

// Distance fog with height falloff (fog denser at ground level)
vec3 apply_urban_fog(vec3 color, float distance, float height, float density) {
	// Fog is thicker at street level
	float height_factor = exp(-max(height, 0.0) * 0.15);
	float fog_amount = 1.0 - exp(-distance * density * height_factor);
	return mix(color, SMOG_COLOR, fog_amount);
}

// Layered fog (ground fog + atmospheric haze)
vec3 apply_layered_fog(vec3 color, float distance, float height, float ground_density, float atmo_density) {
	// Ground fog layer (thick, low)
	float ground_fog = exp(-max(height, 0.0) * 0.5);
	ground_fog *= 1.0 - exp(-distance * ground_density);
	
	// Atmospheric haze (thin, uniform)
	float atmo_haze = 1.0 - exp(-distance * atmo_density);
	
	// Combine
	vec3 result = mix(color, FOG_COLOR, ground_fog * 0.8);
	result = mix(result, HAZE_COLOR, atmo_haze * 0.4);
	
	return result;
}

// ============================================================================
// URBAN HAZE (Always Present)
// ============================================================================

// Atmospheric haze - subtle, always visible in 1960s NYC
vec3 apply_haze(vec3 color, float distance, float intensity) {
	float haze = 1.0 - exp(-distance * intensity * 0.01);
	return mix(color, HAZE_COLOR, haze * 0.35);
}

// Smog haze - thicker, more yellow-brown
vec3 apply_smog_haze(vec3 color, float distance, float intensity) {
	float haze = 1.0 - exp(-distance * intensity * 0.015);
	
	// Smog gets more orange-brown at distance
	vec3 smog_gradient = mix(SMOG_COLOR, SMOG_ORANGE, haze * 0.5);
	
	return mix(color, smog_gradient, haze * 0.5);
}

// Industrial smog (heavy pollution)
vec3 apply_industrial_smog(vec3 color, float distance, float height, float intensity) {
	// Smog layer at specific height
	float smog_height = 20.0; // Smog layer center
	float smog_thickness = 30.0;
	float in_smog_layer = 1.0 - smoothstep(0.0, smog_thickness, abs(height - smog_height));
	
	float smog = 1.0 - exp(-distance * intensity * 0.02);
	smog *= in_smog_layer;
	
	return mix(color, SMOG_COLOR, smog * 0.6);
}

// ============================================================================
// DUST & PARTICLES
// ============================================================================

// Requires value_noise from sixties_common.gdshaderinc
// float value_noise(vec2 uv) - assumed available

// Floating dust particles overlay
float dust_particles(vec2 uv, float time, float density, float scale) {
	float dust = 0.0;
	
	// Multiple layers of drifting particles
	for (float i = 0.0; i < 3.0; i++) {
		vec2 offset = vec2(
			sin(time * 0.1 + i * 2.0) * 0.1,
			time * 0.02 * (1.0 + i * 0.3) // Slowly drifting upward
		);
		
		float layer_scale = scale * (50.0 + i * 20.0);
		
		// Simple noise-based particles
		vec2 noise_uv = (uv + offset) * layer_scale;
		vec2 i_uv = floor(noise_uv);
		float n = fract(sin(dot(i_uv, vec2(12.9898, 78.233))) * 43758.5453);
		
		// Threshold to create sparse particles
		dust += step(1.0 - density * 0.1, n) * 0.5;
	}
	
	return dust * 0.15;
}

// Ash fall (post-apocalyptic)
float ash_fall(vec2 uv, float time, float density) {
	float ash = 0.0;
	
	for (float i = 0.0; i < 5.0; i++) {
		float seed = i * 7.31;
		
		// Falling motion with slight horizontal drift
		vec2 offset = vec2(
			sin(time * 0.3 + seed) * 0.05,
			-time * 0.15 * (1.0 + fract(sin(seed) * 43758.5453) * 0.5)
		);
		
		vec2 ash_uv = fract((uv + offset) * (30.0 + i * 10.0));
		
		// Circular ash flakes
		vec2 center = vec2(0.5);
		float dist = length(ash_uv - center);
		float flake = smoothstep(0.1, 0.05, dist);
		
		// Sparse distribution
		float show = step(0.95, fract(sin(dot(floor(uv * (30.0 + i * 10.0) + offset * 10.0), vec2(12.9898, 78.233))) * 43758.5453));
		
		ash += flake * show * density;
	}
	
	return clamp(ash, 0.0, 0.3);
}

// ============================================================================
// HEAT EFFECTS
// ============================================================================

// Heat shimmer / distortion (from hot pavement, fires)
vec2 heat_shimmer(vec2 uv, float time, float intensity) {
	float distort_x = sin(uv.y * 50.0 + time * 3.0) * intensity * 0.003;
	float distort_y = sin(uv.x * 40.0 + time * 2.5) * intensity * 0.002;
	return uv + vec2(distort_x, distort_y);
}

// Localized heat shimmer (near specific height)
vec2 heat_shimmer_ground(vec2 uv, float height, float time, float intensity) {
	// Only shimmer near ground level
	float ground_factor = smoothstep(5.0, 0.0, height);
	
	float distort = sin(uv.y * 80.0 + time * 4.0) * intensity * 0.004 * ground_factor;
	return uv + vec2(distort, 0.0);
}

// ============================================================================
// VOLUMETRIC LIGHT
// ============================================================================

// God rays / light shafts
float god_rays(vec2 uv, vec2 light_pos, float density, float decay, int samples) {
	vec2 delta = (uv - light_pos) / float(samples);
	vec2 sample_pos = uv;
	float illumination = 0.0;
	float weight = 1.0;
	
	for (int i = 0; i < samples; i++) {
		// Sample would need scene depth/occlusion in real implementation
		// This is a simplified screen-space version
		float sample_value = 1.0; // Replace with actual occlusion sample
		illumination += sample_value * weight;
		weight *= decay;
		sample_pos -= delta;
	}
	
	return illumination * density / float(samples);
}

// Simple radial god rays (no occlusion)
float radial_rays(vec2 uv, vec2 center, float ray_count, float intensity) {
	vec2 delta = uv - center;
	float angle = atan(delta.y, delta.x);
	float dist = length(delta);
	
	float rays = sin(angle * ray_count) * 0.5 + 0.5;
	rays *= exp(-dist * 2.0); // Fade with distance
	
	return rays * intensity;
}

// ============================================================================
// WEATHER EFFECTS
// ============================================================================

// Rain streak overlay
float rain_streaks(vec2 uv, float time, float intensity) {
	float rain = 0.0;
	
	// Multiple rain layers at different speeds/angles
	for (float i = 0.0; i < 3.0; i++) {
		float speed = 2.0 + i * 0.5;
		float angle = 0.1 + i * 0.05;
		
		vec2 rain_uv = uv;
		rain_uv.x += rain_uv.y * angle; // Slight angle
		rain_uv.y -= time * speed;
		rain_uv *= vec2(100.0, 50.0) * (1.0 + i * 0.3);
		
		vec2 i_rain = floor(rain_uv);
		vec2 f_rain = fract(rain_uv);
		
		// Vertical streaks
		float streak = smoothstep(0.45, 0.5, f_rain.x) * smoothstep(0.55, 0.5, f_rain.x);
		streak *= smoothstep(0.0, 0.1, f_rain.y) * smoothstep(1.0, 0.7, f_rain.y);
		
		// Sparse distribution
		float show = step(0.7, fract(sin(dot(i_rain, vec2(12.9898, 78.233))) * 43758.5453));
		
		rain += streak * show * 0.3;
	}
	
	return rain * intensity;
}

// ============================================================================
// COMPOSITE ATMOSPHERE
// ============================================================================

// Full 1960s NYC atmosphere effect
vec3 apply_sixties_atmosphere(vec3 color, float distance, float height, float time, float intensity) {
	// Base urban haze (always present)
	color = apply_smog_haze(color, distance, intensity);
	
	// Height-based fog
	color = apply_urban_fog(color, distance, height, intensity * 0.03);
	
	// Subtle color shift toward smog color at distance
	float distance_tint = 1.0 - exp(-distance * 0.01);
	color = mix(color, color * vec3(1.0, 0.97, 0.92), distance_tint * intensity * 0.3);
	
	return color;
}

// Post-apocalyptic atmosphere (heavier effects)
vec3 apply_postapoc_atmosphere(vec3 color, float distance, float height, float time, float intensity) {
	// Heavy smog
	color = apply_industrial_smog(color, distance, height, intensity);
	
	// Ash and smoke
	color = mix(color, ASH_COLOR, smoothstep(50.0, 200.0, distance) * intensity * 0.4);
	
	// Sickly tint
	color = mix(color, color * RADIATION_TINT / 0.55, intensity * 0.15);
	
	return color;
}
