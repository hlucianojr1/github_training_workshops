# Facilitator Guide: Module 02 — User Stories & Backlogs

## Overview
Participants build a real product backlog for MeetingMind. The "so that" clause gets the most discussion — many participants have never articulated business value explicitly. Success = every participant has 10 user stories with acceptance criteria.

## Pre-Session Checklist
- [ ] Read the MeetingMind PRD so you can answer questions about the product
- [ ] Prepare 2–3 intentionally bad user stories to show as before/after
- [ ] Test the Copilot prompt for story generation
- [ ] Have GitHub Issues creation open as a live demo option

## Session Timing (90 minutes)
| Time | Activity | Notes |
|------|----------|-------|
| 0–10 min | Why story writing bottlenecks teams | Real data: avg 8 min to write one good story |
| 10–20 min | Story anatomy: Role, Goal, Benefit | Bad story → good story live rewrite |
| 20–30 min | Demo: Generate 10 stories from PRD | Run live; compare to what participants expect |
| 30–45 min | Demo: BDD acceptance criteria | Show one story transformed with Given/When/Then |
| 45–80 min | Lab: Build the MeetingMind backlog | Tasks 1–4 |
| 80–90 min | Story review: what makes a great story | Peer review one story per participant |

## Common Questions & Answers
**Q: How detailed should user stories be?**
A: Small enough to complete in one sprint (typically 1–3 days), specific enough that an engineer can start work without asking questions. If it takes more than a day to explain, decompose it.

**Q: What's the difference between a user story and a task?**
A: A user story describes a user need and its business value. A task is a technical implementation step. Stories belong in the product backlog; tasks belong inside stories as subtasks.

**Q: Should acceptance criteria always be Gherkin format?**
A: No — Gherkin is best for features with clear, testable behaviors. For strategic stories, bullet-point criteria work fine. Use whatever the team will actually verify.

**Q: Can Copilot write stories for features we haven't thought of yet?**
A: Yes, and this is often valuable. Try: "What features are commonly missing from [product type] that we haven't mentioned?" as a gap analysis prompt.

**Q: How do I avoid AI-generated stories that are too technical?**
A: Add "Focus on end-user actions, not technical implementation. Do not mention databases, APIs, or code." to your prompt.

## Troubleshooting
| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Stories are too vague | PRD wasn't used as context | Add #file:prd-snippet.md to the prompt |
| Stories missing "so that" | Generic prompt | Explicitly: "Every story must have a non-empty 'so that' clause" |
| Acceptance criteria not testable | Too abstract | Ask: "Rewrite these criteria so each one can be tested with a pass/fail outcome" |
| 10 stories cover same feature | Prompt too narrow | Add "Cover all 5 features in the PRD proportionally" |
