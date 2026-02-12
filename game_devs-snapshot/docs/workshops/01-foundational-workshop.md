# Workshop 1: Foundational
## GitHub Copilot Essentials for Game Developers

**Duration**: 1 Hour  
**Level**: Beginner  
**IDE**: Visual Studio 2022 (17.14+) with GitHub Copilot  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)  
**Date**: January 2026

> **Prerequisite:** Ensure you have Visual Studio 2022 version 17.14 or later installed. GitHub Copilot and Copilot Chat are first-party components of the IDE — no separate extension is required. You must be signed in with a GitHub account that has an active Copilot license.

---

## Workshop Objectives

By the end of this workshop, participants will:
- Understand GitHub Copilot's role as an AI pair programmer in Visual Studio
- Provide effective context for better code suggestions
- Use iterative acceptance to refine generated code
- Apply security and privacy best practices
- Customize Copilot settings for game development workflows
- Use Copilot Chat for debugging and code exploration
- Recognize Copilot's limitations in game development contexts

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:10 | Copilot's Role | Presentation + Demo |
| 0:10 - 0:20 | Provide Clear Context | Live Coding |
| 0:20 - 0:30 | Iterative Acceptance | Hands-On Exercise |
| 0:30 - 0:40 | Security and Privacy | Discussion + Examples |
| 0:40 - 0:50 | Customize Copilot | Configuration Walkthrough |
| 0:50 - 0:55 | Chat for Debugging | Live Demo |
| 0:55 - 1:00 | Understanding Limitations | Q&A |

---

## Visual Studio Quick Reference

Before we begin, familiarize yourself with the key Copilot interactions in Visual Studio:

