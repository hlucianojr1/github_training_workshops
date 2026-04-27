# Module 13: Custom Instructions & Copilot Setup

**Duration:** 75 minutes | **Audience:** Power users, team leads | **Format:** Workshop

## Overview

Custom instructions let you teach GitHub Copilot about your organization — your tone, your vocabulary, your processes, and your standards — so every Copilot interaction reflects your team's context, not a generic one. This module teaches you to write, maintain, and version-control a `copilot-instructions.md` file that makes Copilot feel like a team member who already knows your domain.

## Learning Objectives

By the end of this module, you will be able to:

1. Explain what a `copilot-instructions.md` file does and where it lives
2. Write a complete set of custom instructions for your team or organization
3. Add a domain glossary so Copilot understands your terminology
4. Define formatting preferences and tone standards
5. Add example prompt-output pairs to calibrate Copilot's behavior

## Agenda

| Time | Activity |
|------|----------|
| 0–10 min | What custom instructions are and how they work |
| 10–20 min | Demo: Before and after — same prompt, different instructions |
| 20–35 min | Anatomy of a great instructions file |
| 35–50 min | Lab: Write instructions for Meridian Health |
| 50–65 min | Bonus: Ask Copilot to improve its own instructions |
| 65–75 min | Version control, team sharing, governance |

## Key Concepts

### What copilot-instructions.md Does

When you create a `.github/copilot-instructions.md` file in a repository, GitHub Copilot reads it automatically. Every Copilot Chat response in that repository is influenced by these instructions. You're setting the context once, and it applies to every prompt your team asks.

### Where It Lives

```
your-repository/
└── .github/
    └── copilot-instructions.md   ← Place it here
```

### The Five Sections of Great Instructions

1. **Repository Purpose** — What is this repo for?
2. **Audience** — Who uses this? What do they know?
3. **Tone** — Formal/casual, plain/technical, regional conventions
4. **Domain Glossary** — Terms Copilot should know (with definitions)
5. **Example Pairs** — A prompt and the ideal output, so Copilot calibrates

### Domain Glossary Pattern

```markdown
## Glossary

- **ADT** (Admission, Discharge, Transfer): the process of...
- **EMR** (Electronic Medical Record): the digital version of...
- **Prior Authorization**: a requirement that a provider obtain...
```

### Example Pair Pattern

```markdown
## Example Prompts and Expected Outputs

**Prompt:** "Explain prior authorization to a new patient coordinator."
**Expected output:** Plain language, 3 short paragraphs, no acronyms without expansion, reassuring tone.
```

### Version Control for Instructions

Your `copilot-instructions.md` should be maintained like any other important document:
- Make changes via pull requests so team members can review
- Use clear commit messages: "Add telemedicine glossary terms"
- Tag major versions when rolling out to a new team

### Per-Repo vs. Global Instructions

- **Per-repo** (`.github/copilot-instructions.md`): Applies to everyone working in that repository
- **Global personal instructions**: Available in VS Code settings — applies to you across all repos
- Per-repo instructions take precedence when both exist

## Prerequisites

- Module 00 (Foundations) required
- Modules 01–03 recommended

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Write Copilot Instructions for Meridian Health
- `lab/starter/copilot-instructions-draft.md` — Partial instructions file
- `lab/starter/style-guide-excerpt.md` — Meridian Health writing style guide
- `facilitator-guide.md`
- `assessment.md`
