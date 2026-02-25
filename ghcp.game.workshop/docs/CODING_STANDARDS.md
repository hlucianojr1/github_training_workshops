# Urban Survivor - Coding Standards

## Overview
This document defines coding standards for all code in the Urban Survivor project. Following these standards ensures consistency, maintainability, and quality across the codebase.

---

## C++ Standards

### General Rules
- **C++ Standard**: C++17
- **Compiler Warnings**: Treat all warnings as errors (`-Werror` / `/WX`)
- **Line Length**: Maximum 120 characters
- **Indentation**: 4 spaces (no tabs)
- **Braces**: Allman style (brace on new line) for functions, K&R for control structures

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `PlayerController` |
| Methods | snake_case | `get_player_health()` |
| Variables | snake_case | `current_health` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_HEALTH` |
| Enum Values | SCREAMING_SNAKE_CASE | `STATE_IDLE` |
| Private Members | snake_case (no prefix) | `health` |
| File Names | snake_case | `player_controller.cpp` |
| Namespaces | lowercase | `godot` |

### File Structure

```cpp
// player_controller.hpp
#ifndef PLAYER_CONTROLLER_HPP   // Include guard (or #pragma once)
#define PLAYER_CONTROLLER_HPP

// Standard library includes (alphabetical)
#include <memory>
#include <vector>

// Godot includes (alphabetical)
#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/core/class_db.hpp>

// Project includes (alphabetical)
#include "inventory/inventory.hpp"

namespace godot {

// Forward declarations
class Weapon;

/**
 * @brief Brief description of the class
 * 
 * Detailed description if needed.
 */
class PlayerController : public CharacterBody3D {
    GDCLASS(PlayerController, CharacterBody3D)

public:
    // Public types/enums
    enum class MovementState {
        IDLE,
        WALKING,
        RUNNING
    };

private:
    // Private members (grouped by purpose)
    float health = 100.0f;
    float max_health = 100.0f;
    
    MovementState current_state = MovementState::IDLE;

protected:
    static void _bind_methods();

public:
    // Constructors/Destructors
    PlayerController();
    ~PlayerController();

    // Godot lifecycle
    void _ready() override;
    void _process(double delta) override;
    void _physics_process(double delta) override;

    // Getters/Setters
    float get_health() const { return health; }
    void set_health(float value);

    // Public methods
    void take_damage(float amount);

private:
    // Private methods
    void update_movement(double delta);
};

} // namespace godot

#endif // PLAYER_CONTROLLER_HPP
```

### Method Implementation Order

```cpp
// player_controller.cpp
#include "player_controller.hpp"

// Other includes...

namespace godot {

// Static method bindings first
void PlayerController::_bind_methods() {
    // Properties
    ClassDB::bind_method(D_METHOD("get_health"), &PlayerController::get_health);
    ClassDB::bind_method(D_METHOD("set_health", "value"), &PlayerController::set_health);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "health"), "set_health", "get_health");
    
    // Signals
    ADD_SIGNAL(MethodInfo("health_changed", 
        PropertyInfo(Variant::FLOAT, "new_health")));
    
    // Methods exposed to Godot
    ClassDB::bind_method(D_METHOD("take_damage", "amount"), &PlayerController::take_damage);
}

// Constructors/Destructors
PlayerController::PlayerController() {
    // Initialize members
}

PlayerController::~PlayerController() {
    // Cleanup
}

// Godot lifecycle methods
void PlayerController::_ready() {
    // Setup
}

void PlayerController::_process(double delta) {
    // Per-frame logic
}

void PlayerController::_physics_process(double delta) {
    // Physics logic
}

// Public methods (alphabetical)
void PlayerController::set_health(float value) {
    health = Math::clamp(value, 0.0f, max_health);
    emit_signal("health_changed", health);
}

void PlayerController::take_damage(float amount) {
    set_health(health - amount);
}

// Private methods (alphabetical)
void PlayerController::update_movement(double delta) {
    // Implementation
}

} // namespace godot
```

### Documentation

```cpp
/**
 * @brief Calculate damage after applying armor reduction
 * 
 * @param base_damage The raw damage before armor
 * @param armor_value The target's armor value (0-100)
 * @param damage_type The type of damage being dealt
 * @return float The final damage after armor reduction
 * 
 * @note Armor reduces damage by a percentage: damage * (100 - armor) / 100
 * @warning Negative armor values will increase damage taken
 */