| Action | Shortcut | Description |
|--------|----------|-------------|
| Accept inline suggestion | **Tab** | Accept the gray ghost text |
| Dismiss inline suggestion | **Esc** | Reject the current suggestion |
| Next suggestion | **Alt+]** | Cycle to next alternative |
| Previous suggestion | **Alt+[** | Cycle to previous alternative |
| Open Copilot Chat window | **Ctrl+\\, Ctrl+C** | Open the dockable Chat tool window |
| Inline Chat (at cursor) | **Alt+/** | Invoke Copilot directly in the editor |
| Ask Copilot (context menu) | **Right-click → Ask Copilot** | Quick explain/fix from context menu |

> **Note:** Visual Studio uses **Alt+/** for Inline Chat (VS Code uses **Ctrl+I**). The Copilot Chat window is a dockable tool window, not a sidebar panel.

---

## Session 1: Copilot's Role (10 min)

### Learning Objectives
- Understand what GitHub Copilot is and isn't
- See Copilot in action with Godot C++ and GDScript in Visual Studio

### Presentation Points

**What is GitHub Copilot?**
- AI pair programmer powered by large language models
- Trained on public code repositories
- Provides real-time inline suggestions as you type in the Visual Studio editor
- Natively integrated into Visual Studio 2022 (17.14+) — no separate extension required
- Supports C++, GDScript, and 100+ languages

**What Copilot IS:**
- A productivity accelerator
- A learning tool for new APIs
- A boilerplate generator
- A rubber duck that writes code

**What Copilot IS NOT:**
- A replacement for understanding your code
- A guaranteed source of bug-free code
- A substitute for testing
- An expert in your specific project

### Demo: Copilot in Urban Survivor (Visual Studio)

**Setup:** Open the Urban Survivor solution in Visual Studio 2022. Ensure Copilot is enabled via **Tools → Options → GitHub Copilot → General → Enable GitHub Copilot**.

**Demo 1: C++ GDExtension Suggestion**
```cpp
// File: src/combat/weapon.cpp

// Type this comment, watch Copilot suggest the implementation as gray ghost text:
// Calculate damage based on hit zone multiplier and armor
float Weapon::calculate_damage(HitZone zone, float armor) {
    // Copilot suggests damage calculation logic
    // Press Tab to accept, or Alt+] to see alternatives
}
```

**Demo 2: GDScript UI Pattern**
```gdscript
# File: game/scenes/hud.gd

# Connect health signal to update bar
func _ready():
    # Copilot suggests signal connection pattern
    # Press Tab to accept the suggestion
```

**Demo 3: Ask Copilot (Visual Studio Exclusive)**
1. Select the `calculate_damage` function body
2. Right-click → **Ask Copilot** → **Explain**
3. Copilot Chat opens with an explanation of the selected code

> **Visual Studio Feature:** The **Ask Copilot** context menu is a Visual Studio-exclusive feature not available in VS Code. It provides quick access to explanations, fixes, and documentation for any selected code.

### Discussion Questions
1. How might Copilot change your development workflow?
2. What concerns do you have about using AI-generated code?

---

## Session 2: Provide Clear Context for Better Suggestions (10 min)

### Learning Objectives
- Structure code files for optimal Copilot suggestions
- Write effective comments that guide generation
- Understand how file context influences suggestions in Visual Studio

### Key Concepts

**Context Sources (Priority Order in Visual Studio):**
1. **Current file content** — the file you're actively editing
2. **Solution-wide context** — Visual Studio understands your `.sln` and project structure, giving richer context than file-only awareness
3. **Open document tabs** — other files currently open in the editor
4. **File names and paths** — helps Copilot understand module purpose
5. **Comments and docstrings** — direct guidance for the AI
6. **`copilot-instructions.md`** — repository-level custom instructions (see Session 5)
7. **Instruction files** — pattern-matched rules from `.github/instructions/`

> **Visual Studio Advantage:** Visual Studio's solution-aware context means Copilot can understand your project references, build configurations, and cross-project dependencies automatically — a richer context model than file-tab-only awareness.

**Urban Survivor Example: Good vs. Poor Context**

❌ **Poor Context:**
```cpp
// do damage
void apply() {
    // Copilot has no idea what to suggest
}
```

✅ **Good Context:**
```cpp
// Apply damage to target entity using the DamageSystem
// Parameters:
// - target: The Node receiving damage (must have health component)
// - amount: Base damage before armor reduction
// - damage_type: PHYSICAL, FIRE, or RADIATION
// - source: The attacking entity for aggro tracking
void DamageSystem::apply_damage(Node* target, float amount, DamageType type, Node* source) {
    // Copilot now understands the full context
}
```

### Hands-On Exercise (5 min)

**Task**: Open `src/player/player_controller.hpp` in Visual Studio and add context-rich comments for a new method.

```cpp
// Exercise: Add a stamina regeneration method
// Write comments that describe:
// 1. When regeneration occurs (not sprinting, not recently damaged)
// 2. Regeneration rate (from SPEC.md: 5/sec)
// 3. Maximum stamina cap
// Watch what Copilot suggests based on your comments
// Try Alt+] and Alt+[ to cycle through alternative suggestions
```

### Best Practices Checklist
- [ ] Use descriptive file and class names
- [ ] Include parameter descriptions in comments
- [ ] Reference game design values (e.g., "as per SPEC.md")
- [ ] Keep related files open as tabs in Visual Studio for broader context
- [ ] Leverage solution-wide context by having your `.sln` properly configured

---

## Session 3: Use Iterative Acceptance of Suggestions (10 min)

### Learning Objectives
- Accept suggestions fully or partially
- Refine suggestions through iterative prompting
- Know when to reject and re-prompt

### Key Techniques

**Acceptance Levels in Visual Studio:**

| Action | Shortcut (Visual Studio) | Use Case |
|--------|--------------------------|----------|
| Accept full suggestion | **Tab** | Suggestion is correct |
| Accept word | **Ctrl+Right Arrow** | Partial correctness |
| Reject / Dismiss | **Esc** | Suggestion is wrong |
| Next alternative | **Alt+]** | Compare options |
| Previous alternative | **Alt+[** | Compare options |
| Inline Chat for refinement | **Alt+/** | Refine with natural language |

> **Visual Studio Note:** Visual Studio does not currently support accepting a single line from a multi-line suggestion (VS Code supports this with **Ctrl+Enter**). Instead, use **Ctrl+Right Arrow** to accept word-by-word, or dismiss with **Esc** and add more context to get a better suggestion. You can also use **Inline Chat (Alt+/)** to describe the refinement you want in natural language.

**Urban Survivor Example: Iterative Refinement**

```cpp
// Scenario: Implementing enemy detection

// Step 1: Type the function signature
bool AIPerception::can_see_player() {
    // Copilot suggests: return true; (too simple!)
    // Press Esc to dismiss
}

// Step 2: Add more context, let Copilot regenerate
bool AIPerception::can_see_player() {
    // Cast ray from enemy eyes to player, check occlusion
    // Consider detection cone angle (from SPEC: 90 degrees)
    // Copilot now suggests raycast logic — press Tab to accept
}

// Step 3: Place cursor inside the function, press Alt+/ for Inline Chat
// Type: "Add ERR_FAIL_NULL checks for player and navigation agent"
// Step 4: Accept the refined suggestion with Tab
```

### Hands-On Exercise (7 min)

**Task**: Implement `SurvivalStats::regenerate_stamina()` using iterative acceptance.

1. Start with the function signature — see what Copilot suggests
2. Press **Tab** to accept the first suggestion
3. Identify what's missing (delta time? cap check?)
4. Press **Alt+/** for Inline Chat, describe the improvement
5. Or: add a comment above and let Copilot regenerate

```cpp
void SurvivalStats::regenerate_stamina(float delta) {
    // Regenerate stamina at 5 points per second
    // Only if not sprinting and stamina < max_stamina
    // Apply delta time for frame-rate independence
}
```

**Pro Tip:** If Copilot's suggestion is partially right, accept it with **Tab**, then use **Alt+/** (Inline Chat) on the accepted code to refine specific parts. This two-step pattern — accept then refine — is often faster than trying to get a perfect suggestion on the first attempt.

---

## Session 4: Be Mindful of Security and Privacy (10 min)

### Learning Objectives
- Identify sensitive data that shouldn't be in prompts
- Review generated code for security vulnerabilities
- Configure Copilot privacy settings in Visual Studio

### Security Concerns in Game Development

**Never Include in Code/Comments:**
- API keys (server authentication)
- Player credentials or PII
- Proprietary algorithms (anti-cheat, matchmaking secrets)
- Internal server URLs

**Urban Survivor Example: What NOT to Do**

❌ **Dangerous:**
```cpp
// Connect to our game server at https://internal.studio.com/api
// Using API key: sk_live_abc123xyz
void connect_to_server() {
```

✅ **Safe:**
```cpp
// Connect to game server using environment-configured endpoint
// API key loaded from secure credential manager
void connect_to_server() {
```

### Code Review Checklist for Generated Code

**Security Issues to Watch For:**

| Issue | Example in Game Dev | Fix |
|-------|---------------------|-----|
| Unbounded loops | Enemy spawner with no limit | Add MAX_ENEMIES constant |
| Null pointer access | `player->get_health()` without check | `ERR_FAIL_NULL(player)` |
| Hardcoded paths | `"C:/Users/dev/saves/"` | Use `res://` or `user://` |
| SQL injection | Player name in query | Parameterized queries |
| Buffer overflow | Fixed array for inventory | Use `Vector<Item>` |

### Privacy Settings in Visual Studio (3 min walkthrough)

**Configuring Copilot Privacy in Visual Studio:**

Navigate to **Tools → Options → GitHub Copilot** to access all Copilot settings.

**1. Enable/Disable Copilot Globally:**
- **Tools → Options → GitHub Copilot → General → Enable GitHub Copilot** — toggles all Copilot features on/off

**2. Content Exclusions (Organization-Level):**
- GitHub organization administrators can configure **content exclusions** at the organization level via GitHub.com settings
- This prevents Copilot from using specific repository paths as context
- Navigate to: **GitHub.com → Organization Settings → Copilot → Content Exclusions**

```
# Example organization-level content exclusion rules:
# (configured on GitHub.com, not in Visual Studio)
- "/**/secrets/**"
- "/**/config/credentials.*"
- "/**/*.pem"
- "/**/*.key"
```

> **Visual Studio Note:** Unlike VS Code which supports a local `settings.json` to enable/disable Copilot per file type (e.g., `"github.copilot.enable": { "env": false }`), Visual Studio's Copilot toggle is currently a global on/off setting. Per-file-type granularity is achieved through **organization-level content exclusions** configured on GitHub.com, or by using `.copilotignore` at the repository level.

**3. Repository-Level `.copilotignore`:**

Create a `.copilotignore` file in your repository root to exclude sensitive files from Copilot's context:
```
# .copilotignore
*.pem
*.key
config/secrets.json
server/internal/
.env
.env.local
```

**4. Telemetry & Data Settings:**
- **Tools → Options → GitHub Copilot → General** — configure whether code snippets are collected for product improvement
- For enterprise users, data handling is governed by your organization's Copilot Business/Enterprise agreement

---

## Session 5: Customize Copilot for Your Needs (10 min)

### Learning Objectives
- Configure Copilot settings in Visual Studio for game development
- Set up workspace-specific customizations
- Understand the `copilot-instructions.md` file and instruction files

### Configuration Walkthrough

**1. Copilot Settings in Visual Studio:**

Navigate to **Tools → Options → GitHub Copilot** to access:
- **General** — Enable/disable Copilot, configure telemetry
- **Completions** — Adjust inline suggestion behavior
- **Chat** — Configure Copilot Chat window settings

> **Visual Studio Note:** VS Code uses a `settings.json` file where you can toggle Copilot on/off per language (e.g., `"github.copilot.enable": { "cpp": true, "json": false }`). Visual Studio does not support per-language toggles through the UI. Instead, use **content exclusions** and **instruction files** to control Copilot's behavior for specific file types.

**2. Repository-Level Custom Instructions:**

Create `.github/copilot-instructions.md` in your repository root. This file is **automatically loaded** by Visual Studio when the solution is opened and applies to all Copilot interactions:

```markdown
# Urban Survivor - AI Coding Instructions

## Project Overview
- Godot 4.3+ with C++ GDExtension
- Third-person survival shooter

## CRITICAL: Read These Files First
1. docs/ARCHITECTURE.md
2. docs/SPEC.md
3. docs/CODING_STANDARDS.md

## Code Patterns
- Use CharacterBody3D for all moving entities
- Prefer signals over direct function calls
- Always null-check with ERR_FAIL_NULL()
```

> This file works identically in Visual Studio and VS Code — both automatically discover and apply `.github/copilot-instructions.md`.

**3. Instruction Files (Pattern-Matched Rules):**

Create files in `.github/instructions/` with `applyTo` front-matter to automatically apply rules when editing matching files:

```markdown
---
description: 'C++ GDExtension rules for Urban Survivor'
applyTo: '**/*.{cpp,hpp}'
---

**Godot lifecycle rules:**
- Do not create nodes in constructors; use `_ready()`
- Cache node references; never call `get_node()` every frame

**Safety:**
- Always null-check pointers: ERR_FAIL_NULL(ptr)
- Never modify external/godot-cpp/
```

> **Visual Studio Note:** Instruction files are supported in Visual Studio 2022 (17.13+). You can verify which instructions are active via **Tools → Options → GitHub Copilot → Instructions**.

### Urban Survivor Demo

**Show the existing `.github/copilot-instructions.md`:**
- Project overview section
- Build instructions
- Code organization table
- DO / DON'T lists

**Explain how this affects suggestions:**
1. Open a C++ file in Visual Studio
2. Type a new method
3. Note how suggestions follow the project patterns (ERR_FAIL_NULL, signal usage, naming conventions)
4. Open **Tools → Options → GitHub Copilot** to verify the instructions are loaded

**Show the `.github/instructions/` folder:**
1. Open `cpp-gdextension.instructions.md`
2. Point out the `applyTo: '**/*.{cpp,hpp}'` pattern
3. Edit a `.cpp` file — rules from the instruction file apply automatically
4. Edit a `.gd` file — different instruction file applies

---

## Session 6: Copilot Chat for Debugging and Exploration (5 min)

### Learning Objectives
- Use Copilot Chat to explain unfamiliar code
- Debug errors with AI assistance in Visual Studio
- Explore Godot APIs through conversation

### Demo: Debugging a GDExtension Issue

**Opening Copilot Chat:** Press **Ctrl+\\, Ctrl+C** or navigate to **View → GitHub Copilot Chat**.

**Scenario**: Extension not loading in Godot

**Chat Conversation:**
```
User: My GDExtension isn't loading. I see this error in Godot:
"Failed to load dynamic library: liburban_survivor.windows.debug.x86_64.dll"

Copilot: Let's troubleshoot this step by step:

1. Check if the DLL exists at: game/bin/liburban_survivor.windows.debug.x86_64.dll
2. Verify the .gdextension file paths match:
   [libraries]
   windows.debug.x86_64 = "res://bin/liburban_survivor.windows.debug.x86_64.dll"
3. Rebuild after closing Godot:
   cmake --build build --config Debug
4. Check for missing dependencies (Visual C++ Redistributable)
```

### Copilot Chat Interactions in Visual Studio

Visual Studio provides multiple ways to interact with Copilot Chat:

| Interaction | How to Access | Use Case |
|-------------|---------------|----------|
| **Copilot Chat Window** | **Ctrl+\\, Ctrl+C** | Full conversational debugging, exploration |
| **Inline Chat** | **Alt+/** at cursor | Quick edits and explanations in-context |
| **Ask Copilot** | Right-click → **Ask Copilot** | Explain, fix, or document selected code |
| **`#file:` references** | Type `#file:path` in Chat | Attach specific files as context |
| **`@agent` invocation** | Type `@agent-name` in Chat | Invoke custom agents (see Advanced Workshop) |

> **VS Code Difference:** VS Code supports `/explain`, `/fix`, `/tests`, and `/doc` slash commands in Copilot Chat. These specific slash commands are **not available** in Visual Studio's Copilot Chat. Instead, use these equivalent approaches:
>
> | VS Code Slash Command | Visual Studio Equivalent |
> |-----------------------|--------------------------|
> | `/explain` | Select code → Right-click → **Ask Copilot** → **Explain** |
> | `/fix` | Select code → Right-click → **Ask Copilot** → **Fix** |
> | `/tests` | Ask in Copilot Chat: "Generate tests for this function" |
> | `/doc` | Ask in Copilot Chat: "Create documentation for this class" |

### Hands-On (2 min)

**Try asking in the Copilot Chat window (Ctrl+\\, Ctrl+C):**
```
Explain how NavigationAgent3D.get_next_path_position() works
and when I should call it in _physics_process()
```

**Try Inline Chat (Alt+/):**
1. Place your cursor inside a function body
2. Press **Alt+/**
3. Type: "Explain what this function does"
4. Copilot responds inline with an explanation

**Try Ask Copilot:**
1. Select a block of code in the editor
2. Right-click → **Ask Copilot**
3. Choose **Explain** to understand the code, or **Fix** to suggest improvements

---

## Session 7: Understand Limitations (5 min)

### Learning Objectives
- Recognize when Copilot suggestions are wrong
- Know the boundaries of AI code generation
- Apply critical thinking to all suggestions

### Common Limitations in Game Development

**1. Outdated API Knowledge**
```cpp
// Copilot might suggest (WRONG for Godot 4.3):
Vector3 direction = Vector3::FORWARD;

// Correct:
Vector3 direction = Vector3(0, 0, -1);
```
> **Tip:** Use instruction files (`.github/instructions/cpp-gdextension.instructions.md`) to encode Godot 4.3 API corrections. This helps Copilot avoid suggesting deprecated patterns.

**2. Project-Specific Patterns**
```cpp
// Copilot doesn't know your DamageSystem API
// May suggest generic damage logic instead of:
DamageSystem::get_singleton()->apply_damage(target, amount, type, source);
```
> **Tip:** Keep `copilot-instructions.md` up to date with your project's key patterns and singletons. Reference your architecture docs so Copilot learns your API surface.

**3. Performance Anti-Patterns**
```cpp
// Copilot might suggest (INEFFICIENT):
void _process(float delta) {
    Node* player = get_node("/root/Main/Player");  // Every frame!
}

// Should be:
void _ready() {
    player_ref = get_node("/root/Main/Player");
}
```
> **Tip:** Add "Cache node references in `_ready()`; never call `get_node()` every frame" to your instruction files. Copilot will learn to follow this rule.

**4. Missing Null Checks**
```cpp
// Copilot often forgets:
ERR_FAIL_NULL(target);  // Godot safety pattern
```
> **Tip:** Add "Always null-check pointers: `ERR_FAIL_NULL(ptr)`" to your instruction files. This is one of the most impactful rules you can encode.

### Critical Thinking Checklist

Before accepting any suggestion, ask:
- [ ] Does this match our coding standards?
- [ ] Is the Godot API usage correct for 4.3?
- [ ] Are there null checks where needed?
- [ ] Will this perform well at 60 FPS?
- [ ] Does it integrate with our existing systems?

### When to Use Chat vs. Inline Suggestions

| Scenario | Best Tool |
|----------|-----------|
| Quick boilerplate (getters/setters) | Inline suggestions (**Tab**) |
| Complex algorithm design | Copilot Chat (**Ctrl+\\, Ctrl+C**) |
| Refactoring existing code | Inline Chat (**Alt+/**) |
| Understanding unfamiliar code | Ask Copilot (**Right-click**) |
| Debugging build errors | Copilot Chat with error text pasted in |
| Multi-file changes | Copilot Edits (agentic mode in Chat) |

---

## Workshop Summary

### Key Takeaways

1. **Copilot is a tool, not a replacement** — Always understand and review generated code
2. **Context is king** — Better comments, structure, and instruction files = better suggestions
3. **Iterate, don't accept blindly** — Use **Tab**, **Alt+]**, **Esc**, and **Alt+/** to refine
4. **Security first** — Never include secrets; use `.copilotignore` and content exclusions
5. **Customize for your project** — Use `copilot-instructions.md` and instruction files
6. **Chat is powerful** — Use Copilot Chat (**Ctrl+\\, Ctrl+C**), Inline Chat (**Alt+/**), and Ask Copilot (**Right-click**) for debugging and learning
7. **Know the limits** — Especially with Godot 4.3 API changes; encode corrections in instruction files

### Visual Studio vs. VS Code Feature Summary

| Feature | Visual Studio 2022 | VS Code |
|---------|-------------------|---------|
| Inline completions | ✅ **Tab** to accept | ✅ Same |
| Copilot Chat window | ✅ **Ctrl+\\, Ctrl+C** | ✅ Sidebar panel |
| Inline Chat | ✅ **Alt+/** | ✅ **Ctrl+I** |
| Ask Copilot (right-click) | ✅ VS-exclusive | ❌ Not available |
| Per-language toggle | ❌ Not available | ✅ `settings.json` |
| `/explain`, `/fix` commands | ❌ Use right-click menu | ✅ Slash commands |
| Accept single line | ❌ Use word-by-word | ✅ **Ctrl+Enter** |
| `copilot-instructions.md` | ✅ Supported | ✅ Same |
| Instruction files | ✅ Supported (17.13+) | ✅ Same |
| Solution-wide context | ✅ `.sln` aware | ❌ Workspace folders only |

### Homework Before Intermediate Workshop

1. Read your project's `.github/copilot-instructions.md` file
2. Try implementing one small feature using iterative acceptance (**Tab**, **Esc**, **Alt+]**)
3. Open the Copilot Chat window (**Ctrl+\\, Ctrl+C**) and ask it to explain a Godot API you're unfamiliar with
4. Try the **Ask Copilot** right-click menu on an existing function
5. Identify one security concern in existing code

---

## Resources

- [GitHub Copilot in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-install-and-states)
- [Copilot Chat in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-chat)
- [Copilot Completions in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot)
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Custom Instructions for Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
- [Urban Survivor Coding Standards](../../docs/CODING_STANDARDS.md)
- [Key Definitions & Best Practices](00-key-definitions-and-best-practices.md)
- [Godot 4.3 API Changes](https://docs.godotengine.org/en/stable/tutorials/migrating/)

---

*Next Workshop: [Intermediate - Prompting & Code Generation](02-intermediate-workshop.md)*
