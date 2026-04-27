# Module 00: Foundations — What Copilot Is (and Isn't)

**Duration:** 60 minutes | **Audience:** All roles | **Format:** Lecture + Demo

## Overview

This module establishes the foundational mental model every non-engineer needs before using GitHub Copilot. You'll learn what Copilot actually is, where it lives, how it works, and how to write your first effective prompts — without any technical background.

## Learning Objectives

By the end of this module, you will be able to:

1. Explain the difference between GitHub Copilot and general-purpose AI chat tools
2. Identify the five surfaces where Copilot is available and when to use each
3. Write a well-structured prompt using the Role + Context + Task + Format framework
4. Describe how GitHub Copilot handles your data and privacy
5. Complete at least 3 successful Copilot interactions independently

## Agenda

| Time | Activity |
|------|----------|
| 0–10 min | Welcome and framing: why non-engineers need Copilot |
| 10–20 min | What Copilot is — and what it isn't |
| 20–30 min | Live demo: Copilot on GitHub.com and in VS Code |
| 30–45 min | Prompt anatomy: Role + Context + Task + Format |
| 45–55 min | Lab: Your first 3 Copilot prompts |
| 55–60 min | Debrief, Q&A, key takeaways |

## Key Concepts

### Copilot ≠ ChatGPT

ChatGPT knows about the world. GitHub Copilot knows about the world *and* your repository. When you're working inside a repo, Copilot can read your files, understand the context of your project, and give you suggestions grounded in what your team is actually building. General AI chat tools don't have that context.

### The Five Copilot Surfaces

Copilot lives in multiple places. You don't need to learn all of them today — but knowing they exist helps you choose the right tool for the right task.

1. **VS Code / IDE inline suggestions** — Copilot suggests code as you type (for developers)
2. **Copilot Chat in VS Code** — A sidebar chat window with repo context
3. **GitHub.com chat** — Available at github.com/copilot, works on any public repo
4. **GitHub CLI** — Command-line access (for technical users)
5. **GitHub Mobile** — Copilot Chat on iOS and Android

### Prompt Anatomy

A great prompt has four parts:

| Part | What It Does | Example |
|------|-------------|---------|
| **Role** | Tell Copilot who you are | "As a product manager…" |
| **Context** | Give background information | "…working on a B2B SaaS onboarding flow…" |
| **Task** | State what you need | "…write 5 user stories…" |
| **Format** | Specify the output shape | "…formatted as GitHub Issues." |

### Privacy & Data Residency

By default, GitHub Copilot does not use your code to train its models if your organization has disabled telemetry. Your prompts and suggestions are processed in Microsoft Azure datacenters. For sensitive content, always consult your organization's AI use policy.

### Workspace Context

In VS Code and GitHub Copilot Chat, you can reference specific files using `#file:filename.md`. This tells Copilot to read that file and use it as context. This is one of the most powerful features for non-engineers — you can point Copilot at a PRD, spec, or data file and ask questions about it.

## Prerequisites

None. This is the starting point for all learning paths.

## Materials Needed

- GitHub account with Copilot access
- A web browser — no installation required for the lab

## Lab

See [lab/README.md](lab/README.md) for step-by-step instructions.

## Files

- `slides/outline.md` — Full slide deck with speaker notes
- `lab/README.md` — Your first 3 Copilot prompts
- `lab/prompt-cheat-sheet.md` — Reference card for prompts and surfaces
- `facilitator-guide.md` — Trainer notes and timing
- `assessment.md` — Pre/post quiz and practical challenge
