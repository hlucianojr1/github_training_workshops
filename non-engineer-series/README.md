# GitHub Copilot for Non-Engineers: A Complete Training Series

This series teaches non-technical roles — Product Managers, Business Analysts, Designers, Marketers, HR, Finance, and Ops professionals — how to unlock GitHub Copilot in their day-to-day work. No coding background required.

## Module Catalog

| # | Module | Duration | Audience | Format |
|---|--------|----------|----------|--------|
| 00 | Foundations: What Copilot Is (and Isn't) | 60 min | All roles | Lecture + Demo |
| 01 | Writing Better Docs | 90 min | Technical Writers, PMs | Workshop |
| 02 | User Stories & Backlogs | 90 min | PMs, BAs, Scrum Masters | Workshop |
| 03 | Templates for Every Occasion | 75 min | Marketing, HR, Ops | Workshop |
| 04 | SQL Without Fear | 120 min | BAs, Finance, Analysts | Workshop |
| 05 | Spreadsheet Superpowers | 75 min | Finance, Ops, PMO | Workshop |
| 06 | Light Python for Analysts | 150 min | BAs, Data-adjacent | Hands-on Lab |
| 07 | HTML/CSS Prototyping | 120 min | UX/UI Designers, PMs | Workshop |
| 08 | Design Tokens & Component Specs | 60 min | UX/UI Designers | Workshop |
| 09 | GitHub Issues, PRs & Projects | 90 min | PMs, PMMs, Scrum Masters | Workshop |
| 10 | YAML & GitHub Actions | 120 min | Ops, DevOps-adjacent, IT | Workshop |
| 11 | Markdown Mastery | 60 min | All roles | Workshop |
| 12 | Agent Mode for Non-Engineers | 120 min | All (intermediate) | Workshop |
| 13 | Custom Instructions & Copilot Setup | 75 min | Power users | Workshop |

## Learning Paths by Role

| Role | Path File | Description |
|------|-----------|-------------|
| Product Manager | [learning-paths/product-manager.md](learning-paths/product-manager.md) | Backlog, docs, projects, agent mode |
| Business Analyst | [learning-paths/business-analyst.md](learning-paths/business-analyst.md) | SQL, Python, user stories, data |
| UX/UI Designer | [learning-paths/designer.md](learning-paths/designer.md) | HTML/CSS, design tokens, Markdown |
| Marketing | [learning-paths/marketing.md](learning-paths/marketing.md) | Templates, docs, content creation |
| HR / Operations | [learning-paths/hr-ops.md](learning-paths/hr-ops.md) | Templates, workflows, Markdown |
| Finance | [learning-paths/finance.md](learning-paths/finance.md) | SQL, spreadsheets, Python |

## How to Use This Series

**Self-paced:** Work through modules in the order of your learning path. Each module is standalone. Start with Module 00 regardless of path.

**Facilitated:** Follow the facilitator guide in each module folder. Workshops run best with 6–20 participants.

**Prerequisites:** A GitHub account with Copilot access is all you need. No coding experience required.

## Quick Start for Facilitators

1. Clone this repository
2. Open the module folder you want to run
3. Read `facilitator-guide.md` before the session
4. Share `lab/README.md` with participants
5. Use `slides/outline.md` for your deck

## Repository Structure

```
non-engineer-series/
├── README.md                          ← You are here
├── .github/
│   ├── copilot-instructions.md        ← Repo-scoped Copilot config
│   └── agents/                        ← 8 AI agent definitions
├── module-00-foundations/
│   ├── README.md
│   ├── slides/outline.md
│   ├── lab/README.md
│   ├── lab/prompt-cheat-sheet.md
│   ├── facilitator-guide.md
│   └── assessment.md
├── module-01-docs/ ... module-13-custom-instructions/
│   ├── README.md
│   ├── slides/outline.md
│   ├── lab/README.md
│   ├── lab/starter/                   ← Intentionally incomplete starter files
│   ├── facilitator-guide.md
│   └── assessment.md
├── prompt-catalog/
│   └── README.md                      ← 80+ curated prompts indexed by module
└── learning-paths/
    ├── product-manager.md
    ├── business-analyst.md
    ├── designer.md
    ├── marketing.md
    ├── hr-ops.md
    └── finance.md
```
