# Workshop 3: Advanced GitHub Copilot for Game Dev Tools
## Instruction Files, Agents, Code Review, and Planning

**Duration**: 1 Hour  
**Level**: Advanced  
**Prerequisites**: Foundational + Intermediate Workshops  
**Project**: Game Dev Tools (C++ / SDL2 / OpenGL / ImGui)

---

## Workshop Objectives

By the end of this workshop, participants will:
- Master Chain-of-Thought prompting for complex C++ problems
- Create and maintain Instruction Files for consistent AI behavior
- Build reusable Prompt Files for team workflows
- Use Copilot Code Review for quality assurance
- Leverage Copilot Plan Mode for multi-file changes
- Delegate complex tasks to Copilot Coding Agent
- Organize agents and prompts in Copilot Agent HQ
- Generate architecture and tech stack documentation

---

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:08 | Chain-of-Thought Prompting | Presentation + Demo |
| 0:08 - 0:18 | Instruction Files | Live Creation |
| 0:18 - 0:28 | Prompt Files | Workshop Exercise |
| 0:28 - 0:36 | Copilot Code Review | Demo + Practice |
| 0:36 - 0:44 | Copilot Plan Mode | Live Demo |
| 0:44 - 0:52 | Copilot Coding Agent | Hands-On |
| 0:52 - 0:56 | Copilot Agent HQ | Tour |
| 0:56 - 1:00 | Architecture Generation | Quick Demo |

---

## Session 1: Chain-of-Thought Prompting (8 min)

### Learning Objectives
- Break down complex C++ problems into reasoning steps
- Guide AI through multi-step implementations
- Debug by reasoning through expected behavior

### What is Chain-of-Thought?

**Standard Prompt:**
```
Add thumbnail caching to AssetBrowser
```

**Chain-of-Thought Prompt:**
```
I need to implement thumbnail caching for the Asset Browser to avoid regenerating thumbnails on every scan. Let's reason through this step by step:

Step 1: What data needs to be cached?
- Thumbnail texture ID (OpenGL texture handle)
- File path and modification time (to detect changes)
- Image dimensions
- Cache creation timestamp

Step 2: Where should the cache be stored?
- In-memory: std::unordered_map<std::string, CachedThumbnail>
- On-disk: SQLite database or JSON file in user data directory
- Key: file path hash or relative path

Step 3: When do we invalidate cache entries?
- File modification time changed
- File deleted
- Cache entry older than X days
- Manual cache clear button

Step 4: What's the cache lookup flow?
REQUEST → Check memory cache → If miss, check disk cache → If miss, generate → Store in both

Step 5: Memory management concerns?
- Limit total cache size (e.g., 500MB)
- LRU eviction when limit reached
- Cleanup OpenGL textures on eviction

Now implement Step 1: the CachedThumbnail struct in ThumbnailGenerator.hpp
```

### Demo: Complex OpenGL Resource Management

**Problem**: Implement a resource manager for OpenGL textures with automatic cleanup

```
Let's implement a TextureManager that handles OpenGL texture lifecycle safely.

Analysis:

1. CREATION:
   - Load image data from file (using stb_image)
   - Generate OpenGL texture ID: glGenTextures()
   - Upload to GPU with proper format/filtering
   - Store mapping: filepath → texture_id

2. OWNERSHIP:
   - Use std::shared_ptr with custom deleter
   - Deleter calls glDeleteTextures() automatically
   - Reference counting prevents premature deletion
   - Weak references for cache without ownership

3. CACHE STRATEGY:
   - std::unordered_map<std::string, std::weak_ptr<Texture>>
   - On request: check weak_ptr.lock() → if valid, return
   - If expired, reload from disk
   - Clear cache on OpenGL context recreation

4. THREAD SAFETY:
   - Image loading can be async (worker thread)
   - OpenGL calls MUST be on main thread
   - Use mutex for cache map access
   - Queue texture uploads from worker thread

5. ERROR HANDLING:
   - Invalid file path → return default "missing" texture
   - Out of GPU memory → fallback to lower resolution
   - OpenGL context lost → invalidate all texture IDs

6. EDGE CASES:
   - Texture requested during shutdown → check context validity
   - Same file requested multiple times → dedup requests
   - File changed on disk → detect via timestamp, reload

Let's start with the Texture struct and smart pointer setup in Step 1...
```

### Practice Exercise (3 min)

**Task**: Use Chain-of-Thought for implementing file drag-and-drop:

```
I need to implement drag-and-drop support for the Model Viewer.

Think through:
1. SDL2 event handling (what event type? SDL_DROPFILE?)
2. File validation (is it a supported model format?)
3. Existing model cleanup (unload current before loading new?)
4. UI feedback (show loading spinner? disable controls?)
5. Error handling (invalid file dropped?)
6. Multi-file drop (load multiple or just first?)

Start with Step 1: SDL event setup in Application.cpp...
```

### Advanced Exercise: Asset Browser to Model Viewer Drag-and-Drop

**Task**: Implement internal drag-and-drop from Asset Browser panel to Model Viewer panel

This is a complete chain-of-thought prompt that developers can copy and run to implement the feature:

