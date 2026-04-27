# Module 11: Markdown Mastery

**Duration:** 60 minutes | **Audience:** All roles | **Format:** Workshop

## Overview

Markdown is the universal language of GitHub documentation — READMEs, wikis, comments, pull requests, and issues all use it. With GitHub Copilot, you can write Markdown faster, generate Mermaid diagrams from plain-English process descriptions, and create professional runbooks and wikis for any process you own. No prior Markdown knowledge required.

## Learning Objectives

By the end of this module, you will be able to:

1. Write Markdown for headings, lists, tables, links, and code blocks
2. Use Copilot to generate a process runbook from a description
3. Create a Mermaid flowchart from a plain-English process description
4. Build a FAQ section from a list of topics
5. Commit a Markdown document and preview it on GitHub

## Agenda

| Time | Activity |
|------|----------|
| 0–10 min | Why Markdown? Plain text that looks great |
| 10–20 min | Demo: Markdown syntax quick tour |
| 20–30 min | Demo: Generate a runbook with Copilot |
| 30–40 min | Demo: Mermaid diagrams from descriptions |
| 40–55 min | Lab: Document a process you own |
| 55–60 min | Commit, push, preview on GitHub |

## Key Concepts

### Markdown Syntax Cheat Sheet

| Element | Markdown | Result |
|---------|----------|--------|
| Heading | `# H1` | Large title |
| Bold | `**bold**` | **bold** |
| List | `- item` | Bullet point |
| Numbered | `1. item` | 1. item |
| Table | `\| col \| col \|` | Table |
| Code | `` `code` `` | `code` |
| Link | `[text](url)` | Clickable link |

### Generating Runbooks with Copilot

> "Write a Markdown runbook for the monthly financial reconciliation process. Include: Overview, Prerequisites, Step-by-step instructions (numbered), Troubleshooting, and a FAQ with 5 questions."

### Mermaid Diagrams

GitHub renders Mermaid diagrams directly in Markdown. Describe your process:

> "Create a Mermaid flowchart for this process: A support ticket comes in → Is it urgent? → If yes: assign to on-call engineer and page manager → If no: add to queue → Triage within 24 hours → Resolve → Close ticket."

Copilot generates the `mermaid` code block. GitHub renders it as a real diagram.

### Why Version-Controlled Docs?

When your runbooks live in GitHub instead of a shared drive:
- Every change has a history and an author
- You can see exactly what the process was on any given date
- Team members can suggest edits via pull requests
- Docs live next to the systems they document

### Content Reuse

Copilot can adapt one piece of content for multiple audiences:
> "Rewrite this technical runbook for a non-technical audience. Replace jargon with plain language. Keep the numbered steps but add more context for each."

## Prerequisites

- Module 00 (Foundations) recommended

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Document a Process You Own
- `lab/starter/runbook-template.md` — Full runbook template with placeholders
- `lab/starter/mermaid-examples.md` — Three Mermaid diagram examples
- `facilitator-guide.md`
- `assessment.md`
