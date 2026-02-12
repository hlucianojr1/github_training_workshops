# Workshop 4: Expert
## MCP Servers, Enterprise Management, and Certification

**Duration**: 1 Hour  
**Level**: Expert  
**IDE**: Visual Studio 2022 (17.14+) / Visual Studio 2026 Preview with GitHub Copilot  
**Prerequisites**: Foundational + Intermediate + Advanced Workshops  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)  
**Date**: January 2026

> **Prerequisite:** This workshop assumes you have completed the Foundational, Intermediate, and Advanced Workshops and have Visual Studio 2022 (17.14+) or Visual Studio 2026 Preview installed. GitHub Copilot and Copilot Chat are first-party components of the IDE — no separate extension is required. You must be signed in with a GitHub account that has an active Copilot license.

> **Visual Studio vs. VS Code Feature Parity Note:** Most features in this workshop are fully supported in Visual Studio 2026. Where a capability is **VS Code-only** or works differently in Visual Studio, this document calls it out with a ⚠️ icon and provides the Visual Studio alternative.

---

## Workshop Objectives

By the end of this workshop, participants will:
- Understand Copilot Extensions evolution to MCP Servers
- Configure and use MCP Servers for extended capabilities in Visual Studio 2026
- Implement enterprise policy management for Copilot
- Optimize model selection and cost management
- Leverage the Custom Coding Agent for autonomous multi-file tasks
- Prepare for GitHub Copilot Certification
- Utilize the Copilot Spec Kit for organizational rollout
- Analyze Copilot metrics for team productivity

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:10 | Copilot Extensions → MCP Servers | Presentation |
| 0:10 - 0:22 | MCP Server Configuration in Visual Studio 2026 | Live Demo |
| 0:22 - 0:30 | Custom Coding Agent in Visual Studio 2026 | Live Demo |
| 0:30 - 0:38 | Enterprise Policy Management | Walkthrough |
| 0:38 - 0:46 | Model Selection & Cost Optimization | Analysis |
| 0:46 - 0:50 | GitHub Copilot Certification | Overview |
| 0:50 - 0:55 | Copilot Spec Kit | Tour |
| 0:55 - 1:00 | Copilot Metrics | Dashboard Demo |

---

## Session 1: Copilot Extensions → MCP Servers (10 min)

### Learning Objectives
- Understand the evolution from Extensions to MCP
- Grasp MCP Server architecture in Visual Studio 2026
- Identify use cases for game development

> **Visual Studio 2026 Note:** MCP Server support is built into Visual Studio 2022 (17.14+) and Visual Studio 2026 Preview. Copilot’s Agent mode automatically discovers and invokes MCP tools when they are configured — no separate extension is needed.

### The Evolution

**Copilot Extensions (Legacy):**
- GitHub-hosted plugins
- Limited to GitHub-approved integrations
- Chat-based interaction only

**MCP Servers (Current):**
- Open Model Context Protocol standard
- Self-hosted or third-party servers
- Bidirectional tool invocation
- Works with any MCP-compatible AI

### MCP Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              Visual Studio 2026 (or VS Code)              │
├─────────────────────────────────────────────────────────────┤
│            GitHub Copilot Agent Mode (Host)               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Model Context Protocol                   │   │
│  └──────────────────────────────────────────────────────┘   │
│        │              │              │              │        │
│        ▼              ▼              ▼              ▼        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │  Azure   │  │ Blender  │  │ Database │  │  Custom  │    │
│  │   MCP    │  │   MCP    │  │   MCP    │  │   MCP    │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘    │
│        │              │              │              │        │
│        ▼              ▼              ▼              ▼        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │  Azure   │  │ Blender  │  │ Postgres │  │  Your    │    │
│  │ Services │  │   App    │  │    DB    │  │  Tool    │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### MCP Capabilities

| Capability | Description | Game Dev Example |
|------------|-------------|------------------|
| **Tools** | Functions the AI can invoke | Generate 3D model, query analytics |
| **Resources** | Data sources AI can read | Game design docs, asset database |
| **Prompts** | Reusable prompt templates | Character creation workflow |

### MCP Servers for Game Development

| Server | Purpose | Urban Survivor Use |
|--------|---------|-------------------|
| **Azure MCP** | Cloud deployment | Deploy builds, manage PlayFab |
| **Blender MCP** | 3D modeling | Generate props, export models |
| **GitHub MCP** | Repository actions | Create issues, manage PRs |
| **Database MCP** | Query game data | Player analytics, leaderboards |
| **Docker MCP** | Container management | Game server deployment |
| **Context7 MCP** | Documentation lookup | Godot API references |

