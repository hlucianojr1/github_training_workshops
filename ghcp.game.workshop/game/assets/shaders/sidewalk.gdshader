shader_type spatial;

// ============================================
// 1960s NYC CONCRETE SIDEWALK SHADER
// Large rectangular concrete slabs with seams
// Based on vintage photography reference
// ============================================

// Base concrete appearance
uniform vec3 concrete_color : source_color = vec3(0.627, 0.627, 0.627); // #A0A0A0 medium gray
uniform vec3 concrete_light : source_color = vec3(0.68, 0.68, 0.67); // Lighter patches
uniform vec3 concrete_dark : source_color = vec3(0.55, 0.54, 0.53); // Darker patches
uniform float roughness : hint_range(0.0, 1.0) = 0.85;

// Slab dimensions (world-scale approximate)
uniform float slab_width : hint_range(0.5, 4.0) = 1.5; // Width of each slab
uniform float slab_length : hint_range(1.0, 8.0) = 3.0; // Length of each slab
uniform float uv_scale : hint_range(1.0, 20.0) = 4.0;

// Groove/seam properties
uniform float groove_width : hint_range(0.005, 0.05) = 0.015; // Thin seam lines
uniform float groove_darkness : hint_range(0.2, 0.8) = 0.45; // How dark the grooves are
uniform float groove_depth : hint_range(0.0, 0.3) = 0.12; // Normal perturbation for depth

// Surface detail
uniform float surface_variation : hint_range(0.0, 0.2) = 0.08; // Color patches
uniform float dirt_amount : hint_range(0.0, 0.3) = 0.1; // Dirt in grooves
uniform float wear_intensity : hint_range(0.0, 0.2) = 0.06; // Traffic wear

// ============================================
// NOISE FUNCTIONS
// ============================================

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
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

// Fractal Brownian Motion for surface detail
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
// RECTANGULAR SLAB GRID PATTERN
// ============================================

// Returns groove mask (1.0 = groove, 0.0 = slab surface)
float slab_grid(vec2 uv, out vec2 slab_id) {
    // Scale UV to slab dimensions
    vec2 slab_uv = uv / vec2(slab_width, slab_length);
    
    // Offset every other row for brick-like pattern
    float row = floor(slab_uv.y);
    if (mod(row, 2.0) > 0.5) {
        slab_uv.x += 0.5;
    }
    
    // Get slab ID for per-slab variation
    slab_id = floor(slab_uv);
    
    // Get position within slab (0-1)
    vec2 local_uv = fract(slab_uv);
    
    // Calculate groove masks for edges
    float half_groove = groove_width * 0.5;
    
    // Horizontal grooves (between rows)
    float h_groove = smoothstep(0.0, half_groove, local_uv.y) * 
                     (1.0 - smoothstep(1.0 - half_groove, 1.0, local_uv.y));
    
    // Vertical grooves (between columns)
    float v_groove = smoothstep(0.0, half_groove, local_uv.x) * 
                     (1.0 - smoothstep(1.0 - half_groove, 1.0, local_uv.x));
    
    // Combine: 0 at edges (grooves), 1 in center (surface)
    float surface_mask = h_groove * v_groove;
    
    return 1.0 - surface_mask; // Invert: 1 = groove, 0 = surface
}

// ============================================
// PER-SLAB SURFACE VARIATION
// ============================================

vec3 slab_color_variation(vec2 slab_id, vec2 local_uv, vec3 base_color) {
    // Each slab gets slightly different color based on its ID
    float slab_hash = hash(slab_id * 17.3);
    
    // Blend between light and dark variants
    vec3 slab_base = mix(concrete_dark, concrete_light, slab_hash);
    slab_base = mix(base_color, slab_base, surface_variation * 2.0);
    
    // Add fine surface texture within each slab
    float surface_noise = fbm(local_uv * 8.0 + slab_id * 5.0, 2);
    slab_base *= (0.95 + surface_noise * 0.1);
    
    return slab_base;
}

// ============================================
// WEATHERING AND DIRT
// ============================================

float edge_dirt(vec2 uv, float groove_mask) {
    // Dirt accumulates near grooves
    float dirt_noise = noise(uv * 30.0);
    float edge_proximity = smoothstep(0.0, 0.15, groove_mask);
    return dirt_noise * edge_proximity * dirt_amount;
}

float traffic_wear(vec2 uv) {
    // Subtle wear patterns from foot traffic
    float wear = fbm(uv * 0.8, 2);
    // More wear in center of sidewalk
    float center_bias = 1.0 - abs(fract(uv.x * 0.5) - 0.5) * 2.0;
    return wear * center_bias * wear_intensity;
}

// ============================================
// MAIN FRAGMENT SHADER
// ============================================

void fragment() {
    vec2 uv = UV * uv_scale;
    
    // ----------------------------------------
    // SLAB GRID PATTERN
    // ----------------------------------------
    vec2 slab_id;
    float groove = slab_grid(uv, slab_id);
    
    // Get local position within slab for variation
    vec2 slab_uv = uv / vec2(slab_width, slab_length);
    float row = floor(slab_uv.y);
    if (mod(row, 2.0) > 0.5) {
        slab_uv.x += 0.5;
    }
    vec2 local_uv = fract(slab_uv);
    
    // ----------------------------------------
    // BASE CONCRETE COLOR WITH VARIATION
    // ----------------------------------------
    vec3 base_color = slab_color_variation(slab_id, local_uv, concrete_color);
    
    // ----------------------------------------
    // APPLY GROOVES
    // ----------------------------------------
    float groove_darkening = groove * groove_darkness;
    base_color *= (1.0 - groove_darkening);
    
    // Add dirt in grooves
    float dirt = edge_dirt(uv, groove);
    base_color *= (1.0 - dirt * 0.5);
    
    // ----------------------------------------
    // WEATHERING
    // ----------------------------------------
    float wear = traffic_wear(uv);
    // Worn areas are slightly lighter (polished by feet)
    base_color = mix(base_color, base_color * 1.05, wear);
    
    // ----------------------------------------
    // NORMAL PERTURBATION FOR DEPTH
    // ----------------------------------------
    float eps = 0.02;
    vec2 dummy_id;
    float groove_center = slab_grid(uv, dummy_id);
    float groove_right = slab_grid(uv + vec2(eps, 0.0), dummy_id);
    float groove_up = slab_grid(uv + vec2(0.0, eps), dummy_id);
    
    float dx = (groove_right - groove_center) / eps;
    float dy = (groove_up - groove_center) / eps;
    
    // Add surface texture to normal
    float surface_right = fbm((uv + vec2(eps, 0.0)) * 5.0, 2);
    float surface_up = fbm((uv + vec2(0.0, eps)) * 5.0, 2);
    float surface_center = fbm(uv * 5.0, 2);
    dx += (surface_right - surface_center) * 0.2;
    dy += (surface_up - surface_center) * 0.2;
    
    vec3 perturbed_normal = normalize(vec3(-dx * groove_depth, -dy * groove_depth, 1.0));
    
    // ----------------------------------------
    // FINAL OUTPUT
    // ----------------------------------------
    ALBEDO = base_color;
    ROUGHNESS = roughness;
    SPECULAR = 0.25;
    METALLIC = 0.0;
    
    // Apply normal perturbation
    NORMAL = normalize(NORMAL + vec3(perturbed_normal.x, 0.0, perturbed_normal.y) * 0.6);
}
