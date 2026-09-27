---
name: React components
description: React 19 component, hook, state and data-fetching rules.
applyTo: "**/*.tsx,**/*.jsx"
---

# React rules

For deeper patterns and refactor recipes, load the `react-patterns` skill.

## Components
- Function components only. One exported component per file; small private helpers in the same file are fine.
- **Never define a component inside another component** — it remounts on every render and loses state. Hoist it.
- Props are typed explicitly. Extend native element props when wrapping an element: `type ButtonProps = React.ComponentProps<'button'> & { variant?: 'primary' | 'ghost' }`. Forward `className` and `...rest`.
- React 19: `ref` is a normal prop — don't add `forwardRef` to new components.
- Keep components under ~200 lines. When they grow, extract subcomponents or a custom hook.
- Keys are stable IDs from the data. `key={index}` only for static lists that never reorder.
- Conditional rendering: use a ternary or explicit boolean when the left side can be `0` or `''` (`{count > 0 && …}`, not `{count && …}`).

## State
- **Derive, don't sync.** If a value can be computed from props/state, compute it during render. Don't mirror it into `useState` + `useEffect`.
- Keep state as local as possible; lift only when siblings need it.
- Server data belongs in the data-fetching layer (TanStack Query, SWR, RSC, router loaders) — not in `useState` + `useEffect` + `fetch`.
- URL is state: filters, tabs, pagination, selected item and search terms go in search params so views are shareable and survive refresh.
- Use a reducer or a state machine for state with more than ~3 interdependent fields.
- Global client state (Zustand, Context) only for truly app-wide concerns (auth user, theme, feature flags). Split contexts so unrelated updates don't re-render everything.

## Effects
`useEffect` is for synchronizing with **external systems** (subscriptions, DOM APIs, timers, non-React widgets). It is not for:
- transforming data for render → compute inline (or `useMemo` if measured as expensive)
- responding to a user event → do it in the event handler
- resetting state when a prop changes → pass a `key`
- fetching data → use the data layer

When you do need an effect: include every dependency (never disable `react-hooks/exhaustive-deps`), return a cleanup, and abort in-flight requests with `AbortController`. Use `useEffectEvent` for logic that reads latest values but shouldn't retrigger the effect.

## Memoization
- If the React Compiler is enabled, don't add `useMemo`/`useCallback`/`memo` by hand.
- Without it, memoize only when profiling shows a problem, or to keep a reference stable for a memoized child or an effect dependency.

## Forms
- Use React 19 actions (`<form action>`, `useActionState`, `useFormStatus`) or React Hook Form + Zod, following the project.
- Every input has a `<label>`, a `name`, the right `type`/`inputMode`/`autoComplete`.
- Submit stays enabled until submission starts; then show pending state. Show field errors inline next to the field and move focus to the first error.

## Data fetching
- Every async view handles **loading, error, empty and success**. Use Suspense + error boundaries where the stack supports it.
- Start independent requests in parallel; avoid parent→child fetch waterfalls.
- Use `useOptimistic` or the query library's optimistic updates for fast-feeling mutations, with rollback on error.

## Next.js App Router (only if the project uses it)
- Server Components by default; add `'use client'` at the lowest leaf that needs interactivity.
- Authenticate and authorize **inside every Server Action and route handler** — they are public endpoints.
- Pass only the fields the client needs across the server→client boundary.

## Accessibility (non-negotiable)
- Interactive things are `<button>` or `<a href>`, never `<div onClick>`.
- Icon-only buttons need `aria-label`. Decorative icons get `aria-hidden="true"`.
- Images need meaningful `alt` (or `alt=""` if decorative).
- Dialogs, menus, comboboxes, tabs: use an accessible primitive library (Radix, React Aria, Headless UI, or the project's design system) instead of building from scratch.
