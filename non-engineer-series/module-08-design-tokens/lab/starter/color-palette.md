# Aurora Design System — Color Palette & Token Specification

This document describes the Aurora Design System visual foundation. Use this as the source of truth when generating design tokens with GitHub Copilot.

---

## Color Palette

### Primary (Blue)

| Token Name | Hex Value | Use |
|-----------|-----------|-----|
| color.primary.50 | #EFF6FF | Backgrounds, hover states |
| color.primary.100 | #DBEAFE | Light backgrounds |
| color.primary.200 | #BFDBFE | Borders, dividers |
| color.primary.300 | #93C5FD | Secondary text on dark |
| color.primary.400 | #60A5FA | Icons, secondary actions |
| color.primary.500 | #3B82F6 | Default primary color |
| color.primary.600 | #2563EB | Hover state |
| color.primary.700 | #1D4ED8 | Active/pressed state |
| color.primary.800 | #1E40AF | Dark backgrounds |
| color.primary.900 | #1E3A8A | Darkest — text on light |

### Secondary (Violet)

| Token Name | Hex Value |
|-----------|-----------|
| color.secondary.50 | #F5F3FF |
| color.secondary.100 | #EDE9FE |
| color.secondary.200 | #DDD6FE |
| color.secondary.300 | #C4B5FD |
| color.secondary.400 | #A78BFA |
| color.secondary.500 | #8B5CF6 |
| color.secondary.600 | #7C3AED |
| color.secondary.700 | #6D28D9 |
| color.secondary.800 | #5B21B6 |
| color.secondary.900 | #4C1D95 |

### Neutral (Gray)

| Token Name | Hex Value |
|-----------|-----------|
| color.neutral.50 | #F9FAFB |
| color.neutral.100 | #F3F4F6 |
| color.neutral.200 | #E5E7EB |
| color.neutral.300 | #D1D5DB |
| color.neutral.400 | #9CA3AF |
| color.neutral.500 | #6B7280 |
| color.neutral.600 | #4B5563 |
| color.neutral.700 | #374151 |
| color.neutral.800 | #1F2937 |
| color.neutral.900 | #111827 |

### Semantic Colors

| Token Name | Hex Value | Use |
|-----------|-----------|-----|
| color.semantic.success | #16A34A | Success states, confirmation |
| color.semantic.warning | #D97706 | Warnings, caution states |
| color.semantic.error | #DC2626 | Errors, destructive actions |
| color.semantic.info | #2563EB | Informational states |

---

## Spacing Scale

Base unit: **4px**

| Token Name | Value | Pixels |
|-----------|-------|--------|
| spacing.0.5 | 0.5 × 4px | 2px |
| spacing.1 | 1 × 4px | 4px |
| spacing.1.5 | 1.5 × 4px | 6px |
| spacing.2 | 2 × 4px | 8px |
| spacing.3 | 3 × 4px | 12px |
| spacing.4 | 4 × 4px | 16px |
| spacing.6 | 6 × 4px | 24px |
| spacing.8 | 8 × 4px | 32px |
| spacing.12 | 12 × 4px | 48px |
| spacing.16 | 16 × 4px | 64px |

---

## Typography Scale

### Font Sizes

| Token Name | Value |
|-----------|-------|
| typography.size.xs | 12px |
| typography.size.sm | 14px |
| typography.size.base | 16px |
| typography.size.lg | 18px |
| typography.size.xl | 20px |
| typography.size.2xl | 24px |
| typography.size.3xl | 30px |
| typography.size.4xl | 36px |

### Font Weights

| Token Name | Value |
|-----------|-------|
| typography.weight.regular | 400 |
| typography.weight.medium | 500 |
| typography.weight.semibold | 600 |
| typography.weight.bold | 700 |

### Line Heights

| Token Name | Value | Use |
|-----------|-------|-----|
| typography.lineHeight.tight | 1.25 | Headings |
| typography.lineHeight.base | 1.5 | Body text |
| typography.lineHeight.relaxed | 1.75 | Long-form reading |
