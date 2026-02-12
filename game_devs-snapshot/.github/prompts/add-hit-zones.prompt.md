---
agent: 'agent'
description: 'Implement hit zone detection (HEAD/TORSO/LIMBS) and multipliers in DamageSystem.'
---

Implement hit zones for Urban Survivor.

Load context first:
- src/combat/damage_system.hpp / src/combat/damage_system.cpp
- docs/SPEC.md (hit zone multipliers)

Requirements:
- Multipliers: HEAD 2.5x, TORSO 1.0x, LIMBS 0.7x.
- Determination method: simplest reliable approach based on available hit data.
  - Prefer collision shape name parsing if available.
  - Provide safe fallback to TORSO.

Steps:
1) Inspect how DamageSystem receives hit data today.
2) Add a helper: `get_zone_multiplier(String zone)`.
3) Add logic to determine zone from collider/shape metadata (document naming convention).
4) Apply multiplier in final damage calculation.
5) Emit signal damage_dealt(target, amount, zone).

Acceptance criteria:
- Zone defaults to TORSO if unknown.
- HEAD hits clearly apply > TORSO damage.
- DamageSystem remains the single place damage is applied.
