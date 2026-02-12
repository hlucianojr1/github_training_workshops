#ifndef AI_PERCEPTION_HPP
#define AI_PERCEPTION_HPP

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * AIPerception - Sensory system for AI
 * 
 * Handles sight and hearing for enemy detection.
 * Raycasts for line of sight, distance checks for sounds.
 */
class AIPerception : public Node3D {
    GDCLASS(AIPerception, Node3D)

private:
    // Sight
    float sight_range = 25.0f;
    float sight_angle = 120.0f;  // Degrees (cone in front)
    float peripheral_range = 8.0f;  // Can detect nearby even outside cone
    
    // Hearing
    float hearing_range = 15.0f;
    float gunshot_hearing_range = 40.0f;
    
    // Detection
    float detection_speed = 2.0f;  // How fast alert level rises
    float alert_decay_speed = 0.5f;  // How fast alert drops when no contact
    float current_alert_level = 0.0f;  // 0-100
    
    // Collision mask for raycasts
    uint32_t sight_collision_mask = 1;
    
    // Target tracking
    Array detected_targets;
    Node3D* primary_target = nullptr;
    String target_group = "player";  // Group to look for

protected:
    static void _bind_methods();

public:
    AIPerception();
    ~AIPerception();

    void _ready() override;
    void _physics_process(double delta) override;

    // Sight settings
    void set_sight_range(float range) { sight_range = range; }
    float get_sight_range() const { return sight_range; }
    
    void set_sight_angle(float angle) { sight_angle = angle; }
    float get_sight_angle() const { return sight_angle; }
    
    void set_peripheral_range(float range) { peripheral_range = range; }
    float get_peripheral_range() const { return peripheral_range; }

    // Hearing settings
    void set_hearing_range(float range) { hearing_range = range; }
    float get_hearing_range() const { return hearing_range; }
    
    void set_gunshot_hearing_range(float range) { gunshot_hearing_range = range; }
    float get_gunshot_hearing_range() const { return gunshot_hearing_range; }

    // Detection
    void set_target_group(const String& group) { target_group = group; }
    String get_target_group() const { return target_group; }
    
    float get_alert_level() const { return current_alert_level; }
    bool is_alerted() const { return current_alert_level > 50.0f; }
    bool is_fully_alerted() const { return current_alert_level >= 100.0f; }

    // Perception checks
    bool can_see_target(Node3D* target) const;
    bool can_hear_position(Vector3 position, bool is_gunshot = false) const;
    bool is_in_sight_cone(Vector3 position) const;
    bool has_line_of_sight(Vector3 position) const;
    
    // Target access
    Node3D* get_closest_target() const;
    Array get_all_detected_targets() const { return detected_targets; }
    
    // Manual alerts
    void alert_to_sound(Vector3 position, bool is_gunshot = false);
    void force_detect(Node3D* target);
    void clear_detection();

    // Signals
    // target_detected(Node3D* target)
    // target_lost(Node3D* target)
    // alert_level_changed(float level)
    // sound_heard(Vector3 position)
};

} // namespace godot

#endif // AI_PERCEPTION_HPP
