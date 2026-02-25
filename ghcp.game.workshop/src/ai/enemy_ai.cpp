#include "enemy_ai.hpp"
#include "ai_perception.hpp"
#include "../combat/damage_system.hpp"
#include "../combat/weapon.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/navigation_server3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/sphere_shape3d.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/box_mesh.hpp>
#include <godot_cpp/classes/world3d.hpp>
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/window.hpp>

namespace godot {

void EnemyAI::_bind_methods() {
    // State
    ClassDB::bind_method(D_METHOD("get_current_state"), &EnemyAI::get_current_state_int);

    // Stats
    ClassDB::bind_method(D_METHOD("set_max_health", "health"), &EnemyAI::set_max_health);
    ClassDB::bind_method(D_METHOD("get_max_health"), &EnemyAI::get_max_health);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "max_health", PROPERTY_HINT_RANGE, "1.0,500.0,1.0"), "set_max_health", "get_max_health");

    ClassDB::bind_method(D_METHOD("get_health"), &EnemyAI::get_health);
    ClassDB::bind_method(D_METHOD("get_health_ratio"), &EnemyAI::get_health_ratio);

    ClassDB::bind_method(D_METHOD("set_move_speed", "speed"), &EnemyAI::set_move_speed);
    ClassDB::bind_method(D_METHOD("get_move_speed"), &EnemyAI::get_move_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "move_speed", PROPERTY_HINT_RANGE, "1.0,20.0,0.1"), "set_move_speed", "get_move_speed");

    ClassDB::bind_method(D_METHOD("set_chase_speed", "speed"), &EnemyAI::set_chase_speed);
    ClassDB::bind_method(D_METHOD("get_chase_speed"), &EnemyAI::get_chase_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "chase_speed", PROPERTY_HINT_RANGE, "1.0,25.0,0.1"), "set_chase_speed", "get_chase_speed");

    ClassDB::bind_method(D_METHOD("set_attack_damage", "damage"), &EnemyAI::set_attack_damage);
    ClassDB::bind_method(D_METHOD("get_attack_damage"), &EnemyAI::get_attack_damage);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "attack_damage", PROPERTY_HINT_RANGE, "1.0,100.0,1.0"), "set_attack_damage", "get_attack_damage");

    ClassDB::bind_method(D_METHOD("set_attack_range", "range"), &EnemyAI::set_attack_range);
    ClassDB::bind_method(D_METHOD("get_attack_range"), &EnemyAI::get_attack_range);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "attack_range", PROPERTY_HINT_RANGE, "0.5,20.0,0.1"), "set_attack_range", "get_attack_range");
    
    // Behavior thresholds
    ClassDB::bind_method(D_METHOD("set_flee_health_threshold", "threshold"), &EnemyAI::set_flee_health_threshold);
    ClassDB::bind_method(D_METHOD("get_flee_health_threshold"), &EnemyAI::get_flee_health_threshold);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "flee_health_threshold", PROPERTY_HINT_RANGE, "0.0,1.0,0.05"), "set_flee_health_threshold", "get_flee_health_threshold");
    
    ClassDB::bind_method(D_METHOD("set_cover_health_threshold", "threshold"), &EnemyAI::set_cover_health_threshold);
    ClassDB::bind_method(D_METHOD("get_cover_health_threshold"), &EnemyAI::get_cover_health_threshold);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "cover_health_threshold", PROPERTY_HINT_RANGE, "0.0,1.0,0.05"), "set_cover_health_threshold", "get_cover_health_threshold");
    
    ClassDB::bind_method(D_METHOD("set_ai_accuracy", "accuracy"), &EnemyAI::set_ai_accuracy);
    ClassDB::bind_method(D_METHOD("get_ai_accuracy"), &EnemyAI::get_ai_accuracy);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "ai_accuracy", PROPERTY_HINT_RANGE, "0.0,1.0,0.05"), "set_ai_accuracy", "get_ai_accuracy");
    
    ClassDB::bind_method(D_METHOD("equip_weapon", "weapon"), &EnemyAI::equip_weapon);
    ClassDB::bind_method(D_METHOD("get_equipped_weapon"), &EnemyAI::get_equipped_weapon);

    // Patrol
    ClassDB::bind_method(D_METHOD("set_patrol_points", "points"), &EnemyAI::set_patrol_points);
    ClassDB::bind_method(D_METHOD("get_patrol_points"), &EnemyAI::get_patrol_points);
    ADD_PROPERTY(PropertyInfo(Variant::ARRAY, "patrol_points"), "set_patrol_points", "get_patrol_points");
    ClassDB::bind_method(D_METHOD("add_patrol_point", "point"), &EnemyAI::add_patrol_point);

    // Combat
    ClassDB::bind_method(D_METHOD("take_damage", "amount", "attacker"), &EnemyAI::take_damage, DEFVAL(nullptr));
    ClassDB::bind_method(D_METHOD("alert_to_position", "position"), &EnemyAI::alert_to_position);
    ClassDB::bind_method(D_METHOD("set_target", "target"), &EnemyAI::set_target);
    ClassDB::bind_method(D_METHOD("get_target"), &EnemyAI::get_target);
    ClassDB::bind_method(D_METHOD("is_alive"), &EnemyAI::is_alive);
    ClassDB::bind_method(D_METHOD("is_in_combat"), &EnemyAI::is_in_combat);
    
    // Activation control
    ClassDB::bind_method(D_METHOD("set_ai_active", "active"), &EnemyAI::set_ai_active);
    ClassDB::bind_method(D_METHOD("is_ai_active"), &EnemyAI::is_ai_active);
    
    // Loot configuration
    ClassDB::bind_method(D_METHOD("set_loot_table", "table"), &EnemyAI::set_loot_table);
    ClassDB::bind_method(D_METHOD("get_loot_table"), &EnemyAI::get_loot_table);
    ADD_PROPERTY(PropertyInfo(Variant::ARRAY, "loot_table"), "set_loot_table", "get_loot_table");
    
    ClassDB::bind_method(D_METHOD("set_corpse_cleanup_time", "time"), &EnemyAI::set_corpse_cleanup_time);
    ClassDB::bind_method(D_METHOD("get_corpse_cleanup_time"), &EnemyAI::get_corpse_cleanup_time);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "corpse_cleanup_time", PROPERTY_HINT_RANGE, "0.0,300.0,1.0"), "set_corpse_cleanup_time", "get_corpse_cleanup_time");

    // Signals
    ADD_SIGNAL(MethodInfo("state_changed", PropertyInfo(Variant::INT, "new_state")));
    ADD_SIGNAL(MethodInfo("target_spotted", PropertyInfo(Variant::OBJECT, "target")));
    ADD_SIGNAL(MethodInfo("target_lost"));
    ADD_SIGNAL(MethodInfo("enemy_died"));
    ADD_SIGNAL(MethodInfo("attack_performed"));

    // State enum constants
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "IDLE", static_cast<int>(AIState::IDLE));
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "PATROL", static_cast<int>(AIState::PATROL));
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "INVESTIGATE", static_cast<int>(AIState::INVESTIGATE));
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "CHASE", static_cast<int>(AIState::CHASE));
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "ATTACK", static_cast<int>(AIState::ATTACK));
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "TAKE_COVER", static_cast<int>(AIState::TAKE_COVER));
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "FLEE", static_cast<int>(AIState::FLEE));
    ClassDB::bind_integer_constant(get_class_static(), "AIState", "DEAD", static_cast<int>(AIState::DEAD));
}

