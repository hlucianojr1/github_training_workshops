# Copilot Instructions for Non-Engineer Training Series

## Repository Purpose

This repository contains training materials for non-technical professionals learning to use GitHub Copilot. All content must be accessible, practical, and directly applicable to everyday work tasks.

## Audience

This repository serves:
- **Product Managers** — backlog management, documentation, stakeholder comms
- **Business Analysts** — data queries, user stories, process docs
- **UX/UI Designers** — prototyping, design tokens, specs
- **Marketers** — templates, campaign briefs, content creation
- **HR & Operations** — job descriptions, runbooks, workflows
- **Finance** — data analysis, reports, spreadsheet automation

## Tone & Language Standards

- Use **plain language** at all times — grade 10 reading level target
- Define every acronym on first use: "GitHub Actions (a CI/CD automation tool)"
- Avoid jargon: say "code file" not "source file"; "run" not "execute"
- Use active voice: "Copilot generates…" not "A generation is performed…"
- Address the reader as "you" — not "the user" or "participants"
- Limit sentences to 25 words or fewer when possible
- Use bullet lists for steps, numbered lists for sequences

## Content Standards

- Every concept must include a real-world example relevant to a non-engineer role
- Every lab step must include the exact Copilot prompt to use
- Every prompt must include the expected output format or description
- Link to prerequisites at the top of every lab and module README
- Include a reflection question at the end of every lab task

## Formatting Rules

- Use H2 (`##`) for main sections, H3 (`###`) for subsections
- Use tables for comparisons, reference data, and structured content
- Keep paragraphs to 3–5 sentences maximum
- Code blocks must include the language identifier: ```sql, ```json, ```yaml
- Slide outlines use `---` as slide separators

## Security & Privacy

- Never include real names, real email addresses, or real phone numbers in sample data
- Use fictional company names: TaskFlow Pro, MeetingMind, CloudMetrics, Luminary Analytics, Aurora, Meridian Health
- Use fictional people names: Alex Chen, Jordan Rivera, Sam Okafor, Taylor Nguyen
- Never commit credentials, tokens, or API keys — even as examples
- Always include a note when using database examples: "Never run this on a production database"

## Lab File Standards

- Starter files must have intentional gaps (TODOs) that participants complete with Copilot
- Every lab must be completable in a browser (GitHub.com or DB Fiddle) — no local install required unless a Codespace is provided
- Always provide a "What to do if it breaks" section in labs

## Agent Behavior

When generating new module content:
1. Follow the established module structure (README, slides, lab, facilitator-guide, assessment)
2. Match the tone and format of existing modules
3. Include exactly 5 pre-quiz and 5 post-quiz questions per assessment
4. Include one practical challenge per assessment
5. Include speaker notes on every slide
