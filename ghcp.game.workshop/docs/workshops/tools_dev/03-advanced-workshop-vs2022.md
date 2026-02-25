# Workshop 3: Advanced GitHub Copilot for Visual Studio 2022
## Chain-of-Thought, Tree-of-Thought, Instruction Files, Agents, and Planning

**Duration**: 90 Minutes  
**Level**: Advanced  
**Prerequisites**: Foundational + Intermediate Workshops, Visual Studio 2022 17.10+  
**Project**: C++ Game Development (SDL2 / OpenGL / ImGui / Godot GDExtension)

---

## Workshop Objectives

By the end of this workshop, participants will master:

| Capability | VS2022 Integration | Section |
|------------|-------------------|---------|
| **Chain-of-Thought Prompting** | Copilot Chat (Ctrl+Shift+I) | Session 1 |
| **Tree-of-Thought Prompting** | Copilot Chat + Inline Chat | Session 2 |
| **Instruction Files** | `.github/copilot-instructions.md` | Session 3 |
| **Prompt Files** | `.github/prompts/*.prompt.md` | Session 4 |
| **Copilot Code Review** | Right-click ? Copilot Review | Session 5 |
| **Copilot Plan Mode** | Copilot Chat `/plan` command | Session 6 |
| **Copilot Coding Agent** | Agent Mode in Copilot Chat | Session 7 |
| **Copilot Agent HQ** | `.github/agents/*.agent.md` | Session 8 |
| **Architecture & Tech Stack Generation** | Copilot Chat documentation | Session 9 |

---

## Visual Studio 2022 Setup Requirements

### Minimum Version
- **Visual Studio 2022 17.10** or later (required for full Copilot integration)
- **GitHub Copilot extension** installed and signed in
- **GitHub Copilot Chat extension** installed

### Enable All Features
1. **Tools ? Options ? GitHub Copilot ? General**
   - ? Enable GitHub Copilot
   - ? Enable completions
   - ? Enable Copilot Chat
   
2. **Tools ? Options ? GitHub Copilot ? Chat**
   - ? Enable Agent Mode (if available)
   - ? Enable Plan Mode

3. **Keyboard Shortcuts** (default):
   - `Ctrl+Shift+I` — Open Copilot Chat
   - `Alt+/` — Inline Chat (in editor)
   - `Tab` — Accept suggestion
   - `Esc` — Dismiss suggestion

### Workspace Setup
```
your-project/
??? .github/
?   ??? copilot-instructions.md      # Repo-wide instructions
?   ??? instructions/                 # Path-specific instructions
?   ?   ??? cpp-gameplay.instructions.md
?   ?   ??? opengl-rendering.instructions.md
?   ?   ??? imgui-ui.instructions.md
?   ??? prompts/                      # Reusable prompt files
?   ?   ??? add-panel.prompt.md
?   ?   ??? implement-feature.prompt.md
?   ?   ??? code-review.prompt.md
?   ??? agents/                       # Agent configurations
?       ??? opengl-expert.agent.md
?       ??? gameplay-engineer.agent.md
??? src/
??? tools/
??? docs/
```

---

## The CORE Framework for Prompt Engineering

All prompts in this workshop follow the **CORE Framework** — a structured approach that maximizes Copilot's effectiveness:

| Element | Purpose | Example |
|---------|---------|---------|
| **C**ontext | Background information Copilot needs | "I'm working on a C++ game using SDL2 and OpenGL 3.3" |
| **O**bjective | What you want to accomplish | "Create a texture loading function with error handling" |
| **R**equirements | Specific constraints and criteria | "Must use RAII, check GL errors, return placeholder on failure" |
| **E**xamples | Reference code, patterns, or outputs | "Similar to the existing ModelLoader pattern in ModelLoader.cpp" |

### CORE Prompt Template
```
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

## Agenda

| Time | Topic | Format |
|------|-------|--------|
| 0:00 - 0:12 | Chain-of-Thought Prompting | Presentation + Demo |
| 0:12 - 0:24 | Tree-of-Thought Prompting | Live Demo + Practice |
| 0:24 - 0:36 | Instruction Files | Live Creation |
| 0:36 - 0:48 | Prompt Files | Workshop Exercise |
| 0:48 - 0:58 | Copilot Code Review | Demo + Practice |
| 0:58 - 1:08 | Copilot Plan Mode | Live Demo |
| 1:08 - 1:18 | Copilot Coding Agent | Hands-On |
| 1:18 - 1:24 | Copilot Agent HQ | Configuration |
| 1:24 - 1:30 | Architecture Generation | Quick Demo |

---

## Session 1: Chain-of-Thought Prompting (12 min)

### Learning Objectives
- Break down complex C++ problems into reasoning steps
- Guide Copilot through multi-step implementations
- Use CORE framework for structured prompting in VS2022

### What is Chain-of-Thought?

Chain-of-Thought (CoT) prompting guides the AI through **step-by-step reasoning** rather than asking for a complete solution at once. This produces more accurate, well-structured code.

**VS2022 Access**: Press `Ctrl+Shift+I` to open Copilot Chat, or `Alt+/` for inline chat.

### ? Without Chain-of-Thought (Weak Prompt)

```
Add thumbnail caching to AssetBrowser
```

**Problem**: Vague, no structure, Copilot guesses at requirements.

### ? With Chain-of-Thought (CORE Framework)

**Copy-paste this prompt into VS2022 Copilot Chat (`Ctrl+Shift+I`):**

```
**Context**: 
I'm working on the Asset Browser tool (tools/asset_browser/) which uses C++17, 
OpenGL for textures, and ImGui for UI. Currently thumbnails are regenerated 
on every directory scan, causing performance issues.

**Objective**: 
Implement thumbnail caching to avoid regenerating thumbnails on every scan.

**Requirements**:
Let's reason through this step by step:

Step 1: What data needs to be cached?
- Thumbnail texture ID (OpenGL texture handle)
- File path and modification time (to detect changes)
- Image dimensions
- Cache creation timestamp

