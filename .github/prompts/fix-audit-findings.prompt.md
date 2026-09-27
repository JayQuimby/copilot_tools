---
name: fix-audit-findings
description: Fix findings from an audit report in priority order, verifying each fix.
argument-hint: "[report path] [finding IDs or severity, e.g. 'F-001 F-004' or 'critical,high']"
agent: agent
---

Fix audit findings.

- Report: **${input:report:path to the audit report in docs/audits/}**
- Which findings: **${input:which:all Critical and High findings, quick wins first}**

Process:
1. Read the report. Build a todo list of the selected findings, ordered: Critical → High quick wins (S effort) → remaining High → others.
2. For each finding:
   a. Re-read the cited code (it may have changed since the audit). If the finding no longer applies, mark it resolved-already and move on.
   b. Apply the fix from the report, using the relevant skill for the category: [react-patterns](../skills/react-patterns/SKILL.md) for REACT/STATE/PERF, [frontend-design](../skills/frontend-design/SKILL.md) for VIS/RESP, [webapp-completeness](../skills/webapp-completeness/SKILL.md) for UX/FORM, [node-api](../skills/node-api/SKILL.md) for backend IDs.
   c. For systemic findings (e.g. "hardcoded colors in 40 files"), fix the root cause first (add the tokens/shared component), then migrate usages. Fix **all** listed locations, not just the first.
   d. Keep each fix scoped to its finding. Don't refactor unrelated code.
   e. Add or update a test when the finding is behavioral.
3. After every 2–3 findings, run the [verify-changes](../skills/verify-changes/SKILL.md) loop.
4. Update the report: add a `**Status:** Fixed (<short note>)` line under each fixed finding, or `Deferred (<reason>)`.
5. Finish with a summary table: finding → status → files changed, plus verification results.
