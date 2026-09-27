---
name: verify-changes
description: Run the full verification loop after making code changes — discover the project's check scripts, run typecheck, lint, format, tests and build, fix failures caused by the change, and report results honestly. Use after editing code, before saying a task is complete, before committing or opening a PR, or when asked to "check", "verify", "make sure it works" or "run the tests".
---

# Verify Changes

Never report a task as done based on "the code looks right". Run the checks.

## 1. Discover the checks
Read `package.json` `scripts` (and workspace `package.json`s in a monorepo). Map what exists:

| Check | Typical script | Fallback |
|---|---|---|
| Typecheck | `typecheck`, `type-check`, `tsc` | `npx tsc --noEmit -p .` |
| Lint | `lint` | `npx eslint <changed files>` |
| Format | `format:check`, `format` | `npx prettier --check <changed files>` |
| Unit/component tests | `test`, `test:unit` | `npx vitest run <related>` / `npx jest <related>` |
| E2E | `test:e2e`, `e2e` | only when the change affects a covered flow |
| Build | `build` | — |

Detect the package manager from the lockfile (`package-lock.json` → npm, `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lock` → bun) and use it.

## 2. Run in order, cheapest first
1. **Typecheck** — fix all errors in files you touched; don't introduce new ones anywhere.
2. **Lint** — fix violations in touched code. Don't disable rules to pass.
3. **Format** — apply the formatter to changed files only.
4. **Tests** — run tests related to the change first (`vitest related <files>` / `jest --findRelatedTests <files>`), then the full suite if it's reasonably fast.
5. **Build** — when the change touches config, dependencies, routing, env vars, or imports across packages.

Run non-interactively (`CI=true`, `--run` for vitest) so commands don't hang in watch mode.

## 3. Fix loop
- If a check fails because of your change: fix the root cause, re-run that check, then continue.
- If a failure was **pre-existing** (fails on the untouched code too): don't paper over it; note it in the report.
- If a test fails, read the assertion and the code — don't change the test to match broken behavior unless the old behavior was actually wrong (and say so).
- Stop after 3 failed attempts at the same failure and report what you tried.

## 4. Also check
- VS Code Problems panel for touched files.
- `git diff` of your change: no stray debug logs, commented-out code, unrelated edits, secrets, or leftover TODOs.
- If UI changed and the app can run: load the affected screen and check it (including keyboard and a narrow viewport).

## 5. Report
End with a table like:

| Check | Command | Result |
|---|---|---|
| Typecheck | `npm run typecheck` | ✅ pass |
| Lint | `npm run lint` | ✅ pass |
| Tests | `npx vitest run src/features/invoices` | ✅ 24 passed |
| Build | — | ⏭️ skipped (no config/deps changed) |

Be literal: "not run" is an acceptable result; "should pass" is not.