```
I need to implement drag-and-drop functionality where users can drag a 3D model asset from the Asset Browser panel (left side) and drop it onto the Model Viewer panel (right side) to load and display the model. Let's reason through this step by step:

Step 1: UNDERSTAND THE ARCHITECTURE
Before coding, I need to understand how these components interact:
- Asset Browser: Displays file list with thumbnails, handles selection
- Model Viewer: Renders 3D models with camera controls
- Both are separate tools/panels that need to communicate

Questions to answer:
- Are these running in the same application or separate windows?
- If same app: Use ImGui drag-drop payloads
- If separate: Use SDL2 OS-level drag-drop
- What data needs to transfer? (file path, asset metadata?)

Check existing code:
- tools/asset_browser/AssetBrowserApp.cpp (how assets are displayed)
- tools/model_viewer/ModelViewerApp.cpp (how models are loaded)
- tools/common/Application.hpp (shared infrastructure)

Step 2: CHOOSE THE DRAG-DROP MECHANISM
For ImGui panels in same application (most likely scenario):
- Use ImGui::BeginDragDropSource() on asset items
- Use ImGui::BeginDragDropTarget() on model viewer viewport
- Payload type: "ASSET_PATH" or "MODEL_ASSET"
- Payload data: const char* filepath or AssetMetadata struct

For separate applications:
- Use SDL_DROPFILE event
- Implement IDropTarget on Windows / NSFilePromise on macOS
- More complex, avoid if possible

Decision: Implement ImGui-based drag-drop for unified tool app

Step 3: DESIGN THE DRAG SOURCE (Asset Browser)
Location: AssetBrowserApp::renderAssetGrid() or renderAssetList()

For each asset item in the grid/list:

// After rendering the asset thumbnail/icon
if (ImGui::BeginDragDropSource(ImGuiDragDropFlags_SourceAllowNullID)) {
    // Set payload data - the file path
    const char* path = asset.path.c_str();
    ImGui::SetDragDropPayload("MODEL_ASSET", path, strlen(path) + 1);

    // Visual feedback while dragging
    ImGui::Text("Loading: %s", asset.fileName.c_str());
    ImGui::Image(asset.thumbnailId, ImVec2(64, 64));

    ImGui::EndDragDropSource();
}

Considerations:
- Only enable drag for supported model types (.glb, .gltf, .fbx, .obj)
- Show clear visual feedback (thumbnail follows cursor)
- Disable drag for folders or unsupported file types

Step 4: DESIGN THE DROP TARGET (Model Viewer)
Location: ModelViewerApp::onImGuiRender() viewport area

// In the viewport/scene view area
ImGui::BeginChild("Viewport", viewportSize, false, windowFlags);

// ... existing rendering code ...

// Make viewport a drop target
if (ImGui::BeginDragDropTarget()) {
    if (const ImGuiPayload* payload = ImGui::AcceptDragDropPayload("MODEL_ASSET")) {
        const char* droppedPath = static_cast<const char*>(payload->Data);

        // Validate and load the model
        loadModelFromPath(droppedPath);
    }
    ImGui::EndDragDropTarget();
}

ImGui::EndChild();

Step 5: IMPLEMENT MODEL LOADING LOGIC
Create or modify: ModelViewerApp::loadModelFromPath(const std::string& path)

void ModelViewerApp::loadModelFromPath(const std::string& path) {
    // 5.1 Validate file exists
    if (!std::filesystem::exists(path)) {
        Logger::error("ModelViewer", "File not found: {}", path);
        showErrorDialog("File not found: " + path);
        return;
    }

    // 5.2 Check if supported format
    auto ext = std::filesystem::path(path).extension().string();
    std::transform(ext.begin(), ext.end(), ext.begin(), ::tolower);

    const std::vector<std::string> supportedFormats = {
        ".glb", ".gltf", ".fbx", ".obj", ".dae", ".blend"
    };

    if (std::find(supportedFormats.begin(), supportedFormats.end(), ext) 
        == supportedFormats.end()) {
        Logger::error("ModelViewer", "Unsupported format: {}", ext);
        showErrorDialog("Unsupported model format: " + ext);
        return;
    }

    // 5.3 Cleanup existing model
    if (m_currentModel) {
        m_renderer->unloadModel(m_currentModel);
        m_currentModel = nullptr;
    }

    // 5.4 Show loading state
    m_isLoading = true;
    m_loadingMessage = "Loading " + std::filesystem::path(path).filename().string();

    // 5.5 Load new model (consider async for large files)
    try {
        m_currentModel = m_modelLoader->load(path);

        // 5.6 Reset camera to fit model
        auto bounds = m_currentModel->getBoundingBox();
        m_camera->focusOn(bounds);

        // 5.7 Update UI state
        m_currentModelPath = path;
        m_meshInspector->setModel(m_currentModel);

        Logger::info("ModelViewer", "Loaded model: {}", path);

    } catch (const std::exception& e) {
        Logger::error("ModelViewer", "Failed to load model: {}", e.what());
        showErrorDialog("Failed to load model: " + std::string(e.what()));
    }

    m_isLoading = false;
}

Step 6: ADD VISUAL FEEDBACK DURING DRAG
Enhance drop target with visual cues:

// Track if something is being dragged over viewport
bool isHovered = false;

if (ImGui::BeginDragDropTarget()) {
    isHovered = true;

    // Preview effect - highlight viewport border
    ImDrawList* drawList = ImGui::GetWindowDrawList();
    ImVec2 min = ImGui::GetWindowPos();
    ImVec2 max = ImVec2(min.x + viewportSize.x, min.y + viewportSize.y);
    drawList->AddRect(min, max, IM_COL32(0, 200, 100, 255), 0.0f, 0, 3.0f);

    // Show "Drop to load" text overlay
    const char* hint = "Drop model here to load";
    ImVec2 textSize = ImGui::CalcTextSize(hint);
    ImVec2 textPos = ImVec2(
        min.x + (viewportSize.x - textSize.x) * 0.5f,
        min.y + (viewportSize.y - textSize.y) * 0.5f
    );
    drawList->AddText(textPos, IM_COL32(255, 255, 255, 200), hint);

    if (const ImGuiPayload* payload = ImGui::AcceptDragDropPayload("MODEL_ASSET")) {
        // ... handle drop
    }
    ImGui::EndDragDropTarget();
}

Step 7: HANDLE EDGE CASES
- Drag cancelled (ESC key): ImGui handles automatically
- Invalid drop location: Payload not accepted, nothing happens
- Drag from external source: Consider also handling SDL_DROPFILE for OS drag-drop
- Model loading fails: Show error dialog, keep previous model if any
- Large file dropped: Show progress indicator, consider async loading

Step 8: ADD LOADING INDICATOR UI

void ModelViewerApp::renderLoadingOverlay() {
    if (!m_isLoading) return;

    ImGui::SetNextWindowPos(ImGui::GetMainViewport()->GetCenter(), 
                            ImGuiCond_Always, ImVec2(0.5f, 0.5f));
    ImGui::Begin("Loading", nullptr, 
                 ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_AlwaysAutoResize);

    ImGui::Text("%s", m_loadingMessage.c_str());

    // Animated spinner
    float time = static_cast<float>(ImGui::GetTime());
    const char* spinChars = "|/-\\";
    ImGui::SameLine();
    ImGui::Text("%c", spinChars[static_cast<int>(time * 8) % 4]);

    ImGui::End();
}

Step 9: UPDATE DOCUMENTATION
Files to update:
- tools/README.md: Add drag-drop feature description
- tools/model_viewer/README.md: Document user workflow
- Add keyboard shortcut if any (e.g., ESC to cancel)

Documentation section to add:

## Drag and Drop Support

The Model Viewer supports drag-and-drop loading of 3D models:

1. Open the Asset Browser panel (View → Asset Browser or F2)
2. Navigate to a folder containing 3D models
3. Click and drag a model file (.glb, .gltf, .fbx, .obj, .dae)
4. Drop onto the Model Viewer viewport
5. The model will load and camera will auto-focus

**Supported Formats:**
- glTF/GLB (recommended)
- FBX
- OBJ
- Collada (DAE)
- Blender (BLEND)

**Tips:**
- Large models may take a moment to load
- Previous model is automatically unloaded
- Camera resets to fit the new model's bounds

Step 10: TEST PLAN
Manual test cases:
- [ ] Drag .glb file from Asset Browser → drops and loads correctly
- [ ] Drag .fbx file → loads correctly  
- [ ] Drag .obj file → loads correctly
- [ ] Drag unsupported file (.png, .txt) → shows error, no crash
- [ ] Drag to non-viewport area → no action (expected)
- [ ] Drop while model is loading → queues or cancels appropriately
- [ ] ESC during drag → cancels drag operation
- [ ] Large model (100MB+) → shows loading indicator, completes
- [ ] Invalid/corrupted model file → error dialog, app stable
- [ ] Drop triggers camera reset to fit new model

Step 11: FILES TO MODIFY
Create/modify these files:
1. tools/asset_browser/AssetBrowserApp.cpp - Add drag source
2. tools/model_viewer/ModelViewerApp.hpp - Add loading state members
3. tools/model_viewer/ModelViewerApp.cpp - Add drop target and loading logic
4. tools/README.md - Document feature
5. tools/model_viewer/README.md - User documentation

Step 12: IMPLEMENTATION ORDER
Execute in this sequence:
1. Add drag source to Asset Browser (test drag visual works)
2. Add drop target to Model Viewer (test payload received)
3. Implement loadModelFromPath() method
4. Add visual feedback (border highlight, "drop here" text)
5. Add loading indicator overlay
6. Test all supported formats
7. Test error cases
8. Update documentation
9. Final integration test

Now implement Step 1: Add BeginDragDropSource to asset items in AssetBrowserApp.cpp...
```

---

## Session 2: Instruction Files (10 min)

### Learning Objectives
- Create instruction files for different file types
- Understand `applyTo` patterns
- Build a complete instruction file hierarchy for C++ tools

### Instruction File Structure

**Location**: `.github/instructions/`

**Format**:
```markdown
---
description: 'Brief description of these instructions'
applyTo: '**/*.{extensions}'
---

# Content follows...
```

### Game Dev Tools Instruction Files

