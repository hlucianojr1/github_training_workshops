#include "third_person_camera.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/world3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void ThirdPersonCamera::_bind_methods() {
    // Camera mode enum
    BIND_ENUM_CONSTANT(CAMERA_MODE_THIRD_PERSON);
    BIND_ENUM_CONSTANT(CAMERA_MODE_FIRST_PERSON);
    
    // Camera mode
    ClassDB::bind_method(D_METHOD("set_camera_mode", "mode"), &ThirdPersonCamera::set_camera_mode);
    ClassDB::bind_method(D_METHOD("get_camera_mode"), &ThirdPersonCamera::get_camera_mode);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "camera_mode", PROPERTY_HINT_ENUM, "Third Person,First Person"), "set_camera_mode", "get_camera_mode");
    
    ClassDB::bind_method(D_METHOD("toggle_camera_mode"), &ThirdPersonCamera::toggle_camera_mode);
    ClassDB::bind_method(D_METHOD("is_first_person"), &ThirdPersonCamera::is_first_person);
    
    ClassDB::bind_method(D_METHOD("set_fps_head_height", "height"), &ThirdPersonCamera::set_fps_head_height);
    ClassDB::bind_method(D_METHOD("get_fps_head_height"), &ThirdPersonCamera::get_fps_head_height);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "fps_head_height", PROPERTY_HINT_RANGE, "1.0,2.5,0.05"), "set_fps_head_height", "get_fps_head_height");
    
    ClassDB::bind_method(D_METHOD("set_mode_transition_speed", "speed"), &ThirdPersonCamera::set_mode_transition_speed);
    ClassDB::bind_method(D_METHOD("get_mode_transition_speed"), &ThirdPersonCamera::get_mode_transition_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mode_transition_speed", PROPERTY_HINT_RANGE, "1.0,20.0,0.5"), "set_mode_transition_speed", "get_mode_transition_speed");
    
    ClassDB::bind_method(D_METHOD("set_hide_player_in_fps", "hide"), &ThirdPersonCamera::set_hide_player_in_fps);
    ClassDB::bind_method(D_METHOD("get_hide_player_in_fps"), &ThirdPersonCamera::get_hide_player_in_fps);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "hide_player_in_fps"), "set_hide_player_in_fps", "get_hide_player_in_fps");
    
    // Signal for mode changes
    ADD_SIGNAL(MethodInfo("camera_mode_changed",
        PropertyInfo(Variant::INT, "new_mode"),
        PropertyInfo(Variant::BOOL, "is_first_person")));

    // Arm settings
    ClassDB::bind_method(D_METHOD("set_arm_length", "length"), &ThirdPersonCamera::set_arm_length);
    ClassDB::bind_method(D_METHOD("get_arm_length"), &ThirdPersonCamera::get_arm_length);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "arm_length", PROPERTY_HINT_RANGE, "1.0,10.0,0.1"), "set_arm_length", "get_arm_length");

    ClassDB::bind_method(D_METHOD("set_min_arm_length", "length"), &ThirdPersonCamera::set_min_arm_length);
    ClassDB::bind_method(D_METHOD("get_min_arm_length"), &ThirdPersonCamera::get_min_arm_length);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "min_arm_length", PROPERTY_HINT_RANGE, "0.5,5.0,0.1"), "set_min_arm_length", "get_min_arm_length");

    ClassDB::bind_method(D_METHOD("set_arm_height", "height"), &ThirdPersonCamera::set_arm_height);
    ClassDB::bind_method(D_METHOD("get_arm_height"), &ThirdPersonCamera::get_arm_height);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "arm_height", PROPERTY_HINT_RANGE, "0.0,5.0,0.1"), "set_arm_height", "get_arm_height");

    ClassDB::bind_method(D_METHOD("set_shoulder_offset", "offset"), &ThirdPersonCamera::set_shoulder_offset);
    ClassDB::bind_method(D_METHOD("get_shoulder_offset"), &ThirdPersonCamera::get_shoulder_offset);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "shoulder_offset", PROPERTY_HINT_RANGE, "-2.0,2.0,0.1"), "set_shoulder_offset", "get_shoulder_offset");

    // Aim settings
    ClassDB::bind_method(D_METHOD("set_aim_arm_length", "length"), &ThirdPersonCamera::set_aim_arm_length);
    ClassDB::bind_method(D_METHOD("get_aim_arm_length"), &ThirdPersonCamera::get_aim_arm_length);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "aim_arm_length", PROPERTY_HINT_RANGE, "0.5,5.0,0.1"), "set_aim_arm_length", "get_aim_arm_length");

    ClassDB::bind_method(D_METHOD("set_aim_fov", "fov"), &ThirdPersonCamera::set_aim_fov);
    ClassDB::bind_method(D_METHOD("get_aim_fov"), &ThirdPersonCamera::get_aim_fov);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "aim_fov", PROPERTY_HINT_RANGE, "30.0,90.0,1.0"), "set_aim_fov", "get_aim_fov");

    ClassDB::bind_method(D_METHOD("set_normal_fov", "fov"), &ThirdPersonCamera::set_normal_fov);
    ClassDB::bind_method(D_METHOD("get_normal_fov"), &ThirdPersonCamera::get_normal_fov);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "normal_fov", PROPERTY_HINT_RANGE, "50.0,120.0,1.0"), "set_normal_fov", "get_normal_fov");

    // Smoothing
    ClassDB::bind_method(D_METHOD("set_follow_speed", "speed"), &ThirdPersonCamera::set_follow_speed);
    ClassDB::bind_method(D_METHOD("get_follow_speed"), &ThirdPersonCamera::get_follow_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "follow_speed", PROPERTY_HINT_RANGE, "1.0,30.0,0.5"), "set_follow_speed", "get_follow_speed");

    // Target
    ClassDB::bind_method(D_METHOD("set_target", "target"), &ThirdPersonCamera::set_target);
    ClassDB::bind_method(D_METHOD("get_target"), &ThirdPersonCamera::get_target);

    // Actions
    ClassDB::bind_method(D_METHOD("set_aiming", "aiming"), &ThirdPersonCamera::set_aiming);
    ClassDB::bind_method(D_METHOD("get_is_aiming"), &ThirdPersonCamera::get_is_aiming);
    ClassDB::bind_method(D_METHOD("add_camera_shake", "intensity"), &ThirdPersonCamera::add_camera_shake);
}

