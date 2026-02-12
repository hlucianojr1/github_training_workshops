---
agent: 'agent'
description: 'Add a simple cover-seeking behavior to EnemyAI (health threshold) without introducing new complex systems.'
---

Add basic cover-seeking to EnemyAI.

Load context first:
- src/ai/enemy_ai.*
- docs/ARCHITECTURE.md
- docs/SPEC.md (AI behavior)

Constraints:
- Implement the simplest cover approximation first.
- Do not add large new subsystems unless required.

Approach options (choose simplest that fits current code):
1) Use existing scene nodes tagged as cover points (Group: "cover_points").
2) Use nearby NavigationAgent3D offsets to strafe behind obstacles (fallback).

Steps:
1) Identify how enemy health is tracked (existing component or placeholder).
2) Add trigger: if health < threshold and under fire → seek cover.
3) Find candidate cover nodes within radius (group lookup) and pick best.
4) Navigate to cover and re-engage.

Acceptance criteria:
- Enemy attempts to break line-of-sight when low health.
- Behavior is stable (no oscillation between cover and attack every frame).