Step 2: Where should the cache be stored?
- In-memory: std::unordered_map<std::string, CachedThumbnail>
- On-disk: JSON file in user data directory
- Key: file path hash or relative path

Step 3: When do we invalidate cache entries?
- File modification time changed
- File deleted
- Cache entry older than X days
- Manual cache clear button

Step 4: What's the cache lookup flow?
REQUEST ? Check memory cache ? If miss, check disk cache ? If miss, generate ? Store in both

Step 5: Memory management concerns?
- Limit total cache size (e.g., 500MB)
- LRU eviction when limit reached
- Cleanup OpenGL textures on eviction

**Examples/References**:
- Follow the RAII pattern used in tools/common/TextureManager.hpp
- Use the existing FileSystem utility class for path operations

Now implement Step 1: Create the CachedThumbnail struct in ThumbnailGenerator.hpp
```

### CoT Demo: OpenGL Resource Manager

**Copy-paste prompt for VS2022 Copilot Chat:**

```
**Context**:
I'm implementing a TextureManager class for our Model Viewer tool. The tool uses 
OpenGL 3.3+ core profile, stb_image for loading, and needs to be thread-safe for 
async loading.

**Objective**:
Implement a TextureManager that handles OpenGL texture lifecycle safely with 
smart pointers and reference counting.

**Requirements**:
Let's analyze this step by step:

1. CREATION:
   - Load image data from file (using stb_image)
   - Generate OpenGL texture ID: glGenTextures()
   - Upload to GPU with proper format/filtering
   - Store mapping: filepath ? texture_id

2. OWNERSHIP:
   - Use std::shared_ptr with custom deleter
   - Deleter calls glDeleteTextures() automatically
   - Reference counting prevents premature deletion
   - Weak references for cache without ownership

3. CACHE STRATEGY:
   - std::unordered_map<std::string, std::weak_ptr<Texture>>
   - On request: check weak_ptr.lock() ? if valid, return
   - If expired, reload from disk
   - Clear cache on OpenGL context recreation

4. THREAD SAFETY:
   - Image loading can be async (worker thread)
   - OpenGL calls MUST be on main thread
   - Use std::mutex for cache map access
   - Queue texture uploads from worker thread

5. ERROR HANDLING:
   - Invalid file path ? return default "missing" texture
   - Out of GPU memory ? fallback to lower resolution
   - OpenGL context lost ? invalidate all texture IDs

6. EDGE CASES:
   - Texture requested during shutdown ? check context validity
   - Same file requested multiple times ? deduplicate requests
   - File changed on disk ? detect via timestamp, reload

**Examples/References**:
- Similar to the caching pattern in AssetDatabase.cpp
- Follow the Logger pattern for error reporting

Start with the Texture struct and smart pointer setup.
```

### Practice Exercise (4 min)

**Task**: Use CoT for implementing drag-and-drop in Model Viewer.

**Copy-paste prompt:**

```
**Context**:
I'm adding file drag-and-drop support to the Model Viewer tool (tools/model_viewer/).
The tool uses SDL2 for window management and ImGui for UI. It currently loads 
models via a File ? Open menu.

**Objective**:
Implement drag-and-drop support for loading 3D model files.

**Requirements**:
Think through these steps:

1. SDL2 event handling (what event type? SDL_DROPFILE?)
2. File validation (is it a supported model format? .gltf, .fbx, .obj?)
3. Existing model cleanup (unload current model before loading new?)
4. UI feedback (show loading spinner? disable controls during load?)
5. Error handling (what if an invalid file is dropped?)
6. Multi-file drop (load multiple models or just first?)

**Examples/References**:
- Follow the existing model loading pattern in ModelViewerApp::loadModel()
- Use the Logger class for error messages

Start with Step 1: SDL event setup in Application.cpp
```

---

## Session 2: Tree-of-Thought Prompting (12 min)

### Learning Objectives
- Explore multiple solution branches before committing
- Evaluate trade-offs systematically
- Make architecture decisions with documented rationale

### What is Tree-of-Thought?

Tree-of-Thought (ToT) prompting explores **multiple reasoning branches in parallel**, evaluates each, prunes weak options, and converges on the best solution.

```
          [Problem]
         /    |    \
    Branch A  B     C
      ?       ?     ?
   Evaluate each branch
      ?       ?     ?
   Prune weakest (B)
      ?             ?
   Select best or merge A+C