**1. C++ ImGui Applications** (`cpp-imgui-tools.instructions.md`):
```markdown
---
description: 'C++ ImGui application development rules for Game Dev Tools.'
applyTo: 'tools/**/*.{cpp,hpp}'
---

Follow these rules when editing C++ sources for Game Dev Tools.

**Must read before edits:**
- tools/README.md
- tools/ROADMAP.md
- tools/common/Application.hpp (base class contract)

**Application Lifecycle:**
- Constructor: Initialize members only
- onInit(): Setup OpenGL resources, load initial data
- onUpdate(deltaTime): Update logic (camera, animations)
- onImGuiRender(): All ImGui UI calls go here
- onShutdown(): Cleanup resources, save state
- Destructor: Release remaining resources

**ImGui Best Practices:**
- Always call ImGui::Begin()/End() in pairs
- Use ImGui::PushID()/PopID() in loops to avoid ID collisions
- Check return values: if (ImGui::Button("...")) { /* clicked */ }
- Use ImGuiWindowFlags for window behavior control
- Prefer ImGui::SetNextWindow* before Begin() for positioning

**OpenGL Resource Management:**
- Always check glGetError() after critical operations
- Delete textures/buffers in reverse creation order
- Use RAII wrappers for OpenGL objects when possible
- Never leak OpenGL resources on exception

**SDL2 Integration:**
- Process all SDL events in main loop
- Don't call SDL_GL_SwapWindow() manually (Application handles it)
- Use SDL_GetPerformanceCounter() for timing
- Check SDL_GetError() after SDL operations

**Memory Safety:**
- Use std::unique_ptr/std::shared_ptr for owned resources
- Prefer std::vector/std::string over raw arrays
- Check pointers before dereferencing
- Use std::optional for nullable values

**File I/O:**
- Use std::filesystem for path operations
- Always validate file existence before reading
- Use FileSystem utility class for path normalization
- Handle file errors gracefully with user feedback

**Logging:**
- Use Logger class, not printf/std::cout
- Levels: LOG_DEBUG, LOG_INFO, LOG_WARN, LOG_ERROR
- Include context: Logger::info("ModelLoader", "Loaded mesh: {}", name);
- Never log in hot paths (per-frame)

**Third-Party Libraries:**
- Never modify code in external/
- Wrap external APIs in internal classes
- Handle library errors and translate to tool errors

**Performance:**
- Cache expensive calculations (bounding boxes, etc.)
- Avoid allocations in onUpdate() or ImGui render
- Use move semantics for large objects
- Profile before optimizing (don't guess)

**Code Style:**
- UpperCamelCase for classes: class AssetDatabase
- lowerCamelCase for methods: void loadModel()
- m_prefix for member variables: m_camera
- Use descriptive names over abbreviations
```

**2. OpenGL Rendering Code** (`opengl-rendering.instructions.md`):
```markdown
---
description: 'OpenGL rendering code guidelines for Model Viewer and visual tools.'
applyTo: 'tools/**/Renderer.{cpp,hpp},tools/**/Camera.{cpp,hpp}'
---

**State Management:**
- Save and restore OpenGL state if modifying global state
- Use glPushAttrib/glPopAttrib for legacy contexts
- Document required GL state in function comments

**Shader Usage:**
- Always check compilation errors with glGetShaderiv
- Validate program linking with glGetProgramiv
- Use uniform locations cached in member variables
- Set uniforms only when values change

**Vertex Data:**
- Use Vertex Array Objects (VAOs) for all geometry
- Bind VAO before drawing, unbind after
- Store VBO/EBO in member variables
- Update buffers with glBufferSubData for partial updates

**Textures:**
- Bind to specific texture units: glActiveTexture(GL_TEXTURE0 + slot)
- Always specify min/mag filters and wrap modes
- Generate mipmaps for downscaled textures
- Use correct internal formats (GL_RGBA8, GL_RGB8, etc.)

**Framebuffers:**
- Check completeness: glCheckFramebufferStatus
- Attach all required buffers (color, depth, stencil)
- Restore default framebuffer (0) after rendering
- Clear attachments between renders

**Camera:**
- Use glm:: for all math operations
- Perspective: glm::perspective(fov, aspect, near, far)
- View matrix: glm::lookAt(eye, center, up)
- Update projection matrix on window resize

**Debugging:**
- Use glGetError() in debug builds
- Enable GL_DEBUG_OUTPUT for detailed errors
- Label objects with glObjectLabel for debuggers
- Check shader compile/link logs on failure
```

**3. Asset Processing** (`asset-processing.instructions.md`):
```markdown
---
description: 'Asset loading and processing rules for Asset Browser and Model Viewer.'
applyTo: 'tools/**/AssetDatabase.{cpp,hpp},tools/**/ModelLoader.{cpp,hpp}'
---

**Assimp Model Loading:**
- Import flags: aiProcess_Triangulate | aiProcess_GenNormals | aiProcess_CalcTangentSpace
- Check scene validity: if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE)
- Iterate all meshes, materials, textures in scene
- Convert Assimp types to glm types explicitly

**File Format Support:**
- Detect by extension, not content sniffing
- Support: .gltf, .glb, .fbx, .obj, .dae, .blend
- Return meaningful errors for unsupported formats
- Log format-specific warnings (missing textures, etc.)

**Thumbnail Generation:**
- Use stb_image_resize for downscaling
- Target size: 256x256 for grid view, 128x128 for list
- Maintain aspect ratio with letterboxing
- Generate async on worker thread, upload on main thread

**Path Handling:**
- Store relative paths when inside project directory
- Use std::filesystem::path, not raw strings
- Normalize paths: path.lexically_normal()
- Handle spaces and special characters in filenames

**Caching:**
- Cache parsed asset metadata in memory
- Use file modification time for invalidation
- Serialize cache to disk on shutdown (JSON or binary)
- Clear cache on format version change

**Error Recovery:**
- Don't crash on single malformed file
- Log errors and continue processing batch
- Return placeholder for failed assets
- Show error count in UI status bar
```

**4. ImGui UI Code** (`imgui-ui.instructions.md`):
```markdown
---
description: 'ImGui UI implementation patterns and best practices.'
applyTo: 'tools/**/*Panel.{cpp,hpp},tools/**/*App.cpp'
---

**Layout Patterns:**
- Use ImGui::BeginChild()/EndChild() for scrollable regions
- DockSpace for multi-panel layouts
- Columns or Tables for grid layouts
- Separator() for visual grouping

**Input Widgets:**
- InputText: provide buffer with size: char buf[256]
- SliderFloat/Int: specify min/max/format
- Combo: use const char* items[] array
- ColorEdit: use ImGuiColorEditFlags for options

**Interaction Feedback:**
- Use IsItemHovered() for tooltips
- IsItemActive() for continuous interaction
- IsItemClicked() for mouse button detection
- SetTooltip() for context-sensitive help

**Performance:**
- Don't rebuild static UI every frame
- Use ImGui::BeginDisabled() instead of hiding
- Collapse panels to skip rendering contents
- Limit text rendering in long lists

**Styling:**
- Use PushStyleColor/PopStyleColor in pairs
- PushStyleVar for spacing, padding, rounding
- Use ImGui::GetStyle() for reading current values
- Don't modify global style, use push/pop

**File Dialogs:**
- Use platform-native dialogs (SDL or OS APIs)
- Filter by extension: "Model Files\0*.gltf;*.glb;*.fbx\0"
- Remember last opened directory
- Validate selection before accepting
```

### Live Creation Exercise (5 min)

**Task**: Create an instruction file for debugging and diagnostics:

```markdown
---
description: 'Debugging, logging, and diagnostic guidelines for Game Dev Tools.'
applyTo: 'tools/**/*.{cpp,hpp}'
---

**Logging Levels:**
- DEBUG: Verbose developer info (frame times, cache hits)
- INFO: User-relevant events (file loaded, settings changed)
- WARN: Recoverable issues (missing texture, using default)
- ERROR: Serious problems (file not found, GL error)

**Assertions:**
- Use assert() for developer errors (invariants)
- Use runtime checks for user input errors
- Document preconditions in function comments
- Never assert on file I/O results

**Error Messages:**
- Include context: "Failed to load model 'car.glb': File not found"
- Suggest fixes: "Try checking the file path or permissions"
- Don't expose internal details to users
- Log full stack/details, show summary in UI

**Performance Diagnostics:**
- Track frame time with high-resolution timer
- Count draw calls, vertices per frame
- Monitor memory usage (textures, meshes)
- Display stats in debug overlay (F1 to toggle)

**ImGui Debug Tools:**
- ImGui::ShowDemoWindow() for reference
- ImGui::ShowMetricsWindow() for performance
- Custom debug panels for tool-specific data
- Frame graph for frame time visualization
```

---

## Session 3: Prompt Files (10 min)

### Learning Objectives
- Create reusable prompt files for common tool development tasks
- Structure prompts with context, requirements, and test plans
- Build a library of team-shared prompts

### Prompt File Structure

**Location**: `.github/prompts/`

**Format**:
```markdown
---
agent: 'agent'  # or specific agent name
description: 'What this prompt accomplishes'
---

# Prompt content with placeholders...
```

### Game Dev Tools Prompt Examples

