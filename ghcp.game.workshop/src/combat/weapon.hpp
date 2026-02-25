#ifndef WEAPON_HPP
#define WEAPON_HPP

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/immediate_mesh.hpp>
#include <godot_cpp/classes/standard_material3d.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * Weapon - Firearm system for combat
 * 
 * Handles shooting mechanics, ammo management, and weapon stats.
 */
class Weapon : public Node3D {
    GDCLASS(Weapon, Node3D)

public:
    enum class WeaponType {
        PISTOL,
        REVOLVER,
        SHOTGUN,
        RIFLE,
        MELEE
    };

    enum class FireMode {
        SEMI_AUTO,
        FULL_AUTO,
        BURST
    };

private:
    String weapon_id;
    String weapon_name;
    WeaponType weapon_type = WeaponType::PISTOL;
    FireMode fire_mode = FireMode::SEMI_AUTO;
    
    // Ammo
    String ammo_type = "ammo_45acp";
    int mag_capacity = 7;
    int current_mag_ammo = 7;
    int reserve_ammo = 24;
    
    // Performance
    float damage = 25.0f;
    float fire_rate = 0.3f;  // Time between shots
    int pellet_count = 1;   // Number of pellets per shot (shotguns fire multiple)
    float range = 50.0f;
    float accuracy = 0.95f;  // 0-1, affects spread
    float recoil = 2.0f;
    
    // Dynamic spread system
    float base_spread = 0.05f;         // Minimum spread (higher accuracy value = lower spread)
    float max_spread = 0.3f;           // Maximum spread during sustained fire
    float spread_increase_per_shot = 0.03f; // How much spread increases per shot
    float spread_recovery_rate = 2.0f;  // How fast spread recovers per second
    float current_spread = 0.05f;       // Current spread value (starts at base)
    float time_since_last_shot = 0.0f;  // Track time for spread recovery
    
    // Recoil properties (camera kick)
    float vertical_recoil = 0.8f;      // Degrees of vertical kick per shot
    float horizontal_recoil = 0.3f;    // Degrees of horizontal variance per shot
    float recoil_recovery_speed = 5.0f; // How fast recoil recovers (degrees per second)
    
    // Reload
    float reload_time = 2.0f;
    bool is_reloading = false;
    float reload_timer = 0.0f;
    
    // Reload animation phases (normalized 0-1 of reload_time)
    float reload_mag_out_time = 0.3f;  // When mag eject animation should play
    float reload_mag_in_time = 0.7f;   // When mag insert animation should play
    bool mag_out_triggered = false;    // Track if mag_out event fired
    bool mag_in_triggered = false;     // Track if mag_in event fired
    
    // State
    bool is_firing = false;
    float fire_timer = 0.0f;
    
    // Debug
    bool debug_draw = true;
    float debug_line_duration = 0.1f; // How long debug lines persist (seconds)
    
    // Debug visualization (using Array of Dictionaries for line storage)
    Array debug_lines;
    MeshInstance3D* debug_mesh_instance = nullptr;
    Ref<ImmediateMesh> debug_immediate_mesh;
    Ref<StandardMaterial3D> debug_material;

    // Physics filtering
    uint32_t hit_collision_mask = 1; // Default to layer 1; configure in inspector as needed.
    
    // Muzzle position for raycasting
    Node3D* muzzle_point = nullptr;
    
    // Internal methods
    void draw_debug_line(const Vector3& from, const Vector3& to, const Color& color);

protected:
    static void _bind_methods();

public:
    Weapon();
    ~Weapon();

    void _ready() override;
    void _process(double delta) override;

    // Weapon identity
    void set_weapon_id(const String& id) { weapon_id = id; }
    String get_weapon_id() const { return weapon_id; }
    
    void set_weapon_name(const String& name) { weapon_name = name; }
    String get_weapon_name() const { return weapon_name; }

