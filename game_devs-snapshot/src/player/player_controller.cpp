#include "player_controller.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/input_event_mouse_motion.hpp>
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/physics_shape_query_parameters3d.hpp>
#include <godot_cpp/classes/sphere_shape3d.hpp>
#include <godot_cpp/classes/world3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

#include "../inventory/inventory.hpp"
#include "../survival/survival_stats.hpp"
#include "../combat/weapon.hpp"
#include "../combat/damage_system.hpp"

namespace godot {

void PlayerController::_bind_methods() {
    // Movement properties
    ClassDB::bind_method(D_METHOD("set_walk_speed", "speed"), &PlayerController::set_walk_speed);
    ClassDB::bind_method(D_METHOD("get_walk_speed"), &PlayerController::get_walk_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "walk_speed", PROPERTY_HINT_RANGE, "1.0,20.0,0.1"), "set_walk_speed", "get_walk_speed");

    ClassDB::bind_method(D_METHOD("set_sprint_speed", "speed"), &PlayerController::set_sprint_speed);
    ClassDB::bind_method(D_METHOD("get_sprint_speed"), &PlayerController::get_sprint_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "sprint_speed", PROPERTY_HINT_RANGE, "1.0,30.0,0.1"), "set_sprint_speed", "get_sprint_speed");

    ClassDB::bind_method(D_METHOD("set_crouch_speed", "speed"), &PlayerController::set_crouch_speed);
    ClassDB::bind_method(D_METHOD("get_crouch_speed"), &PlayerController::get_crouch_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "crouch_speed", PROPERTY_HINT_RANGE, "0.5,10.0,0.1"), "set_crouch_speed", "get_crouch_speed");

    ClassDB::bind_method(D_METHOD("set_jump_velocity", "velocity"), &PlayerController::set_jump_velocity);
    ClassDB::bind_method(D_METHOD("get_jump_velocity"), &PlayerController::get_jump_velocity);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "jump_velocity", PROPERTY_HINT_RANGE, "1.0,15.0,0.1"), "set_jump_velocity", "get_jump_velocity");

    ClassDB::bind_method(D_METHOD("set_mouse_sensitivity", "sensitivity"), &PlayerController::set_mouse_sensitivity);
    ClassDB::bind_method(D_METHOD("get_mouse_sensitivity"), &PlayerController::get_mouse_sensitivity);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mouse_sensitivity", PROPERTY_HINT_RANGE, "0.0001,0.01,0.0001"), "set_mouse_sensitivity", "get_mouse_sensitivity");

    // State queries
    ClassDB::bind_method(D_METHOD("get_is_aiming"), &PlayerController::get_is_aiming);
    ClassDB::bind_method(D_METHOD("get_is_crouching"), &PlayerController::get_is_crouching);
    ClassDB::bind_method(D_METHOD("get_is_on_ground"), &PlayerController::get_is_on_ground);

    // Actions
    ClassDB::bind_method(D_METHOD("start_aim"), &PlayerController::start_aim);
    ClassDB::bind_method(D_METHOD("stop_aim"), &PlayerController::stop_aim);
    ClassDB::bind_method(D_METHOD("toggle_crouch"), &PlayerController::toggle_crouch);
    ClassDB::bind_method(D_METHOD("interact"), &PlayerController::interact);
    ClassDB::bind_method(D_METHOD("shoot"), &PlayerController::shoot);
    ClassDB::bind_method(D_METHOD("reload"), &PlayerController::reload);
    ClassDB::bind_method(D_METHOD("melee_attack"), &PlayerController::melee_attack);
    ClassDB::bind_method(D_METHOD("on_weapon_recoil", "vertical", "horizontal"), &PlayerController::on_weapon_recoil);
    ClassDB::bind_method(D_METHOD("on_player_died"), &PlayerController::on_player_died);

    // Signals
    ADD_SIGNAL(MethodInfo("movement_state_changed", PropertyInfo(Variant::INT, "new_state")));
    ADD_SIGNAL(MethodInfo("weapon_fired"));
    ADD_SIGNAL(MethodInfo("weapon_reloaded"));
    ADD_SIGNAL(MethodInfo("player_interacted", PropertyInfo(Variant::OBJECT, "target")));
    ADD_SIGNAL(MethodInfo("aim_state_changed", PropertyInfo(Variant::BOOL, "is_aiming")));
    ADD_SIGNAL(MethodInfo("player_died"));
    ADD_SIGNAL(MethodInfo("game_over"));
    ADD_SIGNAL(MethodInfo("melee_performed"));
}

