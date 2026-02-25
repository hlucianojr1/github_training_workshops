#include "item_database.hpp"
#include "item.hpp"

#include <godot_cpp/classes/dir_access.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

ItemDatabase* ItemDatabase::singleton = nullptr;

void ItemDatabase::_bind_methods() {
    ClassDB::bind_method(D_METHOD("register_item", "item_id", "item"), &ItemDatabase::register_item);
    ClassDB::bind_method(D_METHOD("unregister_item", "item_id"), &ItemDatabase::unregister_item);
    ClassDB::bind_method(D_METHOD("has_item", "item_id"), &ItemDatabase::has_item);
    ClassDB::bind_method(D_METHOD("get_item", "item_id"), &ItemDatabase::get_item);
    ClassDB::bind_method(D_METHOD("create_item_instance", "item_id"), &ItemDatabase::create_item_instance);
    ClassDB::bind_method(D_METHOD("get_all_item_ids"), &ItemDatabase::get_all_item_ids);
    ClassDB::bind_method(D_METHOD("get_items_by_type", "item_type"), &ItemDatabase::get_items_by_type);
    ClassDB::bind_method(D_METHOD("get_item_count"), &ItemDatabase::get_item_count);
    ClassDB::bind_method(D_METHOD("load_items_from_directory", "path"), &ItemDatabase::load_items_from_directory);
    ClassDB::bind_method(D_METHOD("initialize_default_items"), &ItemDatabase::initialize_default_items);
}

ItemDatabase::ItemDatabase() {
    if (singleton == nullptr) {
        singleton = this;
    }
}

ItemDatabase::~ItemDatabase() {
    if (singleton == this) {
        singleton = nullptr;
    }
}

void ItemDatabase::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // Initialize with default survival items
    initialize_default_items();
    
    UtilityFunctions::print("ItemDatabase ready - ", get_item_count(), " items registered");
}

void ItemDatabase::register_item(const String& item_id, const Ref<Item>& item) {
    if (item.is_valid()) {
        items[item_id] = item;
    }
}

void ItemDatabase::unregister_item(const String& item_id) {
    items.erase(item_id);
}

bool ItemDatabase::has_item(const String& item_id) const {
    return items.has(item_id);
}

Ref<Item> ItemDatabase::get_item(const String& item_id) const {
    if (items.has(item_id)) {
        return items[item_id];
    }
    return Ref<Item>();
}

Ref<Item> ItemDatabase::create_item_instance(const String& item_id) const {
    Ref<Item> template_item = get_item(item_id);
    if (template_item.is_valid()) {
        // Create a duplicate for instance
        return template_item->duplicate();
    }
    return Ref<Item>();
}

Array ItemDatabase::get_all_item_ids() const {
    Array ids;
    for (const KeyValue<String, Ref<Item>>& pair : items) {
        ids.append(pair.key);
    }
    return ids;
}

Array ItemDatabase::get_items_by_type(int item_type) const {
    Array matching_items;
    for (const KeyValue<String, Ref<Item>>& pair : items) {
        if (pair.value.is_valid() && static_cast<int>(pair.value->get_item_type()) == item_type) {
            matching_items.append(pair.value);
        }
    }
    return matching_items;
}

int ItemDatabase::get_item_count() const {
    return items.size();
}

void ItemDatabase::load_items_from_directory(const String& path) {
    Ref<DirAccess> dir = DirAccess::open(path);
    if (!dir.is_valid()) {
        UtilityFunctions::printerr("Failed to open item directory: ", path);
        return;
    }

    dir->list_dir_begin();
    String filename = dir->get_next();
    
    while (!filename.is_empty()) {
        if (!dir->current_is_dir() && filename.ends_with(".tres")) {
            String full_path = path.path_join(filename);
            Ref<Item> item = ResourceLoader::get_singleton()->load(full_path);
            
            if (item.is_valid()) {
                register_item(item->get_item_id(), item);
            }
        }
        filename = dir->get_next();
    }
    
    dir->list_dir_end();
}

