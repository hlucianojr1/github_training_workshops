# Lab: Build the Luminary Analytics Landing Page

**Time:** 30 minutes | **Module:** 07 — HTML/CSS Prototyping

## What You'll Build

A complete, responsive landing page for Luminary Analytics — including navigation, hero, features, pricing, and footer — built step-by-step with Copilot.

## Setup

1. Open `lab/starter/index.html` and `lab/starter/styles.css` in VS Code
2. Open Copilot Chat sidebar
3. Install the "Live Preview" extension if available (lets you preview in the browser)

---

## Task 1: Build the Navigation Bar

**Step 1:** In Copilot Chat, type:

> `#file:styles.css` `#file:index.html` Add a navigation bar to this HTML file. It should have the Luminary Analytics logo text on the left and three nav links on the right: Features, Pricing, Get Started. Use the CSS variables from styles.css. Style the 'Get Started' link as a button.

**Step 2:** Replace the navigation TODO comment with the generated HTML.

**Step 3:** Add the generated CSS to `styles.css`.

**Expected result:** A clean nav bar with logo and 3 links.

---

## Task 2: Build the Hero Section

**Prompt:**
> `#file:styles.css` Add a hero section after the nav. Include: a large headline ("Insights That Drive Decisions"), a subheadline (one sentence about analytics for fast-moving teams), and two side-by-side buttons: "Start Free Trial" (primary, using --color-primary) and "Watch Demo" (outlined secondary). Center the text. Add a light background using --color-neutral-100.

**Replace** the hero TODO comment with the result.

---

## Task 3: Build the Features Section

**Prompt:**
> `#file:styles.css` Add a features section with 3 cards in a row. Each card has: an emoji icon, a feature title, and a 2-sentence description. Features: 📊 Real-time Dashboards — "See your metrics update as they happen. No more waiting for daily exports.", 🔮 Predictive Analytics — "Forecast trends before they happen. Let AI surface what matters next.", 👥 Team Collaboration — "Share dashboards and annotations instantly. Align your team on the same numbers." Use --border-radius and --shadow-sm for card styling.

---

## Task 4: Build the Pricing Section

**Prompt:**
> `#file:styles.css` Add a pricing section with 3 tiers side by side: Starter ($29/month — 1 user, 5 dashboards, email support), Growth ($79/month — 10 users, unlimited dashboards, Slack integration, priority support), Enterprise (Custom pricing — unlimited users, SSO, dedicated CSM, SLA). Highlight the Growth card as "Most Popular" with a border in --color-primary. Each card has a CTA button.

---

## Task 5: Make It Responsive

**Prompt:**
> `#file:styles.css` Add CSS media queries to make this layout mobile-first responsive. On screens under 768px: stack the features cards vertically, stack the pricing cards vertically, hide the nav links and show a hamburger menu placeholder, reduce the hero headline font size. Use --color-primary for the hamburger icon.

---

## Task 6: Accessibility Audit

**Prompt:**
> `#file:index.html` Review this HTML for WCAG 2.1 AA accessibility issues. Check for: images without alt text, missing form labels, insufficient color contrast for text, missing landmark roles (header, main, footer), and any interactive elements not reachable by keyboard. List each issue with the line number and a suggested fix.

**Review** the suggestions and apply at least 2 fixes.

---

## Task 7: Publish to GitHub Pages

1. Commit all changes to your repository
2. Go to your repository on GitHub.com
3. Click **Settings** → **Pages** (in the left sidebar)
4. Under "Source": select **Deploy from a branch**
5. Choose branch **main**, folder **/ (root)** → click Save
6. Wait 2 minutes, then visit `https://[your-username].github.io/[repo-name]/lab/starter/`

---

## Reflection

- How long would this have taken to write from scratch?
- Which section needed the most manual editing?
- What would you ask Copilot to add next?
