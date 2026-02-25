#ifndef ENEMY_AI_HPP
#define ENEMY_AI_HPP

#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/navigation_agent3d.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

class AIPerception;
class Weapon;

/**
 * EnemyAI - State machine based enemy behavior
 * 
 * Represents hostile survivors who patrol, scavenge, and attack.
 * Uses a finite state machine for behavior control.
 */
class EnemyAI : public CharacterBody3D {
    GDCLASS(EnemyAI, CharacterBody3D)

public:
    enum class AIState {
        IDLE,
        PATROL,
        INVESTIGATE,
        CHASE,
        ATTACK,
        TAKE_COVER,
        FLEE,
        DEAD
    };

private:
    // State
    AIState current_state = AIState::IDLE;
    AIState previous_state = AIState::IDLE;
    
    // Stats
    float max_health = 100.0f;
    float current_health = 100.0f;
    float move_speed = 3.5f;
    float chase_speed = 5.0f;
    float attack_damage = 15.0f;
    float attack_range = 2.0f;
    float attack_cooldown = 1.5f;
    
    // Behavior parameters
    float patrol_wait_time = 3.0f;
    float investigate_timeout = 10.0f;
    float flee_health_threshold = 0.2f;  // Flee at 20% health
    float cover_health_threshold = 0.5f; // Seek cover at 50% health
    
    // Cover system
    Vector3 current_cover_position;
    bool has_cover_position = false;
    float peek_timer = 0.0f;             // Timer for peek-shoot cycles
    float peek_interval = 2.0f;          // Time between peek attacks
    
    // Timers
    float state_timer = 0.0f;
    float attack_timer = 0.0f;
    
    // Patrol
    Array patrol_points;
    int current_patrol_index = 0;
    
    // Target tracking
    Node3D* target = nullptr;
    Vector3 last_known_target_position;
    Vector3 investigate_position;
    
    // Node references
    NavigationAgent3D* nav_agent = nullptr;
    AIPerception* perception = nullptr;
    Weapon* equipped_weapon = nullptr;
    
    // AI accuracy (makes AI less accurate than perfect)
    float ai_accuracy_modifier = 0.7f;  // 0.0 (terrible) to 1.0 (perfect)
    
    // Loot system
    Array loot_table;  // Item IDs to drop on death
    float corpse_cleanup_time = 30.0f;  // Seconds before corpse is removed
    float death_timer = 0.0f;
    
    // Activation state (for zone-based spawning)
    bool ai_active = true;  // When false, AI doesn't process states
    
    // Internal methods
    void update_state(double delta);
    void execute_state(double delta);
    void change_state(AIState new_state);
    
    void state_idle(double delta);
    void state_patrol(double delta);
    void state_investigate(double delta);
    void state_chase(double delta);
    void state_attack(double delta);
    void state_take_cover(double delta);
    void state_flee(double delta);
    void state_dead(double delta);
    
    void move_to_target(Vector3 position, float speed);
    bool can_attack() const;
    void perform_attack();
    Vector3 find_cover_position() const;
    void drop_loot();

protected:
    static void _bind_methods();

public:
    EnemyAI();
    ~EnemyAI();

    void _ready() override;
    void _physics_process(double delta) override;

    // State
    AIState get_current_state() const { return current_state; }
    int get_current_state_int() const { return static_cast<int>(current_state); }
    
    // Stats
    void set_max_health(float health) { max_health = health; current_health = health; }
    float get_max_health() const { return max_health; }
    
    float get_health() const { return current_health; }
    float get_health_ratio() const { return current_health / max_health; }
    
    void set_move_speed(float speed) { move_speed = speed; }
    float get_move_speed() const { return move_speed; }
    
    void set_chase_speed(float speed) { chase_speed = speed; }
    float get_chase_speed() const { return chase_speed; }
    
    void set_attack_damage(float damage) { attack_damage = damage; }
    float get_attack_damage() const { return attack_damage; }
    
    void set_attack_range(float range) { attack_range = range; }
    float get_attack_range() const { return attack_range; }
    
    // Behavior thresholds
    void set_flee_health_threshold(float threshold) { flee_health_threshold = Math::clamp(threshold, 0.0f, 1.0f); }
    float get_flee_health_threshold() const { return flee_health_threshold; }
    
    void set_cover_health_threshold(float threshold) { cover_health_threshold = Math::clamp(threshold, 0.0f, 1.0f); }
    float get_cover_health_threshold() const { return cover_health_threshold; }

    // Patrol setup
    void set_patrol_points(const Array& points) { patrol_points = points; }
    Array get_patrol_points() const { return patrol_points; }
    void add_patrol_point(Vector3 point);

    // Combat
    void take_damage(float amount, Node3D* attacker = nullptr);
    void alert_to_position(Vector3 position);
    void set_target(Node3D* new_target);
    Node3D* get_target() const { return target; }
    
    // Weapon management
    void equip_weapon(Weapon* weapon);
    Weapon* get_equipped_weapon() const { return equipped_weapon; }
    
    void set_ai_accuracy(float accuracy) { ai_accuracy_modifier = Math::clamp(accuracy, 0.0f, 1.0f); }
    float get_ai_accuracy() const { return ai_accuracy_modifier; }
    
    // Loot configuration
    void set_loot_table(const Array& table) { loot_table = table; }
    Array get_loot_table() const { return loot_table; }
    
    void set_corpse_cleanup_time(float time) { corpse_cleanup_time = Math::max(0.0f, time); }
    float get_corpse_cleanup_time() const { return corpse_cleanup_time; }
    
    bool is_alive() const { return current_state != AIState::DEAD; }
    bool is_in_combat() const;
    
    // Activation control (for zone-based enemy spawning)
    void set_ai_active(bool active) { ai_active = active; }
    bool is_ai_active() const { return ai_active; }

    // Signals
    // state_changed(int new_state)
    // target_spotted(Node3D* target)
    // target_lost()
    // enemy_died()
    // attack_performed()
};

} // namespace godot

#endif // ENEMY_AI_HPP
