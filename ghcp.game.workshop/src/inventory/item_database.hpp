#ifndef ITEM_DATABASE_HPP
#define ITEM_DATABASE_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/templates/hash_map.hpp>

namespace godot {

class Item;

/**
 * ItemDatabase - Central registry for all item definitions
 * 
 * Stores item templates that can be instantiated when picked up.
 * Used for consistent item creation throughout the game.
 */
class ItemDatabase : public Node {
    GDCLASS(ItemDatabase, Node)

private:
    HashMap<String, Ref<Item>> items;
    static ItemDatabase* singleton;

protected:
    static void _bind_methods();

public:
    ItemDatabase();
    ~ItemDatabase();

    void _ready() override;

    static ItemDatabase* get_singleton() { return singleton; }

    // Database management
    void register_item(const String& item_id, const Ref<Item>& item);
    void unregister_item(const String& item_id);
    bool has_item(const String& item_id) const;
    
    // Item retrieval
    Ref<Item> get_item(const String& item_id) const;
    Ref<Item> create_item_instance(const String& item_id) const;
    
    // Utility
    Array get_all_item_ids() const;
    Array get_items_by_type(int item_type) const;
    int get_item_count() const;
    
    // Load items from resource files
    void load_items_from_directory(const String& path);
    
    // Predefined items for survival game
    void initialize_default_items();
};

} // namespace godot

#endif // ITEM_DATABASE_HPP
