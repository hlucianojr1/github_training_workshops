#include "inventory.hpp"
#include "item.hpp"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

void Inventory::_bind_methods() {
    // Capacity
    ClassDB::bind_method(D_METHOD("set_max_slots", "slots"), &Inventory::set_max_slots);
    ClassDB::bind_method(D_METHOD("get_max_slots"), &Inventory::get_max_slots);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_slots", PROPERTY_HINT_RANGE, "5,100,1"), "set_max_slots", "get_max_slots");

    ClassDB::bind_method(D_METHOD("set_max_weight", "weight"), &Inventory::set_max_weight);
    ClassDB::bind_method(D_METHOD("get_max_weight"), &Inventory::get_max_weight);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "max_weight", PROPERTY_HINT_RANGE, "10.0,200.0,0.5"), "set_max_weight", "get_max_weight");

    ClassDB::bind_method(D_METHOD("get_current_weight"), &Inventory::get_current_weight);
    ClassDB::bind_method(D_METHOD("get_weight_ratio"), &Inventory::get_weight_ratio);
    ClassDB::bind_method(D_METHOD("is_overweight"), &Inventory::is_overweight);

    // Item management
    ClassDB::bind_method(D_METHOD("add_item", "item", "quantity"), &Inventory::add_item, DEFVAL(1));
    ClassDB::bind_method(D_METHOD("remove_item", "item", "quantity"), &Inventory::remove_item, DEFVAL(1));
    ClassDB::bind_method(D_METHOD("remove_item_by_id", "item_id", "quantity"), &Inventory::remove_item_by_id, DEFVAL(1));
    ClassDB::bind_method(D_METHOD("has_item", "item_id", "quantity"), &Inventory::has_item, DEFVAL(1));
    ClassDB::bind_method(D_METHOD("get_item_count", "item_id"), &Inventory::get_item_count);

    // Slot access
    ClassDB::bind_method(D_METHOD("get_item_at_slot", "slot_index"), &Inventory::get_item_at_slot);
    ClassDB::bind_method(D_METHOD("get_quantity_at_slot", "slot_index"), &Inventory::get_quantity_at_slot);
    ClassDB::bind_method(D_METHOD("get_slot_count"), &Inventory::get_slot_count);

    // Quick slots
    ClassDB::bind_method(D_METHOD("set_quick_slot", "slot", "item"), &Inventory::set_quick_slot);
    ClassDB::bind_method(D_METHOD("get_quick_slot", "slot"), &Inventory::get_quick_slot);
    ClassDB::bind_method(D_METHOD("use_quick_slot", "slot"), &Inventory::use_quick_slot);

    // Equipment
    ClassDB::bind_method(D_METHOD("equip_primary", "weapon"), &Inventory::equip_primary);
    ClassDB::bind_method(D_METHOD("equip_secondary", "weapon"), &Inventory::equip_secondary);
    ClassDB::bind_method(D_METHOD("get_equipped_primary"), &Inventory::get_equipped_primary);
    ClassDB::bind_method(D_METHOD("get_equipped_secondary"), &Inventory::get_equipped_secondary);

    // Utility
    ClassDB::bind_method(D_METHOD("clear"), &Inventory::clear);
    ClassDB::bind_method(D_METHOD("get_all_items"), &Inventory::get_all_items);
    ClassDB::bind_method(D_METHOD("get_items_by_type", "item_type"), &Inventory::get_items_by_type);

    // Signals
    ADD_SIGNAL(MethodInfo("item_added", 
        PropertyInfo(Variant::OBJECT, "item", PROPERTY_HINT_RESOURCE_TYPE, "Item"),
        PropertyInfo(Variant::INT, "quantity")));
    ADD_SIGNAL(MethodInfo("item_removed", 
        PropertyInfo(Variant::OBJECT, "item", PROPERTY_HINT_RESOURCE_TYPE, "Item"),
        PropertyInfo(Variant::INT, "quantity")));
    ADD_SIGNAL(MethodInfo("inventory_full"));
    ADD_SIGNAL(MethodInfo("weight_changed", PropertyInfo(Variant::FLOAT, "new_weight")));
    ADD_SIGNAL(MethodInfo("item_equipped",
        PropertyInfo(Variant::OBJECT, "item", PROPERTY_HINT_RESOURCE_TYPE, "Item"),
        PropertyInfo(Variant::INT, "slot")));
}

Inventory::Inventory() {
    max_slots = 20;
    max_weight = 50.0f;
    current_weight = 0.0f;
    
    // Initialize quick slots
    quick_slots.resize(4);
    for (int i = 0; i < 4; i++) {
        quick_slots[i] = Variant();
    }
}

Inventory::~Inventory() {
}

void Inventory::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }
    
    slots.resize(max_slots);
    UtilityFunctions::print("Inventory ready - ", max_slots, " slots, ", max_weight, " kg capacity");
}

