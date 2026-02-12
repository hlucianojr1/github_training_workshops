"""
Create Placeholder Player Character for Urban Survivor
Run this script in Blender to create a basic humanoid placeholder.
Height: 1.75m, Male proportions

Usage: 
  - Open Blender
  - Go to Scripting tab
  - Open this file and run it
  - Export via File > Export > glTF 2.0
"""

import bpy
import math

# Configuration
HEIGHT = 1.75
NAME = "char_player_male"
SKIN_COLOR = (0.77, 0.64, 0.52, 1.0)  # #C4A484

# Clear existing objects
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Create skin material
skin_mat = bpy.data.materials.new(name="Skin")
skin_mat.use_nodes = True
bsdf = skin_mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs["Base Color"].default_value = SKIN_COLOR
bsdf.inputs["Roughness"].default_value = 0.7

# Clothing material (1960s style - olive/brown work clothes)
clothes_mat = bpy.data.materials.new(name="Clothes")
clothes_mat.use_nodes = True
bsdf = clothes_mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs["Base Color"].default_value = (0.33, 0.29, 0.22, 1.0)  # Olive brown
bsdf.inputs["Roughness"].default_value = 0.8

# Pants material
pants_mat = bpy.data.materials.new(name="Pants")
pants_mat.use_nodes = True
bsdf = pants_mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs["Base Color"].default_value = (0.15, 0.15, 0.18, 1.0)  # Dark gray
bsdf.inputs["Roughness"].default_value = 0.75

# Boot material
boot_mat = bpy.data.materials.new(name="Boots")
boot_mat.use_nodes = True
bsdf = boot_mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs["Base Color"].default_value = (0.12, 0.08, 0.05, 1.0)  # Dark brown leather
bsdf.inputs["Roughness"].default_value = 0.6

def create_part(prim_type, name, location, scale, material, rotation=(0, 0, 0)):
    """Create a body part primitive with material"""
    if prim_type == "sphere":
        bpy.ops.mesh.primitive_uv_sphere_add(segments=16, ring_count=8, location=location)
    elif prim_type == "cube":
        bpy.ops.mesh.primitive_cube_add(location=location)
    elif prim_type == "cylinder":
        bpy.ops.mesh.primitive_cylinder_add(vertices=12, location=location)
    
    obj = bpy.context.active_object
    obj.name = name
    obj.scale = scale
    obj.rotation_euler = rotation
    
    # Apply material
    if obj.data.materials:
        obj.data.materials[0] = material
    else:
        obj.data.materials.append(material)
    
    return obj

# Scale factor based on height
sf = HEIGHT / 1.75

# === HEAD ===
head = create_part("sphere", "Head", (0, 0, 1.62 * sf), (0.11 * sf, 0.13 * sf, 0.14 * sf), skin_mat)

# === NECK ===
neck = create_part("cylinder", "Neck", (0, 0, 1.48 * sf), (0.05 * sf, 0.05 * sf, 0.06 * sf), skin_mat)

# === TORSO (with clothing) ===
torso = create_part("cube", "Torso", (0, 0, 1.2 * sf), (0.22 * sf, 0.12 * sf, 0.28 * sf), clothes_mat)

# === HIPS ===
hips = create_part("cube", "Hips", (0, 0, 0.88 * sf), (0.18 * sf, 0.10 * sf, 0.10 * sf), pants_mat)

# === ARMS ===
# Upper arms
arm_l_upper = create_part("cylinder", "Arm_L_Upper", (-0.30 * sf, 0, 1.28 * sf), 
                          (0.045 * sf, 0.045 * sf, 0.15 * sf), clothes_mat, (0, 0.2, 0))
arm_r_upper = create_part("cylinder", "Arm_R_Upper", (0.30 * sf, 0, 1.28 * sf), 
                          (0.045 * sf, 0.045 * sf, 0.15 * sf), clothes_mat, (0, -0.2, 0))

# Lower arms (skin visible - rolled up sleeves)
arm_l_lower = create_part("cylinder", "Arm_L_Lower", (-0.34 * sf, 0, 1.02 * sf), 
                          (0.038 * sf, 0.038 * sf, 0.13 * sf), skin_mat, (0, 0.1, 0))
arm_r_lower = create_part("cylinder", "Arm_R_Lower", (0.34 * sf, 0, 1.02 * sf), 
                          (0.038 * sf, 0.038 * sf, 0.13 * sf), skin_mat, (0, -0.1, 0))

# Hands
hand_l = create_part("sphere", "Hand_L", (-0.36 * sf, 0, 0.86 * sf), 
                     (0.04 * sf, 0.025 * sf, 0.05 * sf), skin_mat)
hand_r = create_part("sphere", "Hand_R", (0.36 * sf, 0, 0.86 * sf), 
                     (0.04 * sf, 0.025 * sf, 0.05 * sf), skin_mat)

# === LEGS ===
# Upper legs
leg_l_upper = create_part("cylinder", "Leg_L_Upper", (-0.09 * sf, 0, 0.65 * sf), 
                          (0.065 * sf, 0.065 * sf, 0.18 * sf), pants_mat)
leg_r_upper = create_part("cylinder", "Leg_R_Upper", (0.09 * sf, 0, 0.65 * sf), 
                          (0.065 * sf, 0.065 * sf, 0.18 * sf), pants_mat)

# Lower legs
leg_l_lower = create_part("cylinder", "Leg_L_Lower", (-0.09 * sf, 0, 0.32 * sf), 
                          (0.05 * sf, 0.05 * sf, 0.18 * sf), pants_mat)
leg_r_lower = create_part("cylinder", "Leg_R_Lower", (0.09 * sf, 0, 0.32 * sf), 
                          (0.05 * sf, 0.05 * sf, 0.18 * sf), pants_mat)

# === FEET/BOOTS ===
foot_l = create_part("cube", "Foot_L", (-0.09 * sf, 0.04 * sf, 0.06 * sf), 
                     (0.05 * sf, 0.10 * sf, 0.04 * sf), boot_mat)
foot_r = create_part("cube", "Foot_R", (0.09 * sf, 0.04 * sf, 0.06 * sf), 
                     (0.05 * sf, 0.10 * sf, 0.04 * sf), boot_mat)

# === PARENT ALL TO EMPTY ===
bpy.ops.object.empty_add(type='PLAIN_AXES', location=(0, 0, 0))
root = bpy.context.active_object
root.name = NAME

# Parent all parts to root
for obj in bpy.data.objects:
    if obj != root and obj.type == 'MESH':
        obj.parent = root

# Select root
bpy.ops.object.select_all(action='DESELECT')
root.select_set(True)
bpy.context.view_layer.objects.active = root

print(f"✓ Created player placeholder: {NAME}")
print(f"  Height: {HEIGHT}m")
print(f"  Parts: {len([o for o in bpy.data.objects if o.type == 'MESH'])}")
print(f"\nExport path: game/assets/models/characters/{NAME}_lod0.gltf")
