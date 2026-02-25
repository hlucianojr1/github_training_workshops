# Workshop 2: Intermediate
## Prompting, Chat, and Code Generation Mastery

**Duration**: 1 Hour  
**Level**: Intermediate  
**Prerequisites**: Foundational Workshop  
**Project**: Urban Survivor (Godot 4.3+ / C++ GDExtension)

---

## Workshop Objectives

By the end of this workshop, participants will:
- Write effective prompts for complex code generation
- Use inline code suggestions efficiently
- Get meaningful code explanations from Copilot
- Generate code from descriptive comments
- Refactor existing code with AI assistance
- Apply Few-Shot prompting techniques
- Generate unit tests and debug with Copilot
- Use Copilot CLI for command-line workflows

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:08 | Inline Code Suggestions | Demo + Practice |
| 0:08 - 0:16 | Prompting Fundamentals | Presentation |
| 0:16 - 0:24 | Code Explanations | Hands-On |
| 0:24 - 0:32 | Comment-Based Generation | Live Coding |
| 0:32 - 0:40 | Code Refactoring | Exercise |
| 0:40 - 0:46 | Copilot Chat Deep Dive | Demo |
| 0:46 - 0:52 | Few-Shot Prompting | Practice |
| 0:52 - 0:58 | Unit Testing & Debugging | Live Demo |
| 0:58 - 1:00 | Copilot CLI | Quick Tour |

---

## Session 1: Inline Code Suggestions (8 min)

### Learning Objectives
- Maximize inline suggestion quality
- Navigate between alternative suggestions
- Understand ghost text vs. panel suggestions

### Inline Suggestion Types

**Ghost Text (Inline):**
```cpp
void PlayerController::update_stamina(float delta) {
    if (is_sprinting && current_stamina > 0) {
        current_stamina -= sprint_stamina_cost * delta; // Copilot shows gray text here
    }
}
```

**Suggestion Panel (Multiple Options):**
Press `Ctrl+Enter` to see the Copilot panel with 5-10 alternatives.

### Keyboard Shortcuts Reference

| Action | VS Code Shortcut | Description |
|--------|------------------|-------------|
| Accept suggestion | `Tab` | Accept ghost text |
| Accept word | `Ctrl+→` | Accept next word only |
| Accept line | `Ctrl+Enter` then select | Choose from panel |
| Next suggestion | `Alt+]` | Cycle alternatives |
| Previous suggestion | `Alt+[` | Cycle back |
| Dismiss | `Esc` | Clear suggestion |
| Trigger manually | `Alt+\` | Force suggestion |

### Hands-On Exercise (4 min)

**File**: `src/ai/enemy_ai.cpp`

```cpp
// Task: Complete the patrol behavior
void EnemyAI::update_patrol_state(float delta) {
    // 1. Type this, wait for suggestion
    if (has_reached_patrol_point()) {
        // 2. Copilot suggests next patrol point logic
    }
    
    // 3. Use Alt+] to see alternative implementations
    // 4. Accept the best one with Tab
}
```

**Observe:**
- How does the suggestion change based on method names?
- Do alternatives differ in patrol point selection strategy?

---

## Session 2: Prompting Fundamentals (8 min)

### Learning Objectives
- Structure prompts for optimal results
- Use the CORE prompting framework
- Apply prompting to game development scenarios

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

---

## Session 3: Code Explanations (8 min)

### Learning Objectives
- Get explanations of complex code sections
- Understand unfamiliar Godot APIs
- Use explanations for learning and documentation

### Copilot Chat Commands for Explanations

| Command | Use Case |
|---------|----------|
| `/explain` | Explain selected code |
| `@workspace /explain` | Explain with project context |
| Ask directly | "What does this raycast code do?" |

### Demo: Explaining NavigationAgent3D Code

**Select this code and use `/explain`:**

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

## Session 5: Code Refactoring (8 min)

### Learning Objectives
- Refactor code using Copilot suggestions
- Apply design patterns with AI assistance
- Improve code quality iteratively

### Refactoring Commands

| Command | Description |
|---------|-------------|
| `/fix` | Fix issues in selected code |
| "Refactor this to use..." | Specific pattern request |
| "Extract method for..." | Method extraction |
| "Optimize for performance" | Performance improvements |

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
- Master Copilot Chat participants (@workspace, @vscode)
- Use slash commands effectively
- Create multi-turn conversations for complex tasks

### Chat Participants

| Participant | Purpose | Example |
|-------------|---------|---------|
| `@workspace` | Project-wide context | "@workspace how is damage calculated?" |
| `@vscode` | Editor commands | "@vscode how do I debug GDExtension?" |
| `@terminal` | Terminal help | "@terminal cmake build command" |

### Slash Commands

| Command | Description |
|---------|-------------|
| `/explain` | Explain selected code |
| `/fix` | Fix problems in selection |
| `/tests` | Generate unit tests |
| `/doc` | Generate documentation |
| `/new` | Scaffold new code |
| `/clear` | Clear chat history |

### Demo: Multi-Turn Conversation

```
User: @workspace How does the player take damage?

Copilot: In Urban Survivor, player damage flows through:
1. DamageSystem.apply_damage() receives the hit
2. Checks hit zones (HEAD/TORSO/LIMBS multipliers)
3. Applies armor reduction
4. Updates PlayerController.health
5. Emits "player_damaged" signal for HUD

User: Show me where the armor calculation happens

Copilot: In src/combat/damage_system.cpp line 45:
[shows relevant code]

User: Can you add damage resistance for the RADIATION damage type?

Copilot: I'll add radiation resistance to the damage calculation:
[provides code suggestion]
```

---

## Session 7: Few-Shot Prompting (6 min)

### Learning Objectives
- Use examples to guide generation style
- Create consistent code patterns
- Apply few-shot for game-specific conventions

### What is Few-Shot Prompting?

Provide 2-3 examples of the pattern you want, then request a new instance.

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

## Session 8: Unit Testing & Debugging (6 min)

### Learning Objectives
- Generate unit tests with Copilot
- Debug code issues with AI assistance
- Create test cases from specifications

### Test Generation with /tests

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

---

## Session 9: Copilot CLI (2 min)

### Learning Objectives
- Use Copilot for command-line suggestions
- Generate build and run commands
- Integrate with game development workflows

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

1. **Inline suggestions** are faster with keyboard shortcuts
2. **CORE framework** (Context, Objective, Requirements, Examples) improves prompts
3. **Code explanations** accelerate learning new APIs
4. **Comment-driven generation** works best with structured specifications
5. **Refactoring** is powerful with specific pattern requests
6. **Chat participants** (@workspace, @vscode) provide specialized context
7. **Few-shot prompting** ensures style consistency
8. **Test generation** catches edge cases you might miss
9. **CLI** extends Copilot beyond the editor

### Homework Before Advanced Workshop

1. Create a prompt file for a common task in your project
2. Use few-shot prompting to generate 3 similar functions
3. Generate tests for an existing function and find any bugs
4. Refactor one "code smell" using Copilot suggestions

---

## Resources

- [Copilot Chat Documentation](https://docs.github.com/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide)
- [Prompt Engineering Guide](https://docs.github.com/copilot/using-github-copilot/best-practices-for-using-github-copilot)
- [Copilot CLI Reference](https://docs.github.com/copilot/github-copilot-in-the-cli)
- [Urban Survivor Prompt Files](../../.github/prompts/)

---

*Next Workshop: [Advanced - Instruction Files, Agents, and Code Review](03-advanced-workshop.md)*