**1. Add New ImGui Panel** (`add-imgui-panel.prompt.md`):
```markdown
---
agent: '@ui-developer'
description: 'Create a new ImGui panel with standard layout and controls'
---

You are adding a new ImGui panel to the {{TOOL_NAME}} tool.

**Context to load:**
- tools/{{tool_name}}/{{ToolName}}App.hpp (main app class)
- tools/{{tool_name}}/{{ToolName}}App.cpp (render methods)
- tools/common/Application.hpp (base class reference)

**Requirements:**

1. **Create Panel Class:**
   File: tools/{{tool_name}}/{{PanelName}}.hpp
   ```cpp
   #pragma once
   #include <string>
   
   namespace tools {
   
   class {{PanelName}} {
   public:
       {{PanelName}}();
       
       /**
        * @brief Render the panel using ImGui
        * @return true if panel is open, false if closed
        */
       bool render();
       
       /**
        * @brief Get panel title
        */
       const char* getTitle() const { return "{{Panel Title}}"; }
       
   private:
       bool m_isOpen = true;
       // Add panel-specific state here
   };
   
   } // namespace tools
   ```

2. **Implementation Template:**
   File: tools/{{tool_name}}/{{PanelName}}.cpp
   ```cpp
   #include "{{PanelName}}.hpp"
   #include "Logger.hpp"
   #include <imgui.h>
   
   namespace tools {
   
   {{PanelName}}::{{PanelName}}() {
       Logger::info("{{PanelName}}", "Initialized");
   }
   
   bool {{PanelName}}::render() {
       if (!m_isOpen) return false;
       
       if (ImGui::Begin(getTitle(), &m_isOpen)) {
           // Panel content here
           ImGui::Text("{{Panel Title}} content");
       }
       ImGui::End();
       
       return m_isOpen;
   }
   
   } // namespace tools
   ```

3. **Integrate into App:**
   - Add member variable: `std::unique_ptr<{{PanelName}}> m_{{panelName}};`
   - Initialize in constructor or onInit()
   - Call `m_{{panelName}}->render()` in onImGuiRender()

4. **Update CMakeLists.txt:**
   Add to target sources:
   ```cmake
   {{tool_name}}/{{PanelName}}.cpp
   {{tool_name}}/{{PanelName}}.hpp
   ```

**Test Plan:**
- [ ] Panel appears in tool window
- [ ] Close button works (returns false)
- [ ] Panel can be docked with other panels
- [ ] No ImGui assertion errors in console
- [ ] Panel state persists during session

**Files to modify:**
- tools/{{tool_name}}/{{PanelName}}.hpp (create)
- tools/{{tool_name}}/{{PanelName}}.cpp (create)
- tools/{{tool_name}}/{{ToolName}}App.hpp (add member)
- tools/{{tool_name}}/{{ToolName}}App.cpp (integrate)
- tools/CMakeLists.txt (add sources)
```

**2. Implement Asset Loader** (`implement-asset-loader.prompt.md`):
```markdown
---
agent: '@asset-pipeline'
description: 'Add support for a new asset type in Asset Browser'
---

Add support for {{ASSET_TYPE}} files to the Asset Browser.

**Context:**
- tools/asset_browser/AssetDatabase.cpp (existing loaders)
- tools/asset_browser/ThumbnailGenerator.cpp (thumbnail creation)
- tools/common/FileSystem.hpp (file utilities)

**Asset Type Details:**
- Extensions: {{EXTENSIONS}} (e.g., .png, .jpg, .bmp)
- Detection: File extension or magic bytes?
- Metadata to extract: {{METADATA}} (e.g., dimensions, format, color depth)
- Thumbnail strategy: {{STRATEGY}} (e.g., downscale, extract preview, render)

**Implementation Steps:**

**Step 1: Extend AssetType Enum**
File: tools/asset_browser/AssetDatabase.hpp
```cpp
enum class AssetType {
    Unknown,
    Model3D,
    Texture,
    Audio,
    {{NEW_TYPE}},  // Add this
    // ...
};
```

**Step 2: Add Type Detection**
File: tools/asset_browser/AssetDatabase.cpp
```cpp
AssetType AssetDatabase::detectAssetType(const std::filesystem::path& path) {
    auto ext = path.extension().string();
    std::transform(ext.begin(), ext.end(), ext.begin(), ::tolower);
    
    // Add this block
    if (ext == "{{ext1}}" || ext == "{{ext2}}") {
        return AssetType::{{NEW_TYPE}};
    }
    
    // ... existing checks
}
```

**Step 3: Implement Metadata Extraction**
```cpp
AssetMetadata AssetDatabase::extract{{NewType}}Metadata(const std::filesystem::path& path) {
    AssetMetadata meta;
    meta.type = AssetType::{{NEW_TYPE}};
    meta.path = path;
    meta.fileName = path.filename().string();
    
    // TODO: Extract type-specific metadata
    // Example: Read file header, parse dimensions, etc.
    
    return meta;
}
```

**Step 4: Implement Thumbnail Generation**
File: tools/asset_browser/ThumbnailGenerator.cpp
```cpp
GLuint ThumbnailGenerator::generate{{NewType}}Thumbnail(const std::filesystem::path& path) {
    // TODO: Load asset and generate preview image
    // Return OpenGL texture ID
    
    // Fallback to placeholder if generation fails
    return m_placeholderTexture;
}
```

**Step 5: Update UI Icons**
- Add appropriate icon for this asset type
- Update filter panel to include {{NEW_TYPE}} filter

**Test Plan:**
- [ ] Files with {{EXTENSIONS}} detected correctly
- [ ] Metadata displays in preview panel
- [ ] Thumbnails generate without errors
- [ ] Filter shows/hides files correctly
- [ ] Performance acceptable with many files
- [ ] Error handling for corrupted files

**Files to modify:**
- tools/asset_browser/AssetDatabase.hpp
- tools/asset_browser/AssetDatabase.cpp
- tools/asset_browser/ThumbnailGenerator.hpp
- tools/asset_browser/ThumbnailGenerator.cpp
- tools/asset_browser/FilterPanel.cpp (if adding filter)
```

**3. Add Camera Control Mode** (`add-camera-mode.prompt.md`):
```markdown
---
agent: '@graphics-programmer'
description: 'Implement a new camera control mode for Model Viewer'
---

Add {{CAMERA_MODE}} camera mode to the Model Viewer.

**Context:**
- tools/model_viewer/Camera.hpp (existing camera class)
- tools/model_viewer/Camera.cpp (orbit/pan/zoom implementation)
- tools/model_viewer/ModelViewerApp.cpp (input handling)

**Camera Mode: {{CAMERA_MODE}}**
Description: {{MODE_DESCRIPTION}}

**Requirements:**

1. **Camera State:**
   - What new state variables are needed?
   - Position, rotation, target, or other parameters?
   - How does it differ from existing orbit mode?

2. **Input Mapping:**
   - Mouse buttons: Left = {{ACTION}}, Middle = {{ACTION}}, Right = {{ACTION}}
   - Scroll wheel: {{ACTION}}
   - Keyboard modifiers: Shift/Ctrl/Alt change behavior?

3. **Update Logic:**
   - How does camera position/rotation update each frame?
   - Smoothing/interpolation needed?
   - Constraints (min/max distance, angle limits)?

4. **Mode Switching:**
   - UI button or keyboard shortcut?
   - Can switch mid-interaction?
   - State preservation when switching?

**Implementation Pattern:**

File: tools/model_viewer/Camera.hpp
```cpp
enum class CameraMode {
    Orbit,
    FirstPerson,
    {{NEW_MODE}}  // Add this
};

class Camera {
    // ...
    void set{{NewMode}}Mode();
    void update{{NewMode}}(float deltaTime, const Input& input);
    
private:
    CameraMode m_mode = CameraMode::Orbit;
    // Add mode-specific state
};
```

File: tools/model_viewer/Camera.cpp
```cpp
void Camera::update(float deltaTime) {
    switch (m_mode) {
        case CameraMode::Orbit:
            updateOrbit(deltaTime);
            break;
        case CameraMode::{{NEW_MODE}}:
            update{{NewMode}}(deltaTime, getInput());
            break;
    }
    
    updateMatrices();
}