PlayerController::PlayerController() {
    movement_state = MovementState::IDLE;
    is_aiming = false;
    is_crouching = false;
    can_sprint = true;
    is_dead = false;
    input_direction = Vector2();
    mouse_motion = Vector2();
}

PlayerController::~PlayerController() {
}

void PlayerController::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // Capture mouse for FPS-style control
    Input::get_singleton()->set_mouse_mode(Input::MOUSE_MODE_CAPTURED);

    // Get node references
    camera_pivot = Object::cast_to<Node3D>(get_node_or_null(NodePath("CameraPivot")));
    inventory = Object::cast_to<Inventory>(get_node_or_null(NodePath("Inventory")));
    survival_stats = Object::cast_to<SurvivalStats>(get_node_or_null(NodePath("SurvivalStats")));

    // Auto-equip a child Weapon if present (common test-scene setup).
    if (!equipped_weapon) {
        equipped_weapon = Object::cast_to<Weapon>(get_node_or_null(NodePath("Weapon")));
        if (equipped_weapon) {
            UtilityFunctions::print("PlayerController: auto-equipped Weapon child.");
            
            // Connect weapon recoil signal
            if (!equipped_weapon->is_connected("weapon_recoil", Callable(this, "on_weapon_recoil"))) {
                equipped_weapon->connect("weapon_recoil", Callable(this, "on_weapon_recoil"));
            }
        } else {
            UtilityFunctions::printerr("PlayerController: no equipped weapon (missing 'Weapon' child).");
        }
    }
    
    // Connect to SurvivalStats death signal
    if (survival_stats && survival_stats->has_signal("player_died")) {
        if (!survival_stats->is_connected("player_died", Callable(this, "on_player_died"))) {
            survival_stats->connect("player_died", Callable(this, "on_player_died"));
            UtilityFunctions::print("PlayerController: connected to SurvivalStats.player_died signal.");
        }
    }

    UtilityFunctions::print("PlayerController ready");
}

void PlayerController::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint() || is_dead) {
        return; // Don't process movement if dead
    }

    handle_rotation(delta);
    handle_movement(delta);
    update_movement_state();
}

void PlayerController::_input(const Ref<InputEvent>& event) {
    if (Engine::get_singleton()->is_editor_hint() || is_dead) {
        return; // Don't process input if dead
    }

    // Handle mouse look
    Ref<InputEventMouseMotion> mouse_event = event;
    if (mouse_event.is_valid()) {
        mouse_motion = mouse_event->get_relative();
    }

    // Handle input actions
    Input* input = Input::get_singleton();
    
    // Aim toggle (right mouse button)
    if (input->is_action_just_pressed("aim")) {
        start_aim();
    }
    if (input->is_action_just_released("aim")) {
        stop_aim();
    }

    // Shoot (left mouse button)
    if (input->is_action_just_pressed("shoot")) {
        UtilityFunctions::print("[PlayerController] Shoot input detected");
        shoot();
    }

    // Crouch toggle
    if (input->is_action_just_pressed("crouch")) {
        toggle_crouch();
    }

    // Reload
    if (input->is_action_just_pressed("reload")) {
        reload();
    }
    
    // Melee attack (V key)
    if (input->is_action_just_pressed("melee")) {
        melee_attack();
    }

    // Interact
    if (input->is_action_just_pressed("interact")) {
        interact();
    }

    // Escape to release mouse
    if (input->is_action_just_pressed("ui_cancel")) {
        if (Input::get_singleton()->get_mouse_mode() == Input::MOUSE_MODE_CAPTURED) {
            Input::get_singleton()->set_mouse_mode(Input::MOUSE_MODE_VISIBLE);
        } else {
            Input::get_singleton()->set_mouse_mode(Input::MOUSE_MODE_CAPTURED);
        }
    }
}

