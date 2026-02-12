#include "item.hpp"

#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void Item::_bind_methods() {
    // Identification
    ClassDB::bind_method(D_METHOD("set_item_id", "id"), &Item::set_item_id);
    ClassDB::bind_method(D_METHOD("get_item_id"), &Item::get_item_id);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "item_id"), "set_item_id", "get_item_id");

    ClassDB::bind_method(D_METHOD("set_item_name", "name"), &Item::set_item_name);
    ClassDB::bind_method(D_METHOD("get_item_name"), &Item::get_item_name);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "item_name"), "set_item_name", "get_item_name");

    ClassDB::bind_method(D_METHOD("set_description", "desc"), &Item::set_description);
    ClassDB::bind_method(D_METHOD("get_description"), &Item::get_description);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "description", PROPERTY_HINT_MULTILINE_TEXT), "set_description", "get_description");

    // Type
    ClassDB::bind_method(D_METHOD("set_item_type", "type"), &Item::set_item_type_int);
    ClassDB::bind_method(D_METHOD("get_item_type"), &Item::get_item_type_int);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "item_type", PROPERTY_HINT_ENUM, "Weapon,Ammo,Consumable,Medical,Material,KeyItem,Misc"), "set_item_type", "get_item_type");

    // Properties
    ClassDB::bind_method(D_METHOD("set_weight", "weight"), &Item::set_weight);
    ClassDB::bind_method(D_METHOD("get_weight"), &Item::get_weight);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "weight", PROPERTY_HINT_RANGE, "0.0,100.0,0.1"), "set_weight", "get_weight");

    ClassDB::bind_method(D_METHOD("set_max_stack", "stack"), &Item::set_max_stack);
    ClassDB::bind_method(D_METHOD("get_max_stack"), &Item::get_max_stack);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_stack", PROPERTY_HINT_RANGE, "1,999,1"), "set_max_stack", "get_max_stack");

    ClassDB::bind_method(D_METHOD("set_is_stackable", "stackable"), &Item::set_is_stackable);
    ClassDB::bind_method(D_METHOD("get_is_stackable"), &Item::get_is_stackable);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "is_stackable"), "set_is_stackable", "get_is_stackable");

    ClassDB::bind_method(D_METHOD("set_is_usable", "usable"), &Item::set_is_usable);
    ClassDB::bind_method(D_METHOD("get_is_usable"), &Item::get_is_usable);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "is_usable"), "set_is_usable", "get_is_usable");

    ClassDB::bind_method(D_METHOD("set_is_droppable", "droppable"), &Item::set_is_droppable);
    ClassDB::bind_method(D_METHOD("get_is_droppable"), &Item::get_is_droppable);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "is_droppable"), "set_is_droppable", "get_is_droppable");

    // Resources
    ClassDB::bind_method(D_METHOD("set_icon_path", "path"), &Item::set_icon_path);
    ClassDB::bind_method(D_METHOD("get_icon_path"), &Item::get_icon_path);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "icon_path", PROPERTY_HINT_FILE, "*.png,*.jpg,*.svg"), "set_icon_path", "get_icon_path");

    ClassDB::bind_method(D_METHOD("set_model_path", "path"), &Item::set_model_path);
    ClassDB::bind_method(D_METHOD("get_model_path"), &Item::get_model_path);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "model_path", PROPERTY_HINT_FILE, "*.glb,*.gltf,*.obj"), "set_model_path", "get_model_path");

    // Methods
    ClassDB::bind_method(D_METHOD("use"), &Item::use);
    ClassDB::bind_method(D_METHOD("can_use"), &Item::can_use);

    // Constants for ItemType enum
    ClassDB::bind_integer_constant(get_class_static(), "ItemType", "WEAPON", static_cast<int>(ItemType::WEAPON));
    ClassDB::bind_integer_constant(get_class_static(), "ItemType", "AMMO", static_cast<int>(ItemType::AMMO));
    ClassDB::bind_integer_constant(get_class_static(), "ItemType", "CONSUMABLE", static_cast<int>(ItemType::CONSUMABLE));
    ClassDB::bind_integer_constant(get_class_static(), "ItemType", "MEDICAL", static_cast<int>(ItemType::MEDICAL));
    ClassDB::bind_integer_constant(get_class_static(), "ItemType", "MATERIAL", static_cast<int>(ItemType::MATERIAL));
    ClassDB::bind_integer_constant(get_class_static(), "ItemType", "KEY_ITEM", static_cast<int>(ItemType::KEY_ITEM));
    ClassDB::bind_integer_constant(get_class_static(), "ItemType", "MISC", static_cast<int>(ItemType::MISC));
}

Item::Item() {
    item_id = "";
    item_name = "Unknown Item";
    description = "";
    item_type = ItemType::MISC;
    weight = 1.0f;
    max_stack = 1;
    is_stackable = false;
    is_usable = true;
    is_droppable = true;
}

Item::~Item() {
}

void Item::use() {
    if (!is_usable) {
        UtilityFunctions::print("Cannot use ", item_name);
        return;
    }
    
    UtilityFunctions::print("Using item: ", item_name);
    
    // Base implementation - override in subclasses for specific behavior
    switch (item_type) {
        case ItemType::CONSUMABLE:
        case ItemType::MEDICAL:
            // These should restore stats - handled by subclass
            break;
        case ItemType::WEAPON:
            // Equip weapon - handled by inventory/player
            break;
        default:
            break;
    }
}

} // namespace godot