### Why MCP Matters for Game Dev

1. **Asset Pipeline Automation**
   - AI triggers Blender to generate models
   - Automatic texture optimization
   - Asset import and validation

2. **Cloud Integration**
   - Deploy game builds to testing
   - Manage multiplayer servers
   - Query player analytics

3. **Documentation Access**
   - Real-time Godot API lookup
   - Project-specific docs
   - Standards compliance checking

---

## Session 2: MCP Server Configuration (12 min)

### Learning Objectives
- Configure MCP servers in Visual Studio 2026
- Connect to Azure MCP for deployment
- Create a custom MCP server for game-specific tools

### MCP Configuration in Visual Studio 2026

Visual Studio 2026 discovers MCP servers from configuration files at the solution root. There are three supported locations:

| Location | Scope | Notes |
|----------|-------|-------|
| `.mcp.json` | Solution root | **Recommended** — Visual Studio native format |
| `.vscode/mcp.json` | Compatibility | Shared with VS Code team members |
| **Tools → Options → GitHub Copilot → MCP Servers** | User-level | Per-machine configuration |

> ⚠️ **VS Code Difference:** VS Code uses `.vscode/settings.json` with a `"mcp"` key. Visual Studio uses a dedicated `.mcp.json` file with the `"mcpServers"` top-level key. Both IDEs can read `.vscode/mcp.json` for cross-IDE compatibility.

**Visual Studio `.mcp.json` Format (Recommended):**

```json
{
    "mcpServers": {
        "azure": {
            "command": "npx",
            "args": ["-y", "@azure/mcp-server"],
            "env": {
                "AZURE_SUBSCRIPTION_ID": "${env:AZURE_SUBSCRIPTION_ID}"
            }
        },
        "context7": {
            "command": "npx",
            "args": ["-y", "@context7/mcp-server"]
        },
        "github": {
            "command": "npx",
            "args": ["-y", "@github/mcp-server"],
            "env": {
                "GITHUB_TOKEN": "${env:GITHUB_TOKEN}"
            }
        },
        "blender": {
            "command": "python",
            "args": ["-m", "blender_mcp.server"],
            "env": {}
        }
    }
}
```

> **Tip:** After adding or editing `.mcp.json`, Visual Studio automatically detects the change. You can verify MCP server status in **Tools → Options → GitHub Copilot → MCP Servers** where each server shows a connection indicator.

### Demo: Azure MCP for Deployment

**Step 1: Install Azure MCP**
```bash
npm install -g @azure/mcp-server
```

**Step 2: Authenticate**
```bash
az login
```

**Step 3: Use in Copilot Chat (Agent Mode)**

In Visual Studio 2026, switch to **Agent mode** in the Copilot Chat window (click the mode dropdown or press **Ctrl+\, Ctrl+C** and select **Agent**). Then type your request naturally:

```
Deploy the latest Urban Survivor build to Azure PlayFab
```

Copilot Agent will automatically discover the Azure MCP server tools and invoke them to complete the task:

```
Copilot Agent → discovers Azure MCP tools → invokes deploy → Azure PlayFab API
```

> ⚠️ **VS Code Difference:** VS Code uses `@azure` chat participant syntax to address MCP servers directly. In Visual Studio 2026, Agent mode automatically selects the appropriate MCP tools based on your request — no `@` prefix needed.

**Available Azure MCP Tools (auto-discovered in Agent mode):**
| Tool | Description |
|------|-------------|
| `deploy` | Deploy to Azure services |
| `azqr` | Security/compliance scan |
| `bestpractices` | Get Azure best practices |
| `resources` | Query Azure resources |
| `logs` | Fetch application logs |

### Demo: Context7 for Documentation

**Fetching Godot Documentation (Agent Mode):**

With the Context7 MCP server configured, simply ask Copilot in Agent mode:

```
User: How do I use NavigationAgent3D's avoidance in Godot 4.3?

Copilot Agent → discovers Context7 MCP → fetches Godot Docs

Context7 Response:
NavigationAgent3D Avoidance (Godot 4.3):
- Enable: agent.avoidance_enabled = true
- Set radius: agent.radius = 0.5
- Set layers: agent.avoidance_layers = 1
- Callback: agent.velocity_computed.connect(_on_velocity_computed)
[code examples follow]
```

> **Tip:** In Visual Studio 2026, you can also see which MCP tools Copilot invoked by expanding the tool call details in the Chat response.

### Creating a Custom MCP Server

**Game-Specific MCP Example:**