```

### CoT vs ToT: When to Use Each

| Scenario | Use |
|----------|-----|
| Problem has one clear approach | **Chain-of-Thought** |
| Multiple valid architectures compete | **Tree-of-Thought** |
| Balancing design trade-offs | **Tree-of-Thought** |
| Implementing a chosen design | **Chain-of-Thought** |
| Cross-cutting concerns | **Tree-of-Thought** |

### ToT Demo: Enemy Placement Strategy

**Copy-paste prompt for VS2022 Copilot Chat:**

```
**Context**:
I'm placing 3 enemies in Zone 3 ("The Commercial Strip") for our urban survival 
game. Zone 2 had a frontal checkpoint firefight. Zone 3 ends at a subway entrance.
The level has storefronts (Woolworth's, Rexall Drugs, a Diner) and fire escapes.

Enemy types: Scavenger (75 HP, flees at 25%), Raider (100 HP, stays in cover).
Acceptance criteria: 2 Scavengers, 1 Raider, ambush positions near storefronts.

**Objective**:
Design the optimal enemy placement that creates a distinct combat experience 
from Zone 2.

**Requirements**:
Use Tree of Thought reasoning:

1. **Generate 3 distinctly different arrangements:**
   - Branch A: "Storefront Interior Lurkers" — enemies inside buildings, burst out
   - Branch B: "Street-Level Ambush" — enemies behind cover on the street
   - Branch C: "Layered Defense" — multi-elevation (fire escape + street + interior)

2. **Evaluate each branch against these criteria:**
   | Criteria | Branch A | Branch B | Branch C |
   |----------|----------|----------|----------|
   | Distinct from Zone 2 firefight? | | | |
   | Uses storefront assets? | | | |
   | Teaches player a new skill? | | | |
   | Implementation complexity? | | | |
   | Player experience after Zone 2? | | | |

3. **Prune the weakest branch and explain why**

4. **If two branches are strong, merge their best elements**

5. **Produce final layout with specific positions and enemy properties**

**Examples/References**:
- EnemyAI properties from src/ai/enemy_ai.hpp
- Zone layout from docs/LEVEL_1_DESIGN.md
```

### ToT Demo: Implementation Architecture Decision

**Copy-paste prompt for VS2022 Copilot Chat:**

```
**Context**:
Task: Implement a level exit trigger at the subway entrance in Zone 3.
Current codebase has:
- LevelManager class (src/world/level_manager.hpp) with complete_level() method
- GDScript support for level-specific logic
- CODING_STANDARDS.md says "gameplay logic in C++"

**Objective**:
Choose the best implementation approach for the level exit trigger.

**Requirements**:
Use Tree of Thought with 2-step lookahead:

1. **Generate 3 implementation approaches:**
   - Branch A: Pure GDScript Area3D script
   - Branch B: New C++ LevelExitTrigger class (extending Area3D)
   - Branch C: Extend existing LevelManager class

2. **Evaluate each against:**
   | Criteria | A (GDScript) | B (C++ Class) | C (Extend LevelManager) |
   |----------|--------------|---------------|-------------------------|
   | Coding standards compliance? | | | |
   | Reusable across 6 levels? | | | |
   | Signal integration with GameManager? | | | |
   | **Lookahead: Level 6 boss-gated exit?** | | | |
   | **Lookahead: Milestone 5 Save/Load?** | | | |

3. **Score and prune. Select the winner.**

4. **Within winning branch, generate 3 scope levels:**
   - Minimal (detect + signal only)
   - Full (prereqs + prompt + signal)
   - Over-engineered (camera + fade + cinematic)
   
   Pick the one matching acceptance criteria.

5. **Output final class header and files to create/modify**

**Examples/References**:
- Follow the component pattern in src/world/
- Match the signal naming convention in existing classes
```

### ToT Quick Reference Template

**Copy-paste and customize:**

```
**Context**: [Project details, relevant files, constraints]

**Objective**: [Decision to make or design to choose]

**Requirements**:
Use Tree of Thought reasoning:

1. Generate 3 distinctly different approaches to [WHAT VARIES]:
   - Branch A: [Name and brief description]
   - Branch B: [Name and brief description]
   - Branch C: [Name and brief description]

2. Evaluate each against:
   - [Criterion 1]
   - [Criterion 2]
   - [Criterion 3]
   - Lookahead: [Future milestone impact]

3. Prune the weakest branch and explain why

4. If two branches are strong, merge best elements

5. Produce final design with specific implementation details

**Examples/References**: [Existing patterns to follow]
```

---

## Session 3: Instruction Files (12 min)

### Learning Objectives
- Create instruction files for VS2022 Copilot
- Use `applyTo` patterns for path-specific rules
- Build a complete instruction hierarchy

### VS2022 Instruction File Support

Visual Studio 2022 reads instruction files from:
1. **Repo-wide**: `.github/copilot-instructions.md`
2. **Path-specific**: `.github/instructions/*.instructions.md`

### Creating Repo-Wide Instructions

**File: `.github/copilot-instructions.md`**

```markdown
# Copilot Instructions — C++ Game Development

## Project Overview
This is a C++ game project using:
- C++17 standard
- SDL2 for windowing/input
- OpenGL 3.3+ for rendering
- Dear ImGui for UI
- Assimp for model loading
- stb_image for textures

## Code Style
- UpperCamelCase for classes: `class AssetDatabase`
- lowerCamelCase for methods: `void loadModel()`
- m_prefix for member variables: `m_camera`
- Use descriptive names over abbreviations

## Memory Safety
- Use std::unique_ptr/std::shared_ptr for owned resources
- Prefer std::vector/std::string over raw arrays
- Check pointers before dereferencing
- Use std::optional for nullable values

## OpenGL Rules
- Always check glGetError() after critical operations
- Delete textures/buffers in reverse creation order
- Use RAII wrappers for OpenGL objects
- Never leak OpenGL resources on exception
- All GL calls on main thread only

## ImGui Rules
- Always call ImGui::Begin()/End() in pairs
- Use ImGui::PushID()/PopID() in loops
- Check return values: if (ImGui::Button("...")) { /* clicked */ }
- Don't rebuild static UI every frame

## Logging
- Use Logger class, not printf/std::cout
- Levels: LOG_DEBUG, LOG_INFO, LOG_WARN, LOG_ERROR
- Include context: Logger::info("ModelLoader", "Loaded: {}", name);
- Never log in hot paths (per-frame code)

## Error Handling
- Don't crash on single malformed file
- Log errors and continue processing
- Return placeholder for failed assets
- Show error count in UI status bar

## Performance
- Cache expensive calculations
- Avoid allocations in update loops
- Use move semantics for large objects
- Profile before optimizing
```

### Creating Path-Specific Instructions

**File: `.github/instructions/opengl-rendering.instructions.md`**

```markdown
---
applyTo: '**/Renderer.{cpp,hpp},**/Camera.{cpp,hpp},**/Shader.{cpp,hpp}'
---

# OpenGL Rendering Guidelines

## State Management
- Save and restore OpenGL state if modifying global state
- Document required GL state in function comments
- Bind VAO before drawing, unbind after

## Shader Usage
- Always check compilation errors with glGetShaderiv
- Validate program linking with glGetProgramiv
- Cache uniform locations in member variables
- Set uniforms only when values change

## Textures
- Bind to specific texture units: glActiveTexture(GL_TEXTURE0 + slot)
- Always specify min/mag filters and wrap modes
- Generate mipmaps for downscaled textures
- Use correct internal formats (GL_RGBA8, GL_RGB8)

