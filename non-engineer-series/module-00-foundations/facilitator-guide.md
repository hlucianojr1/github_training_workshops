# Facilitator Guide: Module 00 — Foundations

## Overview

This is the entry point for every learning path. The goal is to give participants a confident mental model of Copilot, dispel myths, and get everyone through 3 successful prompts before the session ends. Success means participants leave believing they can use Copilot tomorrow.

## Pre-Session Checklist

- [ ] Confirm all participants have GitHub accounts with Copilot access
- [ ] Test your own Copilot access at github.com/copilot before the session
- [ ] Have a public GitHub repository URL ready for the demo (suggest: github.com/microsoft/vscode)
- [ ] Share the lab README link or print the prompt cheat sheet
- [ ] Check room audio/video if running hybrid
- [ ] Have a backup plan if Copilot is slow (paste pre-generated outputs and discuss)

## Session Timing (60 minutes)

| Time | Activity | Notes |
|------|----------|-------|
| 0–5 min | Welcome, introductions, ground rules | Ask: "Has anyone tried Copilot before? What for?" |
| 5–15 min | What Copilot is — and what it isn't | Keep it conversational. Use the ChatGPT comparison to anchor |
| 15–25 min | Live demo: Copilot surfaces overview | Show GitHub.com Chat only — don't overwhelm with VS Code yet |
| 25–40 min | Prompt anatomy: Role + Context + Task + Format | Build one prompt together as a group |
| 40–55 min | Lab: First 3 prompts | Circulate and help. Celebrate loud successes |
| 55–60 min | Debrief, key takeaways, what's next | End with: "What will you try tomorrow?" |

## Live Demo Script

### Demo 1: GitHub.com Copilot Chat

**Setup:** Have github.com/copilot open in your browser, and github.com/microsoft/vscode open in another tab.

**Say:** "Let me show you what this looks like. I'm going to ask Copilot to explain a large technical project in plain language."

**Type this prompt:** "Explain what the repository at github.com/microsoft/vscode is, in plain language for someone who has never heard of it. Use 3 bullet points."

**Point out:** The response uses plain language, is structured, and takes about 5 seconds. Ask: "Who here could have written that? Now you don't have to."

### Demo 2: Prompt Refinement

**Say:** "Now watch what happens when I refine the output."

**Type:** "Now give me the same explanation but for an executive who has 30 seconds to read it."

**Point out:** Same knowledge, different format and depth. This is the power of the refinement loop.

## Common Questions & Answers

**Q: Is Copilot the same as ChatGPT?**
A: They both use large language models, but Copilot is trained with a focus on code and software development. More importantly, Copilot integrates with GitHub — so it can read your actual repository files. ChatGPT only knows about the world in general; Copilot knows about your project.

**Q: Will Copilot share my code with competitors?**
A: By default, GitHub doesn't use your code to train its models if your organization has disabled telemetry. Check your organization's Copilot settings. Avoid pasting sensitive or confidential content into any AI tool until you've reviewed your company policy.

**Q: What if Copilot gives me wrong information?**
A: Copilot can and does make mistakes. Treat every output as a first draft from a very fast, imperfect assistant. You own the final version. Always review before publishing or acting on AI-generated content.

**Q: Do I need to know how to code to use this?**
A: No. This entire workshop series is designed for people without coding backgrounds. You'll use Copilot for writing, analysis, templates, and documentation — not code.

**Q: What happens to my prompts?**
A: Prompts are sent to Microsoft Azure for processing. GitHub Enterprise users have additional privacy controls. Don't paste PII (names, emails, SSNs) into Copilot prompts.

## Troubleshooting

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| "You don't have access to Copilot" | No seat assigned | Contact GitHub org admin to assign a seat |
| Copilot Chat loads but doesn't respond | Browser extension conflict | Try an incognito window |
| Very slow responses | Azure region latency | Wait and retry; have backup demo output ready |
| Responses in wrong language | Browser language setting | Add "Respond in English" to the prompt |

## Energy Management Tips

- Do Prompt 3 as a group activity: pick one participant's real-world task and build the prompt together on screen. The personal relevance creates immediate engagement.
- During the lab, set a 2-minute timer for Prompt 1 so participants don't overthink it.
- Call out specific participant outputs: "Sam just wrote a launch email in 45 seconds — share it with the group."
- If energy drops during the prompt anatomy section, skip straight to the demo and explain anatomy retroactively.
- End 5 minutes early if possible — leaving participants wanting more is better than running over.