```python
# urban_survivor_mcp.py
from mcp import MCPServer, Tool

class UrbanSurvivorMCP(MCPServer):
    
    @Tool(description="Query game balance data from design spreadsheet")
    def get_balance_data(self, category: str) -> dict:
        """Fetch weapon stats, enemy health, etc. from balance sheet."""
        # Connect to Google Sheets or local CSV
        return self.balance_db.query(category)
    
    @Tool(description="Generate item definition from description")
    def create_item(self, name: str, type: str, stats: dict) -> str:
        """Create Item class code from parameters."""
        template = self.load_template("item_template.cpp")
        return template.format(name=name, type=type, **stats)
    
    @Tool(description="Validate asset against art guidelines")
    def validate_asset(self, asset_path: str) -> dict:
        """Check texture sizes, poly counts, naming conventions."""
        return self.asset_validator.check(asset_path)

if __name__ == "__main__":
    server = UrbanSurvivorMCP()
    server.run()
```

**Register in `.mcp.json` (solution root):**
```json
{
    "mcpServers": {
        "urban-survivor": {
            "command": "python",
            "args": ["tools/urban_survivor_mcp.py"]
        }
    }
}
```

**Usage (Agent Mode in Visual Studio 2026):**

Switch to Agent mode in Copilot Chat and ask naturally. Copilot will discover and invoke the Urban Survivor MCP tools automatically:

```
What are the balance stats for the pistol weapon?
Create a new health pack item with 50 HP restore
Validate assets/models/enemy_scavenger.glb
```

> ⚠️ **VS Code Difference:** VS Code allows addressing MCP servers with `@urban-survivor` syntax. Visual Studio 2026 relies on Agent mode’s automatic tool discovery instead.

### Custom Coding Agent + MCP Servers

Visual Studio 2026’s **Copilot Coding Agent** (the autonomous agent that runs multi-step tasks) can also leverage MCP servers. When you assign a task to the Coding Agent, it can:

1. **Discover** available MCP tools from `.mcp.json`
2. **Plan** a multi-step approach using those tools
3. **Execute** tool calls autonomously (with your approval for side effects)
4. **Report** results back in the Copilot Chat window

**Example — Agent + Azure MCP:**
```
Build, deploy, and smoke-test Urban Survivor on Azure PlayFab,
then create a GitHub issue summarizing the deployment results.
```

The Coding Agent will orchestrate calls to the Azure MCP and GitHub MCP servers to complete the entire workflow.

---

## Session 3: Custom Coding Agent in Visual Studio 2026 (8 min)

### Learning Objectives
- Understand the Copilot Coding Agent capabilities in Visual Studio 2026
- Use Agent mode for autonomous multi-file tasks
- Differentiate between Ask, Edit, and Agent interaction modes

### Copilot Chat Modes in Visual Studio 2026

Visual Studio 2026 offers three interaction modes in the Copilot Chat window:

| Mode | Shortcut | Description | When to Use |
|------|----------|-------------|-------------|
| **Ask** | Default | Q&A — Copilot answers questions without modifying files | Learning, debugging, explanations |
| **Edit** | Mode dropdown | Copilot suggests edits to specific files you reference | Targeted single-file or small changes |
| **Agent** | Mode dropdown | Autonomous multi-step agent that reads, plans, and edits across files | Multi-file features, refactoring, complex tasks |

> **Visual Studio 2026 Note:** Switch modes using the **mode dropdown** at the top of the Copilot Chat window. Agent mode is the most powerful — it can read your solution, create plans, invoke MCP tools, run terminal commands, and apply multi-file edits.

### Using Agent Mode

**Step 1:** Open Copilot Chat (**Ctrl+\, Ctrl+C**)  
**Step 2:** Select **Agent** from the mode dropdown  
**Step 3:** Describe your task in natural language  

**Example — Add a New Enemy Type:**
```
Add a new FlyingEnemy class to the Urban Survivor project that inherits
from EnemyAI, adds a hover height parameter, and uses NavigationAgent3D
for 3D pathfinding. Register it in register_types.cpp and add it to
CMakeLists.txt.
```

The Agent will:
1. Read existing `EnemyAI` code to understand the pattern
2. Create `src/ai/flying_enemy.hpp` and `src/ai/flying_enemy.cpp`
3. Register the class in `src/register_types.cpp`
4. Update `CMakeLists.txt` with the new source files
5. Show you all proposed changes for approval

### Copilot Coding Agent (Remote / Autonomous)

The **Copilot Coding Agent** can also run autonomously on GitHub — creating a branch, making changes, and opening a pull request without your IDE being open.

