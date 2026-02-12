# Workshop 2: Intermediate
## Prompting, Chat, and Code Generation Mastery

**Duration**: 1 Hour  
**Level**: Intermediate  
**IDE**: Visual Studio 2022 (17.14+) / Visual Studio 2026 Preview with GitHub Copilot  
**Prerequisites**: Foundational Workshop  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)  
**Date**: January 2026

> **Prerequisite:** This workshop assumes you have completed the Foundational Workshop and have Visual Studio 2022 (17.14+) or Visual Studio 2026 Preview installed. GitHub Copilot and Copilot Chat are first-party components of the IDE — no separate extension is required. You must be signed in with a GitHub account that has an active Copilot license.

---

## Workshop Objectives

By the end of this workshop, participants will:
- Write effective prompts for complex code generation
- Use inline code suggestions efficiently in Visual Studio
- Get meaningful code explanations from Copilot Chat and Inline Chat
- Generate code from descriptive comments
- Refactor existing code with AI assistance
- Apply Few-Shot prompting techniques
- Generate unit tests and debug with Copilot
- Understand Copilot's privacy and data handling
- Use Copilot CLI for command-line workflows

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:08 | Inline Code Suggestions | Demo + Practice |
| 0:08 - 0:16 | Prompting Fundamentals | Presentation |
| 0:16 - 0:24 | Code Explanations | Hands-On |
| 0:24 - 0:32 | Comment-Based Generation | Live Coding |
| 0:32 - 0:38 | Code Refactoring | Exercise |
| 0:38 - 0:44 | Copilot Chat Deep Dive | Demo |
| 0:44 - 0:50 | Few-Shot Prompting | Practice |
| 0:50 - 0:54 | Unit Testing & Debugging | Live Demo |
| 0:54 - 0:58 | Privacy & Data Handling | Discussion |
| 0:58 - 1:00 | Copilot CLI | Quick Tour |

---

## Session 1: Inline Code Suggestions (8 min)

### Learning Objectives
- Maximize inline suggestion quality
- Navigate between alternative suggestions
- Understand ghost text and Inline Chat in Visual Studio

### Inline Suggestion Types

**Ghost Text (Inline Completions):**

As you type in the Visual Studio editor, Copilot displays gray "ghost text" suggestions. This is the primary way Copilot offers completions:

```cpp
void PlayerController::update_stamina(float delta) {
    if (is_sprinting && current_stamina > 0) {
        current_stamina -= sprint_stamina_cost * delta; // Copilot shows gray text here
    }
}
```

**Inline Chat (Alt+/):**

