# Workshop 4: Expert - C++ Game Dev Tools Edition
## GitHub Copilot Advanced Features for Tool Development

**Duration**: 90 Minutes  
**Level**: Expert  
**Prerequisites**: Foundational + Intermediate + Advanced Workshops  
**Project**: Urban Survivor C++ Tools Suite (Model Viewer & Asset Browser)

---

## Workshop Objectives

By the end of this workshop, participants will:
- Configure a custom coding agent for C++ game tools development
- Master advanced prompt engineering for complex C++/OpenGL/ImGui scenarios
- Implement and use MCP servers for game development workflows
- Configure enterprise policies for game studio environments
- Optimize model selection for different development tasks
- Understand GitHub Copilot Certification requirements
- Deploy Copilot Spec Kit for team adoption
- Measure and improve productivity with Copilot metrics

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:15 | Custom Coding Agent Configuration | Live Demo |
| 0:15 - 0:30 | Advanced Prompt Engineering for C++ Tools | Hands-on |
| 0:30 - 0:45 | MCP Servers for Game Dev Workflows | Implementation |
| 0:45 - 0:55 | Enterprise Policy Management | Configuration |
| 0:55 - 1:05 | Model Selection & Cost Optimization | Analysis |
| 1:05 - 1:15 | GitHub Copilot Certification | Overview |
| 1:15 - 1:22 | Copilot Spec Kit Deployment | Tour |
| 1:22 - 1:30 | Copilot Metrics & ROI | Dashboard Review |

---

## Session 1: Custom Coding Agent Configuration (15 min)

### Learning Objectives
- Create a specialized coding agent for C++ game tools
- Configure agent instructions for your specific tech stack
- Implement context-aware agent behaviors

### Understanding Custom Agents

A **Custom Coding Agent** is GitHub Copilot configured with specialized knowledge and behaviors for your specific project. Think of it as having a C++/OpenGL/ImGui expert who knows your codebase intimately.

### Tech Stack Context

Our C++ Game Dev Tools Suite uses:
- **Languages**: C++17, GLSL
- **Graphics**: OpenGL 3.3+, GLAD
- **UI**: Dear ImGui 1.90+
- **Window/Input**: SDL2
- **Math**: GLM
- **3D Loading**: Assimp
- **Build**: CMake 3.20+
- **Platforms**: Windows, macOS, Linux

### Creating the Coding Agent Instruction File

**Location**: `.github/copilot-instructions.md`

```markdown
# C++ Game Development Tools - Coding Agent Instructions

## Project Context

You are assisting with development of C++ game development tools for Urban Survivor,
a post-apocalyptic survival game built with Godot 4.3. The tools suite includes:

1. **Model Viewer** - 3D model preview with Assimp + OpenGL
2. **Asset Browser** - File management with thumbnails and search
3. **Template Importer** - (Planned) Scene template generator
4. **Project Assistant** - (Planned) Code scaffolding wizard

## Tech Stack

### Core Technologies
- **C++ Standard**: C++17 (mandatory)
- **Graphics API**: OpenGL 3.3 Core Profile
- **UI Framework**: Dear ImGui 1.90+
- **Window/Input**: SDL2
- **Math Library**: GLM (OpenGL Mathematics)
- **3D Model Loading**: Assimp
- **Build System**: CMake 3.20+

### Directory Structure
```
tools/
  ├── common/           # Shared base classes (Application, Logger, FileSystem)
  ├── model_viewer/     # 3D model viewer tool
  ├── asset_browser/    # Asset management tool
  └── external/         # Third-party dependencies
```

## Coding Standards

### C++ Style Guide

1. **Naming Conventions**
   ```cpp
   // Classes: PascalCase
   class ModelViewerApp;
   class AssetDatabase;
   
   // Member variables: m_camelCase
   std::unique_ptr<Camera> m_camera;
   bool m_wireframeMode;
   
   // Functions: camelCase
   void loadModel(const std::string& path);
   bool initialize();
   
   // Constants: SCREAMING_SNAKE_CASE
   const int MAX_THUMBNAILS = 1000;
   ```

2. **Memory Management**
   - Use `std::unique_ptr` for ownership
   - Use `std::shared_ptr` only when truly shared
   - Avoid raw `new`/`delete`
   - Use RAII for all resources (OpenGL objects, SDL windows)

3. **Error Handling**
   ```cpp
   // Prefer returning bool for operations that can fail
   bool loadModel(const std::string& path) {
       if (!std::filesystem::exists(path)) {
           Logger::error("Model file not found: {}", path);
           return false;
       }
       // ... load model
       return true;
   }
   
   // Use exceptions only for exceptional cases
   // Not for control flow
   ```

4. **OpenGL Best Practices**
   ```cpp
   // Always check for errors in debug builds
   #ifndef NDEBUG
   void checkGLError(const char* location) {
       GLenum err;
       while ((err = glGetError()) != GL_NO_ERROR) {
           Logger::error("OpenGL error at {}: 0x{:x}", location, err);
       }
   }
   #define GL_CHECK(x) x; checkGLError(#x)
   #else
   #define GL_CHECK(x) x
   #endif
   
   // Use modern OpenGL (no immediate mode)
   // VAO/VBO/EBO for all geometry
   // Shaders for all rendering
   ```

5. **ImGui Patterns**
   ```cpp
   // Always use Begin/End pairs
   if (ImGui::Begin("Model Inspector")) {
       // Your UI code
       ImGui::Text("Vertices: %d", vertexCount);
   }
   ImGui::End();
   
   // Use unique IDs for multiple similar widgets
   for (int i = 0; i < meshes.size(); ++i) {
       ImGui::PushID(i);
       if (ImGui::Button("Select")) {
           selectMesh(i);
       }
       ImGui::PopID();
   }
   ```

## Code Generation Rules

### When creating new classes:

1. **Always generate .hpp and .cpp pairs**
   ```cpp
   // MyClass.hpp
   #pragma once
   
   namespace tools {
   
   class MyClass {
   public:
       MyClass();
       ~MyClass();
       
   private:
       // Private implementation
   };
   
   } // namespace tools
   ```

2. **Include file documentation**
   ```cpp
   /**
    * @file ModelLoader.hpp
    * @brief Loads 3D models using Assimp
    */
   ```

3. **Use forward declarations in headers when possible**
   ```cpp
   // Header file - forward declare
   class Camera;
   class Renderer;
   
   std::unique_ptr<Camera> m_camera;  // OK, only pointer
   
   // Implementation file - include full headers
   #include "Camera.hpp"
   #include "Renderer.hpp"
   ```

### When working with Application base class:

All tools inherit from `Application` base class. Override these virtual methods:

```cpp
class MyToolApp : public Application {
protected:
    void onInit() override;         // Called once at startup
    void onUpdate(float dt) override;  // Called every frame (game logic)
    void onImGuiRender() override;  // Called every frame (UI)
    void onResize(int w, int h) override;  // Window resized
    void onFileDrop(const std::string& path) override;  // File drag-dropped
    void onShutdown() override;     // Called at exit
};
```

### When adding new CMake targets:

Follow the existing pattern in `tools/CMakeLists.txt`:

```cmake
# New Tool Template
if(BUILD_MY_TOOL)
    set(MY_TOOL_SOURCES
        my_tool/main.cpp
        my_tool/MyToolApp.cpp
        my_tool/MyToolApp.hpp
    )
    
    add_executable(my_tool ${MY_TOOL_SOURCES})
    target_link_libraries(my_tool PRIVATE
        common
        imgui
        ${SDL2_LIBRARIES}
        OpenGL::GL
    )
    target_include_directories(my_tool PRIVATE ${SDL2_INCLUDE_DIRS})
endif()
```

## Common Tasks

### Task: Add a new UI panel to Model Viewer

```cpp
// In ModelViewerApp.hpp
private:
    void renderStatisticsPanel();  // Add declaration

// In ModelViewerApp.cpp
void ModelViewerApp::onImGuiRender() {
    renderMenuBar();
    renderViewport();
    renderInspector();
    renderStatisticsPanel();  // Add call
    renderStatusBar();
}

void ModelViewerApp::renderStatisticsPanel() {
    if (!ImGui::Begin("Statistics")) {
        ImGui::End();
        return;
    }
    
    // Panel content
    ImGui::Text("FPS: %.1f", ImGui::GetIO().Framerate);
    ImGui::Text("Frame Time: %.3f ms", 1000.0f / ImGui::GetIO().Framerate);
    
    if (m_modelLoader && m_modelLoader->isLoaded()) {
        const auto& stats = m_modelLoader->getStatistics();
        ImGui::Separator();
        ImGui::Text("Triangles: %d", stats.triangleCount);
        ImGui::Text("Vertices: %d", stats.vertexCount);
        ImGui::Text("Materials: %d", stats.materialCount);
    }
    
    ImGui::End();
}
```

### Task: Load a model in Model Viewer

```cpp
bool ModelViewerApp::loadModel(const std::string& path) {
    Logger::info("Loading model: {}", path);
    
    if (!std::filesystem::exists(path)) {
        Logger::error("File not found: {}", path);
        return false;
    }
    
    if (!m_modelLoader->load(path)) {
        Logger::error("Failed to load model: {}", path);
        return false;
    }
    
    m_currentModelPath = path;
    
    // Reset camera to frame the model
    if (m_camera) {
        const auto& bounds = m_modelLoader->getBoundingBox();
        m_camera->frameBox(bounds);
    }
    
    Logger::info("Model loaded successfully: {} meshes", 
                 m_modelLoader->getMeshCount());
    return true;
}
```

### Task: Add search functionality to Asset Browser

```cpp
// In AssetBrowserApp.hpp
private:
    std::vector<std::filesystem::path> filterAssets(
        const std::vector<std::filesystem::path>& assets,
        const std::string& query
    );

