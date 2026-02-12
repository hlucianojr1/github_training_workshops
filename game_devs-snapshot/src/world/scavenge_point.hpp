#ifndef SCAVENGE_POINT_HPP
#define SCAVENGE_POINT_HPP

#include <godot_cpp/classes/area3d.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

class Item;

/**
 * ScavengePoint - Interactable loot location
 * 
 * Spawns items for player to collect. Can be containers,
 * bodies, or environmental pickups.
 */
class ScavengePoint : public Area3D {
    GDCLASS(ScavengePoint, Area3D)

private:
    Array item_pool;  // Items that can spawn here
    bool has_been_looted = false;
    bool is_randomized = true;
    int min_items = 1;
    int max_items = 3;
    
    Array spawned_items;

protected:
    static void _bind_methods();

public:
    ScavengePoint();
    ~ScavengePoint();

    void _ready() override;

    // Setup
    void set_item_pool(const Array& pool) { item_pool = pool; }
    Array get_item_pool() const { return item_pool; }
    
    void set_is_randomized(bool randomized) { is_randomized = randomized; }
    bool get_is_randomized() const { return is_randomized; }
    
    void set_min_items(int min) { min_items = min; }
    int get_min_items() const { return min_items; }
    
    void set_max_items(int max) { max_items = max; }
    int get_max_items() const { return max_items; }

    // Actions
    void generate_loot();
    Array loot();
    bool can_be_looted() const { return !has_been_looted; }
    void reset();

    // State
    bool get_has_been_looted() const { return has_been_looted; }
    Array get_spawned_items() const { return spawned_items; }

    // Signals
    // looted(Array items)
    // loot_generated()
};

} // namespace godot

#endif // SCAVENGE_POINT_HPP
