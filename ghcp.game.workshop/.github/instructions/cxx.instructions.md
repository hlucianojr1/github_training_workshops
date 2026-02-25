# C++ GDExtension — Code Generation Instructions

Apply these rules when generating or modifying C++ code in the `src/` directory.

## Compiler & Language

- Target C++17 with MSVC (`/W4 /permissive- /std:c++17 /bigobj`)
- Do not use GCC/Clang extensions: `__attribute__`, `__int128`, `typeof`, statement expressions
- Prefer standard library utilities (`std::clamp`, `std::optional`, `std::string_view`)

## File Layout

- One class per header/source pair
- Headers use `.hpp`, sources use `.cpp`
- File names are `snake_case` matching the class: `PlayerController` → `player_controller.hpp`
- Include guards use `#ifndef` / `#define` / `#endif` matching existing header style
- All classes live inside `namespace godot { }`

## Class Declaration Pattern

Every Godot-exposed class must follow this structure:

```cpp
#ifndef CLASS_NAME_HPP
#define CLASS_NAME_HPP

#include <godot_cpp/classes/parent_class.hpp>

namespace godot {

class ClassName : public ParentClass {
    GDCLASS(ClassName, ParentClass)

protected:
    static void _bind_methods();

public:
    void _ready() override;
    void _process(double delta) override;

    // Getters and setters
    void set_member(type value);
    type get_member() const;

private:
    // Members with defaults
    type member_name = default_value;
};

} // namespace godot

#endif // CLASS_NAME_HPP
```

## `_bind_methods()` Pattern

Register all exposed members in this order:

1. Bind getters and setters with `ClassDB::bind_method(D_METHOD(...), ...)`
2. Group related properties with `ADD_GROUP("Group Name", "prefix_")`
3. Register properties with `ADD_PROPERTY(PropertyInfo(...), "set_", "get_")`
4. Close groups with `ADD_GROUP("", "")`
5. Declare signals with `ADD_SIGNAL(MethodInfo("signal_name", PropertyInfo(...)))`

Use `PROPERTY_HINT_RANGE` for all numeric properties:

```cpp
ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "walk_speed", PROPERTY_HINT_RANGE, "0.0,20.0,0.1"), "set_walk_speed", "get_walk_speed");
```

## Lifecycle Methods

Guard lifecycle methods against editor execution:

```cpp
void ClassName::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) return;
    // initialization code
}
```

## Null Safety

- Null-check all node pointers before dereferencing
- Use `ERR_FAIL_NULL` or `ERR_FAIL_COND` macros for safety-critical paths
- Use `Object::cast_to<T>()` for safe type casting

## Debug Logging

Use `UtilityFunctions::print()` matching the existing logging style:

```cpp
UtilityFunctions::print("[ClassName] Initialized with value: ", member_name);
```

## Class Registration

Every new class must be added to `src/register_types.cpp`:

```cpp
#include "module/class_name.hpp"
// ...
ClassDB::register_class<ClassName>();
```

Follow the existing grouped comment pattern in that file.

## Naming Rules

| Element         | Convention   | Example                  |
|-----------------|--------------|--------------------------|
| Classes/Structs | `PascalCase` | `DamageSystem`           |
| Class Members   | `snake_case` | `max_health`             |
| Local Variables | `camelCase`  | `deltaTime`              |
| Constants/Enums | `UPPER_CASE` | `MAX_INVENTORY_SLOTS`    |
| Methods         | `snake_case` | `apply_damage()`         |
| Signals         | `snake_case` | `health_changed`         |

## Style Matching

- Match the comment style, spacing, and structure of the file being edited
- Place new members near related existing members
- Follow the same getter/setter pattern (inline vs .cpp) used in the file
- Keep header includes minimal; forward-declare where possible
