# Lab: Create Aurora Design System Tokens

**Time:** 15 minutes | **Module:** 08 — Design Tokens & Component Spec Docs

## What You'll Build

A complete Style Dictionary–compatible JSON token file for the Aurora Design System — generated with GitHub Copilot from the color palette description.

## Setup

1. Open `lab/starter/color-palette.md` — the Aurora design system description
2. Open `lab/starter/tokens-incomplete.json` — your starting point
3. Open GitHub Copilot Chat

---

## Task 1: Fill In the Primary Color Scale

The `tokens-incomplete.json` has only 4 of 9 primary color stops. Add the missing 5.

**Prompt:**
> "The primary blue color scale in this Style Dictionary JSON is missing stops 200, 300, 400, 600, 700, and 800. Based on color-palette.md, the values are: 200=#BFDBFE, 300=#93C5FD, 400=#60A5FA, 600=#2563EB, 700=#1D4ED8, 800=#1E40AF. Add these to the JSON maintaining the existing structure."

**Paste the updated primary section** into your tokens file.

---

## Task 2: Complete the Semantic Colors

The semantic section has TODO values. Fill them in.

**Prompt:**
> "Complete the semantic color tokens in this Style Dictionary JSON: success=#16A34A, warning=#D97706, error=#DC2626, info=#2563EB. Replace the TODO values with the correct hex values."

---

## Task 3: Generate Spacing Tokens

**Prompt:**
> "Generate a Style Dictionary spacing section using a 4px base. Token names: spacing.0.5 through spacing.16 using these multipliers: 0.5, 1, 1.5, 2, 3, 4, 6, 8, 12, 16. Each token has value (in px) and type: 'spacing'. Add a comment field showing the pixel value calculation."

**Add this section** to your JSON after the color section.

---

## Task 4: Generate Typography Tokens

**Prompt:**
> "Generate Style Dictionary typography tokens. Font sizes: xs=12px, sm=14px, base=16px, lg=18px, xl=20px, 2xl=24px, 3xl=30px, 4xl=36px. Font weights: regular=400, medium=500, semibold=600, bold=700. Use value and type fields. Type should be 'fontSizes' for sizes and 'fontWeights' for weights."

---

## Task 5: Validate Your JSON

1. Copy your complete tokens JSON
2. Go to [jsonlint.com](https://jsonlint.com)
3. Paste and click "Validate JSON"
4. If there's an error: paste the error message to Copilot with "Fix this JSON syntax error: [error]"

---

## Bonus: Document a Component

**Prompt:**
> "Write a markdown table documenting the props for a React Button component with these props: variant ('primary'|'secondary'|'ghost', default 'primary'), size ('sm'|'md'|'lg', default 'md'), disabled (boolean, default false), loading (boolean, default false), onClick (function, required), children (ReactNode, required). Columns: Prop, Type, Required, Default, Description."

---

## Reflection

- How long would it take to write this JSON manually?
- What workflow would you use to share these tokens with your engineering team?
- What token categories are missing that your design system needs?
