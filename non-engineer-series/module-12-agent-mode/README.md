# Module 12: Agent Mode for Non-Engineers

**Duration:** 120 minutes | **Audience:** All roles (intermediate) | **Format:** Workshop

## Overview

Agent mode takes Copilot from a single-turn assistant to a multi-step autonomous helper. Instead of one question, one answer — you describe a goal, and Copilot plans and executes multiple steps to reach it. This module demystifies agent mode for non-engineers through hands-on, role-specific scenarios that show what's possible and where the guardrails are.

## Learning Objectives

By the end of this module, you will be able to:

1. Explain the difference between Copilot Chat, inline suggestions, and agent mode
2. Describe a multi-step goal for Copilot and review the execution plan
3. Provide feedback mid-task to redirect agent behavior
4. Identify appropriate use cases for agent mode in your role
5. Recognize safety guardrails and when to stop and review

## Agenda

| Time | Activity |
|------|----------|
| 0–15 min | Chat vs. inline vs. agent mode — what's the difference? |
| 15–30 min | Demo: Agent mode in action (PM scenario) |
| 30–45 min | The execution plan: how to read and review it |
| 45–60 min | Giving feedback mid-task |
| 60–90 min | Lab: Run a 3-step agentic task |
| 90–110 min | Safety discussion: when to stop, verify, and own the output |
| 110–120 min | Debrief, Q&A, what's next |

## Key Concepts

### Chat vs. Agent Mode

| Mode | Behavior | Best For |
|------|----------|----------|
| Copilot Chat | Single question → single answer | Quick lookups, short drafts |
| Inline suggestions | Autocomplete as you type | Writing, coding |
| Agent mode | Goal description → multi-step plan → execution | Complex, multi-step tasks |

### Agent Mode Prompt Pattern

Be specific about the goal and the constraint:

> "Review the MeetingMind PRD in the starter file. Identify any user personas that don't have at least 3 user stories. For each gap you find, draft a user story in Role/Goal/Benefit format and create a GitHub Issue."

### The Execution Plan

Before Copilot acts, it shows you a plan. Review it. Ask yourself:
- Does this match what I wanted?
- Are there steps I don't recognize?
- Am I comfortable with it reading/writing these files?

You can say "Stop" at any time and redirect.

### Giving Mid-Task Feedback

Agent mode accepts mid-course corrections:
- "That issue title isn't descriptive enough — regenerate with more context."
- "Skip the third step — I already have that file."
- "Focus only on the first 3 items in the backlog, not all 10."

### Safety Guardrails

- Agent mode operates within your repository only — it cannot access other systems unless you give it tools
- All file writes are visible in the diff — review before accepting
- For anything involving external APIs, payments, or production data: always add a human review step
- The output is a draft — you own the final decision

### Use Cases by Role

| Role | Agent Mode Use Case |
|------|---------------------|
| PM | Analyze PRD → identify story gaps → create GitHub Issues |
| BA | Load dataset → find data quality issues → generate summary report |
| Writer | Review docs → identify gaps → draft missing sections |
| Designer | Review component specs → find inconsistencies → generate design tokens |
| Ops | Read runbook → identify out-of-date steps → flag for review |

## Prerequisites

- Modules 00–02 recommended (at minimum Module 00)

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Run a 3-Step Agentic Task (3 role paths)
- `lab/starter/pm-scenario.md` — PM scenario context card
- `lab/starter/writer-scenario.md` — Writer scenario context card
- `lab/starter/analyst-scenario.md` — Analyst scenario context card
- `facilitator-guide.md`
- `assessment.md`