float DamageSystem::calculate_damage(float base_damage, float armor_value, DamageType damage_type);
```

### Error Handling

```cpp
// Use ERR_FAIL macros from Godot
void PlayerController::equip_weapon(Weapon* weapon) {
    ERR_FAIL_NULL(weapon);  // Returns if null
    ERR_FAIL_COND(weapon->get_type() == WeaponType::INVALID);  // Returns if condition true
    
    // Or with message
    ERR_FAIL_NULL_MSG(weapon, "Cannot equip null weapon");
    
    // Continue with valid weapon...
}

// For methods with return values
Weapon* PlayerController::get_weapon(int slot) {
    ERR_FAIL_INDEX_V(slot, MAX_WEAPON_SLOTS, nullptr);  // Returns nullptr if out of range
    return weapons[slot];
}
```

---

## GDScript Standards

### General Rules
- **Indentation**: Tabs (Godot default)
- **Line Length**: Maximum 100 characters
- **Type Hints**: Always use static typing

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `InventoryUI` |
| Functions | snake_case | `update_health_bar()` |
| Variables | snake_case | `current_ammo` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_SLOTS` |
| Signals | snake_case | `item_selected` |
| Enums | PascalCase | `ItemType` |
| Enum Values | SCREAMING_SNAKE_CASE | `ITEM_WEAPON` |
| Private | _prefix | `_internal_value` |
| Node refs | snake_case | `health_bar` |

### File Structure

```gdscript
# inventory_ui.gd
class_name InventoryUI
extends Control

## Brief description of the class
##
## Longer description if needed.
## Can span multiple lines.

# Signals
signal item_selected(item: Item)
signal inventory_closed

# Enums
enum SlotType { WEAPON, CONSUMABLE, MATERIAL }

# Constants
const MAX_VISIBLE_SLOTS: int = 12
const SLOT_SIZE: Vector2 = Vector2(64, 64)

# Exports (grouped by category)
@export_group("Layout")
@export var columns: int = 4
@export var slot_spacing: float = 8.0

@export_group("References")
@export var slot_scene: PackedScene

# Public variables
var selected_slot: int = -1

# Private variables
var _slots: Array[Control] = []
var _inventory: Inventory

# Onready variables
@onready var grid_container: GridContainer = $GridContainer
@onready var item_tooltip: Control = $ItemTooltip


func _ready() -> void:
	_setup_slots()
	_connect_signals()


func _process(delta: float) -> void:
	_update_tooltip_position()


# Public methods
func open(inventory: Inventory) -> void:
	_inventory = inventory
	_refresh_slots()
	show()


func close() -> void:
	hide()
	inventory_closed.emit()


func select_slot(index: int) -> void:
	if index < 0 or index >= _slots.size():
		return
	
	selected_slot = index
	_highlight_slot(index)


# Private methods
func _setup_slots() -> void:
	for i in range(MAX_VISIBLE_SLOTS):
		var slot := slot_scene.instantiate() as Control
		grid_container.add_child(slot)
		_slots.append(slot)


func _connect_signals() -> void:
	for i in range(_slots.size()):
		_slots[i].pressed.connect(_on_slot_pressed.bind(i))


func _refresh_slots() -> void:
	pass  # Implementation


func _highlight_slot(index: int) -> void:
	pass  # Implementation


func _update_tooltip_position() -> void:
	item_tooltip.global_position = get_global_mouse_position() + Vector2(10, 10)


# Signal handlers
func _on_slot_pressed(index: int) -> void:
	select_slot(index)
	if _inventory and index < _inventory.get_item_count():
		item_selected.emit(_inventory.get_item(index))
```

### Signal Connections

```gdscript
# Prefer code connections for dynamic connections
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	
	# With arguments
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_indexed_button.bind(i))

# Use editor connections for static scene connections
# (visible in editor, documented in .tscn)
```

### Null Safety

