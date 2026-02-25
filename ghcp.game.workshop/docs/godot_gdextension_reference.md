# Godot 4 GDExtension C++ Development Guide

Reference documentation for AI coding agents working with Godot 4.3+ GDExtension and godot-cpp.

## GDExtension Configuration (.gdextension)

The `.gdextension` file configures how Godot loads your C++ extension.

```ini
[configuration]

entry_symbol = "my_library_init"
compatibility_minimum = "4.3"
reloadable = true

[libraries]

# Windows
windows.debug.x86_64 = "res://bin/libmyextension.windows.debug.x86_64.dll"
windows.release.x86_64 = "res://bin/libmyextension.windows.release.x86_64.dll"

# Linux
linux.debug.x86_64 = "res://bin/libmyextension.linux.debug.x86_64.so"
linux.release.x86_64 = "res://bin/libmyextension.linux.release.x86_64.so"

# macOS
macos.debug = "res://bin/libmyextension.macos.debug.framework"
macos.release = "res://bin/libmyextension.macos.release.framework"
```

### Key Points:
- `entry_symbol` must match the C++ function name exported in register_types.cpp
- `compatibility_minimum` should match or be lower than your godot-cpp branch version
- Library paths must match actual compiled DLL/SO filenames exactly
- Use `res://` paths relative to project root

## Library Entry Point (register_types.cpp)

```cpp
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

void initialize_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    
    // Register all custom classes
    GDREGISTER_CLASS(MyCustomNode);
    GDREGISTER_CLASS(MyOtherClass);
}

void uninitialize_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
}

extern "C" {
// Entry point - name must match entry_symbol in .gdextension
GDExtensionBool GDE_EXPORT my_library_init(
    GDExtensionInterfaceGetProcAddress p_get_proc_address,
    GDExtensionClassLibraryPtr p_library,
    GDExtensionInitialization *r_initialization) {
    
    godot::GDExtensionBinding::InitObject init_obj(
        p_get_proc_address, p_library, r_initialization);
    
    init_obj.register_initializer(initialize_module);
    init_obj.register_terminator(uninitialize_module);
    init_obj.set_minimum_library_initialization_level(
        MODULE_INITIALIZATION_LEVEL_SCENE);
    
    return init_obj.init();
}
}
```

## Class Definition Pattern

```cpp
#ifndef MY_CLASS_HPP
#define MY_CLASS_HPP

#include <godot_cpp/classes/node3d.hpp>

namespace godot {

class MyClass : public Node3D {
    GDCLASS(MyClass, Node3D)

private:
    float my_property = 1.0f;
    
protected:
    static void _bind_methods();

public:
    MyClass();
    ~MyClass();
    
    void _ready() override;
    void _process(double delta) override;
    
    // Getters/Setters for properties
    void set_my_property(float value);
    float get_my_property() const;
};

} // namespace godot

#endif
```

## Method Binding (_bind_methods)

```cpp
void MyClass::_bind_methods() {
    // Bind methods
    ClassDB::bind_method(D_METHOD("my_function", "arg1", "arg2"), &MyClass::my_function);
    
    // Bind method with default arguments
    ClassDB::bind_method(D_METHOD("optional_args", "a", "b"), 
                        &MyClass::optional_args, DEFVAL(0));
    
    // Bind properties (requires getter/setter)
    ClassDB::bind_method(D_METHOD("set_my_property", "value"), &MyClass::set_my_property);
    ClassDB::bind_method(D_METHOD("get_my_property"), &MyClass::get_my_property);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "my_property"), 
                "set_my_property", "get_my_property");
    
    // Bind signals
    ADD_SIGNAL(MethodInfo("my_signal", 
        PropertyInfo(Variant::INT, "value"),
        PropertyInfo(Variant::STRING, "message")));
    
    // Bind enum constants (for scoped enums, use bind_integer_constant)
    ClassDB::bind_integer_constant(get_class_static(), "MyEnum", "VALUE_ONE", 0);
    ClassDB::bind_integer_constant(get_class_static(), "MyEnum", "VALUE_TWO", 1);
}
```

## Godot 4.3+ API Changes

### Vector Constants
```cpp
// OLD (Godot 4.0-4.2)
Vector3 v = Vector3::ZERO;
Vector2 v2 = Vector2::ZERO;

// NEW (Godot 4.3+)
Vector3 v = Vector3();
Vector2 v2 = Vector2();
```

