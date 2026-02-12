---
agent: 'agent'
description: 'Add a new C++ class end-to-end: header/cpp, register_types, and CMakeLists integration.'
---

Create and register a new GDExtension class.

Inputs:
- Class name (PascalCase)
- Parent class (Node/Node3D/CharacterBody3D/etc.)
- Module folder under src/ (core/player/combat/ai/etc.)

Steps:
1) Create `src/<module>/<snake_name>.hpp` and `.cpp` using project templates.
2) Implement `_bind_methods()` with any initial bindings.
3) Add `#include` and `GDREGISTER_CLASS()` in src/register_types.cpp.
4) Add the `.cpp` file to `CMakeLists.txt` sources.
5) Build (Debug) and fix compile errors.

Acceptance criteria:
- Class appears in Godot after rebuild + editor restart.
- No crashes from constructor-time node access.