void Camera::update{{NewMode}}(float deltaTime, const Input& input) {
    // TODO: Implement camera logic
    // Update m_position, m_rotation, m_target based on input
}
```

**Test Plan:**
- [ ] Mode switches correctly from UI
- [ ] Mouse controls feel intuitive
- [ ] Camera doesn't flip or jump unexpectedly
- [ ] Works with different model sizes
- [ ] Smooth transitions between modes
- [ ] State persists across model loads

**Files to modify:**
- tools/model_viewer/Camera.hpp
- tools/model_viewer/Camera.cpp
- tools/model_viewer/ModelViewerApp.cpp (UI for mode selection)
```

### Workshop Exercise (5 min)

**Task**: Create a prompt file for adding performance profiling:

```markdown
---
agent: '@performance-engineer'
description: 'Add frame time profiling and visualization to tools'
---

Add performance profiling overlay to {{TOOL_NAME}}.

**Context:**
- tools/common/Application.cpp (main loop timing)
- tools/{{tool_name}}/{{ToolName}}App.cpp (tool-specific rendering)

**Requirements:**

1. **Frame Time Tracking:**
   - Measure total frame time (ms)
   - Track update time vs render time separately
   - Record last N frames (e.g., 120 for 2 seconds at 60fps)
   - Calculate average, min, max, 99th percentile

2. **ImGui Overlay:**
   - Toggle with F1 key
   - Display as framegraph (line chart)
   - Show numeric stats (FPS, avg ms, max ms)
   - Color code: green (<16ms), yellow (16-33ms), red (>33ms)

3. **Tool-Specific Metrics:**
   For Model Viewer:
   - Draw calls per frame
   - Vertex/triangle count
   - Texture memory usage
   
   For Asset Browser:
   - Assets scanned per frame
   - Thumbnail generation queue size
   - Cache hit rate

4. **Export Capability:**
   - Save profiling session to CSV
   - Include timestamp, frame number, metrics
   - Button to start/stop capture

**Test Plan:**
- [ ] Frame times accurate (verify with external profiler)
- [ ] Graph updates smoothly without affecting FPS
- [ ] Toggle works reliably
- [ ] CSV export readable in spreadsheet
- [ ] No memory leaks from frame history
```

---

## Session 4: Copilot Code Review (8 min)

### Learning Objectives
- Use Copilot for automated code review
- Configure review criteria for C++ tools
- Integrate review into development workflow

### Invoking Code Review

**Method 1: Selection Review**
1. Select code block
2. Right-click → "Copilot: Review Selection"

**Method 2: Chat Command**
```
@workspace /review tools/asset_browser/AssetDatabase.cpp
```

**Method 3: Custom Agent Review**
```
@code-reviewer review the changes in tools/model_viewer/Camera.cpp
Focus on: memory safety, OpenGL resource leaks, input handling edge cases
```

### Review Criteria for C++ Tools

**Game Dev Tools Code Review Checklist:**

| Category | Checks |
|----------|--------|
| **Memory Safety** | No raw pointers, proper RAII, no leaks |
| **OpenGL** | Cleanup resources, state restoration, error checking |
| **ImGui** | Begin/End pairs, ID collisions avoided, performance |
| **Threading** | Proper synchronization, GL calls on main thread only |
| **Error Handling** | User-friendly messages, graceful degradation |
| **Performance** | No per-frame allocations, efficient algorithms |
| **Style** | Naming conventions, documentation, formatting |

### Demo: Reviewing Texture Loading Code

**Code to Review:**
```cpp
GLuint ThumbnailGenerator::loadTexture(const std::string& path) {
    int width, height, channels;
    unsigned char* data = stbi_load(path.c_str(), &width, &height, &channels, 4);
    
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, 
                 GL_RGBA, GL_UNSIGNED_BYTE, data);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    stbi_image_free(data);
    
    return texture;
}
```

**Review Prompt:**
```
@code-reviewer Review this texture loading code for the Asset Browser:

Check for:
1. Memory safety and resource leaks
2. Error handling (what if file not found?)
3. OpenGL error checking
4. Thread safety (where can this be called from?)
5. Texture binding state pollution
6. Missing functionality (mipmaps, compression?)
```

**Expected Review Output:**
```
## Code Review: loadTexture

### Critical Issues:

1. **CRITICAL: No error handling for stbi_load failure**
   - If file doesn't exist or is corrupted, data = nullptr
   - glTexImage2D with null data = undefined behavior
   - Fix:
   ```cpp
   if (!data) {
       Logger::error("ThumbnailGenerator", "Failed to load image: {}", path);
       return 0; // or return placeholder texture
   }
   ```

2. **CRITICAL: Memory leak if glGenTextures fails**
   - If GL error occurs after stbi_load, data is not freed
   - Fix: Move stbi_image_free into RAII wrapper or use earlier
   
3. **CRITICAL: No OpenGL error checking**
   - Texture creation could fail (out of memory)
   - Fix: Check glGetError() and handle gracefully

### Major Issues:

4. **MAJOR: Texture binding state not restored**
   - Leaves GL_TEXTURE_2D bound to this texture
   - Can cause issues in other rendering code
   - Fix: `glBindTexture(GL_TEXTURE_2D, 0);` at end

5. **MAJOR: Missing mipmaps**
   - Using GL_LINEAR but no mipmaps generated
   - Should call `glGenerateMipmap(GL_TEXTURE_2D);`
   - Or use GL_NEAREST if mipmaps not needed

### Minor Issues:

6. **MINOR: Path should be const reference**
   - `const std::string& path` avoids copy
   
7. **MINOR: Hardcoded channel count**
   - Forcing 4 channels for all images
   - Some images could be 1 or 3 channels
   - Consider dynamic format based on channels

### Suggested Fix:
```cpp
GLuint ThumbnailGenerator::loadTexture(const std::filesystem::path& path) {
    int width, height, channels;
    unsigned char* data = stbi_load(path.string().c_str(), 
                                     &width, &height, &channels, 4);
    
    if (!data) {
        Logger::error("ThumbnailGenerator", 
                      "Failed to load texture: {}", path.string());
        return getPlaceholderTexture(); // Return fallback texture
    }
    
    GLuint texture = 0;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glGenerateMipmap(GL_TEXTURE_2D);
    
    // Cleanup
    stbi_image_free(data);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    // Verify no GL errors
    GLenum err = glGetError();
    if (err != GL_NO_ERROR) {
        Logger::error("ThumbnailGenerator", 
                      "OpenGL error during texture creation: 0x{:X}", err);
        glDeleteTextures(1, &texture);
        return getPlaceholderTexture();
    }
    
    return texture;
}
```
```

### Practice Exercise (3 min)

**Review this camera update code:**

```cpp
void Camera::handleMouseInput(int dx, int dy, bool leftButton, bool middleButton) {
    if (leftButton) {
        m_yaw += dx * 0.1f;
        m_pitch += dy * 0.1f;
    }
    
    if (middleButton) {
        m_position.x += dx;
        m_position.y += dy;
    }
    
    updateViewMatrix();
}
```

**Review Focus:**
- Input validation
- Angle wrapping
- Sensitivity constants
- Performance concerns

---

## Session 5: Copilot Plan Mode (8 min)

### Learning Objectives
- Use Plan Mode for multi-file tool features
- Review and modify generated plans
- Execute plans safely with checkpoints

### What is Plan Mode?

Plan Mode allows Copilot to:
1. Analyze a complex tool feature request
2. Create a step-by-step implementation plan
3. Show which files will be modified
4. Execute changes with your approval at each step

### Invoking Plan Mode

**In Chat:**
```
@workspace /plan Add a material editor panel to the Model Viewer that:
- Shows all materials in the loaded model
- Allows tweaking albedo, metallic, roughness values
- Updates the rendered model in real-time
- Can save material overrides to a JSON file
```

### Demo: Multi-File Feature Addition

**Request:**
```
@workspace /plan Add asset search functionality to Asset Browser that:
1. Provides a search text box in the toolbar
2. Filters assets by filename (case-insensitive)
3. Supports wildcards (* and ?)
4. Highlights matching text in results
5. Shows match count in status bar
6. Clears on ESC key press
```

