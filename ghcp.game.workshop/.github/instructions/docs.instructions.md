# Documentation — Code Generation Instructions

Apply these rules when generating or modifying Markdown documentation in `docs/`.

## Documentation Files

| File | Purpose | Update Frequency |
|------|---------|-----------------|
| `docs/ARCHITECTURE.md` | System architecture and class hierarchy | On structural changes |
| `docs/SPEC.md` | Game design specification | On design changes |
| `docs/PRODUCTION_PLAN.md` | Sprint tasks and roadmap | Every sprint cycle |
| `docs/CODING_STANDARDS.md` | Detailed coding standards | On convention changes |

## Markdown Conventions

- Use ATX-style headings (`#`, `##`, `###`)
- Use fenced code blocks with language identifiers (````cpp`, ````gdscript`, ````bash`)
- Use tables for structured data with aligned columns
- Keep lines under 80 characters where practical
- Use relative links for cross-referencing project files

## PRODUCTION_PLAN.md Format

Task entries follow this structure:

```markdown
### Task M{milestone}.{number}: Task Title
- **Status**: 🔲 Not Started | 🔄 In Progress | ✅ Complete
- **Sprint**: {sprint number}
- **Description**: What the task accomplishes
- **Acceptance Criteria**:
  - [ ] Criterion 1
  - [ ] Criterion 2
```

When completing a task, update the status and check off acceptance criteria.

## Architecture Documentation

When modifying `ARCHITECTURE.md`:

- Update the system hierarchy diagram if classes are added or removed
- Update the class tables to reflect new modules or members
- Keep the ASCII art diagrams consistent with actual code structure

## Inline Code Documentation

- C++ files: match the existing comment style in each file
- Do not over-comment obvious code
- Document public APIs, complex algorithms, and non-obvious design decisions
- Use `///` or `/** */` for Doxygen-compatible doc comments when appropriate
