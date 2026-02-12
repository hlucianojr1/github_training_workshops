---
agent: 'environment-artist'
description: 'Configure WorldEnvironment for 1960s post-apocalyptic NYC aesthetic with proper lighting, fog, and color grading.'
---

Setup WorldEnvironment for the 1960s post-apocalyptic NYC look.

## Load Context First
- docs/ART_GUIDELINES.md (color palettes)
- docs/SPEC.md Section 8 (Visual Style)
- game/scenes/ (existing level scenes)

## Requirements
- Overcast sky reflecting nuclear winter atmosphere
- Muted, desaturated color grading (1960s film look)
- Volumetric fog for depth and atmosphere
- Dramatic shadows for tension
- ACES tonemapping for cinematic feel

## Steps

1) Create or locate WorldEnvironment node in main level scene

2) Configure Environment resource:
   ```
   Background: Sky
   Sky: ProceduralSky with overcast colors
   - Sky top: #778899 (slate gray)
   - Sky horizon: #A9A9A9 (gray)
   - Ground bottom: #8B7355 (dust brown)
   
   Ambient Light:
   - Source: Sky
   - Color: #998877 (warm dust)
   - Energy: 0.3
   ```

3) Configure Fog:
   ```
   Fog enabled: true
   Light color: #B3A99A (dusty)
   Density: 0.001
   Height: 0
   Height density: 0.5
   
   Volumetric Fog enabled: true
   Density: 0.02
   Albedo: #CCC4B8
   ```

4) Configure Tonemapping:
   ```
   Mode: ACES
   Exposure: 1.0
   White: 6.0
   ```

5) Configure Adjustments:
   ```
   Enabled: true
   Brightness: 1.0
   Contrast: 1.1
   Saturation: 0.8 (desaturated period look)
   ```

6) Configure Glow (subtle bloom):
   ```
   Enabled: true
   Intensity: 0.3
   Bloom: 0.1
   ```

7) Add DirectionalLight3D for sun:
   ```
   Color: #F5EDE5 (warm white)
   Energy: 0.8
   Rotation: (-45°, 30°, 0°) for dramatic shadows
   Shadow enabled: true
   Shadow mode: PARALLEL_4_SPLITS
   ```

## Acceptance Criteria
- [ ] Level has visible atmospheric depth/fog
- [ ] Colors appear muted and period-appropriate
- [ ] Shadows are dramatic but not pure black
- [ ] No harsh/saturated modern game look
- [ ] Silhouettes readable at 50+ meters
- [ ] Performance: maintains 60 FPS at 1080p
