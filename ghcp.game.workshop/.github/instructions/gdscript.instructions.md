# GDScript — Code Generation Instructions

Apply these rules when generating or modifying GDScript files in `game/scripts/`.

## Purpose

GDScript is used for UI, HUD, and rapid-iteration scripting. Performance-critical
game systems are in C++ GDExtension (`src/`).

## Style Guide

- Follow Godot's official GDScript style guide
- Use `snake_case` for functions, variables, and signals
- Use `PascalCase` for class names and node types
- Use `UPPER_CASE` for constants and enums
- Indent with tabs (Godot default)

## Type Hints

Prefer typed variables and return types for clarity and editor autocompletion:

```gdscript
var speed: float = 5.0
var player_name: String = ""
var inventory: Array[Item] = []

func calculate_damage(base: float, multiplier: float) -> float:
    return base * multiplier
```

## Signal Connections

- Connect signals in `_ready()` or via the Godot editor
- Use typed signal parameters when possible
- Prefer `Callable` syntax for connections:

```gdscript
func _ready() -> void:
    $Button.pressed.connect(_on_button_pressed)
    health_changed.connect(_on_health_changed)
```

## Node References

- Use `@onready` for node references:

```gdscript
@onready var health_bar: ProgressBar = $HealthBar
@onready var ammo_label: Label = $AmmoLabel
```

- Null-check nodes when they may not exist at runtime

## Exports

Use `@export` with type hints for inspector-exposed variables:

```gdscript
@export var max_health: float = 100.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 1.0
@export_group("Movement")
@export var walk_speed: float = 5.0
```

## File Organization

```
game/scripts/
├── ui/          # HUD and menu scripts
├── autoload/    # Global singletons
└── helpers/     # Utility scripts
```

## Interop with C++ Classes

GDScript accesses C++ GDExtension classes as native Godot types. Reference
class names exactly as registered in `src/register_types.cpp`:

```gdscript
var player: PlayerController = get_node("Player")
player.take_damage(10.0, "bullet")
```