## Framebuffers
- Check completeness: glCheckFramebufferStatus
- Attach all required buffers (color, depth)
- Restore default framebuffer (0) after rendering

## Camera
- Use glm:: for all math operations
- Perspective: glm::perspective(fov, aspect, near, far)
- View matrix: glm::lookAt(eye, center, up)
- Update projection on window resize
```

**File: `.github/instructions/imgui-ui.instructions.md`**

```markdown
---
applyTo: '**/*Panel.{cpp,hpp},**/*App.cpp,**/*Dialog.{cpp,hpp}'
---

# ImGui UI Guidelines

## Layout Patterns
- Use ImGui::BeginChild()/EndChild() for scrollable regions
- DockSpace for multi-panel layouts
- Columns or Tables for grid layouts
- Separator() for visual grouping

## Input Widgets
- InputText: provide buffer with size: char buf[256]
- SliderFloat/Int: specify min/max/format
- Combo: use const char* items[] array
- ColorEdit: use ImGuiColorEditFlags

## Interaction Feedback
- Use IsItemHovered() for tooltips
- IsItemActive() for continuous interaction
- SetTooltip() for context-sensitive help

## Performance
- Collapse panels to skip rendering contents
- Limit text rendering in long lists
- Use BeginDisabled() instead of hiding
```

### Live Exercise: Create Debug Instructions

**Create `.github/instructions/debugging.instructions.md`:**

```markdown
---
applyTo: '**/*.{cpp,hpp}'
---

# Debugging & Diagnostics Guidelines

## Logging Levels
- DEBUG: Verbose developer info (frame times, cache hits)
- INFO: User-relevant events (file loaded, settings changed)
- WARN: Recoverable issues (missing texture, using default)
- ERROR: Serious problems (file not found, GL error)

## Assertions
- Use assert() for developer errors (invariants)
- Use runtime checks for user input errors
- Document preconditions in function comments
- Never assert on file I/O results

## Error Messages
- Include context: "Failed to load 'car.glb': File not found"
- Suggest fixes when possible
- Log full details, show summary in UI

## Performance Diagnostics
- Track frame time with high-resolution timer
- Count draw calls, vertices per frame
- Monitor memory usage (textures, meshes)
- Display stats in debug overlay (F1 to toggle)
```

---

## Session 4: Prompt Files (12 min)

### Learning Objectives
- Create reusable prompt files with CORE framework
- Structure prompts for team workflows
- Build a prompt library for common tasks

### VS2022 Prompt File Support

Prompt files are stored in `.github/prompts/` and can be invoked in Copilot Chat using `#file` references.

### Prompt File Structure

```markdown
---
mode: 'agent'  # or 'ask' for questions
description: 'What this prompt accomplishes'
---

# Prompt content using CORE framework...
```

### Example: Add ImGui Panel Prompt

**File: `.github/prompts/add-imgui-panel.prompt.md`**

```markdown
---
mode: 'agent'
description: 'Create a new ImGui panel with standard layout and controls'
---

# Add New ImGui Panel

**Context**:
I'm adding a new panel to the {{TOOL_NAME}} tool in the tools/ directory.
The project uses C++17, ImGui for UI, and follows the Application base class pattern.

**Objective**:
Create a new {{PanelName}} panel class with standard ImGui layout.

**Requirements**:

1. **Create Header File** (`tools/{{tool_name}}/{{PanelName}}.hpp`):
```cpp
#pragma once
#include <string>

namespace tools {

class {{PanelName}} {
public:
    {{PanelName}}();
    
    /// @brief Render the panel using ImGui
    /// @return true if panel is open, false if closed
    bool render();
    
    const char* getTitle() const { return "{{Panel Title}}"; }
    
private:
    bool m_isOpen = true;
    // Panel-specific state here
};

} // namespace tools
```

2. **Create Implementation** (`tools/{{tool_name}}/{{PanelName}}.cpp`):
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

3. **Integrate into App**:
   - Add member: `std::unique_ptr<{{PanelName}}> m_{{panelName}};`
   - Initialize in constructor or onInit()
   - Call `m_{{panelName}}->render()` in onImGuiRender()

4. **Update CMakeLists.txt**: Add to target sources

**Examples/References**:
- Follow pattern in existing panels (tools/asset_browser/FilterPanel.hpp)
- Use Logger class for initialization messages

**Test Checklist**:
- [ ] Panel appears in tool window
- [ ] Close button works
- [ ] Panel can be docked
- [ ] No ImGui assertion errors
```

### Example: Implement Feature Prompt

**File: `.github/prompts/implement-feature.prompt.md`**

```markdown
---
mode: 'agent'
description: 'Implement a new feature with proper architecture'
---

# Implement New Feature

**Context**:
Project: {{PROJECT_NAME}} using C++17
Feature: {{FEATURE_DESCRIPTION}}
Related files: {{RELEVANT_FILES}}

**Objective**:
Implement {{FEATURE_NAME}} following project patterns.

**Requirements**:

## Phase 1: Design
Use Tree-of-Thought to evaluate approaches:
1. Generate 2-3 implementation approaches
2. Evaluate against: reusability, performance, maintainability
3. Select best approach with rationale

## Phase 2: Implementation
Use Chain-of-Thought for implementation:
1. Define data structures needed
2. Implement core logic
3. Add error handling
4. Integrate with existing systems

## Phase 3: Testing
1. Add unit tests for core logic
2. Test edge cases
3. Verify integration

**Examples/References**:
- Similar feature: {{SIMILAR_FEATURE}}
- Coding standards: .github/copilot-instructions.md

**Files to create/modify**:
- [ ] Header: src/{{path}}/{{FeatureName}}.hpp
- [ ] Implementation: src/{{path}}/{{FeatureName}}.cpp
- [ ] Tests: tests/{{FeatureName}}Tests.cpp
- [ ] CMakeLists.txt update
```

### Example: Code Review Prompt

**File: `.github/prompts/code-review.prompt.md`**

