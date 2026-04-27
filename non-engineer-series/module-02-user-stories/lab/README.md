# Lab: Build the MeetingMind Backlog

**Time:** 30 minutes | **Module:** 02 — User Stories & Backlogs

## What You'll Build

A 10-story product backlog for MeetingMind, with acceptance criteria and a GitHub Issue template — all generated with GitHub Copilot.

## Setup

1. Open `lab/starter/prd-snippet.md` — the MeetingMind product requirements document
2. Open GitHub Copilot Chat (github.com/copilot or VS Code)
3. Have a text editor ready to save your outputs

---

## Task 1: Generate 10 User Stories

**Step 1:** Read through `prd-snippet.md` to understand the product.

**Step 2:** In Copilot Chat, type:

> `#file:prd-snippet.md` Based on this product requirements document, generate 10 user stories for MeetingMind. Use the format: "As a [role], I want to [action], so that [benefit]." Cover all 5 features described in the PRD. Use the personas mentioned (Taylor, Morgan, Casey) for at least 3 stories.

**Step 3:** Review the 10 stories. Ask yourself:
- Does each story have a clear "so that" benefit?
- Are all 5 features represented?
- Would an engineer know what to build from this?

**Reflection:** Which story is the most valuable? Which is the vaguest?

---

## Task 2: Add Acceptance Criteria to 3 Stories

Pick the 3 most important stories from Task 1.

**Prompt:**
> Take this user story: "[paste one story]" and add Given/When/Then acceptance criteria. Write 3 acceptance criteria (3 separate Given/When/Then statements). Be specific and testable.

Repeat for all 3 chosen stories.

**Expected output example:**
```
Given I am logged in and a meeting just ended,
When MeetingMind detects action items in the transcript,
Then each action item is listed with an owner and due date in the summary.
```

---

## Task 3: Decompose a Large Story

Pick the largest or most complex story from Task 1.

**Prompt:**
> This user story is too large for one sprint: "[paste story]"
> Break it into 5 smaller sub-tasks that could each be completed in less than 1 day of engineering work. Format each sub-task as a checkbox list item.

**Review:** Are all 5 sub-tasks clearly scoped? Could an engineer start work on each one without asking for clarification?

---

## Task 4: Create a GitHub Issue Template

**Prompt:**
> Format this user story as a GitHub Issue. Include:
> - Title (short, action-oriented)
> - User story (As a / I want / So that)
> - Acceptance criteria (Given/When/Then format, 3 criteria)
> - Labels: priority:high, type:feature
> - Effort estimate field (S/M/L/XL)
>
> Story: "[paste your best story from Task 1]"

**Copy the output.** If you have access to a GitHub repository, create an actual issue using this as the body.

---

## Bonus: Generate an Epic

**Prompt:**
> `#file:prd-snippet.md` Generate an epic-level story that encompasses the Action Item Detection feature. An epic follows this format: "In order to [business goal], as a [persona], I want [capability]." Then list the 5 user stories that belong under this epic.

---

## Reflection

- How different were the Copilot-generated stories from what you would have written manually?
- What role-specific details from the PRD did Copilot pick up correctly?
- What information was missing from the stories that you had to add?