**Generated Plan:**
```
## Plan: Add Asset Search to Asset Browser

### Files to Create:
1. tools/asset_browser/SearchBar.hpp - Search UI component
2. tools/asset_browser/SearchBar.cpp - Search implementation

### Files to Modify:
3. tools/asset_browser/AssetBrowserApp.hpp - Add search state
4. tools/asset_browser/AssetBrowserApp.cpp - Integrate search UI
5. tools/asset_browser/AssetDatabase.hpp - Add filter method
6. tools/asset_browser/AssetDatabase.cpp - Implement filtering logic
7. tools/CMakeLists.txt - Add new source files

### Implementation Steps:

**Step 1: Create SearchBar Component**
Files: SearchBar.hpp/.cpp
- ImGui::InputText for search query
- Clear button (X icon)
- Match count display
- Wildcard pattern matching utility
- Signal/callback when query changes

**Step 2: Add Search State to App**
File: AssetBrowserApp.hpp
```cpp
class AssetBrowserApp : public Application {
    // ...
private:
    std::unique_ptr<SearchBar> m_searchBar;
    std::string m_searchQuery;
    std::vector<AssetMetadata> m_filteredAssets;
    int m_matchCount = 0;
};
```

**Step 3: Implement Filtering Logic**
File: AssetDatabase.cpp
```cpp
std::vector<AssetMetadata> AssetDatabase::filterByQuery(
    const std::string& query) const {
    
    if (query.empty()) {
        return m_assets; // No filter
    }
    
    std::vector<AssetMetadata> results;
    for (const auto& asset : m_assets) {
        if (matchesWildcard(asset.fileName, query)) {
            results.push_back(asset);
        }
    }
    return results;
}
```

**Step 4: Integrate UI in Toolbar**
File: AssetBrowserApp.cpp in renderToolbar()
```cpp
void AssetBrowserApp::renderToolbar() {
    // ... existing buttons
    
    ImGui::SameLine();
    if (m_searchBar->render(m_searchQuery)) {
        // Query changed, update filter
        m_filteredAssets = m_database->filterByQuery(m_searchQuery);
        m_matchCount = m_filteredAssets.size();
    }
}
```

**Step 5: Update Grid/List Rendering**
- Use m_filteredAssets instead of all assets
- Highlight matching portions of filenames
- Use ImGui::TextColored for highlights

**Step 6: Handle ESC Key**
File: AssetBrowserApp.cpp in onUpdate()
```cpp
void AssetBrowserApp::onUpdate(float dt) {
    if (ImGui::IsKeyPressed(ImGuiKey_Escape) && !m_searchQuery.empty()) {
        m_searchQuery.clear();
        m_filteredAssets = m_database->getAllAssets();
    }
}
```

**Step 7: Update Status Bar**
File: AssetBrowserApp.cpp in renderStatusBar()
```cpp
if (!m_searchQuery.empty()) {
    ImGui::Text("Found %d matches for '%s'", 
                m_matchCount, m_searchQuery.c_str());
}
```

**Step 8: Add to CMakeLists.txt**
```cmake
add_executable(asset_browser
    # ... existing files
    asset_browser/SearchBar.cpp
    asset_browser/SearchBar.hpp
)
```

### Test Plan:
- [ ] Search box appears in toolbar
- [ ] Typing filters assets immediately
- [ ] Wildcards work (* matches multiple, ? matches one)
- [ ] Case-insensitive matching
- [ ] Clear button empties search
- [ ] ESC clears search
- [ ] Match count accurate
- [ ] Highlighting shows matched text
- [ ] Performance good with 1000+ assets

Shall I proceed with Step 1: Creating the SearchBar component?
```

### Practice: Evaluate a Plan (3 min)

**Given this plan output, evaluate it:**

```
## Plan: Add Undo/Redo to Material Editor

Step 1: Create Command pattern base class
Step 2: Implement SetColorCommand, SetFloatCommand
Step 3: Add CommandHistory stack to MaterialEditor
Step 4: Wire up Ctrl+Z and Ctrl+Y shortcuts
Step 5: Update UI to disable undo/redo buttons when stack empty
```

**Questions:**
- Are there missing steps?
- What about command merging (dragging sliders)?
- How to handle undo across file loads?
- Memory management for command history?

---

## Session 6: Copilot Coding Agent (8 min)

### Learning Objectives
- Delegate complex tool features to Coding Agent
- Monitor agent progress
- Review and refine agent output

### What is Copilot Coding Agent?

A more autonomous mode where Copilot:
- Understands the entire task scope
- Makes multiple file changes
- Builds and tests the changes
- Iterates on compilation errors

### Invoking Coding Agent

**Method 1: Agent Mode in Chat**
```
@workspace Use agent mode to implement a complete asset tagging system:
- Add "tags" field to AssetMetadata
- UI to add/remove tags per asset
- Tag-based filtering in FilterPanel
- Save/load tags from .assetdb file
- Multi-select to bulk-tag assets
```

**Method 2: Dedicated Agent Panel**
- Open Copilot panel
- Select "Agent" tab
- Describe task in detail

### Demo: Agent Implementation

**Task for Agent:**
```
Implement a complete screenshot capture system for Model Viewer:

1. Screenshot Button in Toolbar:
   - Icon: camera
   - Tooltip: "Capture Screenshot (F12)"
   - Keyboard shortcut: F12

2. Capture Functionality:
   - Capture current framebuffer to image
   - Support sizes: 1x (current), 2x, 4x resolution
   - Remove UI from capture (render model only)
   - Save as PNG with timestamp filename

3. Settings Dialog:
   - Output directory selection
   - Resolution multiplier dropdown
   - Transparent background option
   - "Open folder after save" checkbox

4. Feedback:
   - Flash effect when captured
   - Toast notification with file path
   - Add to recent files list

5. File Management:
   - Default location: ~/Documents/ModelViewerScreenshots/
   - Filename format: screenshot_YYYYMMDD_HHMMSS.png
   - Auto-create directory if not exists

Reference: Use stb_image_write.h for PNG saving
```

**Agent Progress:**
```
[1/12] Reading Model Viewer codebase structure...
[2/12] Creating ScreenshotManager.hpp/.cpp...
[3/12] Adding screenshot button to toolbar...
[4/12] Implementing framebuffer capture logic...
[5/12] Adding F12 keyboard shortcut handling...
[6/12] Creating settings dialog UI...
[7/12] Implementing PNG file writing with stb_image_write...
[8/12] Adding flash effect shader...
[9/12] Implementing toast notification system...
[10/12] Updating CMakeLists.txt with new files...
[11/12] Building to verify compilation...
✓ Build successful
[12/12] Running basic functionality test...

✓ All implementation complete!

Summary of changes:
- Created: ScreenshotManager.hpp, ScreenshotManager.cpp, ScreenshotDialog.hpp, ScreenshotDialog.cpp
- Modified: ModelViewerApp.hpp, ModelViewerApp.cpp, CMakeLists.txt
- Added: Flash effect shader, toast notification widget

Test results:
✓ Screenshot button appears in toolbar
✓ F12 keyboard shortcut works
✓ PNG files saved correctly
✓ Settings dialog functional
✓ Flash effect renders
⚠ Warning: High resolution (4x) capture slow on large models (expected)

Recommendations:
- Consider adding progress bar for high-res captures
- Add format options (JPG, TGA) in future
- Implement thumbnail in toast notification
```

### Best Practices for Agent Tasks

| DO | DON'T |
|----|-------|
| Provide complete context and requirements | Give vague "make it better" requests |
| Reference specific files/classes | Assume agent knows your architecture |
| Specify test criteria | Skip verification steps |
| Review all changes carefully | Auto-accept without reading |
| Break huge features into phases | Request "complete rewrite of tool" |
| Include edge cases in description | Assume agent will think of everything |

### Practice Exercise (3 min)

**Design an agent task:**

```
Write a detailed agent task request for implementing:
"Add recent files menu to Model Viewer"

Include:
- Where recent files stored
- Max number to track
- UI integration points
- File validation (still exists?)
- Keyboard shortcuts
- Test criteria
```

---

## Session 7: Copilot Agent HQ (4 min)

### Learning Objectives
- Organize agents for specific tool domains
- Manage agent permissions and expertise
- Access agent history and metrics

### Agent HQ Overview

**Location**: `.github/agents/` and GitHub web interface

**Game Dev Tools Agent Roster:**

