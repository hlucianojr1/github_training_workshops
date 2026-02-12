---
agent: 'agent'
description: 'Expose a C++ method/property/signal to Godot (GDExtension) safely and consistently.'
---

Expose C++ APIs to Godot/GDScript.

Load context first:
- Target class header/implementation
- docs/godot_gdextension_reference.md (if needed)
- docs/CODING_STANDARDS.md

Checklist:
1) Add/verify `_bind_methods()` exists.
2) Bind methods with `ClassDB::bind_method(D_METHOD(...), &Class::method)`.
3) Add properties with setters/getters if needed.
4) Add signals with `ADD_SIGNAL(MethodInfo(...))`.
5) Ensure names intended for GDScript are `snake_case`.

Acceptance criteria:
- Method callable from GDScript.
- Property visible/editable in inspector (if intended).
- Signal connect/emit works.
