# Workshop 2: Intermediate
## Prompting, Chat, and Code Generation Mastery

**Duration**: 1 Hour  
**Level**: Intermediate  
**Prerequisites**: Foundational Workshop  
**Project**: Urban Survivor Game Dev Tools (C++ Desktop Applications)

---

## Workshop Objectives

By the end of this workshop, participants will:
- Write effective prompts for complex code generation
- Use inline code suggestions efficiently
- Get meaningful code explanations from Copilot
- Generate code from descriptive comments
- Refactor existing code with AI assistance
- Apply Few-Shot prompting techniques
- Generate unit tests and debug with Copilot
- Use Copilot CLI for command-line workflows

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:08 | Inline Code Suggestions | Demo + Practice |
| 0:08 - 0:16 | Prompting Fundamentals | Presentation |
| 0:16 - 0:24 | Code Explanations | Hands-On |
| 0:24 - 0:32 | Comment-Based Generation | Live Coding |
| 0:32 - 0:40 | Code Refactoring | Exercise |
| 0:40 - 0:46 | Copilot Chat Deep Dive | Demo |
| 0:46 - 0:52 | Few-Shot Prompting | Practice |
| 0:52 - 0:58 | Unit Testing & Debugging | Live Demo |
| 0:58 - 1:00 | Copilot CLI & Privacy | Quick Tour |

---

## Session 1: Inline Code Suggestions (8 min)

### Learning Objectives
- Maximize inline suggestion quality
- Navigate between alternative suggestions
- Understand ghost text vs. panel suggestions

### Inline Suggestion Types

**Ghost Text (Inline):**
```cpp
void Camera::update(float deltaTime) {
    if (m_orbitEnabled && m_distance > m_minDistance) {
        m_distance -= scroll_delta * m_zoomSpeed; // Copilot shows gray text here
    }
}
```

**Suggestion Panel (Multiple Options):**
Press `Ctrl+Enter` to see the Copilot panel with 5-10 alternatives.

### Keyboard Shortcuts Reference

| Action | VS Code Shortcut | Description |
|--------|------------------|-------------|
| Accept suggestion | `Tab` | Accept ghost text |
| Accept word | `Ctrl+→` | Accept next word only |
| Accept line | `Ctrl+Enter` then select | Choose from panel |
| Next suggestion | `Alt+]` | Cycle alternatives |
| Previous suggestion | `Alt+[` | Cycle back |
| Dismiss | `Esc` | Clear suggestion |
| Trigger manually | `Alt+\` | Force suggestion |

### Hands-On Exercise (4 min)

**File**: `tools/model_viewer/Camera.cpp`

```cpp
// Task: Complete the camera zoom behavior
void Camera::handleInput(float deltaTime) {
    // 1. Type this, wait for suggestion
    if (mouse_scroll_delta != 0.0f) {
        // 2. Copilot suggests zoom logic
    }
    
    // 3. Use Alt+] to see alternative implementations
    // 4. Accept the best one with Tab
}
```

**Observe:**
- How does the suggestion change based on member variable names like `m_distance`, `m_zoomSpeed`?
- Do alternatives differ in zoom speed calculation or clamping approaches?
- Try renaming variables to see how context affects suggestions

---

## Session 2: Prompting Fundamentals (8 min)

### Learning Objectives
- Structure prompts for optimal results
- Use the CORE prompting framework
- Apply prompting to C++ desktop tool development

### The CORE Prompting Framework

| Element | Description | Example |
|---------|-------------|---------|
| **C**ontext | Background information | "In our C++17 Model Viewer using SDL2/OpenGL/ImGui..." |
| **O**bjective | What you want | "Implement model bounding box calculation" |
| **R**equirements | Constraints and specifics | "Must use Assimp aiMesh, return BoundingBox struct" |
| **E**xamples | Input/output patterns | "Similar to existing focusOnBounds() method" |

### Game Dev Tools Prompting Examples

**Basic Prompt:**
```
Add a file picker to the model viewer
```

**CORE-Enhanced Prompt:**
```
Context: Model Viewer is a C++17 desktop application using SDL2 for windowing,
OpenGL for rendering, and ImGui for UI. The ModelViewerApp class extends Application
and has a loadModel() method that loads 3D models via Assimp.

Objective: Implement showOpenFileDialog() in tools/model_viewer/ModelViewerApp.cpp
to let users select model files.

