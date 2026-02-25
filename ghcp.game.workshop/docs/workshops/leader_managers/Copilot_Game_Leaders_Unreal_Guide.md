
# GitHub Copilot for Game Industry Leaders (**Unreal/C++ Focus**)

> **Audience:** Directors, Managers, and Tech Leads overseeing Unreal Engine game teams (gameplay, engine, tools, build/infra, QA/automation)
>
> **How to use this pack:** Present the accompanying **Executive Deck** to leaders while you facilitate from this **detailed Markdown**. All operational details, links, commands, and templates are consolidated here.

---

## Agenda (60 minutes)

**0:00–0:05 — Welcome & Objectives**  
- Who’s in the room  
- Goals: value, governance, standards, measurement, ROI

**0:05–0:20 — Copilot Core Capabilities**  
- Inline & chat generation for **Unreal/C++**  
- Code review assistance, explanations, docs  
- **Custom instruction files** & coding standards

**0:20–0:30 — Team/Org Benefits**  
- Reduce repetitive work  
- Standardize practices  
- Accelerate onboarding/discoverability

**0:30–0:40 — Reporting & Success Measures**  
- **Metrics & Usage APIs**, NDJSON export  
- **Power BI dashboards**  
- Key metrics and survey loop; ROI math

**0:40–0:50 — Best Practices & Implementation**  
- Training plan  
- Usage/review guidelines  
- Monitor usage, feedback  
- Plan for rapid evolution

**0:50–1:00 — Q&A**

---

## 1) What leaders should expect from Copilot in Unreal/C++

