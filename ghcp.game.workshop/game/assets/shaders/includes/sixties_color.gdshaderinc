// sixties_color.gdshaderinc
// Urban Survivor - 1960s NYC Shader Include Library
// Period-accurate color transforms, LUT emulation, and color grading
// Emulates Kodachrome, Ektachrome, and other 1960s film stocks

// ============================================================================
// 1960s COLOR PALETTE CONSTANTS
// ============================================================================

// Primary palette colors (vec3 in 0-1 range)
const vec3 INDUSTRIAL_GRAY = vec3(0.42, 0.42, 0.42);    // #6B6B6B
const vec3 MUTED_BROWN = vec3(0.55, 0.45, 0.33);        // #8B7355
const vec3 OLIVE_DRAB = vec3(0.42, 0.56, 0.14);         // #6B8E23
const vec3 FADED_RED = vec3(0.80, 0.36, 0.36);          // #CD5C5C
const vec3 STEEL_BLUE = vec3(0.27, 0.51, 0.71);         // #4682B4
const vec3 DIRTY_YELLOW = vec3(0.72, 0.53, 0.04);       // #B8860B

// Shadow and highlight tints
const vec3 SHADOW_TINT = vec3(0.29, 0.23, 0.30);        // Slight magenta
const vec3 HIGHLIGHT_TINT = vec3(0.96, 0.96, 0.86);     // Yellow-cream

// ============================================================================
// LUMINANCE & UTILITY
// ============================================================================

// Rec. 601 luminance (period-accurate for analog TV era)
float luma_601(vec3 color) {
	return dot(color, vec3(0.299, 0.587, 0.114));
}

