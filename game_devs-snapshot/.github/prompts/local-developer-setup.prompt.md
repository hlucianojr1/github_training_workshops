---
mode: agent
description: Complete local development environment setup and troubleshooting for Urban Survivor (Godot 4.3+ GDExtension with C++)
---

# 🚀 Urban Survivor - Local Developer Setup Assistant

---

## 📖 How to Use This Prompt

### Quick Start (VS Code with GitHub Copilot)

1. **Open VS Code** in the `cpp_game` project folder
2. **Open Copilot Chat** (`Cmd+Shift+I` on macOS / `Ctrl+Shift+I` on Windows/Linux)
3. **Type one of these shortcut phrases:**

| Shortcut Phrase | What It Does |
|-----------------|--------------|
| `@workspace /local-developer-setup` | Full guided setup |
| `setup my dev environment` | Start from scratch |
| `verify my dev setup` | Check if everything is installed |
| `fix my build errors` | Troubleshoot compilation issues |
| `rebuild from clean` | Clean and rebuild everything |

### Alternative: Direct Prompt File Reference

```
@workspace #file:.github/prompts/local-developer-setup.prompt.md help me set up my development environment
```

### Shortcut Phrases for Common Tasks

| Say This... | To Do This... |
|-------------|---------------|
| `"setup dev"` | Complete environment setup from scratch |
| `"verify setup"` | Run environment verification checks |
| `"fix godot-cpp"` | Troubleshoot godot-cpp build issues |
| `"fix cmake"` | Troubleshoot CMake configuration |
| `"fix linker"` | Troubleshoot linker/undefined reference errors |
| `"rebuild all"` | Clean rebuild of godot-cpp + game extension |
| `"quick rebuild"` | Fast rebuild of just the game extension |

---

## 🤖 Agent Instructions

You are an expert development environment setup assistant. Your task is to guide new developers through setting up their local machine to build and run the Urban Survivor game project—a third-person survival shooter built with **Godot 4.3+ GDExtension** and **C++17**.

## 🎯 Objective

Help the developer achieve a **fully working local development environment** where they can:
1. Clone and initialize the repository
2. Build the C++ GDExtension library
3. Run the game in Godot Editor
4. Iterate on code changes efficiently

---

## 📋 Pre-Setup: System Detection

**First, detect the developer's operating system and architecture:**

```bash
# Run these commands to gather system info
uname -s        # OS (Darwin=macOS, Linux, MINGW/MSYS=Windows)
uname -m        # Architecture (arm64, x86_64)
echo $SHELL     # Shell type
```

Based on the results, tailor all subsequent instructions.

---

## ✅ Step 1: Verify Prerequisites

### 1.1 Required Software Checklist

Check each tool is installed and meets version requirements:

| Tool | Minimum Version | Check Command | Install Guide |
|------|----------------|---------------|---------------|
| **Git** | 2.30+ | `git --version` | See below |
| **CMake** | 3.20+ | `cmake --version` | See below |
| **C++ Compiler** | C++17 support | See below | See below |
| **SCons** | 4.0+ | `scons --version` | `pip install scons` |
| **Python** | 3.8+ | `python3 --version` | Required for SCons |
| **Godot Engine** | 4.3+ | Check app version | https://godotengine.org/download |

### 1.2 Platform-Specific Compiler Verification

**macOS:**
```bash
# Check Xcode Command Line Tools
xcode-select -p
# If not installed:
xcode-select --install

# Verify clang version (needs C++17 support)
clang++ --version
# Expect: Apple clang version 12+ (Xcode 10+)
```

**Linux (Ubuntu/Debian):**
```bash
# Check GCC version
g++ --version
# Needs GCC 7+ for C++17

# Install if missing:
sudo apt update
sudo apt install build-essential cmake git python3 python3-pip
pip3 install scons
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install gcc-c++ cmake git python3 python3-pip
pip3 install scons
```

**Windows:**
```powershell
# Option A: Visual Studio 2019+ with C++ workload
# Option B: MinGW-w64 with GCC 7+

# Check compiler:
cl.exe    # MSVC
g++ --version   # MinGW
```

### 1.3 Installation Commands (if missing)

**macOS (Homebrew):**
```bash
# Install Homebrew if needed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install cmake git python3
pip3 install scons

# Godot: Download from https://godotengine.org/download/macos/
# Or use: brew install --cask godot
```

**Windows (Chocolatey):**
```powershell
# Install Chocolatey (Run as Admin)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install dependencies
choco install cmake git python visualstudio2022-workload-nativedesktop
pip install scons
```

---

## ✅ Step 2: Repository Setup

### 2.1 Clone the Repository

```bash
# Clone with submodules (recommended)
git clone --recursive https://github.com/hlucianojr1/cpp_game.git
cd cpp_game

# OR if already cloned without submodules:
git submodule update --init --recursive
```

### 2.2 Verify Submodules

```bash
# Check godot-cpp exists
ls -la external/godot-cpp/

# Should see CMakeLists.txt, SConstruct, include/, src/, etc.
# If empty, run:
git submodule update --init --recursive
```

---

## ✅ Step 3: Build godot-cpp Bindings

