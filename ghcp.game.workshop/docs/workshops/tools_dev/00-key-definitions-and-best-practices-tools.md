# GitHub Copilot Workshop Series
## Key Definitions & Best Practices for AI-Assisted C++ Game Tool Development

**Workshop Series**: AI-Assisted C++ Tool Development with GitHub Copilot  
**Project Reference**: Urban Survivor Game Development Tools (Model Viewer & Asset Browser)  
**Tech Stack**: C++17, SDL2, OpenGL, ImGui, Assimp, CMake  
**Date**: January 2026

---

## Table of Contents
1. [Key Definitions](#key-definitions)
2. [Best Practices for AI-Assisted C++ Tool Development](#best-practices-for-ai-assisted-c-tool-development)
3. [Workshop Series Overview](#workshop-series-overview)

---

## Key Definitions

### What is GitHub Copilot?

**GitHub Copilot** is an AI-powered coding assistant developed by GitHub and OpenAI that provides real-time code suggestions directly in your IDE. It acts as a "pair programmer" that understands context from your codebase, comments, and file structures to generate relevant code completions.

**Key Capabilities:**
- Inline code completions (single line to entire functions)
- Chat-based interactions for explanations and debugging
- Code review and refactoring suggestions
- Multi-file context awareness
- Support for 100+ programming languages including C++, Python, and CMake

**In C++ Tool Development Context (Urban Survivor Tools Example):**
```cpp
// Copilot understands ImGui patterns when you write:
void AssetBrowserApp::renderAssetGrid() {
    // Copilot suggests appropriate ImGui table/grid layout
    ImGui::BeginTable("##asset_grid", columns, 
        ImGuiTableFlags_ScrollY | ImGuiTableFlags_BordersOuter);
    
    for (const auto& asset : m_database->getAssets()) {
        ImGui::TableNextColumn();
        renderAssetThumbnail(asset);
    }
    ImGui::EndTable();
}
```

---

### What is an MCP Server?

**MCP (Model Context Protocol) Server** is an open standard that allows AI assistants like GitHub Copilot to connect to external tools, APIs, and data sources. MCP Servers extend Copilot's capabilities beyond code generation.

**Architecture:**
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  GitHub Copilot │◄───►│   MCP Server    │◄───►│ External Service│
│     (Host)      │     │   (Bridge)      │     │  (Data/Tools)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

**Examples of MCP Servers for Tool Development:**
- **Build System MCP**: Manage CMake configurations and builds
- **Package Manager MCP**: Install vcpkg dependencies
- **Asset Pipeline MCP**: Convert FBX to GLB, compress textures
- **Documentation MCP**: Query SDL2/ImGui/Assimp documentation

**Tool Dev Use Case:**
```
User: "Add support for loading OBJ files to the Model Viewer"
Copilot → Assimp Docs MCP → Assimp::Importer API → Code generation
```

---

### What are Custom Agents?

**Custom Agents** are specialized AI personas defined in markdown files that provide domain-specific expertise. They act as virtual team members with focused knowledge areas.

**Structure** (`.github/agents/` folder):
```markdown
---
name: 'imgui-expert'
description: 'Expert in ImGui layout, widgets, and immediate mode GUI patterns'
---

You are an ImGui specialist for the Urban Survivor tools suite.

**Expertise:**
- Window management, docking, viewports
- Table layouts, tree views, custom widgets
- Input handling, drag-and-drop
- Performance optimization (BeginDisabled, IsItemVisible)
- Integration with OpenGL textures

**Reference Files:**
- tools/common/Application.cpp (ImGui initialization)
- tools/asset_browser/AssetBrowserApp.cpp (complex layouts)
- external/imgui/imgui.h (API reference)
```

**Urban Survivor Tools Agents:**
| Agent | Expertise |
|-------|-----------|
| `@imgui-expert` | ImGui layouts, widgets, docking |
| `@opengl-renderer` | OpenGL rendering, shaders, textures |
| `@assimp-loader` | 3D model loading, mesh processing |
| `@cmake-build` | CMake configuration, dependencies |
| `@filesystem-utils` | Cross-platform file operations |

---

### What are Prompt Files?

**Prompt Files** are reusable templates (`.prompt.md`) that define structured workflows for common development tasks. They ensure consistency and encode best practices.

**Structure** (`.github/prompts/` folder):
```markdown
---
agent: 'imgui-expert'
description: 'Add a file browser dialog to the Asset Browser'
---

You are implementing a file browser dialog using ImGui.

**Context to load:**
- tools/asset_browser/AssetBrowserApp.hpp
- tools/common/FileSystem.hpp
- external/imgui/imgui.h (Search: "Selectable", "TreeNode")

**Implementation requirements:**
1. Create renderFileBrowser() method in AssetBrowserApp
2. Use ImGui::BeginChild for scrollable region
3. Render directory tree with ImGui::TreeNode
4. Make files selectable with ImGui::Selectable
5. Support keyboard navigation (arrow keys, Enter)
6. Emit callback when file is selected

**Test plan:**
- [ ] Dialog renders in modal popup
- [ ] Navigate folders using TreeNode expand/collapse
- [ ] Select file updates m_selectedAsset
- [ ] ESC closes dialog, Enter confirms
```

**Example Prompts for Tool Development:**
- `add-model-loader-support.prompt.md`
- `implement-thumbnail-cache.prompt.md`
- `create-imgui-docking-layout.prompt.md`
- `debug-opengl-rendering.prompt.md`

---

### What and Why is an Instruction File?

**Instruction Files** (`.instructions.md`) are persistent rules that automatically apply to specific file patterns. Unlike prompt files (invoked manually), instructions are **always active** when editing matching files.

**Why Use Instruction Files?**
1. **Consistency**: Every C++ file follows the same patterns
2. **Error Prevention**: Rules prevent common mistakes
3. **Onboarding**: New developers (and AI) learn standards automatically
4. **Library-Specific**: Different rules for ImGui, OpenGL, Assimp

**Structure** (`.github/instructions/` folder):
```markdown
---
description: 'C++ tool development rules for Urban Survivor tools'
applyTo: 'tools/**/*.{cpp,hpp}'
---

**Must read before edits:**
- tools/README.md
- tools/ROADMAP.md

**Code organization:**
- Use namespace tools for all tool code
- Header guards: #pragma once (not #ifndef)
- Forward declare when possible to reduce compile time

**ImGui patterns:**
- Always pair Begin/End calls (BeginChild/EndChild, BeginTable/EndTable)
- Use unique IDs with ## prefix for internal widgets
- Cache window sizes/positions in member variables

**OpenGL safety:**
- Check for GL errors after context operations
- Clean up resources in destructors (glDelete*)
- Use RAII wrappers for textures/buffers

**Performance:**
- Avoid allocations in onUpdate/onImGuiRender (runs every frame)
- Use const references for large objects
- Profile before optimizing (use Tracy/Optick)

**Never modify:**
- external/ directory (third-party code)
- CMakeLists.txt without testing build
```

---

### What is Chain of Thought Prompting?

**Chain of Thought (CoT) Prompting** is a technique where you guide the AI to reason through a problem step-by-step before generating code. This improves accuracy for complex tasks.

**Without CoT (Direct Request):**
```
"Add thumbnail generation to AssetBrowser"
```

**With CoT (Step-by-Step Reasoning):**
```
"I need to add thumbnail generation to AssetBrowser. Let's think through this:

1. When do we generate thumbnails? (On directory scan, on demand, or cached?)
2. What formats need thumbnails? (Images: PNG/JPG, Models: rendered preview)
3. How do we render 3D model thumbnails? (Offscreen FBO, headless OpenGL)
4. Where do we cache thumbnails? (~/.urban_survivor/cache/thumbnails/)
5. How do we handle cache invalidation? (Compare file modification time)

Now implement step 1: add thumbnail generation trigger in AssetDatabase::scan()."
```

**Benefits for Tool Development:**
- Complex rendering pipelines become tractable
- Algorithm design before implementation
- Debugging by reasoning through expected vs. actual behavior

---

### What is Few-Shot Prompting?

**Few-Shot Prompting** provides examples of the desired input→output pattern before making your actual request. This teaches the AI the expected format and style.

**Zero-Shot (No Examples):**
```
"Create a new tool application class"
```

**Few-Shot (With Examples):**
```
"Here's how we structure tool applications in Urban Survivor:

Example 1 - Model Viewer:
class ModelViewerApp : public Application {
protected:
    void onInit() override;
    void onUpdate(float deltaTime) override;
    void onImGuiRender() override;
private:
    std::unique_ptr<Camera> m_camera;
    std::unique_ptr<Renderer> m_renderer;
};

Example 2 - Asset Browser:
class AssetBrowserApp : public Application {
protected:
    void onInit() override;
    void onUpdate(float deltaTime) override;
    void onImGuiRender() override;
private:
    std::unique_ptr<AssetDatabase> m_database;
    std::unique_ptr<ThumbnailGenerator> m_thumbnailGenerator;
};

Now create a new ShaderEditorApp following the same pattern.
Include: shader compiler, error panel, and live preview."
```

**Result:**
```cpp
class ShaderEditorApp : public Application {
protected:
    void onInit() override;
    void onUpdate(float deltaTime) override;
    void onImGuiRender() override;
private:
    std::unique_ptr<ShaderCompiler> m_compiler;
    std::unique_ptr<ErrorPanel> m_errorPanel;
    std::unique_ptr<LivePreview> m_preview;
};
```

---

### What is Tree of Thoughts Prompting?

**Tree of Thoughts (ToT) Prompting** explores multiple solution paths simultaneously, evaluating each before selecting the best approach. It's ideal for design decisions with trade-offs.

**Example - Thumbnail Cache Strategy:**
```
"I need to decide how to cache thumbnails for AssetBrowser.

Branch A: In-memory only
- Pros: Fast access, no disk I/O
- Cons: Lost on restart, memory usage grows

Branch B: Disk cache with LRU eviction
- Pros: Persistent, bounded memory
- Cons: Disk I/O overhead, cache invalidation complexity

Branch C: Hybrid (hot cache in memory, warm cache on disk)
- Pros: Best performance for recent assets
- Cons: More code to maintain

Evaluate each branch against Urban Survivor tools requirements:
- Tool starts/stops frequently during development
- Asset library ~5000 models, ~10,000 textures
- Target machines: 8GB RAM minimum

Recommendation: Branch B with mmap for cache file because..."
```

---

### What is Self-Consistency Prompting?

**Self-Consistency Prompting** generates multiple independent solutions to the same problem, then selects the most common or highest-quality answer. This reduces errors on complex tasks.

**Example - OpenGL Texture Loading Validation:**
```
"Implement OpenGL texture loading for thumbnails three different ways:

Method 1: Using stb_image directly
Method 2: Using Assimp's embedded texture loader
Method 3: Manual file reading + format detection

For each method, address:
- Error handling (corrupt files, unsupported formats)
- Memory management (who owns the pixel data?)
- OpenGL texture parameters (mipmaps, filtering)

Compare results. Which method is most robust and maintainable?"
```

**Why Use Self-Consistency?**
- Catches API misuse errors
- Validates complex OpenGL state management
- Increases confidence in rendering code

---

## Best Practices for AI-Assisted C++ Tool Development

### 1. Project Structure & Context

#### Establish Clear Documentation Hierarchy
```
tools/
├── README.md              # Quick start guide
├── ROADMAP.md             # Development timeline
├── CMakeLists.txt         # Build configuration
├── common/                # Shared utilities
│   ├── Application.{hpp,cpp}
│   ├── FileSystem.{hpp,cpp}
│   └── Logger.{hpp,cpp}
├── asset_browser/         # Asset Browser tool
├── model_viewer/          # Model Viewer tool
└── external/              # Third-party deps (NEVER modify)
```

#### Maintain a Development Log
Create `tools/DEVELOPMENT.md` for architectural decisions:
```markdown
## 2026-01-15: ImGui Docking Layout

**Decision**: Use ImGui::DockSpaceOverViewport() instead of manual docking
**Rationale**: Automatic layout saving, user customization support
**Trade-off**: Requires ImGui docking branch (already in external/)
**Affected files**: Application.cpp, AssetBrowserApp.cpp
**Commit**: abc123f
```

---

### 2. Prompt Engineering for Tool Dev

#### Be Specific About Libraries and Patterns
❌ Vague: "Add a camera"
✅ Specific: "Create an orbital Camera class using GLM for math. Implement orbit(deltaYaw, deltaPitch), pan(deltaX, deltaY), and zoom(delta). Store position, target, up vectors. Provide getViewMatrix() returning glm::mat4."

#### Include File Context in Prompts
```
"Looking at tools/common/Application.hpp and tools/model_viewer/Camera.hpp,
implement mouse input handling in ModelViewerApp::onUpdate():
1. Left mouse drag → m_camera->orbit(deltaX, deltaY)
2. Middle mouse drag → m_camera->pan(deltaX, deltaY)
3. Scroll wheel → m_camera->zoom(delta)
Use SDL_GetMouseState() for button checks."
```

#### Reference External Library Documentation
```
"According to ImGui documentation (imgui.h:2847), ImGui::BeginTable
requires matching ImGui::EndTable. Implement renderAssetGrid() with:
- BeginTable with ImGuiTableFlags_ScrollY
- Dynamic column count based on window width / thumbnail size
- TableNextColumn for each asset
- EndTable at function end"
```

---

### 3. Code Generation Patterns

#### Use Instruction Files for Language-Specific Rules
Create `.github/instructions/` files:
- `cpp-tools.instructions.md` → `tools/**/*.{cpp,hpp}`
- `cmake.instructions.md` → `**/CMakeLists.txt`
- `imgui.instructions.md` → `tools/**/*App.{cpp,hpp}`

#### Leverage Custom Agents for Specialized Tasks
```
@imgui-expert implement the AssetBrowser docking layout
@opengl-renderer add wireframe rendering mode to ModelViewer
@cmake-build add vcpkg integration for Assimp dependency
```

#### Create Prompt Files for Repeatable Tasks
Common tool dev prompts:
- `add-new-tool.prompt.md` (scaffold new tool application)
- `implement-imgui-panel.prompt.md` (standard panel template)
- `add-file-format-support.prompt.md` (extend loaders)
- `debug-opengl-state.prompt.md` (GL error tracking)

---

### 4. Testing & Validation

#### Always Include Test Plans in Prompts
```
**Test Plan:**
- [ ] Open Model Viewer with sample.glb
- [ ] Left drag rotates camera smoothly
- [ ] Middle drag pans without rotation
- [ ] Scroll zooms in/out with limits (min: 1.0, max: 100.0)
- [ ] Camera resets with 'R' key
```

#### Use Self-Consistency for Critical Systems
For OpenGL rendering, memory management, or file I/O:
```
"Implement thumbnail generation THREE ways and compare:
1. FBO + glReadPixels
2. Headless EGL context
3. stb_image_resize on source

Which approach works on all platforms (Windows/macOS/Linux)?"
```

#### Validate Generated Code Against Build
After generation, run:
```bash
cmake --build build --config Debug
# Check for warnings, errors, linker issues
```

---

### 5. Iterative Development

#### Start Small, Expand Gradually
1. Generate header file with method declarations
2. Implement constructor/destructor only
3. Add one method at a time
4. Test after each method

#### Use Chain of Thought for Complex Features
```
"Let's implement thumbnail generation step by step:
Step 1: Create ThumbnailGenerator class skeleton
Step 2: Add stb_image integration for loading
Step 3: Implement resize algorithm
Step 4: Generate OpenGL texture from resized data
Step 5: Save to cache directory
Step 6: Integrate with AssetDatabase

Start with Step 1..."
```

#### Maintain Session Continuity
Reference previous work:
```
"Earlier we implemented Camera::orbit(). Now add Camera::pan()
using the same coordinate system (screen space delta → world space offset).
Use glm::cross(forward, up) for the right vector."
```

---

### 6. Security & Privacy

#### Never Include Secrets in Context
- API keys, license keys
- User file paths (use relative paths)
- Proprietary algorithms

#### Review Generated Code for Vulnerabilities
Watch for:
- Buffer overruns (`strcpy` → use `std::string`)
- Unbounded loops in UI rendering
- Missing null checks before pointer dereference
- Unsafe file path construction (`../../../etc/passwd`)

---

### 7. Performance Optimization

#### Profile Before Optimizing
```
"The Asset Browser loads 5000 assets in 12 seconds.
Profile AssetDatabase::scan() to identify bottleneck.
Suspect: repeated filesystem::last_write_time() calls."
```

#### Request Tool-Specific Optimizations
```
"Optimize this ImGui rendering code:
- Cache table column widths between frames
- Use ImGuiListClipper for large lists (only render visible items)
- Batch texture binds (group by GL texture ID)
- Avoid string allocations (use ImGui::TextUnformatted)"
```

---

### 8. Collaboration Workflow

#### Use Prompt Files for Team Consistency
Team members invoke the same prompts:
```
/.github/prompts/add-new-tool.prompt.md
```

#### Document Decisions in DEVELOPMENT.md
```
@doc-maintainer add entry for the new thumbnail cache:
- Cache location: ~/.urban_survivor/tools/thumbnails/
- Format: PNG 256x256
- Invalidation: compare file mtime
```

#### Review Before Merge
```
@code-reviewer review tools/asset_browser/ThumbnailGenerator.cpp
Focus on: memory leaks, OpenGL state, error handling
```

---

### 9. C++ Specific Best Practices

#### Modern C++ Patterns
```cpp
// Use smart pointers, not raw pointers
std::unique_ptr<Renderer> m_renderer;  // ✅
Renderer* m_renderer;                  // ❌

// Use const references for parameters
void load(const std::string& path);    // ✅
void load(std::string path);           // ❌

// Use nullptr, not NULL
if (ptr == nullptr) { }                // ✅
if (ptr == NULL) { }                   // ❌

// Use override keyword
void onUpdate(float dt) override;      // ✅
virtual void onUpdate(float dt);       // ❌
```

#### ImGui Best Practices
```cpp
// Always pair Begin/End
if (ImGui::BeginTable("##table", 3)) {
    // ... render table ...
    ImGui::EndTable();  // Must call!
}

// Use unique IDs with ##
ImGui::Button("Delete##asset_123");  // ✅ Unique
ImGui::Button("Delete");             // ❌ Conflicts

// Check return values
if (ImGui::Button("Load")) {
    // Only runs when clicked
}
```

#### OpenGL Safety
```cpp
// Check errors after GL calls
GLuint texture;
glGenTextures(1, &texture);
GLenum error = glGetError();
if (error != GL_NO_ERROR) {
    Logger::error("Failed to create texture: {}", error);
}

// RAII for GL resources
class Texture {
    GLuint m_id;
public:
    Texture() { glGenTextures(1, &m_id); }
    ~Texture() { glDeleteTextures(1, &m_id); }
    // Delete copy, allow move
};
```

---

### 10. Build System Integration

#### CMake Best Practices
```cmake
# Use target-based approach
add_executable(model_viewer main.cpp ModelViewerApp.cpp)
target_link_libraries(model_viewer PRIVATE 
    tools_common
    SDL2::SDL2
    imgui
    assimp
)

# Set C++ standard
target_compile_features(model_viewer PRIVATE cxx_std_17)

# Add compile warnings
if(MSVC)
    target_compile_options(model_viewer PRIVATE /W4)
else()
    target_compile_options(model_viewer PRIVATE -Wall -Wextra)
endif()
```

#### Dependency Management
```
"Add Assimp dependency to tools/CMakeLists.txt:
1. Use find_package(assimp REQUIRED)
2. Link against assimp::assimp target
3. If not found, print message to install via vcpkg
4. Test build on Windows and macOS"
```

---

## Workshop Series Overview

| Level | Duration | Focus |
|-------|----------|-------|
| **[Foundational](01-foundational-workshop-tools.md)** | 1 hour | Copilot basics, C++ context, ImGui |
| **[Intermediate](02-intermediate-workshop-tools.md)** | 1 hour | Prompting, OpenGL debugging, CMake |
| **[Advanced](03-advanced-workshop-tools.md)** | 1 hour | Instruction files, agents, code review |
| **[Expert](04-expert-workshop-tools.md)** | 1 hour | MCP servers, build automation, CI/CD |

---

## Common Tool Development Scenarios

### Scenario 1: Add New File Format Support
```
User: "Add FBX support to Model Viewer"

Steps:
1. Check Assimp documentation for FBX import
2. Add file extension to FileSystem::isModelFile()
3. Test loading with sample FBX file
4. Handle FBX-specific quirks (Y-up vs Z-up)
```

### Scenario 2: Implement New ImGui Panel
```
User: "Add a material inspector panel to Model Viewer"

Steps:
1. Create MaterialInspector.{hpp,cpp}
2. Add renderMaterialInspector() method
3. Display: albedo color, roughness, metallic, textures
4. Use ImGui::ColorEdit3, ImGui::SliderFloat
5. Update in ModelViewerApp::onImGuiRender()
```

### Scenario 3: Optimize Rendering Performance
```
User: "Model Viewer is slow with high poly models (>1M tris)"

Steps:
1. Profile with GPU debugger (RenderDoc)
2. Identify bottleneck (draw calls? state changes?)
3. Implement solutions:
   - Frustum culling
   - Level of detail (LOD)
   - Instanced rendering for duplicates
4. Re-profile to verify improvement
```

### Scenario 4: Cross-Platform Build Issue
```
User: "Asset Browser builds on Windows but fails on macOS"

Steps:
1. Check error message (linker? runtime?)
2. Verify CMakeLists.txt platform detection
3. Check library paths (Framework vs .dylib)
4. Test with macOS-specific flags
5. Document in README.md
```

---

## Code Style Examples

### Application Lifecycle Pattern
```cpp
class NewToolApp : public Application {
public:
    NewToolApp(const Config& config) : Application(config) {}
    ~NewToolApp() override = default;

protected:
    // Called once after OpenGL context is ready
    void onInit() override {
        // Load resources, create GL objects
        m_renderer = std::make_unique<Renderer>();
    }

    // Called every frame before rendering
    void onUpdate(float deltaTime) override {
        // Update logic (camera, animation)
        m_camera->update(deltaTime);
    }

    // Called every frame for ImGui rendering
    void onImGuiRender() override {
        renderMenuBar();
        renderMainPanel();
        renderSidePanel();
    }

    // Called when window resizes
    void onResize(int width, int height) override {
        m_camera->setAspect(float(width) / height);
    }

    // Called when file is dropped onto window
    void onFileDrop(const std::string& path) override {
        loadFile(path);
    }

    // Called once before shutdown
    void onShutdown() override {
        // Cleanup resources
        m_renderer.reset();
    }

private:
    std::unique_ptr<Camera> m_camera;
    std::unique_ptr<Renderer> m_renderer;
};
```

### ImGui Docking Layout Pattern
```cpp
void AssetBrowserApp::onImGuiRender() {
    // Create dockspace over main viewport
    ImGuiID dockspace_id = ImGui::DockSpaceOverViewport(
        ImGui::GetMainViewport(),
        ImGuiDockNodeFlags_PassthruCentralNode
    );

    // First time setup: create default layout
    static bool first_time = true;
    if (first_time) {
        first_time = false;
        
        ImGui::DockBuilderRemoveNode(dockspace_id);
        ImGui::DockBuilderAddNode(dockspace_id, ImGuiDockNodeFlags_DockSpace);
        
        ImGuiID dock_left = ImGui::DockBuilderSplitNode(
            dockspace_id, ImGuiDir_Left, 0.2f, nullptr, &dockspace_id
        );
        ImGuiID dock_right = ImGui::DockBuilderSplitNode(
            dockspace_id, ImGuiDir_Right, 0.25f, nullptr, &dockspace_id
        );
        
        ImGui::DockBuilderDockWindow("Directory Tree", dock_left);
        ImGui::DockBuilderDockWindow("Asset Grid", dockspace_id);
        ImGui::DockBuilderDockWindow("Preview", dock_right);
        
        ImGui::DockBuilderFinish(dockspace_id);
    }

    // Render docked windows
    renderDirectoryTree();  // Window: "Directory Tree"
    renderAssetGrid();      // Window: "Asset Grid"
    renderPreviewPanel();   // Window: "Preview"
}
```

### Error Handling Pattern
```cpp
bool ModelLoader::load(const std::string& path) {
    if (!FileSystem::exists(path)) {
        Logger::error("File not found: {}", path);
        return false;
    }

    Assimp::Importer importer;
    const aiScene* scene = importer.ReadFile(path, 
        aiProcess_Triangulate | 
        aiProcess_GenNormals |
        aiProcess_FlipUVs
    );

    if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE) {
        Logger::error("Assimp error: {}", importer.GetErrorString());
        return false;
    }

    if (scene->mNumMeshes == 0) {
        Logger::warn("Model has no meshes: {}", path);
        return false;
    }

    // Process scene...
    processMeshes(scene);
    return true;
}
```

---

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Model Context Protocol Spec](https://modelcontextprotocol.io)
- [ImGui Documentation](https://github.com/ocornut/imgui)
- [SDL2 Wiki](https://wiki.libsdl.org/)
- [Assimp Documentation](https://assimp.sourceforge.net/lib_html/index.html)
- [Learn OpenGL](https://learnopengl.com/)
- [CMake Documentation](https://cmake.org/cmake/help/latest/)
- [Urban Survivor Tools README](../../tools/README.md)
- [Urban Survivor Tools Roadmap](../../tools/ROADMAP.md)

---

## Quick Reference: Prompting Templates

### Template 1: Add New Feature
```
"Add [FEATURE] to [TOOL_NAME]:

Context files to read:
- tools/[TOOL]/[CLASS].hpp
- tools/common/[UTILITY].hpp

Requirements:
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

Libraries to use:
- [Library]: [Specific API]

Test plan:
- [ ] [Test 1]
- [ ] [Test 2]
"
```

### Template 2: Debug Issue
```
"Debug [ISSUE] in [TOOL_NAME]:

Error message:
```
[ERROR_TEXT]
```

Suspected cause: [HYPOTHESIS]

Files involved:
- tools/[FILE1]
- tools/[FILE2]

Debugging steps:
1. Check [ASPECT_1]
2. Verify [ASPECT_2]
3. Test with [SCENARIO]
"
```

### Template 3: Optimize Performance
```
"Optimize [SYSTEM] in [TOOL_NAME]:

Current performance:
- [METRIC]: [VALUE] (target: [TARGET])

Profiling shows:
- [BOTTLENECK_1]: [PERCENTAGE]%
- [BOTTLENECK_2]: [PERCENTAGE]%

Optimization strategies to try:
1. [STRATEGY_1]
2. [STRATEGY_2]

Constraints:
- Maintain [REQUIREMENT]
- Don't break [FUNCTIONALITY]
"
```

---

*Last Updated: January 2026*
*Project: Urban Survivor Game Development Tools*
*Tech Stack: C++17, SDL2, OpenGL, ImGui, Assimp, CMake*
