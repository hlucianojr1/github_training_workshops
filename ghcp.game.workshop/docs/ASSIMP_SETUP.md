# Assimp Library Configuration

## Overview
Assimp (Open Asset Import Library) has been integrated into the project for loading 3D model formats (GLB, GLTF, FBX, OBJ, etc.).

## Installation Details

### Git Submodule
Assimp was added as a git submodule:
```bash
git submodule add https://github.com/assimp/assimp.git external/assimp
```

### CMake Configuration
The following configuration was added to `CMakeLists.txt`:

#### Build Options
- `ASSIMP_BUILD_TESTS OFF` - Disabled test suite
- `ASSIMP_BUILD_SAMPLES OFF` - Disabled sample applications
- `ASSIMP_BUILD_ASSIMP_TOOLS OFF` - Disabled command-line tools
- `ASSIMP_INSTALL OFF` - Disabled install targets
- `ASSIMP_WARNINGS_AS_ERRORS OFF` - Warnings won't fail the build

#### Integration
- Added as subdirectory: `add_subdirectory(${ASSIMP_DIR} EXCLUDE_FROM_ALL)`
- Include directory: `${ASSIMP_DIR}/include`
- Linked library: `assimp`

## Usage in Code

### Basic Example
```cpp
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

// Load a model
Assimp::Importer importer;
const aiScene* scene = importer.ReadFile(filepath,
    aiProcess_Triangulate |
    aiProcess_FlipUVs |
    aiProcess_GenNormals |
    aiProcess_CalcTangentSpace
);

if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode) {
    // Error handling
    std::cerr << "Assimp Error: " << importer.GetErrorString() << std::endl;
    return;
}
```

### Supported Formats
Assimp supports over 40 file formats including:
- **GLTF/GLB** - Preferred format for modern 3D assets
- **FBX** - Autodesk FBX
- **OBJ** - Wavefront OBJ
- **DAE** - COLLADA
- **3DS** - 3D Studio Max
- **BLEND** - Blender (import only)

## Build Instructions

After cloning the repository or updating submodules:

```bash
# Initialize/update submodules
git submodule update --init --recursive

# Configure and build (Assimp will be built automatically)
cmake -B build
cmake --build build
```

## Notes

- Assimp is built as part of the main CMake configuration
- Only the library itself is built (no tools, tests, or samples)
- The library is statically linked to the project
- Header files are available at `external/assimp/include/`

## Troubleshooting

### Submodule not initialized
```bash
git submodule update --init external/assimp
```

### Build errors
Ensure you have a C++17 compatible compiler:
- Visual Studio 2017 or later (Windows)
- GCC 7+ or Clang 5+ (Linux/macOS)

## Reference
- Official Documentation: https://assimp-docs.readthedocs.io/
- GitHub Repository: https://github.com/assimp/assimp