EnemyAI::EnemyAI() {
    current_state = AIState::IDLE;
    previous_state = AIState::IDLE;
    current_health = max_health;
}

EnemyAI::~EnemyAI() {
}

void EnemyAI::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // Get navigation agent
    nav_agent = Object::cast_to<NavigationAgent3D>(get_node_or_null(NodePath("NavigationAgent3D")));
    if (!nav_agent) {
        UtilityFunctions::printerr("EnemyAI: NavigationAgent3D not found!");
    }

    // Get perception component
    perception = Object::cast_to<AIPerception>(get_node_or_null(NodePath("AIPerception")));

    current_health = max_health;
    
    // Start patrolling if patrol points exist
    if (patrol_points.size() > 0) {
        change_state(AIState::PATROL);
    }

    UtilityFunctions::print("EnemyAI ready");
}

void EnemyAI::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    if (current_state == AIState::DEAD) {
        return;
    }
    
    // Skip AI processing if deactivated (e.g., zone not entered yet)
    if (!ai_active) {
        return;
    }

    // Update timers
    state_timer += static_cast<float>(delta);
    if (attack_timer > 0) {
        attack_timer -= static_cast<float>(delta);
    }

    // Check perception for targets
    if (perception) {
        Node3D* detected = perception->get_closest_target();
        if (detected && !target) {
            set_target(detected);
            emit_signal("target_spotted", detected);
        } else if (!detected && target && !perception->can_see_target(target)) {
            // Lost sight of target
            last_known_target_position = target->get_global_position();
            target = nullptr;
            emit_signal("target_lost");
            
            // Go investigate last known position
            investigate_position = last_known_target_position;
            change_state(AIState::INVESTIGATE);
        }
    }

    // State machine
    update_state(delta);
    execute_state(delta);
}

