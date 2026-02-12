---
mode: 'agent'
description: 'Perform a structured code review for recent changes against Urban Survivor coding standards and architecture.'
---

Review the changes with a focus on safety, stability, and consistency.

Load context first:
- docs/CODING_STANDARDS.md
- docs/ARCHITECTURE.md
- Changed files (git diff or described list)

Review checklist:
- Null safety (ERR_FAIL_* before deref)
- No node creation in constructors
- Proper Godot 4.3 API usage (no removed constants)
- Signals/method bindings correct
- Minimal coupling (prefer signals)
- Build passes locally

Output format:
- Summary
- Must fix (with file + rationale)
- Suggestions
- Questions
- Verdict: Approved / Changes requested
