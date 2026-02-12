#ifndef DAMAGE_SYSTEM_HPP
#define DAMAGE_SYSTEM_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * DamageSystem - Global damage calculation and handling
 * 
 * Centralized system for damage types, modifiers, and application.
 */
class DamageSystem : public Node {
    GDCLASS(DamageSystem, Node)

public:
    enum class DamageType {
        BULLET,
        EXPLOSION,
        MELEE,
        FALL,
        ENVIRONMENTAL
    };
    
    enum class HitZone {
        UNKNOWN,  // Default fallback
        HEAD,     // 2.5x damage
        TORSO,    // 1.0x damage (base)
        LIMBS     // 0.7x damage
    };

private:
    static DamageSystem* singleton;

protected:
    static void _bind_methods();

public:
    DamageSystem();
    ~DamageSystem();

    void _ready() override;

    static DamageSystem* get_singleton() { return singleton; }

    // Damage calculation (using int for type to avoid template issues with Godot bindings)
    float calculate_damage(float base_damage, int type, Node* target, int hit_zone = 0) const;
    float apply_distance_falloff(float damage, float distance, float max_range) const;
    float get_hit_zone_multiplier(int hit_zone) const;

    // Damage application
    void apply_damage(Node* target, float base_damage, int type, Node* source, int hit_zone = 0);
    
    // Utility
    static int damage_type_to_int(DamageType type) { return static_cast<int>(type); }
    static DamageType int_to_damage_type(int type) { return static_cast<DamageType>(type); }
    static int hit_zone_to_int(HitZone zone) { return static_cast<int>(zone); }
    static HitZone int_to_hit_zone(int zone) { return static_cast<HitZone>(zone); }
    static HitZone detect_hit_zone(Node* collider);
};

} // namespace godot

#endif // DAMAGE_SYSTEM_HPP