void EnemyAI::update_state(double delta) {
    // Health check - flee if critical
    if (get_health_ratio() <= flee_health_threshold && current_state != AIState::FLEE) {
        change_state(AIState::FLEE);
        return;
    }
    
    // Health check - seek cover if damaged (but not fleeing)
    if (get_health_ratio() <= cover_health_threshold && target && 
        current_state != AIState::TAKE_COVER && current_state != AIState::FLEE) {
        change_state(AIState::TAKE_COVER);
        return;
    }

    // Target-based state transitions
    if (target) {
        float distance = get_global_position().distance_to(target->get_global_position());
        
        if (distance <= attack_range && can_attack()) {
            if (current_state != AIState::ATTACK) {
                change_state(AIState::ATTACK);
            }
        } else if (current_state != AIState::CHASE && current_state != AIState::ATTACK) {
            change_state(AIState::CHASE);
        }
    }
}

void EnemyAI::execute_state(double delta) {
    switch (current_state) {
        case AIState::IDLE:
            state_idle(delta);
            break;
        case AIState::PATROL:
            state_patrol(delta);
            break;
        case AIState::INVESTIGATE:
            state_investigate(delta);
            break;
        case AIState::CHASE:
            state_chase(delta);
            break;
        case AIState::ATTACK:
            state_attack(delta);
            break;
        case AIState::TAKE_COVER:
            state_take_cover(delta);
            break;
        case AIState::FLEE:
            state_flee(delta);
            break;
        case AIState::DEAD:
            state_dead(delta);
            break;
    }
}

void EnemyAI::change_state(AIState new_state) {
    if (current_state == new_state) {
        return;
    }
    
    previous_state = current_state;
    current_state = new_state;
    state_timer = 0.0f;
    
    // Clear cover position when leaving cover state
    if (previous_state == AIState::TAKE_COVER && new_state != AIState::TAKE_COVER) {
        has_cover_position = false;
    }
    
    emit_signal("state_changed", static_cast<int>(new_state));
}

void EnemyAI::state_patrol(double delta) {
    if (patrol_points.size() == 0) {
        change_state(AIState::IDLE);
        return;
    }

    Vector3 patrol_target = patrol_points[current_patrol_index];
    float distance = get_global_position().distance_to(patrol_target);

    if (distance < 1.0f) {
        // Reached patrol point, wait then move to next
        if (state_timer > patrol_wait_time) {
            current_patrol_index = (current_patrol_index + 1) % patrol_points.size();
            state_timer = 0.0f;
        }
    } else {
        move_to_target(patrol_target, move_speed);
    }
}

