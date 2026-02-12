---
description: 'GDScript rules for Urban Survivor UI and scene scripting.'
applyTo: '**/*.gd'
---

Follow these rules when editing GDScript for Urban Survivor.

**Must read before edits**
- docs/SPEC.md
- docs/MEMORY.md
- docs/CODING_STANDARDS.md

**Type safety**
- Use typed variables and typed function returns where practical.
- Use `@onready` for node references.

**Scene safety**
- Avoid hardcoded absolute node paths across scenes.
- Prefer groups, exported `NodePath`, or local scene-relative paths.
- Use `get_node_or_null()` when a node may not exist.

**Signals**
- Prefer signal-driven UI updates (health_changed, ammo_changed, etc.) over polling.
- Disconnect signals if nodes can be freed dynamically.

**Performance**
- Avoid heavy logic in `_process()`.
- Don’t allocate arrays/dictionaries every frame.

**Assets/paths**
- Only use `res://` paths.