// In AssetBrowserApp.cpp
void AssetBrowserApp::renderToolbar() {
    ImGui::SetNextItemWidth(200.0f);
    if (ImGui::InputText("##search", m_searchBuffer, sizeof(m_searchBuffer))) {
        m_searchQuery = m_searchBuffer;
        refresh();  // Re-filter assets
    }
    // ... rest of toolbar
}

std::vector<std::filesystem::path> AssetBrowserApp::filterAssets(
    const std::vector<std::filesystem::path>& assets,
    const std::string& query
) {
    if (query.empty()) {
        return assets;
    }
    
    std::vector<std::filesystem::path> filtered;
    std::string lowerQuery = toLowerCase(query);
    
    for (const auto& asset : assets) {
        std::string filename = toLowerCase(asset.filename().string());
        if (filename.find(lowerQuery) != std::string::npos) {
            filtered.push_back(asset);
        }
    }
    
    return filtered;
}
```

## Dependencies and Includes

### Standard Library
```cpp
#include <string>
#include <vector>
#include <memory>
#include <filesystem>
#include <algorithm>
#include <optional>
```

### Third-Party Libraries
```cpp
// OpenGL
#include <glad/gl.h>

// ImGui
#include <imgui.h>
#include <imgui_impl_sdl2.h>
#include <imgui_impl_opengl3.h>

// SDL2
#include <SDL.h>

// GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

// Assimp
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
```

### Project Headers
```cpp
#include "Application.hpp"
#include "Logger.hpp"
#include "FileSystem.hpp"
```

## Performance Considerations

1. **Minimize OpenGL state changes**
   - Batch draw calls with same shader/texture
   - Use uniform buffer objects for shared data

2. **ImGui optimization**
   - Use `ImGui::IsWindowFocused()` to skip heavy updates
   - Cache computed values that don't change every frame

3. **File I/O**
   - Use `std::filesystem` for cross-platform paths
   - Check file existence before operations
   - Handle large directories with pagination

## Debugging Tips

1. **Use Logger consistently**
   ```cpp
   Logger::debug("Variable x = {}", x);
   Logger::info("Operation completed");
   Logger::warn("Unexpected value");
   Logger::error("Operation failed: {}", error);
   ```

2. **OpenGL debugging**
   - Use `GL_CHECK()` macro in debug builds
   - Validate shader compilation with detailed error logs
   - Check framebuffer completeness

3. **ImGui debugging**
   - Use `ImGui::ShowDemoWindow()` for reference
   - Use `ImGui::ShowMetricsWindow()` for debugging

## Build Commands

```bash
# Configure (macOS)
cd tools
cmake -B build -G "Xcode"

# Configure (Windows)
cmake -B build -G "Visual Studio 17 2022"

# Build
cmake --build build --config Release

# Run
./build/Release/model_viewer
./build/Release/asset_browser
```

## When I ask you to generate code:

1. **Check existing patterns first** - Look at similar code in the project
2. **Follow the style guide** - Use the naming conventions above
3. **Include error handling** - Check for null pointers, file existence, OpenGL errors
4. **Add logging** - Use Logger for important events
5. **Document your code** - Add comments for complex logic
6. **Test incrementally** - Suggest how to test the changes

## When I ask you to debug:

1. **Check OpenGL errors** - Suggest adding GL_CHECK calls
2. **Verify resource cleanup** - Look for missing destructors, unreleased OpenGL objects
3. **Review ImGui Begin/End pairs** - Ensure they're balanced
4. **Check file paths** - Cross-platform path handling with std::filesystem
5. **Examine logs** - Suggest adding Logger calls to trace execution

---

Remember: You're helping build professional game development tools. Code quality,
performance, and user experience all matter. When in doubt, ask for clarification
rather than making assumptions.
```

### Agent Configuration in VS Code

**Location**: `.vscode/settings.json`

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": ".github/copilot-instructions.md"
    }
  ],
  "github.copilot.chat.useProjectTemplates": true,
  "github.copilot.advanced": {
    "debug.enableInstrumentation": true
  }
}
```

### Testing Your Custom Agent

**Prompt**: 
```
@workspace Add a material preview panel to the Model Viewer that shows:
- Material name
- Diffuse color swatch
- Texture preview (if available)
- Shininess slider (read-only for now)
```

**Expected Agent Behavior**:
1. ✅ Checks existing `ModelViewerApp.hpp` for panel pattern
2. ✅ Follows naming convention (`renderMaterialPanel()`)
3. ✅ Uses ImGui Begin/End pattern
4. ✅ Includes null checks for model data
5. ✅ Adds Logger calls for debugging
6. ✅ Suggests testing steps

### Advanced Agent Features

**Context-Aware Suggestions**:
```cpp
// When you type this in ModelViewerApp.cpp:
void ModelViewerApp::on

// Agent suggests based on Application.hpp:
void ModelViewerApp::onInit() override {
    // Initialize model viewer
}

void ModelViewerApp::onUpdate(float deltaTime) override {
    // Update camera, animations
}

void ModelViewerApp::onImGuiRender() override {
    renderMenuBar();
    renderViewport();
    renderInspector();
}
```

**CMake Pattern Recognition**:
```cmake
# When adding a new tool, agent suggests:
if(BUILD_SHADER_EDITOR)
    set(SHADER_EDITOR_SOURCES
        shader_editor/main.cpp
        shader_editor/ShaderEditorApp.cpp
        shader_editor/ShaderEditorApp.hpp
        shader_editor/ShaderCompiler.cpp
        shader_editor/ShaderCompiler.hpp
    )
    
    add_executable(shader_editor ${SHADER_EDITOR_SOURCES})
    target_link_libraries(shader_editor PRIVATE
        common
        imgui
        ${SDL2_LIBRARIES}
        OpenGL::GL
    )
    target_include_directories(shader_editor PRIVATE ${SDL2_INCLUDE_DIRS})
endif()
```

### Verifying Agent Configuration

Run this test prompt:
```
@workspace Create a new Logger utility function called logOpenGLInfo() 
that prints the OpenGL version, vendor, and renderer to the log.
```

**Correct Response Should**:
- Place function in `common/Logger.hpp` and `Logger.cpp`
- Use proper namespace (`tools`)
- Call `glGetString()` for GL info
- Use `Logger::info()` for output
- Include `<glad/gl.h>` header
- Add null checks for GL strings

---

## Session 2: Advanced Prompt Engineering for C++ Tools (15 min)

### Learning Objectives
- Master multi-file code generation
- Use architectural prompts for complex features
- Leverage the CORE framework for C++ development

### The Challenge of C++ Development

C++ game tools require:
- Multiple files (.hpp/.cpp pairs)
- Memory management
- OpenGL resource lifecycle
- Cross-platform considerations
- Complex build configuration

### CORE Framework Review (Applied to C++)

**Context** → **Objective** → **Requirements** → **Examples**

### Example 1: Adding Texture Support to Model Viewer

❌ **Bad Prompt**:
```
Add texture support to the model viewer
```

✅ **Good Prompt (CORE)**:
```
@workspace I need to add texture support to the Model Viewer tool.

CONTEXT:
- Model Viewer currently loads 3D models with Assimp
- It renders meshes but doesn't display textures
- ModelLoader.cpp already extracts texture paths from models
- Renderer.cpp uses a basic shader without texture sampling

OBJECTIVE:
Implement texture loading and rendering so materials with diffuse textures
display correctly in the 3D viewport.

REQUIREMENTS:
1. Create a TextureManager class (TextureManager.hpp/.cpp)
   - Load images from disk (support PNG, JPG, TGA)
   - Create OpenGL textures with mipmaps
   - Cache textures to avoid reloading
   - Clean up OpenGL textures in destructor

2. Update Renderer to use textures
   - Modify shader to sample from texture
   - Bind texture before drawing each mesh
   - Fall back to solid color if no texture

3. Handle file paths correctly
   - Texture paths in models are relative to .glb file
   - Use std::filesystem to resolve paths
   - Log errors if texture files not found

4. Add UI control
   - Checkbox in Inspector: "Show Textures" (default: on)
   - Display texture info (resolution, format)

EXAMPLES:
```cpp
// Expected usage in Renderer:
auto texture = m_textureManager->load(materialInfo.diffuseTexture);
if (texture) {
    glBindTexture(GL_TEXTURE_2D, texture->getHandle());
    // Draw mesh
}

// Expected TextureManager API:
class TextureManager {
public:
    std::shared_ptr<Texture> load(const std::filesystem::path& path);
    void clear();
};
```

Please generate:
1. TextureManager.hpp
2. TextureManager.cpp
3. Updated shader code (vertex and fragment shaders)
4. Changes needed to Renderer.cpp
5. UI changes to ModelViewerApp.cpp
```

### Example 2: Implementing Thumbnail Generation

❌ **Bad Prompt**:
```
Make the asset browser show thumbnails
```

✅ **Good Prompt (CORE)**:
```
@workspace Implement thumbnail generation for the Asset Browser.

