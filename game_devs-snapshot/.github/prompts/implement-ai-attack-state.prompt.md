---
agent: 'agent'
description: 'Implement EnemyAI ATTACK state behavior (burst fire, line-of-sight checks, cooldown) using existing FSM patterns.'
---

Implement an EnemyAI ATTACK state.

Load context first:
- src/ai/enemy_ai.hpp / src/ai/enemy_ai.cpp
- src/ai/ai_perception.hpp / src/ai/ai_perception.cpp
- docs/SPEC.md (AI combat expectations)

Requirements:
- Attack only if target is valid and within range.
- Respect line of sight via perception/raycast.
- Fire in bursts with cooldown (timer-driven; don’t run heavy checks every frame).
- Transition rules:
  - Lose target → INVESTIGATE
  - Target too far/no LOS → CHASE

Steps:
1) Map current state machine structure and where transitions are handled.
2) Add attack parameters (attack_range, burst_size, burst_interval, cooldown).
3) Implement update_attack_state with rate-limited firing logic.
4) Use Weapon or DamageSystem interaction as per existing architecture.

Acceptance criteria:
- AI enters ATTACK when in range + LOS.
- AI stops attacking and transitions correctly when conditions change.
- No per-frame heavy path recalculation.
