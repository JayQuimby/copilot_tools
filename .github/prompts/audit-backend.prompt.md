---
name: audit-backend
description: Audit a Node.js API/backend for security, correctness, consistency and performance, producing a prioritized report.
argument-hint: "[path — default: server code]"
agent: agent
---

Audit the Node.js backend at: **${input:scope:the server/API code}**

Use the `node-api` skill: [SKILL.md](../skills/node-api/SKILL.md) and walk every category in [backend-checklist.md](../skills/node-api/references/backend-checklist.md). Compare code against [patterns.md](../skills/node-api/references/patterns.md).

Process:
1. Recon: `package.json`, framework, entry point, route registration, middleware order, config loading, DB access layer, auth mechanism.
2. Run what exists: typecheck, lint, tests, `npm audit --omit=dev`.
3. Run the search leads in the skill; confirm each hit by reading the code.
4. Review every route for: validation, authN, **object-level authZ**, response shaping, error handling, pagination.
5. Write the report using the same structure as [the frontend report template](../skills/frontend-audit/references/report-template.md), with the backend categories (API, BARCH, BSEC, BERR, DATA, OBS, BPERF, BTEST). Save to `docs/audits/backend-audit-<today's date>.md`.

Do not modify application code. Security findings with real exploitability are Critical regardless of effort.
