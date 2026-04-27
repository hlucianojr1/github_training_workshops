# Module 08: Design Tokens & Component Spec Docs

**Duration:** 60 minutes | **Audience:** UX/UI Designers | **Format:** Workshop

## Overview

Design tokens are the single source of truth for your design system — the named values that store colors, spacing, typography, and other visual decisions. This module teaches you to generate, manage, and document design tokens using GitHub Copilot, bridging the gap between Figma and code.

## Learning Objectives

By the end of this module, you will be able to:

1. Explain what design tokens are and why they matter for design-to-dev handoff
2. Use Copilot to generate a Style Dictionary–compatible JSON token file
3. Apply consistent token naming conventions (color, spacing, typography)
4. Use Copilot to document component props and behavior specs
5. Version-control design tokens alongside code in GitHub

## Agenda

| Time | Activity |
|------|----------|
| 0–10 min | The design token problem: 14 different blues in production |
| 10–20 min | Demo: Generate color tokens from a Figma palette description |
| 20–30 min | Demo: Generate spacing and typography tokens |
| 30–45 min | Lab: Create Aurora design system tokens |
| 45–55 min | Demo: Document component props with Copilot |
| 55–60 min | Debrief, version control for tokens |

## Key Concepts

### What Are Design Tokens?

Design tokens are named key-value pairs that represent design decisions. Instead of hard-coding `#2563EB` everywhere, you define `color.primary.500 = #2563EB`. When you need to update the brand color, you change it in one place and it updates everywhere.

### Token Naming Convention

Tokens follow a three-part hierarchy: **category.variant.scale**

- `color.primary.500` — color, primary variant, 500 on the scale
- `spacing.4` — spacing, 4-unit value (16px if base is 4px)
- `typography.size.lg` — typography, size property, large variant

### Style Dictionary Format

Style Dictionary (by Amazon) is the standard open-source token tool. It reads a JSON file and can output CSS variables, SCSS, Swift, or Kotlin. Copilot generates valid Style Dictionary JSON instantly:

```json
{
  "color": {
    "primary": {
      "500": { "value": "#2563EB", "type": "color" }
    }
  }
}
```

### Copilot Prompt for Token Generation

> "Generate a Style Dictionary–compatible JSON file for a design system with a primary blue scale from #EFF6FF (50) to #1E3A8A (900) in 9 steps. Add semantic tokens for success (#16A34A), warning (#D97706), error (#DC2626), and info (#2563EB)."

### Component Prop Documentation

> "Document all props for a React Button component that accepts: variant ('primary' | 'secondary'), size ('sm' | 'md' | 'lg'), disabled (boolean), and onClick (function). Format as a markdown table with columns: Prop, Type, Required, Default, Description."

## Prerequisites

- Module 00 (Foundations) recommended
- Module 07 (HTML/CSS Prototyping) helpful but not required

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Create Aurora Design System Tokens
- `lab/starter/color-palette.md` — Aurora design system description
- `lab/starter/tokens-incomplete.json` — Partial token file to complete
- `facilitator-guide.md`
- `assessment.md`