    // Type
    void set_weapon_type(WeaponType type) { weapon_type = type; }
    WeaponType get_weapon_type() const { return weapon_type; }
    void set_weapon_type_int(int type) { weapon_type = static_cast<WeaponType>(type); }
    int get_weapon_type_int() const { return static_cast<int>(weapon_type); }

    // Ammo
    void set_ammo_type(const String& type) { ammo_type = type; }
    String get_ammo_type() const { return ammo_type; }
    
    void set_mag_capacity(int capacity) { mag_capacity = capacity; }
    int get_mag_capacity() const { return mag_capacity; }
    
    int get_current_mag_ammo() const { return current_mag_ammo; }
    int get_reserve_ammo() const { return reserve_ammo; }
    void add_ammo(int amount) { reserve_ammo += amount; }

    // Performance
    void set_damage(float dmg) { damage = dmg; }
    float get_damage() const { return damage; }
    
    void set_fire_rate(float rate) { fire_rate = rate; }
    float get_fire_rate() const { return fire_rate; }
    
    void set_pellet_count(int count) { pellet_count = Math::max(1, count); }
    int get_pellet_count() const { return pellet_count; }
    
    void set_range(float r) { range = r; }
    float get_range() const { return range; }
    
    void set_accuracy(float acc) { accuracy = Math::clamp(acc, 0.0f, 1.0f); }
    float get_accuracy() const { return accuracy; }
    
    void set_base_spread(float spread) { base_spread = spread; current_spread = spread; }
    float get_base_spread() const { return base_spread; }
    
    void set_max_spread(float spread) { max_spread = spread; }
    float get_max_spread() const { return max_spread; }
    
    void set_spread_increase_per_shot(float increase) { spread_increase_per_shot = increase; }
    float get_spread_increase_per_shot() const { return spread_increase_per_shot; }
    
    void set_spread_recovery_rate(float rate) { spread_recovery_rate = rate; }
    float get_spread_recovery_rate() const { return spread_recovery_rate; }
    
    float get_current_spread() const { return current_spread; }
    
    void set_vertical_recoil(float rec) { vertical_recoil = rec; }
    float get_vertical_recoil() const { return vertical_recoil; }
    
    void set_horizontal_recoil(float rec) { horizontal_recoil = rec; }
    float get_horizontal_recoil() const { return horizontal_recoil; }
    
    void set_recoil_recovery_speed(float speed) { recoil_recovery_speed = speed; }
    float get_recoil_recovery_speed() const { return recoil_recovery_speed; }
    
    // Reload animation timing
    void set_reload_mag_out_time(float time) { reload_mag_out_time = Math::clamp(time, 0.0f, 1.0f); }
    float get_reload_mag_out_time() const { return reload_mag_out_time; }
    
    void set_reload_mag_in_time(float time) { reload_mag_in_time = Math::clamp(time, 0.0f, 1.0f); }
    float get_reload_mag_in_time() const { return reload_mag_in_time; }

    // Physics filtering
    void set_hit_collision_mask(uint32_t mask) { hit_collision_mask = mask; }
    uint32_t get_hit_collision_mask() const { return hit_collision_mask; }
    
    // Debug settings
    void set_debug_draw(bool enabled) { debug_draw = enabled; }
    bool get_debug_draw() const { return debug_draw; }
    void set_debug_line_duration(float duration) { debug_line_duration = duration; }
    float get_debug_line_duration() const { return debug_line_duration; }

    // Actions
    void fire();
    void start_reload();
    void cancel_reload();
    bool can_fire() const;
    bool can_reload() const;
    
    // State
    bool get_is_reloading() const { return is_reloading; }
    bool has_ammo() const { return current_mag_ammo > 0; }
    float get_reload_progress() const;

    // Signals
    // weapon_fired()
    // weapon_empty()
    // reload_started()
    // reload_mag_out()          - Magazine eject animation hook
    // reload_mag_in()           - Magazine insert animation hook
    // reload_finished()
    // reload_cancelled()        - Reload was interrupted
    // ammo_changed(int mag_ammo, int reserve_ammo)
};

} // namespace godot

#endif // WEAPON_HPP