CONTEXT:
- Asset Browser currently shows a file list without previews
- We need thumbnails for images (.png, .jpg) and 3D models (.glb, .obj)
- Thumbnails should be cached on disk to avoid regeneration
- The UI has space reserved for 96x96 thumbnails in grid view

OBJECTIVE:
Create a ThumbnailGenerator system that:
1. Generates thumbnails for supported file types
2. Caches them in .cache/thumbnails/
3. Loads asynchronously to avoid blocking the UI

REQUIREMENTS:

A. Image Thumbnails:
   - Use stb_image to load source image
   - Resize to 96x96 (maintain aspect ratio, letterbox if needed)
   - Save as PNG to cache directory
   - Fast path: if cached thumbnail exists and is newer than source, use it

B. 3D Model Thumbnails:
   - Render model to offscreen framebuffer (256x256)
   - Use ModelLoader to load geometry
   - Simple orthographic camera framing the model
   - White background, simple lighting
   - Downscale to 96x96 and save to cache

C. Async Loading:
   - Generate thumbnails in background thread
   - Queue of pending thumbnails
   - When thumbnail ready, upload to GPU and notify UI
   - Show placeholder icon while loading

D. OpenGL Texture Integration:
   - Load cached PNG thumbnails as OpenGL textures
   - Use in ImGui::Image() calls
   - Handle texture cleanup

EXAMPLES:
```cpp
// Expected API:
class ThumbnailGenerator {
public:
    // Request thumbnail (returns placeholder immediately, loads in background)
    GLuint requestThumbnail(const std::filesystem::path& assetPath);
    
    // Check if thumbnail is ready
    bool isThumbnailReady(const std::filesystem::path& assetPath);
    
    // Clear cache for specific file or all
    void invalidate(const std::filesystem::path& assetPath);
    void clearCache();
};

// Usage in AssetBrowserApp:
GLuint texID = m_thumbnailGenerator->requestThumbnail(asset);
ImGui::Image((void*)(intptr_t)texID, ImVec2(96, 96));
```

FILES TO MODIFY/CREATE:
1. Create asset_browser/ThumbnailGenerator.hpp
2. Create asset_browser/ThumbnailGenerator.cpp
3. Update asset_browser/AssetBrowserApp.cpp (renderAssetGrid)
4. Add stb_image_write to external dependencies
5. Update CMakeLists.txt if needed

Please implement this feature step by step, starting with image thumbnails,
then 3D models, then async loading.
```

### Multi-File Generation Strategy

**Prompt Pattern**:
```
@workspace Create a [FEATURE] system with the following architecture:

FILES TO CREATE:
- [namespace]/[Class].hpp - Header with class declaration
- [namespace]/[Class].cpp - Implementation
- [namespace]/[Helper].hpp - Supporting class if needed

INTEGRATION POINTS:
- [ExistingClass].hpp - Add member variable
- [ExistingClass].cpp - Initialize and use new class
- CMakeLists.txt - Add source files if needed

ARCHITECTURE:
[ASCII diagram or description]

[Detailed requirements...]
```

### Architectural Prompts

**Example: Camera System Design**

```
@workspace Design and implement an orbit camera for the Model Viewer.

ARCHITECTURE:

The camera should support:
1. Orbit rotation (left mouse drag)
2. Pan (middle mouse drag)
3. Zoom (scroll wheel / right mouse drag)
4. Frame target (F key - fit model in view)

DESIGN:

```
Camera State:
  - target: vec3 (look-at point)
  - distance: float (from target)
  - azimuth: float (rotation around Y)
  - elevation: float (rotation around X)
  
Derived Values (computed each frame):
  - position = target + sphericalToCartesian(distance, azimuth, elevation)
  - view matrix = lookAt(position, target, up)
```

INPUT HANDLING:
- Mouse delta → update azimuth/elevation
- Scroll → update distance
- Middle mouse → translate target in view plane

CONSTRAINTS:
- Elevation clamped to [-89°, 89°] (avoid gimbal lock)
- Distance clamped to [0.1, 1000.0]
- Smooth damping on all motions (lerp over time)

INTEGRATION:
- ModelViewerApp owns Camera
- Camera updates in onUpdate(deltaTime)
- Camera provides getViewMatrix() for rendering

Please implement:
1. Camera.hpp with full class declaration
2. Camera.cpp with implementation
3. Input handling in ModelViewerApp.cpp
4. Frame-to-fit function that takes BoundingBox
```

### Code Review Prompts

```
@workspace Review this OpenGL rendering code for correctness and best practices:

```cpp
[paste code]
```

Check for:
1. OpenGL state management (VAO binding, cleanup)
2. Memory leaks (missing deletes, unbounded allocations)
3. Error handling (null checks, GL error checks)
4. Performance issues (redundant state changes, inefficient draws)
5. Cross-platform compatibility
```

### Refactoring Prompts

```
@workspace The ModelLoader class has grown to 800 lines and handles 
too many responsibilities. Refactor it into:

1. ModelLoader - High-level API, orchestrates loading
2. MeshParser - Assimp processing, creates Mesh objects
3. MaterialExtractor - Extracts materials and textures
4. GeometryOptimizer - Vertex cache optimization, merging

Maintain the existing public API of ModelLoader so existing code doesn't break.
Show me the proposed class structure first, then implement one class at a time.
```

---

## Session 3: MCP Servers for Game Dev Workflows (15 min)

### Learning Objectives
- Understand MCP (Model Context Protocol) servers
- Configure Blender MCP for 3D asset pipeline
- Create custom MCP for game-specific operations
- Use Azure MCP for deployment

### What is MCP?

**Model Context Protocol** is an open standard that allows AI assistants to:
- Invoke external tools and APIs
- Access databases and services
- Automate complex workflows
- Integrate with third-party systems

Think of MCP as **function calling for AI**, but standardized and extensible.

### MCP Architecture for Game Dev

```
┌────────────────────────────────────────────────────────────┐
│                VS Code + GitHub Copilot                    │
├────────────────────────────────────────────────────────────┤
│                    MCP Host (Copilot)                      │
│         ┌─────────┬─────────┬──────────┬──────────┐        │
│         │         │         │          │          │        │
│         ▼         ▼         ▼          ▼          ▼        │
│    ┌────────┐ ┌──────┐ ┌────────┐ ┌───────┐ ┌────────┐   │
│    │Blender │ │Azure │ │Context7│ │GitHub │ │Custom  │   │
│    │  MCP   │ │ MCP  │ │  MCP   │ │  MCP  │ │  MCP   │   │
│    └────────┘ └──────┘ └────────┘ └───────┘ └────────┘   │
│         │         │         │          │          │        │
└─────────┼─────────┼─────────┼──────────┼──────────┼────────┘
          │         │         │          │          │
          ▼         ▼         ▼          ▼          ▼
     ┌────────┐ ┌──────┐ ┌────────┐ ┌───────┐ ┌────────┐
     │Blender │ │Azure │ │  Docs  │ │  API  │ │  Game  │
     │  App   │ │Cloud │ │Database│ │       │ │   DB   │
     └────────┘ └──────┘ └────────┘ └───────┘ └────────┘
```

### MCP Server #1: Blender for Asset Pipeline

**Use Case**: Generate 3D assets without leaving VS Code

#### Installation

```bash
# Install Blender MCP server
npm install -g @wonderunit/blender-mcp
```

#### Configuration

**.vscode/settings.json**:
```json
{
  "mcp": {
    "servers": {
      "blender": {
        "command": "blender-mcp",
        "args": [],
        "env": {
          "BLENDER_PATH": "/Applications/Blender.app/Contents/MacOS/Blender"
        }
      }
    }
  }
}
```

#### Usage Examples

**Example 1: Generate a prop model**

```
@blender Create a low-poly fire hydrant model:
- Base cylinder: 0.3m radius, 0.8m height
- Top cylinder: 0.2m radius, 0.1m height
- Two side nozzles at 0.5m height
- Export as fire_hydrant.glb to /Users/hluciano/projects/cpp_game/assets/models/props/
```

**Example 2: Batch process models**

```
@blender For all .blend files in blender/props/:
1. Apply all modifiers
2. Triangulate geometry
3. Bake ambient occlusion to vertex colors
4. Export as .glb to assets/models/props/
```

**Example 3: Generate building variation**

```
@blender Load building_brownstone_01.blend and create 3 variations:
1. _var1: Change window color to green
2. _var2: Add fire escape on right side
3. _var3: Damaged version (some broken windows)

Export all as .glb to import_glb/brownstone_variations/
```

### MCP Server #2: Context7 for Documentation

**Use Case**: Look up Godot, ImGui, OpenGL docs in real-time

#### Installation

```bash
npm install -g @context7/mcp-server
```

#### Configuration

**.vscode/settings.json**:
```json
{
  "mcp": {
    "servers": {
      "context7": {
        "command": "context7-mcp",
        "args": ["--libraries", "godot,imgui,opengl"],
        "env": {}
      }
    }
  }
}
```

#### Usage Examples

**Example 1: ImGui API lookup**

```
@context7 How do I create a dockable window in Dear ImGui with 
save/load layout support?
```

**Response**:
```
ImGui Docking API:

