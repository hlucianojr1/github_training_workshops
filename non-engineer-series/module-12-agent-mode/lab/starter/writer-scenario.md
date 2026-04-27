# Writer Scenario: TaskFlow Pro Documentation Audit

**Module:** 12 — Agent Mode for Non-Engineers
**Role:** Technical Writer / Documentation Lead

---

## Your Scenario

You are a technical writer at TaskFlow Pro. The marketing team just asked for a complete product README before the v2.1 launch next week. You have the incomplete README from a previous writer and the official product specification.

Your job: use agent mode to audit the README, identify gaps, and draft the missing sections — without spending 2 hours on it manually.

## Your Goal (3-Step Agentic Task)

Use Copilot agent mode to:
1. **Review** the incomplete README and identify what's present vs. missing
2. **Diagnose** which gaps are most critical for a product launch audience
3. **Draft** the 2 most important missing sections

## Files You'll Use

- `non-engineer-series/module-01-docs/lab/starter/README-incomplete.md` — Incomplete README
- `non-engineer-series/module-01-docs/lab/starter/product-spec.md` — Full product specification

## What Good Looks Like

After completing this task, you should have:
- A clear inventory: what's complete, what's missing, what's thin
- A prioritized list of the 2 most important gaps
- Draft content for both gaps, ready for your review and editing

## What to Watch For

- Agent may generate generic content not grounded in the spec — ask it to reference `product-spec.md` specifically
- Check factual accuracy: does the generated content match what's actually in the spec?
- The agent should reference the existing README's tone — not just write generically
