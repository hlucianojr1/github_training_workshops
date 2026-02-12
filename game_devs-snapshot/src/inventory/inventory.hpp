#ifndef INVENTORY_HPP
#define INVENTORY_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/templates/vector.hpp>

namespace godot {

class Item;

/**
 * Inventory - Container for player items
 * 
 * Manages item storage with weight limits, quick slots,
 * and equipped items. Used for survival resource management.
 */
class Inventory : public Node {
    GDCLASS(Inventory, Node)

public:
    struct ItemSlot {
        Item* item = nullptr;
        int quantity = 0;
    };

private:
    // Capacity
    int max_slots = 20;
    float max_weight = 50.0f;
    float current_weight = 0.0f;
    
    // Storage
    Vector<ItemSlot> slots;
    Array quick_slots;  // 4 quick access slots
    
    // Equipped
    Item* equipped_primary = nullptr;
    Item* equipped_secondary = nullptr;

protected:
    static void _bind_methods();

public:
    Inventory();
    ~Inventory();

    void _ready() override;

    // Capacity
    void set_max_slots(int slots) { max_slots = slots; }
    int get_max_slots() const { return max_slots; }
    
    void set_max_weight(float weight) { max_weight = weight; }
    float get_max_weight() const { return max_weight; }
    
    float get_current_weight() const { return current_weight; }
    float get_weight_ratio() const { return current_weight / max_weight; }
    bool is_overweight() const { return current_weight > max_weight; }

    // Item management
    bool add_item(Item* item, int quantity = 1);
    bool remove_item(Item* item, int quantity = 1);
    bool remove_item_by_id(const String& item_id, int quantity = 1);
    bool has_item(const String& item_id, int quantity = 1) const;
    int get_item_count(const String& item_id) const;
    
    // Slot access
    Item* get_item_at_slot(int slot_index) const;
    int get_quantity_at_slot(int slot_index) const;
    int get_slot_count() const { return slots.size(); }
    
    // Quick slots (0-3)
    void set_quick_slot(int slot, Item* item);
    Item* get_quick_slot(int slot) const;
    void use_quick_slot(int slot);
    
    // Equipment
    void equip_primary(Item* weapon);
    void equip_secondary(Item* weapon);
    Item* get_equipped_primary() const { return equipped_primary; }
    Item* get_equipped_secondary() const { return equipped_secondary; }
    
    // Utility
    void clear();
    Array get_all_items() const;
    Array get_items_by_type(int item_type) const;

    // Signals
    // item_added(Item* item, int quantity)
    // item_removed(Item* item, int quantity)
    // inventory_full()
    // weight_changed(float new_weight)
    // item_equipped(Item* item, int slot)
};

} // namespace godot

#endif // INVENTORY_HPP