```gdscript
# Always check potentially null values
func damage_player(player: PlayerController) -> void:
	if not player:
		push_warning("Attempted to damage null player")
		return
	
	player.take_damage(damage)


# Use is_instance_valid for node references
func _process(delta: float) -> void:
	if is_instance_valid(target):
		look_at(target.global_position)
```

---

## Scene Organization

### Node Naming
- **PascalCase** for all nodes
- **Descriptive names**: `HealthBar` not `Bar1`
- **Suffix with type for clarity**: `SpawnPoint` (Marker3D), `DamageArea` (Area3D)

### Scene Structure Template

```
RootNode (Type)
├── Visual/
│   ├── MeshInstance3D
│   └── AnimationPlayer
├── Collision/
│   └── CollisionShape3D
├── Logic/
│   ├── StateMachine
│   └── AIPerception
└── UI/
    └── HealthBar3D
```

### Group Usage

| Group | Purpose |
|-------|---------|
| `player` | Player node(s) for AI targeting |
| `enemy` | All enemy nodes |
| `interactable` | Objects player can interact with |
| `damageable` | Objects that can receive damage |
| `persistent` | Nodes that survive scene changes |

---

## Version Control

### Commit Messages

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring
- `docs`: Documentation
- `style`: Formatting
- `test`: Tests
- `chore`: Maintenance

**Examples:**
```
feat(ai): add flanking behavior to veteran enemies

Enemies now attempt to flank when player is in cover.
Requires 2+ enemies to trigger flanking.

Closes #42
```

```
fix(player): prevent double-jump exploit

Players could jump again immediately after landing
by buffering the jump input.
```

### Branch Naming
- `main`: Stable, releasable code
- `develop`: Integration branch
- `feature/description`: New features
- `fix/description`: Bug fixes
- `refactor/description`: Refactoring

---

## Performance Guidelines

### C++ Performance

```cpp
// GOOD: Pass large objects by const reference
void process_item(const Item& item);

// BAD: Copying large objects
void process_item(Item item);

// GOOD: Reserve vector capacity
std::vector<Enemy*> enemies;
enemies.reserve(expected_count);

// GOOD: Use move semantics
inventory.add_item(std::move(new_item));

// AVOID: String concatenation in loops
// BAD:
String result;
for (int i = 0; i < 100; i++) {
    result += String::num(i);
}
// GOOD:
PackedStringArray parts;
parts.resize(100);
for (int i = 0; i < 100; i++) {
    parts[i] = String::num(i);
}
String result = String(",").join(parts);
```

### GDScript Performance

```gdscript
# Cache node references
@onready var player: PlayerController = get_node("/root/Main/Player")

# Avoid get_node in _process
# BAD:
func _process(delta: float) -> void:
	get_node("Health").value = health  # Called every frame

# GOOD:
@onready var health_bar: ProgressBar = $Health
func _process(delta: float) -> void:
	health_bar.value = health

# Use typed arrays
var enemies: Array[EnemyAI] = []  # Faster than untyped Array

# Avoid creating objects in hot paths
# BAD:
func _physics_process(delta: float) -> void:
	var direction := Vector3(input.x, 0, input.y)  # Creates new Vector3 each frame

# GOOD: Reuse or use in-place
var _movement_direction := Vector3.ZERO
func _physics_process(delta: float) -> void:
	_movement_direction.x = input.x
	_movement_direction.z = input.y
```

---

## Security Considerations

### Input Validation
```cpp
// Always validate input ranges
void Inventory::set_slot(int index, Item* item) {
    ERR_FAIL_INDEX(index, MAX_SLOTS);
    slots[index] = item;
}

// Validate file paths
void LevelManager::load_level(const String& path) {
    ERR_FAIL_COND_MSG(!path.begins_with("res://levels/"), 
        "Invalid level path: " + path);
}
```

### Save Data
- Never trust save file contents
- Validate all loaded values
- Use checksums for integrity

---

## Review Checklist

### Before Code Review
- [ ] Code compiles without warnings
- [ ] Follows naming conventions
- [ ] Has appropriate documentation
- [ ] No hardcoded values (use constants/exports)
- [ ] Error cases handled
- [ ] No debug code left in

### During Code Review
- [ ] Logic is correct
- [ ] Edge cases handled
- [ ] Performance acceptable
- [ ] Consistent with existing code
- [ ] Tests provided if applicable
