#include "scavenge_point.hpp"
#include "../inventory/item.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void ScavengePoint::_bind_methods() {
    // Setup
    ClassDB::bind_method(D_METHOD("set_item_pool", "pool"), &ScavengePoint::set_item_pool);
    ClassDB::bind_method(D_METHOD("get_item_pool"), &ScavengePoint::get_item_pool);
    ADD_PROPERTY(PropertyInfo(Variant::ARRAY, "item_pool"), "set_item_pool", "get_item_pool");

    ClassDB::bind_method(D_METHOD("set_is_randomized", "randomized"), &ScavengePoint::set_is_randomized);
    ClassDB::bind_method(D_METHOD("get_is_randomized"), &ScavengePoint::get_is_randomized);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "is_randomized"), "set_is_randomized", "get_is_randomized");

    ClassDB::bind_method(D_METHOD("set_min_items", "min"), &ScavengePoint::set_min_items);
    ClassDB::bind_method(D_METHOD("get_min_items"), &ScavengePoint::get_min_items);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "min_items", PROPERTY_HINT_RANGE, "0,10,1"), "set_min_items", "get_min_items");

    ClassDB::bind_method(D_METHOD("set_max_items", "max"), &ScavengePoint::set_max_items);
    ClassDB::bind_method(D_METHOD("get_max_items"), &ScavengePoint::get_max_items);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_items", PROPERTY_HINT_RANGE, "1,20,1"), "set_max_items", "get_max_items");

    // Actions
    ClassDB::bind_method(D_METHOD("generate_loot"), &ScavengePoint::generate_loot);
    ClassDB::bind_method(D_METHOD("loot"), &ScavengePoint::loot);
    ClassDB::bind_method(D_METHOD("can_be_looted"), &ScavengePoint::can_be_looted);
    ClassDB::bind_method(D_METHOD("reset"), &ScavengePoint::reset);

    // State
    ClassDB::bind_method(D_METHOD("get_has_been_looted"), &ScavengePoint::get_has_been_looted);
    ClassDB::bind_method(D_METHOD("get_spawned_items"), &ScavengePoint::get_spawned_items);

    // Signals
    ADD_SIGNAL(MethodInfo("looted", PropertyInfo(Variant::ARRAY, "items")));
    ADD_SIGNAL(MethodInfo("loot_generated"));
}

ScavengePoint::ScavengePoint() {
    has_been_looted = false;
    is_randomized = true;
    min_items = 1;
    max_items = 3;
}

ScavengePoint::~ScavengePoint() {
}

void ScavengePoint::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // Generate loot on ready
    if (is_randomized) {
        generate_loot();
    }

    UtilityFunctions::print("ScavengePoint ready");
}

void ScavengePoint::generate_loot() {
    if (item_pool.is_empty()) {
        return;
    }

    spawned_items.clear();

    if (is_randomized) {
        // Random selection from pool
        int item_count = UtilityFunctions::randi_range(min_items, max_items);
        
        for (int i = 0; i < item_count; i++) {
            int pool_index = UtilityFunctions::randi_range(0, item_pool.size() - 1);
            spawned_items.append(item_pool[pool_index]);
        }
    } else {
        // Spawn all items in pool
        spawned_items = item_pool.duplicate();
    }

    emit_signal("loot_generated");
}

Array ScavengePoint::loot() {
    if (has_been_looted) {
        return Array();
    }

    has_been_looted = true;
    Array items = spawned_items.duplicate();
    
    emit_signal("looted", items);
    
    return items;
}

void ScavengePoint::reset() {
    has_been_looted = false;
    spawned_items.clear();
    
    if (is_randomized) {
        generate_loot();
    }
}

} // namespace godot