void PlayerController::handle_movement(double delta) {
    Input* input = Input::get_singleton();
    
    // Get input direction
    input_direction = input->get_vector("move_left", "move_right", "move_forward", "move_backward");
    
    // Apply gravity
    Vector3 velocity = get_velocity();
    if (!is_on_floor()) {
        velocity.y -= gravity * delta;
    }

    // Handle jump
    if (input->is_action_just_pressed("jump") && is_on_floor()) {
        velocity.y = jump_velocity;
    }

    // Calculate movement direction relative to camera
    Vector3 direction = Vector3();
    if (input_direction != Vector2()) {
        Transform3D camera_transform = get_global_transform();
        Vector3 forward = -camera_transform.basis.get_column(2);
        Vector3 right = camera_transform.basis.get_column(0);
        
        forward.y = 0;
        right.y = 0;
        forward = forward.normalized();
        right = right.normalized();
        
        direction = (forward * -input_direction.y + right * input_direction.x).normalized();
    }

    // Apply movement
    float target_speed = get_current_speed();
    
    if (direction != Vector3()) {
        float accel = is_on_floor() ? acceleration : acceleration * air_control;
        velocity.x = static_cast<float>(Math::move_toward(static_cast<double>(velocity.x), static_cast<double>(direction.x * target_speed), accel * delta));
        velocity.z = static_cast<float>(Math::move_toward(static_cast<double>(velocity.z), static_cast<double>(direction.z * target_speed), accel * delta));
    } else {
        float decel = is_on_floor() ? deceleration : deceleration * air_control;
        velocity.x = static_cast<float>(Math::move_toward(static_cast<double>(velocity.x), 0.0, decel * delta));
        velocity.z = static_cast<float>(Math::move_toward(static_cast<double>(velocity.z), 0.0, decel * delta));
    }

    set_velocity(velocity);
    move_and_slide();
}

void PlayerController::handle_rotation(double delta) {
    float dt = static_cast<float>(delta);
    
    // Apply recoil recovery
    if (current_recoil_vertical > 0.0f) {
        current_recoil_vertical = Math::max(0.0f, current_recoil_vertical - recoil_recovery_rate * dt);
    }
    if (Math::abs(current_recoil_horizontal) > 0.01f) {
        current_recoil_horizontal = Math::lerp(current_recoil_horizontal, 0.0f, recoil_recovery_rate * 0.5f * dt);
    }
    
    // Horizontal rotation (yaw) - rotate the whole character
    float yaw_input = -mouse_motion.x * mouse_sensitivity;
    rotate_y(yaw_input);

    // Vertical rotation (pitch) - rotate only the camera pivot
    if (camera_pivot) {
        float pitch_input = -mouse_motion.y * mouse_sensitivity;
        
        // Apply both mouse input and recoil to camera rotation
        camera_pivot->rotate_x(pitch_input);
        
        // Clamp vertical look angle (factoring in recoil offset)
        Vector3 rotation = camera_pivot->get_rotation();
        float recoil_offset = Math::deg_to_rad(current_recoil_vertical);
        float target_pitch = rotation.x + recoil_offset;
        target_pitch = Math::clamp(target_pitch, Math::deg_to_rad(-80.0f), Math::deg_to_rad(80.0f));
        rotation.x = target_pitch;
        camera_pivot->set_rotation(rotation);
    }

    // Reset mouse motion for next frame
    mouse_motion = Vector2();
}

void PlayerController::update_movement_state() {
    MovementState new_state = MovementState::IDLE;
    Input* input = Input::get_singleton();
    
    Vector3 horizontal_velocity = get_velocity();
    horizontal_velocity.y = 0;
    float speed = horizontal_velocity.length();

    if (speed > 0.1f) {
        if (is_crouching) {
            new_state = MovementState::CROUCHING;
        } else if (input->is_action_pressed("sprint") && can_sprint && !is_aiming) {
            new_state = MovementState::SPRINTING;
        } else if (speed > walk_speed * 0.9f) {
            new_state = MovementState::RUNNING;
        } else {
            new_state = MovementState::WALKING;
        }
    } else if (is_crouching) {
        new_state = MovementState::CROUCHING;
    }

    if (new_state != movement_state) {
        movement_state = new_state;
        emit_signal("movement_state_changed", static_cast<int>(movement_state));
    }
}

