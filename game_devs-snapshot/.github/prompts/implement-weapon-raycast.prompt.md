---
agent: 'agent'
description: 'Implement raycast-based weapon firing in C++ (Godot 4.3 GDExtension) using existing Weapon/DamageSystem patterns.'
---

Implement raycast-based firing for Urban Survivor.

Load context first:
- src/combat/weapon.hpp / src/combat/weapon.cpp
- src/combat/damage_system.hpp / src/combat/damage_system.cpp
- docs/SPEC.md (combat requirements)
- docs/CODING_STANDARDS.md

Requirements:
- Fire should raycast from aiming origin (camera/aim pivot) toward aim direction.
- Use proper collision mask/layers.
- On hit, compute damage and delegate to DamageSystem.
- Emit signals for UI feedback (fired, out_of_ammo, etc.)
- No node creation in constructors.

Steps:
1) Inspect current Weapon implementation and identify missing hooks (ammo, cooldown, muzzle, aim direction).
2) Add/confirm signals in _bind_methods().
3) Implement `fire()` with PhysicsDirectSpaceState3D raycast query.
4) Package hit info (collider, position, normal) and call DamageSystem.
5) Reduce ammo, enforce fire rate, and emit appropriate signals.
6) Build (Debug) and ensure no compile errors.

Acceptance criteria:
- Firing with ammo produces a raycast and a hit result in logs (or signal emission).
- Firing with zero ammo emits out_of_ammo and does not apply damage.
- No crashes when world/space state is null (guard appropriately).

Notes:
- Prefer minimal changes to fit existing architecture.
- If aim-origin is ambiguous, implement the simplest reliable option and flag it.