**Trigger from Visual Studio 2026:**
- In Agent mode, Copilot may offer to delegate long-running tasks to the remote Coding Agent
- You can also assign tasks via **GitHub Issues** by tagging `@copilot`

**Trigger from GitHub.com:**
```
# In a GitHub Issue comment:
@copilot implement the FlyingEnemy class described in this issue
```

> ⚠️ **VS Code Difference:** VS Code supports custom chat participants via `.agent.md` files. These custom agent personas are **not supported** in Visual Studio 2026. Instead, use **prompt files** (`.prompt.md`) and **instruction files** (`.github/copilot-instructions.md`) to guide Agent behavior — these are fully supported in Visual Studio 2026.

### Prompt Engineering for Agent Mode

**Best practices for Agent mode prompts:**

1. **Be specific about scope** — name files, classes, and patterns
2. **Reference existing code** — "follow the pattern in `enemy_ai.cpp`"
3. **State the full task** — Agent works best with complete descriptions
4. **Use instruction files** — `.github/copilot-instructions.md` provides persistent context to every Agent session

**Good Agent Prompt:**
```
Implement a reload state for the Weapon class following the FSM pattern
in enemy_ai.cpp. Add RELOADING to the WeaponState enum, handle the
state transition from FIRING, use a reload_time property, and emit a
"reload_complete" signal. Update _bind_methods with the new signal.
```

**Poor Agent Prompt:**
```
Add reload to weapons
```

---

## Session 4: Enterprise Policy Management (8 min)

### Learning Objectives
- Configure organization-wide Copilot policies
- Manage content exclusions and permissions
- Implement security and compliance controls

> **IDE-Agnostic:** Enterprise policies are configured in **GitHub.com Admin → Organization → Copilot**. These policies apply uniformly regardless of whether developers use Visual Studio 2026, VS Code, or other Copilot-supported editors. The settings below are enforced server-side.

### Policy Hierarchy

```
GitHub Enterprise
    └── Organization Policies
        └── Repository Settings
            └── User Preferences
```

### Organization Policies

**GitHub Admin → Organization → Copilot → Policies**

| Policy | Options | Recommendation |
|--------|---------|----------------|
| **Copilot Access** | All / Selected / None | Selected (approved repos) |
| **Suggestions Matching** | Block / Allow | Block (avoid license issues) |
| **Chat** | Enabled / Disabled | Enabled |
| **CLI** | Enabled / Disabled | Enabled |
| **PR Summaries** | Enabled / Disabled | Enabled |
| **Docstrings** | Enabled / Disabled | Enabled |

### Content Exclusions

**Organization-Level Exclusions (GitHub.com):**
```yaml
# Settings → Copilot → Content exclusions (in org settings)
# Or: .github/copilot-content-exclusions.yml in the .github repo
paths:
  - "**/*.env"
  - "**/secrets/**"
  - "**/internal/**"
  - "server/auth/**"
  
repositories:
  - "org/proprietary-engine"
  - "org/anti-cheat-system"
```

> **Visual Studio 2026 Note:** Content exclusions are enforced server-side by GitHub. Visual Studio will not send excluded file content to Copilot, and excluded files will not appear in Copilot’s context window. You can verify exclusions are active in **Tools → Options → GitHub Copilot → Advanced**.

**Repository-Level Content Exclusions:**

Configure in the repository’s settings on GitHub.com under **Settings → Copilot → Content exclusion**:

```
# Urban Survivor Exclusions (configured on GitHub.com)
config/server-keys.json
src/anti-cheat/**
tools/internal/**
*.pem
*.key
```

> ⚠️ **Clarification:** `.copilotignore` is **not** an official GitHub feature. Content exclusions must be configured via **organization or repository settings on GitHub.com**, not via a local file. If your team previously used a `.copilotignore` file, migrate those patterns to the GitHub.com content exclusion settings.

### Game Studio Policy Example

```yaml
# Game Studio Copilot Policies

organization_policies:
  copilot_enabled: true
  suggestions_matching_public_code: block
  chat_enabled: true
  
content_exclusions:
  global:
    - "**/secrets/**"
    - "**/*.env*"
    - "**/credentials/**"
  
  game_specific:
    - "src/anti-cheat/**"
    - "src/drm/**"
    - "server/matchmaking/algorithm/**"
    - "tools/build-signing/**"

approved_mcp_servers:
  - "@azure/mcp-server"
  - "@github/mcp-server"
  - "internal/studio-mcp"

blocked_mcp_servers:
  - "*"  # Block all others by default

model_restrictions:
  allowed_models:
    - "gpt-4o"
    - "claude-sonnet"
  require_approval_for:
    - "claude-opus"  # More expensive
```

