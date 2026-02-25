# Urban Survivor - Development Workflow

## Team Roles & Responsibilities

### Programmers
| Role | Responsibilities |
|------|------------------|
| Lead Programmer | Architecture decisions, code reviews, C++ core systems |
| Gameplay Programmer | Player mechanics, AI, combat systems |
| Tools Programmer | Editor tools, build pipeline, automation |
| UI Programmer | Menu systems, HUD, GDScript integration |

### Artists
| Role | Responsibilities |
|------|------------------|
| Art Director | Visual style, asset approval, consistency |
| 3D Artist | Characters, props, environments |
| Texture Artist | PBR textures, materials |
| Animator | Character animations, cinematics |
| UI Artist | Interface design, icons, 2D assets |

### Designers
| Role | Responsibilities |
|------|------------------|
| Lead Designer | Game vision, feature prioritization |
| Level Designer | Level layout, encounters, pacing |
| Systems Designer | Balancing, economy, progression |

### Audio
| Role | Responsibilities |
|------|------------------|
| Sound Designer | SFX, ambience, mixing |
| Composer | Music, dynamic audio |

---

## Development Workflow

### Daily Workflow
```
Morning Standup (15 min)
    ↓
Individual Work
    ↓
Lunch Break
    ↓
Individual Work
    ↓
End of Day Commits
    ↓
Daily Build (automated)
```

### Sprint Cycle (2 weeks)
```
Day 1: Sprint Planning
    ↓
Days 2-9: Development
    ↓
Day 10: Feature Freeze
    ↓
Days 11-12: Bug Fixing & Polish
    ↓
Day 13: Sprint Review & Demo
    ↓
Day 14: Retrospective & Planning Prep
```

---

## Version Control Workflow

### Branch Strategy
```
main (stable releases)
  ↑
develop (integration)
  ↑
feature/* (individual features)
fix/* (bug fixes)
```

### Branch Naming
```
feature/player-sprint-ability
feature/enemy-flanking-ai
fix/inventory-duplication-bug
refactor/damage-system-cleanup
```

### Commit Workflow
1. Create feature branch from `develop`
2. Make commits (small, focused)
3. Push branch
4. Create Pull Request
5. Code review
6. Merge to `develop`
7. Delete feature branch

### Commit Message Format
```
type(scope): short description

Longer description if needed.

Closes #123
```

Types: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`

### Large File Handling (Git LFS)
Track these file types:
```
*.png
*.jpg
*.wav
*.ogg
*.gltf
*.glb
*.fbx
*.blend
*.psd
```

---

## Code Review Process

### Before Requesting Review
- [ ] Code compiles without errors
- [ ] No compiler warnings
- [ ] Self-review completed
- [ ] Tests pass (if applicable)
- [ ] Documentation updated
- [ ] Follows coding standards

### Review Checklist
- [ ] Logic is correct
- [ ] Edge cases handled
- [ ] Performance acceptable
- [ ] Security considerations
- [ ] Consistent with codebase
- [ ] Comments where needed
- [ ] No debug code left in

### Review Etiquette
- **Reviewer**: Be constructive, explain why
- **Author**: Don't take feedback personally
- **Both**: Focus on the code, not the person

---

## Asset Pipeline

### 3D Asset Workflow
```
Concept Art → Modeling → UV Mapping → Texturing → Rigging → Animation → Export → Import → Integration
```

### Asset Handoff
1. Artist completes asset
2. Submits via Pull Request
3. Technical review (poly count, naming, specs)
4. Art Director approval
5. Merge to asset branch
6. Integration by programmer

### Asset Feedback Loop
```
Draft Export → In-Engine Preview → Feedback → Revision → Final Export
```

---

## Build Pipeline

### Build Types
| Build | Trigger | Purpose |
|-------|---------|---------|
| Local | Manual | Developer testing |
| Nightly | Scheduled (2 AM) | Team testing |
| CI | PR/Push | Automated validation |
| Release | Manual | Public release |

### Build Steps
1. Pull latest code
2. Update submodules
3. Build godot-cpp (if needed)
4. Build GDExtension
5. Package Godot project
6. Run automated tests
7. Create build artifact
8. Notify team

### Build Requirements
- CMake 3.20+
- Visual Studio 2022 (Windows)
- GCC 11+ or Clang 14+ (Linux)
- Godot 4.3+ (export templates)

---

## Testing Strategy

### Test Types
| Type | Who | When | Tool |
|------|-----|------|------|
| Unit Tests | Programmers | Per commit | GDUnit4 / Catch2 |
| Integration | Programmers | Per feature | Custom |
| Playtest | QA/Team | Weekly | Manual |
| Performance | Lead Prog | Per milestone | Godot Profiler |
| Smoke Test | CI | Per build | Automated |

### Playtest Protocol
1. **Pre-playtest**: Define goals, prepare build
2. **During**: Take notes, don't interrupt players
3. **Post**: Debrief, gather feedback, file bugs

### Bug Reporting
```
Title: [Module] Brief description

