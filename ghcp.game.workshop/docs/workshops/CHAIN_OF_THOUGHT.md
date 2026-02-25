# Chain of Thought (CoT) — Visual Studio 2026 Guide for Tools Development

**Date**: February 10, 2026  
**Context**: C++ Game Dev Tools — Asset Browser, Model Viewer, Thumbnail Generator  
**IDE**: Visual Studio 2026 with GitHub Copilot (built-in)  
**Standard**: C++17 · SDL2 · OpenGL 3.3+ · Dear ImGui · Assimp · stb_image

---

## What is Chain of Thought?

Chain of Thought (CoT) is a prompting technique where you **explicitly show the reasoning steps** that lead to a solution, rather than just providing the final answer. It helps break down complex problems into manageable pieces and makes the thinking process transparent.

**Think of it like showing your work in math class** — you don't just write "42", you show:
1. The equation: `2x + 6 = 90`
2. Subtract 6: `2x = 84`
3. Divide by 2: `x = 42`

### Why Chain of Thought Matters for AI-Assisted Coding

When you ask GitHub Copilot a direct question like "Add caching to the thumbnail generator," the AI must guess at:
- **What** data to cache (textures? metadata? both?)
- **Where** to store the cache (memory? disk? both?)
- **When** to invalidate entries (time-based? file-change? manual?)
- **How** to manage memory (size limits? eviction policy?)

With Chain of Thought, **you guide the AI through each decision explicitly**, producing more accurate, well-structured, and maintainable code.

---

## The CORE Framework

All prompts in this guide follow the **CORE Framework** — a structured approach that maximizes Copilot's effectiveness. This framework is recommended by GitHub's prompt engineering best practices.

| Element | Purpose | Example |
|---------|---------|---------|
| **C**ontext | Background information Copilot needs | "I'm working on a C++17 Asset Browser using OpenGL and ImGui" |
| **O**bjective | What you want to accomplish | "Implement thumbnail caching to avoid regenerating on every scan" |
| **R**equirements | Specific constraints and criteria | "Must use RAII, check GL errors, LRU eviction at 500MB" |
| **E**xamples | Reference code, patterns, or outputs | "Follow the RAII pattern in tools/common/TextureManager.hpp" |

### CORE Prompt Template

```markdown
**Context**: [Project type, language, frameworks, relevant files]

**Objective**: [Clear statement of what needs to be done]

**Requirements**:
- [Constraint 1]
- [Constraint 2]
- [Quality criteria]

**Examples/References**:
- [Existing code to follow]
- [Expected output format]
```

---

## Visual Studio 2026 — Copilot Integration

Visual Studio 2026 ships with **GitHub Copilot built-in** (no separate extension required). The AI features are deeply integrated into the IDE.

### Key Access Points

| Feature | Access | Purpose |
|---------|--------|---------|
| **Copilot Chat** | `Ctrl+Shift+I` or Chat panel | Long-form prompts, CoT reasoning, planning |
| **Inline Chat** | `Alt+/` (in editor) | Quick contextual edits in-place |
| **Copilot Edits** | `Ctrl+Shift+I` → Edits tab | Multi-file coordinated changes |
| **Agent Mode** | Toggle in Chat panel | Autonomous multi-step implementation |
| **Next Edit Suggestions** | `Tab` after accepting an edit | AI predicts your next logical edit location |
| **Code Review** | Right-click → Copilot → Review | Automated quality review |
| **Plan Mode** | Chat: "Create a plan to..." | Multi-file change planning |
| **Prompt Files** | `.github/prompts/*.prompt.md` | Reusable team prompt templates |
| **Instruction Files** | `.github/instructions/*.instructions.md` | Auto-applied coding rules |
| **Agent Files** | `.github/agents/*.agent.md` | Specialized domain experts |

### VS2026 Setup Verification

1. **Tools → Options → GitHub → Copilot**
   - ✅ Enable Copilot (on by default in VS2026)
   - ✅ Enable Copilot Chat
   - ✅ Enable Agent Mode
   - ✅ Enable Next Edit Suggestions
   - ✅ Enable Copilot Edits

2. **Keyboard Shortcuts** (VS2026 defaults):
   - `Ctrl+Shift+I` — Open Copilot Chat
   - `Alt+/` — Inline Chat (in editor)
   - `Tab` — Accept suggestion / Next Edit
   - `Esc` — Dismiss suggestion
   - `Ctrl+.` — Quick Actions (includes Copilot actions)

> **Note**: Visual Studio 2026 unified the previously separate "GitHub Copilot" and "GitHub Copilot Chat" extensions into a single built-in experience. If you are on Visual Studio 2022 (17.10+), you need both extensions installed separately — see `docs/workshops/tools_dev/03-advanced-workshop-vs2022.md` for that setup.

---

## Examples Based on C++ Game Dev Tools

> All examples below focus on **tools development** — the Asset Browser, Model Viewer, Thumbnail Generator, and supporting systems. Every prompt uses the **CORE Framework** and is designed to be **copy-pasted directly** into Visual Studio 2026 Copilot Chat (`Ctrl+Shift+I`).

---

### **Example 1: Without Chain of Thought (Direct Answer)**

> **📝 Developer Prompt (Poor):**
> ```
> Add thumbnail caching to AssetBrowser
> ```

❌ **Poor approach:**
> "Add a cache map to ThumbnailGenerator and check it before generating."

