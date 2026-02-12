---
agent: 'agent'
description: 'Populate Level 1 with enemies, scavenge points, and objectives using existing scene/system patterns.'
---

Populate Level 1 for Vertical Slice readiness.

Load context first:
- game/scenes/level_1.tscn and level_1.gd
- src/world/level_manager.*
- src/world/scavenge_point.*
- docs/LEVEL_1_DESIGN.md

Requirements:
- Place scavenge points (lootable spots) with sane spacing.
- Place enemy spawns appropriate to early game difficulty.
- Add simple objectives/hints (if existing systems support it).

Steps:
1) Inspect Level 1 scene hierarchy and current scripts.
2) Identify how scavenge points and enemies are instantiated (scene vs code).
3) Add nodes and configure exported properties.
4) Validate the scene loads without errors.

Acceptance criteria:
- Level loads and contains multiple interactable scavenge points.
- At least one enemy encounter is present.
- No missing resource references.