| Agent | Expertise | Files |
|-------|-----------|-------|
| `@opengl-expert` | OpenGL, shaders, rendering | `tools/**/Renderer.*, tools/**/Camera.*` |
| `@imgui-specialist` | ImGui layout, widgets, UI | `tools/**/*Panel.*, tools/**/*App.cpp` |
| `@asset-pipeline` | File loading, Assimp, stb | `tools/**/AssetDatabase.*, tools/**/ModelLoader.*` |
| `@ui-developer` | UI/UX, interactions | `tools/**/*App.*` |
| `@performance-engineer` | Profiling, optimization | All |
| `@code-reviewer` | Quality assurance, safety | All |
| `@build-maintainer` | CMake, dependencies | `tools/CMakeLists.txt, tools/external/**` |
| `@documentation` | Comments, README, guides | `tools/README.md, tools/**/*.md` |

### Agent Configuration

**Agent File Example** (`.github/agents/opengl-expert.agent.md`):
```markdown
---
name: 'opengl-expert'
description: 'OpenGL rendering and graphics programming specialist'
---

You are the OpenGL graphics expert for Game Dev Tools.

**Expertise:**
- Modern OpenGL (3.3+ core profile)
- Shader programming (GLSL)
- Framebuffer operations
- Texture management
- Vertex buffer objects
- Camera and projection matrices

**Reference Files:**
- tools/model_viewer/Renderer.cpp
- tools/model_viewer/Camera.cpp
- tools/common/Application.cpp (OpenGL context setup)
- tools/external/glad/ (OpenGL loading)

**Known Patterns:**
- Use RAII for GL resources
- Check glGetError() in debug builds
- All GL calls on main thread only
- Save/restore GL state when needed

**Response Style:**
- Cite specific GL functions and constants
- Include shader code when relevant
- Warn about driver compatibility issues
- Provide performance notes
- Reference OpenGL documentation
```

**Agent File Example** (`.github/agents/asset-pipeline.agent.md`):
```markdown
---
name: 'asset-pipeline'
description: 'Asset loading, processing, and format conversion expert'
---

You are the asset pipeline specialist for Game Dev Tools.

**Expertise:**
- Assimp model loading (GLTF, FBX, OBJ, etc.)
- Image loading with stb_image
- Thumbnail generation
- File format detection
- Asset metadata extraction
- Path handling and normalization

**Reference Files:**
- tools/asset_browser/AssetDatabase.cpp
- tools/asset_browser/ThumbnailGenerator.cpp
- tools/model_viewer/ModelLoader.cpp
- tools/common/FileSystem.cpp

**Libraries:**
- Assimp: Scene import flags, material properties
- stb_image: Loading, resizing, format conversion
- stb_image_write: PNG/JPG/TGA/BMP output

**Best Practices:**
- Async loading for large files
- Error recovery (don't crash on bad file)
- Progress reporting for batch operations
- Cache parsed data
- Use std::filesystem for paths

**Response Style:**
- Mention supported file formats
- Include error handling
- Note performance implications
- Provide example asset file paths
```

### Using Agents in Practice

**Invoke specific agent:**
```
@opengl-expert How do I render to an offscreen framebuffer at 4x resolution for screenshot capture?
```

**Agent collaboration:**
```
@asset-pipeline and @imgui-specialist work together to add a drag-and-drop import feature for textures
```

---

## Session 8: Architecture & Tech Stack Generation (4 min)

### Learning Objectives
- Generate architecture documentation for tools
- Create tech stack diagrams
- Document system interactions

### Architecture Generation for Model Viewer

**Prompt:**
```
@workspace Generate a detailed architecture diagram for the Model Viewer tool.
Include:
- Class hierarchy and relationships
- Key dependencies (SDL2, OpenGL, ImGui, Assimp)
- Data flow (user input → rendering)
- Component responsibilities
- Integration points between systems
```

**Output:**
```markdown
## Model Viewer Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    ModelViewerApp                       │
│                  (Orchestrates all)                     │
├─────────────────────────────────────────────────────────┤
│  - Main loop coordination                              │
│  - Event dispatching                                   │
│  - UI layout management                                │
└────┬──────────┬──────────┬──────────┬──────────────────┘
     │          │          │          │
     ▼          ▼          ▼          ▼
┌─────────┐ ┌──────┐ ┌─────────┐ ┌──────────────┐
│ Camera  │ │Render│ │ Model   │ │ Mesh         │
│         │ │ er   │ │ Loader  │ │ Inspector    │
├─────────┤ ├──────┤ ├─────────┤ ├──────────────┤
│-position│ │-VAO  │ │-assimp  │ │-stats        │
│-rotation│ │-VBO  │ │-meshes  │ │-hierarchy    │
│-target  │ │-shader│ │-materials│ │-selection   │
│         │ │      │ │         │ │              │
│+orbit() │ │+draw()│ │+load()  │ │+render()     │
│+zoom()  │ │      │ │         │ │              │
└─────────┘ └───┬──┘ └────┬────┘ └──────────────┘
                │         │
                │         ▼
                │    ┌──────────┐
                │    │  Assimp  │
                │    │ Library  │
                │    └──────────┘
                │
                ▼
          ┌──────────┐
          │  OpenGL  │
          │   API    │
          └──────────┘
```

### Class Relationships

```cpp
Application (base class)
  └── ModelViewerApp (derived)
        ├── owns Camera (unique_ptr)
        ├── owns Renderer (unique_ptr)
        ├── owns ModelLoader (unique_ptr)
        └── owns MeshInspector (unique_ptr)

Camera
  - Independent component
  - Provides view/projection matrices

Renderer
  - Depends on: Camera (for matrices)
  - Uses: OpenGL, GLAD
  - Manages: Shaders, VAO/VBO, textures

ModelLoader
  - Depends on: Assimp
  - Produces: Mesh data structures
  - No GL dependencies (decoupled)

MeshInspector
  - Depends on: ImGui
  - Reads: ModelLoader data
  - No GL dependencies
```

### Data Flow

**Loading a Model:**
```
User: File → Open
  ↓
ModelViewerApp::loadModel(path)
  ↓
ModelLoader::load(path)
  ↓
Assimp::Importer.ReadFile()
  ↓
Parse scene → Extract meshes/materials
  ↓
Return std::vector<Mesh>
  ↓
Renderer::uploadMeshes(meshes)
  ↓
Create VAO/VBO for each mesh
  ↓
MeshInspector::setMeshData(meshes)
  ↓
Ready to render ✓
```

**Rendering Loop:**
```
Main Loop (60 FPS):
  ↓
Camera::update(input)
  ↓
Renderer::beginFrame()
  ↓
Renderer::draw(camera.getViewMatrix(), camera.getProjMatrix())
  → glUseProgram(shader)
  → glUniformMatrix4fv(view, proj, model)
  → For each mesh:
      glBindVertexArray(mesh.vao)
      glDrawElements(...)
  ↓
ImGui::BeginFrame()
  → MeshInspector::render()
  → MenuBar, Toolbar, etc.
  ↓
ImGui::Render()
  ↓
SDL_GL_SwapWindow()
```

### Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Windowing** | SDL2 | Window creation, input, context |
| **Graphics API** | OpenGL 3.3+ | 3D rendering |
| **GL Loading** | GLAD | OpenGL function loading |
| **Math** | GLM | Vectors, matrices, transforms |
| **UI** | Dear ImGui | Tool interface |
| **Model Import** | Assimp | GLTF/FBX/OBJ/... parsing |
| **Image Loading** | stb_image | Texture loading |
| **Build** | CMake | Cross-platform build |

### Key Design Decisions

1. **Separation of Concerns:**
   - ModelLoader is GL-agnostic (pure data)
   - Renderer handles all GL state
   - Camera is independent component

2. **Resource Management:**
   - RAII via unique_ptr
   - GL resources cleaned in Renderer destructor
   - No manual delete calls

3. **Threading:**
   - Single-threaded (all GL on main)
   - Future: Async model loading on worker thread

4. **Error Handling:**
   - ModelLoader returns empty vector on error
   - Renderer checks GL errors in debug
   - UI shows error dialogs to user

5. **Extensibility:**
   - Application base class for new tools
   - Plugin pattern for new file formats (Assimp)
   - Shader-based rendering (easy to add effects)