This step compiles the Godot C++ bindings library. This only needs to be done once (or when updating Godot versions).

### 3.1 Build Commands

**macOS (Apple Silicon - arm64):**
```bash
cd external/godot-cpp
scons platform=macos arch=arm64 target=template_debug -j$(sysctl -n hw.ncpu)
scons platform=macos arch=arm64 target=template_release -j$(sysctl -n hw.ncpu)
cd ../..
```

**macOS (Intel - x86_64):**
```bash
cd external/godot-cpp
scons platform=macos arch=x86_64 target=template_debug -j$(sysctl -n hw.ncpu)
scons platform=macos arch=x86_64 target=template_release -j$(sysctl -n hw.ncpu)
cd ../..
```

**Linux:**
```bash
cd external/godot-cpp
scons platform=linux target=template_debug -j$(nproc)
scons platform=linux target=template_release -j$(nproc)
cd ../..
```

**Windows (PowerShell):**
```powershell
cd external\godot-cpp
scons platform=windows target=template_debug
scons platform=windows target=template_release
cd ..\..
```

### 3.2 Verify godot-cpp Build

```bash
# Check for compiled libraries
ls -la external/godot-cpp/bin/

# Expected files (example for macOS arm64):
# libgodot-cpp.macos.template_debug.arm64.a
# libgodot-cpp.macos.template_release.arm64.a
```

---

## ✅ Step 4: Build the Game Extension

### 4.1 Configure and Build

**macOS/Linux:**
```bash
# Create build directory
mkdir -p build && cd build

# Configure (Debug build)
cmake -DCMAKE_BUILD_TYPE=Debug ..

# Build (use all cores)
make -j$(sysctl -n hw.ncpu 2>/dev/null || nproc)

# Return to project root
cd ..
```

**Windows (PowerShell):**
```powershell
mkdir -Force build
cd build
cmake ..
cmake --build . --config Debug
cd ..
```

### 4.2 Verify Build Output

```bash
# Check the compiled library was copied to Godot project
ls -la game/bin/

# Expected output (varies by platform):
# macOS arm64: liburban_survivor.macos.debug.arm64.dylib
# macOS x86:   liburban_survivor.macos.debug.x86_64.dylib
# Linux:       liburban_survivor.linux.debug.x86_64.so
# Windows:     liburban_survivor.windows.debug.x86_64.dll
```

---

## ✅ Step 5: Run the Game

### 5.1 Open in Godot Editor

1. **Launch Godot 4.3+**
2. Click **"Import"**
3. Navigate to: `<project_root>/game/`
4. Select `project.godot`
5. Click **"Import & Edit"**

### 5.2 First-Time Import

- Godot will scan and import all assets (may take 1-2 minutes)
- Watch the progress bar in bottom-right corner
- Wait for "Import" progress to complete

### 5.3 Run the Game

- Press **F5** or click the **Play** button
- Game should load and you can control the character with WASD + Mouse

---

## 🔧 Quick Build Script (One-Liner)

For rapid iteration, use the provided build script:

```bash
# macOS/Linux - Full build and run
./build_and_run.sh

# Or just rebuild C++ (faster iteration)
cd build && make -j$(sysctl -n hw.ncpu 2>/dev/null || nproc) && cd ..
```

---

## 🐛 Troubleshooting Guide

### Problem: "godot-cpp not found"

**Symptom:**
```
CMake Error: godot-cpp not found. Run: git submodule update --init --recursive
```

**Solution:**
```bash
git submodule update --init --recursive
# Verify:
ls external/godot-cpp/CMakeLists.txt
```

---

### Problem: SCons build fails

**Symptom:** Errors during `scons platform=...` command

**Solutions:**

1. **Python/SCons not found:**
   ```bash
   pip3 install scons
   # Or on some systems:
   python3 -m pip install scons
   ```

2. **Wrong architecture:**
   ```bash
   # Check your Mac's architecture
   uname -m
   # Use matching arch flag: arch=arm64 or arch=x86_64
   ```

3. **Permission denied:**
   ```bash
   chmod +x external/godot-cpp/SConstruct
   ```

---

### Problem: CMake configuration fails

**Symptom:** CMake errors about missing compiler or wrong version

**Solutions:**

1. **Compiler not found (macOS):**
   ```bash
   xcode-select --install
   ```

2. **Wrong CMake version:**
   ```bash
   cmake --version
   # If < 3.20, upgrade:
   brew upgrade cmake  # macOS
   ```

3. **Clear CMake cache:**
   ```bash
   rm -rf build/
   mkdir build && cd build
   cmake ..
   ```

---

### Problem: Linker errors during build

**Symptom:** Undefined references to godot-cpp symbols

**Solutions:**

1. **Rebuild godot-cpp for correct target:**
   ```bash
   cd external/godot-cpp
   # Clean and rebuild
   scons -c
   scons platform=macos arch=arm64 target=template_debug
   cd ../..
   # Clean and rebuild game
   rm -rf build/
   mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && make
   ```

2. **Architecture mismatch:** Ensure godot-cpp arch matches your system

---

### Problem: "Can't load extension" in Godot