**Problems with this approach:**
- No reasoning about **what** data to cache (OpenGL texture handle? raw pixels? both?)
- Skips cache storage design — in-memory only? persistent on disk?
- Ignores invalidation strategy — what if the source file changes?
- No memory management — cache grows unbounded, leaks GPU textures
- Doesn't consider thread safety — thumbnails may generate on worker threads
- Missing error handling — what if cache file is corrupted?

---

### **Example 2: With Chain of Thought — Thumbnail Caching (CORE + CoT)**

> **📝 Developer Prompt (Better):**
>
> Copy-paste this into VS2026 Copilot Chat (`Ctrl+Shift+I`):

```
**Context**:
I'm working on the Asset Browser tool (tools/asset_browser/) which uses C++17,
OpenGL for rendering thumbnails, and ImGui for UI. The ThumbnailGenerator class
in tools/asset_browser/ThumbnailGenerator.hpp currently regenerates every
thumbnail on each directory scan, causing noticeable UI lag with 500+ assets.

**Objective**:
Implement a two-level thumbnail caching system (memory + disk) to avoid
regenerating thumbnails on every directory scan.

**Requirements**:
Let's reason through this step by step:

Step 1: What data needs to be cached?
- Thumbnail OpenGL texture ID (GLuint handle for immediate display)
- File path and last modification time (std::filesystem::last_write_time)
- Image dimensions (width, height for layout calculations)
- Cache entry timestamp (for age-based eviction)

Step 2: Where should the cache be stored?
- L1 (Memory): std::unordered_map<std::string, CachedThumbnail>
  - Key: relative file path (normalized with std::filesystem::path)
  - Fast lookup for currently visible assets
- L2 (Disk): Binary file in ~/.assetbrowser/thumbnail_cache/
  - Stores raw RGBA pixels (not GL textures — those can't be serialized)
  - On cache hit: load pixels → upload to GL texture → store in L1

Step 3: When do we invalidate cache entries?
- File modification time changed (compare stored vs current)
- Source file deleted (remove orphaned cache entries on scan)
- Cache entry older than 30 days (configurable)
- User clicks "Clear Cache" button in UI

Step 4: What's the cache lookup flow?
THUMBNAIL_REQUEST
  → Check L1 memory cache (hash lookup, ~O(1))
  → If hit and valid: return GL texture ID immediately
  → If miss: Check L2 disk cache (file read)
  → If hit and valid: upload to GL, store in L1, return
  → If miss: generate thumbnail on worker thread
  → Store in both L1 and L2

Step 5: Memory management concerns?
- L1 limit: 200MB of GPU textures (configurable)
- LRU eviction: when limit reached, evict least-recently-used entry
- Cleanup: call glDeleteTextures() on evicted entries
- Shutdown: flush L1 metadata to disk, release all GL textures
- Thread safety: std::mutex on L1 map, async generation on worker thread,
  GL texture upload queued back to main thread

Step 6: What's the struct design?
- CachedThumbnail { GLuint textureId; int width; int height;
  std::filesystem::file_time_type lastModified; 
  std::chrono::steady_clock::time_point lastAccessed; }

**Examples/References**:
- Follow the RAII pattern used in tools/common/TextureManager.hpp
- Use the existing FileSystem utility class for path normalization
- Match the Logger pattern: Logger::info("ThumbnailCache", "Hit: {}", path)

Now implement Step 1: Create the CachedThumbnail struct and the 
ThumbnailCache class declaration in ThumbnailCache.hpp
```

✅ **Why this works:**

| Aspect | What CoT provides |
|--------|-------------------|
| **Data model** | CachedThumbnail struct fully specified before coding |
| **Architecture** | Two-level cache with clear L1/L2 responsibilities |
| **Invalidation** | Four explicit strategies, not left to guesswork |
| **Flow** | REQUEST → L1 → L2 → GENERATE pipeline documented |
| **Memory safety** | LRU eviction, GL cleanup, thread-safe access |
| **Implementation order** | "Start with Step 1" focuses Copilot on one piece |

#### What Copilot Produces

With this prompt, Copilot generates a well-structured header:

```cpp
// tools/asset_browser/ThumbnailCache.hpp
#pragma once

#include <chrono>
#include <filesystem>
#include <mutex>
#include <string>
#include <unordered_map>
#include <glad/glad.h>

namespace tools {

struct CachedThumbnail {
    GLuint textureId = 0;
    int width = 0;
    int height = 0;
    std::filesystem::file_time_type lastModified;
    std::chrono::steady_clock::time_point lastAccessed;
    size_t memorySizeBytes = 0;
};

class ThumbnailCache {
public:
    explicit ThumbnailCache(size_t maxMemoryBytes = 200 * 1024 * 1024);
    ~ThumbnailCache();

    // Non-copyable, non-movable (owns GL resources)
    ThumbnailCache(const ThumbnailCache&) = delete;
    ThumbnailCache& operator=(const ThumbnailCache&) = delete;

    /// @brief Look up a thumbnail by asset path
    /// @return GL texture ID, or 0 if not cached
    GLuint lookup(const std::filesystem::path& assetPath);

    /// @brief Store a generated thumbnail in L1 cache
    void store(const std::filesystem::path& assetPath,
               GLuint textureId, int width, int height,
               std::filesystem::file_time_type modTime);

    /// @brief Invalidate a specific entry
    void invalidate(const std::filesystem::path& assetPath);

    /// @brief Clear all cached thumbnails (frees GL textures)
    void clearAll();

    /// @brief Remove entries for deleted files
    void pruneOrphans(const std::vector<std::filesystem::path>& validPaths);

    /// @brief Get current cache memory usage
    size_t getMemoryUsage() const;

private:
    void evictLRU();

    mutable std::mutex m_mutex;
    std::unordered_map<std::string, CachedThumbnail> m_cache;
    size_t m_maxMemoryBytes;
    size_t m_currentMemoryBytes = 0;
};

} // namespace tools
```

