# Urban Survivor - Build Instructions

This document explains how to build and run the Urban Survivor game.

## Prerequisites

### Required Software
1. **Godot Engine 4.3+**
   - Download from: https://godotengine.org/download
   - This project uses Godot 4.3 or later

2. **CMake 3.20+**
   - Windows: Download from https://cmake.org/download/
   - Linux: `sudo apt install cmake` (Ubuntu/Debian) or `sudo dnf install cmake` (Fedora)
   - macOS: `brew install cmake`

3. **C++17 Compiler**
   - Windows: Visual Studio 2019+ or MinGW-w64
   - Linux: GCC 7+ or Clang 5+
   - macOS: Xcode 10+ (Command Line Tools)

4. **Git**
   - Required for cloning godot-cpp submodule

## Initial Setup

### 1. Clone godot-cpp
From the project root directory:

```powershell
# Navigate to project directory
cd c:\code\cpp_game

# Initialize godot-cpp submodule
git submodule add -b 4.3 https://github.com/godotengine/godot-cpp external/godot-cpp
git submodule update --init --recursive
```

Or if you already cloned the repo:

```powershell
git submodule update --init --recursive
```

### 2. Build godot-cpp

**Windows (PowerShell):**
```powershell
cd external/godot-cpp
scons platform=windows target=template_debug
scons platform=windows target=template_release
cd ../..
```

**Linux:**
```bash
cd external/godot-cpp
scons platform=linux target=template_debug
scons platform=linux target=template_release
cd ../..
```

**macOS:**
```bash
cd external/godot-cpp
scons platform=macos target=template_debug
scons platform=macos target=template_release
cd ../..
```

## Building the Game Extension

### Option 1: CMake GUI (Windows)

1. Open CMake GUI
2. Set source directory: `c:\code\cpp_game`
3. Set build directory: `c:\code\cpp_game\build`
4. Click "Configure"
5. Select your compiler (Visual Studio or MinGW)
6. Click "Generate"
7. Click "Open Project" or use command line:

```powershell
cd build
cmake --build . --config Debug
# or
cmake --build . --config Release
```

### Option 2: Command Line (All Platforms)

**Windows (PowerShell):**
```powershell
# Create build directory
mkdir build -Force
cd build

# Configure
cmake ..

# Build (Debug)
cmake --build . --config Debug

# Build (Release)
cmake --build . --config Release
```

**Linux/macOS:**
```bash
# Create build directory
mkdir -p build
cd build

# Configure for Debug
cmake -DCMAKE_BUILD_TYPE=Debug ..
make

# Or configure for Release
cmake -DCMAKE_BUILD_TYPE=Release ..
make
```

### Build Output

After building, the compiled library will automatically be copied to:
- `game/bin/liburban_survivor.[platform].[buildtype].[arch].dll/.so/.framework`

For example:
- Windows: `game/bin/liburban_survivor.windows.template_debug.x86_64.dll`
- Linux: `game/bin/liburban_survivor.linux.template_debug.x86_64.so`

## Running the Game

### 1. Open in Godot Editor

1. Launch Godot Engine
2. Click "Import"
3. Navigate to `c:\code\cpp_game\game`
4. Select `project.godot`
5. Click "Import & Edit"

### 2. Create Initial Scenes

The C++ code is complete, but you'll need to create Godot scenes:

**Minimum Required Scenes:**
1. **Main Menu** (`scenes/main_menu.tscn`)
   - Basic UI with Start Game button

2. **Test Level** (`scenes/levels/level_1.tscn`)
   - Add a Player node (type: `PlayerController`)
   - Add child `CameraPivot` (Node3D)
   - Add child to CameraPivot: Camera (type: `ThirdPersonCamera`)
   - Add NavigationRegion3D with basic geometry
   - Add some Enemy nodes (type: `EnemyAI`)
   - Add ScavengePoints for items

3. **HUD** (`scenes/ui/hud.tscn`)
   - Create Control node (type: `HUD`)
   - Add child Labels: `HealthLabel`, `AmmoLabel`, `ObjectiveLabel`
   - Add child ProgressBars: `HealthBar`, `StaminaBar`

### 3. Run the Game

- Press F5 in Godot Editor
- Or click the Play button

## Troubleshooting

### Build Errors

**"Could not find godot-cpp"**
- Ensure godot-cpp submodule is initialized: `git submodule update --init --recursive`
- Verify `external/godot-cpp` directory exists and has content

**Linker errors**
- Make sure godot-cpp is built for the same platform and architecture
- Verify you're using the same compiler for both godot-cpp and the game extension

**"undefined reference to ClassDB" or similar**
- godot-cpp wasn't built properly
- Rebuild godot-cpp: `cd external/godot-cpp && scons platform=[your_platform] target=template_debug`

### Runtime Errors

**"Can't load extension"**
- Verify the .gdextension file path matches your compiled library
- Check that the library file exists in `game/bin/`
- Make sure you built for the correct platform

**"Class not found"**
- Ensure all C++ classes are registered in `src/register_types.cpp`
- Check that the extension loaded successfully (look for "GDExtension loaded" in console)

**Crashes on startup**
- Try Debug build instead of Release for better error messages
- Check Godot console for stack traces
- Verify all node paths in C++ code match scene structure

## Development Workflow

### Iterating on C++ Code

1. Make changes to C++ source files
2. Rebuild the extension:
   ```powershell
   cd build
   cmake --build . --config Debug
   ```
3. Close Godot Editor (if open)
4. Reopen Godot Editor (it will reload the extension)
5. Test changes

**Note:** Godot 4.3's `reloadable = true` in .gdextension allows hot-reloading in some cases, but closing/reopening is more reliable.

### Adding New Classes

1. Create `.hpp` and `.cpp` files in appropriate subdirectory
2. Add to `src/register_types.cpp`:
   ```cpp
   #include "path/to/your_class.hpp"
   // In urban_survivor_library_init():
   ClassDB::register_class<YourClass>();
   ```
3. Rebuild the extension
4. New class will be available in Godot's "Add Node" menu

## Next Steps

1. **Create Assets**
   - Import or create 3D models for player, enemies, weapons
   - Add textures with 1960s aesthetic
   - Import/create audio files

2. **Build Levels**
   - Design NYC urban environment
   - Place NavigationMeshes for AI pathfinding
   - Add ScavengePoints with item spawns

3. **Implement UI**
   - Design HUD layout matching 1960s style
   - Create inventory menu
   - Add pause/death screens

4. **Polish**
   - Add post-processing effects (film grain, vignette)
   - Implement audio system
   - Add particle effects for gunfire, debris

## Resources

- [Godot Documentation](https://docs.godotengine.org/en/stable/)
- [GDExtension Tutorial](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html)
- [godot-cpp Repository](https://github.com/godotengine/godot-cpp)
- [CMake Documentation](https://cmake.org/documentation/)