Requirements:
- Use native Windows file dialog (OPENFILENAME on Windows)
- Filter for supported formats: .gltf, .glb, .fbx, .obj, .dae
- Set initial directory to "../import_glb"
- On successful selection, call loadModel() with the chosen path
- Show error message via Logger if file cannot be opened

Example from existing code:
if (FileSystem::exists(path)) {
    Logger::info("Loading model: {}", path);
}
```

### Prompting Tips for C++ Tool Development

**1. Reference Framework APIs:**
```
Using ImGui tables API (not the old Columns API), create a property grid...
```

**2. Specify C++ Standard:**
```
Using C++17 features (std::filesystem, std::optional), implement...
```

**3. Include Performance Constraints:**
```
Must generate thumbnails asynchronously to avoid UI freezing
```

**4. Describe Integration Points:**
```
This method will be called from renderMenuBar() when File > Open is clicked.
It should update m_currentModelPath and call m_meshInspector->setModel().
```

---

## Session 3: Code Explanations (8 min)

### Learning Objectives
- Get explanations of complex code sections
- Understand unfamiliar C++ patterns and OpenGL/ImGui APIs
- Use explanations for learning and documentation

### Copilot Chat Commands for Explanations

| Command | Use Case |
|---------|----------|
| `/explain` | Explain selected code |
| `@workspace /explain` | Explain with project context |
| Ask directly | "What does this camera orbit code do?" |

### Demo: Explaining Camera Orbit Implementation

**Select this code from `tools/model_viewer/Camera.cpp` and use `/explain`:**

```cpp
void Camera::updateOrbit() {
    // Convert spherical coordinates to Cartesian
    float x = m_distance * cos(m_pitch) * sin(m_yaw);
    float y = m_distance * sin(m_pitch);
    float z = m_distance * cos(m_pitch) * cos(m_yaw);
    
    m_position = m_target + glm::vec3(x, y, z);
    m_up = glm::vec3(0.0f, 1.0f, 0.0f);
}
```

**Expected Copilot Explanation:**
```
This method implements an orbit camera using spherical coordinates:

1. Converts spherical coords (yaw, pitch, distance) to Cartesian (x, y, z)
2. Calculates camera position relative to the target/pivot point
3. Uses standard spherical-to-Cartesian formulas:
   - x = ρ·cos(φ)·sin(θ)  where ρ=distance, φ=pitch, θ=yaw
   - y = ρ·sin(φ)
   - z = ρ·cos(φ)·cos(θ)
4. Adds offset to m_target to get final camera position
5. Sets up-vector for proper camera orientation