---

### **Example 3: Chain of Thought for OpenGL Texture Manager (CORE + CoT)**

> **📝 Developer Prompt:**
>
> Copy-paste into VS2026 Copilot Chat (`Ctrl+Shift+I`):

```
**Context**:
I'm implementing a TextureManager class for the Model Viewer tool
(tools/model_viewer/). The tool uses OpenGL 3.3+ core profile,
stb_image for image loading, and needs to support async texture loading
from worker threads. Currently textures are loaded synchronously,
blocking the UI for 2-3 seconds on large models with many materials.

**Objective**:
Implement a TextureManager with RAII ownership, reference counting via
smart pointers, and a weak-reference cache that safely handles async loading.

**Requirements**:
Let's analyze this step by step:

Step 1 — CREATION: How does a texture go from disk to GPU?
1. Load image data from file (stb_image on worker thread — no GL here)
2. Queue upload request to main thread
3. On main thread: glGenTextures() → glBindTexture() → glTexImage2D()
4. Set filtering: GL_LINEAR_MIPMAP_LINEAR + glGenerateMipmap()
5. Store mapping: filepath → Texture smart pointer

Step 2 — OWNERSHIP: How do we manage texture lifetime?
- std::shared_ptr<Texture> with custom deleter
- Custom deleter calls glDeleteTextures() on the main thread
- Reference counting: multiple meshes can share one texture
- std::weak_ptr<Texture> for cache (doesn't keep texture alive)

Step 3 — CACHE STRATEGY: How do we avoid reloading?
- std::unordered_map<std::string, std::weak_ptr<Texture>> m_cache
- On request: weak_ptr.lock() → if valid, return shared_ptr
- If expired (all users released): reload from disk on next request
- Clear entire cache when OpenGL context is recreated (window resize, etc.)

Step 4 — THREAD SAFETY: What runs where?
- Worker thread: stb_image_load() → produces raw pixel buffer
- Main thread queue: receives (path, pixels, width, height, channels)
- Main thread: creates GL texture from queued pixel data
- std::mutex protects cache map access
- std::condition_variable or lock-free queue for upload requests

Step 5 — ERROR HANDLING: What can fail?
- File not found → return shared_ptr to default "missing.png" texture
- Corrupted image → stbi_failure_reason(), log error, return placeholder
- Out of GPU memory → glGetError() check, fallback to lower resolution
- GL context lost (rare) → invalidate all cached texture IDs
- Request during shutdown → check m_isShuttingDown flag, return nullptr

Step 6 — EDGE CASES:
- Same file requested 3 times simultaneously → deduplicate, only load once
- File modified on disk while cached → detect via file_time_type comparison
- Zero-size textures → validate width/height > 0 before GL calls
- Texture requested after GL context destroyed → guard with context check

**Examples/References**:
- Follow the caching pattern in tools/asset_browser/AssetDatabase.cpp
- Match the Logger pattern: Logger::error("TextureManager", "GL error: 0x{:X}", err)
- RAII pattern reference: tools/common/Application.hpp cleanup flow

Start with the Texture struct definition and shared_ptr setup (Step 2),
then the TextureManager class declaration with the cache and thread-safe queue.
```

#### Verification Checklist
- [x] RAII: Textures auto-deleted via shared_ptr custom deleter
- [x] Cache: weak_ptr avoids preventing cleanup
- [x] Async: Image loading on worker thread, GL upload on main thread
- [x] Thread-safe: Mutex on cache and queue
- [x] Error handling: Placeholder texture for all failure cases
- [x] Edge cases: Dedup, file change detection, shutdown guard

---

### **Example 4: Chain of Thought for Asset Search Feature (CORE + CoT)**

> **📝 Developer Prompt:**
>
> Copy-paste into VS2026 Copilot Chat (`Ctrl+Shift+I`):

