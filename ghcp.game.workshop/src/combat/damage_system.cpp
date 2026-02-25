#include "damage_system.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

DamageSystem* DamageSystem::singleton = nullptr;

void DamageSystem::_bind_methods() {
    // Note: Using int for damage type parameter instead of enum to avoid template issues
    ClassDB::bind_method(D_METHOD("calculate_damage", "base_damage", "type", "target", "hit_zone"), &DamageSystem::calculate_damage);
    ClassDB::bind_method(D_METHOD("apply_distance_falloff", "damage", "distance", "max_range"), &DamageSystem::apply_distance_falloff);
    ClassDB::bind_method(D_METHOD("get_hit_zone_multiplier", "hit_zone"), &DamageSystem::get_hit_zone_multiplier);
    ClassDB::bind_method(D_METHOD("apply_damage", "target", "base_damage", "type", "source", "hit_zone"), &DamageSystem::apply_damage);
    
    // Bind enum constants
    ClassDB::bind_integer_constant(get_class_static(), "DamageType", "BULLET", static_cast<int>(DamageType::BULLET));
    ClassDB::bind_integer_constant(get_class_static(), "DamageType", "EXPLOSION", static_cast<int>(DamageType::EXPLOSION));
    ClassDB::bind_integer_constant(get_class_static(), "DamageType", "MELEE", static_cast<int>(DamageType::MELEE));
    ClassDB::bind_integer_constant(get_class_static(), "DamageType", "FALL", static_cast<int>(DamageType::FALL));
    ClassDB::bind_integer_constant(get_class_static(), "DamageType", "ENVIRONMENTAL", static_cast<int>(DamageType::ENVIRONMENTAL));
    
    // Hit zone constants
    ClassDB::bind_integer_constant(get_class_static(), "HitZone", "UNKNOWN", static_cast<int>(HitZone::UNKNOWN));
    ClassDB::bind_integer_constant(get_class_static(), "HitZone", "HEAD", static_cast<int>(HitZone::HEAD));
    ClassDB::bind_integer_constant(get_class_static(), "HitZone", "TORSO", static_cast<int>(HitZone::TORSO));
    ClassDB::bind_integer_constant(get_class_static(), "HitZone", "LIMBS", static_cast<int>(HitZone::LIMBS));

    ADD_SIGNAL(MethodInfo("damage_dealt",
        PropertyInfo(Variant::OBJECT, "target"),
        PropertyInfo(Variant::FLOAT, "amount"),
        PropertyInfo(Variant::INT, "type"),
        PropertyInfo(Variant::OBJECT, "source")));
}

DamageSystem::DamageSystem() {
    if (singleton == nullptr) {
        singleton = this;
    }
}

DamageSystem::~DamageSystem() {
    if (singleton == this) {
        singleton = nullptr;
    }
}

void DamageSystem::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    UtilityFunctions::print("DamageSystem ready");
}

float DamageSystem::calculate_damage(float base_damage, int type_int, Node* target, int hit_zone_int) const {
    float final_damage = base_damage;

    // Convert int to enum
    DamageType type = static_cast<DamageType>(type_int);
    HitZone hit_zone = static_cast<HitZone>(hit_zone_int);

    // Apply damage type modifiers
    switch (type) {
        case DamageType::BULLET:
            // Standard damage
            break;
        case DamageType::EXPLOSION:
            // Explosions ignore some armor (not implemented yet)
            final_damage *= 1.2f;
            break;
        case DamageType::MELEE:
            // Melee does slightly less base damage
            final_damage *= 0.9f;
            break;
        case DamageType::FALL:
            // Fall damage is proportional to velocity
            break;
        case DamageType::ENVIRONMENTAL:
            // Environmental hazards
            break;
    }
    
    // Apply hit zone multiplier
    final_damage *= get_hit_zone_multiplier(hit_zone_int);

    // Could add armor calculations here if target has armor property
    // if (target && target->has_method("get_armor")) {
    //     float armor = target->call("get_armor");
    //     final_damage *= (1.0f - armor * 0.01f);
    // }

    return final_damage;
}

float DamageSystem::apply_distance_falloff(float damage, float distance, float max_range) const {
    if (distance >= max_range) {
        return 0.0f;
    }

    // Linear falloff - could use quadratic or other curves
    float falloff = 1.0f - (distance / max_range);
    return damage * Math::max(0.0f, falloff);
}

float DamageSystem::get_hit_zone_multiplier(int hit_zone_int) const {
    HitZone zone = static_cast<HitZone>(hit_zone_int);
    
    switch (zone) {
        case HitZone::HEAD:
            return 2.5f;  // Headshot: 2.5x damage
        case HitZone::TORSO:
            return 1.0f;  // Torso: Base damage
        case HitZone::LIMBS:
            return 0.7f;  // Limbs: Reduced damage
        case HitZone::UNKNOWN:
        default:
            return 1.0f;  // Default: Base damage
    }
}

DamageSystem::HitZone DamageSystem::detect_hit_zone(Node* collider) {
    if (!collider) {
        return HitZone::UNKNOWN;
    }
    
    // Check node groups for hit zone identification
    if (collider->is_in_group("hitzone_head")) {
        return HitZone::HEAD;
    }
    if (collider->is_in_group("hitzone_torso")) {
        return HitZone::TORSO;
    }
    if (collider->is_in_group("hitzone_limbs")) {
        return HitZone::LIMBS;
    }
    
    // Fallback: check node name contains zone indicator
    String name = collider->get_name();
    String name_lower = name.to_lower();
    
    if (name_lower.contains("head") || name_lower.contains("skull")) {
        return HitZone::HEAD;
    }
    if (name_lower.contains("torso") || name_lower.contains("chest") || name_lower.contains("body")) {
        return HitZone::TORSO;
    }
    if (name_lower.contains("arm") || name_lower.contains("leg") || name_lower.contains("limb")) {
        return HitZone::LIMBS;
    }
    
    // Default to torso if no zone detected
    return HitZone::TORSO;
}

static int _get_take_damage_arg_count(Object *obj) {
    if (!obj) {
        return 0;
    }

    Array methods = obj->get_method_list();
    for (int i = 0; i < methods.size(); i++) {
        Dictionary m = methods[i];
        if (!m.has("name")) {
            continue;
        }
        String name = m["name"];
        if (name != "take_damage") {
            continue;
        }
        if (m.has("args")) {
            Array args = m["args"];
            return args.size();
        }
        return 0;
    }

    return 0;
}

void DamageSystem::apply_damage(Node* target, float base_damage, int type_int, Node* source, int hit_zone) {
    if (!target || base_damage <= 0.0f) {
        return;
    }

    float final_damage = calculate_damage(base_damage, type_int, target, hit_zone);
    if (final_damage <= 0.0f) {
        return;
    }

    if (target->has_method("take_damage")) {
        const int arg_count = _get_take_damage_arg_count(target);

        // Prefer passing attacker/source when supported.
        if (arg_count >= 2) {
            target->call("take_damage", final_damage, source);
        } else {
            target->call("take_damage", final_damage);
        }

        emit_signal("damage_dealt", target, final_damage, type_int, source);
        return;
    }

    // Common pattern: damage is handled by a child component (e.g., SurvivalStats).
    if (target->has_node(NodePath("SurvivalStats"))) {
        Node* stats = Object::cast_to<Node>(target->get_node_or_null(NodePath("SurvivalStats")));
        if (stats && stats->has_method("take_damage")) {
            stats->call("take_damage", final_damage);
            emit_signal("damage_dealt", target, final_damage, type_int, source);
            return;
        }
    }
}

} // namespace godot
