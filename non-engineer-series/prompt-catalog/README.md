# Copilot Prompt Catalog

A curated collection of 80+ prompts from the Non-Engineer Training Series, organized by module. Each prompt is ready to use — copy, adapt, and make it yours.

## How to Use This Catalog

1. Find the module that matches your current task
2. Copy the prompt and replace the bracketed placeholders
3. Add your Role + Context if not already in the prompt
4. Refine with follow-up prompts until the output is right

**Prompt anatomy reminder:** Role + Context + Task + Format = great output

---

## Module 00 — Foundations

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Explain what the repository at [URL] does in plain language for a non-technical audience. Use 3 bullet points." | Understand a project quickly | All | 3 bullets | Add "for a [role]" to tune the vocabulary |
| "Summarize the README at [URL] in 5 bullet points. Each bullet should be one sentence. Write for a [role] who needs to understand what this project is." | Summarize documentation | All | 5 bullets | Specify the audience to change reading level |
| "As a [role], write a [document type] about [topic]. Keep it under [word count] words. Use a [tone] tone." | Generate any professional content | All | Paragraphs | Start broad, then refine |
| "Explain [concept or term] in plain language for someone with no technical background." | Learn a new concept | All | Explanation | Follow up: "Give me an analogy" |
| "What is the difference between [A] and [B]? Use a table if it helps." | Compare options | All | Table | Works great for tool comparisons |
| "Rewrite this paragraph in a more [formal/concise/friendly] tone: [paste paragraph]" | Tone adjustment | All | Rewritten text | Try multiple tone adjectives |

---

## Module 01 — Writing Better Docs

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "`#file:product-spec.md` Write a Features section for the README based on the features listed in this spec." | Generate from spec | Tech Writer, PM | Bullet list | Always use #file for grounded output |
| "`#file:product-spec.md` Generate a FAQ with 8 questions and answers for this product. Focus on questions from new users." | FAQ generation | Tech Writer, PM | Q&A pairs | Specify the user persona for relevant questions |
| "Write a Getting Started guide for [product] in 5 numbered steps. Start each step with an action verb." | Getting started guide | Tech Writer | Numbered steps | Ask Copilot to add time estimates per step |
| "Rewrite this section in the same tone as the existing content above — friendly, direct, and jargon-free." | Tone matching | Tech Writer | Rewritten text | Paste the "gold standard" section as context |
| "Make the second paragraph shorter without losing the key information." | Concision | All | Shorter text | Be specific: "reduce to 2 sentences" |
| "Write a CHANGELOG entry for [product] version [X]. Include: 2 new features, 1 improvement, 1 bug fix. Use Keep a Changelog format." | Changelog | Tech Writer, PM | CHANGELOG block | Provide the actual feature names for accuracy |
| "`#file:README.md` Review this document for sections that are inconsistent in tone or depth. Identify the 2 weakest sections." | Doc review | Tech Writer | Analysis | Use after generating to catch gaps |
| "Write an API reference entry for the [endpoint name] endpoint. Include: method, path, description, parameters, response format, and an example." | API docs | Tech Writer | Reference doc | Great for non-engineers who inherited API docs |

---

## Module 02 — User Stories & Backlogs

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "`#file:prd-snippet.md` Based on this PRD, generate 10 user stories in the format: As a [role], I want to [action], so that [benefit]." | Backlog generation | PM, BA | Story list | Use real persona names from the PRD |
| "Take this user story: [story] and add 3 Given/When/Then acceptance criteria. Be specific and testable." | Acceptance criteria | PM, BA, Scrum Master | BDD criteria | Ask for edge cases in a follow-up |
| "This user story is too large for one sprint: [story]. Break it into 5 smaller sub-tasks completable in < 1 day each." | Story decomposition | PM, Scrum Master | Checkbox list | Review: each task must be independently deliverable |
| "Generate an epic-level story for the [feature] capability. Then list 5 user stories under it." | Epic generation | PM | Epic + stories | Ask Copilot to add a success metric to the epic |
| "Format this user story as a GitHub Issue with: title, story, acceptance criteria, labels for priority and effort." | Issue formatting | PM, BA | GitHub Issue markdown | Use the output directly in GitHub |
| "Review these 10 user stories and identify which ones are missing clear business value (empty 'so that' clauses)." | Story review | PM | Analysis | Ask for rewrites of the flagged stories |
| "Write 3 user stories for the edge case where [unusual scenario]. Use the same personas as the main backlog." | Edge case coverage | BA | Story list | Edge cases are often missed in initial generation |

---