```
**Context**:
I'm adding search functionality to the Asset Browser tool
(tools/asset_browser/). The tool uses C++17, ImGui for UI, and
std::filesystem for directory scanning. The AssetDatabase class in
tools/asset_browser/AssetDatabase.hpp maintains a std::vector<AssetMetadata>
of all scanned assets. Currently the browser shows ALL assets with no
way to filter by name. Users report difficulty finding specific files
in projects with 2000+ assets.

**Objective**:
Implement a real-time asset search system with a text input box,
wildcard support, and highlighted matches in the asset grid.

**Requirements**:
Let's reason through this step by step:

Step 1: What UI components are needed?
- ImGui::InputTextWithHint() for the search box in the toolbar
- Clear button (X) using ImGui::SmallButton() next to the input
- Match count display: "Found 42 of 2,150 assets"
- ESC key clears the search and restores full listing

Step 2: What search capabilities do we need?
- Case-insensitive substring matching (default: typing "car" matches "CarModel.fbx")
- Wildcard support: * matches any characters, ? matches one character
- Extension filter shorthand: ".fbx" matches only FBX files
- Search scope: filename only (not full path) for simplicity
- Debounced filtering: wait 100ms after last keystroke before filtering
  (avoids filtering on every character with 2000+ assets)

Step 3: How does filtering integrate with AssetDatabase?
- AssetDatabase gets a new method: filterByQuery(const std::string& query)
- Returns const reference to filtered vector (avoid copying 2000 entries)
- Internally maintains m_filteredAssets alongside m_allAssets
- When query is empty: m_filteredAssets = m_allAssets (show everything)
- Grid/List rendering switches to reading m_filteredAssets

Step 4: How do we implement wildcard matching?
- Convert pattern to case-insensitive: std::tolower on both sides
- "*" → match zero or more characters
- "?" → match exactly one character
- No regex needed — simple two-pointer algorithm
- Function signature: bool matchesWildcard(std::string_view text,
  std::string_view pattern)

Step 5: How do we highlight matching text in the grid?
- Split filename into: [before_match][matched_portion][after_match]
- Render before/after with ImGui::Text() (normal color)
- Render matched portion with ImGui::TextColored() (yellow highlight)
- For wildcard matches: highlight all matching regions
- Use ImGui::SameLine() with spacing=0 to keep text inline

Step 6: Performance considerations?
- 2000 assets × string comparison = fast enough for real-time
- But debounce input to avoid filtering mid-typing
- Cache the filtered results until query changes
- Don't re-sort filtered results (preserve original sort order)
- std::string_view for comparisons (avoid allocations)

**Examples/References**:
- Follow the existing FilterPanel pattern in tools/asset_browser/FilterPanel.cpp
- Use ImGui::InputTextWithHint() per ImGui documentation
- Match text highlighting similar to VS2026's own search results highlighting
- Logger::debug("SearchBar", "Query '{}' matched {} assets", query, count)

Start with Step 1 and Step 4: Create a SearchBar class with the
ImGui input and the wildcard matching utility function.
```

#### What This Produces

**SearchBar class with wildcard matching:**

```cpp
// tools/asset_browser/SearchBar.hpp
#pragma once

#include <string>
#include <string_view>
#include <chrono>

namespace tools {

class SearchBar {
public:
    /// @brief Render the search bar in ImGui toolbar
    /// @return true if the query changed this frame
    bool render();

    /// @brief Get the current search query
    const std::string& getQuery() const { return m_query; }

    /// @brief Check if search is active
    bool isActive() const { return !m_query.empty(); }

    /// @brief Clear the search
    void clear();

    /// @brief Wildcard pattern matching (case-insensitive)
    /// Supports * (any characters) and ? (single character)
    static bool matchesWildcard(std::string_view text, std::string_view pattern);

private:
    char m_inputBuffer[256] = {};
    std::string m_query;
    std::chrono::steady_clock::time_point m_lastKeystroke;
    bool m_needsFilter = false;

    static constexpr auto DEBOUNCE_MS = std::chrono::milliseconds(100);
};

} // namespace tools
```

**Wildcard implementation (Step 4):**

```cpp
bool SearchBar::matchesWildcard(std::string_view text, std::string_view pattern) {
    size_t t = 0, p = 0;
    size_t starIdx = std::string_view::npos;
    size_t matchIdx = 0;

    auto toLower = [](char c) -> char {
        return static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
    };

    while (t < text.size()) {
        if (p < pattern.size() && (toLower(pattern[p]) == toLower(text[t]) || pattern[p] == '?')) {
            ++t; ++p;
        } else if (p < pattern.size() && pattern[p] == '*') {
            starIdx = p++;
            matchIdx = t;
        } else if (starIdx != std::string_view::npos) {
            p = starIdx + 1;
            t = ++matchIdx;
        } else {
            return false;
        }
    }
    while (p < pattern.size() && pattern[p] == '*') { ++p; }
    return p == pattern.size();
}
```

#### Verification Checklist
- [x] Search box in toolbar with hint text and clear button
- [x] Case-insensitive substring matching
- [x] Wildcard support (* and ?)
- [x] Debounced filtering (100ms delay)
- [x] Match count display in status bar
- [x] ESC key clears search
- [x] No per-character allocations (std::string_view)
- [x] Filtered results cached until query changes
- [x] Don't re-sort filtered results (original order preserved)
- [x] Zero-allocation comparisons with std::string_view

---

### **Example 5: Chain of Thought for Screenshot Capture System (CORE + CoT)**

> **📝 Developer Prompt:**
>
> Copy-paste into VS2026 Copilot Chat (`Ctrl+Shift+I`):