float PlayerController::get_current_speed() const {
    Input* input = Input::get_singleton();
    
    if (is_crouching) {
        return crouch_speed;
    }
    
    if (input->is_action_pressed("sprint") && can_sprint && !is_aiming) {
        return sprint_speed;
    }
    
    return walk_speed;
}

void PlayerController::start_aim() {
    is_aiming = true;
    emit_signal("aim_state_changed", true);
}

void PlayerController::stop_aim() {
    is_aiming = false;
    emit_signal("aim_state_changed", false);
}

void PlayerController::toggle_crouch() {
    is_crouching = !is_crouching;
    // TODO: Adjust collision shape height for crouching
}

void PlayerController::interact() {
    // Raycast forward from player to find interactable objects
    Vector3 origin = get_global_position();
    origin.y += 1.5f;  // Eye height
    
    Vector3 forward = -get_global_transform().basis.get_column(2);
    Vector3 target = origin + forward * interaction_range;
    
    // Perform raycast
    Ref<World3D> world = get_world_3d();
    PhysicsDirectSpaceState3D* space_state = world.is_valid() ? world->get_direct_space_state() : nullptr;
    
    if (!space_state) {
        UtilityFunctions::printerr("[PlayerController::interact] No physics space state available");
        return;
    }
    
    Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(origin, target);
    query->set_collision_mask(0xFFFFFFFF);  // Check all layers
    
    // Exclude self
    Array exclude;
    exclude.push_back(get_rid());
    query->set_exclude(exclude);
    
    Dictionary result = space_state->intersect_ray(query);
    
    if (!result.is_empty()) {
        Object* hit_obj = result["collider"];
        Node* hit_node = Object::cast_to<Node>(hit_obj);
        
        if (hit_node) {
            // Check if the object has an interact() method
            if (hit_node->has_method("interact")) {
                // Call interact() on the target, passing the player as the interactor
                hit_node->call("interact", this);
                emit_signal("player_interacted", hit_node);
                UtilityFunctions::print("[PlayerController] Interacted with: ", hit_node->get_name());
            } else {
                UtilityFunctions::print("[PlayerController] Object ", hit_node->get_name(), " has no interact() method");
            }
        }
    } else {
        UtilityFunctions::print("[PlayerController] No interactable object in range");
    }
}

void PlayerController::shoot() {
    UtilityFunctions::print("[PlayerController::shoot] Called. Weapon equipped: ", equipped_weapon != nullptr);
    if (equipped_weapon) {
        equipped_weapon->fire();
        emit_signal("weapon_fired");
    } else {
        UtilityFunctions::printerr("[PlayerController::shoot] No weapon equipped!");
    }
}

void PlayerController::reload() {
    if (equipped_weapon) {
        equipped_weapon->start_reload();
        emit_signal("weapon_reloaded");
    }
}

void PlayerController::equip_weapon(Weapon* weapon) {
    if (equipped_weapon) {
        equipped_weapon->cancel_reload();  // Cancel reload on old weapon
    }
    equipped_weapon = weapon;
}

void PlayerController::on_weapon_recoil(float vertical, float horizontal) {
    // Add recoil to current recoil values (accumulates if firing rapidly)
    current_recoil_vertical += vertical;
    
    // Horizontal recoil is random direction, not cumulative
    current_recoil_horizontal = horizontal;
    
    // Also instantly apply horizontal recoil as yaw rotation
    rotate_y(Math::deg_to_rad(horizontal));
}

