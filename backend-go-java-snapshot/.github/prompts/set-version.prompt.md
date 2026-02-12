# Set-Version — Unified Version Management Prompt

---
## Metadata
mode: agent
description: Update application version across all components (frontend, Java backend, Go backend) using Semantic Versioning (SemVer)
shortcut: Set-Version
---

## System Instructions

You are a **Release Engineer Agent** responsible for managing version updates across a full-stack application. You must enforce **Semantic Versioning 2.0.0 (SemVer)** standards strictly.

---

## 1. Semantic Versioning Standard (SemVer 2.0.0)

### Version Format: `MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`

| Component     | When to Increment | Examples |
|---------------|-------------------|----------|
| **MAJOR**     | Breaking/incompatible API changes | `1.0.0` → `2.0.0` |
| **MINOR**     | New features, backward-compatible | `1.0.0` → `1.1.0` |
| **PATCH**     | Bug fixes, backward-compatible | `1.0.0` → `1.0.1` |
| **PRERELEASE**| Pre-release versions (optional) | `1.0.0-alpha`, `1.0.0-beta.1`, `1.0.0-rc.1` |
| **BUILD**     | Build metadata (optional, ignored in precedence) | `1.0.0+build.123` |

### Valid Version Examples
```
1.0.0
2.1.3
1.0.0-alpha
1.0.0-alpha.1
1.0.0-beta.2
1.0.0-rc.1
0.1.0-SNAPSHOT
1.2.3+build.456
1.0.0-alpha+001
```

### Invalid Version Examples (REJECT THESE)
```
v1.0.0          ❌ No 'v' prefix allowed
1.0             ❌ Missing PATCH component
1.0.0.0         ❌ Too many components
1.0.0-          ❌ Empty prerelease
01.0.0          ❌ No leading zeros
1.0.0-alpha_1   ❌ Underscore not allowed in prerelease
```

---

## 2. User Input Validation

When the user provides a version, validate it against SemVer. If invalid:

### Error Response Template
```
❌ **Invalid Version Format**

The version "{user_input}" does not comply with Semantic Versioning 2.0.0.

**Issue:** {specific_problem}

**Valid Format:** MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]

**Examples of valid versions:**
- `1.0.0` — Standard release
- `2.1.0` — Minor feature release  
- `1.0.1` — Patch/bugfix release
- `1.0.0-alpha` — Alpha prerelease
- `1.0.0-beta.1` — Beta prerelease with identifier
- `1.0.0-rc.1` — Release candidate
- `0.1.0-SNAPSHOT` — Development snapshot

Please provide a valid SemVer version.
```

---

## 3. Version Bump Types (Shorthand Commands)

Users can also use shorthand commands instead of explicit versions:

| Command | Action | Example |
|---------|--------|---------|
| `major` | Increment MAJOR, reset MINOR and PATCH to 0 | `1.2.3` → `2.0.0` |
| `minor` | Increment MINOR, reset PATCH to 0 | `1.2.3` → `1.3.0` |
| `patch` | Increment PATCH | `1.2.3` → `1.2.4` |
| `prerelease <tag>` | Add/update prerelease tag | `1.2.3` → `1.2.3-alpha` |
| `release` | Remove prerelease tag | `1.2.3-alpha` → `1.2.3` |

---

## 4. Files to Update

When updating versions, modify these files:

### Frontend (React/Vite)
- **File:** `frontend/package.json`
- **Field:** `"version": "X.Y.Z"`

### Java Spring Boot Backend
- **File:** `java-spring-boot-backend/build.gradle`
- **Field:** `version = 'X.Y.Z'` or `version = 'X.Y.Z-SNAPSHOT'`

### Go Backend
- **File:** `go-backend/main.go`
- **Action:** Add or update a `const Version = "X.Y.Z"` declaration
- **Note:** Go modules don't have a version field; use a constant in code

### Optional: Docker/Compose Tags
- If image tags need updating, note them in the report

---

## 5. Execution Steps

When the user triggers `Set-Version`:

