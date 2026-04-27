# Module 10: YAML & GitHub Actions

**Duration:** 120 minutes | **Audience:** Ops, DevOps-adjacent, IT | **Format:** Workshop

## Overview

GitHub Actions automates repetitive tasks — running tests, sending notifications, creating issues, deploying websites. Actions are configured in YAML files, and while YAML looks intimidating, GitHub Copilot can write it for you from a plain-English description. This module teaches non-engineers to create, understand, and debug simple automation workflows.

## Learning Objectives

By the end of this module, you will be able to:

1. Read a YAML file and identify its key parts (keys, values, indentation, lists)
2. Use Copilot to generate a complete GitHub Actions workflow from a description
3. Set up a trigger, job, and step in a workflow
4. Add a repository secret and reference it safely in a workflow
5. Read a GitHub Actions run log to identify and fix a failure

## Agenda

| Time | Activity |
|------|----------|
| 0–15 min | What YAML is and why it matters for automation |
| 15–25 min | Demo: Read an existing workflow file |
| 25–40 min | Demo: Generate a workflow with Copilot |
| 40–55 min | Demo: Triggers, jobs, steps explained |
| 55–70 min | Demo: Add a secret and reference it |
| 70–100 min | Lab: Create a Welcome New Contributor workflow |
| 100–115 min | Demo: Read a workflow failure log with Copilot |
| 115–120 min | Debrief, Q&A |

## Key Concepts

### YAML Is Just Structured Text

YAML (Yet Another Markup Language) uses indentation to show hierarchy — like an outline. Each level is 2 spaces in. Keys have colons. Lists start with dashes. That's 80% of what you need to know.

```yaml
name: My Workflow    # Key: value
on: push             # Trigger
jobs:
  my-job:            # Job name
    runs-on: ubuntu-latest
    steps:
      - name: Say hello    # Step
        run: echo "Hello"
```

### Workflow Anatomy

Every GitHub Actions workflow has:
- `name:` — what to call it
- `on:` — when to run it (push, pull_request, schedule, etc.)
- `jobs:` — what to do (one or more jobs run in parallel or sequence)
- `steps:` — individual tasks within a job

### Copilot Workflow Generation Prompt

> "Write a GitHub Actions workflow that runs when a pull request is opened. The job should check if this is the contributor's first pull request, and if so, post a welcome comment saying 'Thanks for your first contribution!'"

### Secrets Management

Never put passwords or API keys in a YAML file. Store them as GitHub repository secrets:
1. Settings → Secrets and variables → Actions → New repository secret
2. Reference in YAML: `${{ secrets.MY_SECRET_NAME }}`

Copilot knows this pattern and will use it automatically when generating workflows.

### Reading Failure Logs with Copilot

When a workflow fails:
1. Click the failed run in the Actions tab
2. Copy the error lines from the log
3. Ask Copilot: "This GitHub Actions step failed with this error: [paste error]. Here is my workflow YAML: [paste YAML]. What is wrong?"

## Prerequisites

- Module 00 (Foundations) recommended
- A GitHub account with at least one repository

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Create a Welcome New Contributor Workflow
- `lab/starter/workflow-incomplete.yml` — Starter workflow to complete
- `facilitator-guide.md`
- `assessment.md`
