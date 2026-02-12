# Blender Scripts for Urban Survivor

This directory contains pre-built Python scripts for generating 3D models in Blender via MCP.

## Directory Structure

```
blender_scripts/
├── templates/           # Complete model generators
│   ├── humanoid_base_mesh.py    # Player/enemy base body
│   ├── vehicle_sedan.py         # 1960s sedan (coming soon)
│   └── building_facade.py       # Modular buildings (coming soon)
└── utilities/           # Helper scripts
    ├── apply_weathering.py      # Post-apocalyptic damage (coming soon)
    ├── generate_lods.py         # Create LOD levels (coming soon)
    └── setup_armature.py        # Add skeleton (coming soon)
```

## Usage via Blender MCP

### Basic Usage
```json
{
  "tool": "execute_python_script",
  "script": "exec(open('game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"
}
```

### With Parameters
```json
{
  "tool": "execute_python_script",
  "script": "HEIGHT=1.65; GENDER='female'; NAME='PlayerFemale'; exec(open('game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"
}
```

## Available Scripts

### humanoid_base_mesh.py

Creates a game-ready humanoid mesh with proper topology for animation.

**Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| HEIGHT | float | 1.75 | Total height in meters |
| GENDER | string | 'male' | 'male' or 'female' |
| SUBDIVISIONS | int | 1 | 0=low, 1=medium, 2=high poly |
| NAME | string | 'Humanoid_Base' | Object name in Blender |

**Output:**
- Single mesh object with proper edge loops
- Origin at base center (feet)
- Ready for subdivision surface modifier
- ~800 triangles at subdivision 0, ~3200 at subdivision 1

**Example - Male Player:**
```json
{
  "tool": "execute_python_script",
  "script": "HEIGHT=1.75; GENDER='male'; NAME='char_player_male'; SUBDIVISIONS=1; exec(open('game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"
}
```

**Example - Female Player:**
```json
{
  "tool": "execute_python_script",
  "script": "HEIGHT=1.65; GENDER='female'; NAME='char_player_female'; SUBDIVISIONS=1; exec(open('game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"
}
```

**Example - Scavenger Enemy:**
```json
{
  "tool": "execute_python_script",
  "script": "HEIGHT=1.70; GENDER='male'; NAME='char_enemy_scavenger'; SUBDIVISIONS=0; exec(open('game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"
}
```

## Adding New Scripts

When creating new template scripts, follow this pattern:

```python
"""
Script Name and Description

Usage via Blender MCP:
{
  "tool": "execute_python_script",
  "script": "exec(open('path/to/script.py').read())"
}
"""

import bpy
import bmesh

# Parameters with defaults (can be overridden via globals())
PARAM1 = globals().get('PARAM1', default_value)
PARAM2 = globals().get('PARAM2', default_value)

def main_function():
    # Your code here
    pass

# Execute
if __name__ == "__main__":
    main_function()
else:
    main_function()
```

## Integration with Agents

These scripts are used by the `blender-artist` agent via the `blender-create-*` prompts.

The workflow is:
1. Read model spec from `docs/models/`
2. Determine which template script to use
3. Set parameters based on spec
4. Execute script via MCP
5. Apply materials
6. Export to GLTF
