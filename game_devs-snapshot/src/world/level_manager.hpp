#ifndef LEVEL_MANAGER_HPP
#define LEVEL_MANAGER_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * LevelManager - Handles level-specific logic and objectives
 * 
 * Tracks level completion, spawn points, and progression.
 */
class LevelManager : public Node {
    GDCLASS(LevelManager, Node)

private:
    int level_index = 0;
    String level_name;
    
    Vector3 player_spawn_point;
    Vector3 level_exit_point;
    
    bool level_complete = false;
    float completion_time = 0.0f;
    
    int enemies_remaining = 0;
    int items_collected = 0;

protected:
    static void _bind_methods();

public:
    LevelManager();
    ~LevelManager();

    void _ready() override;
    void _process(double delta) override;

    // Level info
    void set_level_index(int index) { level_index = index; }
    int get_level_index() const { return level_index; }
    
    void set_level_name(const String& name) { level_name = name; }
    String get_level_name() const { return level_name; }

    // Spawn points
    void set_player_spawn_point(Vector3 point) { player_spawn_point = point; }
    Vector3 get_player_spawn_point() const { return player_spawn_point; }
    
    void set_level_exit_point(Vector3 point) { level_exit_point = point; }
    Vector3 get_level_exit_point() const { return level_exit_point; }

    // Progression
    void complete_level();
    bool is_level_complete() const { return level_complete; }
    float get_completion_time() const { return completion_time; }

    // Stats
    void register_enemy();
    void enemy_defeated();
    int get_enemies_remaining() const { return enemies_remaining; }
    
    void item_collected();
    int get_items_collected() const { return items_collected; }

    // Signals
    // level_started()
    // level_completed(float time, int items)
    // objective_updated(String objective)
};

} // namespace godot

#endif // LEVEL_MANAGER_HPP
