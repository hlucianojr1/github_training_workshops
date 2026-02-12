# Blender MCP Setup Guide

**Document Version**: 1.0  
**Created**: January 29, 2026  
**Purpose**: Setup instructions for Blender MCP server integration with VS Code AI agents

---

## Overview

Several Urban Survivor AI agents require the **Blender MCP (Model Context Protocol) Server** to create, modify, and export 3D assets. This guide covers installation, configuration, and troubleshooting.

### Agents Requiring Blender MCP

| Agent | MCP Usage |
|-------|-----------|
| **Blender AI Artist** | Full model creation, scene setup, rendering |
| **Texture Artist** | PBR material application, texture enhancement |
| **Character Artist** | Character modeling, rigging preparation |
| **Animation Artist** | Animation creation and export |
| **GLB Import Reviewer** | Model loading and quality verification |
| **Environment Artist** | Lighting, atmosphere, WorldEnvironment setup |

---

## Prerequisites

| Requirement | Minimum Version | Recommended |
|-------------|-----------------|-------------|
| **Blender** | 3.6 LTS | 4.0+ |
| **Python** | 3.10+ | 3.11 |
| **VS Code** | 1.85+ | Latest |
| **Node.js** | 18+ | 20 LTS |
| **RAM** | 8 GB | 16 GB+ |
| **GPU** | Any (CPU fallback) | NVIDIA RTX / Apple Silicon |

---

## Installation

### Step 1: Install Blender

#### macOS
```bash
# Option A: Download from blender.org
open https://www.blender.org/download/

# Option B: Homebrew
brew install --cask blender
```

#### Windows
```powershell
# Option A: Download from blender.org
Start-Process "https://www.blender.org/download/"

# Option B: Winget
winget install BlenderFoundation.Blender
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt install blender

# Or Flatpak (recommended for latest version)
flatpak install flathub org.blender.Blender
```

### Step 2: Install Blender MCP Addon

1. **Download the MCP Addon**
   ```bash
   # Clone the Blender MCP repository
   git clone https://github.com/ahujasid/blender-mcp.git
   cd blender-mcp
   ```

2. **Install in Blender**
   - Open Blender
   - Go to **Edit → Preferences → Add-ons**
   - Click **Install...**
   - Navigate to the cloned repo and select `addon.py` (or the zip file)
   - Enable the addon by checking the checkbox

3. **Verify Installation**
   - In Blender, press `N` to open the sidebar
   - Look for the **MCP** tab
   - You should see MCP server controls

### Step 3: Configure VS Code MCP Settings

1. **Open VS Code Settings**
   - Press `Cmd+,` (macOS) or `Ctrl+,` (Windows/Linux)
   - Search for "MCP"

2. **Add MCP Server Configuration**
   
   Create or edit `.vscode/mcp.json` in your workspace:
   ```json
   {
     "servers": {
       "blender": {
         "type": "stdio",
         "command": "npx",
         "args": ["-y", "blender-mcp"],
         "env": {
           "BLENDER_PATH": "/Applications/Blender.app/Contents/MacOS/Blender"
         }
       }
     }
   }
   ```

   **Platform-specific BLENDER_PATH:**
   
   | Platform | Path |
   |----------|------|
   | macOS (App) | `/Applications/Blender.app/Contents/MacOS/Blender` |
   | macOS (Homebrew) | `/opt/homebrew/bin/blender` |
   | Windows | `C:\\Program Files\\Blender Foundation\\Blender 4.0\\blender.exe` |
   | Linux | `/usr/bin/blender` |
   | Flatpak | `flatpak run org.blender.Blender` |

3. **Alternative: Global MCP Configuration**
   
   Edit `~/.config/Code/User/settings.json` (or equivalent):
   ```json
   {
     "mcp.servers": {
       "blender": {
         "command": "npx",
         "args": ["-y", "blender-mcp"]
       }
     }
   }
   ```

### Step 4: Start the MCP Server

#### Option A: From Blender (Recommended)
1. Open Blender
2. Open the sidebar (`N` key)
3. Go to **MCP** tab
4. Click **Start Server**
5. Note the port number (default: 8765)

