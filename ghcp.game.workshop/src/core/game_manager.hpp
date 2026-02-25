#ifndef GAME_MANAGER_HPP
#define GAME_MANAGER_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * GameManager - Central game state coordinator
 * 
 * Manages global game state, level transitions, and coordinates
 * between major game systems (player, AI, world, UI).
 */
class GameManager : public Node {
    GDCLASS(GameManager, Node)

public:
    enum class GameState {
        MENU,
        PLAYING,
        PAUSED,
        GAME_OVER,
        LEVEL_COMPLETE
    };

private:
    static GameManager* singleton;
    GameState current_state = GameState::MENU;
    int current_level = 0;
    float game_time = 0.0f;
    bool is_initialized = false;

protected:
    static void _bind_methods();

public:
    GameManager();
    ~GameManager();

    static GameManager* get_singleton() { return singleton; }

    void _ready() override;
    void _process(double delta) override;

    // State management
    void start_game();
    void pause_game();
    void resume_game();
    void end_game(bool victory);
    void restart_level();
    
    // Level management
    void load_level(int level_index);
    void next_level();
    int get_current_level() const { return current_level; }
    
    // State queries
    GameState get_game_state() const { return current_state; }
    bool is_playing() const { return current_state == GameState::PLAYING; }
    bool is_paused() const { return current_state == GameState::PAUSED; }
    float get_game_time() const { return game_time; }

    // Signals
    // game_state_changed(int new_state)
    // level_loaded(int level_index)
    // game_over(bool victory)
};

} // namespace godot

#endif // GAME_MANAGER_HPP