```
**Context**:
I'm adding screenshot capture to the Model Viewer tool (tools/model_viewer/).
The tool uses C++17, OpenGL 3.3+ for rendering, SDL2 for windowing, and ImGui
for UI. The Renderer class in tools/model_viewer/Renderer.hpp draws 3D models
to the default framebuffer. stb_image_write.h is already available in external/.
Currently there is no way to save the rendered view to a file.

**Objective**:
Implement a screenshot capture system that renders the model without UI,
supports multiple resolution multipliers, and saves to PNG with a
timestamp-based filename.

**Requirements**:
Let's reason through this step by step:

Step 1: How do we capture the framebuffer to an image?
1. Create an offscreen framebuffer (FBO) at target resolution
2. Attach color buffer (GL_RGBA8) and depth buffer (GL_DEPTH_COMPONENT24)
3. Bind FBO → call Renderer::draw() (model only, no ImGui) → unbind FBO
4. glReadPixels() from the FBO into a CPU-side pixel buffer
5. Flip vertically (OpenGL origin is bottom-left, images are top-left)
6. Write to PNG using stbi_write_png()

Step 2: How do we support multiple resolutions?
- 1x: current window size (e.g., 1920×1080)
- 2x: double dimensions (3840×2160)
- 4x: quadruple dimensions (7680×4320)
- FBO is created at the target resolution
- Camera aspect ratio must match (use target width/height)
- Projection matrix recalculated for the target dimensions
- Restore original viewport and projection after capture

Step 3: How do we render without ImGui?
- Normal render loop: Renderer::draw() → ImGui::Render() → swap
- Screenshot render: Bind FBO → Renderer::draw() only → unbind FBO
- The Renderer::draw() method already accepts view/projection matrices
- No need to suppress ImGui — we simply don't call it during FBO render
- Background: configurable (solid color or transparent if alpha channel)

Step 4: File management
- Default directory: ~/Documents/ModelViewerScreenshots/
- Create directory if it doesn't exist: std::filesystem::create_directories()
- Filename format: screenshot_YYYYMMDD_HHMMSS.png
- Timestamp via std::chrono + std::put_time
- Avoid overwrites: if file exists, append _1, _2, etc.

Step 5: User feedback
- F12 keyboard shortcut (SDL_SCANCODE_F12)
- Brief white flash overlay (fade from 0.5 alpha to 0 over 0.3 seconds)
- ImGui toast notification: "Screenshot saved: <filepath>"
- Toast auto-dismisses after 3 seconds
- Error toast (red) if save fails

Step 6: UI settings
- ImGui combo box for resolution: "1x (1920×1080)", "2x", "4x"
- Directory path display with "Browse..." button
- Checkbox: "Transparent background"
- Checkbox: "Open folder after save"
- Settings saved to JSON config file

Step 7: OpenGL resource management
- FBO created on-demand, destroyed after capture (simple, avoids stale resources)
- Alternative: keep FBO allocated, resize on resolution change (faster repeated captures)
- Decision: Create on-demand for simplicity — screenshots are infrequent
- Must check: glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE
- Must cleanup: glDeleteFramebuffers, glDeleteTextures, glDeleteRenderbuffers on all paths
- Use RAII scope guard: auto fboGuard = ScopeGuard([&]{ cleanup(); })

**Examples/References**:
- OpenGL FBO pattern from tools/common/Application.cpp (context setup)
- stb_image_write usage: stbi_write_png(path, w, h, 4, pixels, stride)
- Follow the Logger pattern for all error reporting
- SDL keyboard: SDL_SCANCODE_F12 in event handling

Start with Step 1: Create a ScreenshotManager class with the FBO capture method.
Then Step 4: file naming and directory creation.
```

#### Verification Checklist
- [x] FBO created at correct resolution (1x, 2x, 4x)
- [x] Scene rendered without ImGui
- [x] Transparent background option works
- [x] Pixels flipped vertically for correct orientation
- [x] PNG saved with timestamp filename
- [x] Directory auto-created
- [x] RAII cleanup of FBO resources on all paths
- [x] GL state (viewport, framebuffer binding) restored after capture
- [x] Error handling with Logger for all failure points

---

### **Example 6: Chain of Thought for Drag-and-Drop File Loading (CORE + CoT)**

> **📝 Developer Prompt:**
>
> Copy-paste into VS2026 Copilot Chat (`Ctrl+Shift+I`):

```
**Context**:
I'm adding drag-and-drop file loading to the Model Viewer tool
(tools/model_viewer/). The tool uses SDL2 for window management,
ImGui for UI, and Assimp via ModelLoader for loading 3D models.
Currently models are loaded only through File → Open menu dialog.
ModelViewerApp::loadModel(const std::string& path) handles the
loading flow. The tool supports .gltf, .glb, .fbx, .obj, and .dae formats.

**Objective**:
Implement drag-and-drop support so users can drop model files onto
the application window to load them.

**Requirements**:
Think through these steps:

Step 1: SDL2 drag-and-drop events
- SDL2 fires SDL_DROPFILE event when a file is dropped on the window
- The event contains event.drop.file (char* to the file path)
- Must call SDL_free(event.drop.file) after processing (SDL allocates it)
- SDL_DROPBEGIN and SDL_DROPCOMPLETE for multi-file drops
- Enable with SDL_EventState(SDL_DROPFILE, SDL_ENABLE) — may be on by default

Step 2: File validation
- Extract file extension: std::filesystem::path(file).extension()
- Check against supported formats: {".gltf", ".glb", ".fbx", ".obj", ".dae"}
- Case-insensitive comparison (user might drop "Model.FBX")
- If unsupported: show error toast "Unsupported format: .xyz"
- If file doesn't exist (edge case with shortcuts): check std::filesystem::exists()

Step 3: Current model cleanup
- The existing loadModel() already handles cleanup:
  - Renderer::clearMeshes() releases VAOs/VBOs
  - ModelLoader::unload() frees Assimp scene
  - MeshInspector::clear() resets stats
- Reuse loadModel() — don't duplicate cleanup logic
- Question: Block drop during active load? Yes — check m_isLoading flag

Step 4: UI feedback
- During drag hover: show overlay "Drop model file to open"
  - SDL_DROPBEGIN fires when drag enters window
  - SDL_DROPCOMPLETE fires when drag leaves or file dropped
  - Render a semi-transparent overlay with ImGui during hover
- During load: show existing loading spinner
- After load: show existing model info in MeshInspector

Step 5: Error handling
- Invalid file format → toast notification with supported formats list
- File not found → toast "File not found: <path>"
- Load failure (corrupted file) → toast with Assimp error message
- Multiple files dropped → load only the first model file, ignore rest
  (toast: "Loaded first file. Multi-model not supported yet.")

Step 6: Integration into event loop
- Add SDL_DROPFILE case to Application::processEvents()
- Forward to ModelViewerApp::onFileDrop(const std::string& path)
- Keep event handling in base Application class (reusable for Asset Browser too)
- Override in ModelViewerApp for tool-specific validation and loading

**Examples/References**:
- Existing loadModel() flow in ModelViewerApp.cpp
- SDL event handling pattern in tools/common/Application.cpp
- Toast notification pattern (if exists) or ImGui overlay
- Logger::info("ModelViewer", "File dropped: {}", path)

Start with Step 1: Add SDL_DROPFILE event handling in Application.cpp,
then Step 2: file validation in ModelViewerApp::onFileDrop().
```