This allows smooth camera rotation around a 3D model without gimbal lock.
```

### Hands-On Exercise (4 min)

**Task**: Use Copilot Chat to explain this Asset Database scanning code:

```cpp
void AssetDatabase::scan(const std::filesystem::path& root, bool recursive) {
    if (!std::filesystem::exists(root)) {
        Logger::error("Directory not found: {}", root.string());
        return;
    }
    
    clear();
    
    auto iterator = recursive 
        ? std::filesystem::recursive_directory_iterator(root)
        : std::filesystem::directory_iterator(root);
    
    for (const auto& entry : iterator) {
        if (entry.is_regular_file()) {
            AssetInfo info;
            info.path = entry.path();
            info.name = entry.path().filename().string();
            info.extension = entry.path().extension().string();
            info.size = entry.file_size();
            info.type = classifyAsset(entry.path());
            
            m_assets.push_back(info);
            m_pathIndex[info.path.string()] = m_assets.size() - 1;
        }
    }
    
    Logger::info("Scanned {} assets from {}", m_assets.size(), root.string());
}
```

**Questions to Ask Copilot:**
1. "Why is there a separate m_pathIndex in addition to m_assets vector?"
2. "What's the performance benefit of the index for lookups?"
3. "How does recursive vs non-recursive iteration work?"

---

## Session 4: Comment-Based Generation (8 min)

### Learning Objectives
- Write comments that generate accurate code
- Use structured comment patterns
- Guide multi-step implementations

### Comment Patterns That Work

**Pattern 1: Single-Line Intent**
```cpp
// Check if the file extension is a supported 3D model format
bool is_supported = // Copilot completes
```

**Pattern 2: Multi-Line Specification**
```cpp
// Generate a thumbnail for the 3D model:
// 1. Load the model using ModelLoader
// 2. Render to a 256x256 offscreen framebuffer
// 3. Capture the rendered image
// 4. Save as PNG to thumbnails/[model_hash].png
// 5. Return the thumbnail file path
std::string ThumbnailGenerator::generateThumbnail(const std::string& modelPath) {
    // Copilot generates full implementation
}
```

**Pattern 3: Reference Implementation**
```cpp
// Similar to ModelLoader::load() but for texture files.
// Support .png, .jpg, .tga, .bmp using stb_image.
// Return texture ID or 0 on failure.
```

### Live Coding Demo (4 min)

**Task**: Generate a mesh statistics calculator using comments

**File**: `tools/model_viewer/MeshInspector.cpp`

```cpp
// Calculate and display mesh statistics including:
// - Total vertex count across all meshes
// - Total triangle count (faces * 3)
// - Number of materials used
// - Bounding box dimensions
// - Memory footprint estimate
void MeshInspector::calculateStatistics() {
    // Watch Copilot generate the implementation
}
```

### Hands-On Exercise (4 min)

**Create your own comment-driven generation:**

**File**: `tools/asset_browser/FilterPanel.cpp`

```cpp
// Implement asset type filtering
// - Support filtering by: Model, Texture, Audio, Scene, Script, Resource
// - Allow multiple types to be selected simultaneously (checkboxes)
// - Return a vector of selected AssetInfo::Type values
// - Store filter state in member variable m_selectedTypes
// - Emit filter_changed callback when selection changes
std::vector<AssetInfo::Type> FilterPanel::getSelectedTypes() const {
    // Let Copilot generate based on your comments
}
```

---

## Session 5: Code Refactoring (8 min)

### Learning Objectives
- Refactor code using Copilot suggestions
- Apply design patterns with AI assistance
- Improve code quality iteratively

### Refactoring Commands

| Command | Description |
|---------|-------------|
| `/fix` | Fix issues in selected code |
| "Refactor this to use..." | Specific pattern request |
| "Extract method for..." | Method extraction |
| "Optimize for performance" | Performance improvements |

### Demo: Refactoring Model Viewer UI Layout

**Before (Monolithic ImGui Rendering):**
```cpp
void ModelViewerApp::onImGuiRender() {
    // Menu bar
    if (ImGui::BeginMainMenuBar()) {
        if (ImGui::BeginMenu("File")) {
            if (ImGui::MenuItem("Open")) {
                showOpenFileDialog();
            }
            if (ImGui::MenuItem("Exit")) {
                quit();
            }
            ImGui::EndMenu();
        }
        // ... 50+ lines of menu items
        ImGui::EndMainMenuBar();
    }
    
    // Toolbar
    ImGui::Begin("Toolbar");
    // ... 80+ lines of toolbar buttons
    ImGui::End();
    
    // Viewport
    ImGui::Begin("Viewport");
    // ... 100+ lines of viewport rendering
    ImGui::End();
    
    // Inspector
    ImGui::Begin("Inspector");
    // ... 120+ lines of property display
    ImGui::End();
}
```

**Prompt:**
```
Refactor this ImGui rendering code into separate methods:
- renderMenuBar() for the main menu
- renderToolbar() for toolbar buttons
- renderViewport() for 3D viewport
- renderInspector() for mesh properties
- renderStatusBar() for bottom status info

Each method should handle its own ImGui::Begin/End calls.
Follow the existing pattern in ModelViewerApp.hpp where these methods are declared.
```

**After (Clean, Modular):**
```cpp
void ModelViewerApp::onImGuiRender() {
    if (ImGui::BeginMainMenuBar()) {
        renderMenuBar();
        ImGui::EndMainMenuBar();
    }
    
    renderToolbar();
    renderViewport();
    
    if (m_showInspector) {
        renderInspector();
    }
    
    renderStatusBar();
}

void ModelViewerApp::renderMenuBar() {
    if (ImGui::BeginMenu("File")) {
        if (ImGui::MenuItem("Open", "Ctrl+O")) {
            showOpenFileDialog();
        }
        if (ImGui::MenuItem("Exit", "Alt+F4")) {
            quit();
        }
        ImGui::EndMenu();
    }
    // Clean, focused menu logic
}

void ModelViewerApp::renderViewport() {
    ImGui::Begin("Viewport", nullptr, ImGuiWindowFlags_NoScrollbar);
    // Clean, focused viewport logic
    ImGui::End();
}
```

### Hands-On Exercise (4 min)

**Task**: Refactor this duplicated file dialog code:

**Current**: Repeated platform-specific code in multiple places

```cpp
// In ModelViewerApp::showOpenFileDialog()
#ifdef _WIN32
    OPENFILENAME ofn;
    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    // ... 20 lines of setup
    if (GetOpenFileName(&ofn)) {
        loadModel(szFile);
    }
