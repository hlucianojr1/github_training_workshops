#include "weapon.hpp"

#include "damage_system.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/collision_object3d.hpp>
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/world3d.hpp>
#include <godot_cpp/classes/rendering_server.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void Weapon::_bind_methods() {
    // Identity
    ClassDB::bind_method(D_METHOD("set_weapon_id", "id"), &Weapon::set_weapon_id);
    ClassDB::bind_method(D_METHOD("get_weapon_id"), &Weapon::get_weapon_id);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "weapon_id"), "set_weapon_id", "get_weapon_id");

    ClassDB::bind_method(D_METHOD("set_weapon_name", "name"), &Weapon::set_weapon_name);
    ClassDB::bind_method(D_METHOD("get_weapon_name"), &Weapon::get_weapon_name);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "weapon_name"), "set_weapon_name", "get_weapon_name");

    // Type
    ClassDB::bind_method(D_METHOD("set_weapon_type", "type"), &Weapon::set_weapon_type_int);
    ClassDB::bind_method(D_METHOD("get_weapon_type"), &Weapon::get_weapon_type_int);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "weapon_type", PROPERTY_HINT_ENUM, "Pistol,Revolver,Shotgun,Rifle,Melee"), "set_weapon_type", "get_weapon_type");

    // Ammo
    ClassDB::bind_method(D_METHOD("set_ammo_type", "type"), &Weapon::set_ammo_type);
    ClassDB::bind_method(D_METHOD("get_ammo_type"), &Weapon::get_ammo_type);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "ammo_type"), "set_ammo_type", "get_ammo_type");

    ClassDB::bind_method(D_METHOD("set_mag_capacity", "capacity"), &Weapon::set_mag_capacity);
    ClassDB::bind_method(D_METHOD("get_mag_capacity"), &Weapon::get_mag_capacity);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "mag_capacity", PROPERTY_HINT_RANGE, "1,100,1"), "set_mag_capacity", "get_mag_capacity");

    ClassDB::bind_method(D_METHOD("get_current_mag_ammo"), &Weapon::get_current_mag_ammo);
    ClassDB::bind_method(D_METHOD("get_reserve_ammo"), &Weapon::get_reserve_ammo);
    ClassDB::bind_method(D_METHOD("add_ammo", "amount"), &Weapon::add_ammo);

    // Performance
    ClassDB::bind_method(D_METHOD("set_damage", "damage"), &Weapon::set_damage);
    ClassDB::bind_method(D_METHOD("get_damage"), &Weapon::get_damage);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "damage", PROPERTY_HINT_RANGE, "1.0,200.0,1.0"), "set_damage", "get_damage");

    ClassDB::bind_method(D_METHOD("set_fire_rate", "rate"), &Weapon::set_fire_rate);
    ClassDB::bind_method(D_METHOD("get_fire_rate"), &Weapon::get_fire_rate);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "fire_rate", PROPERTY_HINT_RANGE, "0.05,5.0,0.05"), "set_fire_rate", "get_fire_rate");

    ClassDB::bind_method(D_METHOD("set_pellet_count", "count"), &Weapon::set_pellet_count);
    ClassDB::bind_method(D_METHOD("get_pellet_count"), &Weapon::get_pellet_count);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "pellet_count", PROPERTY_HINT_RANGE, "1,16,1"), "set_pellet_count", "get_pellet_count");

    ClassDB::bind_method(D_METHOD("set_range", "range"), &Weapon::set_range);
    ClassDB::bind_method(D_METHOD("get_range"), &Weapon::get_range);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "range", PROPERTY_HINT_RANGE, "5.0,500.0,5.0"), "set_range", "get_range");

    ClassDB::bind_method(D_METHOD("set_accuracy", "accuracy"), &Weapon::set_accuracy);
    ClassDB::bind_method(D_METHOD("get_accuracy"), &Weapon::get_accuracy);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "accuracy", PROPERTY_HINT_RANGE, "0.0,1.0,0.01"), "set_accuracy", "get_accuracy");
    
    // Spread system
    ClassDB::bind_method(D_METHOD("set_base_spread", "spread"), &Weapon::set_base_spread);
    ClassDB::bind_method(D_METHOD("get_base_spread"), &Weapon::get_base_spread);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "base_spread", PROPERTY_HINT_RANGE, "0.0,1.0,0.01"), "set_base_spread", "get_base_spread");
    
    ClassDB::bind_method(D_METHOD("set_max_spread", "spread"), &Weapon::set_max_spread);
    ClassDB::bind_method(D_METHOD("get_max_spread"), &Weapon::get_max_spread);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "max_spread", PROPERTY_HINT_RANGE, "0.0,2.0,0.01"), "set_max_spread", "get_max_spread");
    
    ClassDB::bind_method(D_METHOD("set_spread_increase_per_shot", "increase"), &Weapon::set_spread_increase_per_shot);
    ClassDB::bind_method(D_METHOD("get_spread_increase_per_shot"), &Weapon::get_spread_increase_per_shot);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "spread_increase_per_shot", PROPERTY_HINT_RANGE, "0.0,0.5,0.01"), "set_spread_increase_per_shot", "get_spread_increase_per_shot");
    
    ClassDB::bind_method(D_METHOD("set_spread_recovery_rate", "rate"), &Weapon::set_spread_recovery_rate);
    ClassDB::bind_method(D_METHOD("get_spread_recovery_rate"), &Weapon::get_spread_recovery_rate);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "spread_recovery_rate", PROPERTY_HINT_RANGE, "0.1,10.0,0.1"), "set_spread_recovery_rate", "get_spread_recovery_rate");
    
    ClassDB::bind_method(D_METHOD("get_current_spread"), &Weapon::get_current_spread);
    
    // Recoil
    ClassDB::bind_method(D_METHOD("set_vertical_recoil", "recoil"), &Weapon::set_vertical_recoil);
    ClassDB::bind_method(D_METHOD("get_vertical_recoil"), &Weapon::get_vertical_recoil);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "vertical_recoil", PROPERTY_HINT_RANGE, "0.0,10.0,0.1"), "set_vertical_recoil", "get_vertical_recoil");
    
    ClassDB::bind_method(D_METHOD("set_horizontal_recoil", "recoil"), &Weapon::set_horizontal_recoil);
    ClassDB::bind_method(D_METHOD("get_horizontal_recoil"), &Weapon::get_horizontal_recoil);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "horizontal_recoil", PROPERTY_HINT_RANGE, "0.0,5.0,0.1"), "set_horizontal_recoil", "get_horizontal_recoil");
    
    ClassDB::bind_method(D_METHOD("set_recoil_recovery_speed", "speed"), &Weapon::set_recoil_recovery_speed);
    ClassDB::bind_method(D_METHOD("get_recoil_recovery_speed"), &Weapon::get_recoil_recovery_speed);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "recoil_recovery_speed", PROPERTY_HINT_RANGE, "1.0,20.0,0.5"), "set_recoil_recovery_speed", "get_recoil_recovery_speed");    
    // Reload animation timing
    ClassDB::bind_method(D_METHOD("set_reload_mag_out_time", "time"), &Weapon::set_reload_mag_out_time);
    ClassDB::bind_method(D_METHOD("get_reload_mag_out_time"), &Weapon::get_reload_mag_out_time);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "reload_mag_out_time", PROPERTY_HINT_RANGE, "0.0,1.0,0.05"), "set_reload_mag_out_time", "get_reload_mag_out_time");
    
    ClassDB::bind_method(D_METHOD("set_reload_mag_in_time", "time"), &Weapon::set_reload_mag_in_time);
    ClassDB::bind_method(D_METHOD("get_reload_mag_in_time"), &Weapon::get_reload_mag_in_time);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "reload_mag_in_time", PROPERTY_HINT_RANGE, "0.0,1.0,0.05"), "set_reload_mag_in_time", "get_reload_mag_in_time");
    // Physics filtering
    ClassDB::bind_method(D_METHOD("set_hit_collision_mask", "mask"), &Weapon::set_hit_collision_mask);
    ClassDB::bind_method(D_METHOD("get_hit_collision_mask"), &Weapon::get_hit_collision_mask);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "hit_collision_mask"), "set_hit_collision_mask", "get_hit_collision_mask");
    
    // Debug
    ClassDB::bind_method(D_METHOD("set_debug_draw", "enabled"), &Weapon::set_debug_draw);
    ClassDB::bind_method(D_METHOD("get_debug_draw"), &Weapon::get_debug_draw);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "debug_draw"), "set_debug_draw", "get_debug_draw");
    
    ClassDB::bind_method(D_METHOD("set_debug_line_duration", "duration"), &Weapon::set_debug_line_duration);
    ClassDB::bind_method(D_METHOD("get_debug_line_duration"), &Weapon::get_debug_line_duration);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "debug_line_duration", PROPERTY_HINT_RANGE, "0.05,5.0,0.05"), "set_debug_line_duration", "get_debug_line_duration");

    // Actions
    ClassDB::bind_method(D_METHOD("fire"), &Weapon::fire);
    ClassDB::bind_method(D_METHOD("start_reload"), &Weapon::start_reload);
    ClassDB::bind_method(D_METHOD("cancel_reload"), &Weapon::cancel_reload);
    ClassDB::bind_method(D_METHOD("can_fire"), &Weapon::can_fire);
    ClassDB::bind_method(D_METHOD("can_reload"), &Weapon::can_reload);

    // State
    ClassDB::bind_method(D_METHOD("get_is_reloading"), &Weapon::get_is_reloading);
    ClassDB::bind_method(D_METHOD("has_ammo"), &Weapon::has_ammo);
    ClassDB::bind_method(D_METHOD("get_reload_progress"), &Weapon::get_reload_progress);

    // Signals
    ADD_SIGNAL(MethodInfo("weapon_fired"));
    ADD_SIGNAL(MethodInfo("weapon_empty"));
    ADD_SIGNAL(MethodInfo("reload_started"));
    ADD_SIGNAL(MethodInfo("reload_mag_out"));  // Animation hook: magazine eject
    ADD_SIGNAL(MethodInfo("reload_mag_in"));   // Animation hook: magazine insert
    ADD_SIGNAL(MethodInfo("reload_finished"));
    ADD_SIGNAL(MethodInfo("reload_cancelled"));
    ADD_SIGNAL(MethodInfo("weapon_recoil",
        PropertyInfo(Variant::FLOAT, "vertical"),
        PropertyInfo(Variant::FLOAT, "horizontal")));
    ADD_SIGNAL(MethodInfo("ammo_changed",
        PropertyInfo(Variant::INT, "mag_ammo"),
        PropertyInfo(Variant::INT, "reserve_ammo")));
}

