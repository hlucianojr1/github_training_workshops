#include "survival_stats.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void SurvivalStats::_bind_methods() {
    // Health properties
    ClassDB::bind_method(D_METHOD("set_max_health", "health"), &SurvivalStats::set_max_health);
    ClassDB::bind_method(D_METHOD("get_max_health"), &SurvivalStats::get_max_health);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "max_health", PROPERTY_HINT_RANGE, "1.0,1000.0,1.0"), "set_max_health", "get_max_health");

    ClassDB::bind_method(D_METHOD("get_health"), &SurvivalStats::get_health);
    ClassDB::bind_method(D_METHOD("get_health_ratio"), &SurvivalStats::get_health_ratio);

    ClassDB::bind_method(D_METHOD("set_health_regen_rate", "rate"), &SurvivalStats::set_health_regen_rate);
    ClassDB::bind_method(D_METHOD("get_health_regen_rate"), &SurvivalStats::get_health_regen_rate);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "health_regen_rate", PROPERTY_HINT_RANGE, "0.0,50.0,0.5"), "set_health_regen_rate", "get_health_regen_rate");

    // Stamina properties
    ClassDB::bind_method(D_METHOD("set_max_stamina", "stamina"), &SurvivalStats::set_max_stamina);
    ClassDB::bind_method(D_METHOD("get_max_stamina"), &SurvivalStats::get_max_stamina);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "max_stamina", PROPERTY_HINT_RANGE, "1.0,500.0,1.0"), "set_max_stamina", "get_max_stamina");

    ClassDB::bind_method(D_METHOD("get_stamina"), &SurvivalStats::get_stamina);
    ClassDB::bind_method(D_METHOD("get_stamina_ratio"), &SurvivalStats::get_stamina_ratio);

    ClassDB::bind_method(D_METHOD("set_stamina_regen_rate", "rate"), &SurvivalStats::set_stamina_regen_rate);
    ClassDB::bind_method(D_METHOD("get_stamina_regen_rate"), &SurvivalStats::get_stamina_regen_rate);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "stamina_regen_rate", PROPERTY_HINT_RANGE, "0.0,50.0,0.5"), "set_stamina_regen_rate", "get_stamina_regen_rate");

    ClassDB::bind_method(D_METHOD("set_stamina_drain_rate", "rate"), &SurvivalStats::set_stamina_drain_rate);
    ClassDB::bind_method(D_METHOD("get_stamina_drain_rate"), &SurvivalStats::get_stamina_drain_rate);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "stamina_drain_rate", PROPERTY_HINT_RANGE, "0.0,50.0,0.5"), "set_stamina_drain_rate", "get_stamina_drain_rate");

    // Actions
    ClassDB::bind_method(D_METHOD("take_damage", "amount"), &SurvivalStats::take_damage);
    ClassDB::bind_method(D_METHOD("heal", "amount"), &SurvivalStats::heal);
    ClassDB::bind_method(D_METHOD("restore_stamina", "amount"), &SurvivalStats::restore_stamina);
    ClassDB::bind_method(D_METHOD("drain_stamina", "amount"), &SurvivalStats::drain_stamina);
    ClassDB::bind_method(D_METHOD("set_sprinting", "sprinting"), &SurvivalStats::set_sprinting);
    ClassDB::bind_method(D_METHOD("restore_full"), &SurvivalStats::restore_full);

    // State queries
    ClassDB::bind_method(D_METHOD("can_sprint"), &SurvivalStats::can_sprint);
    ClassDB::bind_method(D_METHOD("get_is_dead"), &SurvivalStats::get_is_dead);
    ClassDB::bind_method(D_METHOD("get_is_exhausted"), &SurvivalStats::get_is_exhausted);
    ClassDB::bind_method(D_METHOD("get_is_sprinting"), &SurvivalStats::get_is_sprinting);
    ClassDB::bind_method(D_METHOD("is_low_health"), &SurvivalStats::is_low_health);
    ClassDB::bind_method(D_METHOD("is_low_stamina"), &SurvivalStats::is_low_stamina);

    // Signals
    ADD_SIGNAL(MethodInfo("health_changed",
        PropertyInfo(Variant::FLOAT, "new_health"),
        PropertyInfo(Variant::FLOAT, "max_health")));
    ADD_SIGNAL(MethodInfo("stamina_changed",
        PropertyInfo(Variant::FLOAT, "new_stamina"),
        PropertyInfo(Variant::FLOAT, "max_stamina")));
    ADD_SIGNAL(MethodInfo("damage_taken", PropertyInfo(Variant::FLOAT, "amount")));
    ADD_SIGNAL(MethodInfo("healed", PropertyInfo(Variant::FLOAT, "amount")));
    ADD_SIGNAL(MethodInfo("player_died"));
    ADD_SIGNAL(MethodInfo("exhausted"));
    ADD_SIGNAL(MethodInfo("stamina_recovered"));
}

