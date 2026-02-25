## Game constants for Urban Survivor
## Adapted from Godot-FPS-Template pattern
extends Node

# Player movement
const PLAYER_SPEED: float = 5.0
const PLAYER_SPRINT_SPEED: float = 8.0
const PLAYER_CROUCH_SPEED: float = 3.0
const PLAYER_JUMP_VELOCITY: float = 4.5
const PLAYER_ACCELERATION: float = 0.1
const PLAYER_DECELERATION: float = 0.25

# Camera
const MOUSE_SENSITIVITY: float = 0.002
const FPS_MOUSE_SENSITIVITY: float = 0.003
const CAMERA_VERTICAL_LIMIT: float = 89.0

# Damage multipliers by body part
const DAMAGE_MULTIPLIER_HEAD: float = 2.5
const DAMAGE_MULTIPLIER_TORSO: float = 1.0
const DAMAGE_MULTIPLIER_LIMBS: float = 0.7

# Weapon sway
const SWAY_SPEED: float = 5.0
const SWAY_AMOUNT: float = 0.02
const SWAY_MAX: float = 0.08
const IDLE_SWAY_SPEED: float = 1.0
const IDLE_SWAY_AMOUNT: float = 0.002

# Weapon bob
const BOB_FREQUENCY_WALK: float = 2.0
const BOB_FREQUENCY_SPRINT: float = 2.8
const BOB_FREQUENCY_CROUCH: float = 1.5
const BOB_AMPLITUDE_WALK: float = 0.03
const BOB_AMPLITUDE_SPRINT: float = 0.05
const BOB_AMPLITUDE_CROUCH: float = 0.015

# Physics layers
const LAYER_ENVIRONMENT: int = 1
const LAYER_PLAYER: int = 2
const LAYER_ENEMIES: int = 3
const LAYER_ITEMS: int = 4
const LAYER_PROJECTILES: int = 5
const LAYER_FPS_WEAPONS: int = 10
