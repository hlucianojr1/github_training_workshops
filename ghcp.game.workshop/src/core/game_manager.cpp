#include "game_manager.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

GameManager* GameManager::singleton = nullptr;

void GameManager::_bind_methods() {
    // State management methods
    ClassDB::bind_method(D_METHOD("start_game"), &GameManager::start_game);
    ClassDB::bind_method(D_METHOD("pause_game"), &GameManager::pause_game);
    ClassDB::bind_method(D_METHOD("resume_game"), &GameManager::resume_game);
    ClassDB::bind_method(D_METHOD("end_game", "victory"), &GameManager::end_game);
    ClassDB::bind_method(D_METHOD("restart_level"), &GameManager::restart_level);

    // Level management methods
    ClassDB::bind_method(D_METHOD("load_level", "level_index"), &GameManager::load_level);
    ClassDB::bind_method(D_METHOD("next_level"), &GameManager::next_level);
    ClassDB::bind_method(D_METHOD("get_current_level"), &GameManager::get_current_level);

    // State query methods
    ClassDB::bind_method(D_METHOD("is_playing"), &GameManager::is_playing);
    ClassDB::bind_method(D_METHOD("is_paused"), &GameManager::is_paused);
    ClassDB::bind_method(D_METHOD("get_game_time"), &GameManager::get_game_time);

    // Signals
    ADD_SIGNAL(MethodInfo("game_state_changed", PropertyInfo(Variant::INT, "new_state")));
    ADD_SIGNAL(MethodInfo("level_loaded", PropertyInfo(Variant::INT, "level_index")));
    ADD_SIGNAL(MethodInfo("game_over", PropertyInfo(Variant::BOOL, "victory")));

    // Constants for GameState enum
    BIND_CONSTANT(0); // MENU
    BIND_CONSTANT(1); // PLAYING
    BIND_CONSTANT(2); // PAUSED
    BIND_CONSTANT(3); // GAME_OVER
    BIND_CONSTANT(4); // LEVEL_COMPLETE
}

GameManager::GameManager() {
    if (singleton == nullptr) {
        singleton = this;
    }
    current_state = GameState::MENU;
    current_level = 0;
    game_time = 0.0f;
    is_initialized = false;
}

GameManager::~GameManager() {
    if (singleton == this) {
        singleton = nullptr;
    }
}

void GameManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    is_initialized = true;
    UtilityFunctions::print("GameManager initialized - Urban Survivor");
}

void GameManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    if (current_state == GameState::PLAYING) {
        game_time += static_cast<float>(delta);
    }
}

void GameManager::start_game() {
    current_state = GameState::PLAYING;
    game_time = 0.0f;
    emit_signal("game_state_changed", static_cast<int>(current_state));
    UtilityFunctions::print("Game started");
}

void GameManager::pause_game() {
    if (current_state == GameState::PLAYING) {
        current_state = GameState::PAUSED;
        get_tree()->set_pause(true);
        emit_signal("game_state_changed", static_cast<int>(current_state));
        UtilityFunctions::print("Game paused");
    }
}

void GameManager::resume_game() {
    if (current_state == GameState::PAUSED) {
        current_state = GameState::PLAYING;
        get_tree()->set_pause(false);
        emit_signal("game_state_changed", static_cast<int>(current_state));
        UtilityFunctions::print("Game resumed");
    }
}

void GameManager::end_game(bool victory) {
    current_state = GameState::GAME_OVER;
    get_tree()->set_pause(true);
    emit_signal("game_over", victory);
    emit_signal("game_state_changed", static_cast<int>(current_state));
    
    if (victory) {
        UtilityFunctions::print("Victory! Level completed.");
    } else {
        UtilityFunctions::print("Game Over - You didn't survive.");
    }
}

void GameManager::restart_level() {
    get_tree()->set_pause(false);
    load_level(current_level);
}

void GameManager::load_level(int level_index) {
    current_level = level_index;
    current_state = GameState::PLAYING;
    game_time = 0.0f;
    
    // Level paths follow pattern: res://scenes/levels/level_X.tscn
    String level_path = String("res://scenes/levels/level_{0}.tscn").format(Array::make(level_index));
    
    Error err = get_tree()->change_scene_to_file(level_path);
    if (err != OK) {
        UtilityFunctions::printerr("Failed to load level: ", level_path);
        return;
    }
    
    emit_signal("level_loaded", level_index);
    emit_signal("game_state_changed", static_cast<int>(current_state));
    UtilityFunctions::print("Loaded level ", level_index);
}

void GameManager::next_level() {
    load_level(current_level + 1);
}

} // namespace godot
