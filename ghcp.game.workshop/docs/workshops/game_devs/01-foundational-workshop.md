# Workshop 1: Foundational
## GitHub Copilot Essentials for Game Developers

**Duration**: 1 Hour  
**Level**: Beginner  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)  

---

## Workshop Objectives

By the end of this workshop, participants will:
- Understand GitHub Copilot's role as an AI pair programmer
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

## Session 1: Copilot's Role (10 min)

### Learning Objectives
- Understand what GitHub Copilot is and isn't
- See Copilot in action with Godot C++ and GDScript

### Presentation Points

**What is GitHub Copilot?**
- AI pair programmer powered by large language models
- Trained on public code repositories
- Provides real-time suggestions in your IDE
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

### Demo: Copilot in Urban Survivor

**Demo 1: C++ GDExtension Suggestion**
```cpp
// File: src/combat/weapon.cpp

// Type this comment, watch Copilot suggest the implementation:
// Calculate damage based on hit zone multiplier and armor
float Weapon::calculate_damage(HitZone zone, float armor) {
    // Copilot suggests damage calculation logic
}
```

**Demo 2: GDScript UI Pattern**
```gdscript
# File: game/scenes/hud.gd

# Connect health signal to update bar
func _ready():
    # Copilot suggests signal connection pattern
```

### Discussion Questions
1. How might Copilot change your development workflow?
2. What concerns do you have about using AI-generated code?

---

## Session 2: Provide Clear Context for Better Suggestions (10 min)

### Learning Objectives
- Structure code files for optimal Copilot suggestions
- Write effective comments that guide generation
- Understand how file context influences suggestions

### Key Concepts

**Context Sources (Priority Order):**
1. Current file content
2. Open tabs in editor
3. File names and paths
4. Comments and docstrings
5. Recent edits

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

**Task**: Open `src/player/player_controller.hpp` and add context-rich comments for a new method.

```cpp
// Exercise: Add a stamina regeneration method
// Write comments that describe:
// 1. When regeneration occurs (not sprinting, not recently damaged)
// 2. Regeneration rate (from SPEC.md: 5/sec)
// 3. Maximum stamina cap
// Watch what Copilot suggests based on your comments
```

### Best Practices Checklist
- [ ] Use descriptive file and class names
- [ ] Include parameter descriptions in comments
- [ ] Reference game design values (e.g., "as per SPEC.md")
- [ ] Keep related files open in tabs

---

## Session 3: Use Iterative Acceptance of Suggestions (10 min)

### Learning Objectives
- Accept suggestions word-by-word or line-by-line
- Refine suggestions through partial acceptance
- Know when to reject and re-prompt

### Key Techniques

**Acceptance Levels:**
| Action | Shortcut (VS Code) | Use Case |
|--------|---------------------|----------|
| Accept full suggestion | `Tab` | Suggestion is correct |
| Accept word | `Ctrl+Right Arrow` | Partial correctness |
| Accept line | `Ctrl+Enter` | Multi-line refinement |
| Reject | `Esc` | Suggestion is wrong |
| See alternatives | `Alt+]` / `Alt+[` | Compare options |

**Urban Survivor Example: Iterative Refinement**

```cpp
// Scenario: Implementing enemy detection

// Step 1: Type the function signature
bool AIPerception::can_see_player() {
    // Copilot suggests: return true; (too simple!)
}

// Step 2: Add more context, regenerate
bool AIPerception::can_see_player() {
    // Cast ray from enemy eyes to player, check occlusion
    // Consider detection cone angle (from SPEC: 90 degrees)
    // Copilot now suggests raycast logic
}

// Step 3: Accept raycast setup, modify distance check
// Step 4: Add null checks (ERR_FAIL_NULL pattern)
```

### Hands-On Exercise (7 min)

**Task**: Implement `SurvivalStats::regenerate_stamina()` using iterative acceptance.

1. Start with the function signature
2. Accept Copilot's first suggestion
3. Identify what's missing (delta time? cap check?)
4. Add a comment, get a new suggestion
5. Combine the best parts

```cpp
void SurvivalStats::regenerate_stamina(float delta) {
    // Regenerate stamina at 5 points per second
    // Only if not sprinting and stamina < max_stamina
    // Apply delta time for frame-rate independence
}
```