### Audit and Compliance

**Copilot Audit Log Events:**
- `copilot.suggestion_accepted`
- `copilot.chat_conversation`
- `copilot.code_review`
- `copilot.mcp_tool_invoked`

**Compliance Dashboard:**
```
┌─────────────────────────────────────────────────────────────┐
│                 Copilot Compliance Dashboard                │
├─────────────────────────────────────────────────────────────┤
│ Excluded Content Access Attempts: 0 ✓                       │
│ Public Code Matches Blocked: 12                             │
│ Unapproved MCP Server Attempts: 3 ⚠                        │
│ Policy Violations: 0 ✓                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Session 5: Model Selection & Cost Optimization (8 min)

### Learning Objectives
- Understand available Copilot models
- Select appropriate models for different tasks
- Optimize costs for team usage

### Available Models

| Model | Strengths | Cost | Use Case |
|-------|-----------|------|----------|
| **GPT-4o** | Fast, good code | $$ | Daily coding |
| **Claude Sonnet** | Great at complex logic | $$ | Architecture |
| **Claude Opus** | Best reasoning | $$$$ | Critical decisions |
| **GPT-4o-mini** | Fast, cheap | $ | Simple completions |

### Model Selection Strategy

**Urban Survivor Model Matrix:**

| Task | Recommended Model | Reason |
|------|-------------------|--------|
| Inline completions | GPT-4o-mini | Speed, low cost |
| Chat Q&A | GPT-4o | Balance |
| Code review | Claude Sonnet | Thorough analysis |
| Architecture planning | Claude Opus | Complex reasoning |
| Debug assistance | GPT-4o | Fast iteration |
| Documentation | GPT-4o | Good prose |

### Configuring Model Preferences

**Visual Studio 2026 — Model Picker Dropdown:**

In the Copilot Chat window, use the **model picker dropdown** at the top of the chat panel to select your preferred model before sending a message. Available models include GPT-4o, Claude Sonnet, Claude Opus, and GPT-4o-mini (depending on your Copilot license tier).

**Steps:**
1. Open Copilot Chat (**Ctrl+\, Ctrl+C**)
2. Click the **model dropdown** at the top of the Chat window
3. Select the desired model (e.g., `Claude Sonnet 4` for architecture planning)
4. Type your prompt and send

> ⚠️ **VS Code Difference:** VS Code allows configuring model preferences in `settings.json` via the `github.copilot.chat.models` key and supports per-request `/model:` syntax. In Visual Studio 2026, model selection is done exclusively through the **Chat window dropdown** — there is no JSON setting or slash command equivalent.

**Per-Request Model Selection (Visual Studio 2026):**

Simply switch the dropdown before asking a complex question:

```
[Model dropdown: Claude Sonnet 4]

Plan the complete multiplayer architecture for Urban Survivor
considering authoritative servers, client prediction, and lag compensation.
```

> **Best Practice:** Default to GPT-4o for everyday tasks. Switch to Claude Sonnet or Claude Opus only for architecture planning, complex refactoring, or critical code reviews where deeper reasoning is needed.

### Cost Optimization Strategies

**1. Tiered Usage:**
- Junior devs: GPT-4o-mini (80% of requests)
- Senior devs: GPT-4o (standard)
- Architects: Claude Opus (on-demand)

**2. Task-Based Selection:**
```
# Low complexity → cheap model
Completions, simple chat → GPT-4o-mini

# Medium complexity → standard model
Refactoring, explanations → GPT-4o

# High complexity → premium model
Architecture, critical reviews → Claude Opus
```

**3. Caching and Deduplication:**
- Cache common documentation lookups
- Share prompt results across team
- Dedupe similar requests

**4. Token Optimization:**
```
# Instead of sending entire file:
"Review lines 45-80 of weapon.cpp focusing on null checks"

# Instead of vague prompts:
"Add ERR_FAIL_NULL checks to all pointer parameters"
```

### Cost Monitoring Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│              Copilot Usage - Urban Survivor Team            │
├─────────────────────────────────────────────────────────────┤
│ This Month's Usage:                                         │
│   Completions: 45,000 tokens ($4.50)                        │
│   Chat: 120,000 tokens ($12.00)                             │
│   Premium Models: 15,000 tokens ($15.00)                    │
│   Total: $31.50                                             │
├─────────────────────────────────────────────────────────────┤
│ Top Users:                                                  │
│   @dev1: 40% (mostly completions)                          │
│   @dev2: 35% (heavy chat usage)                            │
│   @lead: 25% (architecture reviews)                        │
├─────────────────────────────────────────────────────────────┤
│ Recommendations:                                            │
│   ⚠ dev2 could use GPT-4o-mini for simple queries          │
│   ✓ Good premium model usage discipline                     │
└─────────────────────────────────────────────────────────────┘
```

