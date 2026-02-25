#ifndef PLAYER_CONTROLLER_HPP
#define PLAYER_CONTROLLER_HPP

#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/input_event.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

class Inventory;
class SurvivalStats;
class Weapon;

/**
 * PlayerController - Main player character controller
 * 
 * Handles player input, movement physics, state management,
 * and coordinates with other player systems (inventory, survival, combat).
 */
class PlayerController : public CharacterBody3D {
    GDCLASS(PlayerController, CharacterBody3D)

public:
    enum class MovementState {
        IDLE,
        WALKING,
        RUNNING,
        CROUCHING,
        SPRINTING
    };

private:
    // Movement parameters
    float walk_speed = 5.0f;
    float sprint_speed = 8.0f;
    float crouch_speed = 2.5f;
    float jump_velocity = 4.5f;
    float mouse_sensitivity = 0.002f;
    
    // Physics
    float gravity = 9.8f;
    float acceleration = 10.0f;
    float deceleration = 15.0f;
    float air_control = 0.3f;
    
    // State
    MovementState movement_state = MovementState::IDLE;
    bool is_aiming = false;
    bool is_crouching = false;
    bool can_sprint = true;
    bool is_dead = false;
    
    // Input tracking
    Vector2 input_direction;
    Vector2 mouse_motion;
    
    // Recoil tracking
    float current_recoil_vertical = 0.0f;
    float current_recoil_horizontal = 0.0f;
    float recoil_recovery_rate = 8.0f; // How fast camera recovers from recoil
    
    // Melee attack
    float melee_damage = 30.0f;
    float melee_range = 1.5f;  // Short range (sphere radius)
    float melee_cooldown = 1.0f;  // 1 second between attacks
    float last_melee_time = -999.0f;  // Time of last melee attack
    
    // Interaction
    float interaction_range = 2.0f;  // 2 meters forward raycast
    
    // Node references (set in _ready)
    Node3D* camera_pivot = nullptr;
    Inventory* inventory = nullptr;
    SurvivalStats* survival_stats = nullptr;
    Weapon* equipped_weapon = nullptr;
    
    // Internal helpers
    void handle_movement(double delta);
    void handle_rotation(double delta);
    void update_movement_state();
    float get_current_speed() const;
    void on_weapon_recoil(float vertical, float horizontal);
    void on_player_died();

protected:
    static void _bind_methods();

public:
    PlayerController();
    ~PlayerController();

    void _ready() override;
    void _physics_process(double delta) override;
    void _input(const Ref<InputEvent>& event) override;

    // Movement control
    void set_walk_speed(float speed) { walk_speed = speed; }
    float get_walk_speed() const { return walk_speed; }
    
    void set_sprint_speed(float speed) { sprint_speed = speed; }
    float get_sprint_speed() const { return sprint_speed; }
    
    void set_crouch_speed(float speed) { crouch_speed = speed; }
    float get_crouch_speed() const { return crouch_speed; }
    
    void set_jump_velocity(float velocity) { jump_velocity = velocity; }
    float get_jump_velocity() const { return jump_velocity; }
    
    void set_mouse_sensitivity(float sensitivity) { mouse_sensitivity = sensitivity; }
    float get_mouse_sensitivity() const { return mouse_sensitivity; }

    // State queries
    MovementState get_movement_state() const { return movement_state; }
    bool get_is_aiming() const { return is_aiming; }
    bool get_is_crouching() const { return is_crouching; }
    bool get_is_on_ground() const { return is_on_floor(); }
    
    // Actions
    void start_aim();
    void stop_aim();
    void toggle_crouch();
    void interact();
    void shoot();
    void reload();
    void melee_attack();

    // Equipment
    void equip_weapon(Weapon* weapon);
    Weapon* get_equipped_weapon() const { return equipped_weapon; }

    // Signals
    // movement_state_changed(int new_state)
    // weapon_fired()
    // weapon_reloaded()
    // player_interacted(Node* target)
    // player_died()
    // game_over()
    // melee_performed()
};

} // namespace godot

#endif // PLAYER_CONTROLLER_HPP