1. Enable docking in initialization:
   ImGuiIO& io = ImGui::GetIO();
   io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;

2. Create dockspace:
   ImGuiID dockspace_id = ImGui::GetID("MyDockSpace");
   ImGui::DockSpace(dockspace_id);

3. Save layout:
   ImGui::SaveIniSettingsToDisk("imgui.ini");

4. Load layout:
   ImGui::LoadIniSettingsFromDisk("imgui.ini");

[Full code example follows...]
```

**Example 2: OpenGL function reference**

```
@context7 What's the correct way to create a framebuffer for 
off-screen rendering in OpenGL 3.3?
```

### MCP Server #3: Custom Game Tools MCP

**Use Case**: Game-specific operations (asset validation, build, deploy)

#### Implementation

**tools_mcp/server.py**:

```python
#!/usr/bin/env python3
"""
Custom MCP Server for Urban Survivor C++ Tools
"""
from mcp import MCPServer, Tool, Resource
import subprocess
import json
import os
from pathlib import Path

class GameToolsMCP(MCPServer):
    def __init__(self):
        super().__init__(
            name="game-tools",
            version="1.0.0",
            description="Urban Survivor game development tools"
        )
        
        self.project_root = Path(__file__).parent.parent
        
    @Tool(
        name="build_tools",
        description="Build all C++ game dev tools"
    )
    def build_tools(self, config: str = "Release") -> dict:
        """Build the tools suite with CMake"""
        tools_dir = self.project_root / "tools"
        build_dir = tools_dir / "build"
        
        # Configure
        result = subprocess.run(
            ["cmake", "-B", str(build_dir), "-G", "Xcode"],
            cwd=str(tools_dir),
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            return {
                "success": False,
                "error": result.stderr
            }
        
        # Build
        result = subprocess.run(
            ["cmake", "--build", str(build_dir), "--config", config],
            cwd=str(tools_dir),
            capture_output=True,
            text=True
        )
        
        return {
            "success": result.returncode == 0,
            "output": result.stdout,
            "error": result.stderr if result.returncode != 0 else None
        }
    
    @Tool(
        name="validate_model",
        description="Validate a 3D model file for game use"
    )
    def validate_model(self, model_path: str) -> dict:
        """Check if model meets game requirements"""
        path = Path(model_path)
        
        if not path.exists():
            return {"valid": False, "error": "File not found"}
        
        # Use Assimp to check model
        try:
            from assimp import pyassimp
            scene = pyassimp.load(str(path))
            
            issues = []
            
            # Check vertex count
            total_verts = sum(mesh.nVertices for mesh in scene.meshes)
            if total_verts > 100000:
                issues.append(f"High vertex count: {total_verts} (target: <100k)")
            
            # Check texture count
            textures = set()
            for mesh in scene.meshes:
                material = scene.materials[mesh.materialindex]
                # Extract textures from material
                # ...
            
            if len(textures) > 10:
                issues.append(f"Too many unique textures: {len(textures)} (target: <10)")
            
            pyassimp.release(scene)
            
            return {
                "valid": len(issues) == 0,
                "vertex_count": total_verts,
                "texture_count": len(textures),
                "issues": issues
            }
            
        except Exception as e:
            return {"valid": False, "error": str(e)}
    
    @Tool(
        name="import_asset",
        description="Import an asset into the project structure"
    )
    def import_asset(
        self,
        source_path: str,
        asset_type: str,  # "model", "texture", "audio"
        category: str = None
    ) -> dict:
        """Copy asset to correct project location"""
        import shutil
        
        source = Path(source_path)
        if not source.exists():
            return {"success": False, "error": "Source file not found"}
        
        # Determine destination
        dest_map = {
            "model": self.project_root / "game/assets/models",
            "texture": self.project_root / "game/assets/textures",
            "audio": self.project_root / "game/assets/audio"
        }
        
        dest_base = dest_map.get(asset_type)
        if not dest_base:
            return {"success": False, "error": f"Unknown asset type: {asset_type}"}
        
        if category:
            dest_base = dest_base / category
        
        dest_base.mkdir(parents=True, exist_ok=True)
        dest_path = dest_base / source.name
        
        shutil.copy2(source, dest_path)
        
        return {
            "success": True,
            "destination": str(dest_path),
            "relative_path": str(dest_path.relative_to(self.project_root))
        }
    
    @Resource(
        uri="tools://build_status",
        name="Build Status",
        description="Get the current build status of tools"
    )
    def get_build_status(self) -> str:
        """Check if tools are built and up to date"""
        tools_dir = self.project_root / "tools"
        build_dir = tools_dir / "build"
        
        if not build_dir.exists():
            return "Not built"
        
        executables = [
            build_dir / "Release/model_viewer",
            build_dir / "Release/asset_browser"
        ]
        
        status = {}
        for exe in executables:
            exists = exe.exists()
            mtime = exe.stat().st_mtime if exists else None
            status[exe.name] = {
                "exists": exists,
                "modified": mtime
            }
        
        return json.dumps(status, indent=2)

if __name__ == "__main__":
    server = GameToolsMCP()
    server.run()
```

#### Register in VS Code

**.vscode/settings.json**:
```json
{
  "mcp": {
    "servers": {
      "game-tools": {
        "command": "python3",
        "args": ["tools_mcp/server.py"],
        "env": {}
      }
    }
  }
}
```

#### Usage

```
@game-tools Build the tools suite in Debug configuration

@game-tools Validate the model at assets/models/buildings/brownstone_01.glb
and report any issues

@game-tools Import all .png files from /Downloads/game_textures/ 
as textures in category "ui"
```

### MCP Server #4: Azure for Deployment

**Use Case**: Deploy builds, manage PlayFab, query analytics

```
@azure Deploy the latest Windows build of model_viewer to 
Azure Blob Storage in container 'game-tools-builds'

@azure Query PlayFab for player count in last 24 hours

@azure Run compliance scan on all Azure resources used by Urban Survivor
```

### Workflow: Complete Asset Import Pipeline

**Multi-MCP Workflow**:

```
User: I have a building.blend file. Import it to the game.

Step 1: @blender Export building.blend as building.glb with 
        optimizations (triangulate, bake AO)

Step 2: @game-tools Validate building.glb for vertex count 
        and texture limits

Step 3: @game-tools Import building.glb to game/assets/models/buildings/

Step 4: @workspace Generate a Godot scene file that references 
        this model with proper collision shape

Done! building.tscn is ready to use in Godot.
```

---

## Session 4: Enterprise Policy Management (10 min)

### Learning Objectives
- Configure organization-wide Copilot policies
- Manage content exclusions for game studios
- Implement security and compliance controls

### Policy Hierarchy

```
GitHub Enterprise
 └── Organization (Game Studio)
      ├── Copilot Access Control
      ├── Content Exclusions
      ├── Model Restrictions
      └── Audit Logging
```

### Organization Policies

**GitHub.com → Your Org → Settings → Copilot**

| Policy | Options | Game Studio Recommendation |
|--------|---------|---------------------------|
| **Copilot Access** | All / Selected / None | Selected repos only |
| **Suggestions Matching Public Code** | Block / Allow | Block (avoid license issues) |
| **Chat** | Enabled / Disabled | Enabled |
| **CLI** | Enabled / Disabled | Enabled |
| **PR Summaries** | Enabled / Disabled | Enabled |
| **Code Review** | Enabled / Disabled | Enabled |

### Content Exclusions

**Use Case**: Protect proprietary game code and assets

#### Organization-Level Exclusions

**File**: `.github/copilot-content-exclusions.yml` (in .github org repo)

```yaml
# Game Studio - Copilot Content Exclusions

# Exclude proprietary engine code
paths:
  - "**/engine/proprietary/**"
  - "**/anti-cheat/**"
  
# Exclude secret files
  - "**/*.env"
  - "**/*.pem"
  - "**/*.key"
  - "**/server/config/production.json"
  
# Exclude large asset files (not useful for AI anyway)
  - "**/*.glb"
  - "**/*.gltf"
  - "**/*.blend"
  - "**/*.fbx"
  - "**/*.mp3"
  - "**/*.wav"
  - "**/*.ogg"
  
# Exclude player data
  - "**/user_data/**"
  - "**/save_games/**"

# Exclude internal documentation with unannounced features
  - "**/docs/internal/**"
  - "**/design/unreleased/**"

repositories:
  # Block entire sensitive repositories
  - "studio/backend-services"
  - "studio/player-analytics"
  - "studio/monetization-engine"
```

#### Repository-Level (.copilotignore)

**File**: `cpp_game/.copilotignore`

```
# C++ Game Project - Copilot Exclusions

# Build artifacts
build/
*.o
*.obj
*.exe
*.app
*.dll
*.so
*.dylib

# IDE files
.vscode/launch.json
.vscode/tasks.json
*.sln
*.vcxproj
*.xcworkspace

# Third-party code (already have docs)
external/
tools/external/

# Game design secrets (unreleased content)
design/upcoming_dlc/
design/season2/

# Asset source files (too large)
blender/
*.blend*
*.psd
*.ai

# Player data
game/save_data/
game/user_profiles/
```

### Sensitive File Patterns

**In-file markers**:

```cpp
// @copilot-ignore-file
// This file contains anti-cheat logic - do not index

namespace AntiCheat {
    // Proprietary detection algorithms
}
```

Or specific blocks:

```cpp
class NetworkManager {
public:
    void sendMessage(const Message& msg);
    
private:
    // copilot-ignore-start
    // Proprietary encryption implementation
    void encryptPayload(Buffer& data) {
        // Secret algorithm
    }
    // copilot-ignore-end
};
```

### Game Studio Policy Example

```yaml
# Urban Survivor Studio - Copilot Policy

organization: urban-survivor-studio

copilot:
  enabled: true
  access_mode: selected_repos
  
  # Repositories where Copilot is allowed
  allowed_repositories:
    - cpp_game  # Main game project
    - tools     # Development tools
    - docs      # Public documentation
    - website   # Marketing site
  
  # Repositories where Copilot is blocked
  blocked_repositories:
    - backend-services     # Contains API keys
    - anti-cheat          # Proprietary algorithms
    - player-data-pipeline # PII concerns
    - unreleased-dlc      # Unannounced content

  # Suggestion matching
  block_public_code_matches: true
  
  # Features
  chat_enabled: true
  cli_enabled: true
  pr_summaries: true
  code_reviews: true

# Content exclusions (see .github/copilot-content-exclusions.yml)

# MCP servers (only approved ones)
mcp:
  allowed_servers:
    - "@azure/mcp-server"
    - "@context7/mcp-server"
    - "internal/game-tools-mcp"
  
  blocked_by_default: true

# Model usage
models:
  default: "gpt-4o"
  allowed:
    - "gpt-4o"
    - "gpt-4o-mini"
    - "claude-sonnet-4.5"
  
  # Restrict expensive models to leads
  restricted:
    "claude-opus-4":
      allowed_teams:
        - tech-leads
        - architects

# Compliance
audit_logging:
  enabled: true
  retention_days: 90
  
  events:
    - copilot.suggestion_accepted
    - copilot.chat_conversation
    - copilot.mcp_tool_invoked
    - copilot.excluded_content_accessed

alerts:
  # Alert if someone tries to access excluded content
  excluded_content_attempts:
    enabled: true
    notify: security-team@studio.com
  
  # Alert on unapproved MCP server usage
  unapproved_mcp_usage:
    enabled: true
    notify: devops-team@studio.com
```

### Audit Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│         Urban Survivor Studio - Copilot Compliance         │
│                     January 2026                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Policy Compliance                        ✓ 100%           │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━                      │
│                                                             │
│  Excluded Content Access Attempts:        0  ✓             │
│  Public Code Matches Blocked:            23                │
│  Unapproved MCP Server Attempts:          2  ⚠             │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Recent Alerts:                                             │
│                                                             │
│  ⚠ Jan 28, 14:32 - @dev-intern tried to use unauthorized   │
│    MCP server "random-npm-package-mcp"                      │
│    Action: Blocked, notification sent to DevOps             │
│                                                             │
│  ✓ Jan 25, 09:15 - Monthly compliance scan completed       │
│    No violations found                                      │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Active Users by Repository:                                │
│                                                             │
│  cpp_game:           12 developers                          │
│  tools:               5 developers                          │
│  docs:                3 developers                          │
│  website:             2 developers                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Session 5: Model Selection & Cost Optimization (10 min)

### Learning Objectives
- Understand available Copilot models
- Select appropriate models for different C++ dev tasks
- Optimize costs for team usage

### Available Models (Jan 2026)

| Model | Strengths | Weaknesses | Cost (Relative) | Best For |
|-------|-----------|------------|-----------------|----------|
| **GPT-4o** | Fast, good code, balanced | Not best at complex logic | $$ | Daily coding |
| **GPT-4o-mini** | Very fast, cheap | Less accurate | $ | Completions, simple tasks |
| **Claude Sonnet 4.5** | Excellent reasoning | Slower | $$ | Architecture, reviews |
| **Claude Opus 4** | Best reasoning | Slowest, expensive | $$$$ | Critical decisions |

### Model Selection for C++ Tools Development

| Task | Recommended Model | Rationale |
|------|-------------------|-----------|
| **Inline completions** | GPT-4o-mini | Speed critical, simpler context |
| **Chat Q&A** | GPT-4o | Good balance |
| **Refactoring** | Claude Sonnet 4.5 | Complex logic understanding |
| **Architecture design** | Claude Opus 4 | Needs deep reasoning |
| **OpenGL debugging** | GPT-4o | Fast iteration needed |
| **Code review** | Claude Sonnet 4.5 | Thorough analysis |
| **Documentation** | GPT-4o | Good prose |
| **CMake generation** | GPT-4o | Pattern-based |

### Configuring Model Preferences

**.vscode/settings.json**:
```json
{
  "github.copilot.chat.models": {
    "default": "gpt-4o",
    "completion": "gpt-4o-mini",
    "chat": "gpt-4o",
    "review": "claude-sonnet-4.5"
  }
}
```

### Per-Request Model Selection

```
@workspace /model:claude-opus-4
Design the complete architecture for the Template Importer tool including:
- UI mockups in ImGui
- File format for templates (JSON schema)
- Code generation pipeline
- Godot scene assembly
- Testing strategy

This is a critical architecture decision that will affect months of development.
```

### Cost Optimization Strategies

#### Strategy 1: Tiered Model Access

```
Junior Developers (0-2 years):
├─ Completions: GPT-4o-mini (95% of requests)
├─ Chat: GPT-4o (simple queries)
└─ Architecture: Ask senior (don't use Claude Opus)

Mid-Level Developers (2-5 years):
├─ Completions: GPT-4o-mini (80% of requests)
├─ Chat: GPT-4o (standard queries)
└─ Reviews: Claude Sonnet 4.5 (complex reviews)

Senior/Lead Developers:
├─ Completions: GPT-4o-mini (60% of requests)
├─ Chat: GPT-4o or Claude Sonnet 4.5
└─ Architecture: Claude Opus 4 (critical decisions)
```

#### Strategy 2: Task-Based Auto-Selection

**Prompt Patterns**:

```cpp
// Inline completion - use cheapest model
void ModelViewerApp::load█

// Chat - simple question - use GPT-4o
// "How do I bind a texture in OpenGL?"

// Chat - complex refactor - use Claude Sonnet
// "Refactor the 800-line ModelLoader class into 4 focused classes"

// Architecture - use Claude Opus only when explicitly requested
// "@workspace /model:claude-opus-4 Design the shader editor architecture"
```

#### Strategy 3: Caching and Reuse

**Team Shared Prompts** (reduces duplicate requests):

```
# .github/copilot-prompts/opengl-texture.md

## Loading a Texture in OpenGL 3.3

```cpp
GLuint loadTexture(const std::string& path) {
    // Load image data
    int width, height, channels;
    stbi_set_flip_vertically_on_load(true);
    unsigned char* data = stbi_load(path.c_str(), &width, &height, &channels, 0);
    
    if (!data) {
        Logger::error("Failed to load texture: {}", path);
        return 0;
    }
    
    // Create OpenGL texture
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    // Set parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    // Upload texture data
    GLenum format = (channels == 4) ? GL_RGBA : GL_RGB;
    glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, 
                 format, GL_UNSIGNED_BYTE, data);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    stbi_image_free(data);
    
    return textureID;
}
```

Usage: Reference this file instead of asking Copilot repeatedly.
```

#### Strategy 4: Token Optimization

❌ **Token-Wasting Prompt**:
```
@workspace Review the entire ModelViewerApp.cpp file
```
(Sends 800 lines → ~3000 tokens)

✅ **Optimized Prompt**:
```
@workspace Review lines 245-280 of ModelViewerApp.cpp 
(the texture binding logic) for OpenGL correctness
```
(Sends 35 lines → ~150 tokens)

### Cost Monitoring Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│         Urban Survivor Team - Copilot Usage Report          │
│                   January 2026                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Monthly Cost Breakdown:                                    │
│                                                             │
│  GPT-4o-mini (Completions)    125,000 tokens   $1.25       │
│  GPT-4o (Chat)                 80,000 tokens   $8.00       │
│  Claude Sonnet (Reviews)       25,000 tokens  $12.50       │
│  Claude Opus (Architecture)     5,000 tokens  $15.00       │
│  ───────────────────────────────────────────────────       │
│  Total:                       235,000 tokens  $36.75       │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Usage by Developer:                                        │
│                                                             │
│  @senior-dev (Lead)                 $12.50 (mostly Opus)   │
│  @mid-dev-1                         $8.75  (balanced)      │
│  @mid-dev-2                         $7.25                  │
│  @junior-dev-1                      $4.50  (mostly mini)   │
│  @junior-dev-2                      $3.75                  │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Top Cost Drivers:                                          │
│                                                             │
│  1. Architecture reviews (Claude Opus)         $15.00      │
│  2. Code reviews (Claude Sonnet)               $12.50      │
│  3. Daily chat (GPT-4o)                        $8.00       │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Optimization Opportunities:                                │
│                                                             │
│  ⚠ @junior-dev-1 using Claude Opus for simple questions    │
│    Savings potential: ~$5/month                             │
│                                                             │
│  ✓ Team using GPT-4o-mini effectively for completions      │
│                                                             │
│  💡 Consider caching common OpenGL/ImGui patterns           │
│    Estimated savings: $3-5/month                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### ROI Calculation

```
Cost:
├─ Copilot Licenses: 5 devs × $39/month = $195/month
├─ Token Usage (above average): $37/month
└─ Total: $232/month

Value:
├─ Time Saved: ~20 hours/month/dev = 100 hours/month
├─ Labor Value: 100 hours × $75/hour = $7,500/month
└─ Quality Improvements: Fewer bugs, better patterns

ROI: ($7,500 - $232) / $232 = 31.3x return

Even at conservative 10 hours/month time savings:
ROI: ($3,750 - $232) / $232 = 15.2x return
```

---

## Session 6: GitHub Copilot Certification (10 min)

### Learning Objectives
- Understand certification structure and domains
- Review key exam topics for C++ developers
- Access study resources

### Certification Overview

**GitHub Copilot Certification**
- **Duration**: 90 minutes
- **Format**: 50 multiple choice + 2 hands-on scenarios
- **Passing Score**: 70%
- **Cost**: $99 (free retake after 30 days)
- **Validity**: 2 years
- **Renewal**: Pass recertification exam

### Exam Domains

| Domain | Weight | Key Topics |
|--------|--------|------------|
| **Fundamentals** | 20% | What Copilot is, how it works, limitations |
| **Configuration** | 25% | Settings, instruction files, policies |
| **Prompt Engineering** | 30% | Effective prompts, context management |
| **Integration** | 15% | MCP, agents, CI/CD, workflows |
| **Security & Compliance** | 10% | Privacy, exclusions, enterprise controls |

### Sample Exam Questions

#### Question 1: Fundamentals (Easy)

```
Which of the following statements about GitHub Copilot suggestions is TRUE?

A) Suggestions are guaranteed to compile and run correctly
B) Suggestions are based on the current file and neighboring tabs
C) Suggestions require an internet connection for every keystroke
D) Suggestions only work for JavaScript and Python