- **Where Copilot excels**: boilerplate gameplay patterns, input/state machines, editor & pipeline tooling (Python/C# for tools), test scaffolding, build scripts, UBT/CI glue, shader scaffolds, documentation. 
- **Where human review is mandatory**: core engine loops, threading/async, memory ownership, platform bindings, anti‑cheat, perf‑critical render paths. 
- **IDE coverage**: Visual Studio / VS Code / JetBrains Rider with Copilot chat & inline completions. See setup guidance: [VS Code Copilot setup](https://code.visualstudio.com/docs/copilot/setup), and Microsoft Unreal productivity guidance that also highlights Copilot usage with VS.  
  - VS blog (Unreal Fest): [Modernizing Game Dev with Visual Studio & AI](https://devblogs.microsoft.com/cppblog/visual-studio-at-unreal-fest-seattle-2024/)

---

## 2) Governance & Trust (non‑negotiables)

> Establish these **once** at the Enterprise/Org level and revisit quarterly.

1. **Privacy & data use**  
   - For **Business/Enterprise** plans, GitHub states your **prompts/suggestions are not used to train** the model. Share the **Trust Center FAQ** with Legal/SecOps:  
   https://copilot.github.trust.page/faq

2. **Public code controls & transparency**  
   - Enable **code referencing** so any suggestion that matches public code includes links + license so reviewers can decide to attribute/replace:  
   https://docs.github.com/en/enterprise-cloud@latest/copilot/concepts/completions/code-referencing  
   - Set org policy for **suggestions that match public code** (block or allow-with-references):  
   Org policies: https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-policies  
   Enterprise policies: https://docs.github.com/en/enterprise-cloud@latest/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-enterprise-policies

3. **Usage/Metrics policy**  
   - Admins must **enable Copilot usage metrics** (Enterprise → AI Controls → Copilot → Metrics) to unlock dashboards/APIs and NDJSON exports:  
   Overview: https://docs.github.com/en/copilot/concepts/copilot-metrics  
   Data dictionary: https://docs.github.com/en/enterprise-cloud@latest/copilot/reference/copilot-usage-metrics/copilot-usage-metrics

---

## 3) Non‑negotiable Standards (repository level)

1. **Custom instruction files (required in every repo)**  
   - Repo‑wide: `/.github/copilot-instructions.md`  
   - Path‑specific: `/.github/instructions/*.instructions.md` (e.g., `/Engine/`, `/Rendering/`, `/Gameplay/`, `/Shaders/`, `/Build/`)  
   - Agent instructions: `AGENTS.md` (what the Copilot Coding Agent can/can’t touch; human approval gates).  
   Docs: https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions

2. **PR templates with human‑in‑the‑loop**  
   - Authors: disclose Copilot use, minutes saved, any public code references shown, perf checks.  
   - Reviewers: verify code references, perf + memory + threading rules, tests/benchmarks for hot paths.

3. **Security & compliance checkpoints**  
   - Secrets never inline; follow internal secrets SDK.  
   - Use code referencing signals for any third‑party look‑alikes.

---

## 4) Unreal‑focused starter templates

### A) Repo‑wide instructions (drop in `/.github/copilot-instructions.md`)

```markdown
# Copilot Instructions — Unreal/C++ Game Repo (Repo‑wide)

## Style & Safety
- Follow /Docs/CodingStandards.md and Epic’s Unreal C++ conventions.
- Memory: prefer `TUniquePtr/TSharedPtr` where appropriate; avoid raw ownership in gameplay.
- Threading: no blocking on the game thread; use task graph/async patterns.
- Perf budget: 60/120 fps targets per platform; annotate hot paths and require benchmarks.

## Engine & Gameplay
- Use Gameplay Ability System patterns when applicable; avoid bespoke state machines if GAS fits.
- Prefer subsystem/services patterns for cross‑cutting features.
- Avoid heavy work in tick functions; use events/data‑oriented updates.

## Build/CI
- Document and execute with `AGENTS.md` steps for: UBT configure → build → cook → package.
- Agent must run lint/tests/shader compilation before PR creation.

## Review
- If code referencing shows public matches, add an attribution note or replace with approved libs.
```

### B) Path‑specific rules (example: `/.github/instructions/Rendering.instructions.md`)

```markdown
---
paths:
  - /Source/Project/Rendering/**
---
# Rendering & Shaders
- Prefer platform‑specific shader branches with fallbacks.
- For GPU hot paths, propose SIMD/intrinsics variants but keep a portable baseline.
- Never add blocking calls on render thread.
- Require shader compile checks in CI before proposing edits.
```

### C) Agent guardrails (`AGENTS.md`)

```markdown
# Copilot Coding Agent — Guardrails

## Allowed Tasks
- Generate unit/integration tests for gameplay modules.
- Update build scripts and CI yaml following /Build/Runbooks.md.
- Create boilerplate for new features under /Gameplay/ (no edits under /EngineCore/).

## Required Pre‑checks
- Run clang-tidy/unreal-header-tool and unit tests.
- Run shader compile for changed materials.
- Attach perf microbenchmarks for functions tagged // HOT_PATH.

## Prohibited Areas
- /Source/EngineCore/**, /Source/Rendering/** (except docs), /Platform/** bindings, anti‑cheat.

## Human Approval Gates
- Any PR touching HOT_PATH or Rendering must request reviewers @RenderingOwners and @PerfOwners.
```

### D) PR template snippet (`/.github/pull_request_template.md`)

```markdown
### Copilot & Compliance
- [ ] Used Copilot? If yes, approx. minutes saved: __
- [ ] Did code referencing appear? If yes, link to attribution decision/comment
- [ ] Tests added/updated
- [ ] Perf/Memory/Threading considerations addressed (esp. HOT_PATH)
```

---

## 5) Measuring success

### Metrics & APIs
- **Copilot Metrics API** (100‑day aggregates; acceptance rate, active/engaged users, language/IDE):  
  https://docs.github.com/en/enterprise-cloud@latest/rest/copilot/copilot-metrics
- **Copilot Usage Metrics APIs** (enterprise/org/user; daily NDJSON links and exports):  
  https://docs.github.com/rest/copilot/copilot-usage-metrics

**Examples**

```bash
# Enterprise metrics (100 days max window)
curl -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer $TOKEN_WITH_read:enterprise_or_manage_billing:copilot" \
  "https://api.github.com/enterprises/ENTERPRISE_SLUG/copilot/metrics?since=2025-12-01T00:00:00Z&until=2026-01-28T00:00:00Z"

# Daily usage report (signed download links for NDJSON files)
curl -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer $TOKEN" \
  "https://api.github.com/enterprises/ENTERPRISE_SLUG/copilot/usage?day=2026-01-28"
```

### Dashboards
- **Microsoft Copilot Metrics Dashboard (solution accelerator)**:  
  https://github.com/microsoft/copilot-metrics-dashboard
- **Power BI Metrics Viewer template**:  
  https://github.com/github-copilot-resources/copilot-metrics-viewer-power-bi

### Qualitative feedback loop (surveys)
- Deploy **Copilot Survey Engine** and capture **time‑saved % per PR** into Azure SQL or a repo branch:  
  https://github.com/github/copilot-survey-engine

### Key metrics to review weekly
- Completion **acceptance rate**, **daily/weekly active users**, **agent adoption**, **requests per mode (Ask/Edit/Agent)**, **lines of code changed with AI**, **language/IDE mix**.  
  See data dictionary: https://docs.github.com/en/enterprise-cloud@latest/copilot/reference/copilot-usage-metrics/copilot-usage-metrics

---

## 6) ROI: break‑even minutes per developer

> Use fully loaded hourly cost to compute break‑even minutes.

**Formula**  
`Break-even minutes per month = LicenseCostPerMonth / (FullyLoadedCostPerMinute)`

**Illustration** (replace rates with your finance numbers):  
- $100/hour → ~$1.67/min  
  - Copilot **Business ($19)** → **~11.4 minutes**/month  
  - Copilot **Enterprise ($39)** → **~23.4 minutes**/month  
Even **0.5–1.0 minute/day** saves enough to offset licenses.

---

## 7) Implementation Playbook

**Week 0 — Prepare**  
- Pick 1–2 pilot teams (e.g., Unreal gameplay & tools).  
- Enable **usage metrics** in Enterprise AI Controls; stand up Power BI dashboard; deploy Survey Engine.

**Week 1 — Train & baseline**  
- Run 101/201 enablement with **Unreal/C++ prompts and labs**.  
- Merge **instruction files** + **AGENTS.md**; add PR template checkboxes.

**Weeks 2–4 — Practice & measure**  
- Use Copilot for tests, tools, and gameplay boilerplate.  
- Weekly retro: acceptance rate, activation, agent use, minutes saved.

**Week 5+ — Scale**  
- Onboard more studios; quarterly refresh of policies and instruction files.

---

## 8) FAQs you’ll get from executives

- **Is our code used to train Copilot?** No for Business/Enterprise plans; see Trust Center FAQ.  
- **How do we manage IP risk?** Enable **code referencing** and choose the public-code policy (block or allow with references).  
- **What proof will we show?** Power BI from **Metrics/Usage APIs**, plus PR‑level time‑saved surveys and roll‑up ROI.

---

## References
- Copilot Trust Center FAQ — https://copilot.github.trust.page/faq  
- Code referencing — https://docs.github.com/en/enterprise-cloud@latest/copilot/concepts/completions/code-referencing  
- Org policies — https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-policies  
- Enterprise policies — https://docs.github.com/en/enterprise-cloud@latest/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-enterprise-policies  
- Copilot usage metrics (concepts) — https://docs.github.com/en/copilot/concepts/copilot-metrics  
- Usage metrics data dictionary — https://docs.github.com/en/enterprise-cloud@latest/copilot/reference/copilot-usage-metrics/copilot-usage-metrics  
- REST: Copilot metrics — https://docs.github.com/en/enterprise-cloud@latest/rest/copilot/copilot-metrics  
- REST: Copilot usage metrics — https://docs.github.com/rest/copilot/copilot-usage-metrics  
- Microsoft Copilot Metrics Dashboard — https://github.com/microsoft/copilot-metrics-dashboard  
- Power BI Metrics Viewer — https://github.com/github-copilot-resources/copilot-metrics-viewer-power-bi  
- Copilot Survey Engine — https://github.com/github/copilot-survey-engine  
- Visual Studio & Unreal — https://devblogs.microsoft.com/cppblog/visual-studio-at-unreal-fest-seattle-2024/  
- VS Code setup — https://code.visualstudio.com/docs/copilot/setup  
- Custom instruction files — https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions

