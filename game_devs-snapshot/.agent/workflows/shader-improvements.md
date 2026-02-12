---
description: Workflow for improving and creating spatial shaders in Godot 4
---

# Shader Improvement Workflow

This workflow guides the process of creating, improving, and testing spatial shaders for the Urban Survivor game.

## Prerequisites
- Godot 4.3+ installed
- Access to `game/assets/shaders/` directory
- Understanding of target visual style (reference `docs/ART_GUIDELINES.md`)

---

## Step 1: Review Design Requirements
1. Check the relevant level design document (e.g., `docs/LEVEL_1_DESIGN.md`)
2. Identify the target color palette and visual goals
3. Screenshot the current state for before/after comparison

---

## Step 2: Analyze Existing Shader
1. Open the target shader file in `game/assets/shaders/`
2. Document current uniforms, features, and limitations
3. List specific improvements needed

---

## Step 3: Plan Shader Modifications
Create a plan that includes:
- [ ] New uniforms to add
- [ ] New functions needed (noise, patterns, etc.)
- [ ] Performance considerations (avoid expensive operations in fragment())
- [ ] Fallback values for all uniforms

---

## Step 4: Implement Changes
// turbo
1. Back up the original shader:
   ```bash
   cp game/assets/shaders/<shader>.gdshader game/assets/shaders/<shader>.gdshader.bak
   ```

2. Edit the shader file incrementally:
   - Add one feature at a time
   - Test after each addition
   - Use `render_mode` appropriately

3. Common patterns to use:
   - **Procedural noise**: Use hash/noise functions for variation
   - **UV-based patterns**: Use `mod()`, `step()`, `smoothstep()` for lanes/markings
   - **Normal perturbation**: Modify `NORMAL` for fake bumps
   - **Detail blending**: Mix multiple noise octaves

---

## Step 5: Create Material Resource
1. Create a new `.tres` material file if one doesn't exist:
   ```
   game/assets/materials/<name>_material.tres
   ```

2. Set the shader path and configure uniform values
3. Apply to test geometry in the level

---

## Step 6: Test In-Editor
// turbo
1. Open the target scene in Godot editor:
   ```bash
   godot --editor game/scenes/levels/level_1.tscn
   ```

2. Verify visual appearance from multiple camera angles
3. Check performance in the Profiler (Debugger > Profiler tab)
4. Test with different lighting conditions

---

## Step 7: Document Changes
1. Update the level design document with shader improvements made
2. Add before/after screenshots to documentation
3. Note any uniform values that work well for future reference

---

## Common Shader Techniques Reference

### Procedural Noise
```glsl
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
```

### Lane Markings
```glsl
// Dashed center line
float lane = step(0.48, uv.x) * step(uv.x, 0.52);
float dashes = step(0.5, mod(uv.y * dash_frequency, 1.0));
float marking = lane * dashes;
```

### Normal Perturbation
```glsl
vec3 perturbed_normal = normalize(NORMAL + vec3(noise_x, 0.0, noise_z) * strength);
NORMAL = perturbed_normal;
```

### Crack Patterns
```glsl
// Voronoi-based cracks or FBM noise with high contrast
float crack = smoothstep(crack_threshold, crack_threshold + 0.05, noise_value);
```

---

## Performance Guidelines
- Avoid `texture()` calls in loops
- Prefer procedural over texture-based when possible for mobile
- Use `varying` to pass computations from vertex() to fragment()
- Limit noise octaves (2-3 max for real-time)
- Consider LOD for distant surfaces
