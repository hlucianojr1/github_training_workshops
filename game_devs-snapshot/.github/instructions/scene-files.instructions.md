---
description: 'Rules for editing Godot scene files (.tscn) in Urban Survivor.'
applyTo: '**/*.tscn'
---

Follow these rules when editing Godot `.tscn` files.

**Stability**
- Prefer minimal diffs; avoid re-saving unrelated nodes.
- Do not rename nodes unless required (breaks scripted paths and signal bindings).

**Wiring**
- Prefer signal connections over per-frame polling.
- Ensure any referenced scripts/resources exist under `res://`.

**Structure**
- Keep node hierarchy consistent with existing patterns in `game/scenes/`.
- Use Groups for cross-system discovery (e.g., player/enemies/cover_points) when needed.

**Validation**
- After edits, confirm the scene opens in Godot without missing references.
