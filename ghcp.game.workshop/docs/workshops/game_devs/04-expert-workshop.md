# Workshop 4: Expert
## MCP Servers, Enterprise Management, and Certification

**Duration**: 1 Hour  
**Level**: Expert  
**Prerequisites**: Foundational + Intermediate + Advanced Workshops  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)

---

## Workshop Objectives

By the end of this workshop, participants will:
- Understand Copilot Extensions evolution to MCP Servers
- Configure and use MCP Servers for extended capabilities
- Implement enterprise policy management for Copilot
- Optimize model selection and cost management
- Prepare for GitHub Copilot Certification
- Utilize the Copilot Spec Kit for organizational rollout
- Analyze Copilot metrics for team productivity

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:12 | Copilot Extensions → MCP Servers | Presentation |
| 0:12 - 0:24 | MCP Server Configuration | Live Demo |
| 0:24 - 0:34 | Enterprise Policy Management | Walkthrough |
| 0:34 - 0:44 | Model Selection & Cost Optimization | Analysis |
| 0:44 - 0:50 | GitHub Copilot Certification | Overview |
| 0:50 - 0:55 | Copilot Spec Kit | Tour |
| 0:55 - 1:00 | Copilot Metrics | Dashboard Demo |

---

## Session 1: Copilot Extensions → MCP Servers (12 min)

### Learning Objectives
- Understand the evolution from Extensions to MCP
- Grasp MCP Server architecture
- Identify use cases for game development

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
│                     VS Code / IDE                           │
├─────────────────────────────────────────────────────────────┤
│                   GitHub Copilot (Host)                     │
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
- Configure MCP servers in VS Code
- Connect to Azure MCP for deployment
- Create a custom MCP server for game-specific tools

### MCP Configuration File

**Location**: `.vscode/settings.json` or `mcp.json`

```json
{
    "mcp": {
        "servers": {
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
                "args": ["-m", "blender_mcp"],
                "env": {
                    "BLENDER_PATH": "C:/Program Files/Blender Foundation/Blender 4.0/blender.exe"
                }
            }
        }
    }
}
```

### Demo: Azure MCP for Deployment

**Step 1: Install Azure MCP**
```bash
npm install -g @azure/mcp-server
```

**Step 2: Authenticate**
```bash
az login
```

**Step 3: Use in Copilot Chat**
```
@azure Deploy the latest Urban Survivor build to Azure PlayFab

Copilot → Azure MCP → Azure PlayFab API
```

**Available Azure MCP Tools:**
| Tool | Description |
|------|-------------|
| `deploy` | Deploy to Azure services |
| `azqr` | Security/compliance scan |
| `bestpractices` | Get Azure best practices |
| `resources` | Query Azure resources |
| `logs` | Fetch application logs |

### Demo: Context7 for Documentation

**Fetching Godot Documentation:**
```
User: How do I use NavigationAgent3D's avoidance in Godot 4.3?

Copilot → Context7 MCP → Godot Docs

Context7 Response:
NavigationAgent3D Avoidance (Godot 4.3):
- Enable: agent.avoidance_enabled = true
- Set radius: agent.radius = 0.5
- Set layers: agent.avoidance_layers = 1
- Callback: agent.velocity_computed.connect(_on_velocity_computed)
[code examples follow]
```

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

**Register in mcp.json:**
```json
{
    "mcp": {
        "servers": {
            "urban-survivor": {
                "command": "python",
                "args": ["tools/urban_survivor_mcp.py"]
            }
        }
    }
}
```

**Usage:**
```
@urban-survivor What are the balance stats for the pistol weapon?
@urban-survivor Create a new health pack item with 50 HP restore
@urban-survivor Validate assets/models/enemy_scavenger.glb
```

---

## Session 3: Enterprise Policy Management (10 min)

### Learning Objectives
- Configure organization-wide Copilot policies
- Manage content exclusions and permissions
- Implement security and compliance controls

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

**Organization-Level Exclusions:**
```yaml
# .github/copilot-content-exclusions.yml
paths:
  - "**/*.env"
  - "**/secrets/**"
  - "**/internal/**"
  - "server/auth/**"
  
repositories:
  - "org/proprietary-engine"
  - "org/anti-cheat-system"
```

**Repository-Level (.copilotignore):**
```
# Urban Survivor Exclusions
config/server-keys.json
src/anti-cheat/**
tools/internal/**
*.pem
*.key
```

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

## Session 4: Model Selection & Cost Optimization (10 min)

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

**VS Code Settings:**
```json
{
    "github.copilot.chat.models": {
        "default": "gpt-4o",
        "codeReview": "claude-sonnet-4",
        "planning": "claude-sonnet-4"
    }
}
```

**Per-Request Model Selection:**
```
@workspace /model:claude-opus
Plan the complete multiplayer architecture for Urban Survivor
considering authoritative servers, client prediction, and lag compensation.
```

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

## Session 5: GitHub Copilot Certification (6 min)

### Learning Objectives
- Understand certification structure
- Review key exam topics
- Access study resources

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
- [ ] Configure Copilot in a real project
- [ ] Create instruction files and prompt files
- [ ] Use MCP servers for extended tasks
- [ ] Review enterprise policy documentation
- [ ] Take practice assessments
- [ ] Schedule and pass the exam

---

## Session 6: Copilot Spec Kit (5 min)

### Learning Objectives
- Understand Spec Kit components
- Use templates for team rollout
- Customize for game development studios

### Spec Kit Overview

The **Copilot Spec Kit** is a collection of templates, guides, and tools for organizational Copilot adoption.

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
- Blender MCP configuration
- Texture validation workflows
- Model import automation

### Game Engine Specifics
- Godot 4.3 API instruction files
- GDExtension best practices
- Scene file handling policies

### Game Design Integration
- SPEC.md reference in prompts
- Balance data MCP connection
- Design doc compliance checking
```

---

## Session 7: Copilot Metrics (5 min)

### Learning Objectives
- Access and interpret Copilot metrics
- Measure team productivity gains
- Identify optimization opportunities

### Metrics Dashboard

**GitHub Admin → Organization → Copilot → Metrics**

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

1. **MCP Servers** extend Copilot with custom tools and data sources
2. **Azure/Context7/Custom MCPs** enable game-specific workflows
3. **Enterprise Policies** control access, content, and compliance
4. **Model Selection** balances quality, speed, and cost
5. **Certification** validates Copilot expertise
6. **Spec Kit** accelerates organizational adoption
7. **Metrics** measure ROI and identify improvements

### Complete Workshop Series Recap

| Workshop | Focus | Key Skills |
|----------|-------|------------|
| Foundational | Basics | Context, security, limits |
| Intermediate | Prompting | CORE, few-shot, testing |
| Advanced | Customization | Instructions, agents, plans |
| Expert | Enterprise | MCP, policies, metrics |

### Next Steps

1. **Implement** instruction and prompt files in your project
2. **Configure** MCP servers for your workflow
3. **Measure** productivity with metrics dashboard
4. **Certify** your team's Copilot skills
5. **Share** knowledge through internal training

---

## Resources

- [MCP Specification](https://modelcontextprotocol.io)
- [GitHub Copilot Enterprise](https://docs.github.com/copilot/copilot-enterprise)
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

```json
{
    "mcp": {
        "servers": {
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
}
```

### Common MCP Commands

```
# Azure
@azure deploy [app] to [service]
@azure show best practices for [topic]
@azure scan for security issues

# Context7
@context7 documentation for [library] [topic]

# GitHub
@github create issue for [description]
@github show PR status
```

---

*Workshop Series Complete! 🎮*

*For questions or updates, contact the workshop facilitator.*
