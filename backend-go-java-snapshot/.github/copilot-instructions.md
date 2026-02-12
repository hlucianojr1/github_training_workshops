# Copilot Instructions — High Scores Demo (Agent Rules)


## YOU MUST ASK QUESTION BEFORE ANYTHING ELSE IF ANYTHING IS UNCLEAR.
## NO ASSUMPTIONS. CLARIFY FIRST.

These instructions are for AI coding agents working in this repository. Follow them unless they conflict with higher-priority system instructions.

## 1) Scope and goals

- Make **small, reviewable, minimal-diff** changes. Don’t reformat or rename broadly unless required.
- Prefer **existing patterns** already used in this repo.
- Keep the repo **runnable**: after substantive changes, run the most relevant build/lint/tests.
- Don’t introduce new dependencies unless there’s a clear benefit; keep them minimal and pinned.
- Never add or output secrets. Don’t log secrets.

## 2) Repo architecture (what exists today)

This repo is a full-stack leaderboard app:

- `frontend/`: React 18 + Vite + TypeScript + Tailwind. Calls `/api/scores/*`.
- `java-spring-boot-backend/`: Spring Boot REST API implementing `/api/scores/*`.
- `go-backend/`: Go implementation area for the same API contract.
- `terraform/`: local + Azure infra.

When making backend changes, ensure the **frontend contract remains compatible**.

## 3) API contract constraints

Endpoints expected by the frontend:

- `POST /api/scores/submit`
- `GET /api/scores/game/{name}/top?limit=10`
- `GET /api/scores/player/{name}?page=0&size=10`
- `GET /api/scores/games`
- `GET /api/scores/players`

When implementing these endpoints (in any backend), preserve:

- JSON field names and types as used by `frontend/src/app/api/scoreService.ts` and `frontend/src/app/api/types.ts`.
- Error handling that is machine-readable and consistent.
- Pagination behavior for list endpoints (include metadata), matching existing backend behavior where applicable.

## 4) Go backend rules (`go-backend/`) — enforced

### 4.1 Structure

Prefer this layout:

- `go-backend/cmd/highscores-api/main.go`
- `go-backend/internal/httpapi/` (routing/handlers/middleware)
- `go-backend/internal/domain/` (pure domain types + business rules)
- `go-backend/internal/storage/` (persistence adapters)
- `go-backend/internal/config/` (env/config)
- `go-backend/internal/observability/` (logging/metrics wiring)
- `go-backend/migrations/` (Go-service-owned migrations)

Import boundaries:

- `internal/domain` must not import `internal/httpapi` or `internal/storage`.
- `internal/httpapi` depends on `domain` + small interfaces, not concrete DB types.

### 4.2 HTTP quality

- Use `context.Context` end-to-end.
- Server must have sane timeouts.
- Validate requests explicitly (required strings non-empty; score >= 0; paging params bounded).
- Return consistent JSON errors:
  - `{"error":{"code":"...","message":"..."}}`
  - Validation errors → `400`.

### 4.3 Errors, logging, concurrency

- Don’t ignore errors. Wrap with context: `fmt.Errorf("…: %w", err)`.
- Define sentinel domain errors in `internal/domain` for business cases.
- Structured logging with a `request_id` (use `X-Request-Id` when present or generate one).
- No goroutine leaks. Background work must be tied to context or properly waited.

### 4.4 Dependency hygiene

- Prefer the standard library.
- If adding deps, keep them small and justify in code review description.
- Keep the module tidy (`go mod tidy`).

## 5) Single database per service (Go)

If implementing persistence for the Go service:

- Treat the Go service as owning **one database/schema**.
- Do not couple to the Java service’s schema or read Java-owned tables directly.
- Place schema changes/migrations under `go-backend/migrations/`.

## 6) Testing requirements

### 6.1 General

- Add or update tests with behavior changes.
- New behavior should include at least:
  - happy path
  - one validation failure
  - one dependency failure (e.g., repository error)

### 6.2 Go testing (when touching `go-backend/`)

- Prefer table-driven tests.
- `internal/httpapi`: handler tests with `httptest`.
- Keep tests fast and parallelizable (`t.Parallel()` where safe).

## 7) Working agreements for edits

- Read relevant files before editing.
- Preserve public APIs unless the change requires it.
- Update docs only when the change impacts a developer workflow.

## 8) Reference points in this repo

- Frontend contract reference:
  - `frontend/src/app/api/scoreService.ts`
  - `frontend/src/app/api/types.ts`
- Existing API behavior reference:
  - `java-spring-boot-backend/*.http`
- Compose wiring reference:
  - `docker-compose.yml`