Answer: B

Explanation: Copilot uses context from your current file, open tabs,
and project structure to generate suggestions. Suggestions are not
guaranteed to be correct (A is false), context is sent to the cloud
but not on every keystroke (C is false), and Copilot supports many
languages including C++ (D is false).
```

#### Question 2: Configuration (Medium)

```
You want to prevent GitHub Copilot from suggesting code based on
proprietary authentication logic across your entire organization.
What is the BEST approach?

A) Add comments // copilot-ignore in each file
B) Create .copilotignore in each repository
C) Configure copilot-content-exclusions.yml in the .github org repository
D) Disable Copilot for the entire organization

Answer: C

Explanation: Organization-level content exclusions in the .github
repository apply across all repos in the org, making it the most
efficient solution. Option A is per-file and error-prone, B is
per-repo (less efficient), and D is too restrictive.
```

#### Question 3: Prompt Engineering (Hard)

```
You ask Copilot: "Fix this OpenGL code"

Which additional context would MOST improve the quality of suggestions?

A) Increase the temperature parameter in settings
B) Provide the error message and expected behavior
C) Use /model:claude-opus-4 for more expensive model
D) Regenerate the prompt multiple times until it works

Answer: B

Explanation: Specific error messages and expected behavior give
Copilot concrete information to work with. Temperature affects
randomness (A), model selection helps but not as much as better
context (C), and regenerating without adding context is inefficient (D).
The CORE framework teaches us that Objective and Requirements matter.
```

#### Question 4: Integration (Medium)

```
An MCP server allows GitHub Copilot to:

