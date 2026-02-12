---
agent: 'agent'
description: 'Add a reload state machine to Weapon (C++) with signals for HUD.'
---

Add a reload flow to Urban Survivor weapons.

Load context first:
- src/combat/weapon.hpp / src/combat/weapon.cpp
- docs/SPEC.md (reload behavior)
- docs/CODING_STANDARDS.md

Requirements:
- Track magazine ammo and reserve ammo.
- Enforce reload duration (timer-based).
- While reloading: cannot fire.
- Signals: reloading(duration), reload_complete(), ammo_changed(...)

Steps:
1) Inspect current ammo fields and add missing fields (mag_size, current_mag, reserve).
2) Add weapon state enum: IDLE/FIRING/RELOADING (or simplest equivalent).
3) Implement `start_reload()` and timer-driven completion.
4) Emit signals for UI.
5) Ensure reload is blocked if mag already full or reserve empty.

Acceptance criteria:
- Reload starts only when valid.
- Reload completion transfers ammo from reserve to mag.
- HUD can display reload progress using duration signal.
