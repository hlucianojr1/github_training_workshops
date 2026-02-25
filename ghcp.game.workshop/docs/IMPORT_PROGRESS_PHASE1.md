# Animation Import - Phase 1 Progress

**Date Started**: January 15, 2026  
**Phase**: Skeleton Verification & Mixamo Download  
**Status**: 🔄 IN PROGRESS

---

## Phase 1 Tasks (Steps 1-3)

### ✅ Step 0: Setup Complete
- [x] Created animation source directory: `game/assets/animations/player/source/`
- [x] Created skeleton inspection tool: `game/scripts/tools/inspect_savage_skeleton.gd`

### 🔄 Step 1: Verify savage.glb Skeleton Structure

**Status**: Ready for manual inspection

**Action Required**:
1. Open Godot editor (project.godot)
2. Run skeleton inspection tool:
   - Navigate to `game/scripts/tools/inspect_savage_skeleton.gd`
   - Click "File" → "Run" (or press Ctrl+Shift+X)
3. Review output in Output panel
4. Document findings below

**Expected Findings**:
- Bone count: ~65-70 bones (humanoid)
- Naming convention: Mixamo (`mixamorig:*`) or Standard (`Hips`, `Spine`, etc.)
- Key bones present: Hips, Spine, Chest, Head, arms, legs

**Skeleton Analysis Results**:
```
[Paste inspection tool output here after running]

Bone Count: [TBD]
Naming Convention: [Mixamo / Standard / Custom]
Root Bone: [TBD]
```

**BoneMap Asset Creation**:
- [ ] Create BoneMap asset: `res://assets/models/characters/savage_bonemap.tres`
- [ ] Configure in Godot:
  1. Right-click in FileSystem → "Create New" → "BoneMap"
  2. Set Profile: `SkeletonProfileHumanoid`
  3. Map bones (auto-detect if Mixamo, manual if custom)
  4. Save as `savage_bonemap.tres`

**BoneMap Configuration**:
```
Profile: SkeletonProfileHumanoid
Auto-detected mappings: [TBD / Manual]
```

---

### ⏳ Step 2: Download 16 Mixamo Animations

**Status**: Not started - awaiting manual download

**Mixamo.com Download Checklist**:

**Download Settings (use for ALL animations)**:
- Format: **FBX Binary (.fbx)**
- Skin: **Without Skin** (animation only, no mesh)
- Frame Rate: **30 FPS**
- Keyframe Reduction: **None**

#### Locomotion Animations (9)

| # | Mixamo Animation Name | Target File Name | Frames | Motion | Status |
|---|-----------------------|------------------|--------|--------|--------|
| ☐ 1 | "Idle" | `player_idle.fbx` | 60 | In Place | ⏳ Not downloaded |
| ☐ 2 | "Walking" | `player_walk_forward.fbx` | 30 | In Place | ⏳ Not downloaded |
| ☐ 3 | "Walking Backwards" | `player_walk_backward.fbx` | 30 | In Place | ⏳ Not downloaded |
| ☐ 4 | "Strafe Left" | `player_walk_left.fbx` | 30 | In Place | ⏳ Not downloaded |
| ☐ 5 | "Strafe Right" | `player_walk_right.fbx` | 30 | In Place | ⏳ Not downloaded |
| ☐ 6 | "Running" | `player_run_forward.fbx` | 20 | In Place | ⏳ Not downloaded |
| ☐ 7 | "Running Backwards" | `player_run_backward.fbx` | 24 | In Place | ⏳ Not downloaded |
| ☐ 8 | "Run Strafe Left" | `player_run_left.fbx` | 20 | In Place | ⏳ Not downloaded |
| ☐ 9 | "Run Strafe Right" | `player_run_right.fbx` | 20 | In Place | ⏳ Not downloaded |

#### Crouch Animations (2)

| # | Mixamo Animation Name | Target File Name | Frames | Motion | Status |
|---|-----------------------|------------------|--------|--------|--------|
| ☐ 10 | "Crouching Idle" | `player_crouch_idle.fbx` | 60 | In Place | ⏳ Not downloaded |
| ☐ 11 | "Crouch Walk" | `player_crouch_walk.fbx` | 40 | In Place | ⏳ Not downloaded |

#### Jump Animations (3)

| # | Mixamo Animation Name | Target File Name | Frames | Motion | Status |
|---|-----------------------|------------------|--------|--------|--------|
| ☐ 12 | "Jump Start" OR "Jumping Up" | `player_jump_start.fbx` | 10 | In Place | ⏳ Not downloaded |
| ☐ 13 | "Falling Idle" | `player_jump_loop.fbx` | 20 | In Place | ⏳ Not downloaded |
| ☐ 14 | "Hard Landing" | `player_jump_land.fbx` | 15 | In Place | ⏳ Not downloaded |

