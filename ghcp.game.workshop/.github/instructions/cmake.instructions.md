# CMake & Build — Code Generation Instructions

Apply these rules when modifying `CMakeLists.txt` or build configuration files.

## Build System

- CMake 3.20+ generating MSBuild projects for Visual Studio
- C++17 standard enforced via `CMAKE_CXX_STANDARD 17`
- Extensions disabled via `CMAKE_CXX_EXTENSIONS OFF`

## Build Commands

```bash
# Configure
cmake -B visualstudio/vs2026-x64 -G "Visual Studio 18 2026" -A x64

# Debug build
cmake --build visualstudio/vs2026-x64 --config Debug

# Clean rebuild
cmake --build visualstudio/vs2026-x64 --config Debug --clean-first
```

## Output

The compiled GDExtension library is output to:

```
game/bin/liburban_survivor.windows.template_debug.x86_64.dll
```

## Adding New Source Files

When adding a new C++ class:

1. Create `src/<module>/class_name.hpp` and `src/<module>/class_name.cpp`
2. The root `CMakeLists.txt` uses a `file(GLOB_RECURSE)` pattern to collect
   sources from `src/` — verify the glob includes the new subdirectory
3. If not using glob, add the new files explicitly to the `SOURCES` list
4. Register the class in `src/register_types.cpp`

## Platform Support

The build supports Windows, macOS, and Linux through platform detection
in `CMakeLists.txt`. Do not add platform-specific code without appropriate
`if(CMAKE_SYSTEM_NAME STREQUAL ...)` guards.

## Dependencies

- `godot-cpp` is a Git submodule at `external/godot-cpp/`
- Do not modify files in `external/` — they are managed upstream
- Additional libraries should be added via `FetchContent` or submodules

## Compiler Flags (MSVC)

The project uses these MSVC-specific flags — do not remove or weaken them:

- `/W4` — High warning level
- `/permissive-` — Standards conformance mode
- `/std:c++17` — C++17 standard
- `/bigobj` — Required for godot-cpp template-heavy headers
