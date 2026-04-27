# Lab: Document a Process You Own

**Time:** 20 minutes | **Module:** 11 — Markdown Mastery

## What You'll Build

A complete process runbook for something you actually do at work — written in Markdown, with a Mermaid flowchart, committed to GitHub and previewed live.

## Setup

1. Open `lab/starter/runbook-template.md` — your starting point
2. Open `lab/starter/mermaid-examples.md` — Mermaid syntax reference
3. Open Copilot Chat

---

## Task 1: Choose Your Process

Pick a process you run at least monthly. Examples:
- Weekly status report preparation
- New hire onboarding checklist
- Running a product demo
- Monthly expense reconciliation
- Sprint planning preparation
- Publishing a blog post or newsletter

Write one sentence describing your process and keep it handy.

---

## Task 2: Fill in the Overview

**Prompt:**
> "I'm writing a runbook for this process: [your one-sentence description]. Write an Overview section (3 sentences), a Purpose (1 sentence), and fill in the Frequency, Estimated Time, and Who Can Run This fields."

**Paste the result** into the Overview section of your runbook template.

---

## Task 3: Generate Step-by-Step Instructions

**Prompt:**
> "Write detailed step-by-step instructions for: [your process]. Include 5–8 numbered steps. Each step starts with an action verb. Add a brief 'Note:' for any step with a common mistake or important detail."

**Paste into** the Step-by-Step section of the runbook.

---

## Task 4: Generate a Mermaid Flowchart

**Prompt:**
> "Create a Mermaid flowchart for this process: [your process]. Include the steps you just wrote. Add at least one decision diamond (yes/no branch). Use the mermaid flowchart TD format."

**Paste the Mermaid code block** into your runbook after the step-by-step section.

**Preview it:** Copy the code block content and paste at [mermaid.live](https://mermaid.live) to verify it renders correctly.

---

## Task 5: Generate a FAQ

**Prompt:**
> "Write a FAQ section for this process with 5 questions. Include common questions from people doing it for the first time. Format as bold Q: followed by A: answers."

**Paste into** the FAQ section of the runbook.

---

## Task 6: Commit and Preview on GitHub

1. Save your completed runbook as `runbook-[process-name].md` in your repository
2. Commit and push to GitHub
3. Navigate to the file on GitHub.com
4. GitHub automatically renders the Markdown — including the Mermaid diagram

**Verify:** The Mermaid diagram renders as a visual flowchart, not raw text.

---

## Bonus: Create a Table of Contents

**Prompt:**
> "Add a Markdown table of contents at the top of this runbook document. Link to each H2 section heading using Markdown anchor links. Format as a bullet list."

---

## Reflection

- How long would this have taken to write from scratch?
- What did you add or change that Copilot got wrong?
- Who on your team should have access to this runbook?
