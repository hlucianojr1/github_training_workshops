"""
Humanoid Base Mesh Generator for Urban Survivor
Creates a game-ready humanoid mesh with proper topology for animation.

Usage via Blender MCP:
{
  "tool": "execute_python_script",
  "script": "exec(open('game/assets/blender_scripts/templates/humanoid_base_mesh.py').read())"
}

Or with parameters:
{
  "tool": "execute_python_script", 
  "script": "HEIGHT=1.75; GENDER='male'; exec(open('...').read())"
}
"""

import bpy
import bmesh
from mathutils import Vector
import math

# Parameters (can be overridden before exec)
HEIGHT = globals().get('HEIGHT', 1.75)  # Total height in meters
GENDER = globals().get('GENDER', 'male')  # 'male' or 'female'
SUBDIVISIONS = globals().get('SUBDIVISIONS', 1)  # 0=low, 1=medium, 2=high
NAME = globals().get('NAME', 'Humanoid_Base')

# Proportions based on gender
if GENDER == 'male':
    SHOULDER_WIDTH = 0.45
    HIP_WIDTH = 0.35
    CHEST_DEPTH = 0.25
    HEAD_SCALE = 1.0
else:
    SHOULDER_WIDTH = 0.40
    HIP_WIDTH = 0.38
    CHEST_DEPTH = 0.22
    HEAD_SCALE = 0.95

# Body segment heights (as fraction of total height)
HEAD_HEIGHT = 0.12
NECK_HEIGHT = 0.03
TORSO_HEIGHT = 0.30
HIP_HEIGHT = 0.08
THIGH_HEIGHT = 0.22
SHIN_HEIGHT = 0.20
FOOT_HEIGHT = 0.05

# Calculate absolute positions
FLOOR = 0.0
ANKLE = FLOOR + FOOT_HEIGHT * HEIGHT
KNEE = ANKLE + SHIN_HEIGHT * HEIGHT
HIP_Y = KNEE + THIGH_HEIGHT * HEIGHT
WAIST = HIP_Y + HIP_HEIGHT * HEIGHT
SHOULDER = WAIST + TORSO_HEIGHT * HEIGHT
NECK_BASE = SHOULDER + NECK_HEIGHT * HEIGHT
HEAD_TOP = NECK_BASE + HEAD_HEIGHT * HEIGHT


def create_humanoid_mesh():
    """Create a humanoid mesh with proper edge loops for animation."""
    
    # Clear existing mesh objects only
    bpy.ops.object.select_all(action='DESELECT')
    for obj in bpy.data.objects:
        if obj.type == 'MESH':
            obj.select_set(True)
    bpy.ops.object.delete()
    
    # Create new mesh
    mesh = bpy.data.meshes.new(NAME)
    obj = bpy.data.objects.new(NAME, mesh)
    bpy.context.collection.objects.link(obj)
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)
    
    bm = bmesh.new()
    
    # Create torso cross-sections
    torso_sections = []
    
    # Hips
    hip_verts = create_oval_ring(bm, HIP_WIDTH/2, CHEST_DEPTH/2, HIP_Y, 8)
    torso_sections.append(hip_verts)
    
    # Waist
    waist_verts = create_oval_ring(bm, HIP_WIDTH/2 * 0.9, CHEST_DEPTH/2 * 0.85, WAIST, 8)
    torso_sections.append(waist_verts)
    
    # Chest
    chest_y = WAIST + (SHOULDER - WAIST) * 0.6
    chest_verts = create_oval_ring(bm, SHOULDER_WIDTH/2 * 0.9, CHEST_DEPTH/2, chest_y, 8)
    torso_sections.append(chest_verts)
    
    # Shoulders
    shoulder_verts = create_oval_ring(bm, SHOULDER_WIDTH/2, CHEST_DEPTH/2 * 0.9, SHOULDER, 8)
    torso_sections.append(shoulder_verts)
    
    # Connect torso sections
    for i in range(len(torso_sections) - 1):
        bridge_rings(bm, torso_sections[i], torso_sections[i + 1])
    
    # Cap bottom (hips)
    bmesh.ops.contextual_create(bm, geom=hip_verts)
    
    # Create neck
    neck_bottom = create_oval_ring(bm, 0.06, 0.05, SHOULDER, 6)
    neck_top = create_oval_ring(bm, 0.055, 0.045, NECK_BASE, 6)
    bridge_rings(bm, neck_bottom, neck_top)
    
    # Create head (simplified sphere)
    head_center = NECK_BASE + (HEAD_TOP - NECK_BASE) / 2
    head_radius = (HEAD_TOP - NECK_BASE) / 2 * HEAD_SCALE
    
    # Manual head creation (sphere segments)
    head_rings = []
    head_segments = 6
    for j in range(head_segments + 1):
        phi = math.pi * j / head_segments
        ring_radius = math.sin(phi) * head_radius
        ring_z = head_center + math.cos(phi) * head_radius
        if ring_radius > 0.01:
            ring = create_oval_ring(bm, ring_radius, ring_radius, ring_z, 8)
            head_rings.append(ring)
    
    for i in range(len(head_rings) - 1):
        bridge_rings(bm, head_rings[i], head_rings[i + 1])
    
    # Create arms
    for side in [-1, 1]:  # Left and right
        create_arm(bm, side, SHOULDER)
    
    # Create legs  
    for side in [-1, 1]:
        create_leg(bm, side, HIP_Y)
    
    # Finalize
    bm.to_mesh(mesh)
    bm.free()
    
    # Recalculate normals
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.mesh.normals_make_consistent(inside=False)
    bpy.ops.object.mode_set(mode='OBJECT')
    
    # Add subdivision if requested
    if SUBDIVISIONS > 0:
        mod = obj.modifiers.new('Subsurf', 'SUBSURF')
        mod.levels = SUBDIVISIONS
        mod.render_levels = SUBDIVISIONS + 1
    
    # Set origin to bottom center
    bpy.context.scene.cursor.location = (0, 0, 0)
    bpy.ops.object.origin_set(type='ORIGIN_CURSOR')
    
    return obj


