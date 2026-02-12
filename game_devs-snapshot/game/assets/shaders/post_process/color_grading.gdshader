shader_type canvas_item;

// Color Grading Post-Process Shader
// Urban Survivor - 1960s NYC Aesthetic
// Emulates Kodachrome, Ektachrome, and other period film stocks

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Preset selection: 0=Kodachrome, 1=Ektachrome, 2=CrossProcess, 3=Agfacolor
uniform int preset : hint_range(0, 3) = 0;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

// Manual adjustments
uniform float saturation : hint_range(0.0, 2.0) = 1.0;
uniform float contrast : hint_range(0.5, 1.5) = 1.0;
uniform float brightness : hint_range(-0.5, 0.5) = 0.0;

// Temperature/tint
uniform float temperature : hint_range(-1.0, 1.0) = 0.0;
uniform float tint : hint_range(-1.0, 1.0) = 0.0;

// Luminance (Rec. 601 - period accurate)
float luma(vec3 color) {
	return dot(color, vec3(0.299, 0.587, 0.114));
}

// Kodachrome color grade
vec3 kodachrome(vec3 color) {
	vec3 shadows = vec3(0.05, 0.02, 0.04);
	vec3 highlights = vec3(1.02, 1.01, 0.95);
	
	float l = luma(color);
	vec3 saturated = mix(vec3(l), color, 1.15);
	saturated = saturated * saturated * (3.0 - 2.0 * saturated) * 0.1 + saturated * 0.9;
	
	return (saturated + shadows) * highlights;
}

// Ektachrome color grade
vec3 ektachrome(vec3 color) {
	vec3 shadows = vec3(0.02, 0.03, 0.05);
	vec3 highlights = vec3(0.98, 1.0, 1.03);
	
	float l = luma(color);
	vec3 saturated = mix(vec3(l), color, 1.25);
	vec3 curved = saturated * saturated * (3.0 - 2.0 * saturated);
	curved = mix(saturated, curved, 0.3);
	
	return (curved + shadows) * highlights;
}

// Cross-process color grade
vec3 cross_process(vec3 color) {
	color.r = pow(color.r, 0.85);
	color.g = pow(color.g, 1.0);
	color.b = pow(color.b, 1.15);
	
	color = color * color * (3.0 - 2.0 * color);
	
	float l = luma(color);
	vec3 shadow_tint = vec3(0.7, 0.9, 1.0);
	color = mix(color * shadow_tint, color, smoothstep(0.0, 0.5, l));
	
	return color;
}

// Agfacolor grade
vec3 agfacolor(vec3 color) {
	vec3 shadows = vec3(0.03, 0.03, 0.01);
	vec3 highlights = vec3(1.02, 1.0, 0.95);
	
	float l = luma(color);
	vec3 desaturated = mix(vec3(l), color, 0.85);
	vec3 result = desaturated * 0.9 + 0.05;
	
	return (result + shadows) * highlights;
}

// White balance
vec3 apply_white_balance(vec3 color) {
	color.r += temperature * 0.1;
	color.b -= temperature * 0.1;
	color.g -= tint * 0.1;
	color.r += tint * 0.05;
	color.b += tint * 0.05;
	return color;
}

void fragment() {
	vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	// Apply preset
	vec3 graded;
	if (preset == 0) {
		graded = kodachrome(screen);
	} else if (preset == 1) {
		graded = ektachrome(screen);
	} else if (preset == 2) {
		graded = cross_process(screen);
	} else {
		graded = agfacolor(screen);
	}
	
	// Blend with intensity
	vec3 result = mix(screen, graded, intensity);
	
	// Apply manual adjustments
	// Brightness
	result += brightness;
	
	// Contrast
	result = (result - 0.5) * contrast + 0.5;
	
	// Saturation
	float l = luma(result);
	result = mix(vec3(l), result, saturation);
	
	// Temperature/Tint
	result = apply_white_balance(result);
	
	// Clamp
	result = clamp(result, vec3(0.0), vec3(1.0));
	
	COLOR = vec4(result, 1.0);
}
