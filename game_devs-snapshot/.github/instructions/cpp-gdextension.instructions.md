---
description: 'C++ GDExtension implementation rules for Urban Survivor (Godot 4.3+).'
applyTo: '**/*.{cpp,hpp}'
---

Follow these rules when editing C++ sources for Urban Survivor.

**Must read before edits**
- docs/ARCHITECTURE.md
- docs/SPEC.md
- docs/MEMORY.md
- docs/CODING_STANDARDS.md

**Godot lifecycle**
- Do not access the scene tree from constructors.
- Do not create nodes in constructors; use `_ready()`.
- Prefer `_physics_process()` for movement/AI ticks.

**Binding requirements**
- Every exposed class must have `GDCLASS()` and implement `_bind_methods()`.
- Bind methods via `ClassDB::bind_method(D_METHOD(...), &Class::method)`.
- Exposed names should be `snake_case`.
- Declare signals using `ADD_SIGNAL(MethodInfo(...))` with typed `PropertyInfo`.

**Safety & correctness**
- Always null-check pointers before use; prefer `ERR_FAIL_NULL(ptr)` / `ERR_FAIL_COND()`.
- Avoid per-frame allocations and expensive searches.
- Do not call `get_node()` every frame; cache references after `_ready()`.

**Godot 4.3 API note**
- Do not use removed Vector3 constants like `Vector3::ZERO/UP/FORWARD`.

**Repo constraints**
- Never modify `external/godot-cpp/`.
- Use `res://` paths only; never hardcode OS paths.

**Build/verify**
- After C++ changes: close Godot → build (Debug) → reopen Godot.