#### Implementation Result

**Base class event handling (Step 1+6):**

```cpp
// tools/common/Application.cpp — in processEvents()
case SDL_DROPBEGIN:
    onDragEnter();
    break;

case SDL_DROPCOMPLETE:
    onDragLeave();
    break;

case SDL_DROPFILE: {
    std::string filePath(event.drop.file);
    SDL_free(event.drop.file);
    onFileDrop(filePath);
    onDragLeave();  // Reset drag overlay state
    break;
}
```

**Model Viewer specific handling (Steps 2-5):**

```cpp
// tools/model_viewer/ModelViewerApp.cpp
void ModelViewerApp::onFileDrop(const std::string& filePath) {
    // Step 2: Validate file
    std::filesystem::path path(filePath);

    if (!std::filesystem::exists(path)) {
        showToast("File not found: " + path.filename().string(), ToastType::Error);
        Logger::error("ModelViewer", "Dropped file not found: {}", filePath);
        return;
    }

    auto ext = path.extension().string();
    std::transform(ext.begin(), ext.end(), ext.begin(),
        [](unsigned char c) { return std::tolower(c); });

    static const std::set<std::string> supportedFormats = {
        ".gltf", ".glb", ".fbx", ".obj", ".dae"
    };

    if (supportedFormats.find(ext) == supportedFormats.end()) {
        showToast("Unsupported format: " + ext +
                  "\nSupported: .gltf, .glb, .fbx, .obj, .dae", ToastType::Error);
        Logger::warn("ModelViewer", "Unsupported file format: {}", ext);
        return;
    }

    // Step 3: Check if already loading
    if (m_isLoading) {
        showToast("Please wait — model is loading...", ToastType::Warning);
        return;
    }

    // Step 3: Reuse existing load path (handles cleanup)
    Logger::info("ModelViewer", "Loading dropped file: {}", filePath);
    loadModel(filePath);
}
```

#### Verification Checklist
- [x] SDL_DROPFILE event handled and SDL_free() called
- [x] File extension validated (case-insensitive)
- [x] Unsupported formats show error toast
- [x] Missing files detected before loading
- [x] Existing loadModel() reused (no duplicate cleanup logic)
- [x] Loading blocked during active load
- [x] Drag-hover overlay shows during drag
- [x] Base class handles SDL event, derived class handles validation
- [x] Multiple file drops handled (first file only)

---

## Why Chain of Thought Matters for Tools Development

### **Without Chain of Thought:**
- ❌ Cache thumbnails in-memory only — runs out of GPU memory with large asset sets
- ❌ Load textures synchronously — blocks UI for seconds on large models
- ❌ Implement search without debouncing — lags on every keystroke with 2000+ files
- ❌ Capture screenshots without restoring GL state — corrupts subsequent renders
- ❌ Handle drag-and-drop without cleanup — memory leak from unfreed SDL strings

### **With Chain of Thought:**
1. ✅ Design two-level cache (L1 memory + L2 disk) with LRU eviction and size limits
2. ✅ Split texture loading: async pixel read on worker, GL upload on main thread
3. ✅ Debounce search input, use string_view for zero-allocation comparisons
4. ✅ Use RAII scope guard for FBO cleanup, restore viewport and framebuffer binding
5. ✅ Free SDL strings, validate files, reuse existing load/cleanup paths

### **Result:**
- **Robust tools** — error handling for every failure path
- **Performant** — async loading, caching, debounced filtering
- **Memory-safe** — RAII everywhere, smart pointers, GL resource cleanup
- **Maintainable** — clear separation of concerns, documented reasoning
- **Testable** — each step has specific success criteria

---

## How to Write CORE + CoT Prompts in Visual Studio 2026

### The Key Principles

| Principle | Poor Prompt | Better Prompt (CORE + CoT) |
|-----------|-------------|----------------------------|
| **C — Context** | "Add caching" | "Asset Browser tool, C++17, OpenGL textures, 500+ assets cause lag" |
| **O — Objective** | "Make it faster" | "Implement two-level thumbnail caching to avoid regeneration on scan" |
| **R — Requirements** | (silent) | "Step 1: What to cache? Step 2: Where to store? Step 3: When to invalidate?" |
| **E — Examples** | (silent) | "Follow the RAII pattern in tools/common/TextureManager.hpp" |

