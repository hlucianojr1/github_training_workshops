# Module 02: User Stories & Backlogs

**Duration:** 90 minutes | **Audience:** Product Managers, Business Analysts, Scrum Masters | **Format:** Workshop

## Overview

User stories are the backbone of product development — but writing them well is time-consuming. This module shows you how GitHub Copilot can generate, refine, and decompose user stories and acceptance criteria from simple product descriptions, so you can spend more time validating and prioritizing instead of writing.

## Learning Objectives

By the end of this module, you will be able to:

1. Use the Role/Goal/Benefit story format to guide Copilot's output
2. Generate a full product backlog from a PRD or feature brief
3. Add Given/When/Then (BDD) acceptance criteria to any user story
4. Decompose a large story into smaller, sprint-ready sub-tasks
5. Export stories as GitHub Issue templates

## Agenda

| Time | Activity |
|------|----------|
| 0–10 min | Why story writing is a bottleneck |
| 10–20 min | Story anatomy: Role, Goal, Benefit |
| 20–30 min | Demo: Generate 10 stories from a PRD snippet |
| 30–45 min | Demo: Add BDD acceptance criteria |
| 45–80 min | Lab: Build the MeetingMind backlog |
| 80–90 min | Debrief: Story quality review, Q&A |

## Key Concepts

### User Story Anatomy

A user story has three parts:

> **As a** [who], **I want to** [what], **so that** [why/value].

The "so that" clause is the most important — and the most often skipped. It forces you to articulate value, not just functionality.

### Copilot Prompt for Story Generation

> "Based on this product requirements document, generate 10 user stories in the format: 'As a [role], I want to [action], so that [benefit].' Focus on end-user actions, not technical implementation."

### Gherkin / BDD Acceptance Criteria

Gherkin (Behavior-Driven Development) format structures acceptance criteria as:
- **Given** [starting state]
- **When** [action the user takes]
- **Then** [expected outcome]

Example:
> Given I am logged in, When I click "Export CSV", Then a CSV file downloads within 5 seconds.

This format makes stories directly testable.

### Story Decomposition

When a story is too large for one sprint, decompose it:
> "Break this user story into 5 smaller sub-tasks, each completable in less than a day of work."

### GitHub Issues Export

Copilot can format stories directly as GitHub Issue markdown:
> "Format this user story as a GitHub Issue with: title, user story, acceptance criteria (Given/When/Then), and labels for priority and effort."

## Prerequisites

- Module 00 (Foundations) recommended

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Build the MeetingMind Backlog
- `lab/starter/prd-snippet.md` — MeetingMind product requirements document
- `facilitator-guide.md`
- `assessment.md`
