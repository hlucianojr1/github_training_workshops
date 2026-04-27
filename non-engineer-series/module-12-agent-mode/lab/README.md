# Lab: Run a 3-Step Agentic Task

**Time:** 30 minutes | **Module:** 12 — Agent Mode for Non-Engineers

## What You'll Do

Run a 3-step agentic Copilot task using a scenario matched to your role. Choose one of three paths below.

## Setup

- You need access to GitHub Copilot agent mode in VS Code (requires Copilot subscription)
- Open the scenario card that matches your role from `lab/starter/`
- Have your chosen module's starter files accessible

---

## Choose Your Path

### Path A: PM / BA — Gap Analysis
**Scenario:** [See lab/starter/pm-scenario.md](lab/starter/pm-scenario.md)

**Step 1 — Analyze:**
> "Review the MeetingMind PRD at [path to module-02 prd-snippet.md]. Identify all user personas mentioned and list the features assigned to each persona."

**Step 2 — Identify Gaps:**
> "Based on the PRD analysis, which features have user stories (from module-02 backlog work) and which features have no user stories yet? List the gaps."

**Step 3 — Generate:**
> "For each feature gap you identified, draft one user story in As a / I want / So that format, then format it as a GitHub Issue with title, user story, and 2 acceptance criteria."

Review all outputs carefully before accepting.

---

### Path B: Writer / Docs — Documentation Audit
**Scenario:** [See lab/starter/writer-scenario.md](lab/starter/writer-scenario.md)

**Step 1 — Review:**
> "Review the TaskFlow Pro README at [path to module-01 README-incomplete.md]. List all sections that are present and all sections that are still marked as missing or incomplete."

**Step 2 — Identify Gaps:**
> "Based on the incomplete README and the product spec at [path to product-spec.md], what documentation gaps exist? Which sections are missing entirely vs. just thin?"

**Step 3 — Draft:**
> "Draft the 2 most important missing sections of the TaskFlow Pro README based on the product spec. Write in the same tone as the existing content."

---

### Path C: Analyst / Finance — Data Summary Report
**Scenario:** [See lab/starter/analyst-scenario.md](lab/starter/analyst-scenario.md)

**Step 1 — Load and Describe:**
> "Describe the sales dataset at [path to module-06 sales.csv]. How many rows? What columns? What date range? What are the unique values in the 'region' and 'customer_tier' columns?"

**Step 2 — Identify Issues:**
> "What data quality issues exist in this dataset? List: null values by column, inconsistent formatting, and any outliers or unusual values."

**Step 3 — Summarize:**
> "Generate a brief data quality summary report for the sales dataset. Format as a markdown document with: Executive Summary (2 sentences), Data Quality Issues table, and Recommended Cleaning Steps."

---

## How to Give Mid-Task Feedback

If an agent step produces output you don't want:
- "That's not what I needed — [describe what you actually want]"
- "Focus only on [specific subset] — ignore the rest"
- "That output is too long — summarize it in 3 bullet points"
- "Stop — I need to review this before you continue"

## Review Checklist Before Accepting Output

- [ ] Does the output match what I asked for?
- [ ] Is any information factually wrong?
- [ ] Are there steps that look unusual or unexpected?
- [ ] Would I be comfortable sharing this output with my team?

---

## Reflection

- Which step required the most review and correction?
- What would you add to the initial prompt to reduce editing?
- Where do you think agent mode would save the most time in your real job?
