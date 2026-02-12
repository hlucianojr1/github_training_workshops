#include "register_types.hpp"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

// Core systems
#include "core/game_manager.hpp"

// Player systems
#include "player/player_controller.hpp"

// Camera systems
#include "camera/third_person_camera.hpp"

// AI systems
#include "ai/enemy_ai.hpp"
#include "ai/ai_perception.hpp"

// Inventory systems
#include "inventory/inventory.hpp"
#include "inventory/item.hpp"
#include "inventory/item_database.hpp"

// Survival systems
#include "survival/survival_stats.hpp"

// Combat systems
#include "combat/weapon.hpp"
#include "combat/damage_system.hpp"

// World systems
#include "world/level_manager.hpp"
#include "world/scavenge_point.hpp"

// UI systems
#include "ui/hud.hpp"

using namespace godot;

void initialize_urban_survivor_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

    // Register core classes
    ClassDB::register_class<GameManager>();

    // Register player classes
    ClassDB::register_class<PlayerController>();

    // Register camera classes
    ClassDB::register_class<ThirdPersonCamera>();

    // Register AI classes
    ClassDB::register_class<EnemyAI>();
    ClassDB::register_class<AIPerception>();

    // Register inventory classes
    ClassDB::register_class<Item>();
    ClassDB::register_class<Inventory>();
    ClassDB::register_class<ItemDatabase>();

    // Register survival classes
    ClassDB::register_class<SurvivalStats>();

    // Register combat classes
    ClassDB::register_class<Weapon>();
    ClassDB::register_class<DamageSystem>();

    // Register world classes
    ClassDB::register_class<LevelManager>();
    ClassDB::register_class<ScavengePoint>();

    // Register UI classes
    ClassDB::register_class<HUD>();
}

void uninitialize_urban_survivor_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    // Cleanup if needed
}

extern "C" {
    GDExtensionBool GDE_EXPORT urban_survivor_library_init(
        GDExtensionInterfaceGetProcAddress p_get_proc_address,
        const GDExtensionClassLibraryPtr p_library,
        GDExtensionInitialization *r_initialization
    ) {
        godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

        init_obj.register_initializer(initialize_urban_survivor_module);
        init_obj.register_terminator(uninitialize_urban_survivor_module);
        init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

        return init_obj.init();
    }
}
