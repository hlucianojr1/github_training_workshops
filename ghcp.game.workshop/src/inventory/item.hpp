#ifndef ITEM_HPP
#define ITEM_HPP

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

/**
 * Item - Base class for all inventory items
 * 
 * Defines item properties like type, weight, stacking.
 * Subclassed for weapons, consumables, materials, etc.
 */
class Item : public Resource {
    GDCLASS(Item, Resource)

public:
    enum class ItemType {
        WEAPON,
        AMMO,
        CONSUMABLE,
        MEDICAL,
        MATERIAL,
        KEY_ITEM,
        MISC
    };

private:
    String item_id;
    String item_name;
    String description;
    ItemType item_type = ItemType::MISC;
    
    float weight = 1.0f;
    int max_stack = 1;
    bool is_stackable = false;
    bool is_usable = true;
    bool is_droppable = true;
    
    String icon_path;
    String model_path;

protected:
    static void _bind_methods();

public:
    Item();
    ~Item();

    // Identification
    void set_item_id(const String& id) { item_id = id; }
    String get_item_id() const { return item_id; }
    
    void set_item_name(const String& name) { item_name = name; }
    String get_item_name() const { return item_name; }
    
    void set_description(const String& desc) { description = desc; }
    String get_description() const { return description; }

    // Type
    void set_item_type(ItemType type) { item_type = type; }
    ItemType get_item_type() const { return item_type; }
    void set_item_type_int(int type) { item_type = static_cast<ItemType>(type); }
    int get_item_type_int() const { return static_cast<int>(item_type); }

    // Properties
    void set_weight(float w) { weight = w; }
    float get_weight() const { return weight; }
    
    void set_max_stack(int stack) { max_stack = stack; }
    int get_max_stack() const { return max_stack; }
    
    void set_is_stackable(bool stackable) { is_stackable = stackable; max_stack = stackable ? 99 : 1; }
    bool get_is_stackable() const { return is_stackable; }
    
    void set_is_usable(bool usable) { is_usable = usable; }
    bool get_is_usable() const { return is_usable; }
    
    void set_is_droppable(bool droppable) { is_droppable = droppable; }
    bool get_is_droppable() const { return is_droppable; }

    // Resources
    void set_icon_path(const String& path) { icon_path = path; }
    String get_icon_path() const { return icon_path; }
    
    void set_model_path(const String& path) { model_path = path; }
    String get_model_path() const { return model_path; }

    // Virtual methods for subclasses
    virtual void use();
    virtual bool can_use() const { return is_usable; }
};

} // namespace godot

#endif // ITEM_HPP