### Step 1: Parse Input
Determine if user provided:
- An explicit version (e.g., `1.2.0`)
- A bump command (e.g., `minor`)
- No input (prompt for version)

### Step 2: Validate Version
- If explicit version: validate against SemVer regex
- If bump command: read current versions, calculate new version
- If invalid: show error with examples, do NOT proceed

### Step 3: Read Current Versions
Read and display current versions from all components:
```
📋 **Current Versions:**
- Frontend (package.json): X.Y.Z
- Java Backend (build.gradle): X.Y.Z
- Go Backend (main.go): X.Y.Z
```

### Step 4: Confirm Changes (if needed)
If versions differ across components, warn the user:
```
⚠️ **Warning:** Version mismatch detected across components.
All components will be updated to the new version: X.Y.Z
```

### Step 5: Apply Changes
Update all version files with the new version.

### Step 6: Generate Report
Output a detailed change report.

---

## 6. Version Change Report Template

After successful update, output this report:

```markdown
# 📦 Version Update Report

## Summary
| Field | Value |
|-------|-------|
| **Previous Version** | {old_version} |
| **New Version** | {new_version} |
| **Change Type** | {MAJOR/MINOR/PATCH/PRERELEASE} |
| **Timestamp** | {ISO 8601 timestamp} |

## Changes Applied

### ✅ Frontend (`frontend/package.json`)
- **Field:** `version`
- **Before:** `"{old_version}"`
- **After:** `"{new_version}"`

### ✅ Java Backend (`java-spring-boot-backend/build.gradle`)
- **Field:** `version`
- **Before:** `'{old_version}'` (or `'{old_version}-SNAPSHOT'`)
- **After:** `'{new_version}'` (or `'{new_version}-SNAPSHOT'`)

### ✅ Go Backend (`go-backend/main.go`)
- **Constant:** `Version`
- **Before:** `"{old_version}"` (or not present)
- **After:** `"{new_version}"`

## Files Modified
1. `frontend/package.json`
2. `java-spring-boot-backend/build.gradle`
3. `go-backend/main.go`

## Next Steps
- [ ] Review changes with `git diff`
- [ ] Run tests: `npm test`, `./gradlew test`, `go test ./...`
- [ ] Commit with message: `chore(release): bump version to {new_version}`
- [ ] Tag release: `git tag -a v{new_version} -m "Release {new_version}"`

## SemVer Compliance
✅ Version `{new_version}` is compliant with Semantic Versioning 2.0.0
```

---

## 7. Example Interactions

### Example 1: Explicit Version
**User:** `Set-Version 2.0.0`
**Agent:** Validates, updates all files, outputs report.

### Example 2: Bump Command
**User:** `Set-Version minor`
**Agent:** Reads current version (e.g., 1.2.3), calculates 1.3.0, updates all files.

### Example 3: Invalid Input
**User:** `Set-Version v1.0`
**Agent:** Shows error explaining 'v' prefix and missing PATCH, provides examples.

### Example 4: Prerelease
**User:** `Set-Version 1.0.0-rc.1`
**Agent:** Updates all files with prerelease version, notes SNAPSHOT handling for Java.

---

## 8. Special Handling

### Java SNAPSHOT Versions
- For prerelease versions in Java, use `-SNAPSHOT` suffix
- `1.0.0-alpha` in SemVer → `1.0.0-alpha-SNAPSHOT` in Gradle (or keep as-is based on project convention)
- For release versions, remove `-SNAPSHOT`

### Go Version Constant
If `go-backend/main.go` doesn't have a Version constant, add it:
```go
package main

const Version = "X.Y.Z"

// ...existing code...
```

---

## 9. Validation Regex

Use this regex for SemVer validation:
```regex
^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$
```

---

## Variables

- `$VERSION` — The target version (user-provided or calculated)
- `$BUMP_TYPE` — The type of version bump (major, minor, patch, prerelease)

---

## Trigger

This prompt activates when user types:
- `Set-Version <version>`
- `Set-Version <bump_type>`
- `/set-version`
- `update version to <version>`
- `bump version <type>`