void PlayerController::melee_attack() {
    // Check cooldown
    float current_time = static_cast<float>(get_process_delta_time()) + last_melee_time;
    if (current_time - last_melee_time < melee_cooldown) {
        return; // Still on cooldown
    }
    
    // Use Engine time for accurate cooldown tracking
    double time = Engine::get_singleton()->get_process_frames() * get_process_delta_time();
    last_melee_time = static_cast<float>(time);
    
    // Get melee attack position (slightly in front of player)
    Vector3 attack_position = get_global_position();
    Vector3 forward = -get_global_transform().basis.get_column(2);
    attack_position += forward * (melee_range * 0.5f);  // Center sphere in front
    attack_position.y += 1.0f;  // At torso height
    
    // Find all physics bodies in melee range using sphere overlap
    Ref<World3D> world = get_world_3d();
    PhysicsDirectSpaceState3D* space_state = world.is_valid() ? world->get_direct_space_state() : nullptr;
    
    if (!space_state) {
        UtilityFunctions::printerr("[PlayerController::melee_attack] No physics space state available");
        return;
    }
    
    // Use PhysicsShapeQueryParameters3D for sphere query
    Ref<PhysicsShapeQueryParameters3D> query;
    query.instantiate();
    
    // Create sphere shape
    Ref<SphereShape3D> sphere;
    sphere.instantiate();
    sphere->set_radius(melee_range);
    
    query->set_shape(sphere);
    query->set_transform(Transform3D(Basis(), attack_position));
    query->set_collision_mask(2);  // Enemy collision layer
    
    // Exclude self
    Array exclude;
    exclude.push_back(get_rid());
    query->set_exclude(exclude);
    
    // Perform sphere query
    TypedArray<Dictionary> results = space_state->intersect_shape(query, 10);  // Max 10 hits
    
    if (results.size() > 0) {
        // Hit something - apply damage to all targets in range
        DamageSystem* ds = DamageSystem::get_singleton();
        
        for (int i = 0; i < results.size(); i++) {
            Dictionary hit = results[i];
            Object* hit_obj = hit["collider"];
            Node* hit_node = Object::cast_to<Node>(hit_obj);
            
            if (hit_node && ds) {
                // Apply melee damage
                ds->apply_damage(
                    hit_node, 
                    melee_damage, 
                    DamageSystem::damage_type_to_int(DamageSystem::DamageType::MELEE), 
                    this,
                    DamageSystem::hit_zone_to_int(DamageSystem::HitZone::TORSO)
                );
                
                UtilityFunctions::print("[PlayerController] Melee hit: ", hit_node->get_name(), " for ", melee_damage, " damage");
            }
        }
    }
    
    // Emit melee signal (for animation, sound, etc.)
    emit_signal("melee_performed");
    
    // TODO: Play melee animation when animation system is implemented
    // TODO: Add melee sound effect
}

void PlayerController::on_player_died() {
    if (is_dead) {
        return; // Already dead
    }
    
    is_dead = true;
    
    // Disable physics and input
    set_physics_process(false);
    
    // Stop all movement
    set_velocity(Vector3(0, 0, 0));
    
    // Release mouse capture
    Input::get_singleton()->set_mouse_mode(Input::MOUSE_MODE_VISIBLE);
    
    // Cancel any weapon actions
    if (equipped_weapon) {
        equipped_weapon->cancel_reload();
    }
    
    UtilityFunctions::print("[PlayerController] Player died! Game Over.");
    
    // Emit signals for UI updates
    emit_signal("player_died");
    emit_signal("game_over");
    
    // TODO: Play death animation when animation system is implemented
    // TODO: Disable collision or enable ragdoll physics
}

void::PlayerController::set_walk_speed(float speed) {
    walk_speed = speed; 
}
float PlayerController::get_walk_speed() const {
    return walk_speed;
}

void PlayerController::set_sprint_speed(float speed) {
    sprint_speed = speed;
}

float PlayerController::get_sprint_speed() const {
    return sprint_speed;
}

void PlayerController::set_crouch_speed(float speed) {
    crouch_speed = speed;
}

float PlayerController::get_crouch_speed() const {
    return crouch_speed;
}

void PlayerController::set_jump_velocity(float velocity) {
    jump_velocity = velocity;
}

float PlayerController::get_jump_velocity() const {
    return jump_velocity;
}

void PlayerController::set_mouse_sensitivity(float sensitivity) {
    mouse_sensitivity = sensitivity;
}

float PlayerController::get_mouse_sensitivity() const {
    return mouse_sensitivity;
}

bool PlayerController::get_is_aiming() const {
    return is_aiming;
}

bool PlayerController::get_is_crouching() const {
    return is_crouching;
}

bool PlayerController::get_is_on_ground() const {
    return is_on_floor();
}

void PlayerController::set_random_walk_speed() {
    float random_value = UtilityFunctions::randf();
    if (random_value < 0.5f) {
        walk_speed = UtilityFunctions::randf_range(2.0f, 4.0f);  // Slow
    } else {
        walk_speed = UtilityFunctions::randf_range(6.0f, 10.0f);  // Fast
    }
}
} // namespace godot
