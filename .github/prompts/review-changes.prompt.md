---
name: review-changes
description: Review the current uncommitted changes (or branch diff) like a strict senior reviewer before commit/PR.
argument-hint: "[base branch — default: uncommitted changes]"
agent: agent
---

Review the changes against: **${input:base:uncommitted changes (git diff HEAD)}**

1. Get the diff (`git diff HEAD`, or `git diff <base>...HEAD`) and the list of changed files. Read each changed file in full for context, not just the hunks.
2. Review for, in priority order:
   1. **Correctness** — logic errors, unhandled cases, race conditions, broken contracts with callers.
   2. **Security** — injection, missing authZ, secrets, XSS, PII in logs/URLs ([security rules](../instructions/security.instructions.md)).
   3. **Completeness** — missing loading/empty/error states, validation, tests ([webapp-completeness](../skills/webapp-completeness/SKILL.md)).
   4. **Standards** — the rules in `.github/instructions/` for each file type; design tokens; accessibility.
   5. **Simplicity** — duplication of existing utilities/components, unnecessary abstraction, dead code, leftover debug code.
3. Run the [verify-changes](../skills/verify-changes/SKILL.md) checks.
4. Output findings grouped as **Must fix / Should fix / Consider**, each with `file:line`, the problem, and the suggested change. Say explicitly if you found nothing in a group. Don't pad with praise or trivia.
5. Don't edit files unless I ask; offer to fix the Must-fix items.
