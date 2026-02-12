---
agent: 'environment-artist'
description: 'Implement volumetric lighting, dramatic shadows, and atmospheric dust particles for post-apocalyptic mood.'
---

Implement volumetric lighting and particle atmosphere for NYC ruins.

## Load Context First
- docs/ART_GUIDELINES.md
- game/scenes/ (level scenes)
- Existing WorldEnvironment configuration

## Requirements
- God rays / light shafts through ruins
- Floating dust particles in air
- Ground-level fog wisps
- Dramatic shadow contrast
- Debris particles near destruction

## Steps

1) Configure Volumetric Fog for Light Shafts:
   ```gdscript
   # In WorldEnvironment
   environment.volumetric_fog_enabled = true
   environment.volumetric_fog_density = 0.03
   environment.volumetric_fog_albedo = Color(0.8, 0.75, 0.7)
   environment.volumetric_fog_emission = Color(0, 0, 0)
   environment.volumetric_fog_gi_inject = 1.0
   
   # DirectionalLight3D
   light.light_volumetric_fog_energy = 1.5
   ```

2) Create Ambient Dust Particle System:
   ```
   GPUParticles3D: "AmbientDust"
   ├── Amount: 300
   ├── Lifetime: 10.0
   ├── Visibility AABB: Large (cover playable area)
   └── Process Material:
       ├── Emission Shape: Box (50m x 10m x 50m)
       ├── Direction: (0, -0.1, 0)
       ├── Initial Velocity: 0.1-0.3 (random)
       ├── Gravity: (0, -0.02, 0)
       ├── Scale: 0.01-0.03
       └── Color: RGBA(0.7, 0.65, 0.55, 0.3)
   
   Material: Unshaded, billboard, soft particles
   ```

3) Create Ground Fog Wisps:
   ```
   GPUParticles3D: "GroundFog"
   ├── Amount: 50
   ├── Lifetime: 15.0
   └── Process Material:
       ├── Emission Shape: Box (ground level, 1m height)
       ├── Direction: Horizontal drift
       ├── Initial Velocity: 0.2
       ├── Damping: 0.5
       ├── Scale: 0.5-2.0
       └── Color: RGBA(0.8, 0.8, 0.8, 0.15)
   
   Material: Additive blend, billboard
   ```

4) Add Debris Particles Near Rubble:
   ```
   GPUParticles3D: "LocalDebris" (place near destruction)
   ├── Amount: 30
   ├── Lifetime: 5.0
   └── Process Material:
       ├── Emission Shape: Small box
       ├── Direction: Upward with spread
       ├── Gravity: (0, -0.5, 0)
       ├── Scale: 0.005-0.02
       └── Color: Match rubble color
   ```

5) Configure Shadow Quality:
   ```
   DirectionalLight3D:
   ├── Shadow enabled: true
   ├── Shadow bias: 0.1
   ├── Shadow normal bias: 1.0
   ├── Shadow pancake size: 20.0
   └── Shadow mode: SHADOW_PARALLEL_4_SPLITS
   
   Project Settings > Rendering > Lights and Shadows:
   ├── Directional shadow size: 4096
   └── Positional shadow atlas size: 4096
   ```

6) Add Spot Volumetric Lights (for interiors):
   ```
   SpotLight3D: (through windows, holes in ceiling)
   ├── Light volumetric fog energy: 2.0
   ├── Shadow enabled: true
   └── Spot angle: 30-45 degrees
   ```

## Performance Optimization
- LOD particles: reduce amount when distant
- Particle pooling: reuse particle systems
- Shadow distance: limit to 50m for directional
- Volumetric fog steps: balance quality/performance

## Acceptance Criteria
- [ ] Visible light shafts through gaps in ruins
- [ ] Dust particles floating in lit areas
- [ ] Ground fog adds depth to rubble
- [ ] Shadows create dramatic contrast
- [ ] No flickering or visual artifacts
- [ ] Maintains 60 FPS target (test on Low settings)
