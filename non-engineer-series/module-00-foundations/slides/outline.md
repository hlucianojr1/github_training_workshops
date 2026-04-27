# Module 00 Slides: Foundations

---

## Slide 1: Title
**GitHub Copilot for Non-Engineers: Foundations**
*What Copilot is, where it lives, and how to use it from day one*

Module 00 | 60 minutes | All roles

**Speaker Notes:** Welcome everyone. Today is about building the right mental model — not about memorizing tools. By the end of this session, you'll have made your first 3 Copilot prompts. Let's start.

---

## Slide 2: Who Is This For?
- Product managers
- Business analysts
- Designers
- Marketers
- HR and Operations
- Finance
- Anyone who writes, analyzes, or creates at work

**Speaker Notes:** Raise your hand if you've ever spent more than 30 minutes writing something you knew was repetitive. That's who this is for. Everyone in this room.

---

## Slide 3: What Problem Are We Solving?
- We spend too much time on first drafts
- We re-invent templates that already exist elsewhere
- We ask "how do I write a [thing]" and get generic answers
- We can't analyze data without waiting for someone else
- We waste time reformatting, summarizing, and restructuring

**Speaker Notes:** These are not engineering problems. They're everyone problems. Copilot doesn't write code for you — it thinks alongside you.

---

## Slide 4: What Copilot Is NOT
- ❌ Not a replacement for your expertise
- ❌ Not always correct — it makes mistakes
- ❌ Not ChatGPT (has your repository context)
- ❌ Not a magic button that produces finished work
- ❌ Not a tool only for engineers

**Speaker Notes:** I want to address the fear in the room directly. Copilot is not here to replace you. It's a very fast, imperfect collaborator. You are still the expert. You make the final call on everything.

---

## Slide 5: What Copilot IS
- ✅ A writing accelerator for any professional content
- ✅ A context-aware assistant that reads your files
- ✅ A 24/7 collaborator that drafts, summarizes, and explains
- ✅ A tool accessible to every role — no code required
- ✅ An iterative partner: you guide, it drafts, you refine

**Speaker Notes:** The key word is "accelerator." A good draft in 30 seconds that you refine for 5 minutes beats a blank page for 2 hours every time.

---

## Slide 6: Copilot vs. General AI Chat

| | GitHub Copilot | General AI Chat |
|--|---------------|-----------------|
| Knows your repo | ✅ Yes | ❌ No |
| Code suggestions | ✅ Yes | ⚠️ Limited |
| Integrated into GitHub | ✅ Yes | ❌ No |
| Repository context | ✅ Yes | ❌ No |
| Free-form chat | ✅ Yes | ✅ Yes |

**Speaker Notes:** The table on screen shows the key difference. If you work in GitHub, use Copilot — it knows your project. General chat tools don't.

---

## Slide 7: The Five Copilot Surfaces
1. **GitHub.com Chat** — browser, no setup, works on any repo
2. **VS Code Chat sidebar** — for when you're editing files
3. **VS Code Inline** — autocomplete suggestions as you type
4. **GitHub Mobile** — Copilot on your phone
5. **GitHub CLI** — for the command line

**Speaker Notes:** Today we'll use GitHub.com Chat only — no installation needed. Once you're comfortable, explore VS Code. For non-engineers, GitHub.com Chat is often the most useful surface.

---

## Slide 8: DEMO — GitHub.com Copilot Chat
*Live demo: github.com/copilot*

**What I'm typing:**
> "Explain what the repository at github.com/microsoft/vscode is, in plain language for someone who has never heard of it. Use 3 bullet points."

Watch the response appear in seconds.

**Speaker Notes:** Navigate to github.com/copilot now and show the interface. Type the prompt live. Point out the response time, the plain language, and the structured output.

---

## Slide 9: Prompt Anatomy — Part 1
Great prompts have 4 parts:

1. **Role** — Who you are: "As a product manager..."
2. **Context** — Background: "...working on a B2B SaaS onboarding flow..."
3. **Task** — What you need: "...write 5 user stories..."
4. **Format** — Output shape: "...formatted as GitHub Issues."

**Speaker Notes:** You don't need all four every time. But the more context you give, the more useful the output. Think of it as briefing a new colleague who is very talented but knows nothing about your work yet.

---

## Slide 10: Prompt Anatomy — Part 2

**Weak prompt:** "Write something for my team"

**Strong prompt:** "As a project manager at a 50-person software company, write a Slack announcement telling the engineering team that the Q3 roadmap is finalized. Include the 3 top priorities and a link placeholder. Keep it under 100 words."

**Speaker Notes:** Show both prompts side-by-side. Run both in Copilot if time allows. The difference in output quality is dramatic. This is the most important skill in the session.

---

## Slide 11: The Refinement Loop
1. **Generate** — first draft from Copilot
2. **Review** — read it critically
3. **Refine** — follow-up prompt to improve
4. **Repeat** — 1–3 refinement rounds
5. **Own** — edit directly until it's yours

**Speaker Notes:** First drafts are starting points, not finished products. The real power of Copilot is the back-and-forth. Think of it like working with an editor who responds instantly.

---

## Slide 12: Useful Refinement Prompts
- "Make this 30% shorter"
- "Use simpler language — grade 10 reading level"
- "Add a FAQ section at the end"
- "Make the tone more empathetic"
- "Match the tone of this example: [paste]"
- "Add more specific detail about [topic]"

**Speaker Notes:** These refinement prompts work across all types of content. Write them on a sticky note for the first week. You'll memorize them quickly.

---

## Slide 13: Privacy & Data — What You Need to Know
- Prompts are processed on Microsoft Azure
- Don't paste: names, emails, SSNs, passwords, PII
- GitHub Enterprise orgs can disable telemetry
- Check your organization's AI use policy
- Read-only tasks (summarize, explain) are lower risk than write tasks

**Speaker Notes:** This is important. I'm not saying don't use Copilot — I'm saying be thoughtful about what you type. Treat it like typing into any cloud-connected service.

---

## Slide 14: Workspace Context with #file
In VS Code Copilot Chat:

`#file:product-spec.md` Write a FAQ based on this spec.

Copilot reads the file and grounds its output in real content. No more generic answers.

**Speaker Notes:** This is the feature that separates Copilot from everything else. In VS Code, you can point Copilot at your actual files. We'll use this in later modules, especially Modules 01 and 02.

---

## Slide 15: Lab Time — Your First 3 Prompts
**Open:** github.com/copilot

**Task 1:** Explain a public repo in plain language
**Task 2:** Summarize a README in 5 bullets
**Task 3:** Write something real for your job

Use the Prompt Cheat Sheet for help!

**Speaker Notes:** Give everyone the lab README link or printed sheet now. Set a timer for 15 minutes. Circulate and help anyone who gets stuck on setup. Celebrate the first person to complete all 3.

---

## Slide 16: Key Takeaways
1. Copilot is for everyone — not just engineers
2. It has repository context that general AI chat tools don't
3. Great prompts use Role + Context + Task + Format
4. First drafts are starting points — always refine and own the output
5. Never paste sensitive data into any AI tool without checking policy

**What's next:** Module 01 — Writing Better Docs | Module 02 — User Stories | Module 03 — Templates

**Speaker Notes:** What's one thing you'll try with Copilot this week? Go around the room if time allows. Hearing real use cases from colleagues is the best way to spark ideas.

---
