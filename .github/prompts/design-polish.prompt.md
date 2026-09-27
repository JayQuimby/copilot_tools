---
name: design-polish
description: Make an existing screen or component look professional and consistent without changing behavior.
argument-hint: "[screen, route or component to polish]"
agent: agent
---

Polish the UI of: **${input:target:screen, route or component}**

Follow [frontend-design](../skills/frontend-design/SKILL.md), especially Step 0 (respect what exists) and Step 5 (review pass). Use [anti-patterns.md](../skills/frontend-design/references/anti-patterns.md) and [app-patterns.md](../skills/frontend-design/references/app-patterns.md).

1. Read the target and the design token source. List every visual problem you find, grouped as: consistency (off-token values, mismatched components), hierarchy, spacing/alignment, typography, color/contrast, states, responsiveness, copy.
2. Show that list with the planned change for each, then implement.
3. Rules:
   - **No behavior changes.** Visual, markup-semantics and copy improvements only. If you spot a bug, note it; don't fix it here.
   - Replace hardcoded values with tokens; add missing tokens to the token source rather than inventing local values.
   - Use existing shared components instead of one-off styled elements.
   - Keep or improve accessibility (contrast, focus, semantics).
4. Check the result at 360px, 768px and 1440px and in dark mode if supported (by running the app if possible, otherwise by careful reading).
5. Run [verify-changes](../skills/verify-changes/SKILL.md). Summarize before → after per group.