```

### Tech Stack for Asset Browser

**Prompt:**
```
@workspace Document the technology stack for Asset Browser, focusing on:
- Asset scanning and indexing approach
- Thumbnail generation pipeline
- Filtering and search architecture
- UI layout and interactions
```

**Output:**
```markdown
## Asset Browser Tech Stack

### Architecture Overview

```
┌──────────────────────────────────────────────────┐
│            AssetBrowserApp                       │
│         (Main orchestrator)                      │
└───┬────────────┬─────────────┬──────────────┬───┘
    │            │             │              │
    ▼            ▼             ▼              ▼
┌────────┐  ┌─────────┐  ┌──────────┐  ┌──────────┐
│ Asset  │  │Thumbnail│  │ Filter   │  │ Search   │
│Database│  │Generator│  │ Panel    │  │ Bar      │
└────────┘  └─────────┘  └──────────┘  └──────────┘
    │            │
    │            └──────┐
    ▼                   ▼
┌─────────┐      ┌──────────┐
│Filesystem│      │ OpenGL   │
│ Scanner  │      │ Textures │
└─────────┘      └──────────┘
```

### Components

**AssetDatabase:**
- Scans directory trees recursively
- Detects asset type by extension
- Extracts metadata (size, modified date, dimensions)
- Caches results in-memory and on-disk
- Provides filtering/sorting APIs

**ThumbnailGenerator:**
- Creates preview images for assets
- Uses stb_image for image files
- Uses Assimp + GL rendering for 3D models
- Generates thumbnails async (worker thread)
- Uploads to GPU textures (main thread only)
- LRU cache with memory limit

**FilterPanel:**
- Type filters (Models, Textures, Audio, etc.)
- Date range filtering
- File size filtering
- Custom tag filtering
- Communicates via callbacks to app

**SearchBar:**
- Real-time text filtering
- Wildcard pattern matching
- Case-insensitive search
- Highlights matched text in results

### Data Flow

**Initial Directory Scan:**
```
User: Select Folder
  ↓
AssetDatabase::scanDirectory(path)
  ↓
Recursive filesystem walk (std::filesystem)
  ↓
For each file:
  - detectAssetType(extension)
  - extractMetadata()
  - Add to m_assets vector
  ↓
Sort by name/date/size
  ↓
Save cache to ~/.assetbrowser/cache.db
  ↓
Trigger thumbnail generation for visible assets
```

**Thumbnail Generation:**
```
AssetDatabase → Request thumbnail for asset
  ↓
ThumbnailGenerator::generate(assetPath)
  ↓
Check memory cache → If hit, return
  ↓
Check disk cache → If hit, load and return
  ↓
[Worker Thread] Load image/render 3D model
  ↓
[Worker Thread] Resize to thumbnail size
  ↓
[Main Thread] Upload to GL texture
  ↓
[Main Thread] Store in cache
  ↓
Return texture ID
```

**Filtering:**
```
User: Clicks filter checkbox
  ↓
FilterPanel::onFilterChanged()
  ↓
AssetBrowserApp::applyFilters()
  ↓
AssetDatabase::filter(criteria)
  ↓
Return filtered asset list
  ↓
Update grid/list view
  ↓
Request thumbnails for newly visible items
```

### Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **File I/O** | std::filesystem | Cross-platform path handling |
| **Threading** | std::thread, std::mutex | Async thumbnail generation |
| **Image Processing** | stb_image, stb_image_resize | Load and resize images |
| **3D Rendering** | OpenGL + Assimp | Generate 3D model thumbnails |
| **UI** | Dear ImGui | Grid, list, tree views |
| **Caching** | JSON / SQLite | Persistent asset metadata |
| **Text Matching** | std::regex or custom | Search and wildcards |

### Performance Optimizations

1. **Lazy Thumbnail Loading:**
   - Only generate for visible assets
   - Queue system with priority
   - Cancel requests when scrolled out of view

2. **Memory Management:**
   - Texture cache size limit (e.g., 500MB)
   - LRU eviction policy
   - Unload thumbnails for hidden assets

3. **Async Operations:**
   - Directory scanning on background thread
   - Image loading on worker threads
   - GL texture upload on main thread only

4. **Caching Strategy:**
   - L1: In-memory texture cache
   - L2: On-disk thumbnail cache
   - L3: On-disk metadata cache
   - Invalidation on file modification time change

### Future Enhancements

1. **Database Backend:**
   - SQLite for metadata storage
   - Full-text search support
   - Custom tag/rating system

2. **Preview Panel:**
   - Large preview on selection
   - Metadata display (dimensions, format, etc.)
   - Quick actions (open, copy path, delete)

3. **Batch Operations:**
   - Multi-select assets
   - Bulk tag/rename/move
   - Export selected to format

4. **Integration:**
   - Drag-and-drop to external apps
   - Copy path / file to clipboard
   - Launch in default editor
```

---

## Workshop Summary

### Key Takeaways

1. **Chain-of-Thought Prompting:**
   - Break complex problems into logical steps
   - Reason through requirements before coding
   - Identify edge cases early

2. **Instruction Files:**
   - Encode team knowledge and standards
   - Ensure consistent AI behavior
   - Apply context automatically to file types

3. **Prompt Files:**
   - Reusable templates for common tasks
   - Include complete context and test plans
   - Share across team for consistency

4. **Code Review:**
   - Automated quality checks
   - Find issues before they reach production
   - Learn from review feedback

5. **Plan Mode:**
   - Visualize implementation before coding
   - Multi-file changes with checkpoints
   - Review and refine plans

6. **Coding Agent:**
   - Delegate complex, multi-step tasks
   - Autonomous implementation with verification
   - Iterate on build errors

7. **Agent HQ:**
   - Organize specialized agents
   - Domain expertise for tool subsystems
   - Consistent behavior across sessions

8. **Architecture Generation:**
   - Document system design
   - Create diagrams automatically
   - Maintain up-to-date tech stack docs

### Next Steps

1. **Create your instruction files** for the tools project
2. **Build a prompt library** for common tasks
3. **Set up agents** for each tool domain
4. **Practice code review** on existing PRs
5. **Use plan mode** for next feature
6. **Try coding agent** for a complete subsystem

### Resources

- `.github/instructions/` - Team instruction files
- `.github/prompts/` - Reusable prompt templates
- `.github/agents/` - Specialized agent configurations
- `tools/README.md` - Architecture overview
- `tools/ROADMAP.md` - Planned features

---

## Practice Exercises

### Exercise 1: Create Complete Instruction Set
Create instruction files for:
- C++ tool applications
- OpenGL rendering code
- ImGui UI code
- Asset processing code

### Exercise 2: Build Prompt Library
Create prompt files for:
- Adding new ImGui panel
- Implementing asset loader
- Adding camera control mode
- Integrating new library

### Exercise 3: Agent Configuration
Set up agents for:
- OpenGL expert
- ImGui specialist
- Asset pipeline engineer
- Performance optimizer
- Code reviewer

### Exercise 4: Complex Feature with Plan Mode
Use plan mode to add:
- Material editor to Model Viewer
- Tag system to Asset Browser
- Screenshot capture
- Recent files menu

### Exercise 5: Agent Task
Delegate to coding agent:
- Complete screenshot system
- Asset import wizard
- Undo/redo system
- Keyboard shortcut customization

### Exercise 6: Asset Browser to Model Viewer Drag-and-Drop
Use the chain-of-thought prompt from Session 1 to implement drag-and-drop:
- Copy the complete prompt from "Advanced Exercise: Asset Browser to Model Viewer Drag-and-Drop"
- Run in GitHub Copilot Chat or Agent mode
- Follow the 12-step implementation guide
- Verify with the included test plan
- Update documentation as specified

**Success Criteria:**
- [ ] Drag model assets from Asset Browser grid/list
- [ ] Drop onto Model Viewer viewport loads the model
- [ ] Visual feedback shows during drag (highlight border)
- [ ] Loading indicator displays for large models
- [ ] Error handling for unsupported formats
- [ ] Camera auto-focuses on newly loaded model
- [ ] Documentation updated in tools/README.md

---

**Workshop Complete!**

You now have advanced skills in leveraging GitHub Copilot for complex C++ tool development. Apply these techniques to accelerate your Game Dev Tools development!
