---
applyTo: '**/*.{gdshader,gdshaderinc}'
---

# Godot Shader Development Rules for Urban Survivor

## File Organization

- **Surface shaders**: `game/assets/shaders/spatial/`
- **Post-processing**: `game/assets/shaders/post_process/`
- **Particles**: `game/assets/shaders/particles/`
- **Environment**: `game/assets/shaders/environment/`
- **Includes**: `game/assets/shaders/includes/`
- **Material presets**: `game/assets/materials/presets/`

## Shader Type Declaration

Always declare shader type on line 1:
```glsl
shader_type spatial;        // 3D objects
shader_type canvas_item;    // 2D, UI, post-processing
shader_type particles;      // GPU particles
shader_type sky;            // Sky rendering
shader_type fog;            // Volumetric fog
```

## Naming Conventions

- **Files**: `snake_case.gdshader` or `snake_case.gdshaderinc`
- **Uniforms**: `snake_case` (e.g., `base_color`, `grain_size`)
- **Functions**: `snake_case` (e.g., `apply_grain`, `calculate_fresnel`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `PI`, `MAX_STEPS`)
- **Varyings**: `v_` prefix (e.g., `varying vec3 v_world_pos;`)

## Required Header Comment

Every shader must have a header comment:
```glsl
shader_type spatial;

// Shader Name
// Urban Survivor - 1960s NYC Aesthetic
// Brief description of what this shader does
```

## Uniform Hints

Always use appropriate hints for editor usability:
```glsl
// Colors
uniform vec3 base_color : source_color = vec3(0.5);
uniform vec4 tint : source_color = vec4(1.0);

// Ranges
uniform float roughness : hint_range(0.0, 1.0) = 0.5;
uniform float intensity : hint_range(0.0, 2.0) = 1.0;

// Textures
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;
uniform sampler2D normal_map : hint_normal, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
```

## 1960s NYC Include Library

Use the project's include library for consistent aesthetic:
```glsl
#include "res://assets/shaders/includes/sixties_common.gdshaderinc"
#include "res://assets/shaders/includes/sixties_film.gdshaderinc"
#include "res://assets/shaders/includes/sixties_color.gdshaderinc"
#include "res://assets/shaders/includes/sixties_atmosphere.gdshaderinc"
```

## Render Modes (Spatial)

Document render mode choices:
```glsl
// Standard opaque PBR
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

// Transparent materials
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley;

// Unlit/emissive
render_mode unshaded;
```

## 1960s Color Palette

Use period-accurate colors:
```glsl
// Browns and earth tones
const vec3 RUST_BROWN = vec3(0.55, 0.28, 0.12);
const vec3 DIRT_BROWN = vec3(0.35, 0.28, 0.22);

// Industrial grays
const vec3 CONCRETE_GRAY = vec3(0.45, 0.43, 0.40);
const vec3 METAL_GRAY = vec3(0.35, 0.33, 0.30);

// Accent colors
const vec3 OLIVE_DRAB = vec3(0.42, 0.56, 0.14);
const vec3 FADED_RED = vec3(0.80, 0.35, 0.30);
const vec3 COOL_BLUE = vec3(0.27, 0.51, 0.71);

// Lighting temperatures
const vec3 TUNGSTEN_WARM = vec3(1.0, 0.85, 0.65);  // 2700K interiors
const vec3 DAYLIGHT_COOL = vec3(0.95, 0.98, 1.0);  // 6500K exteriors
```

## Performance Guidelines

1. **Avoid branching** in fragment shaders when possible
2. **Use `lowp`/`mediump`** for color values when precision allows
3. **Minimize texture samples** - combine channels when possible
4. **Pre-compute** values in vertex shader when applicable
5. **Use `const`** for compile-time constants

## Do NOT

- Use hardcoded magic numbers without comments
- Create shaders without uniform hints
- Skip the header comment
- Use non-standard naming conventions
- Forget to test with the post-processing stack active

## Do

- Test shaders with post_processing.tscn active
- Create `.tres` presets for reusable material configurations
- Document complex math with comments
- Use the include library for consistent noise/color functions
- Consider how the shader looks with film grain overlay
