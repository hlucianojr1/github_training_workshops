---
mode: 'agent'
description: 'Create a sprint plan (epic → tasks) aligned with the Urban Survivor production roadmap.'
---

You are planning work for the Urban Survivor game.

Goal: Produce a sprint plan with tasks that are 1–8 hours each, have clear dependencies, and include acceptance criteria.

Context to load first:
- docs/PRODUCTION_PLAN.md
- docs/PHASE1_DEVELOPMENT_PLAN.md
- docs/MEMORY.md (recent decisions)
- docs/SPEC.md (feature intent)

Ask (if not provided):
1) Which milestone are we targeting (Vertical Slice / Art Pipeline / Audio / Polish / Alpha / Beta)?
2) Sprint length (1 week / 2 weeks) and available hours.
3) Feature list or a single epic to focus on.

Output format:
- Title: Sprint [N] — [Milestone]
- Objectives (3–5 bullets)
- Task list (8–15 tasks) where each task includes:
  - Estimate (hours)
  - Owner prompt (e.g., combat-specialist, ai-specialist)
  - Files likely to change
  - Acceptance criteria checklist
  - Test plan (manual steps)
- Risks & mitigations (3–5 items)

Constraints:
- Don’t invent new features beyond the epic.
- Prefer signal-driven integration between systems.
- Include at least 1 task for testing/verification per feature area.

Recommended handoffs (use prompt files in .github/prompts/):
- Combat tasks → combat-specialist.prompt.md
- AI tasks → ai-specialist.prompt.md
- UI tasks → wire-hud-health-ammo.prompt.md
- Architecture validation → (use Copilot Chat agent mode)
- Review before merge → code-review-changes.prompt.md
- Document decisions → update-docs.prompt.md
