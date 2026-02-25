#ifndef THIRD_PERSON_CAMERA_HPP
#define THIRD_PERSON_CAMERA_HPP

#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * ThirdPersonCamera - Hybrid TPS/FPS camera system
 * 
 * Features:
 * - Spring arm behavior with collision avoidance (TPS)
 * - First-person mode at head height (FPS)
 * - Smooth follow with configurable lag
 * - Aim mode (closer, offset for aiming)
 * - Camera shake for impacts/shooting
 * - Mode transition with smooth interpolation
 */
class ThirdPersonCamera : public Node3D {
    GDCLASS(ThirdPersonCamera, Node3D)

public:
    enum CameraMode {
        CAMERA_MODE_THIRD_PERSON = 0,
        CAMERA_MODE_FIRST_PERSON = 1
    };

private:
    // Camera mode
    CameraMode camera_mode = CAMERA_MODE_THIRD_PERSON;
    float fps_head_height = 1.7f;       // Eye height in FPS mode
    float mode_transition_speed = 8.0f; // Speed of TPS<->FPS transition
    bool hide_player_in_fps = true;     // Hide player mesh in FPS
    float fps_arm_transition = 0.0f;    // 0=TPS, 1=FPS (for smooth lerp)

    // Spring arm settings
    float arm_length = 3.5f;
    float min_arm_length = 1.0f;
    float arm_height = 1.5f;
    float shoulder_offset = 0.5f;  // Right shoulder offset
    
    // Aim mode settings
    float aim_arm_length = 1.8f;
    float aim_shoulder_offset = 0.8f;
    float aim_fov = 55.0f;
    float normal_fov = 75.0f;
    
    // Smoothing
    float follow_speed = 10.0f;
    float rotation_speed = 8.0f;
    float zoom_speed = 5.0f;
    
    // Collision
    float collision_margin = 0.2f;
    uint32_t collision_mask = 1;  // Default collision layer
    
    // Camera shake
    float shake_intensity = 0.0f;
    float shake_decay = 5.0f;
    
    // State
    bool is_aiming = false;
    float current_arm_length = 3.5f;
    float current_fov = 75.0f;
    Vector3 current_offset;
    
    // References
    Node3D* target = nullptr;
    Camera3D* camera = nullptr;
    
    // Internal methods
    void update_camera_position(double delta);
    void handle_collision();
    void apply_camera_shake(double delta);
    Vector3 get_target_position() const;

protected:
    static void _bind_methods();

public:
    ThirdPersonCamera();
    ~ThirdPersonCamera();

    void _ready() override;
    void _physics_process(double delta) override;

    // Arm settings
    void set_arm_length(float length) { arm_length = length; }
    float get_arm_length() const { return arm_length; }
    
    void set_min_arm_length(float length) { min_arm_length = length; }
    float get_min_arm_length() const { return min_arm_length; }
    
    void set_arm_height(float height) { arm_height = height; }
    float get_arm_height() const { return arm_height; }
    
    void set_shoulder_offset(float offset) { shoulder_offset = offset; }
    float get_shoulder_offset() const { return shoulder_offset; }
    
    // Aim settings
    void set_aim_arm_length(float length) { aim_arm_length = length; }
    float get_aim_arm_length() const { return aim_arm_length; }
    
    void set_aim_fov(float fov) { aim_fov = fov; }
    float get_aim_fov() const { return aim_fov; }
    
    void set_normal_fov(float fov) { normal_fov = fov; }
    float get_normal_fov() const { return normal_fov; }
    
    // Smoothing
    void set_follow_speed(float speed) { follow_speed = speed; }
    float get_follow_speed() const { return follow_speed; }
    
    // Target
    void set_target(Node3D* new_target);
    Node3D* get_target() const { return target; }
    
    // Actions
    void set_aiming(bool aiming);
    bool get_is_aiming() const { return is_aiming; }
    
    void add_camera_shake(float intensity);
    
    // Get the actual camera node
    Camera3D* get_camera() const { return camera; }
    
    // Camera mode (TPS/FPS)
    void set_camera_mode(int mode);
    int get_camera_mode() const { return static_cast<int>(camera_mode); }
    void toggle_camera_mode();
    
    void set_fps_head_height(float height) { fps_head_height = height; }
    float get_fps_head_height() const { return fps_head_height; }
    
    void set_mode_transition_speed(float speed) { mode_transition_speed = speed; }
    float get_mode_transition_speed() const { return mode_transition_speed; }
    
    void set_hide_player_in_fps(bool hide) { hide_player_in_fps = hide; }
    bool get_hide_player_in_fps() const { return hide_player_in_fps; }
    
    // Check current effective mode
    bool is_first_person() const { return camera_mode == CAMERA_MODE_FIRST_PERSON; }
};

} // namespace godot

VARIANT_ENUM_CAST(godot::ThirdPersonCamera::CameraMode);

#endif // THIRD_PERSON_CAMERA_HPP