#endif

// In AssetBrowserApp::showOpenFolderDialog()
#ifdef _WIN32
    OPENFILENAME ofn;
    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    // ... similar 20 lines
    if (GetOpenFileName(&ofn)) {
        openDirectory(szFile);
    }
#endif
```

**Prompt to try:**
```
Extract a reusable showFileDialog() utility function to tools/common/FileSystem.hpp:
- Parameters: title, filter, initialDir, callback function
- Handle Windows OPENFILENAME internally
- Return selected path as std::optional<std::string>
- Add support for folder selection via BROWSEINFO

Usage:
auto path = FileSystem::showFileDialog("Open Model", "*.gltf;*.glb", "../import_glb");
if (path) loadModel(*path);
```

---

## Session 6: Copilot Chat Deep Dive (6 min)

### Learning Objectives
- Master Copilot Chat participants (@workspace, @vscode)
- Use slash commands effectively
- Create multi-turn conversations for complex tasks

### Chat Participants

| Participant | Purpose | Example |
|-------------|---------|---------|
| `@workspace` | Project-wide context | "@workspace how are thumbnails generated?" |
| `@vscode` | Editor commands | "@vscode how do I set up C++ debugging?" |
| `@terminal` | Terminal help | "@terminal cmake build release command" |

### Slash Commands

| Command | Description |
|---------|-------------|
| `/explain` | Explain selected code |
| `/fix` | Fix problems in selection |
| `/tests` | Generate unit tests |
| `/doc` | Generate documentation |
| `/new` | Scaffold new code |
| `/clear` | Clear chat history |

### Demo: Multi-Turn Conversation

```
User: @workspace How does the Model Viewer load 3D models?

Copilot: The Model Viewer uses Assimp library for loading:
1. ModelLoader::load() is called with file path
2. Assimp's aiImportFile() reads the model
3. Meshes are extracted from aiScene
4. Vertex data is copied to OpenGL buffers
5. Materials and textures are loaded
6. BoundingBox is calculated from vertices
7. MeshInspector receives the loaded model data

User: Show me where the bounding box calculation happens

Copilot: In tools/model_viewer/ModelLoader.cpp, the getBounds() method:
[shows code with aiMesh iteration and min/max calculation]

User: Can you add support for calculating vertex normals if they're missing?

Copilot: I'll add normal generation using Assimp's postprocessing:
[provides code suggestion with aiProcess_GenNormals flag]
```

### Advanced Chat Features

**Using #file references:**
```
User: In #file:ModelViewerApp.cpp add drag-and-drop support
similar to how #file:AssetBrowserApp.cpp handles onFileDrop
```

**Referencing specific lines:**
```
User: Optimize the loop in ModelLoader.cpp:145-167 for better cache locality
```

---

## Session 7: Few-Shot Prompting (6 min)

### Learning Objectives
- Use examples to guide generation style
- Create consistent code patterns
- Apply few-shot for framework-specific conventions

### What is Few-Shot Prompting?

Provide 2-3 examples of the pattern you want, then request a new instance.

### Demo: ImGui Window Pattern Consistency

```
I need to add new ImGui panels to the Asset Browser following our project pattern.

Example 1 - Existing renderDirectoryTree():
void AssetBrowserApp::renderDirectoryTree() {
    ImGui::Begin("Directory Tree", nullptr, ImGuiWindowFlags_NoCollapse);
    // Tree logic here
    ImGui::End();
}

Example 2 - Existing renderAssetGrid():
void AssetBrowserApp::renderAssetGrid() {
    ImGui::Begin("Asset Grid", &m_showGrid, ImGuiWindowFlags_NoScrollbar);
    // Grid logic here
    ImGui::End();
}

Example 3 - Existing renderPreviewPanel():
void AssetBrowserApp::renderPreviewPanel() {
    ImGui::Begin("Preview", &m_showPreview);
    // Preview logic here
    ImGui::End();
}

Now create:
1. renderSearchPanel() - for advanced asset search
2. renderBookmarksPanel() - for favorite directories
3. renderHistoryPanel() - for recently opened files
```

**Result:**
```cpp
void AssetBrowserApp::renderSearchPanel() {
    ImGui::Begin("Search", &m_showSearch, ImGuiWindowFlags_AlwaysAutoResize);
    // Search logic here
    ImGui::End();
}