ThirdPersonCamera::ThirdPersonCamera() {
    current_arm_length = arm_length;
    current_fov = normal_fov;
    current_offset = Vector3();
}

ThirdPersonCamera::~ThirdPersonCamera() {
}

void ThirdPersonCamera::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // Find or create camera child
    camera = Object::cast_to<Camera3D>(get_node_or_null(NodePath("Camera3D")));
    if (!camera) {
        // Camera should be added as child in scene, but fallback
        UtilityFunctions::printerr("ThirdPersonCamera: No Camera3D child found!");
    }

    // Try to find player as target if not set
    if (!target) {
        target = Object::cast_to<Node3D>(get_tree()->get_first_node_in_group("player"));
    }

    current_arm_length = arm_length;
    current_fov = normal_fov;

    UtilityFunctions::print("ThirdPersonCamera ready");
}

void ThirdPersonCamera::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    if (!target || !camera) {
        return;
    }

    update_camera_position(delta);
    handle_collision();
    apply_camera_shake(delta);
}

void ThirdPersonCamera::update_camera_position(double delta) {
    // Update mode transition value (0=TPS, 1=FPS)
    float target_transition = (camera_mode == CAMERA_MODE_FIRST_PERSON) ? 1.0f : 0.0f;
    fps_arm_transition = Math::lerp(fps_arm_transition, target_transition, 
                                     static_cast<float>(delta) * mode_transition_speed);
    
    // First-person mode: camera at head height, no offset
    if (fps_arm_transition > 0.99f) {
        // Pure FPS mode
        Vector3 fps_pos = target->get_global_position() + Vector3(0, fps_head_height, 0);
        set_global_position(fps_pos);
        set_global_rotation(target->get_global_rotation());
        
        if (camera) {
            camera->set_position(Vector3(0, 0, 0));
            float target_fov_value = is_aiming ? aim_fov : normal_fov;
            current_fov = Math::lerp(current_fov, target_fov_value, static_cast<float>(delta) * zoom_speed);
            camera->set_fov(current_fov);
        }
        return;
    }
    
    // Target arm length and offset based on aim state
    float target_arm = is_aiming ? aim_arm_length : arm_length;
    float target_offset = is_aiming ? aim_shoulder_offset : shoulder_offset;
    float target_fov_value = is_aiming ? aim_fov : normal_fov;
    
    // Blend arm length toward 0 as we approach FPS mode
    target_arm = Math::lerp(target_arm, 0.0f, fps_arm_transition);
    target_offset = Math::lerp(target_offset, 0.0f, fps_arm_transition);
    float blended_height = Math::lerp(arm_height, fps_head_height, fps_arm_transition);

    // Smooth interpolation
    current_arm_length = Math::lerp(current_arm_length, target_arm, static_cast<float>(delta) * zoom_speed);
    current_fov = Math::lerp(current_fov, target_fov_value, static_cast<float>(delta) * zoom_speed);
    
    if (camera) {
        camera->set_fov(current_fov);
    }

    // Calculate target position
    Vector3 target_pos = get_target_position();
    
    // Smooth follow
    Vector3 current_pos = get_global_position();
    Vector3 new_pos = current_pos.lerp(target_pos, static_cast<float>(delta) * follow_speed);
    set_global_position(new_pos);

    // Calculate camera local position (behind and above player)
    Vector3 camera_offset;
    camera_offset.x = Math::lerp(current_offset.x, target_offset, static_cast<float>(delta) * zoom_speed);
    camera_offset.y = blended_height;
    camera_offset.z = current_arm_length;
    current_offset.x = camera_offset.x;

    if (camera) {
        camera->set_position(camera_offset);
    }

    // Match target rotation for looking
    set_global_rotation(target->get_global_rotation());
}