def create_oval_ring(bm, width, depth, height, segments):
    """Create an oval ring of vertices at given height."""
    verts = []
    for i in range(segments):
        angle = 2 * math.pi * i / segments
        x = math.cos(angle) * width
        y = math.sin(angle) * depth
        v = bm.verts.new((x, y, height))
        verts.append(v)
    return verts


def bridge_rings(bm, ring1, ring2):
    """Connect two rings of vertices with quad faces."""
    n = min(len(ring1), len(ring2))
    for i in range(n):
        v1 = ring1[i % len(ring1)]
        v2 = ring1[(i + 1) % len(ring1)]
        v3 = ring2[(i + 1) % len(ring2)]
        v4 = ring2[i % len(ring2)]
        try:
            bm.faces.new([v1, v2, v3, v4])
        except ValueError:
            pass  # Face already exists


def create_arm(bm, side, shoulder_height):
    """Create an arm with proper edge loops."""
    shoulder_x = side * SHOULDER_WIDTH / 2
    
    # Upper arm
    upper_arm_length = 0.30 * HEIGHT
    elbow_x = shoulder_x + side * upper_arm_length * 0.9
    elbow_z = shoulder_height - upper_arm_length * 0.4
    
    arm_radius = 0.04
    segments = 6
    
    # Shoulder ring
    shoulder_ring = []
    for i in range(segments):
        angle = 2 * math.pi * i / segments
        x = shoulder_x + math.cos(angle) * arm_radius
        y = math.sin(angle) * arm_radius
        v = bm.verts.new((x, y, shoulder_height))
        shoulder_ring.append(v)
    
    # Elbow ring
    elbow_ring = []
    for i in range(segments):
        angle = 2 * math.pi * i / segments
        x = elbow_x + math.cos(angle) * arm_radius * 0.9
        y = math.sin(angle) * arm_radius * 0.9
        v = bm.verts.new((x, y, elbow_z))
        elbow_ring.append(v)
    
    bridge_rings(bm, shoulder_ring, elbow_ring)
    
    # Forearm
    forearm_length = 0.25 * HEIGHT
    wrist_x = elbow_x + side * forearm_length * 0.8
    wrist_z = elbow_z - forearm_length * 0.3
    
    wrist_ring = []
    for i in range(segments):
        angle = 2 * math.pi * i / segments
        x = wrist_x + math.cos(angle) * arm_radius * 0.7
        y = math.sin(angle) * arm_radius * 0.7
        v = bm.verts.new((x, y, wrist_z))
        wrist_ring.append(v)
    
    bridge_rings(bm, elbow_ring, wrist_ring)
    
    # Cap wrist
    bmesh.ops.contextual_create(bm, geom=wrist_ring)


def create_leg(bm, side, hip_height):
    """Create a leg with proper edge loops."""
    hip_x = side * HIP_WIDTH / 4
    
    leg_radius = 0.07
    segments = 6
    
    # Hip ring
    hip_ring = []
    for i in range(segments):
        angle = 2 * math.pi * i / segments
        x = hip_x + math.cos(angle) * leg_radius
        y = math.sin(angle) * leg_radius
        v = bm.verts.new((x, y, hip_height))
        hip_ring.append(v)
    
    # Knee ring
    knee_ring = []
    for i in range(segments):
        angle = 2 * math.pi * i / segments
        x = hip_x + math.cos(angle) * leg_radius * 0.85
        y = math.sin(angle) * leg_radius * 0.85
        v = bm.verts.new((x, y, KNEE))
        knee_ring.append(v)
    
    bridge_rings(bm, hip_ring, knee_ring)
    
    # Ankle ring
    ankle_ring = []
    for i in range(segments):
        angle = 2 * math.pi * i / segments
        x = hip_x + math.cos(angle) * leg_radius * 0.6
        y = math.sin(angle) * leg_radius * 0.6
        v = bm.verts.new((x, y, ANKLE))
        ankle_ring.append(v)
    
    bridge_rings(bm, knee_ring, ankle_ring)
    
    # Simple foot
    foot_verts = [
        bm.verts.new((hip_x - 0.05, -0.08, FLOOR)),
        bm.verts.new((hip_x + 0.05, -0.08, FLOOR)),
        bm.verts.new((hip_x + 0.05, 0.12, FLOOR)),
        bm.verts.new((hip_x - 0.05, 0.12, FLOOR)),
    ]
    bm.faces.new(foot_verts)


# Execute when run
if __name__ == "__main__":
    create_humanoid_mesh()
    print(f"Created humanoid mesh: {NAME}, Height: {HEIGHT}m, Gender: {GENDER}")
else:
    # When executed via exec()
    create_humanoid_mesh()
    print(f"Created humanoid mesh: {NAME}, Height: {HEIGHT}m, Gender: {GENDER}")