void EnemyAI::state_investigate(double delta) {
    float distance = get_global_position().distance_to(investigate_position);

    if (distance < 2.0f || state_timer > investigate_timeout) {
        // Reached investigation point or timeout
        if (patrol_points.size() > 0) {
            change_state(AIState::PATROL);
        } else {
            change_state(AIState::IDLE);
        }
    } else {
        move_to_target(investigate_position, move_speed);
    }
}

void EnemyAI::state_chase(double delta) {
    if (!target) {
        change_state(AIState::INVESTIGATE);
        return;
    }

    Vector3 target_pos = target->get_global_position();
    float distance = get_global_position().distance_to(target_pos);

    if (distance <= attack_range) {
        change_state(AIState::ATTACK);
    } else {
        move_to_target(target_pos, chase_speed);
    }
}

void EnemyAI::state_attack(double delta) {
    if (!target) {
        change_state(AIState::INVESTIGATE);
        return;
    }

    float distance = get_global_position().distance_to(target->get_global_position());

    if (distance > attack_range * 1.5f) {
        change_state(AIState::CHASE);
        return;
    }

    // Face target
    Vector3 direction = (target->get_global_position() - get_global_position()).normalized();
    direction.y = 0;
    if (direction.length() > 0.1f) {
        look_at(get_global_position() + direction, Vector3(0, 1, 0));
    }

    // Attack if cooldown ready
    if (can_attack()) {
        perform_attack();
    }
}

void EnemyAI::state_take_cover(double delta) {
    if (!target) {
        change_state(AIState::IDLE);
        return;
    }
    
    // Find/update cover position if we don't have one
    if (!has_cover_position) {
        current_cover_position = find_cover_position();
        has_cover_position = true;
        peek_timer = 0.0f;
    }
    
    float distance = get_global_position().distance_to(current_cover_position);
    
    if (distance < 1.5f) {
        // We're in cover - peek and shoot periodically
        peek_timer += static_cast<float>(delta);
        
        // Face target while in cover
        Vector3 direction = (target->get_global_position() - get_global_position()).normalized();
        direction.y = 0;
        if (direction.length() > 0.1f) {
            look_at(get_global_position() + direction, Vector3(0, 1, 0));
        }
        
        // Peek out and shoot at intervals
        if (peek_timer >= peek_interval && can_attack()) {
            perform_attack();
            peek_timer = 0.0f;
        }
        
        // Exit cover if health recovered enough or too much time passed
        if (get_health_ratio() > cover_health_threshold + 0.2f || state_timer > 10.0f) {
            has_cover_position = false;
            change_state(AIState::CHASE);
        }
    } else {
        // Moving to cover
        move_to_target(current_cover_position, chase_speed);
    }
}

void EnemyAI::state_flee(double delta) {
    if (!target) {
        if (patrol_points.size() > 0) {
            change_state(AIState::PATROL);
        } else {
            change_state(AIState::IDLE);
        }
        return;
    }

    // Run away from target
    Vector3 flee_direction = (get_global_position() - target->get_global_position()).normalized();
    Vector3 flee_target = get_global_position() + flee_direction * 20.0f;
    
    move_to_target(flee_target, chase_speed);

    // If far enough, stop fleeing
    float distance = get_global_position().distance_to(target->get_global_position());
    if (distance > 30.0f) {
        target = nullptr;
        change_state(AIState::IDLE);
    }
}

void EnemyAI::state_dead(double delta) {
    // Corpse cleanup timer
    death_timer += static_cast<float>(delta);
    
    if (death_timer >= corpse_cleanup_time) {
        // Remove corpse from scene
        queue_free();
    }
}

void EnemyAI::state_idle(double delta) {
    // Just stand still, optionally look around
    state_timer += static_cast<float>(delta);
    
    // After some time, consider patrolling
    if (state_timer > 5.0f && patrol_points.size() > 0) {
        change_state(AIState::PATROL);
    }
}