## Module 03 — Templates

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Write a product launch announcement email for [product] to existing customers. New features: [list]. Tone: excited but professional. Under 300 words." | Launch email | Marketing, PMM | Email | Generate 3 subject line options too |
| "Create a job description for [role] at a [size/type] company. Include: about us, role summary, responsibilities (6 bullets), requirements (5 bullets), benefits (4 bullets)." | Job description | HR | JD | Add "avoid jargon" for better candidate experience |
| "Write a weekly status report template for a [team type]. Include sections for: summary, completed, in-progress, blockers, next week, metrics table." | Status report | PM, Ops | Template | Add "with placeholder variables in [brackets]" |
| "Make this [content] more [adjective] while keeping [constraint]." | Tone refinement | All | Refined text | Use specific adjectives: "empathetic", "direct", "conversational" |
| "Add placeholder variables in [SQUARE BRACKETS] wherever this template needs customization." | Templatize | All | Template with vars | Run this on any generated content to make it reusable |
| "Using this template: [paste template], fill it in with these facts: [paste facts]. Keep the structure." | Fill from facts | All | Completed doc | The fastest way to produce a first draft |

---

## Module 04 — SQL Without Fear

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Write SQLite SQL to calculate total MRR by plan tier for active customers (churn_date is NULL). Show: plan, total_mrr." | Revenue analysis | BA, Finance | SQL query | Always specify the database type (SQLite, PostgreSQL, etc.) |
| "Write SQL to find all customers whose churn_date is within the last 90 days. Show: name, plan, mrr, churn_date." | Churn analysis | BA, Finance | SQL query | Add "ORDER BY churn_date DESC" for most recent first |
| "Write SQL to join [table1] and [table2] on [key] and calculate [metric] grouped by [dimension]." | Joined aggregation | BA, Analyst | SQL query | The most reusable SQL pattern — memorize this |
| "Explain this SQL query in plain English, line by line: [paste query]" | SQL learning | All | Explanation | Add "for someone who has never written SQL" |
| "My SQL query returned this error: [error]. Here is the query: [paste]. What is wrong and how do I fix it?" | Debug SQL | All | Fixed query | Always paste the exact error message |
| "Optimize this SQL query. It currently takes [time] to run on [row count] rows: [paste query]" | Query optimization | BA, Analyst | Optimized query | Provide context: what database, what indexes exist |
| "Write SQL to calculate [metric] as a percentage. The formula is: ([numerator query] / [denominator query]) * 100." | Percentage metrics | Finance, BA | SQL query | Ask Copilot to add ROUND() automatically |
| "Write SQL to create a monthly trend report for [metric] across [time period]. Show: month, metric value, month-over-month change." | Trend analysis | Finance, BA | SQL query | Great for board reports and executive dashboards |

---

## Module 05 — Spreadsheet Superpowers

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Write an XLOOKUP formula to find [value] from column [A] in a lookup table where [B] has keys and [C] has values. Return '[fallback]' if not found." | XLOOKUP | Finance, Ops | Formula | Specify the exact column letters and sheet names |
| "Write a SUMIFS formula to sum column [D] only where column [A] = '[value1]' AND column [B] = '[value2]'." | Multi-condition sum | Finance, Ops | Formula | Works for any number of conditions |
| "Write a nested IF formula to categorize [column] as: [value1] if < [threshold1], [value2] if < [threshold2], else [value3]." | Tiered categorization | Finance | Formula | Add a final ELSE for uncategorized values |
| "My formula [paste formula] returns [error or wrong result]. My column layout is [describe]. What is wrong?" | Formula debugging | All | Fixed formula | Always describe the expected result |
| "Write a Google Apps Script function that loops through all rows and [action] when [condition]." | Spreadsheet automation | Ops, Finance | Apps Script | Ask Copilot to add error handling too |
| "Write an Excel formula to calculate the percentage change between column [A] (old value) and column [B] (new value). Handle division by zero." | Variance calculation | Finance | Formula | Division by zero handling is often forgotten |

---

## Module 06 — Light Python

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Write Python to load [filename.csv] using pandas and print the first 5 rows, the shape, and the column data types." | Load and inspect data | BA, Analyst | Python code | Always start with this before any analysis |
| "Add code to show which columns have null values and how many nulls are in each column." | Data quality check | BA, Analyst | Python code | Follow up: "also show total rows vs non-null rows" |
| "Add code to fill null values in '[column]' with '[value]' and drop rows where '[column]' is null." | Handle nulls | BA, Analyst | Python code | Print the shape before and after to verify |
| "Add code to standardize the '[column]' column so all values are title case." | Data standardization | BA, Analyst | Python code | Works for region, city, name columns |
| "Add code to group by '[column]' and calculate total [metric] and average [metric2] per group. Sort descending by total." | Group and aggregate | BA, Finance | Python code | Add .reset_index() if the output looks odd |
| "Add code to create a bar chart of [metric] by [dimension] using matplotlib. Save as '[filename].png'." | Visualization | BA, Analyst | Python + chart | Add a title, axis labels, and color parameter |
| "My Python script returned this error: [error]. Here is the code: [paste]. What is wrong?" | Debug Python | All | Fixed code | Always paste the full error traceback |