---

## Session 6: GitHub Copilot Certification (6 min)

### Learning Objectives
- Understand certification structure
- Review key exam topics
- Access study resources

> **Note:** The GitHub Copilot Certification is IDE-agnostic. Questions cover Copilot fundamentals, configuration, and prompt engineering across all supported editors including Visual Studio 2026 and VS Code.

### Certification Overview

**GitHub Copilot Certification**
- Duration: 90 minutes
- Format: Multiple choice + hands-on scenarios
- Passing score: 70%
- Validity: 2 years

### Exam Domains

| Domain | Weight | Topics |
|--------|--------|--------|
| **Fundamentals** | 20% | What Copilot is, how it works, models |
| **Configuration** | 25% | Settings, policies, exclusions |
| **Prompt Engineering** | 30% | Effective prompts, context, patterns |
| **Integration** | 15% | MCP, agents, workflows |
| **Security & Compliance** | 10% | Privacy, enterprise policies |

### Sample Exam Questions

**Question 1: Fundamentals**
```
Which of the following best describes GitHub Copilot's suggestion behavior?

A) Suggestions are always correct and can be accepted without review
B) Suggestions are based on context from the current file and open tabs
C) Suggestions only work for JavaScript and Python
D) Suggestions require internet connection for every keystroke

Answer: B
```

**Question 2: Configuration**
```
To exclude sensitive files from Copilot's context across an entire
organization, you should:

A) Add entries to each repository's .gitignore
B) Configure .copilot-content-exclusions.yml in the .github repository
C) Disable Copilot for those repositories
D) Use inline comments to mark sensitive sections

Answer: B
```

**Question 3: Prompt Engineering**
```
Which prompt structure is most likely to produce accurate code generation?

A) "Write a function"
B) "Create sort algorithm fast"
C) "Implement a binary search function that takes a sorted array and
    target value, returns the index if found or -1 if not found"
D) "function search"

Answer: C
```

### Study Resources

| Resource | Type | Link |
|----------|------|------|
| GitHub Copilot Docs | Documentation | docs.github.com/copilot |
| Copilot Fundamentals | Learning Path | learn.microsoft.com |
| Practice Exams | Assessment | GitHub Skills |
| This Workshop Series | Hands-on | You are here! |

### Certification Preparation Checklist

- [ ] Complete all 4 workshops (Foundational → Expert)
- [ ] Configure Copilot in Visual Studio 2026 with a real project
- [ ] Create instruction files (`.github/copilot-instructions.md`) and prompt files (`.prompt.md`)
- [ ] Configure and use MCP servers via `.mcp.json`
- [ ] Use Agent mode for multi-file tasks
- [ ] Review enterprise policy documentation
- [ ] Take practice assessments
- [ ] Schedule and pass the exam

---

## Session 7: Copilot Spec Kit (5 min)

### Learning Objectives
- Understand Spec Kit components
- Use templates for team rollout
- Customize for game development studios

### Spec Kit Overview

The **Copilot Spec Kit** is a collection of templates, guides, and tools for organizational Copilot adoption.

> **IDE-Agnostic:** The Spec Kit is designed to work across all Copilot-supported IDEs. Templates apply equally to Visual Studio 2026 and VS Code teams. When customizing, note which IDE your team uses so you include the correct configuration file formats (`.mcp.json` for Visual Studio vs `.vscode/settings.json` for VS Code).

### Kit Components

**1. Adoption Guide**
- Phased rollout plan
- Stakeholder communication templates
- Success metrics definition

**2. Policy Templates**
```yaml
# Template: Game Studio Policy

# Customize these for your organization
organization_name: "{{ STUDIO_NAME }}"

copilot_tiers:
  - name: "Free Tier"
    users: ["interns", "contractors"]
    features: ["completions"]
    models: ["gpt-4o-mini"]
    
  - name: "Standard Tier"
    users: ["developers"]
    features: ["completions", "chat", "cli"]
    models: ["gpt-4o"]
    
  - name: "Premium Tier"
    users: ["leads", "architects"]
    features: ["all"]
    models: ["all"]

content_exclusions:
  # Add studio-specific exclusions
  - "{{ PROPRIETARY_PATHS }}"
```