```markdown
---
mode: 'ask'
description: 'Comprehensive code review for C++ game code'
---

# Code Review Request

**Context**:
Reviewing: {{FILE_OR_SELECTION}}
Type: {{CODE_TYPE}} (gameplay/rendering/UI/utility)

**Objective**:
Provide a comprehensive code review focusing on quality, safety, and performance.

**Requirements**:

## Check Categories

### 1. Memory Safety
- [ ] No raw pointer ownership
- [ ] Proper RAII usage
- [ ] No memory leaks
- [ ] Smart pointer usage correct

### 2. OpenGL (if applicable)
- [ ] Resources cleaned up
- [ ] Error checking present
- [ ] State properly managed
- [ ] Thread safety (main thread only)

### 3. Error Handling
- [ ] User-friendly error messages
- [ ] Graceful degradation
- [ ] Proper logging

### 4. Performance
- [ ] No per-frame allocations in hot paths
- [ ] Efficient algorithms
- [ ] Appropriate caching

### 5. Style
- [ ] Naming conventions followed
- [ ] Comments where needed
- [ ] Consistent formatting

**Output Format**:
```
## Code Review: {{FILE_NAME}}

### Critical Issues:
1. [CRITICAL]: Description - Fix suggestion

### Major Issues:
1. [MAJOR]: Description - Fix suggestion

### Minor Issues:
1. [MINOR]: Description - Fix suggestion

### Suggested Fix:
```code
// Improved code here
```
```

**Examples/References**:
- Standards: .github/copilot-instructions.md
- Patterns: tools/common/
```

### Using Prompt Files in VS2022

**In Copilot Chat**, reference prompt files:

```
@workspace Apply the prompt from #file:.github/prompts/add-imgui-panel.prompt.md

Substitutions:
- TOOL_NAME = model_viewer
- PanelName = MaterialEditor
- Panel Title = Material Editor
```

---

## Session 5: Copilot Code Review (10 min)

### Learning Objectives
- Use Copilot for automated code review in VS2022
- Configure review criteria for C++ code
- Integrate review into workflow

### VS2022 Code Review Methods

**Method 1: Selection Review**
1. Select code block in editor
2. Right-click ? "Ask Copilot" ? "Review selection"

**Method 2: Inline Chat Review**
1. Select code
2. Press `Alt+/` (inline chat)
3. Type: "Review this code for memory safety and performance"

**Method 3: Copilot Chat Review**
Press `Ctrl+Shift+I` and use this CORE framework prompt:

```
**Context**:
Reviewing C++ code from: [FILE_PATH]
Code type: [gameplay/rendering/UI/utility]
Project uses: C++17, OpenGL 3.3+, ImGui, RAII patterns

**Objective**:
Review this code for quality, safety, and performance issues.

**Requirements**:
Check for:
1. Memory safety and resource leaks
2. Error handling (what if file not found? null pointer?)
3. OpenGL error checking
4. Thread safety (where can this be called from?)
5. Performance concerns (allocations in hot paths?)
6. Missing functionality

**Examples/References**:
- Standards: .github/copilot-instructions.md
- Rate severity: CRITICAL / MAJOR / MINOR

[PASTE CODE HERE]
```

### Demo: Review Texture Loading Code

**Code to review:**
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

**Review prompt (copy-paste to Copilot Chat):**

```
**Context**:
Reviewing texture loading code from ThumbnailGenerator.cpp.
Uses stb_image for loading, OpenGL for texture creation.
This is called during asset browser directory scans.

**Objective**:
Review for memory safety, error handling, and OpenGL best practices.

**Requirements**:
Check for:
1. Memory safety and resource leaks
2. Error handling (what if file doesn't exist or is corrupted?)
3. OpenGL error checking
4. Thread safety (is this safe to call from worker thread?)
5. Texture binding state pollution
6. Missing functionality (mipmaps? compression?)

**Examples/References**:
- Should follow RAII pattern from TextureManager
- Must not crash on invalid files

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
```

### Expected Review Output

The review should identify:

1. **CRITICAL: No null check on stbi_load** - If file missing, data is nullptr, glTexImage2D crashes
2. **CRITICAL: Memory leak if GL fails** - If glGenTextures fails after stbi_load, data not freed
3. **MAJOR: No GL error checking** - Texture creation could fail silently
4. **MAJOR: Texture binding not restored** - Leaves GL_TEXTURE_2D bound
5. **MINOR: Missing mipmaps** - Using GL_LINEAR but no mipmaps generated

### Practice Exercise (3 min)

**Review this camera code:**

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

**Use this prompt:**

```
**Context**:
Camera input handling for Model Viewer tool.
Called every frame when mouse buttons are held.

**Objective**:
Review for input handling issues and mathematical correctness.

**Requirements**:
Check for:
1. Input validation (are dx/dy reasonable values?)
2. Angle wrapping (yaw 0-360, pitch limits?)
3. Sensitivity hardcoded (should be configurable?)
4. Performance (called per-frame, any concerns?)
5. Mathematical correctness

[PASTE THE CODE]
```

---

## Session 6: Copilot Plan Mode (10 min)

### Learning Objectives
- Use Plan Mode for multi-file changes
- Review and modify generated plans
- Execute plans with checkpoints

### What is Plan Mode?

Plan Mode allows Copilot to:
1. Analyze a complex feature request
2. Create a step-by-step implementation plan
3. Show which files will be created/modified
4. Execute changes with your approval at each step

### VS2022 Plan Mode Access

**In Copilot Chat (`Ctrl+Shift+I`):**

Use the `/plan` command or structure your request to trigger planning:

```
@workspace Create a plan to implement [FEATURE]
```

### Demo: Multi-File Feature Planning

**Copy-paste this prompt to Copilot Chat:**