---

## Module 07 — HTML/CSS Prototyping

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "`#file:styles.css` Add a navigation bar with [logo] on left and [N] nav links on right. Use CSS variables from styles.css." | Nav component | Designer, PM | HTML + CSS | Reference the CSS file so variables are used consistently |
| "`#file:styles.css` Add a hero section with [headline], [subheadline], and [N] CTA buttons. Center the text." | Hero section | Designer, PM | HTML + CSS | Describe button style (primary/secondary/outlined) |
| "`#file:styles.css` Add a [N]-column card grid where each card has [icon/image], title, and description." | Feature/card grid | Designer | HTML + CSS | Add hover effects: "add a subtle lift on hover" |
| "Make this layout mobile-first responsive. Stack all sections vertically on screens under 768px." | Responsive design | Designer | CSS media queries | "Mobile-first" produces cleaner CSS than retrofitting |
| "`#file:index.html` Review this HTML for WCAG 2.1 AA accessibility issues. List each issue with line number and fix." | Accessibility audit | Designer, PM | Issue list | Run before every prototype review |
| "Write CSS to create a [component] using these design tokens: [paste variables]. Add hover and focus states." | Styled component | Designer | CSS | Always include focus states for keyboard accessibility |
| "Add CSS custom properties for [design system tokens] and refactor this stylesheet to use them." | CSS refactor | Designer | Refactored CSS | Reduces long-term maintenance significantly |

---

## Module 08 — Design Tokens

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Generate a Style Dictionary–compatible JSON file for a color system with: [describe palette]. Include value and type fields." | Token generation | Designer | JSON | Describe the full palette — Copilot fills in the numbers |
| "Add spacing tokens using a [N]px base unit with these multipliers: [list]. Include a comment showing the pixel value." | Spacing tokens | Designer | JSON | Add a pixel comment for non-engineers reading the file |
| "Add typography tokens for these sizes: [list with px values] and weights: [list]. Use Style Dictionary format." | Typography tokens | Designer | JSON | Ask for line-height tokens too |
| "Document all props for this [Component] component as a markdown table. Include: Prop, Type, Required, Default, Description." | Component docs | Designer | Markdown table | Works with any component description, not just code |
| "List all interactive states for the [Component] component and describe the visual change for each state." | State documentation | Designer | Table | Generates QA test cases as a side effect |

---

## Module 09 — GitHub Projects

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "`#file:feature-brief.md` Generate 5 GitHub Issues from this brief — one per feature. Each has: title, user story, 3 acceptance criteria, labels." | Issue generation | PM | GitHub Issue markdown | Use real feature names from the brief |
| "Write a GitHub bug report issue template in YAML format. Include: summary, steps to reproduce, expected/actual behavior, severity dropdown, environment checkboxes." | Issue template | PM, Ops | YAML | Test in a real repo — YAML is indentation-sensitive |
| "Write a professional GitHub pull request description for [feature]. Include: Summary, Changes Made, Testing Done, Screenshots, Related Issues." | PR description | PM, Tech Writer | PR markdown | Add "for a non-technical reviewer audience" |
| "Write release notes for version [X] of [product]. New features: [list]. Audience: non-technical end users." | Release notes | PM, PMM | Release markdown | Specify audience — developer vs. end-user release notes differ greatly |
| "Explain what this pull request does in 2 sentences for a non-technical stakeholder. Here is the diff summary: [paste]." | PR translation | PM | Summary | Great for weekly stakeholder updates |
| "Write a GitHub milestone description for [milestone name] covering: goal, scope, success criteria, target date." | Milestone setup | PM | Milestone text | Keeps the team aligned on what "done" means |

---

## Module 10 — YAML & GitHub Actions

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Write a GitHub Actions workflow that triggers on [event] and [describes what it does]." | Workflow generation | Ops, IT | YAML | Be specific about the trigger and job steps |
| "Explain this GitHub Actions workflow YAML in plain English, section by section: [paste]." | Workflow understanding | All | Explanation | Follow up: "What would happen if [condition]?" |
| "This GitHub Actions step failed with this log output: [paste]. Here is my YAML: [paste]. What went wrong?" | Workflow debugging | Ops | Fixed YAML | Always paste both the log AND the YAML |
| "Add a step to this workflow that sends a Slack notification when the job [succeeds/fails]. Use the incoming webhook URL stored as a secret named SLACK_WEBHOOK." | Notification step | Ops | YAML step | Never hard-code webhook URLs — always use secrets |
| "Fix the indentation errors in this GitHub Actions YAML: [paste]." | YAML fixing | All | Fixed YAML | YAML indentation errors are the most common mistake |
| "Add an if condition to this workflow step so it only runs when [condition]." | Conditional logic | Ops | YAML | Common condition: `if: github.event.pull_request.merged == true` |

