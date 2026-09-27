---
name: frontend-audit
description: Systematic, evidence-based audit of an existing web frontend (React/TypeScript/JS) covering both functional quality (correctness, types, state, performance, accessibility, security, error handling, tests, tooling) and aesthetic quality (visual consistency, design tokens, typography, spacing, responsiveness, UX states, copy). Use when asked to audit, review, assess, grade or find problems in a frontend, UI, React app or component library, or before a release or handoff. Produces a prioritized findings report with file:line evidence and concrete fixes.
argument-hint: "[path or area to audit, default: whole app]"
---

# Frontend Audit

You are performing a professional frontend audit. The goal is a **prioritized, evidence-backed list of problems with concrete fixes**, not a generic lecture. Every finding must point to real code.

Supporting files (read them when you reach the phase that uses them):
- [Audit checklist](./references/checklist.md) — every check, grouped by category, with IDs
- [Smell search patterns](./references/smell-search.md) — text/regex searches that surface likely problems fast
- [Report template](./references/report-template.md) — the required output format

## Ground rules
- **Evidence or it didn't happen.** Each finding cites `path/to/file.tsx:line` (or a screenshot/command output) and quotes the offending snippet briefly. No finding without a location.
- **Verify before reporting.** A search hit is a *lead*, not a finding. Open the file and confirm it's actually a problem in context (e.g. `key={index}` on a static list is fine).
- **Group duplicates.** If the same issue appears in 14 files, report it once with the count and the 3–5 worst locations, not 14 times.
- **Prioritize by user and business impact**, not by how easy it was to find.
- **Don't fix anything during the audit** unless the user asked for it. The deliverable is the report. Fixes come after (see `/fix-audit-findings`).
- Be honest about coverage: list what you could not check (e.g. "did not run the app; visual checks are from code only").

## Phase 1 — Reconnaissance (build a map before judging)
1. Read `package.json` (scripts, dependencies and versions), `tsconfig*.json`, ESLint/Prettier config, build config (`vite.config.*`, `next.config.*`), and any README/CONTRIBUTING/AGENTS.md.
2. Identify: framework & router, rendering model (SPA / SSR / RSC), styling approach, component library, state/data-fetching libraries, form library, test setup, i18n.
3. Map the app: list routes/pages, shared components directory, design-token source (CSS variables, Tailwind theme, theme file), API client layer.
4. Note the scope: if the user gave a path/area, restrict to it but still read the shared primitives it depends on.

Write a short **Context** section from this (it goes at the top of the report).

## Phase 2 — Automated signals (run what exists; don't install new tooling without asking)
Run the project's own scripts where present and capture pass/fail + counts:
- Type check: `npx tsc --noEmit` (or `npm run typecheck`)
- Lint: `npm run lint` / `npx eslint .`
- Tests: `npm test -- --run` (vitest) or equivalent; note coverage if configured
- Build: `npm run build` — record bundle output sizes if printed
- Dependencies: `npm audit --omit=dev`, `npm outdated`
- If Playwright + `@axe-core/playwright` or Lighthouse is already set up, run it.

If a command fails for environmental reasons, record that and move on.

## Phase 3 — Pattern sweep
Run the searches in [smell-search.md](./references/smell-search.md). For each hit, open the file and confirm or discard. Keep a scratch list of confirmed issues with locations.

## Phase 4 — Deep review against the checklist
Walk through every category in [checklist.md](./references/checklist.md). For a large app, sample deliberately:
- all shared primitives (Button, Input, Modal, Table, Layout, Nav)
- the 3–5 most important user flows end to end (usually: auth, main list/dashboard, detail view, create/edit form, settings)
- the largest components by line count (`find src -name '*.tsx' | xargs wc -l | sort -n | tail -20`)
- the API/data layer

For **aesthetic** review without running the app: read the token/theme source, then compare how components actually use color, spacing, radius, type and shadow. Inconsistency (e.g. 7 different grays, 5 border radii, mixed spacing) is a finding.

If the app can be started and a browser tool is available, also check it visually at 360px, 768px and 1440px, in light and dark mode, and do a keyboard-only pass of the main flow.

## Phase 5 — Score and prioritize
Severity:
- **Critical** — security hole, data loss, crash in a core flow, legal accessibility blocker (can't complete a task by keyboard/screen reader), broken build/types.
- **High** — wrong behavior users will hit, missing error/loading states in core flows, serious performance issue (e.g. waterfalls, huge bundle), major visual inconsistency on primary screens.
- **Medium** — maintainability problems, inconsistent patterns, minor a11y issues, missing tests on important logic.
- **Low** — polish, naming, small refactors.

Effort: **S** (< 1 hr), **M** (half a day), **L** (multi-day / cross-cutting).

Also give each category a 0–5 score (see checklist) so progress is measurable across audits.

## Phase 6 — Report
Produce the report exactly in the format in [report-template.md](./references/report-template.md). Save it to `docs/audits/frontend-audit-<YYYY-MM-DD>.md` in the audited project (create the folder), and show the executive summary + top findings in chat.

End by offering the next step: "Run `/fix-audit-findings` with the report path to fix issues, starting with Critical/High quick wins."
