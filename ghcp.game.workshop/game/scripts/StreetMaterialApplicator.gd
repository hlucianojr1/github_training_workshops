# StreetMaterialApplicator.gd
# Applies NYC Street Asphalt material to road/street meshes
# Attach this to the RoadCity node

extends Node3D

@export var street_material_path: String = "res://textures/street/nyc_street_asphalt.tres"
@export var target_material_names: Array[String] = ["Material2", "Material3"]  # Materials to replace
@export var apply_to_all_meshes: bool = false  # If true, applies to all mesh children

var street_material: StandardMaterial3D = null

func _ready():
	# Load the street material
	street_material = load(street_material_path)
	if street_material == null:
		push_error("StreetMaterialApplicator: Failed to load material from " + street_material_path)
		return
	
	# Apply to all LOD children
	call_deferred("_apply_materials")

func _apply_materials():
	for child in get_children():
		if child.name.begins_with("LOD"):
			_apply_to_node(child)
	
	print("StreetMaterialApplicator: Applied NYC Street Asphalt material to road meshes")

func _apply_to_node(node: Node):
	# If this node is a MeshInstance3D, check its materials
	if node is MeshInstance3D:
		var mesh_inst: MeshInstance3D = node as MeshInstance3D
		var mesh: Mesh = mesh_inst.mesh
		
		if mesh == null:
			return
		
		# Check each surface
		for surface_idx in range(mesh.get_surface_count()):
			var mat = mesh_inst.get_active_material(surface_idx)
			if mat == null:
				continue
			
			# Check if this material should be replaced
			var should_replace = apply_to_all_meshes
			if not should_replace:
				for target_name in target_material_names:
					if mat.resource_name.begins_with(target_name) or target_name in mat.resource_name:
						should_replace = true
						break
			
			if should_replace:
				mesh_inst.set_surface_override_material(surface_idx, street_material)
	
	# Recurse into children
	for child in node.get_children():
		_apply_to_node(child)