#### Option B: From Terminal
```bash
# If using npm package
npx blender-mcp

# Or if installed globally
blender-mcp --port 8765
```

#### Option C: Auto-start with Blender
Add to Blender's startup script (`~/.config/blender/4.0/scripts/startup/mcp_autostart.py`):
```python
import bpy
import addon_utils

def start_mcp_server():
    # Enable MCP addon if not enabled
    addon_utils.enable("blender_mcp")
    # Start server
    bpy.ops.mcp.start_server()

# Register to run after Blender fully loads
bpy.app.timers.register(start_mcp_server, first_interval=2.0)
```

---

## Verification

### Test 1: Check MCP Connection in VS Code

1. Open Copilot Chat (`Cmd+Shift+I` or `Ctrl+Shift+I`)
2. Type: `@Blender AI Artist get scene info`
3. Expected response: Scene details (objects, materials, etc.)

### Test 2: Create a Test Object

```
@Blender AI Artist create a cube at origin
```

Expected: A new cube appears in Blender.

### Test 3: List Available Tools

```
@Blender AI Artist what MCP tools are available?
```

Expected: List of `mcp_blender_*` functions.

---

## Available MCP Tools

### Scene Management
| Tool | Description |
|------|-------------|
| `mcp_blender_get_scene_info` | Get detailed scene information |
| `mcp_blender_execute_blender_code` | Run arbitrary Python in Blender |
| `mcp_blender_get_viewport_screenshot` | Capture current viewport |

### Asset Import/Export
| Tool | Description |
|------|-------------|
| `mcp_blender_search_sketchfab_models` | Search Sketchfab library |
| `mcp_blender_download_sketchfab_model` | Import from Sketchfab |
| `mcp_blender_import_generated_asset` | Import AI-generated model |

### AI Model Generation
| Tool | Description |
|------|-------------|
| `mcp_blender_generate_hyper3d_model_via_images` | Generate 3D from images |
| `mcp_blender_poll_rodin_job_status` | Check generation progress |

### Scene Enhancement
| Tool | Description |
|------|-------------|
| `mcp_blender_analyze_scene_composition` | Analyze composition |
| `mcp_blender_suggest_composition` | Get composition suggestions |
| `mcp_blender_add_atmospheric_fog` | Add fog/atmosphere |
| `mcp_blender_add_color_effects` | Add post-processing |
| `mcp_blender_setup_tone_mapping` | Configure color grading |
| `mcp_blender_configure_render_settings` | Set render quality |

---

## BlenderKit Integration (Optional)

For access to BlenderKit's asset library:

### Step 1: Create BlenderKit Account
1. Go to https://www.blenderkit.com/
2. Create a free account
3. Note: Free tier has limited downloads

### Step 2: Install BlenderKit Addon
1. In Blender: **Edit → Preferences → Add-ons**
2. Search for "BlenderKit"
3. Enable the addon
4. Click addon preferences and log in

### Step 3: Configure API Key (for automation)
```bash
# Set environment variable
export BLENDERKIT_API_KEY="your-api-key-here"
```

Add to VS Code MCP config:
```json
{
  "servers": {
    "blender": {
      "env": {
        "BLENDERKIT_API_KEY": "your-api-key"
      }
    }
  }
}
```

---

## Hyper3D / Hunyuan3D Integration (AI Model Generation)

For AI-powered 3D model generation:

### Option A: Hyper3D Rodin (Cloud)
1. Sign up at https://hyper3d.ai/
2. Get API key from dashboard
3. Add to environment:
   ```bash
   export HYPER3D_API_KEY="your-key"
   ```

### Option B: Hunyuan3D (Local/Cloud)
1. Requires significant GPU resources (16GB+ VRAM)
2. See: https://github.com/tencent/Hunyuan3D

### Usage
```
@Blender AI Artist generate 3D model from image: [image_url]
```

---

## Troubleshooting

### Issue: "MCP server not connected"

**Symptoms:**
- Agent says it can't reach Blender
- No response from MCP tools

**Solutions:**
1. Verify Blender is running with MCP server started
2. Check MCP server port matches VS Code config
3. Restart VS Code after config changes
4. Check firewall isn't blocking local connections

