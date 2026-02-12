#include "ai_perception.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/world3d.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void AIPerception::_bind_methods() {
    // Sight
    ClassDB::bind_method(D_METHOD("set_sight_range", "range"), &AIPerception::set_sight_range);
    ClassDB::bind_method(D_METHOD("get_sight_range"), &AIPerception::get_sight_range);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "sight_range", PROPERTY_HINT_RANGE, "1.0,100.0,0.5"), "set_sight_range", "get_sight_range");

    ClassDB::bind_method(D_METHOD("set_sight_angle", "angle"), &AIPerception::set_sight_angle);
    ClassDB::bind_method(D_METHOD("get_sight_angle"), &AIPerception::get_sight_angle);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "sight_angle", PROPERTY_HINT_RANGE, "30.0,360.0,5.0"), "set_sight_angle", "get_sight_angle");

    ClassDB::bind_method(D_METHOD("set_peripheral_range", "range"), &AIPerception::set_peripheral_range);
    ClassDB::bind_method(D_METHOD("get_peripheral_range"), &AIPerception::get_peripheral_range);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "peripheral_range", PROPERTY_HINT_RANGE, "1.0,20.0,0.5"), "set_peripheral_range", "get_peripheral_range");

    // Hearing
    ClassDB::bind_method(D_METHOD("set_hearing_range", "range"), &AIPerception::set_hearing_range);
    ClassDB::bind_method(D_METHOD("get_hearing_range"), &AIPerception::get_hearing_range);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "hearing_range", PROPERTY_HINT_RANGE, "1.0,50.0,0.5"), "set_hearing_range", "get_hearing_range");

    ClassDB::bind_method(D_METHOD("set_gunshot_hearing_range", "range"), &AIPerception::set_gunshot_hearing_range);
    ClassDB::bind_method(D_METHOD("get_gunshot_hearing_range"), &AIPerception::get_gunshot_hearing_range);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "gunshot_hearing_range", PROPERTY_HINT_RANGE, "10.0,100.0,1.0"), "set_gunshot_hearing_range", "get_gunshot_hearing_range");

    // Detection
    ClassDB::bind_method(D_METHOD("set_target_group", "group"), &AIPerception::set_target_group);
    ClassDB::bind_method(D_METHOD("get_target_group"), &AIPerception::get_target_group);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "target_group"), "set_target_group", "get_target_group");

    ClassDB::bind_method(D_METHOD("get_alert_level"), &AIPerception::get_alert_level);
    ClassDB::bind_method(D_METHOD("is_alerted"), &AIPerception::is_alerted);
    ClassDB::bind_method(D_METHOD("is_fully_alerted"), &AIPerception::is_fully_alerted);

    // Perception checks
    ClassDB::bind_method(D_METHOD("can_see_target", "target"), &AIPerception::can_see_target);
    ClassDB::bind_method(D_METHOD("can_hear_position", "position", "is_gunshot"), &AIPerception::can_hear_position, DEFVAL(false));
    ClassDB::bind_method(D_METHOD("is_in_sight_cone", "position"), &AIPerception::is_in_sight_cone);
    ClassDB::bind_method(D_METHOD("has_line_of_sight", "position"), &AIPerception::has_line_of_sight);

    // Target access
    ClassDB::bind_method(D_METHOD("get_closest_target"), &AIPerception::get_closest_target);
    ClassDB::bind_method(D_METHOD("get_all_detected_targets"), &AIPerception::get_all_detected_targets);

    // Manual alerts
    ClassDB::bind_method(D_METHOD("alert_to_sound", "position", "is_gunshot"), &AIPerception::alert_to_sound, DEFVAL(false));
    ClassDB::bind_method(D_METHOD("force_detect", "target"), &AIPerception::force_detect);
    ClassDB::bind_method(D_METHOD("clear_detection"), &AIPerception::clear_detection);

    // Signals
    ADD_SIGNAL(MethodInfo("target_detected", PropertyInfo(Variant::OBJECT, "target")));
    ADD_SIGNAL(MethodInfo("target_lost", PropertyInfo(Variant::OBJECT, "target")));
    ADD_SIGNAL(MethodInfo("alert_level_changed", PropertyInfo(Variant::FLOAT, "level")));
    ADD_SIGNAL(MethodInfo("sound_heard", PropertyInfo(Variant::VECTOR3, "position")));
}

AIPerception::AIPerception() {
    current_alert_level = 0.0f;
    target_group = "player";
}

AIPerception::~AIPerception() {
}

void AIPerception::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }
}