void ThirdPersonCamera::handle_collision() {
    // Skip collision in first-person mode
    if (camera_mode == CAMERA_MODE_FIRST_PERSON || fps_arm_transition > 0.5f) {
        return;
    }
    
    if (!camera || !target) {
        return;
    }

    // Raycast from target to camera to detect obstacles
    Vector3 from = target->get_global_position() + Vector3(0, arm_height, 0);
    Vector3 to = camera->get_global_position();
    Vector3 direction = (to - from).normalized();
    float max_distance = from.distance_to(to);

    PhysicsDirectSpaceState3D* space_state = get_world_3d()->get_direct_space_state();
    if (!space_state) {
        return;
    }

    Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(from, to, collision_mask);
    // Note: Cannot exclude by RID in Godot 4.3, rely on collision mask instead

    Dictionary result = space_state->intersect_ray(query);
    
    if (!result.is_empty()) {
        Vector3 collision_point = result["position"];
        float collision_distance = from.distance_to(collision_point) - collision_margin;
        
        if (collision_distance < max_distance && collision_distance > min_arm_length) {
            // Move camera to collision point
            Vector3 new_camera_pos = from + direction * collision_distance;
            camera->set_global_position(new_camera_pos);
        } else if (collision_distance <= min_arm_length) {
            // At minimum distance
            Vector3 new_camera_pos = from + direction * min_arm_length;
            camera->set_global_position(new_camera_pos);
        }
    }
}

void ThirdPersonCamera::apply_camera_shake(double delta) {
    if (shake_intensity > 0.01f && camera) {
        // Apply random offset based on shake intensity
        Vector3 shake_offset;
        shake_offset.x = (UtilityFunctions::randf() - 0.5f) * 2.0f * shake_intensity;
        shake_offset.y = (UtilityFunctions::randf() - 0.5f) * 2.0f * shake_intensity;
        shake_offset.z = 0;
        
        Vector3 current_pos = camera->get_position();
        camera->set_position(current_pos + shake_offset);
        
        // Decay shake
        shake_intensity = Math::lerp(shake_intensity, 0.0f, static_cast<float>(delta) * shake_decay);
    }
}

Vector3 ThirdPersonCamera::get_target_position() const {
    if (target) {
        return target->get_global_position();
    }
    return Vector3();
}

void ThirdPersonCamera::set_target(Node3D* new_target) {
    target = new_target;
}

void ThirdPersonCamera::set_aiming(bool aiming) {
    is_aiming = aiming;
}

void ThirdPersonCamera::add_camera_shake(float intensity) {
    shake_intensity = Math::max(shake_intensity, intensity);
}

void ThirdPersonCamera::set_camera_mode(int mode) {
    CameraMode new_mode = static_cast<CameraMode>(mode);
    if (new_mode != camera_mode) {
        camera_mode = new_mode;
        emit_signal("camera_mode_changed", mode, camera_mode == CAMERA_MODE_FIRST_PERSON);
        UtilityFunctions::print("Camera mode changed to: ", 
            camera_mode == CAMERA_MODE_FIRST_PERSON ? "First Person" : "Third Person");
    }
}

void ThirdPersonCamera::toggle_camera_mode() {
    if (camera_mode == CAMERA_MODE_THIRD_PERSON) {
        set_camera_mode(CAMERA_MODE_FIRST_PERSON);
    } else {
        set_camera_mode(CAMERA_MODE_THIRD_PERSON);
    }
}

} // namespace godot
