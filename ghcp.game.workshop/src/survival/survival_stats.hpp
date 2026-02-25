#ifndef SURVIVAL_STATS_HPP
#define SURVIVAL_STATS_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * SurvivalStats - Player vital statistics
 * 
 * Tracks health, stamina for light survival gameplay.
 * (Full survival would add hunger, thirst, etc.)
 */
class SurvivalStats : public Node {
    GDCLASS(SurvivalStats, Node)

private:
    // Health
    float max_health = 100.0f;
    float current_health = 100.0f;
    float health_regen_rate = 0.0f;  // Per second, 0 = no regen
    
    // Stamina
    float max_stamina = 100.0f;
    float current_stamina = 100.0f;
    float stamina_regen_rate = 10.0f;  // Per second when not sprinting
    float stamina_drain_rate = 15.0f;  // Per second when sprinting
    
    // State flags
    bool is_sprinting = false;
    bool is_dead = false;
    bool is_exhausted = false;  // Stamina depleted
    
    // Timers
    float damage_cooldown = 0.0f;
    float regen_delay = 3.0f;  // Seconds after damage before regen starts
    float time_since_damage = 0.0f;

protected:
    static void _bind_methods();

public:
    SurvivalStats();
    ~SurvivalStats();

    void _ready() override;
    void _process(double delta) override;

    // Health
    void set_max_health(float health) { max_health = health; }
    float get_max_health() const { return max_health; }
    
    float get_health() const { return current_health; }
    float get_health_ratio() const { return current_health / max_health; }
    
    void set_health_regen_rate(float rate) { health_regen_rate = rate; }
    float get_health_regen_rate() const { return health_regen_rate; }

    // Stamina
    void set_max_stamina(float stamina) { max_stamina = stamina; }
    float get_max_stamina() const { return max_stamina; }
    
    float get_stamina() const { return current_stamina; }
    float get_stamina_ratio() const { return current_stamina / max_stamina; }
    
    void set_stamina_regen_rate(float rate) { stamina_regen_rate = rate; }
    float get_stamina_regen_rate() const { return stamina_regen_rate; }
    
    void set_stamina_drain_rate(float rate) { stamina_drain_rate = rate; }
    float get_stamina_drain_rate() const { return stamina_drain_rate; }

    // Actions
    void take_damage(float amount);
    void heal(float amount);
    void restore_stamina(float amount);
    void drain_stamina(float amount);
    
    // Sprint control
    void set_sprinting(bool sprinting);
    bool can_sprint() const { return current_stamina > 0 && !is_exhausted; }
    
    // State queries
    bool get_is_dead() const { return is_dead; }
    bool get_is_exhausted() const { return is_exhausted; }
    bool get_is_sprinting() const { return is_sprinting; }
    bool is_low_health() const { return get_health_ratio() < 0.25f; }
    bool is_low_stamina() const { return get_stamina_ratio() < 0.2f; }

    // Full restore (for level start, etc.)
    void restore_full();

    // Signals
    // health_changed(float new_health, float max_health)
    // stamina_changed(float new_stamina, float max_stamina)
    // damage_taken(float amount)
    // healed(float amount)
    // player_died()
    // exhausted()
    // stamina_recovered()
};

} // namespace godot

#endif // SURVIVAL_STATS_HPP
