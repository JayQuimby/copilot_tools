---
name: audit-frontend
description: Full functional + aesthetic audit of a frontend, producing a prioritized findings report with file:line evidence.
argument-hint: "[path or area — default: entire frontend]"
agent: agent
---

Perform a complete frontend audit of: **${input:scope:the entire frontend}**

Follow the `frontend-audit` skill exactly: [SKILL.md](../skills/frontend-audit/SKILL.md). Read its references as you reach each phase:
- [checklist.md](../skills/frontend-audit/references/checklist.md)
- [smell-search.md](../skills/frontend-audit/references/smell-search.md)
- [report-template.md](../skills/frontend-audit/references/report-template.md)

Requirements:
1. Create a todo list with one item per phase (Recon, Automated checks, Pattern sweep, Deep review by category, Scoring, Report) and work through **all** of them. Don't stop after the pattern sweep.
2. Cover **both** functional quality (types, React correctness, state, performance, accessibility, security, error handling, tests, tooling) **and** aesthetic quality (tokens, color, typography, spacing, consistency, hierarchy, responsiveness, UX states, copy).
3. Every finding needs a real `file:line`, a short evidence snippet, impact, and a concrete fix. Confirm each search hit by reading the code before you report it.
4. Group repeated issues into one finding with a count and example locations.
5. Do **not** modify application code. The only file you create is the report at `docs/audits/frontend-audit-<today's date>.md`.
6. In chat, show the executive summary, the score table, and the top 10 priorities, then link the report file.
