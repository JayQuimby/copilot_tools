---
name: react-patterns
description: Modern React 19 + TypeScript patterns and before/after refactor recipes for fixing poorly implemented React code — useEffect misuse, derived state, data fetching, prop drilling, giant components, re-render problems, forms, error boundaries, context. Use when writing new React components or hooks, refactoring or cleaning up React code, fixing React bugs or performance problems, or when an audit finding references REACT-, STATE- or PERF- checks.
argument-hint: "[component or file to write/refactor]"
---

# React Patterns

Use this skill to write React code the right way the first time, and to fix React code that was written poorly.

- [Refactor recipes](./references/refactor-recipes.md) — before/after fixes for the most common problems
- [Component blueprint](./references/component-blueprint.md) — the default shape for components, hooks, and data-driven views

## Decision guide

**Where does this state live?**
1. Can it be computed from props/other state? → compute during render. No state.
2. Is it server data? → data layer (TanStack Query / SWR / RSC / router loader).
3. Should it survive refresh or be shareable? → URL search params.
4. Is it used by one component? → `useState` in that component.
5. Shared by a few nearby components? → lift to the nearest common parent.
6. Truly app-wide (auth user, theme, flags)? → context (split by concern) or a small store (Zustand).
7. Complex transitions between many fields? → `useReducer` or a state machine.

**Do I need `useEffect`?**
Only to synchronize with something outside React: subscriptions, browser APIs, timers, third-party widgets, manual DOM measurements. Not for: derived data, event responses, resetting on prop change (use `key`), fetching (use the data layer), or notifying parents (call the callback in the event handler).

**Do I need memoization?**
With React Compiler on: no. Without: only after measuring, or for referential stability that a memoized child or an effect depends on.

**Should I split this component?**
Split when a component: exceeds ~200 lines; has multiple unrelated state groups; mixes data fetching with complex presentation; or has JSX sections that could be named. Extract a custom hook when logic (state + effects) is reusable or distracting from the markup.

## Workflow when refactoring existing code
1. Read the component and all its call sites. Note the current behavior, including edge cases, so you don't change it accidentally.
2. If there are no tests covering the behavior, add a characterization test first (Testing Library, role-based queries).
3. Apply the recipe in small steps, re-running typecheck and tests after each.
4. Don't mix refactors with behavior changes in one step.
5. Summarize the before/after and why in your final message.
