# Facilitator Guide: module-05-spreadsheets

## Overview
See the module README.md for learning objectives and agenda. This guide provides trainer-specific notes, demo scripts, and troubleshooting for the session.

## Pre-Session Checklist
- [ ] Complete the lab yourself before facilitating — know every step
- [ ] Confirm all participants have GitHub Copilot access
- [ ] Test any browser-based tools (DB Fiddle, mermaid.live, GitHub.com) in advance
- [ ] Share lab/README.md link with participants before the session

## Session Timing
Follow the agenda in the module README.md. Add 5 min buffer after every lab section for stragglers.

## Live Demo Tips
- Run every demo live using your own Copilot account — never show pre-generated output as "live"
- If Copilot produces an unexpected result, use it as a teaching moment: "This is interesting — let's debug it together"
- Narrate your prompt construction out loud: "I'm adding the role, now the context, now the specific task..."

## Common Questions & Answers

**Q: What if Copilot gives wrong output?**
A: Treat it as a teaching opportunity. Show the refinement loop: identify what's wrong, add context, re-run. Every "bad" output is a lesson in prompt improvement.

**Q: Can I use this at work right away?**
A: Yes — that's the goal. Pick one task from today's lab that maps to real work you do. Try the same prompt on real content this week.

**Q: Does this work for teams using different tools?**
A: The prompting skills are universal. Some tool-specific steps (VS Code, GitHub.com) may differ. Adapt the examples to your team's actual toolchain.

**Q: Is there a limit to how much I can use Copilot?**
A: Copilot seats have usage limits based on your organization's plan. Check with your GitHub admin if you're unsure about your allocation.

**Q: How do I get my team to adopt this?**
A: Share one specific prompt that solved a real problem you had this week. Concrete examples beat abstract advice every time.

## Troubleshooting
| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Copilot not responding | Session timeout | Refresh the page; re-authenticate if needed |
| Output in wrong language | Browser locale | Add "Respond in English" to the prompt |
| Output too long | No length constraint | Add "under [N] words" or "in [N] bullet points" |
| Very slow responses | Azure region latency | Wait 30s and retry; have backup output ready to paste |

## Energy Management Tips
- Use pair work for lab sections — one person types, one reviews. Discussing output improves quality and engagement.
- Celebrate the first person who completes a task by sharing their prompt with the group
- If energy drops, do a quick "compare prompts" exercise: same goal, 3 different prompts from 3 participants
- End every session with "What will you try at work this week?" — personal commitment increases follow-through