---

## Module 11 — Markdown

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Write a Markdown runbook for [process]. Include: Overview, Prerequisites, Step-by-step instructions, Troubleshooting table, FAQ (5 questions)." | Runbook generation | All | Markdown doc | The most reusable prompt in the series |
| "Create a Mermaid flowchart for this process: [describe steps and decision points]. Use flowchart TD format." | Process diagram | All | Mermaid code | Preview at mermaid.live before committing |
| "Add a Markdown table of contents linking to all H2 sections in this document." | Table of contents | All | TOC | Run this after drafting to add navigation |
| "Convert this bulleted process description into a numbered step-by-step guide where each step starts with an action verb." | Formatting | All | Numbered steps | Works great for transforming meeting notes into SOPs |
| "Write a wiki page for [topic] that a new team member would read on their first day. Keep it under 500 words." | Wiki page | All | Wiki doc | Great for team onboarding documentation |

---

## Module 12 — Agent Mode

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Review [file path] and identify all [content type] that are missing or incomplete." | Gap analysis | PM, BA, Writer | Analysis list | Be specific about what "missing" means |
| "Based on your analysis of [file], generate [output type] for each gap you identified." | Gap filling | PM, BA | Generated content | Always review before accepting — agent can be creative |
| "Load and describe [data file]. How many rows, what columns, what date range, and what are the unique values in [column]?" | Data profiling | BA, Analyst | Description | Good first step before any agentic data task |
| "Review [content] for consistency issues. Flag any sections that contradict each other or use different terminology." | Consistency check | PM, Writer | Issue list | Especially useful for large documents |
| "For each item in [list], generate [output]. Format all results as [format]. Stop and confirm before proceeding if you find more than 10 items." | Batch generation | PM, BA | Batch output | The "stop and confirm" guard is important for large runs |
| "You are helping me analyze [topic]. First, explain your plan before starting. I will approve the plan before you proceed." | Controlled agent | All | Plan + output | Always review the plan before approving action |

---

## Module 13 — Custom Instructions

| Prompt | Use Case | Best Role | Output Format | Pro Tip |
|--------|----------|-----------|--------------|---------|
| "Write a copilot-instructions.md file for a [team/company type] repository. Include: purpose, audience, tone, glossary (10 terms), formatting preferences." | Instructions generation | Team Leads | Instructions file | Start with this and refine — easier than from scratch |
| "Add a domain glossary section with 10 terms for [industry/domain]. Each term should have a 1–2 sentence plain-language definition." | Glossary creation | All | Glossary section | Use your actual jargon — Copilot knows most industries |
| "Rewrite this copilot-instructions.md tone section to match this writing style example: [paste example]." | Style adaptation | Team Leads | Updated section | Paste a high-quality example of your team's writing |
| "`#file:copilot-instructions.md` Review these instructions. What is missing that would make Copilot more useful for [role]?" | Instructions review | Team Leads | Gap list | Great way to continuously improve your setup |
| "Add 3 example prompt-output pairs to this copilot-instructions.md. Show: the prompt, the expected tone, and the expected format." | Example pairs | Team Leads | Example section | The example pairs section has the highest impact on quality |

---

## Prompt Patterns Reference

### 8 Reusable Templates

**1. Role + Task**
> "As a [role], write a [document type] for [subject] that [specific requirement]."

**2. Summarize for Audience**
> "Summarize [content or URL] in [N] bullet points for [audience] who [context about their knowledge level]."

**3. Generate from Spec**
> "`#file:[spec-file]` Based on this [spec/PRD/brief], generate [output type]. Focus on [aspect]. Format as [format]."

**4. Improve and Refine**
> "Make this [content] more [adjective: concise/formal/empathetic/specific] while keeping [constraint: the key message / all technical details / under 200 words]."

**5. Debug**
> "This [SQL/formula/code/YAML] returns [error or wrong result]. Here is the [content]: [paste]. What is wrong and how do I fix it?"

**6. Convert Format**
> "Convert this [input format: bullet list / paragraph / table] into [output format: numbered steps / JSON / markdown table] while preserving all information."

**7. Fill the Gap**
> "This [document] is missing a [section name]. Write it based on the existing content and this context: [paste context]. Match the existing tone."

**8. Match Tone**
> "Rewrite this [content] in the same tone and style as this example: [paste example]. Keep the same information but adjust vocabulary and sentence structure."
