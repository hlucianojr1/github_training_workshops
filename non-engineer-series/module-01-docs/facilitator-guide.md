# Facilitator Guide: Module 01 — Writing Better Docs

## Overview
Participants use GitHub Copilot to generate and refine product documentation grounded in real spec files. Key skill: the #file context trick. Success = every participant has a complete product FAQ by end of session.

## Pre-Session Checklist
- [ ] Verify VS Code with Copilot Chat is available (or plan for GitHub.com fallback)
- [ ] Test `#file:` in VS Code Copilot Chat — open product-spec.md and reference it
- [ ] Share the starter files path with participants
- [ ] Prepare your "bad AI output" demo (generic FAQ not grounded in spec)

## Session Timing (90 minutes)
| Time | Activity | Notes |
|------|----------|-------|
| 0–10 min | Why docs fall behind | Ask: "How often do your docs lag your product?" |
| 10–20 min | Doc type taxonomy | Use the how-to/reference/tutorial/explanation framework |
| 20–35 min | Demo: #file context | Run Task 1 live. Show grounded vs ungrounded output |
| 35–50 min | Demo: Iterative refinement | Show "make it shorter" → "match this tone" |
| 50–80 min | Lab: TaskFlow Pro docs | Participants work through tasks 1–5 |
| 80–90 min | Responsible use discussion, Q&A | Emphasize review-refine-own |

## Common Questions & Answers
**Q: Is it plagiarism if I publish AI-written docs?**
A: Not legally, but you own the responsibility for accuracy. Always review and edit. The output is a draft, not a finished product.

**Q: What if Copilot makes up features that don't exist?**
A: This is called hallucination and it happens. Using #file with a real spec dramatically reduces it. Always fact-check AI output against your source of truth.

**Q: Will Copilot replace technical writers?**
A: Copilot accelerates the drafting phase. Expert humans are still needed for accuracy, strategy, information architecture, and editorial judgment.

**Q: Can I use this for internal documentation too?**
A: Yes — and it's often even more impactful there. Internal wikis, runbooks, and onboarding guides are great targets.

**Q: What's the best format to give Copilot context?**
A: Markdown files work best. PDFs and complex Word documents lose structure when pasted.

## Troubleshooting
| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| #file not working | Not in VS Code Copilot Chat | #file only works in VS Code; use paste for GitHub.com |
| Output is too generic | No file context provided | Add `#file:product-spec.md` before the prompt |
| FAQ has wrong product info | Copilot hallucinated | Ask: "Verify these FAQ answers against #file:product-spec.md" |
| Output is too long | No length constraint | Add "under 50 words per answer" to the prompt |

## Energy Management Tips
- Do Task 1 as a group — everyone running the same prompt simultaneously and comparing outputs generates great discussion
- The iterative refinement demo is the highest-engagement moment; let participants shout out refinements to try live
- Save 5 minutes at the end for the responsible use discussion — it lands better after participants have seen outputs
