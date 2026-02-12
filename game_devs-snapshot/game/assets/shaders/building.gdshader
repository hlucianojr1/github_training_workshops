shader_type spatial;

uniform vec3 brick_color : source_color = vec3(0.545, 0.0, 0.0); // #8B0000
uniform vec3 mortar_color : source_color = vec3(0.6, 0.6, 0.6);
uniform float brick_scale = 10.0;
uniform float mortar_thickness = 0.05;
uniform float roughness = 0.8;

// Simple pseudo-random function
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV * brick_scale;
    
    // Offset every other row
    float row_index = floor(uv.y);
    if (mod(row_index, 2.0) != 0.0) {
        uv.x += 0.5;
    }
    
    vec2 brick_uv = fract(uv);
    
    // Calculate mortar mask
    // 0 = mortar, 1 = brick
    vec2 border = step(vec2(mortar_thickness), brick_uv) - step(vec2(1.0 - mortar_thickness), brick_uv);
    float mask = border.x * border.y;
    
    // Add some noise/texture to the brick color
    float noise = random(floor(uv)); // Random value per brick
    vec3 base_color = mix(brick_color * 0.8, brick_color * 1.2, noise);
    
    ALBEDO = mix(mortar_color, base_color, mask);
    ROUGHNESS = mix(1.0, roughness, mask); // Mortar is rougher (1.0)
    
    // Simple normal map effect based on edges
    // Just forcing normals up for now, could be improved with height to normal
    NORMAL = vec3(0.0, 0.0, 1.0);
}
