# Lab: Mini Project Board for DashboardV2 Feature Launch

**Time:** 30 minutes | **Module:** 09 — GitHub Issues, PRs & Projects

## What You'll Build

A complete GitHub project board for the DashboardV2 feature launch — including Issues, a bug report template, a PR description, and release notes — all with Copilot's help.

## Setup

1. Create a new public GitHub repository named `dashboardv2-launch`
2. Open Copilot Chat at github.com/copilot
3. Have `lab/starter/feature-brief.md` open for reference

---

## Task 1: Generate 5 GitHub Issues from the Feature Brief

**Step 1:** Open `lab/starter/feature-brief.md` and read through the 5 features.

**Step 2:** In Copilot Chat, paste the feature brief content and ask:

> "Based on this feature brief, generate 5 GitHub Issues — one per feature. Each issue should have: a short action-oriented title, a user story (As a / I want / So that), 3 acceptance criteria in Given/When/Then format, and labels: 'feature' and 'v2.0'. Format each issue as a markdown block I can copy into GitHub."

**Step 3:** Create each issue in your `dashboardv2-launch` repository.

---

## Task 2: Complete the Bug Report Issue Template

**Step 1:** Open `lab/starter/issue-template-draft.md` — this is a partial YAML issue template.

**Step 2:** In Copilot Chat, ask:

> `#file:issue-template-draft.md` This GitHub issue template YAML is incomplete. Add the missing fields: Steps to Reproduce (textarea, required), Expected Behavior (textarea, required), Actual Behavior (textarea, required), Severity dropdown with options low/medium/high/critical (required), and Environment checkboxes for Web, iOS, Android, API. Keep the existing fields and structure."

**Step 3:** Create the file `.github/ISSUE_TEMPLATE/bug_report.yml` in your repo and paste the completed template.

---

## Task 3: Write a PR Description

**Step 1:** Open `lab/starter/pr-description-draft.md`.

**Step 2:** In Copilot Chat:

> `#file:pr-description-draft.md` Complete this pull request description. Expand the summary to 3–4 sentences explaining what DashboardV2 custom date ranges and CSV export add for users. Fill in the missing Changes Made bullets, write a Testing Done section (unit tests for date logic, CSV generation, and manual testing on Chrome/Firefox/Safari), and add an accessibility checklist.

---

## Task 4: Set Up a GitHub Project Board

1. In your repository, click the **Projects** tab → **New project**
2. Select **Board** view
3. Name it: "DashboardV2 Feature Launch"
4. Create columns: **Backlog**, **In Progress**, **In Review**, **Done**
5. Move the 5 Issues you created into the **Backlog** column

---

## Task 5: Generate Release Notes

**Prompt:**
> "Write release notes for CloudMetrics Dashboard v2.0. New features: custom date ranges, CSV export, shareable dashboard links, real-time data refresh (60-second intervals), and mobile-responsive layout. Write for a non-technical end-user audience. Format as a bulleted list under the heading '## What's New in v2.0'. Keep it under 250 words."

**Create a new file** in your repo called `CHANGELOG.md` and paste the release notes.

---

## Reflection

- How long would it take to manually write all 5 issues + template + PR description?
- What information did you need to provide that Copilot couldn't generate?
- How would you use a GitHub Project board to manage your real work?
