# Report Template

Use this structure exactly. Keep the executive summary readable by a non-engineer; keep findings precise enough that another engineer (or agent) can fix them without re-investigating.

````markdown
# Frontend Audit — <App name>

**Date:** YYYY-MM-DD · **Scope:** <whole app | path> · **Commit:** <short SHA if available>
**Auditor:** GitHub Copilot (<model>) using the `frontend-audit` skill

## Executive summary
<3–5 sentences: overall health, the biggest risks, and what to fix first.>

| Category | Score (0–5) | Critical | High | Medium | Low |
|---|---|---|---|---|---|
| Architecture (ARCH) | | | | | |
| Type safety (TS) | | | | | |
| React correctness (REACT) | | | | | |
| State & data (STATE) | | | | | |
| Performance (PERF) | | | | | |
| Accessibility (A11Y) | | | | | |
| Visual design (VIS) | | | | | |
| Responsiveness (RESP) | | | | | |
| UX completeness (UX) | | | | | |
| Forms (FORM) | | | | | |
| Content & copy (COPY) | | | | | |
| Security (SEC) | | | | | |
| Error handling (ERR) | | | | | |
| Testing (TEST) | | | | | |
| Tooling (TOOL) | | | | | |

## Context
- **Stack:** <framework, router, rendering model, styling, component lib, data/state libs, forms, tests>
- **Structure:** <key directories, number of routes/components>
- **Design system:** <where tokens live, or "none found">

## Automated checks
| Check | Command | Result |
|---|---|---|
| Typecheck | `npx tsc --noEmit` | ✅ pass / ❌ 23 errors / ⚠️ not run (reason) |
| Lint | | |
| Tests | | |
| Build | | <bundle sizes if shown> |
| npm audit | | <n high / n critical> |

## Top 10 priorities
Ordered by impact ÷ effort. Quick wins (High impact, S effort) first.
1. **[F-003] <title>** — Critical · S
2. …

## Findings

### F-001 · <Short title>
- **Severity:** Critical | High | Medium | Low · **Effort:** S | M | L · **Check:** A11Y-02
- **Where:** `src/components/Table/Row.tsx:42` (+ 11 similar: `src/…:18`, `src/…:77`, …)
- **Evidence:**
  ```tsx
  <div onClick={() => onSelect(row.id)}>
  ```
- **Impact:** <who is affected and how — e.g. "keyboard and screen-reader users cannot select rows">
- **Fix:** <concrete change, with a short code example when helpful>
  ```tsx
  <button type="button" onClick={() => onSelect(row.id)}>
  ```

### F-002 · …

## Patterns & systemic issues
<Cross-cutting observations that aren't single findings — e.g. "no shared form field component, so validation display is implemented 6 different ways". Suggest the structural fix.>

## What's working well
<Brief, specific. Tells the team what to keep doing.>

## Coverage & limitations
- <What was sampled vs. fully reviewed>
- <What couldn't be checked (app not run, no browser, no backend access, etc.)>

## Recommended next steps
1. Fix Critical findings: F-…
2. Quick wins: F-…
3. Systemic work: <e.g. introduce design tokens, adopt TanStack Query>
4. Prevent regressions: <lint rules, CI checks, tests to add>
````