### VS2026 Copilot Chat — Copy-Paste Template

```markdown
**Context**:
I'm working on [TOOL_NAME] (tools/[tool_dir]/) which uses C++17, 
[FRAMEWORK_1] for [PURPOSE], and [FRAMEWORK_2] for [PURPOSE].
Currently [DESCRIBE_CURRENT_STATE_AND_PROBLEM].

**Objective**:
Implement [FEATURE] to [SOLVE_PROBLEM].

**Requirements**:
Let's reason through this step by step:

Step 1: [FIRST_DESIGN_QUESTION]
- [Consideration A]
- [Consideration B]
- [Decision and rationale]

Step 2: [SECOND_DESIGN_QUESTION]
- [Consideration A]
- [Consideration B]
- [Decision and rationale]

Step 3: [THIRD_DESIGN_QUESTION]
- [Consideration A]
- [Consideration B]
- [Decision and rationale]

Step 4: [ERROR_HANDLING_QUESTION]
- [What can fail?]
- [How to recover?]

Step 5: [PERFORMANCE_OR_EDGE_CASE_QUESTION]
- [Concern A]
- [Mitigation]

**Examples/References**:
- Follow [EXISTING_PATTERN] in [FILE_PATH]
- Use [EXISTING_UTILITY] for [PURPOSE]
- Match Logger pattern for error reporting
```

### Anti-Patterns to Avoid

| ❌ Don't | ✅ Do Instead |
|----------|--------------|
| "Add caching" | "Implement L1 memory + L2 disk thumbnail cache with LRU eviction" |
| "Make it thread-safe" | "Image load on worker thread, GL upload on main thread, mutex on cache" |
| "Handle errors" | "File not found → placeholder texture; GL error → log + fallback; shutdown → guard flag" |
| "Just make it work" | "Follow the RAII pattern in TextureManager.hpp with custom shared_ptr deleter" |
| "Figure it out" | "First validate file extension case-insensitively, then check file exists" |
| "Add search" | "ImGui::InputTextWithHint with debounce, wildcard matching, highlighted results" |

---

## VS2026 Advanced Features for Chain of Thought

### Using Copilot Edits for Multi-File CoT

VS2026 **Copilot Edits** (`Ctrl+Shift+I` → Edits tab) can apply CoT reasoning across multiple files simultaneously. After generating a plan with CoT, switch to Edits mode:

```
Apply the ThumbnailCache design from our previous conversation.
Create:
- tools/asset_browser/ThumbnailCache.hpp (class declaration)
- tools/asset_browser/ThumbnailCache.cpp (implementation)
Modify:
- tools/asset_browser/AssetBrowserApp.hpp (add m_thumbnailCache member)
- tools/asset_browser/AssetBrowserApp.cpp (integrate into scan flow)
- tools/CMakeLists.txt (add new source files)
```

### Using Next Edit Suggestions with CoT

After accepting a CoT-generated change (e.g., adding the `CachedThumbnail` struct), VS2026's **Next Edit Suggestions** will:
1. Predict you need to update the `.cpp` file next
2. Suggest the constructor or method implementation
3. Guide you to update `CMakeLists.txt`

Press `Tab` to flow through the predicted edit chain.

### Using Agent Mode for Complete CoT Implementation

Toggle **Agent Mode** in the Chat panel for fully autonomous implementation:

```
**Context**:
[Full CORE + CoT prompt as shown in examples above]

Implement this feature completely using agent mode:
1. Create all new files
2. Modify all integration points
3. Update CMakeLists.txt
4. Build and fix any compilation errors
5. Report what was created and any issues
```

Agent Mode in VS2026 will:
- Create files
- Make coordinated multi-file edits
- Run the build (`cmake --build`)
- Iterate on compilation errors
- Report final status

### Using Instruction Files to Enhance CoT

Create `.github/instructions/tools-cot.instructions.md` to automatically apply CoT patterns:

```markdown
---
applyTo: 'tools/**/*.{cpp,hpp}'
---

When implementing new features in tools/, always reason through:
1. What data structures are needed (structs, classes)
2. Memory management (RAII, smart pointers, GL resource cleanup)
3. Thread safety (what runs on main thread vs worker)
4. Error handling (file not found, GL errors, invalid input)
5. Performance (caching, async loading, debouncing)
6. Integration with existing systems (Logger, Application base, CMake)

Follow the CORE framework for all implementation decisions.
```

### Using Prompt Files for Reusable CoT Templates

Create `.github/prompts/cot-new-tool-feature.prompt.md`:

```markdown
---
mode: 'agent'
description: 'Implement a new tool feature using Chain of Thought reasoning'
---

**Context**:
Tool: {{TOOL_NAME}} in tools/{{TOOL_DIR}}/
Tech: C++17, {{FRAMEWORKS}}
Current state: {{CURRENT_STATE}}
Problem: {{PROBLEM}}

**Objective**:
{{OBJECTIVE}}

**Requirements**:
Reason through step by step:

Step 1: Data model — What structs/classes are needed?
Step 2: Core logic — What's the algorithm/flow?
Step 3: Memory — RAII, smart pointers, GL resources?
Step 4: Threading — Main thread vs worker thread boundaries?
Step 5: Errors — What can fail and how to recover?
Step 6: Performance — Caching, async, batching?
Step 7: Integration — How does this connect to existing systems?

**Examples/References**:
- {{REFERENCE_FILES}}
- Follow .github/copilot-instructions.md patterns

Create the implementation starting with Step 1.
```

