# Phase 1 Manual Instructions

**START HERE** - Follow these steps to complete Phase 1 of the animation import.

---

## 🎯 STEP 1: Inspect savage.glb Skeleton

### 1.1 Open Godot Editor

```powershell
# From PowerShell in c:\code\cpp_game
cd game
# Double-click project.godot in File Explorer, or run:
start project.godot
```

### 1.2 Run Skeleton Inspection Tool

1. In Godot, navigate to FileSystem panel (bottom-left)
2. Browse to: `scripts/tools/inspect_savage_skeleton.gd`
3. **Right-click** the file → **Open in Script Editor**
4. In Script Editor menu: **File** → **Run** (or press `Ctrl+Shift+X`)
5. Check **Output** panel (bottom) for results

### 1.3 Document Results

Copy the entire output from the Output panel and paste it into:
`docs/IMPORT_PROGRESS_PHASE1.md` under "Skeleton Analysis Results"

**Look for**:
- ✅ "MIXAMO NAMING DETECTED" → Proceed with Mixamo BoneMap
- ✅ "HUMANOID NAMING DETECTED" → May need less retargeting
- ⚠️ "CUSTOM NAMING" → Will need manual BoneMap creation

---

## 🎯 STEP 2: Create BoneMap Asset

### 2.1 Create BoneMap Resource

1. In Godot FileSystem panel, navigate to: `assets/models/characters/`
2. **Right-click** in the folder → **Create New** → **Resource**
3. In the search box, type: `BoneMap`
4. Select **BoneMap** and click **Create**
5. Name it: `savage_bonemap.tres`

### 2.2 Configure BoneMap

1. **Double-click** `savage_bonemap.tres` to open in Inspector
2. In Inspector panel (right):
   - Set **Profile**: `SkeletonProfileHumanoid`
   - Click **Auto-Map** button (if skeleton uses Mixamo naming)

### 2.3 Verify Bone Mappings

If auto-mapping worked, you should see green checkmarks for:
- ✅ Hips
- ✅ Spine
- ✅ Chest
- ✅ Head
- ✅ LeftUpperArm, LeftLowerArm, LeftHand
- ✅ RightUpperArm, RightLowerArm, RightHand
- ✅ LeftUpperLeg, LeftLowerLeg, LeftFoot
- ✅ RightUpperLeg, RightLowerLeg, RightFoot

**If auto-mapping failed** (Mixamo bones not detected):
1. Manually map each bone:
   - Click bone name in list
   - Select corresponding bone from savage.glb skeleton
2. Common Mixamo → Standard mappings:
   - `mixamorig:Hips` → Hips
   - `mixamorig:Spine` → Spine
   - `mixamorig:Spine1` → Chest
   - `mixamorig:Spine2` → UpperChest
   - `mixamorig:LeftArm` → LeftUpperArm
   - `mixamorig:LeftForeArm` → LeftLowerArm
   - (see docs/ART_GUIDELINES.md for full mapping table)

### 2.4 Save BoneMap

- Press `Ctrl+S` to save
- Close Inspector

---

## 🎯 STEP 3: Download Mixamo Animations

### 3.1 Create Download Folder

```powershell
# Create temporary folder for downloads
New-Item -Path "C:\Temp\mixamo_animations" -ItemType Directory -Force
```

### 3.2 Download from Mixamo.com

**For EACH animation** (16 total):

1. **Go to**: https://www.mixamo.com
2. **Sign in** with Adobe account (free)
3. **Search** for animation name (e.g., "Idle")
4. **Click** animation to preview
5. **Click "Download"** button
6. **Configure settings**:
   - Format: **FBX Binary (.fbx)**
   - Skin: **Without Skin** ← IMPORTANT!
   - Frame Rate: **30**
   - Keyframe Reduction: **none**
7. **Click Download**
8. **Rename file** to match target name (e.g., `player_idle.fbx`)
9. **Save to**: `C:\Temp\mixamo_animations\`

### 3.3 Animation Name Reference

Use this table to find Mixamo animations:

| Search Term | Mixamo Result | Save As |
|-------------|---------------|---------|
| "Idle" | Idle | player_idle.fbx |
| "Walking" | Walking | player_walk_forward.fbx |
| "Walking Backwards" | Walking Backwards | player_walk_backward.fbx |
| "Strafe Left" | Strafe Left | player_walk_left.fbx |
| "Strafe Right" | Strafe Right | player_walk_right.fbx |
| "Running" | Running | player_run_forward.fbx |
| "Running Backwards" | Running Backwards | player_run_backward.fbx |
| "Strafe Left" + filter "Run" | Run Strafe Left | player_run_left.fbx |
| "Strafe Right" + filter "Run" | Run Strafe Right | player_run_right.fbx |
| "Crouching Idle" | Crouching Idle | player_crouch_idle.fbx |
| "Crouch Walk" | Crouch Walk | player_crouch_walk.fbx |
| "Jump" | Jumping Up | player_jump_start.fbx |
| "Falling" | Falling Idle | player_jump_loop.fbx |
| "Landing" | Hard Landing | player_jump_land.fbx |
| "Rifle Aiming" | Rifle Aiming Idle | player_aim_idle.fbx |
| "Reload" | Reloading (rifle) | player_reload.fbx |

**Total downloads**: 16 FBX files (~50-80 MB total)

### 3.4 Verify Downloads

```powershell
# List downloaded files
Get-ChildItem "C:\Temp\mixamo_animations\" -Filter *.fbx | Select-Object Name, Length
```

Should show 16 .fbx files.

---

## 🎯 STEP 4: Import First Batch (5 animations)

### 4.1 Copy Files to Project

```powershell
# Copy first 5 animations
$sourceDir = "C:\Temp\mixamo_animations"
$destDir = "c:\code\cpp_game\game\assets\animations\player\source"