**3. Training Materials**
- Slide decks (like these workshops!)
- Hands-on exercises
- Assessment quizzes

**4. Success Metrics Template**
```markdown
## Copilot Success Metrics

### Developer Productivity
- [ ] Lines of code accepted per day
- [ ] Time to complete feature tasks
- [ ] Code review turnaround time

### Code Quality
- [ ] Bug rate in Copilot-assisted code
- [ ] Test coverage of generated code
- [ ] Adherence to coding standards

### Developer Satisfaction
- [ ] NPS score for Copilot
- [ ] Feature request frequency
- [ ] Voluntary usage rate
```

### Game Studio Customization

**Urban Survivor Spec Kit Additions:**

```markdown
## Game Development Specific

### Asset Pipeline Integration
- Blender MCP configuration (`.mcp.json` at solution root)
- Texture validation workflows
- Model import automation

### Game Engine Specifics
- Godot 4.3 API instruction files (`.github/copilot-instructions.md`)
- GDExtension best practices
- Scene file handling policies

### Visual Studio 2026 Configuration
- `.mcp.json` template for team distribution
- Prompt files (`.prompt.md`) for repeatable workflows
- Agent mode best practices for C++ GDExtension development

### Game Design Integration
- SPEC.md reference in prompts
- Balance data MCP connection
- Design doc compliance checking
```

---

## Session 8: Copilot Metrics (5 min)

### Learning Objectives
- Access and interpret Copilot metrics
- Measure team productivity gains
- Identify optimization opportunities

### Metrics Dashboard

**GitHub Admin → Organization → Copilot → Metrics**

> **IDE-Agnostic:** Copilot metrics are tracked at the GitHub organization level. The metrics dashboard on GitHub.com aggregates data across all IDEs — Visual Studio 2026, VS Code, JetBrains, etc. You do not need to configure anything in your IDE to start collecting metrics.

### Key Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| **Acceptance Rate** | % of suggestions accepted | > 25% |
| **Lines Accepted** | Code lines from Copilot | Track trend |
| **Active Users** | Users with activity | > 80% of seats |
| **Chat Sessions** | Conversations per day | Growing |
| **Time Saved** | Estimated from accepted code | ROI calculation |