A) Run code faster with multiple CPU cores
B) Invoke external tools and APIs during chat interactions
C) Share suggestions across multiple developers simultaneously
D) Store chat history in the cloud for 90 days

Answer: B

Explanation: MCP (Model Context Protocol) servers extend Copilot's
capabilities by allowing it to call external tools, query databases,
and interact with APIs. It's not related to performance (A),
suggestion sharing (C), or data storage (D).
```

#### Question 5: Security (Hard)

```
A developer on your team reports that Copilot suggested code that
appears to contain an API key from a public repository. What should
you do FIRST?

A) Disable Copilot immediately for the entire organization
B) Enable "Block suggestions matching public code" in org settings
C) Investigate if the API key is real and rotate it if necessary
D) Report the incident to GitHub Support

Answer: C

Explanation: If a real API key was leaked publicly, it's already
compromised and must be rotated immediately. After handling the
security issue, then enable blocking public code matches (B) to
prevent future occurrences. Disabling Copilot (A) doesn't fix the
leak, and reporting to GitHub (D) is less urgent than securing
your systems.
```

### Hands-On Scenario Example

**Scenario 1: Configure Instruction File for C++ Project**

```
Task: You are starting a new C++ game project using SDL2 and OpenGL.
Create a copilot-instructions.md file that will help Copilot generate
code following your team's standards.

Requirements:
1. Specify C++17 as the standard
2. Prefer smart pointers over raw new/delete
3. Use a specific naming convention (your choice, be consistent)
4. Mention the tech stack (SDL2, OpenGL, GLM)
5. Include at least one code example showing correct usage

Time: 10 minutes

Evaluation Criteria:
- File structure and markdown formatting (10 pts)
- Completeness of tech stack info (20 pts)
- Code example quality (30 pts)
- Clear naming conventions (20 pts)
- Practical and actionable (20 pts)
```

**Scenario 2: Optimize a Prompt for Code Generation**

```
Task: You have an existing prompt that produces mediocre results.
Rewrite it using the CORE framework to improve output quality.

Original Prompt:
"Add camera controls to the viewer"

Requirements:
1. Use CORE framework (Context, Objective, Requirements, Examples)
2. Specify the exact files to modify
3. Include technical details (input method, camera type)
4. Provide expected API usage example

Time: 8 minutes

Evaluation Criteria:
- Clear context about project state (25 pts)
- Specific, measurable objective (25 pts)
- Detailed requirements (30 pts)
- Useful code example (20 pts)
```

### Study Resources

| Resource | Type | URL / Location |
|----------|------|----------------|
| **GitHub Copilot Docs** | Official Docs | docs.github.com/copilot |
| **GitHub Skills** | Interactive Labs | skills.github.com |
| **Microsoft Learn** | Learning Path | learn.microsoft.com/training |
| **This Workshop Series** | Hands-On | You're here! |
| **Practice Exams** | Assessment | github.com/certifications |

### Study Plan (2 Weeks)

**Week 1: Fundamentals & Configuration**
- Day 1-2: Read official Copilot documentation
- Day 3-4: Configure Copilot in a personal project
- Day 5: Create instruction files and test them
- Day 6-7: Practice configuration scenarios

**Week 2: Advanced Topics & Practice**
- Day 8-9: Study MCP servers, implement one
- Day 10-11: Practice prompt engineering (CORE framework)
- Day 12: Review security and compliance
- Day 13: Take practice exam
- Day 14: Review weak areas, schedule real exam

### Certification Checklist

- [ ] Complete all 4 workshops (Foundation → Expert)
- [ ] Configure Copilot in at least 2 projects
- [ ] Create custom instruction file
- [ ] Use MCP server in real workflow
- [ ] Practice CORE prompts for complex tasks
- [ ] Understand content exclusion patterns
- [ ] Review security best practices
- [ ] Take at least 2 practice exams
- [ ] Score 80%+ on practice before scheduling real exam

---

## Session 7: Copilot Spec Kit Deployment (7 min)

### Learning Objectives
- Understand Spec Kit components
- Customize for game development studios
- Deploy to your team

### What is the Copilot Spec Kit?

A **turnkey package** for rolling out GitHub Copilot across your organization, including:
- Adoption roadmap
- Training materials
- Policy templates
- Success metrics
- Communication templates

### Spec Kit Components

**1. Adoption Guide**
```markdown
# Urban Survivor Studio - Copilot Adoption Roadmap

## Phase 1: Pilot (Weeks 1-2)
- Select 3-5 developers (mixed experience levels)
- Enable Copilot for cpp_game and tools repositories
- Gather initial feedback
- Metrics: Acceptance rate, time saved (estimated)

## Phase 2: Expansion (Weeks 3-4)
- Onboard remaining development team (12 developers)
- Run workshops (Foundation, Intermediate)
- Deploy instruction files
- Configure content exclusions

## Phase 3: Optimization (Weeks 5-6)
- Advanced workshop (Expert level)
- Configure MCP servers
- Fine-tune model selection
- Analyze metrics and adjust

## Phase 4: Full Deployment (Week 7+)
- Enable for all technical staff (20 total)
- Ongoing training and support
- Monthly metrics reviews
- Continuous improvement
```

**2. Policy Templates**

**File**: `copilot_spec_kit/policy_template.yml`

```yaml
# Copilot Policy Template for Game Studios

studio_name: "{{ YOUR_STUDIO_NAME }}"

# Customize these sections:
repositories:
  allowed:
    - "{{ GAME_PROJECT_REPO }}"
    - "{{ TOOLS_REPO }}"
    # Add more...
  
  blocked:
    - "{{ SENSITIVE_BACKEND_REPO }}"
    # Add more...

content_exclusions:
  # Add your proprietary paths
  - "**/anti-cheat/**"
  - "**/proprietary-engine/**"
  - "{{ YOUR_SENSITIVE_PATHS }}"

mcp_servers:
  approved:
    - "@azure/mcp-server"
    - "internal/{{ YOUR_CUSTOM_MCP }}"