void EnemyAI::move_to_target(Vector3 position, float speed) {
    if (!nav_agent) {
        // Simple direct movement without navigation
        Vector3 direction = (position - get_global_position()).normalized();
        direction.y = 0;
        set_velocity(direction * speed);
        move_and_slide();
        return;
    }

    nav_agent->set_target_position(position);
    
    if (!nav_agent->is_navigation_finished()) {
        Vector3 next_pos = nav_agent->get_next_path_position();
        Vector3 direction = (next_pos - get_global_position()).normalized();
        
        // Face movement direction
        if (direction.length() > 0.1f) {
            Vector3 look_dir = direction;
            look_dir.y = 0;
            if (look_dir.length() > 0.1f) {
                look_at(get_global_position() + look_dir, Vector3(0, 1, 0));
            }
        }
        
        set_velocity(direction * speed);
        move_and_slide();
    }
}

bool EnemyAI::can_attack() const {
    return attack_timer <= 0.0f;
}

void EnemyAI::perform_attack() {
    attack_timer = attack_cooldown;
    emit_signal("attack_performed");
    
    if (!target) {
        return;
    }
    
    // If enemy has a weapon, use it
    if (equipped_weapon && equipped_weapon->can_fire()) {
        // Temporarily increase weapon spread based on AI accuracy
        // Lower accuracy = more spread = worse aim
        float original_spread = equipped_weapon->get_base_spread();
        float ai_spread_penalty = (1.0f - ai_accuracy_modifier) * 2.0f; // 0-2 degrees penalty
        equipped_weapon->set_base_spread(original_spread + ai_spread_penalty);
        
        // Fire the weapon (uses weapon's raycast system)
        equipped_weapon->fire();
        
        // Restore original spread
        equipped_weapon->set_base_spread(original_spread);
        
        UtilityFunctions::print("[EnemyAI] Fired weapon at target (accuracy: ", ai_accuracy_modifier, ")");
    } else {
        // Fallback to melee attack if no weapon or can't fire
        DamageSystem* ds = DamageSystem::get_singleton();
        if (ds) {
            UtilityFunctions::print("[EnemyAI] Melee attacking target for ", attack_damage, " damage");
            ds->apply_damage(target, attack_damage, DamageSystem::damage_type_to_int(DamageSystem::DamageType::MELEE), this);
        } else {
            UtilityFunctions::printerr("[EnemyAI] DamageSystem singleton not available!");
        }
    }
}

Vector3 EnemyAI::find_cover_position() const {
    if (!target) {
        return get_global_position();
    }
    
    PhysicsDirectSpaceState3D* space_state = get_world_3d()->get_direct_space_state();
    if (!space_state) {
        // Fallback to simple away-from-target position
        Vector3 away_dir = (get_global_position() - target->get_global_position()).normalized();
        return get_global_position() + away_dir * 5.0f;
    }
    
    Vector3 my_pos = get_global_position();
    Vector3 target_pos = target->get_global_position();
    Vector3 to_target = (target_pos - my_pos).normalized();
    
    // Try multiple positions around the AI to find cover
    const int num_samples = 8;
    float best_score = -1.0f;
    Vector3 best_position = my_pos;
    
    for (int i = 0; i < num_samples; i++) {
        float angle = (Math_TAU / num_samples) * i;
        Vector3 offset = Vector3(Math::cos(angle), 0, Math::sin(angle)) * 5.0f;
        Vector3 test_pos = my_pos + offset;
        
        // Raycast from test position to target to see if there's cover
        Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(
            test_pos + Vector3(0, 1, 0),  // Raise up to torso height
            target_pos + Vector3(0, 1, 0)
        );
        
        Dictionary result = space_state->intersect_ray(query);
        
        if (!result.is_empty()) {
            // Hit something - this is potential cover!
            Vector3 hit_pos = result["position"];
            float cover_distance = test_pos.distance_to(hit_pos);
            
            // Score this position (prefer close obstacles between us and target)
            if (cover_distance > 0.5f && cover_distance < 3.0f) {
                float score = 1.0f / cover_distance; // Prefer closer cover
                if (score > best_score) {
                    best_score = score;
                    best_position = test_pos;
                }
            }
        }
    }
    
    // If no cover found, just move away from target
    if (best_score < 0) {
        Vector3 away_dir = (my_pos - target_pos).normalized();
        best_position = my_pos + away_dir * 5.0f;
    }
    
    return best_position;
}