void AssetBrowserApp::renderBookmarksPanel() {
    ImGui::Begin("Bookmarks", &m_showBookmarks, ImGuiWindowFlags_NoCollapse);
    // Bookmarks logic here
    ImGui::End();
}

void AssetBrowserApp::renderHistoryPanel() {
    ImGui::Begin("Recent Files", &m_showHistory);
    // History logic here
    ImGui::End();
}
```

### Hands-On Exercise (3 min)

**Task**: Use few-shot to generate consistent logger calls:

```
Following the pattern from existing code in tools/common/Logger.cpp:

Example 1:
Logger::info("Model loaded successfully: {} vertices, {} triangles",
             vertexCount, triangleCount);

Example 2:
Logger::error("Failed to load model: {}", path);

Example 3:
Logger::warn("Texture not found, using default: {}", texturePath);

Now generate appropriate logger calls for:
1. Thumbnail generation started
2. Asset database scan completed with count
3. OpenGL context creation failed
4. File dialog cancelled by user
```

---

## Session 8: Unit Testing & Debugging (6 min)

### Learning Objectives
- Generate unit tests with Copilot
- Debug code issues with AI assistance
- Create test cases from specifications

### Test Generation with /tests

**Select this function and use `/tests`:**

```cpp
BoundingBox ModelLoader::getBounds() const {
    BoundingBox bounds;
    bounds.min = glm::vec3(FLT_MAX);
    bounds.max = glm::vec3(-FLT_MAX);
    
    for (const auto& mesh : m_meshes) {
        for (const auto& vertex : mesh.vertices) {
            bounds.min = glm::min(bounds.min, vertex.position);
            bounds.max = glm::max(bounds.max, vertex.position);
        }
    }
    
    return bounds;
}
```

**Generated Tests (using Catch2 or Google Test):**
```cpp
#include "ModelLoader.hpp"
#include <catch2/catch_test_macros.hpp>

TEST_CASE("BoundingBox is calculated correctly for single mesh") {
    ModelLoader loader;
    // Create mock mesh with vertices at (0,0,0), (1,1,1), (2,2,2)
    auto bounds = loader.getBounds();
    
    REQUIRE(bounds.min.x == Approx(0.0f));
    REQUIRE(bounds.min.y == Approx(0.0f));
    REQUIRE(bounds.min.z == Approx(0.0f));
    REQUIRE(bounds.max.x == Approx(2.0f));
    REQUIRE(bounds.max.y == Approx(2.0f));
    REQUIRE(bounds.max.z == Approx(2.0f));
}

TEST_CASE("BoundingBox handles negative coordinates") {
    ModelLoader loader;
    // Mesh with vertices at (-1,-1,-1), (0,0,0), (1,1,1)
    auto bounds = loader.getBounds();
    
    REQUIRE(bounds.center() == glm::vec3(0.0f));
    REQUIRE(bounds.size() == glm::vec3(2.0f));
}

TEST_CASE("Empty mesh returns default bounds") {
    ModelLoader loader;
    auto bounds = loader.getBounds();
    
    REQUIRE(bounds.min.x == FLT_MAX);
    REQUIRE(bounds.max.x == -FLT_MAX);
}
```

### Debugging with Copilot Chat

**Scenario**: Asset browser crashes when scanning large directories

```
User: The Asset Browser crashes when scanning folders with 10,000+ files:
[paste stack trace showing crash in AssetDatabase::scan]

Here's the scan method:
[paste function]

Copilot: The crash is likely caused by:

1. Stack overflow from deep recursion in recursive_directory_iterator
   - Try iterative approach or limit recursion depth

2. Memory exhaustion from loading all assets at once
   - Implement pagination or lazy loading
   - Reserve vector capacity upfront: m_assets.reserve(estimatedCount);

3. Path string allocation overhead
   - Use string_view where possible
   - Consider memory pooling for paths

Try this fix first:
m_assets.reserve(10000); // Before the loop
// And add try-catch around file operations

Let me also check if there are any file permission issues...
```

---

## Session 9: Copilot CLI & Privacy (2 min)

### Learning Objectives
- Use Copilot for command-line suggestions
- Generate build and run commands
- Understand privacy and data handling

### Quick Tour: Copilot CLI

**Installation:**
```bash
gh extension install github/gh-copilot
```

**Usage Examples:**

```bash
# Explain a command
gh copilot explain "cmake -B build -G 'Visual Studio 17 2022' -A x64"

# Suggest a command
gh copilot suggest "build cmake project in release mode for windows"
# Output: cmake --build build --config Release