// Rec. 709 luminance (modern standard)
float luma_709(vec3 color) {
	return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

// ============================================================================
// KODACHROME (1960s Flagship - Warm, Saturated)
// ============================================================================

// Kodachrome color characteristics:
// - Rich, saturated colors
// - Warm shadows (magenta-brown)
// - Yellow-green highlights
// - Excellent skin tones
// - Deep blacks

vec3 kodachrome_grade(vec3 color) {
	// Lift shadows toward magenta-brown
	vec3 shadows = vec3(0.05, 0.02, 0.04);
	
	// Push highlights toward yellow-green
	vec3 highlights = vec3(1.02, 1.01, 0.95);
	
	// Increase saturation slightly
	float luma = luma_601(color);
	vec3 saturated = mix(vec3(luma), color, 1.15);
	
	// Contrast curve (slight S-curve)
	saturated = saturated * saturated * (3.0 - 2.0 * saturated) * 0.1 + saturated * 0.9;
	
	// Apply lift and gain
	return (saturated + shadows) * highlights;
}

// Kodachrome with intensity control
vec3 kodachrome_grade_intensity(vec3 color, float intensity) {
	vec3 graded = kodachrome_grade(color);
	return mix(color, graded, intensity);
}

// ============================================================================
// EKTACHROME (Cooler, Higher Contrast)
// ============================================================================

// Ektachrome color characteristics:
// - Cooler overall tone
// - Higher contrast
// - Cyan shadows
// - Neutral-cool highlights
// - Punchy colors

vec3 ektachrome_grade(vec3 color) {
	// Lift shadows toward cyan-blue
	vec3 shadows = vec3(0.02, 0.03, 0.05);
	
	// Slightly cool highlights
	vec3 highlights = vec3(0.98, 1.0, 1.03);
	
	// Higher saturation
	float luma = luma_601(color);
	vec3 saturated = mix(vec3(luma), color, 1.25);
	
	// Strong S-curve contrast
	vec3 curved = saturated * saturated * (3.0 - 2.0 * saturated);
	curved = mix(saturated, curved, 0.3);
	
	return (curved + shadows) * highlights;
}

vec3 ektachrome_grade_intensity(vec3 color, float intensity) {
	vec3 graded = ektachrome_grade(color);
	return mix(color, graded, intensity);
}

// ============================================================================
// AGFACOLOR (European Look - Muted, Earthy)
// ============================================================================

// Agfacolor characteristics:
// - Muted, earthy tones
// - Lower saturation than American stocks
// - Brown-green shadows
// - Warm but subdued

vec3 agfacolor_grade(vec3 color) {
	// Brown-green shadows
	vec3 shadows = vec3(0.03, 0.03, 0.01);
	
	// Warm highlights
	vec3 highlights = vec3(1.02, 1.0, 0.95);
	
	// Reduced saturation
	float luma = luma_601(color);
	vec3 desaturated = mix(vec3(luma), color, 0.85);
	
	// Lower contrast
	vec3 result = desaturated * 0.9 + 0.05;
	
	return (result + shadows) * highlights;
}

// ============================================================================
// CROSS PROCESS (Experimental Look)
// ============================================================================

// Cross-process: E-6 slide film developed in C-41 chemistry
// - Cyan shadows, yellow highlights
// - Extreme color shifts
// - High contrast
// - Used for psychedelic/experimental scenes

vec3 cross_process(vec3 color) {
	// Channel-specific gamma adjustments
	color.r = pow(color.r, 0.85);
	color.g = pow(color.g, 1.0);
	color.b = pow(color.b, 1.15);
	
	// Push to extremes
	color = color * color * (3.0 - 2.0 * color);
	
	// Cyan shadows
	float luma = luma_601(color);
	vec3 shadow_tint = vec3(0.7, 0.9, 1.0);
	color = mix(color * shadow_tint, color, smoothstep(0.0, 0.5, luma));
	
	return color;
}

vec3 cross_process_intensity(vec3 color, float intensity) {
	vec3 processed = cross_process(color);
	return mix(color, processed, intensity);
}

// ============================================================================
// DESATURATION & FADING
// ============================================================================

// Selective desaturation (preserves warm tones - browns, reds, yellows)
vec3 sixties_desaturate(vec3 color, float amount) {
	float luma = luma_601(color);
	
	// Calculate warmth (how much red exceeds blue)
	float warmth = max(color.r - color.b, 0.0) + max(color.r - color.g, 0.0) * 0.5;
	
	// Preserve warm colors
	float preserve = clamp(warmth * 3.0, 0.0, 1.0);
	float final_amount = amount * (1.0 - preserve);
	
	return mix(color, vec3(luma), final_amount);
}

// Faded film look (old/damaged print)
vec3 faded_film(vec3 color, float fade_amount) {
	float luma = luma_601(color);
	
	// Lift blacks
	color = color + fade_amount * 0.1;
	
	// Reduce saturation
	color = mix(vec3(luma), color, 1.0 - fade_amount * 0.5);
	
	// Yellow tint
	color = mix(color, color * vec3(1.05, 1.02, 0.9), fade_amount * 0.5);
	
	return color;
}

// ============================================================================
// SEPIA & MONOCHROME
// ============================================================================

// Classic sepia tint
vec3 sepia_tint(vec3 color, float intensity) {
	vec3 sepia = vec3(
		dot(color, vec3(0.393, 0.769, 0.189)),
		dot(color, vec3(0.349, 0.686, 0.168)),
		dot(color, vec3(0.272, 0.534, 0.131))
	);
	return mix(color, sepia, intensity);
}

// Orthochromatic (blue-blind B&W - 1920s-30s look)
float orthochromatic_luma(vec3 color) {
	// Blue contributes less, red more
	return dot(color, vec3(0.45, 0.45, 0.10));
}

// Panchromatic B&W (standard B&W film)
vec3 panchromatic_bw(vec3 color) {
	float luma = luma_601(color);
	return vec3(luma);
}

// ============================================================================
// LIFT / GAMMA / GAIN (Standard Color Grading)
// ============================================================================

// Lift (shadows), Gamma (midtones), Gain (highlights)
vec3 lift_gamma_gain(vec3 color, vec3 lift, vec3 gamma, vec3 gain) {
	// Apply lift (add to shadows)
	color = color + lift * (1.0 - color);
	
	// Apply gamma (power function)
	color = pow(max(color, vec3(0.0)), 1.0 / gamma);
	
	// Apply gain (multiply highlights)
	color = color * gain;
	
	return clamp(color, vec3(0.0), vec3(1.0));
}

// Shadows / Midtones / Highlights (alternative grading)
vec3 shadows_midtones_highlights(vec3 color, vec3 shadows, vec3 midtones, vec3 highlights) {
	float luma = luma_601(color);
	
	// Weight functions
	float shadow_weight = 1.0 - smoothstep(0.0, 0.33, luma);
	float highlight_weight = smoothstep(0.67, 1.0, luma);
	float midtone_weight = 1.0 - shadow_weight - highlight_weight;
	
	// Apply tints
	vec3 result = color;
	result = mix(result, result * shadows, shadow_weight);
	result = mix(result, result * midtones, midtone_weight);
	result = mix(result, result * highlights, highlight_weight);
	
	return result;
}

// ============================================================================
// CONTRAST CURVES
// ============================================================================

// S-curve contrast
vec3 s_curve_contrast(vec3 color, float strength) {
	vec3 curved = color * color * (3.0 - 2.0 * color);
	return mix(color, curved, strength);
}

// Toe and shoulder (film-like response)
vec3 toe_shoulder(vec3 color, float toe, float shoulder) {
	// Toe (compress shadows)
	color = color / (color + toe) * (1.0 + toe);
	
	// Shoulder (roll off highlights)
	vec3 inv = 1.0 - color;
	inv = inv / (inv + shoulder) * (1.0 + shoulder);
	color = 1.0 - inv;
	
	return color;
}

// ============================================================================
// TEMPERATURE & TINT
// ============================================================================

// White balance adjustment
vec3 white_balance(vec3 color, float temperature, float tint) {
	// Temperature: negative = cooler (blue), positive = warmer (orange)
	// Tint: negative = green, positive = magenta
	
	color.r += temperature * 0.1;
	color.b -= temperature * 0.1;
	
	color.g -= tint * 0.1;
	color.r += tint * 0.05;
	color.b += tint * 0.05;
	
	return clamp(color, vec3(0.0), vec3(1.0));
}

// ============================================================================
// COMPOSITE 1960s GRADE
// ============================================================================

// Full 1960s Urban Survivor color grade
vec3 apply_sixties_grade(vec3 color, int preset, float intensity) {
	vec3 graded;
	
	if (preset == 0) {
		// Kodachrome (default)
		graded = kodachrome_grade(color);
	} else if (preset == 1) {
		// Ektachrome
		graded = ektachrome_grade(color);
	} else if (preset == 2) {
		// Cross-process
		graded = cross_process(color);
	} else if (preset == 3) {
		// Agfacolor
		graded = agfacolor_grade(color);
	} else {
		graded = color;
	}
	
	return mix(color, graded, intensity);
}