void EnemyAI::add_patrol_point(Vector3 point) {
    patrol_points.append(point);
}

void EnemyAI::take_damage(float amount, Node3D* attacker) {
    if (current_state == AIState::DEAD) {
        return;
    }

    current_health = Math::max(0.0f, current_health - amount);

    // Alert to attacker
    if (attacker && !target) {
        set_target(attacker);
    }

    if (current_health <= 0.0f) {
        change_state(AIState::DEAD);
        
        // Disable collision (stop blocking player/projectiles)
        set_collision_layer(0);
        set_collision_mask(0);
        
        // Drop loot
        drop_loot();
        
        emit_signal("enemy_died");
        UtilityFunctions::print("Enemy died");
    }
}

void EnemyAI::alert_to_position(Vector3 position) {
    if (current_state == AIState::DEAD || target) {
        return;
    }
    
    investigate_position = position;
    change_state(AIState::INVESTIGATE);
}

void EnemyAI::set_target(Node3D* new_target) {
    target = new_target;
    if (target && current_state != AIState::DEAD && current_state != AIState::FLEE) {
        change_state(AIState::CHASE);
    }
}

bool EnemyAI::is_in_combat() const {
    return current_state == AIState::CHASE || 
           current_state == AIState::ATTACK || 
           current_state == AIState::TAKE_COVER;
}

void EnemyAI::equip_weapon(Weapon* weapon) {
    equipped_weapon = weapon;
    if (weapon) {
        UtilityFunctions::print("[EnemyAI] Equipped weapon: ", weapon->get_weapon_id());
    }
}

void EnemyAI::drop_loot() {
    if (loot_table.is_empty()) {
        return;
    }
    
    // Get the scene root to spawn pickups
    SceneTree* tree = get_tree();
    if (!tree) {
        return;
    }
    
    Node* scene_root = Object::cast_to<Node>(tree->get_root());
    if (!scene_root) {
        return;
    }
    
    Vector3 drop_origin = get_global_position() + Vector3(0, 0.5f, 0);
    
    // Spawn each item in loot table
    for (int i = 0; i < loot_table.size(); i++) {
        String item_id = loot_table[i];
        
        // Create a simple StaticBody3D pickup
        StaticBody3D* pickup = memnew(StaticBody3D);
        pickup->set_name("ItemPickup_" + item_id);
        
        // Scatter items around corpse
        float angle = (i / static_cast<float>(loot_table.size())) * Math_TAU;
        float radius = 0.5f + (i * 0.2f);
        Vector3 offset = Vector3(Math::cos(angle) * radius, 0, Math::sin(angle) * radius);
        pickup->set_global_position(drop_origin + offset);
        
        // Create collision shape (simple sphere for now)
        CollisionShape3D* collision = memnew(CollisionShape3D);
        Ref<SphereShape3D> shape;
        shape.instantiate();
        shape->set_radius(0.2f);
        collision->set_shape(shape);
        pickup->add_child(collision);
        collision->set_owner(pickup);
        
        // Create visual (placeholder cube)
        MeshInstance3D* mesh = memnew(MeshInstance3D);
        Ref<BoxMesh> box;
        box.instantiate();
        box->set_size(Vector3(0.3f, 0.3f, 0.3f));
        mesh->set_mesh(box);
        pickup->add_child(mesh);
        mesh->set_owner(pickup);
        
        // Store item ID as metadata
        pickup->set_meta("item_id", item_id);
        
        // Add to scene
        scene_root->add_child(pickup);
        pickup->set_owner(scene_root);
        
        UtilityFunctions::print("[EnemyAI] Dropped loot: ", item_id);
    }
}



} // namespace godot
