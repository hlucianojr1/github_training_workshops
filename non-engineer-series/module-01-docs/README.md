# Module 01: Writing Better Docs

**Duration:** 90 minutes | **Audience:** Technical Writers, Product Managers | **Format:** Workshop

## Overview

GitHub Copilot can dramatically accelerate documentation work — from writing READMEs and product FAQs to generating changelogs and API guides. This module teaches you how to use Copilot's repository context to produce docs that are grounded in your actual product, not generic templates.

## Learning Objectives

By the end of this module, you will be able to:

1. Identify the four documentation types (how-to, reference, tutorial, explanation) and when to use each
2. Use `#file:` context to ground Copilot's output in real product specifications
3. Apply a review-refine-own workflow to ensure AI-generated docs reflect your voice
4. Use Copilot to match an existing doc's tone and style
5. Generate a complete product FAQ from a specification document

## Agenda

| Time | Activity |
|------|----------|
| 0–10 min | The documentation problem: why docs fall behind |
| 10–20 min | Doc type taxonomy and when each matters |
| 20–35 min | Demo: Generate a README from a product spec using #file |
| 35–50 min | Demo: Iterative refinement ("make it shorter", "match this tone") |
| 50–80 min | Lab: Complete the TaskFlow Pro product docs |
| 80–90 min | Debrief, responsible use discussion, Q&A |

## Key Concepts

### The Four Documentation Types

| Type | Purpose | Example |
|------|---------|---------|
| **How-to** | Guide to completing a specific task | "How to reset your password" |
| **Reference** | Lookup information | API endpoints, config options |
| **Tutorial** | Learning-oriented walkthrough | "Build your first dashboard" |
| **Explanation** | Background understanding | "Why we use event-driven architecture" |

Knowing which type you're writing helps you give Copilot better instructions.

### The `#file:` Context Trick

In VS Code Copilot Chat, typing `#file:product-spec.md` before your request tells Copilot to read that file. This means your generated docs are based on real content, not Copilot's imagination.

Example:
> `#file:product-spec.md` Write a Features section for the README based on the features listed in this spec.

### The Review-Refine-Own Workflow

1. **Generate** — Get a first draft from Copilot
2. **Review** — Read every sentence. Check for accuracy, tone, completeness
3. **Refine** — Use follow-up prompts: "make the second paragraph shorter", "add a note about security"
4. **Own** — Edit directly until it sounds like you. You are the author; Copilot is a drafting tool

### Brand Voice Prompting

You can tell Copilot to match a specific tone:
> "Rewrite this section in the same tone as the existing content above — friendly, direct, and jargon-free."

Or paste an example of good writing:
> "Here is an example of our writing style: [paste example]. Rewrite the FAQ using this same style."

### Responsible Use

- Always verify facts. Copilot can hallucinate product features that don't exist.
- Never publish AI-generated docs without human review.
- Sensitive documentation (security, legal, compliance) should have extra review steps.

## Prerequisites

- Module 00 (Foundations) recommended

## Lab

See [lab/README.md](lab/README.md) for step-by-step instructions.

## Files

- `slides/outline.md` — Full slide deck with speaker notes
- `lab/README.md` — Complete the TaskFlow Pro Product FAQ
- `lab/starter/README-incomplete.md` — Partial TaskFlow Pro README
- `lab/starter/product-spec.md` — Full product specification
- `facilitator-guide.md` — Trainer notes and demo script
- `assessment.md` — Pre/post quiz and practical challenge
