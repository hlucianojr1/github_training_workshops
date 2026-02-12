---
agent: 'agent'
description: 'Update CMakeLists.txt to include new C++ sources in the GDExtension build.'
---

Update the build configuration.

Load context first:
- CMakeLists.txt (root)

Steps:
1) Locate the SOURCES list.
2) Add the new `src/.../*.cpp` entries.
3) Keep ordering consistent with existing module grouping.

Acceptance criteria:
- `cmake --build build --config Debug` succeeds.
- The compiled library updates in game/bin output location.
