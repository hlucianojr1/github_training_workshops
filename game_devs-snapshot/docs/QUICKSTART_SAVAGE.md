# 🎮 Savage Character - Quick Start Guide

## ✅ Setup Complete!

The savage character has been integrated into the Urban Survivor player system.

---

## 🚀 Test It Now (3 Steps)

### 1️⃣ Rebuild C++ Extension (macOS)

```bash
cd /Users/hluciano/projects/cpp_game
cmake --build build --config Debug
```

**Expected output**: Successful build of liburban_survivor extension

---

### 2️⃣ Open Godot Editor

1. Launch **Godot 4.3**
2. Open project: `/Users/hluciano/projects/cpp_game/game/project.godot`
3. **Wait** for savage.glb to import (check bottom-right progress bar)

---

### 3️⃣ Run the Game

1. Press **F5** (or click Play button)
2. Game loads Level 1
3. You spawn as the savage character!

---

## 🎯 Controls

| Action | Key |
|--------|-----|
| **Move** | W A S D |
| **Look** | Mouse |
| **Sprint** | Shift |
| **Jump** | Space |
| **Crouch** | Ctrl |
| **Aim** | Right Click |
| **Shoot** | Left Click |
| **Reload** | R |
| **Interact** | E |

---

## 🔍 What to Expect

### Camera Behavior
- **Third-person view** behind right shoulder
- Camera follows smoothly as you move
- **Zoom in** when aiming (Right Click)
- Camera **avoids walls** (spring arm collision)

### Movement
- Walk with WASD
- Sprint makes you move faster
- Jump with Space (only when on ground)
- Crouch makes you shorter and slower

### Visual
- Savage character model visible
- Arms/weapon visible in view
- Camera positioned 3.5m behind, 1.5m above

---

## 📁 What Was Changed

### Modified
- `game/scenes/player.tscn` - Now uses savage.glb

### New Scene Structure
```
Player (PlayerController C++)
├── CollisionShape3D (physics capsule)
├── SavageModel (your character!)
├── ThirdPersonCamera (C++ camera)
│   └── Camera3D (actual camera)
├── SurvivalStats
├── Inventory
└── Weapon (M1911)
```

---

## ⚠️ Troubleshooting

### "Class not found" errors
**Solution**: Rebuild C++ extension
```bash
cmake --build build --config Debug
```
Then restart Godot

### Model not visible
**Solution**: 
1. Check FileSystem panel for `savage.glb`
2. If not imported, right-click → Reimport
3. Wait for import to complete

### Camera not following
**Solution**: Verify player has "player" group
1. Select Player node in scene tree
2. Check Node panel → Groups
3. Should have "player" group listed

### Physics not working
**Solution**: Check collision shape
1. Open player.tscn
2. Select CollisionShape3D
3. Ensure shape is set to CapsuleShape3D

---

## 📊 Verification

Run the verification script:
```bash
cd /Users/hluciano/projects/cpp_game
./verify_integration.sh
```

Should show all ✓ checks passed.

---

## 📖 More Info

- **Detailed Guide**: See `SAVAGE_CHARACTER_INTEGRATION.md`
- **Summary**: See `INTEGRATION_SUMMARY.md`
- **Architecture**: See `docs/ARCHITECTURE.md`

---

## 🎉 Success Criteria

When you press F5, you should see:
- ✅ Savage character model visible
- ✅ Camera behind and above character
- ✅ WASD movement works
- ✅ Mouse look rotates camera/player
- ✅ No errors in Output panel

**If all ✅ then congratulations - integration successful!**

---

*Last Updated: January 6, 2026*
*Urban Survivor - Godot 4.3 + C++ GDExtension*
