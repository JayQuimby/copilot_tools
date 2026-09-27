---
name: refactor-react
description: Clean up poorly implemented React code (effects, state, giant components, re-renders) without changing behavior.
argument-hint: "[file or component]"
agent: agent
---

Refactor: **${input:target:file or component}**

Use [react-patterns](../skills/react-patterns/SKILL.md) and its [refactor recipes](../skills/react-patterns/references/refactor-recipes.md).

1. Read the target fully and all its call sites. Write down the current behavior, including edge cases.
2. Diagnose: list every problem with the recipe ID that fixes it (R1–R18) and the line numbers.
3. If behavior isn't covered by tests, add characterization tests first (Testing Library, role-based queries) and make sure they pass on the **old** code.
4. Apply recipes one at a time; run typecheck + tests after each.
5. **Behavior must not change.** Don't mix in new features or visual changes.
6. Report: problems found → recipe applied → result, the verification table, and anything intentionally left alone.
