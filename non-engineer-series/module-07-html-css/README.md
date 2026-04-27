# Module 07: HTML/CSS Prototyping

**Duration:** 120 minutes | **Audience:** UX/UI Designers, Product Managers | **Format:** Workshop

## Overview

Designers and PMs often need to communicate layout and interaction ideas quickly — without waiting for an engineer. GitHub Copilot can generate complete HTML/CSS components from a plain-language description. This module teaches you to build a real landing page prototype, make it responsive, publish it on GitHub Pages, and audit it for accessibility — all in one session.

## Learning Objectives

By the end of this module, you will be able to:

1. Use Copilot to generate HTML components (nav, hero, cards, pricing) from descriptions
2. Apply CSS custom properties to build a consistent visual system
3. Make a page layout responsive using Copilot-generated CSS
4. Ask Copilot to audit HTML for accessibility issues
5. Publish a prototype to GitHub Pages with one setting change

## Agenda

| Time | Activity |
|------|----------|
| 0–10 min | Why prototyping in HTML/CSS beats Figma for dev handoff |
| 10–20 min | Anatomy of an HTML file (for non-engineers) |
| 20–35 min | Demo: Build a nav bar with Copilot |
| 35–50 min | Demo: Hero section + feature cards |
| 50–65 min | Demo: Mobile-responsive layout |
| 65–80 min | Demo: Accessibility audit prompt |
| 80–110 min | Lab: Build the Luminary Analytics landing page |
| 110–120 min | GitHub Pages publish, debrief, Q&A |

## Key Concepts

### HTML Is Just Structure

An HTML file is a text document with tags that describe structure. `<nav>` is a navigation bar. `<section>` is a content area. `<button>` is a button. You don't need to memorize tags — Copilot knows them all.

### CSS Custom Properties (Variables)

Instead of repeating color codes everywhere, CSS variables let you define them once:

```css
:root {
  --color-primary: #2563EB;
  --font-size-base: 16px;
}
```

The starter file already has these defined. You reference them with `var(--color-primary)`.

### The Copilot Component Pattern

For every section:
1. Add a TODO comment in the HTML where the section should go
2. In Copilot Chat: "Add a [section name] to my HTML file using the CSS variables already defined in styles.css"
3. Copilot generates the HTML and the matching CSS
4. Review and paste it in

### Mobile-First Responsive Design

> "Make this layout mobile-first responsive. Stack all sections vertically on screens under 768px wide. Use CSS media queries."

### Accessibility Auditing

> "Review this HTML for WCAG 2.1 AA accessibility issues. Check for: missing alt text, insufficient color contrast, missing form labels, keyboard navigation issues, and ARIA roles."

### GitHub Pages — One-Click Publish

After committing your HTML/CSS to GitHub:
1. Go to your repository Settings
2. Click "Pages" in the left sidebar
3. Under "Source", select "Deploy from a branch"
4. Select `main` branch and `/ (root)`
5. Your page is live at `https://[username].github.io/[repo]/`

## Prerequisites

- Module 00 (Foundations) recommended
- GitHub account
- No HTML/CSS experience required

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Build the Luminary Analytics Landing Page
- `lab/starter/index.html` — HTML boilerplate with TODO comments
- `lab/starter/styles.css` — CSS design system with variables defined
- `facilitator-guide.md`
- `assessment.md`
