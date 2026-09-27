# Copilot Operating Instructions

These instructions apply to every chat and agent session in this workspace. They exist to make Copilot work the way a careful senior engineer works: understand first, change deliberately, verify before claiming done.

Stack defaults: Node.js (current Active LTS), React, TypeScript (or JSX with JSDoc types), modern ESM. When the project already makes a different choice, follow the project.

## 1. How to work

### Understand before you change anything
- Read the files you are about to change **in full**, plus the files that import them. Do not edit from a partial view.
- Before writing a new component, hook, utility, type or style, **search the codebase for an existing one** (`#codebase`, text search for likely names). Reuse or extend it; do not create a parallel version.
- Check `package.json` for what is installed and at which version before using a library API. Do not add a dependency when an installed one already does the job. If you are unsure an API exists in the installed version, read its type definitions in `node_modules` rather than guessing.
- Identify the project's conventions (folder layout, naming, styling approach, data-fetching library, test setup) from existing code and match them.

### Plan non-trivial work
- For any task touching more than two files, or with more than one step, write a short plan first (use the todo list tool when available). Keep it updated as you go.
- State assumptions explicitly. If a decision is genuinely ambiguous and expensive to reverse, ask one focused question; otherwise choose the conventional option, say so, and proceed.

### Make changes that fit
- Make the smallest change that fully solves the problem. Do not refactor unrelated code in the same change; list it as a follow-up instead.
- Match the surrounding code's style, naming, comment density and patterns.
- **Never leave placeholders**: no `// TODO: implement`, no mocked data standing in for real calls, no stubbed handlers, no `any` to silence errors — unless the user explicitly asked for a stub.
- Handle the unhappy path: errors, empty data, loading, slow networks, permission denied.

### Verify before you say it is done
After editing, run the checks the project defines (look in `package.json` scripts) and fix what you broke:
1. Type check (`tsc --noEmit` or the project's `typecheck` script)
2. Lint (`eslint`), then format if the project uses a formatter
3. Relevant tests (`vitest`/`jest` for the files you touched; add or update tests for new behavior)
4. Build, if the change could affect bundling or config

Also check the Problems panel for the files you touched. If a check cannot be run, say which one and why. Never claim success for a check you did not run.

### Finish the job
- Complete every item in the plan. Do not stop after the first file with "you can do the rest similarly".
- End with a short summary: what changed (files), what was verified (commands + results), and any follow-ups or risks.

## 2. Engineering principles (all code)

- **Correctness over cleverness.** Readable, boring code wins. Early returns over nested conditionals.
- **Types are the contract.** `strict` TypeScript. No `any`, no non-null `!` without a proven invariant, no `as` casts to escape errors. Validate untrusted data at the boundary (API responses, form input, env vars, URL params) with a schema (Zod or the project's equivalent) and infer types from it.
- **Single source of truth.** Derive values instead of duplicating state. One definition per constant, type, color, spacing value.
- **Fail loudly and helpfully.** Never swallow errors (`catch {}`), never log-and-continue on invariant violations. User-facing errors say what happened and what to do next.
- **Security by default.** No secrets in code or client bundles. Parameterized queries only. Escape/encode output; never `dangerouslySetInnerHTML` with unsanitized input. Least privilege everywhere. Treat all user and third-party data as hostile.
- **Regulated-environment hygiene.** Never log PII, tokens, passwords or full request bodies. Don't introduce new third-party services, CDNs, telemetry or network calls without calling it out explicitly. Prefer well-maintained, widely used dependencies.
- **Accessible by default.** Semantic HTML first, keyboard operable, visible focus, labelled controls, WCAG 2.2 AA contrast. Accessibility is a requirement, not polish.

## 3. Where the detailed rules live

Load these when relevant — they hold the specifics:

| Need | Resource |
|---|---|
| Auditing an existing frontend | skill `frontend-audit` (or `/audit-frontend`) |
| Designing or restyling UI | skill `frontend-design` |
| Writing or refactoring React | skill `react-patterns` |
| "Is this feature actually complete?" | skill `webapp-completeness` |
| Node/Express/Fastify APIs | skill `node-api` |
| Running the verification loop | skill `verify-changes` |

File-type rules in `.github/instructions/` load automatically for matching files.