### Math/Utility Functions
```cpp
// OLD
float r = Math::randf();
int ri = Math::randi_range(0, 10);
float mt = Math::move_toward(current, target, delta);

// NEW (Godot 4.3+)
#include <godot_cpp/variant/utility_functions.hpp>

float r = UtilityFunctions::randf();
int ri = UtilityFunctions::randi_range(0, 10);
// move_toward may need type conversion
double mt = Math::move_toward(static_cast<double>(current), 
                              static_cast<double>(target), 
                              static_cast<double>(delta));
```

### RID and Raycast Exclusion
```cpp
// OLD - Node::get_rid() was available
query->set_exclude(Array::make(node->get_rid()));

// NEW (Godot 4.3+) - get_rid() removed from many classes
// Use collision masks instead, or get RID from physics body
Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(from, to, collision_mask);
// Simply don't set exclude, rely on collision_mask filtering
```

### Enum Binding for Scoped Enums
```cpp
// For enum class (scoped enums), use bind_integer_constant
enum class MyState {
    IDLE = 0,
    ACTIVE = 1,
    PAUSED = 2
};

void MyClass::_bind_methods() {
    // BIND_ENUM_CONSTANT won't work with enum class
    // Use this instead:
    ClassDB::bind_integer_constant(get_class_static(), "MyState", "IDLE", 
                                   static_cast<int>(MyState::IDLE));
    ClassDB::bind_integer_constant(get_class_static(), "MyState", "ACTIVE", 
                                   static_cast<int>(MyState::ACTIVE));
    ClassDB::bind_integer_constant(get_class_static(), "MyState", "PAUSED", 
                                   static_cast<int>(MyState::PAUSED));
}
```

### Enum Parameters in Bound Methods
```cpp
// Enums cannot be directly used as parameters in bound methods
// Convert to int in method signature

// BAD - won't compile
float calculate(float base, MyEnum type);

// GOOD - use int and convert internally
float calculate(float base, int type_int) {
    MyEnum type = static_cast<MyEnum>(type_int);
    // ... use type
}
```

## CMake Build Configuration

```cmake
cmake_minimum_required(VERSION 3.20)
project(MyExtension)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add godot-cpp as subdirectory
add_subdirectory(external/godot-cpp)

# Your extension library
add_library(${PROJECT_NAME} SHARED
    src/register_types.cpp
    src/my_class.cpp
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(${PROJECT_NAME} PRIVATE godot-cpp)

# Get suffix from godot-cpp
get_target_property(GODOTCPP_SUFFIX godot-cpp GODOTCPP_SUFFIX)

set_target_properties(${PROJECT_NAME} PROPERTIES
    PREFIX "lib"
    OUTPUT_NAME "myextension${GODOTCPP_SUFFIX}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/game/bin"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/game/bin"
)
```

## Common Include Headers

```cpp
// Core
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

// Variant types
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>

// Common classes
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/input_event.hpp>

// 3D nodes
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/navigation_agent3d.hpp>

// Physics
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/world3d.hpp>

// Resources
#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
```

## Debug vs Release Builds

When building with CMake:
- **Debug build**: `cmake --build build --config Debug`
  - Links against debug godot-cpp library
  - Includes debug symbols
  - Output: `libname.windows.debug.x86_64.dll`

- **Release build**: `cmake --build build --config Release`
  - Links against release godot-cpp library  
  - Optimized, no debug symbols
  - Output: `libname.windows.release.x86_64.dll`

**IMPORTANT**: Debug and Release builds must match between godot-cpp and your extension. Mixing them causes linker errors about `_ITERATOR_DEBUG_LEVEL` mismatch.

## Troubleshooting

### "GDExtension dynamic library not found"
1. Check `.gdextension` library paths match actual filenames
2. Ensure DLL is in the correct `bin/` folder
3. Verify entry_symbol matches your C++ export function name

### Linker errors about _ITERATOR_DEBUG_LEVEL
Build configurations mismatch. Rebuild godot-cpp and your extension with same config:
```bash
# For Debug
cd external/godot-cpp && scons target=template_debug
cmake --build build --config Debug

# For Release  
cd external/godot-cpp && scons target=template_release
cmake --build build --config Release
```

### Method binding template errors with enums
Use `int` parameter type instead of enum type in bound methods, then cast internally.

### "undefined type 'godot::SceneTree'"
Add the include:
```cpp
#include <godot_cpp/classes/scene_tree.hpp>
```