```
**Context**:
Project: Asset Browser tool (tools/asset_browser/)
Uses: C++17, ImGui, std::filesystem, OpenGL
Current state: Assets displayed but no search functionality

**Objective**:
Create a plan to add asset search functionality with:
1. Search text box in toolbar
2. Filter assets by filename (case-insensitive)
3. Wildcard support (* and ?)
4. Highlight matching text in results
5. Show match count in status bar
6. Clear on ESC key press

**Requirements**:
Structure the plan as:

## Files to Create:
- List new files with purpose

## Files to Modify:
- List existing files and what changes

## Implementation Steps:
- Step 1: [Component/Class] - Description
- Step 2: [Integration] - Description
- ...

## Test Plan:
- [ ] Test criterion 1
- [ ] Test criterion 2

**Examples/References**:
- Follow pattern in existing FilterPanel.cpp
- Use similar text matching as ModelLoader filename validation

Generate a detailed implementation plan.
```

### Expected Plan Output

```markdown
## Plan: Add Asset Search to Asset Browser

### Files to Create:
1. `tools/asset_browser/SearchBar.hpp` - Search UI component
2. `tools/asset_browser/SearchBar.cpp` - Search implementation

### Files to Modify:
3. `tools/asset_browser/AssetBrowserApp.hpp` - Add search state
4. `tools/asset_browser/AssetBrowserApp.cpp` - Integrate search UI
5. `tools/asset_browser/AssetDatabase.hpp` - Add filter method
6. `tools/asset_browser/AssetDatabase.cpp` - Implement filtering
7. `tools/CMakeLists.txt` - Add new source files

### Implementation Steps:

**Step 1: Create SearchBar Component**
- ImGui::InputText for search query
- Clear button (X icon)
- Wildcard pattern matching utility

**Step 2: Add Filter Method to AssetDatabase**
```cpp
std::vector<AssetMetadata> filterByQuery(const std::string& query) const;
bool matchesWildcard(const std::string& text, const std::string& pattern) const;
```

**Step 3: Add Search State to AssetBrowserApp**
- m_searchBar unique_ptr
- m_searchQuery string
- m_filteredAssets vector
- m_matchCount int

**Step 4: Integrate Search UI**
- Render SearchBar in toolbar
- Call filter on query change
- Update grid to use filtered results

**Step 5: Add ESC Key Handling**
- Check ImGui::IsKeyPressed(ImGuiKey_Escape)
- Clear query and reset to all assets

**Step 6: Update Status Bar**
- Display "Found X matches for 'query'"

**Step 7: Update CMakeLists.txt**
- Add SearchBar.cpp and SearchBar.hpp

### Test Plan:
- [ ] Search box appears in toolbar
- [ ] Typing filters assets immediately
- [ ] Wildcards work (* matches multiple, ? matches one)
- [ ] Case-insensitive matching
- [ ] Clear button works
- [ ] ESC clears search
- [ ] Match count accurate

Proceed with Step 1?
```

### Practice: Evaluate and Refine a Plan

**Given this plan, identify issues:**

```
## Plan: Add Undo/Redo to Material Editor

Step 1: Create Command pattern base class
Step 2: Implement SetColorCommand, SetFloatCommand
Step 3: Add CommandHistory stack to MaterialEditor
Step 4: Wire up Ctrl+Z and Ctrl+Y shortcuts
Step 5: Update UI to disable buttons when stack empty
```

**Questions to ask:**
- Missing: Command merging for continuous slider drags?
- Missing: How to handle undo across file loads?
- Missing: Memory limits for command history?
- Missing: What about compound operations (set multiple values)?

**Refine the plan with this prompt:**

```
**Context**:
Reviewing the undo/redo plan for Material Editor.
Users will drag sliders continuously (generating many small changes).

**Objective**:
Improve the plan to handle command merging and memory limits.

**Requirements**:
Address these concerns:
1. Slider drag generates 60 commands/second - how to merge?
2. Memory limit for command history (e.g., 100 commands max)
3. Compound operations (set albedo + metallic together)
4. Clear history when loading new model?

Update the plan with additional steps.
```

---

## Session 7: Copilot Coding Agent (10 min)

### Learning Objectives
- Delegate complex tasks to Coding Agent
- Monitor agent progress
- Review and refine agent output

### What is Copilot Coding Agent?

A more autonomous mode where Copilot:
- Understands the entire task scope
- Makes multiple file changes
- Builds and tests the changes
- Iterates on compilation errors

### VS2022 Agent Mode Access

**In Copilot Chat**, use agent mode syntax or explicit delegation:

```
@workspace Use agent mode to implement [COMPLETE FEATURE]
```

Or use the Agent toggle in Copilot Chat settings.

### Demo: Agent Task for Screenshot System

**Copy-paste this comprehensive agent task:**

```
**Context**:
Project: Model Viewer tool (tools/model_viewer/)
Tech: C++17, OpenGL 3.3+, SDL2, ImGui
Current: Can render 3D models, no screenshot capability

**Objective**:
Implement a complete screenshot capture system.

**Requirements**:

## 1. Screenshot Button in Toolbar
- Icon: camera
- Tooltip: "Capture Screenshot (F12)"
- Keyboard shortcut: F12

## 2. Capture Functionality
- Capture current framebuffer to image
- Support sizes: 1x (current), 2x, 4x resolution
- Remove UI from capture (render model only)
- Save as PNG with timestamp filename

## 3. Settings Dialog
- Output directory selection
- Resolution multiplier dropdown
- Transparent background option
- "Open folder after save" checkbox

## 4. User Feedback
- Flash effect when captured
- Toast notification with file path

## 5. File Management
- Default location: ~/Documents/ModelViewerScreenshots/
- Filename format: screenshot_YYYYMMDD_HHMMSS.png
- Auto-create directory if not exists

## Implementation Notes
- Use stb_image_write.h for PNG saving (already in external/)
- Follow existing panel patterns for Settings Dialog
- Use existing Logger for error reporting

## Files Expected
- ScreenshotManager.hpp/.cpp (capture logic)
- ScreenshotDialog.hpp/.cpp (settings UI)
- Modifications to ModelViewerApp.hpp/.cpp
- CMakeLists.txt update

## Test Criteria
- [ ] F12 captures screenshot
- [ ] PNG file saved correctly
- [ ] Settings dialog works
- [ ] Different resolutions work
- [ ] Directory auto-created

Implement this feature completely, iterating on any build errors.
```

