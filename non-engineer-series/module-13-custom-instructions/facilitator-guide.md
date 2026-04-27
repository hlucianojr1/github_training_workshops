# Facilitator Guide: Module 13 — Custom Instructions & Copilot Setup

## Overview

This is the capstone module. Participants leave with a concrete artifact they can use immediately: a `copilot-instructions.md` file for their own team. The session works best when participants bring real examples from their domain instead of using the Meridian Health scenario exclusively.

## Pre-Session Checklist

- [ ] Confirm participants have completed at least Module 00 (some prior experience is needed to appreciate the "before/after")
- [ ] Prepare a "before/after" demo: same prompt without instructions, then with instructions
- [ ] Have your own team's copilot-instructions.md ready to share as a real example (if available)
- [ ] Share `lab/starter/copilot-instructions-draft.md` and `lab/starter/style-guide-excerpt.md` links

## Session Timing (75 minutes)

| Time | Activity | Notes |
|------|----------|-------|
| 0–10 min | What custom instructions do and where they live | Show the .github/ folder in a real repo |
| 10–20 min | Demo: Same prompt, before and after instructions | The most persuasive part of the session |
| 20–30 min | Anatomy of a great instructions file | Walk through the 5 sections live |
| 30–50 min | Lab: Complete the Meridian Health instructions | Circulate and encourage adaptation to real domains |
| 50–65 min | Bonus: Ask Copilot to improve its own instructions | Fun, slightly meta — good energy moment |
| 65–75 min | Sharing, governance discussion, Q&A | How do teams maintain this file? |

## Live Demo Script

### Demo: Before and After Instructions

**Setup:** Open github.com/copilot. Have no custom instructions set yet.

**Prompt (no instructions):**
> "Explain what prior authorization means."

Note the response — probably clinical or generic.

**Now:** Create or show a repo with the Meridian Health instructions file. Navigate to github.com/copilot with that repo selected.

**Same prompt:**
> "Explain what prior authorization means."

The response is now warmer, uses plain language, avoids jargon, and uses the "you" voice from the instructions.

**Say:** "Same prompt. Different instructions. That difference is what you're building today."

## Common Questions & Answers

**Q: Do custom instructions affect all Copilot responses everywhere?**
A: No. `.github/copilot-instructions.md` applies only to that repository. You also have personal global instructions in VS Code settings, but per-repo is more precise and shareable.

**Q: What if Copilot ignores the instructions?**
A: Instructions are guidance, not rules. Very specific or unusual instructions may be partially ignored. Include example pairs (prompt + expected output) — these have the most impact on behavior.

**Q: Can anyone on the team edit the instructions file?**
A: Anyone with write access to the repo. Best practice: require a PR review for changes to the instructions file, so the team maintains ownership collectively.

**Q: How long should the instructions file be?**
A: Quality over quantity. A 200-word file with a glossary and 3 example pairs outperforms a 2,000-word file without examples. Start focused, expand based on real gaps.

**Q: Can competitors see our copilot-instructions.md?**
A: If the repo is public, yes. Keep sensitive business context in private repos. The instructions file itself should not contain confidential information — just formatting and tone guidance.

## Troubleshooting

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Instructions not taking effect | File is not in `.github/copilot-instructions.md` exactly | Check the path — exact case and folder matter |
| Copilot ignores glossary terms | Terms are too technical for Copilot to override | Add example pairs showing the term used correctly |
| Instructions file breaks Copilot responses | Instructions are contradictory | Ask Copilot to review the file for conflicts |
| Participants can't find .github folder | Repo was created without a commit | Add any file first; the .github/ folder needs to exist |

## Energy Management Tips

- The "Ask Copilot to improve its own instructions" exercise generates energy naturally — let it breathe
- Share 1–2 participant-created instructions files at the end for peer learning
- Encourage participants to commit their file before leaving — the physical act of committing makes it feel real
