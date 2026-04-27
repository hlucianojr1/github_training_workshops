# Prompt Cheat Sheet — Module 00: Foundations

## Prompt Anatomy

Every effective Copilot prompt has four parts:

| Part | What It Does | Example |
|------|-------------|---------|
| **Role** | Tell Copilot who you are | "As a product manager…" |
| **Context** | Give background | "…for a B2B SaaS onboarding flow…" |
| **Task** | State what you need | "…write 5 user stories…" |
| **Format** | Specify the output shape | "…formatted as GitHub Issues." |

You don't need all four parts every time, but the more you include, the better the result.

---

## 10 Starter Prompts for Beginners

### Writing
1. "As a [role], write a [document type] about [topic]. Keep it under 200 words. Use a [formal/friendly] tone."
2. "Write a professional email to [audience] explaining [situation]. Include a clear next step at the end."

### Summarizing
3. "Summarize the following in 3–5 bullet points for a non-technical audience: [paste content]"
4. "Give me the key takeaways from this document in plain language: [paste or link content]"

### Creating Templates
5. "Create a template for [document type] that our [team/company type] can reuse. Include placeholders in square brackets."
6. "Generate a [meeting agenda / status report / onboarding checklist] template for a [team size] [team type]."

### Asking Questions
7. "Explain [concept or term] in plain language for someone with no technical background."
8. "What is the difference between [thing A] and [thing B]? Use a table if it helps."

### Formatting
9. "Convert this bullet list into a markdown table with columns for [column names]: [paste list]"
10. "Rewrite this paragraph in a more [formal/concise/friendly] tone: [paste paragraph]"

---

## Copilot Surface Guide

| Surface | Best For | How to Access |
|---------|----------|---------------|
| GitHub.com Copilot Chat | Working with repos, issues, PRs without VS Code | github.com/copilot |
| VS Code Copilot Chat | Anything in your project files, #file context | Click Copilot icon in VS Code sidebar |
| VS Code Inline | Getting suggestions as you type | Start typing in any file |
| GitHub Mobile | Quick questions on the go | GitHub app → Copilot tab |
| GitHub CLI | Terminal-based queries | `gh copilot suggest` |

---

## Common Mistakes & Fixes

| Mistake | Why It Fails | Better Approach |
|---------|-------------|-----------------|
| "Write something for my team" | Too vague — no context, no format | "Write a Slack message for my engineering team announcing the v2.0 release" |
| "Make it better" | Copilot doesn't know what "better" means | "Make it more concise and remove jargon" |
| Long wall of text | Copilot loses focus | Break into multiple targeted prompts |
| Accepting the first output | First drafts are starting points | Always refine with 1–2 follow-up prompts |
| Using Copilot for sensitive data | Privacy and accuracy risk | Never paste PII or confidential data into any AI tool without verifying your policy |

---

## Prompt Patterns Reference

### The Refinement Loop
1. Generate → 2. Review → 3. Refine with a follow-up prompt → 4. Repeat until satisfied → 5. Own the final version

### Useful Refinement Prompts
- "Make this shorter by 30%"
- "Use simpler language — aim for a 10th grade reading level"
- "Add a FAQ section at the end"
- "Match the tone of this example: [paste example]"
- "Add more specific detail about [topic]"
- "Break this into 3 sections with headers"
