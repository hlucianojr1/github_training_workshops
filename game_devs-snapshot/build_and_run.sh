#!/bin/bash

# Urban Survivor - Build and Run Script for macOS

# Default to Debug build type
BUILD_TYPE="Debug"
if [ "$1" == "release" ]; then
    BUILD_TYPE="Release"
fi

echo "=== Building Urban Survivor ($BUILD_TYPE) ==="

# 1. Check for Godot
GODOT_EXEC="godot"
if ! command -v $GODOT_EXEC &> /dev/null; then
    # Try common location
    if [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
        GODOT_EXEC="/Applications/Godot.app/Contents/MacOS/Godot"
        echo "Found Godot at: $GODOT_EXEC"
    else
        echo "Error: Godot executable not found in PATH or /Applications/Godot.app"
        echo "Please install Godot or add it to your PATH."
        # Attempt to prompt user? No, shell script.
        # Fallback to asking user to set GODOT_PATH env var
        if [ -n "$GODOT_PATH" ]; then
             GODOT_EXEC="$GODOT_PATH"
             echo "Using GODOT_PATH: $GODOT_EXEC"
        else
             exit 1
        fi
    fi
fi

# 2. Initialize Submodules
echo "--> Initializing submodules..."
git submodule update --init --recursive

# 3. Build godot-cpp
echo "--> Building godot-cpp (if needed)..."
cd external/godot-cpp
# Check if library exists to avoid rebuilding every time (Scons is usually smart but good to be safe/fast)
# Just run scons, it handles incremental
scons platform=macos target=template_debug
if [ "$BUILD_TYPE" == "Release" ]; then
    scons platform=macos target=template_release
fi
cd ../..

# 4. Build Game Extension
echo "--> Building Game Extension..."
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE ..
make -j$(sysctl -n hw.ncpu)
cd ..

# 5. Run Game
echo "=== Running Game ==="
"$GODOT_EXEC" --path game/