Weapon::Weapon() {
    weapon_type = WeaponType::PISTOL;
    fire_mode = FireMode::SEMI_AUTO;
    current_mag_ammo = mag_capacity;
    current_spread = base_spread;
}

Weapon::~Weapon() {
}

void Weapon::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // Find muzzle point for shooting origin
    muzzle_point = Object::cast_to<Node3D>(get_node_or_null(NodePath("MuzzlePoint")));
    
    // Setup debug visualization
    if (debug_draw) {
        debug_immediate_mesh.instantiate();
        
        debug_mesh_instance = memnew(MeshInstance3D);
        add_child(debug_mesh_instance);
        debug_mesh_instance->set_mesh(debug_immediate_mesh);
        
        // Create unshaded material for debug lines
        debug_material.instantiate();
        debug_material->set_shading_mode(BaseMaterial3D::SHADING_MODE_UNSHADED);
        debug_material->set_flag(BaseMaterial3D::FLAG_ALBEDO_FROM_VERTEX_COLOR, true);
        debug_mesh_instance->set_material_override(debug_material);
    }
    
    UtilityFunctions::print("Weapon ready: ", weapon_name);
}

void Weapon::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    float dt = static_cast<float>(delta);

    // Update fire cooldown
    if (fire_timer > 0.0f) {
        fire_timer -= dt;
    }
    
    // Update time since last shot for spread recovery
    time_since_last_shot += dt;
    
    // Recover spread over time (only if not firing)
    if (time_since_last_shot > 0.1f && current_spread > base_spread) {
        current_spread = Math::max(base_spread, current_spread - spread_recovery_rate * dt);
    }

    // Update reload
    if (is_reloading) {
        reload_timer += dt;
        
        float reload_progress = reload_timer / reload_time;
        
        // Trigger animation events at specific points in reload
        if (!mag_out_triggered && reload_progress >= reload_mag_out_time) {
            mag_out_triggered = true;
            emit_signal("reload_mag_out");
        }
        
        if (!mag_in_triggered && reload_progress >= reload_mag_in_time) {
            mag_in_triggered = true;
            emit_signal("reload_mag_in");
        }
        
        if (reload_timer >= reload_time) {
            // Reload complete
            int ammo_needed = mag_capacity - current_mag_ammo;
            int ammo_to_reload = Math::min(ammo_needed, reserve_ammo);
            
            current_mag_ammo += ammo_to_reload;
            reserve_ammo -= ammo_to_reload;
            
            is_reloading = false;
            reload_timer = 0.0f;
            mag_out_triggered = false;
            mag_in_triggered = false;
            
            emit_signal("reload_finished");
            emit_signal("ammo_changed", current_mag_ammo, reserve_ammo);
        }
    }
    
    // Render debug lines if enabled
    if (debug_draw && debug_immediate_mesh.is_valid()) {
        debug_immediate_mesh->clear_surfaces();
        
        if (debug_lines.size() > 0) {
            debug_immediate_mesh->surface_begin(Mesh::PRIMITIVE_LINES, debug_material);
            
            bool has_vertices = false;  // Track if we added any vertices
            
            for (int i = debug_lines.size() - 1; i >= 0; i--) {
                Dictionary line_dict = debug_lines[i];
                float lifetime = line_dict["lifetime"];
                
                if (lifetime > 0.0f) {
                    Vector3 start = line_dict["start"];
                    Vector3 end = line_dict["end"];
                    Color color = line_dict["color"];
                    
                    // Fade out based on remaining lifetime
                    float alpha = Math::min(1.0f, lifetime / debug_line_duration);
                    color.a = alpha;
                    
                    debug_immediate_mesh->surface_set_color(color);
                    debug_immediate_mesh->surface_add_vertex(start);
                    debug_immediate_mesh->surface_set_color(color);
                    debug_immediate_mesh->surface_add_vertex(end);
                    
                    has_vertices = true;  // We added vertices
                    
                    // Update lifetime
                    line_dict["lifetime"] = lifetime - dt;
                    debug_lines[i] = line_dict;
                } else {
                    // Remove expired line
                    debug_lines.remove_at(i);
                }
            }
            
            // Only call surface_end() if we added vertices
            if (has_vertices) {
                debug_immediate_mesh->surface_end();
            }
        }
    }
}