bool Inventory::add_item(Item* item, int quantity) {
    if (!item || quantity <= 0) {
        return false;
    }

    // Check weight
    float additional_weight = item->get_weight() * quantity;
    if (current_weight + additional_weight > max_weight * 1.5f) {
        // Allow some overweight but not too much
        emit_signal("inventory_full");
        return false;
    }

    // Try to stack with existing item
    if (item->get_is_stackable()) {
        for (int i = 0; i < slots.size(); i++) {
            if (slots[i].item && slots[i].item->get_item_id() == item->get_item_id()) {
                int max_stack = item->get_max_stack();
                int space = max_stack - slots[i].quantity;
                
                if (space > 0) {
                    int add_amount = Math::min(quantity, space);
                    slots.write[i].quantity += add_amount;
                    quantity -= add_amount;
                    current_weight += item->get_weight() * add_amount;
                    
                    emit_signal("item_added", item, add_amount);
                    emit_signal("weight_changed", current_weight);
                    
                    if (quantity <= 0) {
                        return true;
                    }
                }
            }
        }
    }

    // Find empty slot for remaining quantity
    for (int i = 0; i < slots.size(); i++) {
        if (slots[i].item == nullptr) {
            slots.write[i].item = item;
            slots.write[i].quantity = Math::min(quantity, item->get_max_stack());
            current_weight += item->get_weight() * slots[i].quantity;
            
            emit_signal("item_added", item, slots[i].quantity);
            emit_signal("weight_changed", current_weight);
            return true;
        }
    }

    emit_signal("inventory_full");
    return false;
}

bool Inventory::remove_item(Item* item, int quantity) {
    if (!item) {
        return false;
    }
    return remove_item_by_id(item->get_item_id(), quantity);
}

bool Inventory::remove_item_by_id(const String& item_id, int quantity) {
    int remaining = quantity;

    for (int i = 0; i < slots.size() && remaining > 0; i++) {
        if (slots[i].item && slots[i].item->get_item_id() == item_id) {
            int remove_amount = Math::min(remaining, slots[i].quantity);
            slots.write[i].quantity -= remove_amount;
            current_weight -= slots[i].item->get_weight() * remove_amount;
            remaining -= remove_amount;

            emit_signal("item_removed", slots[i].item, remove_amount);

            if (slots[i].quantity <= 0) {
                slots.write[i].item = nullptr;
                slots.write[i].quantity = 0;
            }
        }
    }

    if (remaining < quantity) {
        emit_signal("weight_changed", current_weight);
    }

    return remaining == 0;
}

bool Inventory::has_item(const String& item_id, int quantity) const {
    return get_item_count(item_id) >= quantity;
}

int Inventory::get_item_count(const String& item_id) const {
    int count = 0;
    for (int i = 0; i < slots.size(); i++) {
        if (slots[i].item && slots[i].item->get_item_id() == item_id) {
            count += slots[i].quantity;
        }
    }
    return count;
}

Item* Inventory::get_item_at_slot(int slot_index) const {
    if (slot_index >= 0 && slot_index < slots.size()) {
        return slots[slot_index].item;
    }
    return nullptr;
}

int Inventory::get_quantity_at_slot(int slot_index) const {
    if (slot_index >= 0 && slot_index < slots.size()) {
        return slots[slot_index].quantity;
    }
    return 0;
}

void Inventory::set_quick_slot(int slot, Item* item) {
    if (slot >= 0 && slot < 4) {
        quick_slots[slot] = item;
    }
}

Item* Inventory::get_quick_slot(int slot) const {
    if (slot >= 0 && slot < 4) {
        return Object::cast_to<Item>(quick_slots[slot]);
    }
    return nullptr;
}

void Inventory::use_quick_slot(int slot) {
    Item* item = get_quick_slot(slot);
    if (item) {
        item->use();
    }
}

void Inventory::equip_primary(Item* weapon) {
    equipped_primary = weapon;
    emit_signal("item_equipped", weapon, 0);
}

void Inventory::equip_secondary(Item* weapon) {
    equipped_secondary = weapon;
    emit_signal("item_equipped", weapon, 1);
}

void Inventory::clear() {
    for (int i = 0; i < slots.size(); i++) {
        slots.write[i].item = nullptr;
        slots.write[i].quantity = 0;
    }
    current_weight = 0.0f;
    equipped_primary = nullptr;
    equipped_secondary = nullptr;
    emit_signal("weight_changed", current_weight);
}

Array Inventory::get_all_items() const {
    Array items;
    for (int i = 0; i < slots.size(); i++) {
        if (slots[i].item) {
            Dictionary slot_info;
            slot_info["item"] = slots[i].item;
            slot_info["quantity"] = slots[i].quantity;
            slot_info["slot"] = i;
            items.append(slot_info);
        }
    }
    return items;
}

Array Inventory::get_items_by_type(int item_type) const {
    Array items;
    for (int i = 0; i < slots.size(); i++) {
        if (slots[i].item && static_cast<int>(slots[i].item->get_item_type()) == item_type) {
            Dictionary slot_info;
            slot_info["item"] = slots[i].item;
            slot_info["quantity"] = slots[i].quantity;
            slot_info["slot"] = i;
            items.append(slot_info);
        }
    }
    return items;
}

} // namespace godot