For more complex generation, press **Alt+/** to open Inline Chat directly at your cursor. This lets you describe what you want in natural language, and Copilot generates code in place with a diff preview you can accept or discard.

> **Visual Studio Note:** VS Code uses `Ctrl+Enter` to open a "Suggestion Panel" with multiple alternatives. This panel does **not** exist in Visual Studio. Instead, use **Alt+]** / **Alt+[** to cycle through alternative inline suggestions, or use **Inline Chat** (`Alt+/`) for guided generation.

### Keyboard Shortcuts Reference

| Action | Visual Studio Shortcut | Description |
|--------|------------------------|-------------|
| Accept suggestion | **Tab** | Accept ghost text |
| Accept next word | **Ctrl+→** | Accept one word at a time |
| Next suggestion | **Alt+]** | Cycle to next alternative |
| Previous suggestion | **Alt+[** | Cycle to previous alternative |
| Dismiss | **Esc** | Clear current suggestion |
| Open Copilot Chat | **Ctrl+\\, Ctrl+C** | Dockable Chat tool window |
| Inline Chat | **Alt+/** | Copilot prompt at cursor |
| Ask Copilot | **Right-click → Ask Copilot** | Context menu quick action |

### Hands-On Exercise (4 min)

**File**: `src/ai/enemy_ai.cpp`

```cpp
// Task: Complete the patrol behavior
void EnemyAI::update_patrol_state(float delta) {
    // 1. Type this, wait for ghost text suggestion
    if (has_reached_patrol_point()) {
        // 2. Copilot suggests next patrol point logic
    }
    
    // 3. Use Alt+] to see alternative implementations
    // 4. Accept the best one with Tab
    // 5. Try Alt+/ to open Inline Chat and ask:
    //    "Add patrol timeout that transitions to idle after 30 seconds"
}
```

**Observe:**
- How does the suggestion change based on method names?
- Do alternatives (via **Alt+]**) differ in patrol point selection strategy?
- How does Inline Chat (**Alt+/**) compare to ghost text for complex logic?

---

## Session 2: Prompting Fundamentals (8 min)

### Learning Objectives
- Structure prompts for optimal results
- Use the CORE prompting framework
- Apply prompting to game development scenarios

### Where to Enter Prompts in Visual Studio

| Method | When to Use |
|--------|-------------|
| **Copilot Chat window** (`Ctrl+\, Ctrl+C`) | Multi-turn conversations, complex prompts, project-wide questions |
| **Inline Chat** (`Alt+/`) | Quick generation or refactoring at cursor position |
| **Ask Copilot** (right-click context menu) | Explain or fix selected code |
| **Comments in code** | Trigger ghost text suggestions with structured comments |

### The CORE Prompting Framework

| Element | Description | Example |
|---------|-------------|---------|
| **C**ontext | Background information | "In our Godot 4.3 survival shooter..." |
| **O**bjective | What you want | "Implement enemy flanking behavior" |
| **R**equirements | Constraints and specifics | "Must use NavigationAgent3D, max 30ms" |
| **E**xamples | Input/output patterns | "Similar to existing patrol behavior" |

### Urban Survivor Prompting Examples

**Basic Prompt:**
```
Add a reload function to the weapon
```

**CORE-Enhanced Prompt:**
```
Context: Urban Survivor is a Godot 4.3 third-person shooter using C++ GDExtension.
The Weapon class extends Node3D and uses signals for UI communication.

Objective: Implement the reload_weapon() method in src/combat/weapon.cpp.

Requirements:
- Check if magazine is already full (skip reload)
- Check if player has reserve ammo in inventory
- Play reload animation via AnimationPlayer
- Transfer ammo from reserve to magazine
- Emit "reload_started" and "reload_complete" signals
- Reload time varies by weapon type (pistol: 1.5s, rifle: 2.5s)

Example signal pattern from existing code:
emit_signal("weapon_fired", current_ammo, max_ammo);
```

### Prompting Tips for Game Dev

**1. Reference Documentation:**
```
According to docs/SPEC.md Section 5.2, weapons have these properties...
```

**2. Specify Engine Version:**
```
Using Godot 4.3 API (not 3.x), implement...
```

**3. Include Performance Constraints:**
```
Must run in under 0.5ms per call, suitable for _physics_process
```

**4. Describe Integration Points:**
```
This method will be called by GameManager when player presses R.
It should update HUD via the existing ammo_changed signal.
```

**5. Use File References in Visual Studio Chat:**
```
#file:src/combat/weapon.hpp Implement the reload_weapon() method
based on the declarations in this header.
```

> **Visual Studio Tip:** In the Copilot Chat window, use `#file:path` to attach specific files as context. This gives Copilot precise knowledge about your types and signatures without needing to paste code.

---

## Session 3: Code Explanations (8 min)

### Learning Objectives
- Get explanations of complex code sections
- Understand unfamiliar Godot APIs
- Use explanations for learning and documentation

### Copilot Chat Commands for Explanations

| Method | How to Use in Visual Studio |
|--------|-----------------------------|
| **Ask Copilot (context menu)** | Select code → right-click → **Ask Copilot** → "Explain this" |
| **Inline Chat** | Select code → press **Alt+/** → type "Explain this code" |
| **Copilot Chat window** | Select code → open Chat (`Ctrl+\, Ctrl+C`) → `/explain` or ask directly |
| **Slash command** | Type `/explain` in Chat window with code selected |

> **Visual Studio Note:** The `/explain` slash command works in the Copilot Chat window. In VS Code, `@workspace /explain` adds project-wide context — in Visual Studio, the Chat window automatically has solution context, so you can simply use `/explain` or ask directly.

### Demo: Explaining NavigationAgent3D Code

**Select this code, then right-click → Ask Copilot → "Explain this":**

```cpp
void EnemyAI::update_chase_state(float delta) {
    if (!navigation_agent) return;
    
    Vector3 target_pos = player->get_global_position();
    navigation_agent->set_target_position(target_pos);
    
    if (navigation_agent->is_navigation_finished()) {
        enter_attack_state();
        return;
    }
    
    Vector3 next_pos = navigation_agent->get_next_path_position();
    Vector3 direction = (next_pos - get_global_position()).normalized();
    velocity = direction * chase_speed;
    move_and_slide();
}
```

**Copilot Explanation Output:**
```
This method handles the enemy's chase state in the AI state machine:

1. Safety check for navigation agent existence
2. Sets the player's current position as the navigation target
3. If navigation is complete (enemy reached player), transitions to attack state
4. Otherwise, calculates the next waypoint on the path
5. Computes direction vector toward that waypoint
6. Sets velocity and calls move_and_slide() for physics-based movement

Key Godot APIs used:
- NavigationAgent3D.set_target_position(): Requests path calculation
- NavigationAgent3D.get_next_path_position(): Returns next waypoint
- CharacterBody3D.move_and_slide(): Handles collision response
```

### Hands-On Exercise (4 min)

**Task**: Use Copilot Chat to explain this damage calculation:

```cpp
float DamageSystem::calculate_final_damage(float base_damage, HitZone zone, float armor, float distance) {
    float zone_mult = zone == HEAD ? 2.5f : (zone == TORSO ? 1.0f : 0.7f);
    float armor_reduction = Math::clamp(1.0f - (armor * 0.01f), 0.2f, 1.0f);
    float falloff = Math::clamp(1.0f - ((distance - 10.0f) / 40.0f), 0.5f, 1.0f);
    return base_damage * zone_mult * armor_reduction * falloff;
}
```

**Questions to Ask:**
1. "What is the maximum damage multiplier for a headshot?"
2. "At what distance does damage falloff begin?"
3. "What's the minimum armor effectiveness?"

---

## Session 4: Comment-Based Generation (8 min)

### Learning Objectives
- Write comments that generate accurate code
- Use structured comment patterns
- Guide multi-step implementations

### Comment Patterns That Work

**Pattern 1: Single-Line Intent**
```cpp
// Check if player is within attack range and has line of sight
bool can_attack = // Copilot completes
```

**Pattern 2: Multi-Line Specification**
```cpp
// Find the nearest cover point that:
// 1. Is within 15 meters of current position
// 2. Blocks line of sight to the player
// 3. Is navigable via NavigationServer3D
// 4. Is not already occupied by another enemy
Vector3 find_cover_point() {
    // Copilot generates full implementation
}
```

**Pattern 3: Reference Implementation**
```cpp
// Similar to the existing patrol_points selection logic,
// but for cover points. Use the same scoring algorithm
// but prioritize protection angle over distance.
```

### Live Coding Demo (4 min)

**Task**: Generate a loot drop system using comments

```cpp
// src/world/loot_spawner.cpp

/tea
void LootSpawner::spawn_loot(Vector3 position, int enemy_tier) {
    // Watch Copilot generate the implementation
}
```

### Hands-On Exercise (4 min)

**Create your own comment-driven generation:**

```cpp
// File: src/survival/survival_stats.cpp

// Apply radiation damage over time
// - Damage starts at 1 HP/sec at radiation level 1
// - Each level doubles the damage (2, 4, 8, 16...)
// - Emit "radiation_damage" signal with current health
// - If health drops below 25%, emit "radiation_critical" signal
// - Called every physics frame with delta time
void SurvivalStats::apply_radiation_damage(float delta) {
    // Let Copilot generate based on your comments
}
```

---

## Session 5: Code Refactoring (6 min)

### Learning Objectives
- Refactor code using Copilot suggestions
- Apply design patterns with AI assistance
- Improve code quality iteratively

### Refactoring Methods in Visual Studio

| Method | How to Use |
|--------|------------|
| **Inline Chat** (`Alt+/`) | Select code → `Alt+/` → "Refactor this to use..." |
| **Ask Copilot** (context menu) | Select code → right-click → **Ask Copilot** → describe refactoring |
| **Chat `/fix`** | Select code → `/fix` in Chat window |
| **Chat `/optimize`** | Select code → `/optimize` in Chat window |
| **Copilot Edits** | For multi-file refactoring across the solution |

> **Visual Studio Feature:** The `/optimize` slash command is available in Visual Studio's Copilot Chat and specifically targets performance improvements. **Copilot Edits** (available in VS 2022 17.14+ and VS 2026) enables agentic multi-file refactoring — Copilot plans and applies changes across multiple files in your solution.

### Demo: Refactoring Enemy State Machine

**Before (Monolithic):**
```cpp
void EnemyAI::update(float delta) {
    switch (current_state) {
        case IDLE:
            // 50 lines of idle logic
            break;
        case PATROL:
            // 80 lines of patrol logic
            break;
        case CHASE:
            // 100 lines of chase logic
            break;
        // ... more states
    }
}
```

**Prompt:**
```
Refactor this state machine to use separate methods for each state.
Each state method should be named update_[state]_state(float delta).
Add transition methods like enter_[state]_state() for state setup.
Follow the existing pattern in docs/ARCHITECTURE.md.
```

**After (Refactored):**
```cpp
void EnemyAI::update(float delta) {
    switch (current_state) {
        case IDLE: update_idle_state(delta); break;
        case PATROL: update_patrol_state(delta); break;
        case CHASE: update_chase_state(delta); break;
        case ATTACK: update_attack_state(delta); break;
        case FLEE: update_flee_state(delta); break;
    }
}

void EnemyAI::enter_chase_state() {
    current_state = CHASE;
    navigation_agent->set_target_position(player->get_global_position());
    emit_signal("state_changed", "chase");
}

void EnemyAI::update_chase_state(float delta) {
    // Clean, focused chase logic
}
```

### Hands-On Exercise (4 min)

**Task**: Refactor this inventory code:

```cpp
// Current: Repeated code for different item types
void Inventory::add_item(Item* item) {
    if (item->type == AMMO) {
        for (int i = 0; i < items.size(); i++) {
            if (items[i]->id == item->id) {
                items[i]->quantity += item->quantity;
                delete item;
                return;
            }
        }
        items.push_back(item);
    } else if (item->type == WEAPON) {
        // Similar stacking logic
    } else if (item->type == CONSUMABLE) {
        // Similar stacking logic
    }
}
```

**Prompt to try:**
```
Refactor this to eliminate code duplication.
Use a single add_stackable_item method for stackable items.
Weapons should not stack. Use the Item::is_stackable() property.
```

---

## Session 6: Copilot Chat Deep Dive (6 min)

### Learning Objectives
- Master Copilot Chat in Visual Studio (Chat window, Inline Chat, Ask Copilot)
- Use context references and slash commands effectively
- Create multi-turn conversations for complex tasks

### Copilot Chat Surfaces in Visual Studio

| Surface | Shortcut | Best For |
|---------|----------|----------|
| **Copilot Chat window** | `Ctrl+\, Ctrl+C` | Multi-turn conversations, project-wide questions, complex prompts |
| **Inline Chat** | `Alt+/` | Quick edits, generation, or explanations at cursor |
| **Ask Copilot** | Right-click → Ask Copilot | One-shot explain/fix for selected code |

> **Visual Studio vs. VS Code:** VS Code uses **chat participants** (`@workspace`, `@vscode`, `@terminal`) to scope context. Visual Studio does **not** use these participants. Instead, the Chat window automatically has **solution-wide context**. You use **context references** (`#file:`, `#selection`, `#solution`) to provide targeted context, and **custom agents** (`@agent-name`) for domain expertise.

### Context References (Visual Studio)

| Reference | Purpose | Example |
|-----------|---------|---------|
| `#file:path` | Attach a specific file | `#file:src/combat/weapon.hpp explain the reload method` |
| `#selection` | Reference selected code | `#selection refactor this to use a strategy pattern` |
| `#solution` | Scope to entire solution | `#solution how is damage calculated?` |
| `@agent-name` | Invoke a custom agent | `@combat-systems implement hit zone detection` |

### Slash Commands (Visual Studio)

| Command | Description |
|---------|-------------|
| `/explain` | Explain selected code |
| `/fix` | Fix problems in selection |
| `/tests` | Generate unit tests |
| `/doc` | Generate documentation |
| `/optimize` | Optimize for performance |

> **Not Available in Visual Studio:** The `/new` scaffolding command and `/clear` command are VS Code-specific. In Visual Studio, use **File → New** for scaffolding and the **clear button** (🗑️) in the Chat window to reset conversation history.

### Demo: Multi-Turn Conversation

Open the Copilot Chat window (`Ctrl+\, Ctrl+C`) and try this conversation:

```
User: #solution How does the player take damage?

Copilot: In Urban Survivor, player damage flows through:
1. DamageSystem.apply_damage() receives the hit
2. Checks hit zones (HEAD/TORSO/LIMBS multipliers)
3. Applies armor reduction
4. Updates PlayerController.health
5. Emits "player_damaged" signal for HUD

User: #file:src/combat/damage_system.cpp Show me where the armor calculation happens

Copilot: In src/combat/damage_system.cpp line 45:
[shows relevant code]

User: Can you add damage resistance for the RADIATION damage type?

Copilot: I'll add radiation resistance to the damage calculation:
[provides code suggestion with diff preview]
```

> **Visual Studio Tip:** Notice the use of `#solution` and `#file:` to provide targeted context. The Chat window remembers your conversation history within a session, enabling powerful multi-turn refinement.

---

## Session 7: Few-Shot Prompting (6 min)

### Learning Objectives
- Use examples to guide generation style
- Create consistent code patterns
- Apply few-shot for game-specific conventions

### What is Few-Shot Prompting?

Provide 2-3 examples of the pattern you want, then request a new instance. This technique works in both the **Copilot Chat window** and **Inline Chat** in Visual Studio.

### Demo: Signal Pattern Consistency

```
I need to add signals to the Inventory class following our project pattern.

Example 1 - Existing signal in Weapon class:
ADD_SIGNAL(MethodInfo("weapon_fired",
    PropertyInfo(Variant::INT, "current_ammo"),
    PropertyInfo(Variant::INT, "max_ammo")));

Example 2 - Existing signal in SurvivalStats:
ADD_SIGNAL(MethodInfo("health_changed",
    PropertyInfo(Variant::FLOAT, "current_health"),
    PropertyInfo(Variant::FLOAT, "max_health")));

Example 3 - Existing signal in EnemyAI:
ADD_SIGNAL(MethodInfo("state_changed",
    PropertyInfo(Variant::STRING, "new_state"),
    PropertyInfo(Variant::STRING, "old_state")));

Now create signals for Inventory:
1. item_added - when an item is added to inventory
2. item_removed - when an item is removed
3. item_used - when a consumable is used
4. inventory_full - when cannot add more items
```

**Result:**
```cpp
ADD_SIGNAL(MethodInfo("item_added",
    PropertyInfo(Variant::STRING, "item_id"),
    PropertyInfo(Variant::INT, "quantity"),
    PropertyInfo(Variant::INT, "slot_index")));

ADD_SIGNAL(MethodInfo("item_removed",
    PropertyInfo(Variant::STRING, "item_id"),
    PropertyInfo(Variant::INT, "quantity")));

ADD_SIGNAL(MethodInfo("item_used",
    PropertyInfo(Variant::STRING, "item_id"),
    PropertyInfo(Variant::INT, "remaining")));

ADD_SIGNAL(MethodInfo("inventory_full",
    PropertyInfo(Variant::STRING, "rejected_item_id")));
```

### Hands-On Exercise (3 min)

**Task**: Use few-shot to generate enemy state transitions:

```
Following the pattern from EnemyAI:

Example 1:
void EnemyAI::enter_chase_state() {
    current_state = CHASE;
    play_animation("run");
    emit_signal("state_changed", "chase", get_state_name(previous_state));
}

Example 2:
void EnemyAI::enter_attack_state() {
    current_state = ATTACK;
    play_animation("attack_ready");
    emit_signal("state_changed", "attack", get_state_name(previous_state));
}

Now generate: enter_flee_state() and enter_cover_state()
```

---

## Session 8: Unit Testing & Debugging (4 min)

### Learning Objectives
- Generate unit tests with Copilot in Visual Studio
- Debug code issues with AI assistance
- Create test cases from specifications

### Test Generation with /tests

**In Visual Studio:** Select the function, then use one of these methods:
1. **Chat window:** `/tests` slash command (`Ctrl+\, Ctrl+C` → type `/tests`)
2. **Inline Chat:** `Alt+/` → "Generate unit tests for this function"
3. **Ask Copilot:** Right-click → **Ask Copilot** → "Generate tests"

**Select this function and use `/tests`:**

```cpp
float DamageSystem::calculate_final_damage(float base, HitZone zone, float armor, float distance) {
    float zone_mult = zone == HEAD ? 2.5f : (zone == TORSO ? 1.0f : 0.7f);
    float armor_reduction = Math::clamp(1.0f - (armor * 0.01f), 0.2f, 1.0f);
    float falloff = Math::clamp(1.0f - ((distance - 10.0f) / 40.0f), 0.5f, 1.0f);
    return base * zone_mult * armor_reduction * falloff;
}
```

**Generated Tests:**
```cpp
// Test headshot multiplier
TEST_CASE("Headshot deals 2.5x damage") {
    float damage = DamageSystem::calculate_final_damage(100.0f, HEAD, 0.0f, 5.0f);
    CHECK(damage == 250.0f);
}

// Test armor reduction
TEST_CASE("Full armor reduces damage by 80%") {
    float damage = DamageSystem::calculate_final_damage(100.0f, TORSO, 100.0f, 5.0f);
    CHECK(damage == 20.0f);  // 100 * 1.0 * 0.2 * 1.0
}

// Test distance falloff
TEST_CASE("Damage at 50m is 50% of base") {
    float damage = DamageSystem::calculate_final_damage(100.0f, TORSO, 0.0f, 50.0f);
    CHECK(damage == 50.0f);  // falloff kicks in after 10m
}
```

### Debugging with Copilot Chat

**Scenario**: Test failing, unexpected damage value

In Visual Studio, you can paste error output directly into the Copilot Chat window or use **Ask Copilot** on code that produces unexpected results:

```
User: This test is failing:
CHECK(damage == 250.0f) but got 225.0f

Here's the function:
[paste function]

Copilot: The discrepancy is caused by distance falloff.
Your test uses distance 5.0f, but the function applies:
- falloff = 1.0 - ((5.0 - 10.0) / 40.0) = 1.0 - (-0.125) = 1.125

Wait, that should clamp to 1.0... Let me check the clamp order.
Actually, the issue is armor_reduction is applied even with armor=0:
- armor_reduction = 1.0 - (0 * 0.01) = 1.0 ✓

Let me recalculate: 100 * 2.5 * 1.0 * 0.9 = 225
The falloff at 5m is: 1.0 - ((5.0 - 10.0) / 40.0) = 1.125, clamped to 1.0

I see the issue now - check if zone_mult values are correct in your enum...
```

> **Visual Studio Debugging Tip:** During a debug session, you can hover over a variable, then click **Ask Copilot** in the DataTip to ask about unexpected values. You can also copy the **Output window** or **Error List** content and paste it directly into the Copilot Chat window for diagnosis.

---

## Session 9: Privacy & Data Handling (4 min)

### Learning Objectives
- Understand what data Copilot sends and retains
- Configure privacy settings in Visual Studio
- Apply responsible AI practices in game development

### How Copilot Handles Your Code

| Aspect | Details |
|--------|---------|
| **Prompt data** | Copilot sends the current file context (surrounding code, file name, language) to generate suggestions |
| **Telemetry** | Accepted/rejected suggestions may be logged for quality improvements (configurable) |
| **Code retention** | With **Copilot for Business/Enterprise**, prompts and suggestions are **not** retained or used to train models |
| **Local processing** | No code is stored on GitHub servers beyond the request/response cycle (Business/Enterprise) |

### Configuring Privacy in Visual Studio

Navigate to **Tools → Options → GitHub Copilot → General** to configure:

| Setting | Recommendation |
|---------|----------------|
| **Allow Copilot telemetry** | Review your organization's policy; Business/Enterprise plans have stricter defaults |
| **Content exclusions** | Use `.copilotignore` files or repository settings to exclude sensitive files from Copilot context |
| **Suggestion matching** | Enable "block suggestions matching public code" for IP protection |

> **Visual Studio Note:** In Visual Studio 2022 (17.14+) and VS 2026, privacy settings are found under **Tools → Options → GitHub Copilot**. Organization admins can enforce content exclusion policies at the GitHub organization level that apply regardless of local settings.

### Best Practices for Game Development

1. **Exclude secrets:** Never put API keys, server credentials, or encryption keys in files Copilot can read
2. **Review generated code:** Copilot may suggest patterns from public repos — always review for licensing compliance
3. **Sensitive game logic:** For proprietary algorithms (e.g., anti-cheat, matchmaking), consider using `.copilotignore` to exclude those files
4. **Team policy:** Establish team guidelines on when to accept Copilot suggestions for security-critical code (e.g., authentication, payment)

### `.copilotignore` Example

Create a `.copilotignore` file at the repository root (syntax is like `.gitignore`):

```
# Exclude server credentials and secrets
config/secrets/
*.pem
*.key

# Exclude proprietary anti-cheat logic
src/anticheat/

# Exclude paid asset licenses
assets/licenses/
```

---

## Session 10: Copilot CLI (2 min)

### Learning Objectives
- Use Copilot for command-line suggestions
- Generate build and run commands
- Integrate with game development workflows

> **Note:** Copilot CLI is a GitHub CLI extension that runs in your terminal (PowerShell, Command Prompt, or Windows Terminal). It is independent of Visual Studio and complements the IDE-based Copilot experience. You can also use Visual Studio's built-in **Developer PowerShell** or **Developer Command Prompt** (accessible via **Tools → Command Line**) to run these commands.

### Quick Tour

**Installation:**
```bash
gh extension install github/gh-copilot
```

**Usage Examples:**

```bash
# Explain a command
gh copilot explain "cmake -B build -G 'Visual Studio 17 2022'"

# Suggest a command
gh copilot suggest "build godot gdextension for windows release"
# Output: cmake --build build --config Release

# Get help with Godot CLI
gh copilot suggest "run godot project headlessly"
# Output: godot --headless --path game/
```

### Game Dev CLI Tasks

| Task | Command to Ask |
|------|----------------|
| Build extension | "build cmake project in release mode" |
| Export game | "export godot project for windows" |
| Run tests | "run godot scene tests headlessly" |
| Package release | "create zip of release build" |

---

## Workshop Summary

### Key Takeaways

1. **Inline suggestions** are faster with Visual Studio keyboard shortcuts (**Tab**, **Alt+]**, **Alt+[**)
2. **CORE framework** (Context, Objective, Requirements, Examples) improves prompts
3. **Code explanations** via Ask Copilot and `/explain` accelerate learning new APIs
4. **Comment-driven generation** works best with structured specifications
5. **Refactoring** is powerful with Inline Chat (`Alt+/`) and `/optimize`
6. **Context references** (`#file:`, `#solution`, `@agent-name`) provide targeted context in Visual Studio
7. **Few-shot prompting** ensures style consistency across generated code
8. **Test generation** with `/tests` catches edge cases you might miss
9. **Privacy controls** (`.copilotignore`, content exclusions) protect sensitive game code
10. **CLI** extends Copilot beyond the IDE into terminal workflows

### Homework Before Advanced Workshop

1. Create a prompt file for a common task in your project
2. Use few-shot prompting in the Copilot Chat window to generate 3 similar functions
3. Generate tests for an existing function using `/tests` and find any bugs
4. Refactor one "code smell" using Inline Chat (`Alt+/`) or Copilot Edits
5. Create a `.copilotignore` file for your project's sensitive files

---

## Resources

- [GitHub Copilot in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-chat)
- [Copilot Chat in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/ide/copilot-chat-context)
- [Prompt Engineering Best Practices](https://docs.github.com/copilot/using-github-copilot/best-practices-for-using-github-copilot)
- [Copilot Privacy & Data Handling](https://docs.github.com/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide)
- [Content Exclusions](https://docs.github.com/copilot/managing-copilot/managing-github-copilot-in-your-organization/configuring-content-exclusions-for-github-copilot)
- [Copilot CLI Reference](https://docs.github.com/copilot/github-copilot-in-the-cli)
- [Urban Survivor Prompt Files](../../.github/prompts/)

---

*Next Workshop: [Advanced - Instruction Files, Agents, and Code Review](03-advanced-workshop.md)*