void Weapon::fire() {
    UtilityFunctions::print("[Weapon::fire] Called. can_fire=", can_fire(), " ammo=", current_mag_ammo, "/", mag_capacity);
    if (!can_fire()) {
        UtilityFunctions::print("[Weapon::fire] Cannot fire: reloading=", is_reloading, " fire_timer=", fire_timer, " has_ammo=", current_mag_ammo > 0);
        if (current_mag_ammo == 0) {
            emit_signal("weapon_empty");
        }
        return;
    }

    // Consume ammo
    current_mag_ammo--;
    fire_timer = fire_rate;
    
    // Increase spread (sustained fire reduces accuracy)
    current_spread = Math::min(max_spread, current_spread + spread_increase_per_shot);
    time_since_last_shot = 0.0f; // Reset recovery timer

    // Raycast from muzzle
    Vector3 origin = muzzle_point ? muzzle_point->get_global_position() : get_global_position();
    Vector3 base_direction = -get_global_transform().basis.get_column(2);  // Forward

    // Perform raycast for each pellet (shotguns fire multiple pellets per shot)
    Ref<World3D> world = get_world_3d();
    PhysicsDirectSpaceState3D* space_state = world.is_valid() ? world->get_direct_space_state() : nullptr;
    
    if (space_state) {
        // Build exclude list once (exclude shooter's collision body)
        Array exclude;
        Node* p = get_parent();
        while (p) {
            CollisionObject3D* co = Object::cast_to<CollisionObject3D>(p);
            if (co) {
                exclude.push_back(co->get_rid());
                break;
            }
            p = p->get_parent();
        }

        // Fire each pellet with individual spread
        for (int pellet = 0; pellet < pellet_count; pellet++) {
            // Apply accuracy spread using current_spread (dynamic) - each pellet gets unique spread
            Vector3 direction = base_direction;
            direction.x += (UtilityFunctions::randf() - 0.5f) * current_spread;
            direction.y += (UtilityFunctions::randf() - 0.5f) * current_spread;
            direction = direction.normalized();

            Vector3 target = origin + direction * range;

            Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(origin, target);
            query->set_collision_mask(hit_collision_mask);
            query->set_exclude(exclude);

            Dictionary result = space_state->intersect_ray(query);
            
            if (!result.is_empty()) {
                Object* hit_obj = result["collider"];
                Vector3 hit_position = result["position"];
                Node* hit_node = Object::cast_to<Node>(hit_obj);

                // Detect hit zone from the collider
                int hit_zone = DamageSystem::hit_zone_to_int(DamageSystem::HitZone::UNKNOWN);
                if (hit_node) {
                    hit_zone = DamageSystem::hit_zone_to_int(DamageSystem::detect_hit_zone(hit_node));
                }

                // Debug: Draw yellow line to hit point (red for headshots)
                if (debug_draw) {
                    Color line_color = (hit_zone == DamageSystem::hit_zone_to_int(DamageSystem::HitZone::HEAD)) 
                        ? Color(1.0f, 0.0f, 0.0f)  // Red for headshot
                        : Color(1.0f, 1.0f, 0.0f); // Yellow for body hit
                    draw_debug_line(origin, hit_position, line_color);
                    
                    if (pellet == 0) {  // Only log first pellet to avoid spam
                        String zone_name = "UNKNOWN";
                        if (hit_zone == DamageSystem::hit_zone_to_int(DamageSystem::HitZone::HEAD)) zone_name = "HEAD";
                        else if (hit_zone == DamageSystem::hit_zone_to_int(DamageSystem::HitZone::TORSO)) zone_name = "TORSO";
                        else if (hit_zone == DamageSystem::hit_zone_to_int(DamageSystem::HitZone::LIMBS)) zone_name = "LIMBS";
                        
                        UtilityFunctions::print("Weapon hit: ", hit_obj, " [Zone: ", zone_name, "] (", pellet_count, " pellets)");
                    }
                }

                DamageSystem* ds = DamageSystem::get_singleton();
                if (ds && hit_node) {
                    ds->apply_damage(hit_node, damage, DamageSystem::damage_type_to_int(DamageSystem::DamageType::BULLET), get_parent(), hit_zone);
                } else if (!ds && debug_draw && pellet == 0) {
                    UtilityFunctions::printerr("DamageSystem singleton not available; cannot apply damage.");
                }
            } else {
                // Debug: Draw green line on miss (no hit)
                if (debug_draw) {
                    draw_debug_line(origin, target, Color(0.0f, 1.0f, 0.0f)); // Green
                }
            }
        }
    } else if (debug_draw) {
        UtilityFunctions::printerr("Weapon: no world/space state available for raycast.");
    }
    
    // Apply camera recoil
    float recoil_vertical = vertical_recoil;
    float recoil_horizontal = (UtilityFunctions::randf() - 0.5f) * 2.0f * horizontal_recoil; // Random horizontal variance
    emit_signal("weapon_recoil", recoil_vertical, recoil_horizontal);

    emit_signal("weapon_fired");
    emit_signal("ammo_changed", current_mag_ammo, reserve_ammo);
}

void Weapon::start_reload() {
    if (!can_reload()) {
        return;
    }

    is_reloading = true;
    reload_timer = 0.0f;
    mag_out_triggered = false;
    mag_in_triggered = false;
    emit_signal("reload_started");
}

void Weapon::cancel_reload() {
    if (is_reloading) {
        is_reloading = false;
        reload_timer = 0.0f;
        mag_out_triggered = false;
        mag_in_triggered = false;
        emit_signal("reload_cancelled");
    }
}

bool Weapon::can_fire() const {
    return !is_reloading && fire_timer <= 0.0f && current_mag_ammo > 0;
}

bool Weapon::can_reload() const {
    return !is_reloading && current_mag_ammo < mag_capacity && reserve_ammo > 0;
}

float Weapon::get_reload_progress() const {
    if (!is_reloading) {
        return 0.0f;
    }
    return reload_timer / reload_time;
}

void Weapon::draw_debug_line(const Vector3& from, const Vector3& to, const Color& color) {
    if (!debug_draw) {
        return;
    }
    
    Dictionary line;
    line["start"] = from;
    line["end"] = to;
    line["color"] = color;
    line["lifetime"] = debug_line_duration;
    
    debug_lines.push_back(line);
}

} // namespace godot