---

## Session 4: Be Mindful of Security and Privacy (10 min)

### Learning Objectives
- Identify sensitive data that shouldn't be in prompts
- Review generated code for security vulnerabilities
- Configure Copilot privacy settings

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

### Privacy Settings (3 min walkthrough)

**VS Code Settings:**
```json
{
    "github.copilot.enable": {
        "*": true,
        "plaintext": false,  // Disable for notes
        "env": false         // Disable for .env files
    }
}
```

**Exclude Files from Copilot Context:**
```
// .copilotignore
*.pem
*.key
config/secrets.json
server/internal/
```

---

## Session 5: Customize Copilot for Your Needs (10 min)

### Learning Objectives
- Configure Copilot settings for game development
- Set up workspace-specific customizations
- Understand the copilot-instructions.md file

### Configuration Walkthrough

**1. Enable/Disable by File Type:**
```json
// settings.json
{
    "github.copilot.enable": {
        "*": true,
        "cpp": true,
        "gdscript": true,
        "json": false,      // Don't suggest for data files
        "markdown": true    // Helpful for docs
    }
}
```

**2. Project-Level Instructions:**

Create `.github/copilot-instructions.md`:
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

### Urban Survivor Demo

**Show the existing `.github/copilot-instructions.md`:**
- Project overview section
- Build instructions
- Code organization table
- DO / DON'T lists

**Explain how this affects suggestions:**
1. Open a C++ file
2. Type a new method
3. Note how suggestions follow the project patterns

---

## Session 6: Copilot Chat for Debugging and Exploration (5 min)

### Learning Objectives
- Use Copilot Chat to explain unfamiliar code
- Debug errors with AI assistance
- Explore Godot APIs through conversation

### Demo: Debugging a GDExtension Issue

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

### Quick Chat Commands for Game Dev

| Command | Use Case |
|---------|----------|
| `/explain` | Understand complex Godot API calls |
| `/fix` | Suggest fixes for selected error |
| `/tests` | Generate test cases for a function |
| `/doc` | Create documentation for a class |

### Hands-On (2 min)

**Try asking Copilot Chat:**
```
Explain how NavigationAgent3D.get_next_path_position() works
and when I should call it in _physics_process()
```

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

**2. Project-Specific Patterns**
```cpp
// Copilot doesn't know your DamageSystem API
// May suggest generic damage logic instead of:
DamageSystem::get_singleton()->apply_damage(target, amount, type, source);
```

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

**4. Missing Null Checks**
```cpp
// Copilot often forgets:
ERR_FAIL_NULL(target);  // Godot safety pattern
```

### Critical Thinking Checklist

Before accepting any suggestion, ask:
- [ ] Does this match our coding standards?
- [ ] Is the Godot API usage correct for 4.3?
- [ ] Are there null checks where needed?
- [ ] Will this perform well at 60 FPS?
- [ ] Does it integrate with our existing systems?

---

## Workshop Summary

### Key Takeaways

1. **Copilot is a tool, not a replacement** - Always understand and review generated code
2. **Context is king** - Better comments and structure = better suggestions
3. **Iterate, don't accept blindly** - Use partial acceptance and refinement
4. **Security first** - Never include secrets, always review for vulnerabilities
5. **Customize for your project** - Use copilot-instructions.md
6. **Chat is powerful** - Use it for debugging and learning APIs
7. **Know the limits** - Especially with Godot 4.3 API changes

### Homework Before Intermediate Workshop

1. Read your project's `copilot-instructions.md` file
2. Try implementing one small feature using iterative acceptance
3. Use Copilot Chat to explain a Godot API you're unfamiliar with
4. Identify one security concern in existing code

---

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Copilot in VS Code](https://code.visualstudio.com/docs/copilot/overview)
- [Urban Survivor Coding Standards](../../docs/CODING_STANDARDS.md)
- [Godot 4.3 API Changes](https://docs.godotengine.org/en/stable/tutorials/migrating/)

---

*Next Workshop: [Intermediate - Prompting & Code Generation](02-intermediate-workshop.md)*