# Model tiers by role
model_access:
  junior_developers:
    default: "gpt-4o-mini"
    allowed: ["gpt-4o-mini", "gpt-4o"]
  
  senior_developers:
    default: "gpt-4o"
    allowed: ["gpt-4o-mini", "gpt-4o", "claude-sonnet-4.5"]
  
  tech_leads:
    default: "claude-sonnet-4.5"
    allowed: ["gpt-4o", "claude-sonnet-4.5", "claude-opus-4"]
```

**3. Training Materials**

```
copilot_spec_kit/training/
├── 01-foundational-workshop.md
├── 02-intermediate-workshop.md
├── 03-advanced-workshop.md
├── 04-expert-workshop.md  ← This document
├── slides/
│   ├── foundation.pptx
│   ├── intermediate.pptx
│   ├── advanced.pptx
│   └── expert.pptx
├── exercises/
│   ├── prompt_engineering.md
│   ├── instruction_files.md
│   └── mcp_setup.md
└── assessments/
    ├── quiz_foundation.md
    ├── quiz_intermediate.md
    └── quiz_advanced.md
```

**4. Success Metrics Template**

**File**: `copilot_spec_kit/metrics_template.md`

```markdown
## Copilot Success Metrics for {{ STUDIO_NAME }}

### Developer Productivity
- [ ] Average acceptance rate
  - Target: >25%
  - Actual: _____

- [ ] Lines of code accepted per developer/day
  - Target: >100
  - Actual: _____

- [ ] Time to complete feature tickets
  - Baseline (pre-Copilot): _____ hours
  - Current: _____ hours
  - Improvement: _____%

### Code Quality
- [ ] Bug rate in Copilot-assisted code
  - Compare to non-assisted code
  - Metric: bugs per 1000 lines

- [ ] Code review feedback volume
  - Has decreased? By how much?

- [ ] Test coverage
  - Are developers writing more tests with Copilot?

### Developer Satisfaction
- [ ] NPS score for Copilot
  - Target: >40
  - Actual: _____

- [ ] Survey: "Copilot helps me be more productive"
  - Agree/Strongly Agree: _____%

- [ ] Voluntary usage rate
  - Active users / Total seats: _____%

### ROI Calculation
```
Cost:
  Copilot licenses: {{ NUM_DEVS }} × $39 = $_____ /month
  Token usage:                           $_____ /month
  Training time:                         $_____ (one-time)
  Total Monthly:                         $_____ /month

Value:
  Time saved: {{ HOURS_SAVED }} hours/month
  Labor value: {{ HOURS_SAVED }} × ${{ HOURLY_RATE }} = $_____ /month
  
ROI: ( $_____ - $_____ ) / $_____ = ____ x
```
```

**5. Communication Templates**

**Announcement Email**:
```
Subject: Introducing GitHub Copilot to Urban Survivor Studio

Team,

We're excited to announce that GitHub Copilot is now available to all
developers at Urban Survivor Studio!

What is Copilot?
GitHub Copilot is an AI-powered coding assistant that helps you write
code faster and with fewer errors. Think of it as "autocomplete on steroids"
for coding.

What can it do?
- Suggest code completions as you type
- Generate entire functions from comments
- Answer questions about code
- Help with debugging and refactoring

Getting Started:
1. Copilot is enabled for these repos: cpp_game, tools, docs
2. Install the extension: [link]
3. Complete the Foundation workshop: [link]
4. Join #copilot-support on Slack for help

Workshops:
- Jan 30, 2pm: Foundation (1 hour)
- Feb 6, 2pm: Intermediate (1 hour)
- Feb 13, 2pm: Advanced (1 hour)
- Feb 20, 2pm: Expert (90 min)

Questions? Reach out to @tech-lead or #copilot-support.

Let's build Urban Survivor faster and better!

- Engineering Leadership
```

### Deploying the Spec Kit

**Step 1: Customize Templates**
```bash
cd copilot_spec_kit
find . -type f -name "*.md" -o -name "*.yml" | xargs \
  sed -i '' 's/{{ YOUR_STUDIO_NAME }}/Urban Survivor Studio/g'
```

**Step 2: Create Shared Repository**
```bash
# Create internal repo
gh repo create urban-survivor-studio/copilot-resources --private

# Push spec kit
git init
git add copilot_spec_kit/
git commit -m "Initial Copilot Spec Kit deployment"
git push
```

**Step 3: Schedule Workshops**
- Book conference room
- Send calendar invites
- Prepare live demo environments
- Test all exercises beforehand

**Step 4: Launch Communication**
- Send announcement email
- Post in team Slack
- Add to onboarding docs
- Create FAQ document

### Measuring Adoption Success

**Week 2 Check-In**:
```
Metrics to review:
✓ How many devs have installed Copilot? (Target: 100%)
✓ Acceptance rate (Target: >15% in first 2 weeks)
✓ Support questions volume (normal to be high initially)
✓ Sentiment from pilot group
```

**Month 1 Review**:
```
✓ Acceptance rate (Target: >25%)
✓ All devs completed Foundation workshop?
✓ Instruction files deployed?
✓ Content exclusions working?
✓ Cost tracking in place?
```

**Month 3 Assessment**:
```
✓ Acceptance rate (Target: >30%)
✓ Measurable time savings?
✓ Positive NPS score?
✓ ROI calculation complete?
✓ Advanced features adopted (MCP, custom agents)?
```

---

## Session 8: Copilot Metrics & ROI (8 min)

### Learning Objectives
- Access and interpret Copilot metrics dashboard
- Measure team productivity gains
- Calculate ROI for management reporting

### Accessing Metrics

**Location**: GitHub.com → Your Org → Settings → Copilot → Metrics

**Available Dashboards**:
1. Organization Overview
2. Repository-level Metrics
3. Individual Developer Metrics (aggregated)
4. Model Usage Statistics

### Key Metrics Explained

#### 1. Acceptance Rate

**Definition**: Percentage of Copilot suggestions that developers accept

```
Acceptance Rate = (Accepted Suggestions / Total Suggestions) × 100%
```

**Benchmarks**:
- <15%: Low (review instruction files, provide training)
- 15-25%: Average (typical for new users)
- 25-35%: Good (experienced users, well-configured)
- >35%: Excellent (optimal configuration)

**For C++ Development**:
- Lower than JavaScript/Python (language complexity)
- Target: 20-30% for C++ projects

#### 2. Lines Accepted

**Definition**: Total lines of code from Copilot suggestions that were accepted

**Interpretation**:
- Raw metric: Track trend over time
- Per developer: Identify power users and training needs
- Per repository: Which projects benefit most

**Example**:
```
Urban Survivor Tools (cpp_game/tools):
  This month: 5,200 lines accepted
  Last month:  3,800 lines accepted
  Growth: +37%
```

#### 3. Active Users

**Definition**: Developers who used Copilot at least once in the period

```
Active User Rate = (Active Users / Total Seats) × 100%
```

**Target**: >80% active users

**If below target**:
- Identify inactive users
- Send personalized onboarding
- Remove obstacles (firewall, VPN issues)

#### 4. Chat Engagement

**Definition**: Number of chat conversations, questions asked, models used

**Useful for**:
- Understanding how developers use Copilot beyond completions
- Identifying training opportunities (if chat underutilized)
- Model usage patterns

### Urban Survivor Studio Dashboard (Example)

```
┌─────────────────────────────────────────────────────────────┐
│         GitHub Copilot Metrics - Urban Survivor Studio      │
│                     January 2026                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Organization Overview                                      │
│  ──────────────────────                                     │
│                                                             │
│  Active Users:           18 / 20  (90%)  ✓                  │
│                                                             │
│  Acceptance Rate:        28%                                │
│  ████████████████████████████░░░░░░░░░░                    │
│  Target: 25%             ✓ Above target                     │
│                                                             │
│  Lines Accepted:         18,450 lines this month            │
│  vs Last Month:          +22%  ▲                            │
│                                                             │
│  Chat Sessions:          340 conversations                  │
│  Avg per developer:      18.9 sessions                      │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Repository Breakdown                                       │
│  ──────────────────────                                     │
│                                                             │
│  Repo                Lines Accepted    Acceptance Rate      │
│  ───────────────────────────────────────────────────────    │
│  cpp_game/tools      5,200  (28%)      32%  ✓               │
│  cpp_game/src        8,900  (48%)      26%  ✓               │
│  cpp_game/docs       2,100  (11%)      42%  ✓ (markdown)    │
│  website             1,800  (10%)      35%                  │
│  other                 450  (3%)       18%                  │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Top Contributors                                           │
│  ──────────────────                                         │
│                                                             │
│  Developer        Lines Accepted   Acceptance Rate   Chat   │
│  ──────────────────────────────────────────────────────────│
│  @senior-dev-1    3,200  (17%)     35%              42      │
│  @mid-dev-1       2,900  (16%)     28%              38      │
│  @mid-dev-2       2,400  (13%)     25%              25      │
│  @junior-dev-1    1,800  (10%)     22%              18      │
│  @senior-dev-2    1,700  (9%)      30%              45      │
│  ...                                                        │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Language Distribution                                      │
│  ──────────────────────                                     │
│                                                             │
│  C++:               62%  ████████████████████░░░░░░░        │
│  CMake:             12%  ███████░░░░░░░░░░░░░░░░░░░         │
│  Markdown:          11%  ██████░░░░░░░░░░░░░░░░░░░          │
│  GDScript:          8%   ████░░░░░░░░░░░░░░░░░░░░░          │
│  GLSL:              4%   ██░░░░░░░░░░░░░░░░░░░░░░░          │
│  Other:             3%   █░░░░░░░░░░░░░░░░░░░░░░░░          │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Model Usage                                                │
│  ────────────                                               │
│                                                             │
│  GPT-4o-mini:       45%  (completions)                      │
│  GPT-4o:            35%  (chat, general)                    │
│  Claude Sonnet:     18%  (reviews, refactoring)             │
│  Claude Opus:       2%   (architecture)                     │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Estimated Impact                                           │
│  ─────────────────                                          │
│                                                             │
│  Time Saved:        ~85 hours this month                    │
│  (Based on accepted lines, industry benchmarks)             │
│                                                             │
│  Value:             85 hours × $75/hr = $6,375              │
│  Cost:              20 seats × $39 + $37 tokens = $817      │
│  Net Benefit:       $5,558                                  │
│  ROI:               6.8x                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Analyzing Trends