SurvivalStats::SurvivalStats() {
    max_health = 100.0f;
    current_health = 100.0f;
    health_regen_rate = 0.0f;
    
    max_stamina = 100.0f;
    current_stamina = 100.0f;
    stamina_regen_rate = 10.0f;
    stamina_drain_rate = 15.0f;
    
    is_sprinting = false;
    is_dead = false;
    is_exhausted = false;
    
    damage_cooldown = 0.0f;
    regen_delay = 3.0f;
    time_since_damage = 0.0f;
}

SurvivalStats::~SurvivalStats() {
}

void SurvivalStats::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }
    
    current_health = max_health;
    current_stamina = max_stamina;
    
    UtilityFunctions::print("SurvivalStats ready - Health: ", max_health, ", Stamina: ", max_stamina);
}

void SurvivalStats::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint() || is_dead) {
        return;
    }

    float dt = static_cast<float>(delta);
    
    // Update damage cooldown
    if (time_since_damage < regen_delay) {
        time_since_damage += dt;
    }

    // Health regeneration (only if regen is enabled and not recently damaged)
    if (health_regen_rate > 0.0f && time_since_damage >= regen_delay && current_health < max_health) {
        float old_health = current_health;
        current_health = Math::min(current_health + health_regen_rate * dt, max_health);
        
        if (current_health != old_health) {
            emit_signal("health_changed", current_health, max_health);
        }
    }

    // Stamina handling
    float old_stamina = current_stamina;
    
    if (is_sprinting && !is_exhausted) {
        // Drain stamina while sprinting
        current_stamina = Math::max(0.0f, current_stamina - stamina_drain_rate * dt);
        
        if (current_stamina <= 0.0f) {
            is_exhausted = true;
            is_sprinting = false;
            emit_signal("exhausted");
        }
    } else {
        // Regenerate stamina when not sprinting
        current_stamina = Math::min(current_stamina + stamina_regen_rate * dt, max_stamina);
        
        // Recover from exhaustion when stamina reaches 30%
        if (is_exhausted && current_stamina >= max_stamina * 0.3f) {
            is_exhausted = false;
            emit_signal("stamina_recovered");
        }
    }

    if (current_stamina != old_stamina) {
        emit_signal("stamina_changed", current_stamina, max_stamina);
    }
}

void SurvivalStats::take_damage(float amount) {
    if (is_dead || amount <= 0.0f) {
        return;
    }

    current_health = Math::max(0.0f, current_health - amount);
    time_since_damage = 0.0f;
    
    emit_signal("damage_taken", amount);
    emit_signal("health_changed", current_health, max_health);

    if (current_health <= 0.0f) {
        is_dead = true;
        emit_signal("player_died");
        UtilityFunctions::print("Player died!");
    }
}

void SurvivalStats::heal(float amount) {
    if (is_dead || amount <= 0.0f) {
        return;
    }

    float old_health = current_health;
    current_health = Math::min(current_health + amount, max_health);
    float actual_heal = current_health - old_health;

    if (actual_heal > 0.0f) {
        emit_signal("healed", actual_heal);
        emit_signal("health_changed", current_health, max_health);
    }
}

void SurvivalStats::restore_stamina(float amount) {
    if (amount <= 0.0f) {
        return;
    }

    current_stamina = Math::min(current_stamina + amount, max_stamina);
    
    if (is_exhausted && current_stamina >= max_stamina * 0.3f) {
        is_exhausted = false;
        emit_signal("stamina_recovered");
    }
    
    emit_signal("stamina_changed", current_stamina, max_stamina);
}

void SurvivalStats::drain_stamina(float amount) {
    if (amount <= 0.0f) {
        return;
    }

    current_stamina = Math::max(0.0f, current_stamina - amount);
    
    if (current_stamina <= 0.0f && !is_exhausted) {
        is_exhausted = true;
        emit_signal("exhausted");
    }
    
    emit_signal("stamina_changed", current_stamina, max_stamina);
}

void SurvivalStats::set_sprinting(bool sprinting) {
    if (sprinting && !can_sprint()) {
        return;
    }
    is_sprinting = sprinting;
}

void SurvivalStats::restore_full() {
    current_health = max_health;
    current_stamina = max_stamina;
    is_dead = false;
    is_exhausted = false;
    time_since_damage = regen_delay;
    
    emit_signal("health_changed", current_health, max_health);
    emit_signal("stamina_changed", current_stamina, max_stamina);
}

} // namespace godot
