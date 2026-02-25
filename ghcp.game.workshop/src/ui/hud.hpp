#ifndef HUD_HPP
#define HUD_HPP

#include <godot_cpp/classes/control.hpp>
#include <godot_cpp/classes/label.hpp>
#include <godot_cpp/classes/progress_bar.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * HUD - Heads-up display for game information
 * 
 * Shows health, stamina, ammo, and objectives.
 */
class HUD : public Control {
    GDCLASS(HUD, Control)

private:
    // UI element references
    Label* health_label = nullptr;
    Label* ammo_label = nullptr;
    Label* objective_label = nullptr;
    ProgressBar* health_bar = nullptr;
    ProgressBar* stamina_bar = nullptr;
    Node* crosshair = nullptr;
    
    // Cached values
    float current_health = 100.0f;
    float max_health = 100.0f;
    float current_stamina = 100.0f;
    float max_stamina = 100.0f;
    int current_ammo = 0;
    int reserve_ammo = 0;
    
    // Visual effects state
    float damage_flash_timer = 0.0f;
    float ammo_flash_timer = 0.0f;
    bool is_low_stamina = false;
    float stamina_pulse_time = 0.0f;
    
    // Effect constants
    const float DAMAGE_FLASH_DURATION = 0.3f;
    const float AMMO_FLASH_DURATION = 0.5f;
    const float LOW_STAMINA_THRESHOLD = 20.0f;
    const float STAMINA_PULSE_SPEED = 3.0f;

protected:
    static void _bind_methods();

public:
    HUD();
    ~HUD();

    void _ready() override;
    void _process(double delta) override;

    // Update methods
    void update_health(float health, float max);
    void update_stamina(float stamina, float max);
    void update_ammo(int mag_ammo, int reserve);
    void update_objective(const String& text);
    
    // Show/hide
    void show_hud();
    void hide_hud();
    
    // Crosshair
    void show_crosshair();
    void hide_crosshair();
    void set_crosshair_spread(float spread);
    void set_crosshair_color(const Color& color);
};

} // namespace godot

#endif // HUD_HPP