**Acceptance Rate Over Time**:
```
Month       Acceptance Rate   Insight
────────────────────────────────────────────────────────
Nov 2025    12%               Initial adoption, learning curve
Dec 2025    19%               Training workshops completed
Jan 2026    28%               Instruction files deployed ✓
Feb 2026    ?                 Target: 30%+
```

**Lines Accepted Growth**:
```
                      Lines Accepted
                             │
 20k ────────────────────────┤
                             │                    ╭──
                             │                ╭───╯
 15k ────────────────────────┤            ╭───╯
                             │        ╭───╯
                             │    ╭───╯
 10k ────────────────────────┤╭───╯
                             ╯
  5k ────────────────────────┤
                             │
   0 ────┬────┬────┬────┬────┤
        Nov  Dec  Jan  Feb  Mar
```

**Inactive Users Investigation**:
```
Inactive: @dev7, @artist2

Investigation:
@dev7:
  - Last active: 3 weeks ago
  - Possible issue: Working on non-coding tasks (documentation)
  - Action: Check if they need Copilot access

@artist2:
  - Last active: Never
  - Issue: Artist role, doesn't write code
  - Action: Remove seat, reallocate to engineer
```

### ROI Calculation (Detailed)

**Methodology**:

```python
# Time savings estimation
lines_accepted = 18_450  # This month
time_per_line = 1.5  # minutes (industry benchmark for C++)

time_saved_minutes = lines_accepted * time_per_line
time_saved_hours = time_saved_minutes / 60  # = 461.25 hours

# Conservative adjustment (not all lines are net-new productivity)
# Some would have been written anyway, just faster
productivity_factor = 0.6  # 60% represents true time savings

net_time_saved = time_saved_hours * productivity_factor
# = 276.75 hours → round to ~280 hours for reporting

# Cost calculation
copilot_seats = 20
cost_per_seat = 39
token_costs = 37  # From model usage

total_cost = (copilot_seats * cost_per_seat) + token_costs
# = 780 + 37 = $817

# Value calculation
hourly_rate = 75  # Blended rate for team
value = net_time_saved * hourly_rate
# = 280 × 75 = $21,000

# ROI
roi = (value - total_cost) / total_cost
# = (21,000 - 817) / 817 = 24.7x

# More conservative estimate (using 30% productivity factor):
conservative_time_saved = time_saved_hours * 0.3  # = 138 hours
conservative_value = 138 * 75  # = $10,350
conservative_roi = (10,350 - 817) / 817  # = 11.7x
```

**Report to Management**:

```markdown
## GitHub Copilot ROI - Urban Survivor Studio
### January 2026

**Investment**:
- 20 Copilot licenses @ $39/month: $780
- Token usage (premium models): $37
- **Total Monthly Cost**: $817

**Return**:
- Lines of code accepted: 18,450
- Estimated time saved: 280 hours (conservative: 138 hours)
- Labor value of time saved: $21,000 (conservative: $10,350)

**ROI**:
- Best estimate: **24.7x** return on investment
- Conservative estimate: **11.7x** return on investment
- Monthly net benefit: $20,183 (conservative: $9,533)

**Additional Benefits** (not quantified):
- Improved code quality (fewer bugs reported)
- Faster onboarding for new developers
- Increased developer satisfaction (NPS: 68)
- Knowledge sharing (Copilot learns from senior devs)

**Recommendation**: Continue investment, expand to QA team.
```

### Action Items from Metrics

**If Acceptance Rate is Low (<20%)**:
1. Review instruction files - are they deployed?
2. Check if content exclusions are too broad
3. Provide additional training workshops
4. Survey developers for friction points

**If Usage is Declining**:
1. Refresh training materials
2. Share success stories internally
3. Introduce new features (MCP servers)
4. Review if policies are too restrictive

**If Costs are High**:
1. Audit model usage (too much Claude Opus?)
2. Optimize prompts to reduce token usage
3. Cache common queries
4. Implement tiered model access

---

## Workshop Summary

### What We Covered

1. **Custom Coding Agent** - Configured specialized AI for C++ game tools
2. **Advanced Prompting** - CORE framework for complex multi-file generation
3. **MCP Servers** - Blender, Context7, Azure, custom game tools integration
4. **Enterprise Policies** - Content exclusions, model access, compliance
5. **Model Selection** - Optimized costs while maintaining quality
6. **Certification** - Prepared for GitHub Copilot certification exam
7. **Spec Kit** - Deployed templates for team adoption
8. **Metrics** - Measured productivity and calculated ROI

### Key Takeaways

✅ **A well-configured agent is 10x more effective** than default Copilot  
✅ **MCP servers unlock game dev superpowers** (Blender automation, docs lookup)  
✅ **Enterprise policies protect IP** while enabling productivity  
✅ **Model selection matters** - right model for the right task  
✅ **Certification validates expertise** and builds credibility  
✅ **Metrics prove ROI** - typically 10-30x return on investment  

### Next Steps

#### Immediate (This Week)
- [ ] Deploy `.github/copilot-instructions.md` in your project
- [ ] Configure MCP servers (start with Context7 for docs)
- [ ] Set up content exclusions (.copilotignore)
- [ ] Start tracking metrics

#### Short-Term (This Month)
- [ ] Complete all 4 workshops with team
- [ ] Create custom MCP server for game-specific tasks
- [ ] Run first metrics review meeting
- [ ] Calculate and report ROI to management

#### Long-Term (This Quarter)
- [ ] Schedule and pass GitHub Copilot Certification
- [ ] Expand Copilot to QA and design teams
- [ ] Build library of prompt templates
- [ ] Achieve 30%+ acceptance rate
- [ ] Document case studies and best practices

---

## Resources

### Official Documentation
- [GitHub Copilot Docs](https://docs.github.com/copilot)
- [Model Context Protocol Spec](https://modelcontextprotocol.io)
- [GitHub Copilot Enterprise](https://docs.github.com/copilot/copilot-enterprise)

### MCP Servers
- [Blender MCP](https://github.com/wonderunit/blender-mcp)
- [Context7 MCP](https://github.com/context7/mcp-server)
- [Azure MCP](https://github.com/azure/azure-mcp)

### Training & Certification
- [GitHub Skills](https://skills.github.com)
- [Microsoft Learn - Copilot](https://learn.microsoft.com/training/github/)
- [Certification Exam](https://examregistration.github.com/certification/copilot)

### Tools & Extensions
- [GitHub Copilot VS Code Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [Copilot CLI](https://githubnext.com/projects/copilot-cli)

### Community
- [GitHub Community Discussions](https://github.com/community)
- [r/githubcopilot](https://reddit.com/r/githubcopilot)

---

## Appendix: Quick Reference

### Copilot Keyboard Shortcuts (VS Code)

| Action | Windows/Linux | macOS |
|--------|---------------|-------|
| Accept suggestion | `Tab` | `Tab` |
| Dismiss suggestion | `Esc` | `Esc` |
| Next suggestion | `Alt+]` | `Option+]` |
| Previous suggestion | `Alt+[` | `Option+[` |
| Open Copilot Chat | `Ctrl+Shift+I` | `Cmd+Shift+I` |
| Inline chat | `Ctrl+I` | `Cmd+I` |

### Copilot Chat Slash Commands

| Command | Purpose |
|---------|---------|
| `/explain` | Explain selected code |
| `/fix` | Suggest fixes for problems |
| `/tests` | Generate unit tests |
| `/help` | Get help with Copilot |
| `/clear` | Clear chat history |
| `@workspace` | Include workspace context |
| `/model:<name>` | Select specific model |

### CORE Prompt Template

```
@workspace [TASK DESCRIPTION]

CONTEXT:
- [Current state of code]
- [Relevant files and their purposes]
- [Constraints or existing patterns]

OBJECTIVE:
[What you want to achieve, specific and measurable]

REQUIREMENTS:
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

EXAMPLES:
```[language]
// Expected usage or API
[code example]
```

FILES TO MODIFY/CREATE:
- [file1.hpp] - [what changes]
- [file2.cpp] - [what changes]
```

---

**End of Expert Workshop**

Congratulations on completing the GitHub Copilot Expert Workshop! 🎉

You now have the skills to:
- Configure enterprise-grade Copilot setups
- Build custom MCP servers for game dev
- Optimize costs and measure ROI
- Pass the GitHub Copilot Certification

Go forth and code with AI superpowers! 🚀
