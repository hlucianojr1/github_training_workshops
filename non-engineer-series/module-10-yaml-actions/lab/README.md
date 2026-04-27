# Lab: Create a Welcome New Contributor Workflow

**Time:** 30 minutes | **Module:** 10 — YAML & GitHub Actions

## What You'll Build

A GitHub Actions workflow that automatically posts a welcome comment when someone opens their first pull request to your repository.

## Setup

1. Use your `dashboardv2-launch` repository from Module 09 (or create a new public repo)
2. Open VS Code with Copilot Chat
3. Have `lab/starter/workflow-incomplete.yml` open

---

## Task 1: Add the Workflow Trigger

**Step 1:** Open `lab/starter/workflow-incomplete.yml`.

**Step 2:** In Copilot Chat:

> "Complete this GitHub Actions workflow YAML. First, add the correct trigger: it should run on the `pull_request` event, but only when the action is `opened`. Show just the `on:` section."

**Paste the result** into your YAML file, replacing the trigger TODO comment.

---

## Task 2: Add the Welcome Job

**Prompt:**
> "Add a complete GitHub Actions job to this workflow that: runs on ubuntu-latest, checks if this is the contributor's first pull request, and if so, posts a comment saying: 'Welcome to DashboardV2! 🎉 Thanks for your first contribution. A maintainer will review your PR within 2 business days. Check our CONTRIBUTING.md if you have questions.' Use the peter-evans/first-interaction action. Use ${{ secrets.GITHUB_TOKEN }} for authentication."

**Paste the result** into your YAML file, replacing the jobs TODO comment.

---

## Task 3: Understand What You Built

Ask Copilot to explain the workflow you just created:

> "Explain this GitHub Actions workflow YAML in plain English, section by section: [paste your complete YAML]"

Read the explanation. If anything is unclear, ask a follow-up.

---

## Task 4: Commit and Watch It Run

1. Create the file `.github/workflows/welcome.yml` in your repository
2. Paste your completed YAML
3. Commit directly to the `main` branch
4. Open a pull request from a different branch (or from a test account)
5. Go to the **Actions** tab and watch the workflow run

**Expected result:** A welcome comment appears on the PR within ~30 seconds.

---

## Task 5: Read a Workflow Log

If the workflow fails (or even if it succeeds):
1. Click into the Actions run
2. Click on the job name
3. Expand a step to see its log output

**Practice debugging:**
> "This GitHub Actions step failed with this log output: [paste log lines]. Here is my workflow YAML: [paste YAML]. What went wrong and how do I fix it?"

---

## YAML Indentation Warning

YAML is sensitive to indentation. Two spaces per level — not tabs. If you get a parse error:
> "This GitHub Actions YAML has an indentation error. Please fix it: [paste YAML]"

---

## Reflection

- What other automation would be valuable to add to a repository you own?
- What is the difference between a secret and a regular environment variable?
- How would you modify this workflow to also send a Slack notification?
