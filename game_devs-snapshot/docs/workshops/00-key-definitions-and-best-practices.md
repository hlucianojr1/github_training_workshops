# GitHub Copilot Workshop Series
## Key Definitions & Best Practices for AI-Assisted Game Development

**Workshop Series**: AI-Assisted Game Development with GitHub Copilot  
**IDE**: Visual Studio 2022 (17.14+) with GitHub Copilot  
**Project Reference**: Urban Survivor (Godot 4.3+ / C++ GDExtension)  
**Date**: January 2026

---

## Table of Contents
1. [Key Definitions](#key-definitions)
2. [Best Practices for AI-Assisted Game Development](#best-practices-for-ai-assisted-game-development)
3. [Workshop Series Overview](#workshop-series-overview)

---

## Key Definitions

### What is GitHub Copilot?

**GitHub Copilot** is an AI-powered coding assistant developed by GitHub and OpenAI that provides real-time code suggestions directly in your IDE. It acts as a "pair programmer" that understands context from your codebase, comments, and file structures to generate relevant code completions.

> **Visual Studio Note:** GitHub Copilot is natively integrated into Visual Studio 2022 (17.14+). No separate extension install is required for Copilot Chat — it ships as a first-party component of the IDE.

**Key Capabilities in Visual Studio:**
- **Inline code completions** — gray ghost text appears as you type; press **Tab** to accept, **Esc** to dismiss
- **Copilot Chat window** — a dockable tool window for conversational AI interactions (**Ctrl+\, Ctrl+C** or **View → GitHub Copilot Chat**)
- **Inline Chat** — invoke Copilot directly in the editor at your cursor (**Alt+/**)
- **Ask Copilot** — right-click any code and choose **Ask Copilot** from the context menu for quick explanations or fixes
- **Copilot Edits** — multi-file agentic editing mode that plans and applies changes across your solution
- **Solution-wide context** — Copilot understands your `.sln` and project structure, giving it richer context than file-only awareness
- **Code review suggestions** — Copilot can review your changes for bugs, style issues, and security vulnerabilities
- Support for 100+ programming languages including C++, GDScript, and Python

**Visual Studio Keyboard Shortcuts (Default):**
| Action | Shortcut |
|--------|----------|
| Accept inline suggestion | **Tab** |
| Dismiss inline suggestion | **Esc** |
| Open Copilot Chat window | **Ctrl+\, Ctrl+C** |
| Inline Chat (at cursor) | **Alt+/** |
| Next suggestion | **Alt+]** |
| Previous suggestion | **Alt+[** |

**In Game Development Context (Urban Survivor Example):**
```cpp
// Copilot understands Godot patterns when you write:
void PlayerController::_bind_methods() {
    // Copilot suggests appropriate ClassDB bindings
    ClassDB::bind_method(D_METHOD("get_health"), &PlayerController::get_health);
    ClassDB::bind_method(D_METHOD("set_health", "value"), &PlayerController::set_health);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "health"), "set_health", "get_health");
}
```

---

### What is an MCP Server?

**MCP (Model Context Protocol) Server** is an open standard that allows AI assistants like GitHub Copilot to connect to external tools, APIs, and data sources. MCP Servers extend Copilot's capabilities beyond code generation.

**Architecture:**
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  GitHub Copilot │◄───►│   MCP Server    │◄───►│ External Service│
│     (Host)      │     │   (Bridge)      │     │  (Data/Tools)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

**Examples of MCP Servers for Game Development:**
- **Azure MCP**: Deploy game builds to cloud infrastructure
- **Blender MCP**: Generate 3D models programmatically
- **Database MCP**: Query game analytics and player data
- **Docker MCP**: Manage containerized game servers

**Game Dev Use Case:**
```
User: "Deploy the latest Urban Survivor build to Azure PlayFab"
Copilot → Azure MCP Server → Azure PlayFab API → Deployment
```

**Configuring MCP Servers in Visual Studio:**

Visual Studio 2022 (17.14+) supports MCP servers natively. Configuration is defined in a `mcp.json` file placed in your solution directory or in `%USERPROFILE%/.vscode/mcp.json` for user-level servers.

Example `.vscode/mcp.json` at the solution root:
```json
{
  "servers": {
    "azure-mcp": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure/mcp-server"]
    }
  }
}
```

> **Visual Studio Note:** MCP servers appear automatically in the Copilot Chat window once configured. You can manage enabled/disabled servers from **Tools → Options → GitHub Copilot → MCP Servers**. The MCP server tools become available to Copilot’s agent mode when processing chat requests.

---

### What are Custom Agents?

**Custom Agents** are specialized AI personas defined in markdown files that provide domain-specific expertise. They act as virtual team members with focused knowledge areas.

> **Visual Studio Note:** Custom agents are supported in Visual Studio 2022 (17.14+). Agent files are placed in the `.github/agents/` folder and are automatically discovered when the solution is opened. Invoke them by typing `@agent-name` in the **Copilot Chat window** (Ctrl+\, Ctrl+C).

**Structure** (`.github/agents/` folder):
```markdown
---
name: 'combat-systems'
description: 'Expert in weapon mechanics, damage calculation, and hit detection'
---

You are a combat systems specialist for the Urban Survivor game.

**Expertise:**
- Weapon firing, reload mechanics, and ammunition
- DamageSystem integration
- Hit zone detection (HEAD 2.5x, TORSO 1.0x, LIMBS 0.7x)
- Raycast/hitscan weapon implementation

**Reference Files:**
- src/combat/weapon.cpp
- src/combat/damage_system.cpp
- docs/SPEC.md (Section 5: Combat)
```

**Urban Survivor Agents:**
| Agent | Expertise |
|-------|-----------|
| `@combat-systems` | Weapons, damage, hit detection |
| `@enemy-ai` | FSM AI, navigation, perception |
| `@godot-cpp-expert` | GDExtension bindings, lifecycle |
| `@gdscript-ui` | HUD, menus, UI signals |
| `@debug-helper` | Build errors, runtime crashes |

**Invoking Agents in Visual Studio:**

In the Copilot Chat window, type `@` followed by the agent name. Visual Studio provides autocomplete for available agents:
```
@combat-systems implement the reload_weapon() method
```

> **Tip:** You can also reference files alongside agent invocations using `#file:` to give the agent additional context:
> ```
> @combat-systems #file:src/combat/weapon.hpp implement the reload method
> ```

---

### What are Prompt Files?

**Prompt Files** are reusable templates (`.prompt.md`) that define structured workflows for common development tasks. They ensure consistency and encode best practices.

> **Visual Studio Note:** Prompt files are supported in Visual Studio 2022 (17.13+). They live in the `.github/prompts/` folder and are discovered automatically. To invoke a prompt file in Visual Studio, open the **Copilot Chat window** and click the **Attach Context** (paperclip) button, then select **Prompt Files** to browse available prompts. You can also type `#` in the chat to search for and attach a prompt file directly.
>
> ⚠️ **VS Code Difference:** In VS Code, prompt files are invoked using the `/` slash command syntax (e.g., `/implement-weapon-raycast`). This slash command invocation is **not available** in Visual Studio. Use the attach context method or `#` reference described above instead.

**Structure** (`.github/prompts/` folder):
```markdown
---
agent: 'agent'
description: 'Implement raycast weapon firing for Urban Survivor'
---

You are implementing weapon firing mechanics.

**Context to load:**
- src/combat/weapon.hpp
- src/combat/damage_system.hpp
- docs/SPEC.md (Section 5.2: Weapons)

**Implementation requirements:**
1. Cast ray from camera through crosshair
2. Apply damage via DamageSystem.apply_damage()
3. Spawn muzzle flash and impact particles
4. Play audio: fire sound, impact sound
5. Emit "weapon_fired" signal for HUD ammo update

**Test plan:**
- [ ] Fire hits static target at 10m
- [ ] Fire hits moving enemy
- [ ] Ammo decrements correctly
```

**Example Prompts for Game Development:**
- `implement-weapon-raycast.prompt.md`
- `implement-ai-attack-state.prompt.md`
- `wire-hud-health-ammo.prompt.md`
- `debug-extension-not-loading.prompt.md`

**Invoking in Visual Studio:**
```
# In the Copilot Chat window, click the paperclip (📎) icon,
# select "Prompt Files", and choose the prompt to run.
# Alternatively, type # in the chat input to search for a prompt.
```

---

### What and Why is an Instruction File?

**Instruction Files** (`.instructions.md`) are persistent rules that automatically apply to specific file patterns. Unlike prompt files (invoked manually), instructions are **always active** when editing matching files.

> **Visual Studio Note:** Instruction files are supported in Visual Studio 2022 (17.12+). They are placed in `.github/instructions/` and use the `applyTo` front-matter glob pattern to match files. When you edit a C++ file that matches `**/*.{cpp,hpp}`, Visual Studio automatically includes the corresponding instruction file’s rules in Copilot’s context. You can verify which instructions are active via **Tools → Options → GitHub Copilot → Instructions**.
>
> Visual Studio also supports **repository-level custom instructions** via `.github/copilot-instructions.md`, which apply globally to all Copilot interactions within the solution.

**Why Use Instruction Files?**
1. **Consistency**: Every C++ file follows the same patterns
2. **Error Prevention**: Rules prevent common mistakes
3. **Onboarding**: New developers (and AI) learn standards automatically
4. **Language-Specific**: Different rules for C++, GDScript, shaders

**Structure** (`.github/instructions/` folder):
```markdown
---
description: 'C++ GDExtension rules for Urban Survivor'
applyTo: '**/*.{cpp,hpp}'
---

**Must read before edits:**
- docs/ARCHITECTURE.md
- docs/CODING_STANDARDS.md

**Godot lifecycle rules:**
- Do not create nodes in constructors; use `_ready()`
- Cache node references; never call `get_node()` every frame

**Binding requirements:**
- Every exposed class needs GDCLASS() and _bind_methods()
- Use snake_case for exposed method names

**Safety:**
- Always null-check pointers: ERR_FAIL_NULL(ptr)
- Never modify external/godot-cpp/
```

---

### What is Chain of Thought Prompting?

**Chain of Thought (CoT) Prompting** is a technique where you guide the AI to reason through a problem step-by-step before generating code. This improves accuracy for complex tasks.

**Without CoT (Direct Request):**
```
"Add cover-seeking behavior to EnemyAI"
```

**With CoT (Step-by-Step Reasoning):**
```
"I need to add cover-seeking behavior to EnemyAI. Let's think through this:

1. First, what triggers cover-seeking? (Taking damage, seeing armed player)
2. How do we find cover points? (Raycast to nearby NavigationRegion3D)
3. What makes a valid cover point? (Blocks line-of-sight to player)
4. How do we navigate there? (NavigationAgent3D.set_target_position)
5. What state do we enter? (COVER state with peek/shoot behavior)

Now implement step 1: the trigger conditions in the CHASE state."
```

**Benefits for Game Development:**
- Complex AI behaviors become tractable
- Algorithm design before implementation
- Debugging by reasoning through expected vs. actual behavior

---

### What is Few-Shot Prompting?

**Few-Shot Prompting** provides examples of the desired input→output pattern before making your actual request. This teaches the AI the expected format and style.

**Zero-Shot (No Examples):**
```
"Create a signal for when the player takes damage"
```

**Few-Shot (With Examples):**
```
"Here's how we define signals in Urban Survivor:

Example 1 - Weapon fired:
ADD_SIGNAL(MethodInfo("weapon_fired",
    PropertyInfo(Variant::INT, "ammo_remaining")));

Example 2 - Item collected:
ADD_SIGNAL(MethodInfo("item_collected",
    PropertyInfo(Variant::STRING, "item_id"),
    PropertyInfo(Variant::INT, "quantity")));

Now create a signal for when the player takes damage.
Include: damage amount, damage type, and attacker reference."
```

**Result:**
```cpp
ADD_SIGNAL(MethodInfo("damage_taken",
    PropertyInfo(Variant::FLOAT, "amount"),
    PropertyInfo(Variant::INT, "damage_type"),
    PropertyInfo(Variant::OBJECT, "attacker")));
```

---

### What is Tree of Thoughts Prompting?

**Tree of Thoughts (ToT) Prompting** explores multiple solution paths simultaneously, evaluating each before selecting the best approach. It's ideal for design decisions with trade-offs.

**Example - AI Pathfinding Strategy:**
```
"I need to decide how EnemyAI should navigate around obstacles.

Branch A: Pure NavigationAgent3D
- Pros: Built-in, handles dynamic obstacles
- Cons: Can look robotic, expensive for many agents

Branch B: Custom steering behaviors
- Pros: More natural movement, flocking possible
- Cons: More code to maintain, collision issues

Branch C: Hybrid (Navigation for long paths, steering for local)
- Pros: Best of both worlds
- Cons: Integration complexity

Evaluate each branch against Urban Survivor's requirements:
- Up to 15 simultaneous enemies
- Performance target: 60 FPS
- Behavior: Tactical, cover-seeking

Recommendation: Branch C is best because..."
```

---

### What is Self-Consistency Prompting?

**Self-Consistency Prompting** generates multiple independent solutions to the same problem, then selects the most common or highest-quality answer. This reduces errors on complex tasks.

**Example - Damage Calculation Validation:**
```
"Calculate the damage output for the following scenario three different ways:

Weapon: Pistol (base damage: 25)
Range: 15 meters (falloff starts at 10m)
Hit zone: HEAD (2.5x multiplier)
Target armor: Light (0.8x reduction)

Method 1: Step-by-step calculation
Method 2: Using the DamageSystem.calculate_final_damage() formula
Method 3: Working backwards from expected behavior

Compare results. If they differ, identify the error."
```

**Why Use Self-Consistency?**
- Catches calculation errors
- Validates complex algorithms
- Increases confidence in critical game mechanics

---

## Best Practices for AI-Assisted Game Development

### 1. Project Structure & Context

#### Establish Clear Documentation Hierarchy
```
docs/
├── ARCHITECTURE.md    # System design (read first)
├── SPEC.md            # Game design document
├── MEMORY.md          # Decisions & known issues
├── CODING_STANDARDS.md # Style guidelines
└── models/            # Asset specifications
```

#### Maintain a Living Memory File
Update `MEMORY.md` with every significant decision:
```markdown
## 2026-01-08: Enemy Cover-Seeking

**Decision**: Use NavigationServer3D.map_get_closest_point_to_segment()
**Rationale**: Better performance than custom raycasting
**Trade-off**: Less control over cover quality scoring
**Affected files**: src/ai/enemy_ai.cpp, src/ai/ai_perception.cpp
```

---

### 2. Prompt Engineering for Game Dev

#### Be Specific About Game Engine Patterns

When typing in the **Copilot Chat window** (Ctrl+\, Ctrl+C), be explicit about engine and version:

❌ Vague: "Create a player controller"
✅ Specific: "Create a CharacterBody3D-based PlayerController for Godot 4.3 with WASD movement, sprint (Shift), crouch (Ctrl), and jump (Space). Use _physics_process for movement. Emit signals for stamina changes."

#### Include File Context in Prompts

In Visual Studio’s Copilot Chat, you can attach files to your prompt using `#file:` references for precise context:
```
#file:src/combat/weapon.cpp #file:src/combat/damage_system.hpp
implement the reload_weapon() method that:
1. Checks current ammo vs magazine size
2. Plays reload animation via AnimationPlayer
3. Transfers ammo from inventory to magazine
4. Emits 'reload_complete' signal when done
```

> **Tip:** You can also drag files from **Solution Explorer** into the Copilot Chat input box to attach them as context.

#### Reference Your SPEC.md for Accuracy
Use `#file:` to attach the spec directly in Copilot Chat:
```
#file:docs/SPEC.md
According to Section 3.1, player sprint speed is 8 m/s
and costs 10 stamina/sec. Implement the sprint logic matching these values.
```

---

### 3. Code Generation Patterns

#### Use Instruction Files for Language-Specific Rules
Create `.github/instructions/` files for each language:
- `cpp-gdextension.instructions.md` → `**/*.{cpp,hpp}`
- `gdscript.instructions.md` → `**/*.gd`
- `shader.instructions.md` → `**/*.gdshader`

#### Leverage Custom Agents for Specialized Tasks

In the **Copilot Chat window** (Ctrl+\, Ctrl+C), type `@` to invoke an agent:
```
@combat-systems implement the reload_weapon() method
@enemy-ai add flanking behavior to the CHASE state
@gdscript-ui create the inventory quick-slot UI
```

> **Visual Studio Note:** Agent autocomplete appears after typing `@`. You can combine agents with `#file:` references for richer context.

#### Create Prompt Files for Repeatable Tasks
Common game dev prompts:
- `implement-weapon-*.prompt.md` (per weapon type)
- `add-enemy-state.prompt.md` (FSM state template)
- `create-interactable.prompt.md` (world objects)
- `wire-signal-*.prompt.md` (UI connections)

> **Visual Studio Invocation:** Open Copilot Chat, click the **Attach Context** (📎) button, select **Prompt Files**, and choose the prompt to execute. All team members with the same `.github/prompts/` folder get the same set of prompts.

---

### 4. Testing & Validation

#### Always Include Test Plans in Prompts
```
**Test Plan:**
- [ ] Player takes 10 damage → health bar updates
- [ ] Player health reaches 0 → game over triggered
- [ ] Damage number popup appears at hit location
- [ ] Damage sound plays with correct attenuation
```

#### Use Self-Consistency for Critical Systems
For damage calculations, economy balancing, or physics:
```
"Calculate the expected behavior THREE ways and compare.
If results differ, identify the discrepancy."
```

#### Validate Generated Code Against Standards
After generation, invoke the code reviewer agent in Copilot Chat:
```
@code-reviewer review the changes in src/combat/weapon.cpp
against docs/CODING_STANDARDS.md
```

> **Visual Studio Tip:** You can also select code in the editor, right-click, and choose **Ask Copilot** → **Explain** or **Fix** to quickly validate specific sections.

---

### 5. Iterative Development

#### Start Small, Expand Gradually
1. Generate a skeleton with method signatures
2. Implement one method at a time
3. Test each method before proceeding
4. Refactor once all methods work

#### Use Chain of Thought for Complex Features
In Copilot Chat, break complex requests into explicit steps:
```
"Let's implement AI cover-seeking step by step:
Step 1: Define what triggers cover-seeking
Step 2: Find valid cover points
Step 3: Evaluate cover quality
Step 4: Navigate to best cover
Step 5: Implement peek/shoot behavior

Start with Step 1..."
```

#### Maintain Session Continuity
Copilot Chat in Visual Studio maintains conversation history within a session. Reference previous decisions:
```
"Earlier we decided to use raycasting for cover detection.
Now implement the cover quality scoring based on:
- Distance to cover
- Angle of protection
- Line of sight to player"
```

---

### 6. Security & Privacy

#### Never Include Secrets in Context
- API keys, passwords, tokens
- Player personal data
- Proprietary algorithms

#### Review Generated Code for Vulnerabilities
Watch for:
- Unbounded loops in `_process()`
- Missing null checks (`ERR_FAIL_NULL()`)
- Unsafe file paths (use `res://` not absolute paths)

---

### 7. Performance Optimization

#### Profile Before Optimizing
```
"The Godot profiler shows _physics_process in EnemyAI
takes 2ms per frame with 10 enemies.
Identify the bottleneck and suggest optimizations."
```

#### Request Game-Specific Optimizations
```
"Optimize this code for Godot 4.3:
- Use object pooling for bullets
- Cache node references in _ready()
- Avoid per-frame allocations"
```

---

### 8. Collaboration Workflow

#### Use Prompt Files for Team Consistency
Team members invoke the same prompts from the Copilot Chat window:
```
# In Visual Studio: Copilot Chat → Attach Context (📎) → Prompt Files
# → Select "implement-weapon-raycast.prompt.md"
#
# All team members with the .github/prompts/ folder in source
# control see the same set of shared prompts.
```

> ⚠️ **VS Code Difference:** VS Code uses the `/` slash command (e.g., `/implement-weapon-raycast`) to invoke prompt files. This syntax is **not available** in Visual Studio. Use the Attach Context method above instead.

#### Document Decisions in MEMORY.md
In the Copilot Chat window, invoke the documentation agent:
```
@doc-maintainer add entry for the new reload system:
- Reload cancels on damage taken
- Magazine size varies by weapon type
- Partial reloads supported
```

#### Review Before Merge
In the Copilot Chat window, invoke the code reviewer agent:
```
@code-reviewer review all changed files
Focus on: thread safety, signal connections, null checks
```

> **Visual Studio Tip:** You can also use Copilot’s built-in code review feature by right-clicking changed files in the **Git Changes** window and selecting **Ask Copilot to Review**.

---

## Workshop Series Overview

| Level | Duration | Focus |
|-------|----------|-------|
| **[Foundational](01-foundational-workshop.md)** | 1 hour | Copilot basics, context, security |
| **[Intermediate](02-intermediate-workshop.md)** | 1 hour | Prompting, chat, testing |
| **[Advanced](03-advanced-workshop.md)** | 1 hour | Instruction files, agents, code review |
| **[Expert](04-expert-workshop.md)** | 1 hour | MCP servers, enterprise, certification |

---

## Resources

**Visual Studio & GitHub Copilot:**
- [GitHub Copilot in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-install-and-states)
- [Copilot Chat in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-chat)
- [Copilot Completions in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot)
- [GitHub Copilot Documentation](https://docs.github.com/copilot)

**Customization & Extensibility:**
- [Custom Instructions for Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
- [Custom Agents](https://docs.github.com/en/copilot/customizing-copilot/extending-copilot-chat-in-your-ide)
- [Model Context Protocol Spec](https://modelcontextprotocol.io)

**Project References:**
- [Godot 4.3 GDExtension Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/)
- [Urban Survivor Architecture](../ARCHITECTURE.md)
- [Urban Survivor Spec](../SPEC.md)

---

## Visual Studio Feature Compatibility Reference

The following table summarizes GitHub Copilot feature availability in Visual Studio 2022 compared to VS Code. Use this as a quick reference when following workshop exercises.

| Feature | Visual Studio 2022 | Min Version | VS Code Equivalent | Notes |
|---------|-------------------|-------------|-------------------|-------|
| Inline completions | ✅ Supported | 17.10+ | Same | Tab to accept, Esc to dismiss |
| Copilot Chat window | ✅ Supported | 17.10+ | Sidebar panel | Dockable tool window in VS |
| Inline Chat | ✅ Supported | 17.12+ | Ctrl+I | Alt+/ in Visual Studio |
| Copilot Edits (multi-file) | ✅ Supported | 17.13+ | Same | Agentic multi-file editing |
| Custom Instructions (`.github/copilot-instructions.md`) | ✅ Supported | 17.12+ | Same | Auto-loaded per repo |
| Instruction Files (`.github/instructions/`) | ✅ Supported | 17.13+ | Same | `applyTo` glob matching |
| Prompt Files (`.github/prompts/`) | ✅ Supported | 17.13+ | `/` slash commands | Use Attach Context (📎) in VS |
| Custom Agents (`.github/agents/`) | ✅ Supported | 17.14+ | Same `@` syntax | `@agent-name` in Chat |
| MCP Servers | ✅ Supported | 17.14+ | Same `mcp.json` | Configure via `mcp.json` |
| `#file:` context references | ✅ Supported | 17.12+ | Same | Attach files to chat context |
| Ask Copilot (right-click) | ✅ Supported | 17.10+ | N/A | VS-exclusive context menu |
| `/` slash commands for prompts | ❌ Not Available | N/A | VS Code only | Use Attach Context in VS instead |
| Copilot in integrated terminal | ❌ Not Available | N/A | VS Code only | VS Code terminal has Copilot suggestions; Visual Studio’s terminal does not |

---

*Last Updated: January 2026 — Updated for Visual Studio 2022 (17.14+)*
