#include "hud.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void HUD::_bind_methods() {
    ClassDB::bind_method(D_METHOD("update_health", "health", "max"), &HUD::update_health);
    ClassDB::bind_method(D_METHOD("update_stamina", "stamina", "max"), &HUD::update_stamina);
    ClassDB::bind_method(D_METHOD("update_ammo", "mag_ammo", "reserve"), &HUD::update_ammo);
    ClassDB::bind_method(D_METHOD("update_objective", "text"), &HUD::update_objective);
    ClassDB::bind_method(D_METHOD("show_hud"), &HUD::show_hud);
    ClassDB::bind_method(D_METHOD("hide_hud"), &HUD::hide_hud);
    ClassDB::bind_method(D_METHOD("show_crosshair"), &HUD::show_crosshair);
    ClassDB::bind_method(D_METHOD("hide_crosshair"), &HUD::hide_crosshair);
    ClassDB::bind_method(D_METHOD("set_crosshair_spread", "spread"), &HUD::set_crosshair_spread);
    ClassDB::bind_method(D_METHOD("set_crosshair_color", "color"), &HUD::set_crosshair_color);
}

HUD::HUD() {
    current_health = 100.0f;
    max_health = 100.0f;
    current_stamina = 100.0f;
    max_stamina = 100.0f;
    current_ammo = 0;
    reserve_ammo = 0;
    damage_flash_timer = 0.0f;
    ammo_flash_timer = 0.0f;
    is_low_stamina = false;
    stamina_pulse_time = 0.0f;
}

HUD::~HUD() {
}

void HUD::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // Get UI element references (under Control child node)
    health_label = Object::cast_to<Label>(get_node_or_null(NodePath("Control/HealthLabel")));
    ammo_label = Object::cast_to<Label>(get_node_or_null(NodePath("Control/AmmoLabel")));
    objective_label = Object::cast_to<Label>(get_node_or_null(NodePath("Control/ObjectiveLabel")));
    health_bar = Object::cast_to<ProgressBar>(get_node_or_null(NodePath("Control/HealthBar")));
    stamina_bar = Object::cast_to<ProgressBar>(get_node_or_null(NodePath("Control/StaminaBar")));
    crosshair = get_node_or_null(NodePath("Control/Crosshair"));

    // Debug: report what was found
    UtilityFunctions::print("HUD ready - HealthLabel: ", health_label != nullptr, 
                           ", AmmoLabel: ", ammo_label != nullptr,
                           ", HealthBar: ", health_bar != nullptr,
                           ", Crosshair: ", crosshair != nullptr);
}

void HUD::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }
    
    // Handle damage flash effect
    if (damage_flash_timer > 0.0f) {
        damage_flash_timer -= delta;
        
        if (health_bar) {
            // Pulse between red and normal color
            float alpha = damage_flash_timer / DAMAGE_FLASH_DURATION;
            Color flash_color = Color(1.0f, 0.3f, 0.3f, alpha);
            health_bar->set_modulate(flash_color.lerp(Color(1, 1, 1, 1), 1.0f - alpha));
        }
        
        if (damage_flash_timer <= 0.0f) {
            if (health_bar) {
                health_bar->set_modulate(Color(1, 1, 1, 1));
            }
        }
    }
    
    // Handle low stamina warning pulse
    if (is_low_stamina && stamina_bar) {
        stamina_pulse_time += delta * STAMINA_PULSE_SPEED;
        float pulse = (Math::sin(stamina_pulse_time) + 1.0f) * 0.5f; // 0 to 1
        Color warning_color = Color(1.0f, 0.3f, 0.3f).lerp(Color(0.2f, 0.8f, 1.0f), pulse);
        stamina_bar->set_modulate(warning_color);
    } else if (stamina_bar) {
        stamina_bar->set_modulate(Color(1, 1, 1, 1));
    }
    
    // Handle ammo flash effect
    if (ammo_flash_timer > 0.0f) {
        ammo_flash_timer -= delta;
        
        if (ammo_label) {
            // Flash yellow when empty
            float alpha = ammo_flash_timer / AMMO_FLASH_DURATION;
            Color flash_color = Color(1.0f, 1.0f, 0.0f, alpha);
            ammo_label->set_modulate(flash_color.lerp(Color(1, 1, 1, 1), 1.0f - alpha));
        }
        
        if (ammo_flash_timer <= 0.0f) {
            if (ammo_label) {
                ammo_label->set_modulate(Color(1, 1, 1, 1));
            }
        }
    }
}

void HUD::update_health(float health, float max) {
    float previous_health = current_health;
    current_health = health;
    max_health = max;
    
    // Trigger damage flash if health decreased
    if (health < previous_health) {
        damage_flash_timer = DAMAGE_FLASH_DURATION;
    }

    if (health_label) {
        health_label->set_text(String("{0} HP").format(Array::make(static_cast<int>(health))));
    }

    if (health_bar) {
        health_bar->set_max(max);
        health_bar->set_value(health);
    }
}

void HUD::update_stamina(float stamina, float max) {
    current_stamina = stamina;
    max_stamina = max;
    
    // Check if we're in low stamina warning zone
    float stamina_percent = (stamina / max) * 100.0f;
    is_low_stamina = (stamina_percent <= LOW_STAMINA_THRESHOLD);

    if (stamina_bar) {
        stamina_bar->set_max(max);
        stamina_bar->set_value(stamina);
    }
}

void HUD::update_ammo(int mag_ammo, int reserve) {
    int previous_ammo = current_ammo;
    current_ammo = mag_ammo;
    reserve_ammo = reserve;
    
    // Trigger flash if ammo is now 0 and wasn't before
    if (mag_ammo == 0 && previous_ammo > 0) {
        ammo_flash_timer = AMMO_FLASH_DURATION;
    }

    if (ammo_label) {
        ammo_label->set_text(String("{0} / {1}").format(Array::make(mag_ammo, reserve)));
    }
}

void HUD::update_objective(const String& text) {
    if (objective_label) {
        objective_label->set_text(text);
    }
}

void HUD::show_hud() {
    set_visible(true);
}

void HUD::hide_hud() {
    set_visible(false);
}

void HUD::show_crosshair() {
    if (crosshair) {
        crosshair->set("visible", true);
    }
}

void HUD::hide_crosshair() {
    if (crosshair) {
        crosshair->set("visible", false);
    }
}

void HUD::set_crosshair_spread(float spread) {
    if (crosshair) {
        crosshair->set("spread", spread);
    }
}

void HUD::set_crosshair_color(const Color& color) {
    if (crosshair) {
        crosshair->set("modulate", color);
    }
}

} // namespace godot
