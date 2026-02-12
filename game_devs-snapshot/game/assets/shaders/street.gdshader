shader_type spatial;

// ============================================
// REALISTIC 1960s NYC STREET SHADER
// Based on vintage photography reference
// Authentic charcoal gray asphalt with minimal cracking
// ============================================

// Base asphalt appearance - true charcoal gray (matches #3A3A3A)
uniform vec3 asphalt_color : source_color = vec3(0.227, 0.227, 0.227); // Neutral charcoal #3A3A3A
uniform vec3 asphalt_warm : source_color = vec3(0.24, 0.23, 0.22); // Subtle warm gray
uniform vec3 asphalt_cool : source_color = vec3(0.21, 0.22, 0.23); // Subtle cool gray
uniform float roughness : hint_range(0.0, 1.0) = 0.88; // Slightly rougher
uniform float uv_scale : hint_range(1.0, 50.0) = 12.0;

// Lane markings - 1960s period-appropriate white
uniform vec3 lane_color : source_color = vec3(0.92, 0.92, 0.90); // White with slight aging
uniform float lane_width : hint_range(0.01, 0.1) = 0.035;
uniform float dash_length : hint_range(0.5, 5.0) = 2.5;
uniform float dash_gap : hint_range(0.5, 5.0) = 2.0;
uniform float lane_fade : hint_range(0.0, 1.0) = 0.50; // Well-worn appearance

// MINIMAL crack patterns - 10-15% coverage max
uniform float crack_density : hint_range(0.0, 0.2) = 0.05; // Very sparse, ~10% coverage
uniform float crack_darkness : hint_range(0.0, 0.4) = 0.20; // Subtle darkness

// Aggregate texture (small stones/pebbles in asphalt)
uniform float aggregate_scale : hint_range(30.0, 120.0) = 65.0;
uniform float aggregate_intensity : hint_range(0.0, 0.2) = 0.08; // Very subtle

// Normal/bump mapping - gentle surface texture
uniform float normal_strength : hint_range(0.0, 0.2) = 0.05;

// Subtle wear patterns from traffic
uniform float wear_intensity : hint_range(0.0, 0.2) = 0.10;

