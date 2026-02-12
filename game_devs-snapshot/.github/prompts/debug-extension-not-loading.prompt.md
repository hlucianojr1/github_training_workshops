---
agent: 'agent'
description: 'Troubleshoot: GDExtension fails to load or classes are missing in Godot.'
---

Diagnose extension load failures.

Collect:
- Godot output log snippet (first error)
- Current platform (macOS/Windows/Linux)
- Build config (Debug/Release)

Steps:
1) Verify built library exists under game/bin.
2) Validate game/urban_survivor.gdextension library paths and platform keys.
3) Check src/register_types.cpp includes and GDREGISTER_CLASS entries.
4) Ensure target class has GDCLASS + _bind_methods.
5) Rebuild with Godot closed.

Output:
- Root cause hypothesis
- Minimal fix list
- Verification steps
