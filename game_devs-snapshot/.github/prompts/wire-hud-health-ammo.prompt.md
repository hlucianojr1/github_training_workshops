---
agent: 'agent'
description: 'Wire up HUD (GDScript) to display player health and weapon ammo using signals.'
---

Connect HUD UI to gameplay signals.

Load context first:
- game/scenes/ui/* (if present)
- game/scenes/*.tscn and corresponding .gd scripts
- src/ui/hud.*
- Player/Weapon signals exposed from C++

Requirements:
- Health bar updates on health_changed(current, max)
- Ammo label updates on ammo_changed(current, magazine, reserve)
- Avoid hardcoded node paths; prefer groups or exported NodePaths.

Steps:
1) Inspect current HUD scene/scripts.
2) Confirm which signals exist in C++ (bind if missing).
3) Connect signals in HUD _ready().
4) Implement handlers to update UI elements.

Acceptance criteria:
- Health bar moves when player takes damage.
- Ammo display changes when firing/reloading.
- No errors in Godot output about missing nodes/signals.