// ============================================
// NOISE FUNCTIONS
// ============================================

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float hash2(vec2 p) {
    return fract(sin(dot(p, vec2(269.5, 183.3))) * 43758.5453);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 uv, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < octaves; i++) {
        value += amplitude * noise(uv * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// ============================================
// AGGREGATE TEXTURE (small stones/pebbles)
// ============================================

float aggregate_pattern(vec2 uv) {
    // Multi-scale noise for realistic aggregate
    float fine = noise(uv * aggregate_scale);
    float medium = noise(uv * aggregate_scale * 0.5);
    
    // Combine for varied pebble sizes
    float aggregate = fine * 0.6 + medium * 0.4;
    
    // Add slight variation in density
    float density_var = noise(uv * 5.0);
    aggregate *= (0.8 + density_var * 0.4);
    
    return aggregate;
}

// ============================================
// SPARSE CRACK PATTERN
// Truly isolated cracks - ~10-15% coverage max
// Based on 1960s NYC street photography
// ============================================

float sparse_cracks(vec2 uv) {
    // STEP 1: Create very sparse "damage zones" 
    // These are isolated patches where cracks can exist
    float zone_noise = noise(uv * 0.15); // Very large scale
    float zone_noise2 = noise(uv * 0.25 + vec2(50.0, 50.0)); // Second layer offset
    
    // Combine for more organic zones
    float combined_zone = zone_noise * 0.6 + zone_noise2 * 0.4;
    
    // Create hard threshold - only top ~10% of noise values create zones
    float zone_threshold = 1.0 - crack_density; // e.g., 0.95 for 5% density
    float zone_mask = smoothstep(zone_threshold, zone_threshold + 0.02, combined_zone);
    
    // Early exit for most of the surface (no cracks)
    if (zone_mask < 0.01) {
        return 0.0;
    }
    
    // STEP 2: Within damage zones, create irregular crack lines
    vec2 crack_uv = uv * 6.0;
    
    // Simple directional cracks (not grid-like)
    float angle = noise(floor(uv * 0.5)) * 6.28; // Random angle per region
    vec2 dir = vec2(cos(angle), sin(angle));
    float crack_line = noise(crack_uv);
    
    // Create thin lines using gradient
    float dx = noise(crack_uv + dir * 0.02) - crack_line;
    float crack_edge = abs(dx) * 30.0;
    
    // Threshold to get distinct thin cracks
    float crack = smoothstep(0.2, 0.35, crack_edge);
    
    // STEP 3: Break up continuous lines into fragments
    float fragment = step(0.55, noise(uv * 40.0));
    crack *= fragment;
    
    // Fade edges of damage zones for smooth transition
    float zone_fade = smoothstep(0.0, 0.3, zone_mask);
    
    return crack * zone_fade * 0.8; // Reduce overall intensity
}

// ============================================
// OCCASIONAL POTHOLE/PATCH AREAS
// ============================================

float repair_patches(vec2 uv) {
    // Very sparse repair patches (slightly different colored asphalt)
    float patch_noise = noise(uv * 1.5);
    
    // Only show in very limited areas
    float patch = smoothstep(0.88, 0.92, patch_noise);
    
    return patch;
}

// ============================================
// LANE MARKING FUNCTIONS
// ============================================

float center_dashes(vec2 uv, float road_uv_x) {
    float center = 0.5;
    float half_width = lane_width * 0.5;
    
    float in_lane = smoothstep(center - half_width - 0.01, center - half_width, road_uv_x) 
                  * (1.0 - smoothstep(center + half_width, center + half_width + 0.01, road_uv_x));
    
    float dash_pattern = dash_length + dash_gap;
    float dash = step(dash_gap, mod(uv.y, dash_pattern));
    
    return in_lane * dash;
}

float edge_lines(vec2 uv, float road_uv_x) {
    float half_width = lane_width * 0.3;
    
    float left_edge = smoothstep(0.08 - half_width, 0.08, road_uv_x) 
                    * (1.0 - smoothstep(0.08 + half_width, 0.08 + half_width + 0.01, road_uv_x));
    
    float right_edge = smoothstep(0.92 - half_width, 0.92, road_uv_x) 
                     * (1.0 - smoothstep(0.92 + half_width, 0.92 + half_width + 0.01, road_uv_x));
    
    // More aggressive wear on edge lines
    float wear = noise(uv * 15.0);
    float worn_mask = step(0.25, wear);
    
    return (left_edge + right_edge) * worn_mask;
}

// ============================================
// MAIN FRAGMENT SHADER
// ============================================

void fragment() {
    vec2 uv = UV * uv_scale;
    vec2 road_uv = UV;
    
    // ----------------------------------------
    // BASE ASPHALT COLOR
    // Mostly uniform with very subtle variation
    // ----------------------------------------
    
    // Very subtle warm/cool gray patches (no green tint!)
    float color_var = noise(uv * 0.2);
    vec3 base_color = mix(asphalt_cool, asphalt_warm, color_var);
    base_color = mix(base_color, asphalt_color, 0.7); // Mostly neutral
    
    // Very subtle wear patterns - tire tracks etc
    float wear_pattern = fbm(uv * 0.5, 2);
    base_color *= (0.96 + wear_pattern * wear_intensity * 0.5);
    
    // ----------------------------------------
    // AGGREGATE TEXTURE
    // Very subtle pebble/stone texture
    // ----------------------------------------
    float aggregate = aggregate_pattern(uv);
    
    // Apply very subtle lightness variation
    base_color *= (1.0 - aggregate_intensity * 0.3 + aggregate * aggregate_intensity * 0.6);
    
    // ----------------------------------------
    // SPARSE CRACKS
    // Isolated damage areas only
    // ----------------------------------------
    float cracks = sparse_cracks(uv);
    
    // Subtle darkening where cracks exist
    base_color *= (1.0 - cracks * crack_darkness);
    
    // ----------------------------------------
    // REPAIR PATCHES (very rare)
    // Slightly different aged asphalt
    // ----------------------------------------
    float patches = repair_patches(uv);
    vec3 patch_color = asphalt_color * 1.05; // Very slightly lighter
    base_color = mix(base_color, patch_color, patches * 0.2);
    
    // ----------------------------------------
    // LANE MARKINGS - 1960s Style
    // ----------------------------------------
    float center_lane = center_dashes(uv, road_uv.x);
    float edge_lane = edge_lines(uv, road_uv.x);
    float all_lanes = max(center_lane, edge_lane);
    
    // Aged, faded lane markings with yellowed patina
    vec3 faded_lane_color = mix(base_color, lane_color, lane_fade);
    
    // Period-appropriate wear and grime
    float lane_dirt = noise(uv * 25.0) * 0.12;
    faded_lane_color *= (1.0 - lane_dirt);
    
    base_color = mix(base_color, faded_lane_color, all_lanes);
    
    // ----------------------------------------
    // NORMAL PERTURBATION
    // Subtle surface texture
    // ----------------------------------------
    float eps = 0.01;
    float noise_center = aggregate_pattern(uv);
    float noise_right = aggregate_pattern(uv + vec2(eps, 0.0));
    float noise_up = aggregate_pattern(uv + vec2(0.0, eps));
    
    float dx = (noise_right - noise_center) / eps;
    float dy = (noise_up - noise_center) / eps;
    
    // Add crack influence to normals
    dx += cracks * 0.3;
    
    vec3 perturbed_normal = normalize(vec3(-dx * normal_strength, -dy * normal_strength, 1.0));
    
    // ----------------------------------------
    // FINAL OUTPUT
    // ----------------------------------------
    ALBEDO = base_color;
    ROUGHNESS = roughness;
    SPECULAR = 0.3; // Slight specular for asphalt
    
    // Apply subtle normal perturbation
    NORMAL = normalize(NORMAL + vec3(perturbed_normal.x, 0.0, perturbed_normal.y) * 0.5);
    
    METALLIC = 0.0;
}