### Best Practices for Agent Tasks

| DO | DON'T |
|----|-------|
| Provide complete context and requirements | Give vague "make it better" requests |
| Reference specific files/patterns | Assume agent knows your architecture |
| Specify test criteria | Skip verification steps |
| Break huge features into phases | Request "complete rewrite" |
| Include edge cases | Assume agent thinks of everything |

### Practice: Design an Agent Task

**Task**: Write an agent task for "Add recent files menu"

**Template to complete:**

```
**Context**:
Project: Model Viewer tool
[What existing functionality is relevant?]

**Objective**:
Add a recent files menu that [describe complete behavior]

**Requirements**:

## Storage
- Where stored? [JSON file location]
- Max entries? [number]
- What data per entry? [path, timestamp, ...]

## UI
- Menu location? [File menu submenu]
- Entry format? [filename with path on hover]
- Clear option? [Clear Recent Files button]

## Behavior
- File validation? [Check if still exists]
- Duplicate handling? [Move to top on reopen]
- Keyboard shortcuts? [Ctrl+1 through Ctrl+9?]

## Edge Cases
- File renamed/moved?
- Network paths unavailable?
- Very long file paths?

## Files Expected
- [List files to create/modify]

## Test Criteria
- [ ] [Test 1]
- [ ] [Test 2]
```

---

## Session 8: Copilot Agent HQ (6 min)

### Learning Objectives
- Organize specialized agents
- Configure agent expertise and permissions
- Use agents for domain-specific tasks

### Agent Configuration in VS2022

Agents are configured in `.github/agents/` with `.agent.md` files.

### Example: OpenGL Expert Agent

**File: `.github/agents/opengl-expert.agent.md`**

```markdown
---
name: 'opengl-expert'
description: 'OpenGL rendering and graphics programming specialist'
---

# OpenGL Graphics Expert

You are the OpenGL graphics expert for this C++ game tools project.

## Your Expertise
- Modern OpenGL (3.3+ core profile)
- Shader programming (GLSL)
- Framebuffer operations
- Texture management
- Vertex buffer objects
- Camera and projection matrices

## Reference Files
Always consult these before making changes:
- tools/model_viewer/Renderer.cpp
- tools/model_viewer/Camera.cpp
- tools/common/Application.cpp (OpenGL context setup)
- .github/copilot-instructions.md

## Your Rules
- Use RAII for GL resources
- Check glGetError() in debug builds
- All GL calls on main thread only
- Save/restore GL state when modifying globals
- Never leave textures bound after operations

## Response Style
- Cite specific GL functions and constants
- Include shader code when relevant
- Warn about driver compatibility issues
- Provide performance notes
- Link to OpenGL documentation when helpful
```

### Example: Gameplay Engineer Agent

**File: `.github/agents/gameplay-engineer.agent.md`**

```markdown
---
name: 'gameplay-engineer'
description: 'Gameplay systems and AI specialist'
---

# Gameplay Systems Engineer

You are the gameplay systems engineer for this urban survival game.

## Your Expertise
- Player controller and input handling
- Enemy AI state machines
- Combat systems (weapons, damage, health)
- Level progression and triggers
- Game state management

## Reference Files
Always consult:
- src/player/player_controller.hpp
- src/ai/enemy_ai.hpp
- src/combat/weapon_controller.hpp
- src/world/level_manager.hpp
- docs/SPEC.md (game design spec)

## Your Rules
- Follow component/entity patterns
- Use signals for cross-system communication
- Validate all player input
- Balance performance with gameplay fidelity
- Document state machine transitions

## Response Style
- Reference game design doc for values
- Consider multiplayer implications
- Note performance impact of AI decisions
- Suggest playtesting for feel-related changes
```

### Using Agents in VS2022

**In Copilot Chat:**

```
@opengl-expert How do I render to an offscreen framebuffer at 4x resolution 
for screenshot capture without affecting the main render?
```

```
@gameplay-engineer Design an enemy activation system where enemies "wake up" 
based on gunfire sounds within 50 meters, following the cascade pattern.
```

### Agent Roster Template

| Agent Name | Expertise | Files |
|------------|-----------|-------|
| `@opengl-expert` | OpenGL, shaders, rendering | `**/Renderer.*, **/Camera.*` |
| `@imgui-specialist` | ImGui layout, widgets | `**/*Panel.*, **/*App.cpp` |
| `@gameplay-engineer` | Player, enemies, combat | `src/player/*, src/ai/*` |
| `@asset-pipeline` | File loading, caching | `**/AssetDatabase.*, **/ModelLoader.*` |
| `@code-reviewer` | Quality, safety, perf | All files |

---

## Session 9: Architecture & Tech Stack Generation (6 min)

### Learning Objectives
- Generate architecture documentation
- Create tech stack diagrams
- Document system interactions

### Architecture Generation Prompt

**Copy-paste to Copilot Chat:**

```
**Context**:
Project: Model Viewer tool (tools/model_viewer/)
A 3D model viewing application for game asset preview.

**Objective**:
Generate comprehensive architecture documentation.

**Requirements**:
Include these sections:

## 1. Component Diagram
Show main classes and their relationships:
- ModelViewerApp (orchestrator)
- Camera (view/projection)
- Renderer (OpenGL drawing)
- ModelLoader (Assimp integration)
- MeshInspector (UI panel)

## 2. Class Relationships
Show ownership and dependencies:
- Who owns what (unique_ptr, shared_ptr)
- Who depends on what
- Interface contracts

## 3. Data Flow Diagrams
Show these flows:
- Loading a Model: User action ? file system ? parsing ? GPU upload
- Rendering Loop: Update ? Draw ? UI ? Swap

## 4. Technology Stack Table
| Layer | Technology | Purpose |
|-------|------------|---------|
| ... | ... | ... |

## 5. Key Design Decisions
Document why certain approaches were chosen:
- Separation of concerns
- Resource management approach
- Threading model
- Error handling strategy

## 6. Future Extension Points
Where to add new features:
- New file format support
- Additional render modes
- Plugin architecture

Format as markdown documentation.
```

