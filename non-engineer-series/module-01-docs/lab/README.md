# Lab: Complete the TaskFlow Pro Product Docs

**Time:** 30 minutes | **Module:** 01 — Writing Better Docs

## What You'll Build

A complete, polished README for TaskFlow Pro — using GitHub Copilot and the product specification as context.

## Setup

1. Open VS Code (or the GitHub Codespace for this module)
2. Open `lab/starter/README-incomplete.md` — this is your working file
3. Open `lab/starter/product-spec.md` — this is your source of truth
4. Open Copilot Chat in VS Code (click the chat icon in the sidebar)

---

## Task 1: Complete the Features Section

The README has 2 of 5 features listed. Add the remaining 3 from the spec.

**In Copilot Chat, type:**
> `#file:product-spec.md` The features section in the README is incomplete. Add the 3 missing features (Slack Integration, Reporting Dashboard, and Mobile App) using the same format as the existing 2 features. Keep each description to one sentence.

**Paste the result** into the `## Features` section of `README-incomplete.md`.

**Expected output:** 5 feature bullets in consistent format matching the existing style.

**Reflection:** Did Copilot match the format exactly? What would you edit?

---

## Task 2: Complete the Getting Started Steps

The README has steps 1–2 of the Getting Started guide. Add steps 3–5.

**Prompt:**
> `#file:product-spec.md` The Getting Started section is missing steps 3–5. Based on the product spec, generate 3 more logical setup steps after "Invite your team members via email." Keep each step to one sentence starting with an action verb.

**Paste the result** into the `## Getting Started` section.

---

## Task 3: Generate the FAQ

The FAQ section is completely empty. Generate 8 questions and answers.

**Prompt:**
> `#file:product-spec.md` `#file:README-incomplete.md` Generate a FAQ section with 8 questions and answers for TaskFlow Pro. Focus on questions a new user would ask about getting started, pricing, integrations, and mobile access. Format each Q&A as: **Q: [question]** followed by **A: [answer]** on the next line.

**Paste the result** into the `## FAQ` section.

---

## Task 4: Generate the Integrations Section

The integrations section is missing entirely.

**Prompt:**
> `#file:product-spec.md` Write an Integrations section for the TaskFlow Pro README. List all integrations as bullet points. For each integration, include a one-sentence description of what it does. Note which integrations are Enterprise only.

---

## Task 5: Match the Tone

Now that you have a complete draft, ask Copilot to review it for consistency.

**Prompt:**
> `#file:README-incomplete.md` Review this README for tone and style consistency. Are there any sections that feel noticeably different from the others? Rewrite the most inconsistent paragraph to match the overall tone.

**Apply the suggested rewrite** if you agree with it.

---

## Bonus: Write a Changelog Entry

**Prompt:**
> Write a CHANGELOG entry for TaskFlow Pro version 2.1. Use the Keep a Changelog format. Include: 2 new features from the spec, 1 improvement, and 1 bug fix (make up a realistic one). Date it today.

---

## Reflection

- How long did this take vs. writing the README from scratch?
- Which section needed the most editing after Copilot generated it?
- What would you add to a prompt to make Copilot's output need less editing?