Copy-Item "$sourceDir\player_idle.fbx" $destDir
Copy-Item "$sourceDir\player_walk_forward.fbx" $destDir
Copy-Item "$sourceDir\player_walk_backward.fbx" $destDir
Copy-Item "$sourceDir\player_walk_left.fbx" $destDir
Copy-Item "$sourceDir\player_walk_right.fbx" $destDir

# Verify
Get-ChildItem $destDir -Filter *.fbx
```

### 4.2 Configure Import Settings in Godot

**For EACH of the 5 FBX files**:

1. In Godot FileSystem, navigate to: `assets/animations/player/source/`
2. **Click** on `player_idle.fbx` to select it
3. **Click** the **Import** tab (top-center panel)
4. Configure these settings:

   **Animation Section**:
   - ✅ Import: **ON**
   - FPS: **30**
   - ✅ Trimming: **OFF**
   - ✅ Remove Immutable Tracks: **ON**

   **Scroll down to Skeleton3D Section**:
   - Expand **Retarget** dropdown
   - ✅ Enable: **ON**
   - **BoneMap**: Click dropdown → Browse → Select `savage_bonemap.tres`
   - Expand **Bone Renamer** → ✅ **Rename Bones: ON**
   - Expand **Rest Fixer** → ✅ **Overwrite Axis: ON** ← **CRITICAL!**

5. **Click "Reimport"** button (bottom-right of Import panel)
6. **Wait** for import to finish (progress bar in bottom-right)
7. **Check Output panel** for errors (should say "Import successful")

**Repeat for all 5 files**:
- player_idle.fbx
- player_walk_forward.fbx
- player_walk_backward.fbx
- player_walk_left.fbx
- player_walk_right.fbx

### 4.3 Verify Animations in Preview

**For EACH imported FBX**:

1. **Double-click** the FBX file in FileSystem
2. **Scene Import** tab opens
3. Click **Animation** sub-tab
4. Select animation from list
5. **Click Play** button (▶)
6. **Watch for**:
   - ✅ Smooth natural movement
   - ❌ NO bone stretching (arms/legs too long)
   - ❌ NO inverted joints (elbows/knees backward)
   - ❌ NO T-pose flickering

**If you see issues**:
- Check BoneMap is correctly assigned
- Verify "Overwrite Axis" is ON
- Check Output panel for warnings

---

## ✅ Phase 1 Complete!

After completing all steps:

1. **Update** `docs/IMPORT_PROGRESS_PHASE1.md`:
   - Mark all checkboxes as complete
   - Paste skeleton inspection output
   - Note any issues encountered

2. **Verify checklist**:
   - [x] savage.glb skeleton analyzed
   - [x] savage_bonemap.tres created
   - [x] 16 Mixamo animations downloaded to C:\Temp\
   - [x] First 5 animations copied to project
   - [x] Import settings configured with BoneMap retargeting
   - [x] All 5 animations preview correctly (no deformation)

3. **Ready for Phase 2!**

---

## 🆘 Troubleshooting

### Skeleton inspection tool doesn't run
- Make sure you're running from **Script Editor**, not double-clicking
- Check Output panel for errors
- File → Run (or Ctrl+Shift+X)

### BoneMap auto-mapping doesn't work
- Manually map bones using the table in docs/ART_GUIDELINES.md
- Check that savage.glb actually has Mixamo bones (should start with `mixamorig:`)

### Mixamo download stuck
- Try different browser
- Check internet connection
- Adobe account may need verification

### Animations look broken after import
- **Most common**: "Overwrite Axis" not enabled → Re-import with it ON
- Check BoneMap is correctly assigned
- Verify FBX was downloaded "Without Skin"
- Check frame rate is 30 FPS

### Files not appearing in Godot
- Click FileSystem panel → Right-click → "Scan" or "Reimport"
- Close and reopen Godot editor

---

**When complete, ask AI assistant to proceed to Phase 2**