#### Combat Animations (2)

| # | Mixamo Animation Name | Target File Name | Frames | Motion | Status |
|---|-----------------------|------------------|--------|--------|--------|
| ☐ 15 | "Rifle Aiming Idle" | `player_aim_idle.fbx` | 60 | In Place | ⏳ Not downloaded |
| ☐ 16 | "Reloading" OR "Rifle Reload" | `player_reload.fbx` | 60 | In Place | ⏳ Not downloaded |

**Total**: 0/16 animations downloaded

**Download Location**: Save to temporary folder (e.g., `C:\Temp\mixamo_animations\`)

**Notes**:
- Mixamo may have multiple variations of each animation
- Choose animations that match 1960s character aesthetic (doesn't need to be perfect)
- "In Place" motion means character stays at origin (no root motion)
- Frame counts are approximate - Mixamo defaults are acceptable

---

### ⏳ Step 3: Import First Batch & Configure Retargeting

**Status**: Not started - depends on Step 2

**First Batch (5 animations)**:
1. player_idle.fbx
2. player_walk_forward.fbx
3. player_walk_backward.fbx
4. player_walk_left.fbx
5. player_walk_right.fbx

**Import Process**:

1. **Copy files to project**:
   ```powershell
   # From Windows PowerShell
   Copy-Item "C:\Temp\mixamo_animations\player_idle.fbx" "c:\code\cpp_game\game\assets\animations\player\source\"
   Copy-Item "C:\Temp\mixamo_animations\player_walk_forward.fbx" "c:\code\cpp_game\game\assets\animations\player\source\"
   Copy-Item "C:\Temp\mixamo_animations\player_walk_backward.fbx" "c:\code\cpp_game\game\assets\animations\player\source\"
   Copy-Item "C:\Temp\mixamo_animations\player_walk_left.fbx" "c:\code\cpp_game\game\assets\animations\player\source\"
   Copy-Item "C:\Temp\mixamo_animations\player_walk_right.fbx" "c:\code\cpp_game\game\assets\animations\player\source\"
   ```

2. **Configure Godot Import Settings** (for EACH FBX file):
   - Open Godot editor
   - Select FBX file in FileSystem panel
   - Go to Import tab (top panel)
   - Configure settings:

   ```
   [Animation]
   ✓ Import: ON
   FPS: 30
   ✓ Trimming: OFF
   ✓ Remove Immutable Tracks: ON
   
   [Skeleton3D]
   ☐ Retarget:
     ✓ Enable: ON
     BoneMap: [Select savage_bonemap.tres]
     ✓ Bone Renamer → Rename Bones: ON
     ✓ Rest Fixer → Overwrite Axis: ON  ← CRITICAL!
   ```

3. **Reimport**:
   - Click "Reimport" button
   - Wait for import to complete
   - Check for errors in Output panel

4. **Verify in Preview**:
   - Double-click FBX in FileSystem
   - In Scene Import preview, select Animation tab
   - Play animation
   - Check for:
     - ❌ Bone stretching/deformation
     - ❌ Inverted joints
     - ✓ Smooth natural movement

**Import Results**:

| FBX File | Import Status | Preview Status | Issues |
|----------|---------------|----------------|--------|
| player_idle.fbx | ⏳ Pending | ⏳ Pending | None |
| player_walk_forward.fbx | ⏳ Pending | ⏳ Pending | None |
| player_walk_backward.fbx | ⏳ Pending | ⏳ Pending | None |
| player_walk_left.fbx | ⏳ Pending | ⏳ Pending | None |
| player_walk_right.fbx | ⏳ Pending | ⏳ Pending | None |

---

## Issues Encountered

**Skeleton Analysis Issues**:
- None yet

**BoneMap Creation Issues**:
- None yet

**Mixamo Download Issues**:
- None yet

**Import/Retargeting Issues**:
- None yet

---

## Next Steps

After completing Phase 1:

1. **Verify all 5 animations import correctly**
2. **Create CHECKPOINT 1** (this document updated)
3. **Proceed to Phase 2**:
   - Import remaining 11 animations
   - Add reload markers
   - Setup AnimationTree

---

## Phase 1 Completion Criteria

- [x] Directory structure created
- [x] Skeleton inspection tool created
- [ ] savage.glb skeleton structure documented
- [ ] BoneMap asset created (`savage_bonemap.tres`)
- [ ] All 16 Mixamo animations downloaded
- [ ] First 5 animations imported with retargeting
- [ ] Import settings verified and working
- [ ] No bone deformation issues in preview

**Phase 1 Status**: 🔄 **In Progress** (2/8 tasks complete)

---

**Last Updated**: January 15, 2026  
**Next Checkpoint**: After Step 3 completion
