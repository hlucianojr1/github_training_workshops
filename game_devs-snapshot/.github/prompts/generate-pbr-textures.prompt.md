---
agent: 'texture-artist'
description: 'Generate PBR textures for a model using AI image generation and processing.'
---

Generate PBR texture set for a 3D model.

## Load Context First
- Model spec: `docs/models/[MODEL]_SPEC.md`
- Art guidelines: `docs/ART_GUIDELINES.md` (color palette, materials)
- Existing textures: `game/assets/textures/`

## Input Parameters
- **Model Name**: Which model to texture (e.g., player, scavenger, sedan)
- **Texture Resolution**: 512 | 1024 | 2048
- **Material Zones**: List of materials needed
- **Weathering Level**: pristine | light | heavy | destroyed

## Workflow

### Phase 1: Define Material Zones

For a character like the player:
```
Material Zones:
├── Skin (face, hands)
├── Hair
├── Jacket_Leather (bomber jacket)
├── Shirt_Cotton (t-shirt)
├── Pants_Wool (slacks)
├── Boots_Leather (work boots)
└── Metal_Brass (buckles, zippers)
```

### Phase 2: Generate Albedo Prompts

Create prompts for AI image generation:

**Skin**:
```
"Seamless tileable texture of caucasian human skin, weathered and 
sun-damaged, slight stubble texture, 8k, PBR albedo map, no shadows, 
flat studio lighting, color #D2A679"
```

**Leather Jacket**:
```
"Seamless tileable texture of worn brown leather bomber jacket material, 
1950s vintage, scratched and scuffed, visible grain, 8k, PBR albedo map, 
no shadows, flat lighting, saddle brown #8B4513"
```

**Cotton T-Shirt**:
```
"Seamless tileable texture of dirty off-white cotton t-shirt fabric, 
sweat stains, worn threads, 1960s vintage, 8k, PBR albedo map, no shadows"
```

**Wool Slacks**:
```
"Seamless tileable texture of dark gray wool trouser fabric, high-waisted 
1960s style, slight wear at knees, 8k, PBR albedo map, no shadows, #4A4A4A"
```

**Leather Boots**:
```
"Seamless tileable texture of worn brown leather work boot, scuffed toe, 
creased leather, 1950s work wear, 8k, PBR albedo map, no shadows, #654321"
```

### Phase 3: Generate Images

**Option A: Stable Diffusion (Recommended for seamless)**
```bash
# Using stable-diffusion-webui API
curl -X POST http://localhost:7860/sdapi/v1/txt2img \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Seamless tileable texture of worn brown leather...",
    "negative_prompt": "shadows, lighting, gradients, seams, borders",
    "steps": 30,
    "width": 1024,
    "height": 1024,
    "sampler_name": "DPM++ 2M Karras",
    "cfg_scale": 7
  }'
```

**Option B: DALL-E 3 API**
```bash
curl https://api.openai.com/v1/images/generations \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "dall-e-3",
    "prompt": "Seamless tileable texture of worn brown leather...",
    "size": "1024x1024",
    "quality": "hd"
  }'
```

### Phase 4: Make Seamless (If Needed)

```bash
# Using ImageMagick offset method
convert input.png \
  \( +clone -roll +512+512 \) \
  -gravity center -compose blend -composite \
  seamless.png

# Or using GIMP CLI
gimp -i -b '(python-fu-tile-seamless RUN-NONINTERACTIVE "input.png" "output.png")' -b '(gimp-quit 0)'
```

### Phase 5: Generate Normal Map

**Using Blender (recommended)**:
```python
# save as generate_normal.py
import bpy
import sys

input_path = sys.argv[-2]
output_path = sys.argv[-1]

# Create material with normal map node setup
# Use Blender's built-in normal map baking
```

**Using online tools**:
- NormalMap-Online.com
- Materialize (free software)

**Using command line** (approximation):
```bash
# Sobel filter approximation
convert input.png -colorspace Gray \
  \( +clone -morphology Convolve Sobel:0 \) \
  \( +clone -morphology Convolve Sobel:90 \) \
  \( -clone 0 -fill "rgb(128,128,255)" -colorize 100 \) \
  -delete 0 -combine normal_approx.png
```

### Phase 6: Create ORM Map

```bash
# R = Ambient Occlusion (from albedo grayscale or cavity map)
convert albedo.png -colorspace Gray -level 20%,80% ao_channel.png

# G = Roughness (based on material type)
# For leather (roughness ~0.5):
convert -size 1024x1024 xc:"gray(50%)" roughness_leather.png
# For fabric (roughness ~0.8):
convert -size 1024x1024 xc:"gray(80%)" roughness_fabric.png

# B = Metallic (0 for non-metals, 255 for metals)
convert -size 1024x1024 xc:black metallic_zero.png

# Combine
convert ao_channel.png roughness_leather.png metallic_zero.png \
  -combine orm_combined.png
```

### Phase 7: Organize Output

```bash
# Create directory structure
mkdir -p game/assets/textures/characters/player

# Copy processed textures
cp skin_albedo.png game/assets/textures/characters/player/
cp jacket_albedo.png game/assets/textures/characters/player/
# etc.
```

### Phase 8: Create Godot Material

Generate `.tres` material file:

```gdresource
[gd_resource type="StandardMaterial3D" format=3]

[ext_resource type="Texture2D" path="res://assets/textures/characters/player/jacket_albedo.png" id="1"]
[ext_resource type="Texture2D" path="res://assets/textures/characters/player/jacket_normal.png" id="2"]
[ext_resource type="Texture2D" path="res://assets/textures/characters/player/jacket_orm.png" id="3"]

[resource]
albedo_texture = ExtResource("1")
normal_enabled = true
normal_texture = ExtResource("2")
ao_enabled = true
ao_texture = ExtResource("3")
ao_texture_channel = 0
roughness_texture = ExtResource("3")
roughness_texture_channel = 1
metallic_texture = ExtResource("3")
metallic_texture_channel = 2
```

## Per-Model Texture Atlas Option

For characters, consider UV-packing all materials into one atlas:

```
Texture Atlas (2048x2048):
┌────────┬────────┐
│  Skin  │ Jacket │
│ (512²) │ (512²) │
├────────┼────────┤
│ Shirt  │ Pants  │
│ (512²) │ (512²) │
├────────┴────────┤
│     Boots       │
│    (1024x512)   │
└─────────────────┘
```

**Combine into atlas**:
```bash
montage skin.png jacket.png shirt.png pants.png boots.png \
  -tile 2x3 -geometry 512x512+0+0 atlas_albedo.png
```

## Verification

- [ ] All textures tile seamlessly
- [ ] No visible seams when applied to model
- [ ] Colors match spec palette
- [ ] Weathering appropriate for asset
- [ ] Resolution matches requirements
- [ ] Named correctly

## Acceptance Criteria
- [ ] Albedo maps generated for all material zones
- [ ] Normal maps created (optional for simple props)
- [ ] ORM maps packed correctly
- [ ] Textures copied to correct asset folder
- [ ] Godot material files created (optional)