void ItemDatabase::initialize_default_items() {
    // === WEAPONS ===
    
    // Pistol - M1911 (1960s classic)
    Ref<Item> pistol;
    pistol.instantiate();
    pistol->set_item_id("weapon_pistol_m1911");
    pistol->set_item_name("M1911 Pistol");
    pistol->set_description("A reliable .45 ACP pistol. Standard sidearm, effective at close range.");
    pistol->set_item_type(Item::ItemType::WEAPON);
    pistol->set_weight(1.1f);
    pistol->set_is_stackable(false);
    register_item(pistol->get_item_id(), pistol);

    // Revolver
    Ref<Item> revolver;
    revolver.instantiate();
    revolver->set_item_id("weapon_revolver_38");
    revolver->set_item_name(".38 Revolver");
    revolver->set_description("Six-shot revolver. Slow to reload but packs a punch.");
    revolver->set_item_type(Item::ItemType::WEAPON);
    revolver->set_weight(0.9f);
    revolver->set_is_stackable(false);
    register_item(revolver->get_item_id(), revolver);

    // Shotgun
    Ref<Item> shotgun;
    shotgun.instantiate();
    shotgun->set_item_id("weapon_shotgun_pump");
    shotgun->set_item_name("Pump Shotgun");
    shotgun->set_description("12-gauge pump-action. Devastating at close quarters.");
    shotgun->set_item_type(Item::ItemType::WEAPON);
    shotgun->set_weight(3.5f);
    shotgun->set_is_stackable(false);
    register_item(shotgun->get_item_id(), shotgun);

    // Rifle
    Ref<Item> rifle;
    rifle.instantiate();
    rifle->set_item_id("weapon_rifle_m14");
    rifle->set_item_name("M14 Rifle");
    rifle->set_description("Semi-automatic rifle. Good accuracy at medium range.");
    rifle->set_item_type(Item::ItemType::WEAPON);
    rifle->set_weight(4.1f);
    rifle->set_is_stackable(false);
    register_item(rifle->get_item_id(), rifle);

    // === AMMUNITION ===
    
    Ref<Item> ammo_pistol;
    ammo_pistol.instantiate();
    ammo_pistol->set_item_id("ammo_45acp");
    ammo_pistol->set_item_name(".45 ACP Rounds");
    ammo_pistol->set_description("Standard pistol ammunition.");
    ammo_pistol->set_item_type(Item::ItemType::AMMO);
    ammo_pistol->set_weight(0.02f);
    ammo_pistol->set_is_stackable(true);
    ammo_pistol->set_max_stack(100);
    register_item(ammo_pistol->get_item_id(), ammo_pistol);

    Ref<Item> ammo_38;
    ammo_38.instantiate();
    ammo_38->set_item_id("ammo_38special");
    ammo_38->set_item_name(".38 Special Rounds");
    ammo_38->set_description("Revolver ammunition.");
    ammo_38->set_item_type(Item::ItemType::AMMO);
    ammo_38->set_weight(0.015f);
    ammo_38->set_is_stackable(true);
    ammo_38->set_max_stack(50);
    register_item(ammo_38->get_item_id(), ammo_38);

    Ref<Item> ammo_shotgun;
    ammo_shotgun.instantiate();
    ammo_shotgun->set_item_id("ammo_12gauge");
    ammo_shotgun->set_item_name("12 Gauge Shells");
    ammo_shotgun->set_description("Shotgun shells. Limited availability.");
    ammo_shotgun->set_item_type(Item::ItemType::AMMO);
    ammo_shotgun->set_weight(0.04f);
    ammo_shotgun->set_is_stackable(true);
    ammo_shotgun->set_max_stack(30);
    register_item(ammo_shotgun->get_item_id(), ammo_shotgun);

    Ref<Item> ammo_rifle;
    ammo_rifle.instantiate();
    ammo_rifle->set_item_id("ammo_762nato");
    ammo_rifle->set_item_name("7.62 NATO Rounds");
    ammo_rifle->set_description("Rifle ammunition. Rare find.");
    ammo_rifle->set_item_type(Item::ItemType::AMMO);
    ammo_rifle->set_weight(0.025f);
    ammo_rifle->set_is_stackable(true);
    ammo_rifle->set_max_stack(60);
    register_item(ammo_rifle->get_item_id(), ammo_rifle);

    // === MEDICAL ===
    
    Ref<Item> bandage;
    bandage.instantiate();
    bandage->set_item_id("medical_bandage");
    bandage->set_item_name("Bandage");
    bandage->set_description("Basic wound dressing. Restores 25 health over time.");
    bandage->set_item_type(Item::ItemType::MEDICAL);
    bandage->set_weight(0.1f);
    bandage->set_is_stackable(true);
    bandage->set_max_stack(10);
    register_item(bandage->get_item_id(), bandage);

    Ref<Item> medkit;
    medkit.instantiate();
    medkit->set_item_id("medical_medkit");
    medkit->set_item_name("First Aid Kit");
    medkit->set_description("Complete medical kit. Restores 75 health instantly.");
    medkit->set_item_type(Item::ItemType::MEDICAL);
    medkit->set_weight(0.8f);
    medkit->set_is_stackable(true);
    medkit->set_max_stack(3);
    register_item(medkit->get_item_id(), medkit);

    Ref<Item> morphine;
    morphine.instantiate();
    morphine->set_item_id("medical_morphine");
    morphine->set_item_name("Morphine Syrette");
    morphine->set_description("Military-grade painkiller. Restores full health but causes temporary vision blur.");
    morphine->set_item_type(Item::ItemType::MEDICAL);
    morphine->set_weight(0.05f);
    morphine->set_is_stackable(true);
    morphine->set_max_stack(5);
    register_item(morphine->get_item_id(), morphine);

    // === CONSUMABLES ===
    
    Ref<Item> canned_food;
    canned_food.instantiate();
    canned_food->set_item_id("food_canned_beans");
    canned_food->set_item_name("Canned Beans");
    canned_food->set_description("Preserved food. Restores stamina.");
    canned_food->set_item_type(Item::ItemType::CONSUMABLE);
    canned_food->set_weight(0.4f);
    canned_food->set_is_stackable(true);
    canned_food->set_max_stack(5);
    register_item(canned_food->get_item_id(), canned_food);

    Ref<Item> water;
    water.instantiate();
    water->set_item_id("drink_water_bottle");
    water->set_item_name("Water Bottle");
    water->set_description("Clean drinking water. Essential for survival.");
    water->set_item_type(Item::ItemType::CONSUMABLE);
    water->set_weight(0.5f);
    water->set_is_stackable(true);
    water->set_max_stack(3);
    register_item(water->get_item_id(), water);

    Ref<Item> rations;
    rations.instantiate();
    rations->set_item_id("food_military_rations");
    rations->set_item_name("Military Rations");
    rations->set_description("Complete meal pack. Restores health and stamina.");
    rations->set_item_type(Item::ItemType::CONSUMABLE);
    rations->set_weight(0.6f);
    rations->set_is_stackable(true);
    rations->set_max_stack(3);
    register_item(rations->get_item_id(), rations);

    // === MATERIALS ===
    
    Ref<Item> scrap_metal;
    scrap_metal.instantiate();
    scrap_metal->set_item_id("material_scrap_metal");
    scrap_metal->set_item_name("Scrap Metal");
    scrap_metal->set_description("Salvaged metal. Useful for repairs and crafting.");
    scrap_metal->set_item_type(Item::ItemType::MATERIAL);
    scrap_metal->set_weight(0.3f);
    scrap_metal->set_is_stackable(true);
    scrap_metal->set_max_stack(20);
    scrap_metal->set_is_usable(false);
    register_item(scrap_metal->get_item_id(), scrap_metal);

    Ref<Item> cloth;
    cloth.instantiate();
    cloth->set_item_id("material_cloth");
    cloth->set_item_name("Cloth Scraps");
    cloth->set_description("Torn fabric. Can be used to craft bandages.");
    cloth->set_item_type(Item::ItemType::MATERIAL);
    cloth->set_weight(0.1f);
    cloth->set_is_stackable(true);
    cloth->set_max_stack(20);
    cloth->set_is_usable(false);
    register_item(cloth->get_item_id(), cloth);

    UtilityFunctions::print("Default items initialized");
}

} // namespace godot
