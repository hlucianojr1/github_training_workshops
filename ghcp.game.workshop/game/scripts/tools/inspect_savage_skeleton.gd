@tool
extends EditorScript

## Tool script to inspect savage.glb skeleton structure
## Run this from Godot Editor: File > Run

func _run():
	print("=".repeat(60))
	print("SAVAGE.GLB SKELETON INSPECTION")
	print("=".repeat(60))
	
	# Load the savage.glb scene
	var savage_scene = load("res://assets/models/characters/savage.glb")
	if savage_scene == null:
		print("ERROR: Could not load savage.glb")
		return
	
	# Instantiate it
	var savage_instance = savage_scene.instantiate()
	print("\nScene loaded successfully")
	print("Root node: ", savage_instance.name, " (", savage_instance.get_class(), ")")
	
	# Find skeleton
	var skeleton = find_skeleton(savage_instance)
	if skeleton == null:
		print("\nERROR: No Skeleton3D found in savage.glb")
		print_node_tree(savage_instance, 0)
		savage_instance.queue_free()
		return
	
	print("\n✓ Skeleton3D found: ", skeleton.name)
	print("  Bone count: ", skeleton.get_bone_count())
	print("\n" + "=".repeat(60))
	print("BONE HIERARCHY")
	print("=".repeat(60))
	
	# Print all bones with hierarchy
	for i in range(skeleton.get_bone_count()):
		var bone_name = skeleton.get_bone_name(i)
		var parent_idx = skeleton.get_bone_parent(i)
		var parent_name = "ROOT" if parent_idx == -1 else skeleton.get_bone_name(parent_idx)
		var indent = get_bone_depth(skeleton, i)
		
		print("%s[%d] %s (parent: %s)" % ["  ".repeat(indent), i, bone_name, parent_name])
	
	print("\n" + "=".repeat(60))
	print("BONE NAMING ANALYSIS")
	print("=".repeat(60))
	
	# Check naming convention
	var sample_bones = []
	for i in range(min(5, skeleton.get_bone_count())):
		sample_bones.append(skeleton.get_bone_name(i))
	
	print("Sample bone names: ", sample_bones)
	
	if sample_bones.size() > 0:
		if sample_bones[0].begins_with("mixamorig:"):
			print("\n✓ MIXAMO NAMING DETECTED (mixamorig: prefix)")
			print("  → BoneMap retargeting REQUIRED in Godot import settings")
		elif "Hips" in str(sample_bones) or "Spine" in str(sample_bones):
			print("\n✓ HUMANOID NAMING DETECTED (possible SkeletonProfileHumanoid compatible)")
			print("  → May need BoneMap verification")
		else:
			print("\n⚠ CUSTOM NAMING DETECTED")
			print("  → BoneMap creation required")
	
	print("\n" + "=".repeat(60))
	print("KEY BONES FOR SKELETONPROFILEHUMANOID")
	print("=".repeat(60))
	
	# Check for standard humanoid bones
	var required_bones = [
		"Hips", "Spine", "Chest", "UpperChest", "Neck", "Head",
		"LeftShoulder", "LeftUpperArm", "LeftLowerArm", "LeftHand",
		"RightShoulder", "RightUpperArm", "RightLowerArm", "RightHand",
		"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes",
		"RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"
	]
	
	var mixamo_bones = [
		"mixamorig:Hips", "mixamorig:Spine", "mixamorig:Spine1", "mixamorig:Spine2",
		"mixamorig:Neck", "mixamorig:Head",
		"mixamorig:LeftShoulder", "mixamorig:LeftArm", "mixamorig:LeftForeArm", "mixamorig:LeftHand",
		"mixamorig:RightShoulder", "mixamorig:RightArm", "mixamorig:RightForeArm", "mixamorig:RightHand",
		"mixamorig:LeftUpLeg", "mixamorig:LeftLeg", "mixamorig:LeftFoot", "mixamorig:LeftToeBase",
		"mixamorig:RightUpLeg", "mixamorig:RightLeg", "mixamorig:RightFoot", "mixamorig:RightToeBase"
	]
	
	print("\nChecking for standard bones:")
	var found_standard = 0
	for bone in required_bones:
		if skeleton.find_bone(bone) != -1:
			print("  ✓ ", bone)
			found_standard += 1
	
	print("\nChecking for Mixamo bones:")
	var found_mixamo = 0
	for bone in mixamo_bones:
		if skeleton.find_bone(bone) != -1:
			print("  ✓ ", bone)
			found_mixamo += 1
	
	if found_mixamo > 10:
		print("\n✓✓✓ MIXAMO SKELETON CONFIRMED")
		print("RECOMMENDATION: Use BoneMap retargeting with SkeletonProfileHumanoid")
	elif found_standard > 10:
		print("\n✓✓✓ STANDARD HUMANOID SKELETON CONFIRMED")
		print("RECOMMENDATION: May work directly, verify bone names match SkeletonProfileHumanoid")
	else:
		print("\n⚠⚠⚠ CUSTOM SKELETON")
		print("RECOMMENDATION: Create custom BoneMap asset")
	
	print("\n" + "=".repeat(60))
	print("INSPECTION COMPLETE")
	print("=".repeat(60))
	
	# Cleanup
	savage_instance.queue_free()

func find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var result = find_skeleton(child)
		if result != null:
			return result
	return null

func get_bone_depth(skeleton: Skeleton3D, bone_idx: int) -> int:
	var depth = 0
	var current = bone_idx
	while true:
		var parent = skeleton.get_bone_parent(current)
		if parent == -1:
			break
		depth += 1
		current = parent
	return depth

func print_node_tree(node: Node, depth: int):
	print("  ".repeat(depth), node.name, " (", node.get_class(), ")")
	for child in node.get_children():
		print_node_tree(child, depth + 1)
