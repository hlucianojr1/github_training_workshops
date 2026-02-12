# RoadCityLOD.gd
# Automatic LOD system for road city block in Urban Survivor
# Attach this to the RoadCity Node3D parent

extends Node3D

# LOD switch distances (optimized for Urban Survivor third-person camera)
@export var lod_distances: Array[float] = [20.0, 50.0, 100.0]
@export var enable_debug_output: bool = false

# LOD mesh nodes (will be auto-discovered from children)
@onready var lod_meshes: Array[Node3D] = []

var current_lod: int = -1
var player: Node3D = null

func _ready():
    # Discover LOD meshes from children (LOD0, LOD1, LOD2, LOD3)
    for child in get_children():
        if child.name.begins_with("LOD") and child.name != "LODManager":
            lod_meshes.append(child)
    
    # Sort by name to ensure LOD0, LOD1, LOD2, LOD3 order
    lod_meshes.sort_custom(_sort_by_name)
    
    if lod_meshes.size() != 4:
        push_error("RoadCityLOD: Expected 4 LOD levels, found " + str(lod_meshes.size()))
        return
    
    # Start with lowest detail (LOD3) visible
    for i in range(lod_meshes.size()):
        lod_meshes[i].visible = (i == 3)
    current_lod = 3
    
    if enable_debug_output:
        print("RoadCityLOD initialized with ", lod_meshes.size(), " LOD levels")
        print("  LOD0: 0-", lod_distances[0], "m")
        print("  LOD1: ", lod_distances[0], "-", lod_distances[1], "m")
        print("  LOD2: ", lod_distances[1], "-", lod_distances[2], "m")
        print("  LOD3: ", lod_distances[2], "m+")

func _process(_delta):
    # Find player if we don't have a reference
    if player == null:
        player = _find_player()
        if player == null:
            return
    
    # Calculate distance from player to this city block
    var distance = global_position.distance_to(player.global_position)
    
    # Determine appropriate LOD level based on distance
    var new_lod = 3  # Default to lowest detail
    if distance < lod_distances[0]:
        new_lod = 0  # Closest: full detail
    elif distance < lod_distances[1]:
        new_lod = 1  # Medium distance
    elif distance < lod_distances[2]:
        new_lod = 2  # Far distance
    # else: new_lod = 3 (furthest distance)
    
    # Only switch if LOD level changed
    if new_lod != current_lod:
        _switch_lod(new_lod)

func _switch_lod(new_lod: int):
    if new_lod < 0 or new_lod >= lod_meshes.size():
        return
    
    # Hide current LOD
    if current_lod >= 0 and current_lod < lod_meshes.size():
        lod_meshes[current_lod].visible = false
    
    # Show new LOD
    lod_meshes[new_lod].visible = true
    
    if enable_debug_output:
        var distance = global_position.distance_to(player.global_position)
        var poly_counts = [671914, 335950, 167977, 67172]
        print("City block switched to LOD", new_lod, 
              " at ", int(distance), "m",
              " (", poly_counts[new_lod], " polys)")
    
    current_lod = new_lod

func _find_player() -> Node3D:
    # Try to find player in the scene tree
    # Urban Survivor typically has Player as a top-level node
    var root = get_tree().root
    var player_node = root.get_node_or_null("Player")
    
    if player_node == null:
        # Try common player names
        for player_name in ["Player", "PlayerController", "PlayerCharacter"]:
            player_node = root.get_node_or_null(player_name)
            if player_node:
                break
    
    # Fallback: search for CharacterBody3D with "player" in name
    if player_node == null:
        for node in get_tree().get_nodes_in_group("player"):
            if node is CharacterBody3D or node is Node3D:
                player_node = node
                break
    
    if player_node and enable_debug_output:
        print("RoadCityLOD: Found player at ", player_node.get_path())
    
    return player_node

func _sort_by_name(a, b):
    return a.name < b.name


# === Alternative: Manual LOD Control ===
# If you don't want automatic switching, call these manually

func set_lod_level(lod: int):
    '''Manually set specific LOD level (0-3)'''
    if lod >= 0 and lod < lod_meshes.size():
        _switch_lod(lod)

func get_current_lod() -> int:
    '''Get currently active LOD level'''
    return current_lod

func get_distance_to_player() -> float:
    '''Get current distance to player'''
    if player:
        return global_position.distance_to(player.global_position)
    return -1.0