Invoke in VS2026 Copilot Chat:
```
Use #file:.github/prompts/cot-new-tool-feature.prompt.md with:
- TOOL_NAME = Asset Browser
- TOOL_DIR = asset_browser
- FRAMEWORKS = ImGui, OpenGL, std::filesystem
- CURRENT_STATE = Assets displayed in grid, no tagging system
- PROBLEM = Users can't organize or categorize assets
- OBJECTIVE = Add an asset tagging system with UI, storage, and filtering
- REFERENCE_FILES = tools/asset_browser/FilterPanel.cpp, AssetDatabase.hpp
```

---

## Chain of Thought Template for Any Tools Development Problem

### Copy-Paste Template

```markdown
### Problem: [Describe the feature or bug fix]

#### Step 1: Understand Current State
- What exists in the codebase? (check tools/[tool_name]/)
- What class/file is responsible? (check the .hpp file)
- What's the current behavior vs desired behavior?
- What frameworks/libraries are involved?

#### Step 2: Identify Dependencies
- What other classes are needed? (Renderer, Camera, AssetDatabase, etc.)
- What libraries does this touch? (OpenGL, ImGui, SDL2, Assimp, stb)
- What thread does this run on? (main thread for GL, worker for I/O)
- What files need to be modified?

#### Step 3: Design the Solution
Use CORE framework:
- **Context**: [Tool, tech, current state]
- **Objective**: [Clear goal]
- **Requirements**: [Step-by-step reasoning]
- **Examples**: [Existing patterns to follow]

Optionally use Tree-of-Thought for design decisions:
- Option A: [Approach + pros/cons]
- Option B: [Approach + pros/cons]
- Decision: [Chosen option] because [rationale]

#### Step 4: Implementation Plan
1. [Struct/class declaration in .hpp]
2. [Core logic in .cpp]
3. [Error handling additions]
4. [Integration into App class]
5. [CMakeLists.txt update]

#### Step 5: Verify Against Requirements
- [ ] Feature works as described
- [ ] Error handling covers all failure paths
- [ ] Memory management is correct (no leaks, RAII)
- [ ] Thread safety maintained (GL on main, I/O on worker)
- [ ] Performance acceptable (no per-frame allocations)

#### Step 6: Test Plan
- Build: cmake --build build --config Debug
- Run tool and verify [specific behavior]
- Edge cases: [file not found, GL error, empty input, large dataset]
```

---

## Key Takeaway

**Chain of Thought = Show your reasoning work**, just like in math class.

For C++ tools development, this means:
1. **What** data structures do we need before writing any code?
2. **Where** does each operation execute — main thread or worker thread?
3. **How** do we manage OpenGL resources safely with RAII?
4. **What** can fail and how do we recover gracefully?
5. **How** does this integrate with the existing Application/Logger/CMake patterns?

This structured thinking prevents:
- GPU memory leaks from uncleaned textures
- UI freezes from synchronous file loading
- Crashes from null pointers on failed operations
- Broken GL state from unreversed modifications
- Build failures from missing CMakeLists.txt entries

---

## Additional Resources

### Visual Studio 2026 Copilot Documentation
- **VS2026 Copilot Overview**: [learn.microsoft.com — Visual Studio Copilot](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-install-and-states)
- **Copilot Chat in VS**: [learn.microsoft.com — Copilot Chat](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-chat)
- **Custom Instructions**: [docs.github.com — Instruction Files](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-instructions-for-github-copilot)
- **Prompt Engineering Best Practices**: [docs.github.com — Prompt Engineering](https://docs.github.com/en/copilot/using-github-copilot/prompt-engineering-for-github-copilot)

### Workshop Files
- **VS2022 Version** (alternate): `docs/workshops/tools_dev/03-advanced-workshop-vs2022.md`
- **Tools Workshop**: `docs/workshops/tools_dev/03-advanced-workshop-tools.md`
- **Tree of Thought Guide**: `docs/workshops/TREE_OF_THOUGHT.md`
- **Key Definitions**: `docs/workshops/tools_dev/00-key-definitions-and-best-practices-tools.md`

### Project Architecture
- **Architecture**: `docs/ARCHITECTURE.md` — System hierarchy and signal flow
- **Coding Standards**: `docs/CODING_STANDARDS.md` — C++ conventions and patterns
- **Game Spec** (for tools context): `docs/SPEC.md` — Asset types, data formats

### Source Code References
- **Application Base**: `tools/common/Application.hpp` — Base class for all tools
- **Asset Database**: `tools/asset_browser/AssetDatabase.hpp` — Asset scanning and metadata
- **Model Loader**: `tools/model_viewer/ModelLoader.hpp` — Assimp integration
- **Renderer**: `tools/model_viewer/Renderer.hpp` — OpenGL drawing pipeline

### Instruction & Prompt Files
- **Repo Instructions**: `.github/copilot-instructions.md` — Global Copilot rules
- **Path Instructions**: `.github/instructions/` — Per-file-type rules
- **Prompt Templates**: `.github/prompts/` — Reusable CORE prompt files
- **Agent Definitions**: `.github/agents/` — Specialized domain agents

---

**Author**: GitHub Copilot  
**Context**: C++ Game Dev Tools — Visual Studio 2026 Chain of Thought Guide  
**Last Updated**: February 10, 2026