void AIPerception::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    float dt = static_cast<float>(delta);
    bool any_detected = false;

    // Get all potential targets from group
    Array targets = get_tree()->get_nodes_in_group(target_group);
    Array new_detected;

    for (int i = 0; i < targets.size(); i++) {
        Node3D* potential_target = Object::cast_to<Node3D>(targets[i]);
        if (!potential_target) {
            continue;
        }

        if (can_see_target(potential_target)) {
            any_detected = true;
            new_detected.append(potential_target);

            // Check if newly detected
            if (!detected_targets.has(potential_target)) {
                emit_signal("target_detected", potential_target);
            }
        }
    }

    // Check for lost targets
    for (int i = 0; i < detected_targets.size(); i++) {
        Node3D* old_target = Object::cast_to<Node3D>(detected_targets[i]);
        if (old_target && !new_detected.has(old_target)) {
            emit_signal("target_lost", old_target);
        }
    }

    detected_targets = new_detected;

    // Update alert level
    float old_alert = current_alert_level;
    
    if (any_detected) {
        current_alert_level = Math::min(100.0f, current_alert_level + detection_speed * dt * 50.0f);
    } else {
        current_alert_level = Math::max(0.0f, current_alert_level - alert_decay_speed * dt * 10.0f);
    }

    if (Math::abs(current_alert_level - old_alert) > 0.1f) {
        emit_signal("alert_level_changed", current_alert_level);
    }

    // Update primary target (closest)
    primary_target = get_closest_target();
}

bool AIPerception::can_see_target(Node3D* target) const {
    if (!target) {
        return false;
    }

    Vector3 target_pos = target->get_global_position();
    Vector3 my_pos = get_global_position();
    float distance = my_pos.distance_to(target_pos);

    // Within peripheral range - always detected
    if (distance <= peripheral_range) {
        return has_line_of_sight(target_pos);
    }

    // Beyond sight range - never detected
    if (distance > sight_range) {
        return false;
    }

    // Check if in sight cone and has line of sight
    return is_in_sight_cone(target_pos) && has_line_of_sight(target_pos);
}

bool AIPerception::can_hear_position(Vector3 position, bool is_gunshot) const {
    float range = is_gunshot ? gunshot_hearing_range : hearing_range;
    float distance = get_global_position().distance_to(position);
    return distance <= range;
}

bool AIPerception::is_in_sight_cone(Vector3 position) const {
    Vector3 to_target = (position - get_global_position()).normalized();
    Vector3 forward = -get_global_transform().basis.get_column(2);  // -Z is forward
    
    float dot = forward.dot(to_target);
    float angle = Math::rad_to_deg(Math::acos(dot));
    
    return angle <= sight_angle / 2.0f;
}

bool AIPerception::has_line_of_sight(Vector3 position) const {
    PhysicsDirectSpaceState3D* space_state = get_world_3d()->get_direct_space_state();
    if (!space_state) {
        return false;
    }

    Vector3 from = get_global_position() + Vector3(0, 1.5f, 0);  // Eye height
    Vector3 to = position + Vector3(0, 1.0f, 0);  // Target center mass

    Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(from, to, sight_collision_mask);
    query->set_exclude(Array());  // Exclude self

    Dictionary result = space_state->intersect_ray(query);
    
    if (result.is_empty()) {
        return true;  // No obstruction
    }

    // Check if we hit the target or something blocking
    // If hit position is very close to target, we can see them
    Vector3 hit_pos = result["position"];
    return hit_pos.distance_to(position) < 1.0f;
}

Node3D* AIPerception::get_closest_target() const {
    if (detected_targets.is_empty()) {
        return nullptr;
    }

    Node3D* closest = nullptr;
    float closest_dist = Math_INF;
    Vector3 my_pos = get_global_position();

    for (int i = 0; i < detected_targets.size(); i++) {
        Node3D* target = Object::cast_to<Node3D>(detected_targets[i]);
        if (target) {
            float dist = my_pos.distance_to(target->get_global_position());
            if (dist < closest_dist) {
                closest_dist = dist;
                closest = target;
            }
        }
    }

    return closest;
}

void AIPerception::alert_to_sound(Vector3 position, bool is_gunshot) {
    if (can_hear_position(position, is_gunshot)) {
        // Increase alert based on sound type
        float alert_boost = is_gunshot ? 50.0f : 25.0f;
        current_alert_level = Math::min(100.0f, current_alert_level + alert_boost);
        
        emit_signal("sound_heard", position);
        emit_signal("alert_level_changed", current_alert_level);
    }
}

void AIPerception::force_detect(Node3D* target) {
    if (target && !detected_targets.has(target)) {
        detected_targets.append(target);
        current_alert_level = 100.0f;
        emit_signal("target_detected", target);
        emit_signal("alert_level_changed", current_alert_level);
    }
}

void AIPerception::clear_detection() {
    for (int i = 0; i < detected_targets.size(); i++) {
        emit_signal("target_lost", detected_targets[i]);
    }
    detected_targets.clear();
    current_alert_level = 0.0f;
    primary_target = nullptr;
    emit_signal("alert_level_changed", current_alert_level);
}

} // namespace godot