**Symptom:** Error when opening project or running game

**Solutions:**

1. **Library file missing:**
   ```bash
   ls game/bin/
   # If empty, rebuild the project
   ```

2. **Wrong library name:** Check `game/urban_survivor.gdextension` matches your build output

3. **Godot version mismatch:** Ensure Godot 4.3+ (godot-cpp 4.3 branch)

---

### Problem: "Class not found" errors

**Symptom:** `PlayerController`, `ThirdPersonCamera`, etc. not found

**Solutions:**

1. **Extension not loaded:** Check Godot Output panel for loading errors
2. **Rebuild extension:**
   ```bash
   cd build && make && cd ..
   ```
3. **Restart Godot Editor** (required after C++ changes)

---

### Problem: Game crashes on startup

**Symptom:** Immediate crash when pressing Play

**Solutions:**

1. **Check Godot Output panel** for error messages
2. **Use Debug build** for better error info:
   ```bash
   cmake -DCMAKE_BUILD_TYPE=Debug ..
   make
   ```
3. **Verify scene structure** matches expected node types

---

## 📊 Environment Verification Script

Run this script to verify your setup:

```bash
#!/bin/bash
echo "=== Urban Survivor Environment Check ==="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1: $(command -v $1)"
        return 0
    else
        echo -e "${RED}✗${NC} $1: NOT FOUND"
        return 1
    fi
}

check_version() {
    echo -e "${YELLOW}  Version:${NC} $($1 2>&1 | head -1)"
}

echo ""
echo "1. Checking required tools..."
check_command git && check_version "git --version"
check_command cmake && check_version "cmake --version"
check_command python3 && check_version "python3 --version"
check_command scons && check_version "scons --version"

echo ""
echo "2. Checking C++ compiler..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    check_command clang++ && check_version "clang++ --version"
else
    check_command g++ && check_version "g++ --version"
fi

echo ""
echo "3. Checking godot-cpp submodule..."
if [ -f "external/godot-cpp/CMakeLists.txt" ]; then
    echo -e "${GREEN}✓${NC} godot-cpp: Found"
else
    echo -e "${RED}✗${NC} godot-cpp: NOT INITIALIZED"
    echo "  Run: git submodule update --init --recursive"
fi

echo ""
echo "4. Checking godot-cpp build..."
if ls external/godot-cpp/bin/*.a 2>/dev/null || ls external/godot-cpp/bin/*.lib 2>/dev/null; then
    echo -e "${GREEN}✓${NC} godot-cpp libraries: Found"
else
    echo -e "${YELLOW}!${NC} godot-cpp libraries: Not built yet"
fi

echo ""
echo "5. Checking game extension..."
if ls game/bin/liburban_survivor.* 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Game extension: Found"
    ls game/bin/liburban_survivor.*
else
    echo -e "${YELLOW}!${NC} Game extension: Not built yet"
fi

echo ""
echo "=== Check Complete ==="
```

---

## 🔄 Development Workflow

### Daily Development Cycle

1. **Pull latest changes:**
   ```bash
   git pull
   git submodule update --init --recursive
   ```

2. **Make C++ code changes** in `src/` directory

3. **Rebuild extension:**
   ```bash
   cd build && make -j8 && cd ..
   ```

4. **Test in Godot:**
   - Close and reopen Godot Editor (for C++ changes)
   - Press F5 to run

### When to Rebuild godot-cpp

Only rebuild godot-cpp when:
- First-time setup
- Updating Godot version
- Switching git branches with different godot-cpp versions

---

## 📚 Additional Resources

- [Godot GDExtension Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/)
- [godot-cpp Repository](https://github.com/godotengine/godot-cpp)
- [Project BUILD_INSTRUCTIONS.md](../docs/BUILD_INSTRUCTIONS.md)
- [Project MEMORY.md](../docs/MEMORY.md) - Development decisions and context

---

## 🆘 Getting Help

If you encounter issues not covered here:

1. **Check existing docs:** `docs/BUILD_INSTRUCTIONS.md`, `docs/MEMORY.md`
2. **Search project issues** on GitHub
3. **Run the verification script** and share output
4. **Provide system info:**
   ```bash
   uname -a
   cmake --version
   scons --version
   ```

---

## 🏁 Quick Reference Card

### One-Liner Commands

```bash
# Full setup (first time)
git submodule update --init --recursive && cd external/godot-cpp && scons platform=macos target=template_debug -j8 && cd ../.. && mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j8 && cd ..

# Quick rebuild (daily use)
cd build && make -j8 && cd ..

# Clean rebuild
rm -rf build && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j8 && cd ..

# Run game (macOS)
/Applications/Godot.app/Contents/MacOS/Godot --path game/
```

### Copilot Shortcut Phrases

| Just Type... | Result |
|--------------|--------|
| `setup dev` | Full environment setup |
| `verify setup` | Check all prerequisites |
| `fix build` | Diagnose build errors |
| `rebuild clean` | Clean and rebuild all |

---

**Success Criteria:** Developer can run `./build_and_run.sh` (or equivalent) and see the game running in Godot with the savage character controllable via WASD + Mouse.