# Get help with build tools
gh copilot suggest "how to find all TODO comments in cpp files"
# Output: grep -r "TODO" --include="*.cpp" --include="*.hpp" .
```

### Tool Development CLI Tasks

| Task | Command to Ask |
|------|----------------|
| Build tools | "build cmake project release mode" |
| Run model viewer | "execute model viewer with a glb file" |
| Find memory leaks | "run valgrind on c++ executable" |
| Format code | "format all cpp files with clang-format" |

### Privacy & Data Handling

**What Copilot Sees:**
- ✅ Open files and editor context
- ✅ File names and paths
- ✅ Comments and code structure
- ✅ Public repository context (@workspace)

**What Copilot Does NOT See:**
- ❌ Files not opened in editor
- ❌ Private credentials/keys (filtered)
- ❌ Your browsing history
- ❌ Files in .gitignore (unless opened)

**Privacy Best Practices:**
1. **Never paste** API keys, passwords, or tokens in prompts
2. **Use environment variables** for sensitive data
3. **Review suggestions** before accepting - don't blindly trust
4. **Configure filters** in your organization's GitHub settings
5. **Use .copilotignore** to exclude sensitive files (if supported)

**Data Retention:**
- Prompts and suggestions may be stored for service improvement
- Enterprise customers can opt out of data retention
- Check your organization's Copilot Business settings

**When to Disable Copilot:**
- Working with classified/confidential data
- Handling customer PII without consent
- Under strict NDA restrictions
- Processing medical/financial records

**How to Temporarily Disable:**
```
Ctrl+Shift+P > "GitHub Copilot: Disable"
```

---

## Workshop Summary

### Key Takeaways

1. **Inline suggestions** are faster with keyboard shortcuts (`Tab`, `Alt+]`, `Alt+[`)
2. **CORE framework** (Context, Objective, Requirements, Examples) improves prompts
3. **Code explanations** accelerate learning new APIs (OpenGL, ImGui, Assimp)
4. **Comment-driven generation** works best with structured specifications
5. **Refactoring** is powerful with specific pattern requests
6. **Chat participants** (@workspace, @vscode) provide specialized context
7. **Few-shot prompting** ensures style consistency across codebase
8. **Test generation** catches edge cases you might miss
9. **CLI** extends Copilot beyond the editor
10. **Privacy** matters - never share secrets with AI

### Homework Before Advanced Workshop

1. **Create a prompt file** for adding a new feature to Model Viewer or Asset Browser
2. **Use few-shot prompting** to generate 3 similar ImGui panels
3. **Generate tests** for an existing function and find any bugs
4. **Refactor one code smell** using Copilot suggestions (extract method, reduce duplication)
5. **Try Copilot CLI** for 3 different build/development commands

---

## Resources

- [Copilot Chat Documentation](https://docs.github.com/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide)
- [Prompt Engineering Guide](https://docs.github.com/copilot/using-github-copilot/best-practices-for-using-github-copilot)
- [Copilot CLI Reference](https://docs.github.com/copilot/github-copilot-in-the-cli)
- [GitHub Copilot Trust Center](https://resources.github.com/copilot-trust-center/)
- [Tools Project README](../../tools/README.md)
- [ImGui Documentation](https://github.com/ocornut/imgui)
- [Assimp Documentation](https://assimp-docs.readthedocs.io/)

---

## Practical Exercises for Next Session

Before the Advanced Workshop, try these exercises using the tools codebase:

### Exercise 1: Add a New Camera Preset
Use comment-based generation to add a "diagonal" camera view preset to `Camera.cpp`:
```cpp
// Add a diagonal view (45° from top-right) looking at target
// Similar to existing Front/Top views but at 45° angles
void Camera::setDiagonalView() {
    // Let Copilot generate this
}
```

### Exercise 2: Implement Asset Search
Use few-shot prompting to add search functionality to `AssetDatabase.cpp`:
- Look at existing `getByType()` method as example
- Create `searchByName()`, `searchByExtension()`, `searchBySize()` methods
- Use consistent return types and patterns

### Exercise 3: Refactor Renderer
Use `/fix` or refactoring prompts on `Renderer.cpp`:
- Extract shader compilation into separate method
- Extract mesh rendering into reusable function
- Add error handling and logging

### Exercise 4: Generate Unit Tests
Select `Camera::focusOnBounds()` and use `/tests`:
- Test with various bounding box sizes
- Test with zero-size boxes
- Test with inverted min/max
- Test with extreme values