Steps to Reproduce:
1. ...
2. ...
3. ...

Expected: What should happen
Actual: What actually happens

Build: [version/commit]
Platform: [Windows/Linux/etc]
Attachments: [screenshots, logs]
```

---

## Documentation Standards

### Required Documentation
| Document | Owner | Update Frequency |
|----------|-------|------------------|
| README.md | Lead Prog | Per release |
| ARCHITECTURE.md | Lead Prog | Per major change |
| SPEC.md | Lead Designer | Per milestone |
| MEMORY.md | Team | As needed |
| CODING_STANDARDS.md | Lead Prog | Rarely |
| ART_GUIDELINES.md | Art Director | Per major change |

### Code Documentation
- **Public APIs**: Full Doxygen comments
- **Complex logic**: Inline comments explaining why
- **Workarounds**: Comment with context and ticket #

### Wiki/Knowledge Base
- Onboarding guide
- Tool setup instructions
- Common issues & solutions
- Meeting notes
- Design decisions

---

## Communication

### Meetings
| Meeting | Frequency | Duration | Attendees |
|---------|-----------|----------|-----------|
| Daily Standup | Daily | 15 min | All |
| Sprint Planning | Biweekly | 2 hours | All |
| Sprint Review | Biweekly | 1 hour | All |
| Retrospective | Biweekly | 1 hour | All |
| Tech Sync | Weekly | 1 hour | Programmers |
| Art Review | Weekly | 1 hour | Artists + Lead |
| Playtest | Weekly | 2 hours | All available |

### Communication Channels
| Channel | Use For |
|---------|---------|
| Discord #general | Casual, quick questions |
| Discord #dev | Technical discussions |
| Discord #art | Asset sharing, feedback |
| GitHub Issues | Bug reports, tasks |
| GitHub Discussions | Design decisions |
| Email | External, formal |

### Status Updates
- End of day: Brief commit message or standup note
- End of week: Progress summary
- End of sprint: Demo + retrospective

---

## Onboarding Checklist

### New Team Member
- [ ] Add to GitHub repo
- [ ] Add to Discord
- [ ] Add to project management tool
- [ ] Share documentation links
- [ ] Schedule intro meeting
- [ ] Assign buddy/mentor
- [ ] First task: Read all docs
- [ ] Second task: Build project locally
- [ ] Third task: Small starter issue

### Environment Setup
1. Install Visual Studio 2022 (Community OK)
2. Install CMake 3.20+
3. Install Git + Git LFS
4. Install Godot 4.3+
5. Clone repo with submodules
6. Build project (follow BUILD_INSTRUCTIONS.md)
7. Run game in editor
8. Make test modification, rebuild, verify

---

## AI Agent Workflow Integration

This project uses **21 specialized AI agents** to accelerate development. For complete documentation on invoking and chaining agents, see:

📖 **[AGENT_WORKFLOW.md](AGENT_WORKFLOW.md)** — Complete AI agent guide

### Quick Start with Agents

1. **Open Copilot Chat**: `Cmd+Shift+I` (macOS) or `Ctrl+Shift+I` (Windows/Linux)
2. **Invoke Agent**: Type `@agent-name` followed by your request
3. **Use Prompts**: Combine agents with prompts for guided workflows

### Agent Categories

| Category | Example Agents | When to Use |
|----------|----------------|-------------|
| **Code** | `@Godot C++ Expert`, `@Combat Systems Developer` | Implementing C++ features |
| **Art** | `@Blender AI Artist`, `@Texture Artist` | Creating 3D assets (requires MCP) |
| **Planning** | `@Sprint Planner`, `@Code Reviewer` | Task planning and reviews |
| **Debug** | `@Urban Survivor Debugger` | Diagnosing crashes and issues |

### Key Pipelines

```
Feature Development:
@Sprint Planner → @Specialist Agent → @Code Reviewer → @Doc Maintainer

Asset Creation:
@Model Spec Writer → @Blender Artist → @Texture Artist → @Level Populator

Bug Fix:
@Debugger → @Specialist Agent → @Code Reviewer → @Doc Maintainer
```

### MCP Setup for Art Agents

Art pipeline agents require Blender MCP server. See **[MCP_SETUP.md](MCP_SETUP.md)** for installation.

---

9. Merge back to `develop`

### Post-Release
- Monitor for critical bugs
- Prepare hotfix branch if needed
- Gather player feedback
- Plan next version