### Tech Stack Documentation Prompt

```
**Context**:
Project: Asset Browser tool
Purpose: Browse and preview game assets in a directory

**Objective**:
Document the complete technology stack.

**Requirements**:

## Technology Stack

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| Language | | | |
| Build System | | | |
| Windowing | | | |
| Graphics | | | |
| UI | | | |
| Model Loading | | | |
| Image Loading | | | |
| File System | | | |
| Threading | | | |
| Caching | | | |

## Architecture Overview
- Describe main components
- Show how they interact
- Note threading boundaries

## Performance Characteristics
- Async operations
- Caching strategy
- Memory limits

Generate comprehensive documentation.
```

---

## CORE Framework Quick Reference

### Template for Any Prompt

```
**Context**: [What project/file/situation]

**Objective**: [What you want to accomplish]

**Requirements**:
- [Specific constraint 1]
- [Specific constraint 2]
- [Quality criteria]

**Examples/References**:
- [Existing code to follow]
- [Expected output format]
```

### Chain-of-Thought Pattern

```
**Context**: [Background]

**Objective**: [Goal]

**Requirements**:
Let's reason through this step by step:

Step 1: [Analysis question]
- [Consider this]
- [Consider that]

Step 2: [Design question]
- [Option A]
- [Option B]

Step 3: [Implementation question]
...

**Examples/References**: [Patterns to follow]

Start with Step 1: [First concrete task]
```

### Tree-of-Thought Pattern

```
**Context**: [Background]

**Objective**: [Decision to make]

**Requirements**:
Use Tree of Thought reasoning:

1. Generate 3 approaches:
   - Branch A: [Name] — [Description]
   - Branch B: [Name] — [Description]
   - Branch C: [Name] — [Description]

2. Evaluate against:
   | Criteria | A | B | C |
   |----------|---|---|---|
   | [Criterion 1] | | | |
   | [Criterion 2] | | | |
   | Lookahead: [Future impact] | | | |

3. Prune weakest with rationale

4. Produce final design

**Examples/References**: [Patterns to follow]
```

### Code Review Pattern

```
**Context**: [File and code type]

**Objective**: Review for [focus areas]

**Requirements**:
Check for:
1. [Category 1] - [specifics]
2. [Category 2] - [specifics]
3. [Category 3] - [specifics]

Rate: CRITICAL / MAJOR / MINOR

**Examples/References**: [Standards to apply]

[CODE TO REVIEW]
```

### Agent Task Pattern

```
**Context**: [Project, tech stack, current state]

**Objective**: Implement [complete feature]

**Requirements**:

## Component 1
- [Requirement]
- [Requirement]

## Component 2
- [Requirement]
- [Requirement]

## Files Expected
- [file1] - [purpose]
- [file2] - [purpose]

## Test Criteria
- [ ] [Test 1]
- [ ] [Test 2]

Implement completely, iterating on errors.
```

---

## Workshop Summary

### Capabilities Covered

| Capability | VS2022 Access | When to Use |
|------------|---------------|-------------|
| **Chain-of-Thought** | Copilot Chat (Ctrl+Shift+I) | Complex single-path problems |
| **Tree-of-Thought** | Copilot Chat | Architecture decisions, trade-offs |
| **Instruction Files** | `.github/copilot-instructions.md` | Consistent AI behavior |
| **Prompt Files** | `.github/prompts/` | Reusable team workflows |
| **Code Review** | Right-click or Chat | Quality assurance |
| **Plan Mode** | `/plan` in Chat | Multi-file features |
| **Coding Agent** | Agent mode in Chat | Complex autonomous tasks |
| **Agent HQ** | `.github/agents/` | Domain expertise |
| **Architecture Gen** | Copilot Chat | Documentation |

### Key Takeaways

1. **CORE Framework**: Context, Objective, Requirements, Examples — use for all prompts
2. **CoT vs ToT**: Use CoT for "how", ToT for "what approach"
3. **Instruction Files**: Encode team standards once, apply everywhere
4. **Prompt Files**: Build a library of reusable prompts
5. **Code Review**: Automate quality checks before PRs
6. **Plan Mode**: Visualize before implementing
7. **Coding Agent**: Delegate complete, well-specified tasks
8. **Architecture Docs**: Generate and maintain automatically

### Next Steps

1. [ ] Create `.github/copilot-instructions.md` for your project
2. [ ] Add path-specific instructions for different code areas
3. [ ] Build 3-5 prompt files for common tasks
4. [ ] Configure agents for your domain experts
5. [ ] Practice code review on existing code
6. [ ] Use plan mode for your next feature
7. [ ] Try coding agent for a complete subsystem

---

## Resources

### VS2022 Copilot Documentation
- [VS2022 Copilot Setup](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-install-and-states)
- [Copilot Chat in VS](https://learn.microsoft.com/en-us/visualstudio/ide/visual-studio-github-copilot-chat)
- [Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-instructions-for-github-copilot)

### Prompt Engineering
- [GitHub Copilot Best Practices](https://docs.github.com/en/copilot/using-github-copilot/best-practices-for-using-github-copilot)
- [Prompt Engineering Guide](https://docs.github.com/en/copilot/using-github-copilot/prompt-engineering-for-github-copilot)

### Project Files
- `.github/copilot-instructions.md` — Repo-wide instructions
- `.github/instructions/` — Path-specific rules
- `.github/prompts/` — Reusable prompt templates
- `.github/agents/` — Agent configurations

---

**Workshop Complete!**

You now have advanced skills in leveraging GitHub Copilot in Visual Studio 2022 for complex C++ game development. Apply the CORE framework and these techniques to accelerate your development workflow!

---

**Author**: GitHub Copilot Workshop Team  
**Version**: 1.0 (Visual Studio 2022)  
**Last Updated**: February 2025