```bash
# Test if server is running
curl http://localhost:8765/health
```

### Issue: "Blender path not found"

**Symptoms:**
- MCP can't launch Blender
- "Command not found" errors

**Solutions:**
1. Verify `BLENDER_PATH` in MCP config
2. Test path directly:
   ```bash
   # macOS
   /Applications/Blender.app/Contents/MacOS/Blender --version
   
   # Windows
   "C:\Program Files\Blender Foundation\Blender 4.0\blender.exe" --version
   ```
3. Update path if Blender was upgraded

### Issue: "Timeout waiting for Blender"

**Symptoms:**
- Commands hang then fail
- Slow response from agents

**Solutions:**
1. Blender may be loading a heavy scene - wait or start fresh
2. Increase timeout in MCP config:
   ```json
   {
     "servers": {
       "blender": {
         "timeout": 60000
       }
     }
   }
   ```
3. Close other Blender instances

### Issue: "Permission denied" (macOS)

**Symptoms:**
- Security warnings when launching Blender
- MCP can't execute commands

**Solutions:**
1. Grant Terminal/VS Code automation permissions:
   - System Preferences → Security & Privacy → Privacy → Automation
   - Enable VS Code → Blender
2. For unsigned addons:
   ```bash
   xattr -cr /path/to/addon
   ```

### Issue: Export fails silently

**Symptoms:**
- GLTF export command runs but no file appears
- No error messages

**Solutions:**
1. Check Blender's console for errors (Window → Toggle System Console)
2. Verify export path is writable:
   ```bash
   touch /path/to/export/test.txt && rm /path/to/export/test.txt
   ```
3. Try exporting manually in Blender first

---

## Performance Optimization

### For Large Scenes
```json
{
  "servers": {
    "blender": {
      "env": {
        "BLENDER_MEMORY_LIMIT": "8G",
        "CYCLES_DEVICE": "GPU"
      }
    }
  }
}
```

### For Apple Silicon
Blender 4.0+ has native Apple Silicon support. Ensure you're using the ARM64 version:
```bash
file /Applications/Blender.app/Contents/MacOS/Blender
# Should show: arm64
```

### For NVIDIA GPUs
Enable CUDA/OptiX in Blender:
- Edit → Preferences → System → Cycles Render Devices
- Select CUDA or OptiX

---

## Project Integration

### Recommended Blender File Structure
```
blender/
├── urban_survivor.blend       # Main project file
├── characters/
│   └── player_rig.blend       # Player character with rig
├── vehicles/
│   └── vehicle_library.blend  # Vehicle collection
├── props/
│   └── street_props.blend     # Street furniture
└── exports/                   # GLTF export staging
```

### Export Settings for Godot 4

When exporting GLTF for Godot, use these settings:

| Setting | Value |
|---------|-------|
| Format | GLTF Binary (.glb) |
| Include | Selected Objects |
| Transform | +Y Up |
| Materials | Export |
| Images | Automatic |
| Compression | Draco (optional) |

Or use MCP:
```
@Blender AI Artist export selected as GLB to game/assets/models/vehicles/taxi.glb
```

---

## Quick Reference

### Start MCP Workflow
1. Open Blender
2. Start MCP Server (sidebar → MCP → Start Server)
3. Open VS Code in Urban Survivor project
4. Use any MCP-enabled agent

### Common Commands
```bash
# Get scene info
@Blender AI Artist get scene info

# Create primitive
@Blender AI Artist create a cylinder at (0, 0, 1) with radius 0.5

# Apply material
@Texture Artist apply weathered_metal preset to selected object

# Export for Godot
@Blender AI Artist export selected as GLB to game/assets/models/props/barrel.glb

# Generate AI model
@Blender AI Artist generate 3D model from image: https://example.com/reference.jpg
```

---

## Support Resources

| Resource | URL |
|----------|-----|
| Blender MCP GitHub | https://github.com/ahujasid/blender-mcp |
| Blender Manual | https://docs.blender.org/ |
| Godot GLTF Import | https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html |
| BlenderKit | https://www.blenderkit.com/ |
| Hyper3D | https://hyper3d.ai/ |

---

*Last Updated: January 29, 2026*
