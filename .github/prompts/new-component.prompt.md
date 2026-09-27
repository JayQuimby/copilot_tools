---
name: new-component
description: Create a reusable, accessible, fully-stated React component that fits the existing design system.
argument-hint: "[component name and purpose]"
agent: agent
---

Create a component: **${input:component:name and purpose}**

1. **Search first.** Look for an existing component that does this or nearly does it (`#codebase`, search by likely names). If one exists, extend it instead and explain why.
2. **Study the system.** Read the design token source and 2–3 existing primitives in `components/ui` (or equivalent) to match API style, styling approach, variant pattern and file layout.
3. **Design the API**: typed props extending the native element's props where it wraps one; variants as unions; `className` and rest props forwarded; controlled + uncontrolled support if it holds a value.
4. **Build it** following [react-patterns](../skills/react-patterns/SKILL.md) and [frontend-design](../skills/frontend-design/SKILL.md):
   - Semantic HTML / accessible primitive (Radix, React Aria, or the project's library) for anything interactive.
   - Every state: default, hover, active, focus-visible, disabled, loading/pending, error, empty, selected (as applicable).
   - Tokens only — no hardcoded colors, sizes or spacing. Works in dark mode if the app supports it.
   - Handles long, short and missing content.
5. **Test it**: Testing Library tests for behavior and keyboard interaction, plus an axe assertion. Add a story if the project uses Storybook.
6. Run [verify-changes](../skills/verify-changes/SKILL.md) and summarize: API, usage example, files created.
