#include "level_manager.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void LevelManager::_bind_methods() {
    // Level info
    ClassDB::bind_method(D_METHOD("set_level_index", "index"), &LevelManager::set_level_index);
    ClassDB::bind_method(D_METHOD("get_level_index"), &LevelManager::get_level_index);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "level_index"), "set_level_index", "get_level_index");

    ClassDB::bind_method(D_METHOD("set_level_name", "name"), &LevelManager::set_level_name);
    ClassDB::bind_method(D_METHOD("get_level_name"), &LevelManager::get_level_name);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "level_name"), "set_level_name", "get_level_name");

    // Spawn points
    ClassDB::bind_method(D_METHOD("set_player_spawn_point", "point"), &LevelManager::set_player_spawn_point);
    ClassDB::bind_method(D_METHOD("get_player_spawn_point"), &LevelManager::get_player_spawn_point);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "player_spawn_point"), "set_player_spawn_point", "get_player_spawn_point");

    ClassDB::bind_method(D_METHOD("set_level_exit_point", "point"), &LevelManager::set_level_exit_point);
    ClassDB::bind_method(D_METHOD("get_level_exit_point"), &LevelManager::get_level_exit_point);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "level_exit_point"), "set_level_exit_point", "get_level_exit_point");

    // Progression
    ClassDB::bind_method(D_METHOD("complete_level"), &LevelManager::complete_level);
    ClassDB::bind_method(D_METHOD("is_level_complete"), &LevelManager::is_level_complete);
    ClassDB::bind_method(D_METHOD("get_completion_time"), &LevelManager::get_completion_time);

    // Stats
    ClassDB::bind_method(D_METHOD("register_enemy"), &LevelManager::register_enemy);
    ClassDB::bind_method(D_METHOD("enemy_defeated"), &LevelManager::enemy_defeated);
    ClassDB::bind_method(D_METHOD("get_enemies_remaining"), &LevelManager::get_enemies_remaining);
    ClassDB::bind_method(D_METHOD("item_collected"), &LevelManager::item_collected);
    ClassDB::bind_method(D_METHOD("get_items_collected"), &LevelManager::get_items_collected);

    // Signals
    ADD_SIGNAL(MethodInfo("level_started"));
    ADD_SIGNAL(MethodInfo("level_completed",
        PropertyInfo(Variant::FLOAT, "time"),
        PropertyInfo(Variant::INT, "items")));
    ADD_SIGNAL(MethodInfo("objective_updated", PropertyInfo(Variant::STRING, "objective")));
}

LevelManager::LevelManager() {
    level_index = 0;
    level_complete = false;
    completion_time = 0.0f;
    enemies_remaining = 0;
    items_collected = 0;
}

LevelManager::~LevelManager() {
}

void LevelManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    emit_signal("level_started");
    UtilityFunctions::print("Level Manager ready: ", level_name);
}

void LevelManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint() || level_complete) {
        return;
    }

    completion_time += static_cast<float>(delta);
}

void LevelManager::complete_level() {
    if (level_complete) {
        return;
    }

    level_complete = true;
    emit_signal("level_completed", completion_time, items_collected);
    UtilityFunctions::print("Level complete! Time: ", completion_time, "s, Items: ", items_collected);
}

void LevelManager::register_enemy() {
    enemies_remaining++;
}

void LevelManager::enemy_defeated() {
    enemies_remaining = Math::max(0, enemies_remaining - 1);
    
    String objective = String("Enemies remaining: {0}").format(Array::make(enemies_remaining));
    emit_signal("objective_updated", objective);
}

void LevelManager::item_collected() {
    items_collected++;
    
    String objective = String("Items collected: {0}").format(Array::make(items_collected));
    emit_signal("objective_updated", objective);
}

} // namespace godot