### Urban Survivor Team Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│              Urban Survivor - Copilot Metrics               │
│                    January 2026                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Acceptance Rate        ████████████████░░░░  32%          │
│  Target: 25%            ✓ Above target                      │
│                                                             │
│  Lines Accepted         12,450 lines this month             │
│  vs Last Month          ▲ +18%                              │
│                                                             │
│  Active Users           8/10 (80%)                          │
│  Inactive               @dev7, @artist2                     │
│                                                             │
│  Top Features Used:                                         │
│    1. Inline completions (45%)                              │
│    2. Chat explanations (30%)                               │
│    3. Code refactoring (15%)                                │
│    4. Test generation (10%)                                 │
│                                                             │
│  Language Breakdown:                                        │
│    C++: 60%                                                 │
│    GDScript: 25%                                            │
│    Markdown: 10%                                            │
│    Other: 5%                                                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Estimated Time Saved: 45 hours                             │
│  At $75/hr: $3,375 value                                   │
│  Copilot Cost: $190 (10 seats)                             │
│  ROI: 17.8x ✓                                               │
└─────────────────────────────────────────────────────────────┘
```

### Improving Metrics

**Low Acceptance Rate (<20%):**
- Review prompt quality
- Check instruction files
- Train on effective prompting

**Inactive Users:**
- Identify blockers
- Provide targeted training
- Review workflow integration

**Declining Usage:**
- Survey for friction points
- Update instruction files
- Add new prompt templates

---

## Workshop Summary

### Key Takeaways

1. **MCP Servers** extend Copilot with custom tools and data sources (configured via `.mcp.json` in Visual Studio 2026)
2. **Azure/Context7/Custom MCPs** enable game-specific workflows through Agent mode
3. **Custom Coding Agent** enables autonomous multi-file tasks in Visual Studio 2026
4. **Enterprise Policies** control access, content, and compliance (IDE-agnostic, configured on GitHub.com)
5. **Model Selection** balances quality, speed, and cost (use the Chat window dropdown in Visual Studio 2026)
6. **Certification** validates Copilot expertise across all supported IDEs
7. **Spec Kit** accelerates organizational adoption
8. **Metrics** measure ROI and identify improvements

### Visual Studio 2026 Feature Summary

| Capability | Visual Studio 2026 Support | Notes |
|------------|---------------------------|-------|
| MCP Servers | ✅ Supported | `.mcp.json` at solution root |
| Custom Coding Agent | ✅ Supported | Agent mode in Copilot Chat |
| Prompt Engineering | ✅ Supported | Instruction files, prompt files |
| Enterprise Policies | ✅ Supported | GitHub.com admin (IDE-agnostic) |
| Model Selection | ✅ Supported | Dropdown in Chat window |
| Copilot Spec Kit | ✅ Supported | IDE-agnostic templates |
| Copilot Metrics | ✅ Supported | GitHub.com dashboard (IDE-agnostic) |
| Custom Agents (`.agent.md`) | ⚠️ VS Code Only | Use prompt files + instruction files instead |
| `@participant` chat syntax | ⚠️ VS Code Only | Agent mode auto-discovers MCP tools |
| `settings.json` model config | ⚠️ VS Code Only | Use Chat window model dropdown |

### Complete Workshop Series Recap

| Workshop | Focus | Key Skills |
|----------|-------|------------|
| Foundational | Basics | Context, security, limits |
| Intermediate | Prompting | CORE, few-shot, testing |
| Advanced | Customization | Instructions, agents, plans |
| Expert | Enterprise | MCP, coding agent, policies, metrics |

### Next Steps

1. **Configure** `.mcp.json` with MCP servers for your workflow
2. **Implement** instruction and prompt files in your project
3. **Practice** Agent mode for multi-file tasks in Visual Studio 2026
4. **Measure** productivity with the GitHub metrics dashboard
5. **Certify** your team's Copilot skills
6. **Share** knowledge through internal training

---

## Resources

- [MCP Specification](https://modelcontextprotocol.io)
- [GitHub Copilot Enterprise](https://docs.github.com/copilot/copilot-enterprise)
- [GitHub Copilot in Visual Studio](https://learn.microsoft.com/visualstudio/ide/copilot/copilot-chat)
- [Azure MCP Server](https://github.com/azure/azure-mcp)
- [Copilot Certification](https://learn.microsoft.com/credentials)
- [Urban Survivor Project](../../README.md)

---

## Appendix: MCP Server Quick Reference

### Installing MCP Servers

```bash
# Azure MCP
npm install -g @azure/mcp-server

# Context7 (Documentation)
npm install -g @context7/mcp-server

# GitHub
npm install -g @github/mcp-server

# Docker
npm install -g @docker/mcp-server
```

### MCP Configuration Template

**Visual Studio 2026 (`.mcp.json` at solution root):**

```json
{
    "mcpServers": {
        "azure": {
            "command": "npx",
            "args": ["-y", "@azure/mcp-server"],
            "env": {
                "AZURE_SUBSCRIPTION_ID": "${env:AZURE_SUBSCRIPTION_ID}"
            }
        },
        "context7": {
            "command": "npx", 
            "args": ["-y", "@context7/mcp-server"]
        },
        "github": {
            "command": "npx",
            "args": ["-y", "@github/mcp-server"],
            "env": {
                "GITHUB_TOKEN": "${env:GITHUB_TOKEN}"
            }
        }
    }
}
```

> **Cross-IDE Tip:** If your team uses both Visual Studio and VS Code, place configuration in `.vscode/mcp.json` which both IDEs can read. Visual Studio will also read its native `.mcp.json` format.

### Using MCP Tools in Visual Studio 2026 (Agent Mode)

In Visual Studio 2026, MCP tools are invoked automatically by Agent mode. Describe your task in natural language and Copilot will select the appropriate MCP tools:

```
# Azure (Agent mode auto-discovers Azure MCP tools)
Deploy the Urban Survivor build to Azure App Service
Show best practices for Azure Cosmos DB
Scan the project for security issues using Azure

# Context7 (Agent mode auto-discovers Context7 MCP tools)
Look up the Godot 4.3 documentation for NavigationAgent3D

# GitHub (Agent mode auto-discovers GitHub MCP tools)
Create an issue for the reload animation bug
Show the status of open pull requests
```

> ⚠️ **VS Code Difference:** VS Code uses `@azure`, `@context7`, `@github` chat participant prefixes to address MCP servers directly. In Visual Studio 2026, simply describe your intent in Agent mode — the agent automatically routes to the correct MCP server.

---

*Workshop Series Complete! 🎮*

*All examples in this workshop target Visual Studio 2026 Preview. For VS Code equivalents, refer to the VS Code parity notes (⚠️) throughout each session.*

*For questions or updates, contact the workshop facilitator.*
