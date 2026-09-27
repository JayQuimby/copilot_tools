# Frontend Audit Checklist

Each check has an ID so findings and fixes can reference it (e.g. `A11Y-04`). Score each category 0–5:
**5** exemplary · **4** solid, minor gaps · **3** acceptable, clear gaps · **2** weak, recurring problems · **1** poor · **0** absent/broken.

---

## ARCH — Architecture & organization
- **ARCH-01** Clear folder structure (feature-based or layered), applied consistently. No "misc"/"utils2"/"helpers-new" dumping grounds.
- **ARCH-02** Shared UI primitives exist and are actually used; no near-duplicate components (`Button`, `PrimaryButton`, `Btn`, `CustomButton`).
- **ARCH-03** Separation of concerns: API calls in a data layer, not scattered `fetch` in components; business logic not buried in JSX.
- **ARCH-04** Components are reasonably sized (> ~250 lines or > ~7 props of mixed concerns is a smell).
- **ARCH-05** No circular imports; barrel files don't pull heavy modules into every bundle.
- **ARCH-06** One way of doing each thing: one styling approach, one data-fetching library, one form library, one date library, one icon set.
- **ARCH-07** Dead code: unused components, exports, files, dependencies, feature flags that are always on.

## TS — Type safety & code quality
- **TS-01** `strict: true` (and ideally `noUncheckedIndexedAccess`) in tsconfig. Typecheck passes.
- **TS-02** No `any` / `as any` / `as unknown as` / `@ts-ignore` / unexplained `@ts-expect-error`. Count them.
- **TS-03** External data (API responses, storage, URL params, env) validated at runtime, not just cast.
- **TS-04** State modeled with discriminated unions rather than multiple optional booleans.
- **TS-05** ESLint configured (flat config) with `typescript-eslint`, `react-hooks`, `jsx-a11y`; lint passes; `eslint-disable` comments are rare and justified.
- **TS-06** No floating promises; errors not swallowed by empty `catch`.
- **TS-07** Naming is consistent and meaningful; no leftover `console.log`, commented-out code, or TODOs without owners.
- **TS-08** Magic numbers/strings extracted into named constants or config.

## REACT — React correctness
- **REACT-01** No components defined inside other components.
- **REACT-02** Stable keys from data; no `key={index}` on dynamic/reorderable lists; no random keys.
- **REACT-03** No derived state stored in `useState` and synced via `useEffect`.
- **REACT-04** `useEffect` used only for external synchronization; each has correct deps and cleanup; no `exhaustive-deps` suppressions.
- **REACT-05** No data fetching in raw `useEffect` without abort/race handling (prefer a data library).
- **REACT-06** No state mutation (`arr.push`, `obj.x = ` on state); updates are immutable; functional `setState` when depending on previous value.
- **REACT-07** Conditional rendering doesn't leak `0`/`''` (`{items.length && …}`).
- **REACT-08** Context values are memoized/split so unrelated consumers don't re-render; no giant "AppContext".
- **REACT-09** Error boundaries exist at route level (and around risky widgets).
- **REACT-10** Refs not used to bypass React's data flow; no direct DOM manipulation where state would do.
- **REACT-11** React 19 idioms where applicable: `ref` as prop (no new `forwardRef`), actions/`useActionState` for forms, `use()` with Suspense, `useOptimistic`.
- **REACT-12** RSC/Next.js (if used): `'use client'` pushed to leaves; server actions authenticate; no secrets or excess data serialized to the client.

## STATE — State & data management
- **STATE-01** Server state handled by a cache library (TanStack Query / SWR / RSC / loaders) with sensible stale times and invalidation after mutations.
- **STATE-02** URL holds shareable state (filters, sort, pagination, tabs, selected entity). Refresh and back/forward preserve the view.
- **STATE-03** No duplicated sources of truth (same data in store + component state + URL).
- **STATE-04** Global store only holds truly global state; no prop drilling beyond ~3 levels.
- **STATE-05** Optimistic updates roll back on failure; stale responses can't overwrite newer ones.
- **STATE-06** Persisted client state (`localStorage`) is versioned, validated on read, and contains no sensitive data.

## PERF — Performance
- **PERF-01** No request waterfalls: independent fetches run in parallel; no parent-fetch → child-fetch chains for data known up front.
- **PERF-02** Route-level code splitting (`lazy`, dynamic import); heavy libraries (charts, editors, maps, PDF) loaded on demand.
- **PERF-03** Bundle hygiene: no full-library imports (`import _ from 'lodash'`, whole icon packs, `moment`); tree-shakable imports; reasonable initial JS (flag > ~200 KB gzipped for an app shell).
- **PERF-04** Images: modern formats, explicit `width`/`height` (or aspect-ratio), `loading="lazy"` below the fold, priority/preload for the LCP image, responsive `srcset`.
- **PERF-05** Fonts: self-hosted or preloaded, `font-display: swap`, limited weights/subsets; no layout shift on load.
- **PERF-06** Long lists (> ~100 rows) virtualized or paginated; `content-visibility: auto` for long offscreen sections.
- **PERF-07** Expensive computation not repeated on every render; input handlers stay responsive (`useDeferredValue`/`startTransition`, debounced search). Targets INP ≤ 200 ms.
- **PERF-08** No layout thrash (reading layout in loops), no `transition: all`, animations use `transform`/`opacity`.
- **PERF-09** Core Web Vitals targets: LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1. Skeletons match final layout to avoid shift.
- **PERF-10** Third-party scripts deferred/async and loaded after hydration.

## A11Y — Accessibility (WCAG 2.2 AA)
- **A11Y-01** Semantic landmarks (`header`, `nav`, `main`, `footer`), one `h1`, logical heading order, skip link, `lang` on `<html>`.
- **A11Y-02** No clickable `div`/`span`; interactive elements are `button`/`a[href]`/form controls.
- **A11Y-03** Full keyboard operability of every flow; logical tab order; no keyboard traps; no positive `tabIndex`.
- **A11Y-04** Visible `:focus-visible` indicator everywhere (≥ 3:1), never `outline: none` without replacement; focus not hidden by sticky elements.
- **A11Y-05** Dialogs/menus/popovers: focus trap, Escape to close, focus returns to trigger, background inert, correct roles.
- **A11Y-06** All form controls labelled; errors associated via `aria-describedby` and announced; required fields indicated in text.
- **A11Y-07** Images have appropriate `alt`; icon-only buttons have `aria-label`; decorative icons `aria-hidden`.
- **A11Y-08** Color contrast: text ≥ 4.5:1, large text/UI ≥ 3:1 — check muted text, placeholders, disabled-looking-but-enabled controls, text on brand colors, dark mode.
- **A11Y-09** Information not conveyed by color alone (status, validation, charts, links in body text).
- **A11Y-10** Dynamic updates announced (`aria-live`/`role="status"`) — toasts, async validation, "saved".
- **A11Y-11** Target size ≥ 24×24 px; zoom not disabled; reflow at 320 px / 400% zoom.
- **A11Y-12** `prefers-reduced-motion` respected; no auto-playing motion that can't be paused.
- **A11Y-13** Route changes update `document.title` and move focus appropriately (SPA).
- **A11Y-14** Tables use `<th scope>`/captions; data grids follow the grid pattern if interactive.

## VIS — Visual design & consistency
- **VIS-01** A token source exists (CSS variables / Tailwind theme) for color, spacing, radius, shadow, typography, z-index — and components use it. Count hardcoded hex/px values in components.
- **VIS-02** Restrained palette: one primary/accent, a neutral ramp, semantic colors (success, warning, danger, info). No near-duplicate grays or blues.
- **VIS-03** Typography: a defined type scale, ≤ 2 families, ≤ 3–4 weights used consistently; heading hierarchy visually clear; comfortable line length (~60–80ch) and line height.
- **VIS-04** Spacing: consistent scale (4/8 px based); related items grouped; consistent padding in cards, forms, tables, page gutters.
- **VIS-05** Consistent radii, borders and elevation; nested radii ≤ parent; shadows used for elevation meaning, not decoration.
- **VIS-06** Alignment: elements align to a grid; form labels, inputs and buttons line up; icons optically centered with text.
- **VIS-07** Components look and behave identically everywhere (same button in every place, same table style, same empty state style).
- **VIS-08** All interactive states styled: hover, active, focus-visible, disabled, selected, loading.
- **VIS-09** Dark mode (if supported) is complete: no unthemed surfaces, images/illustrations readable, `color-scheme` set.
- **VIS-10** Visual hierarchy: one clear primary action per view; secondary actions visually subordinate; destructive actions distinct.
- **VIS-11** Icons from one set, consistent size and stroke; no emoji as UI icons in a professional app.
- **VIS-12** No "template tells": gratuitous gradients, everything-in-a-card, random glassmorphism, oversized hero padding in an app UI, inconsistent decorative flourishes.
- **VIS-13** Favicon, app title, meta theme-color and brand assets present and correct.

## RESP — Responsiveness & layout
- **RESP-01** Works at 360 px with no horizontal scroll; tables have a mobile strategy (scroll container, stacked cards, or column priority).
- **RESP-02** Uses fluid layout (flex/grid, `minmax`, `clamp`) rather than fixed widths; sensible max-width on large screens.
- **RESP-03** Navigation adapts (collapsible nav/drawer) and remains keyboard/screen-reader accessible.
- **RESP-04** Touch targets adequate; hover-only interactions have touch/keyboard equivalents.
- **RESP-05** Safe areas respected on mobile (notches); inputs ≥ 16 px font to avoid iOS zoom.
- **RESP-06** Modals/drawers usable on small screens (scrollable body, reachable actions, `overscroll-behavior: contain`).

## UX — States, feedback & completeness
(See the `webapp-completeness` skill for the full definition-of-done.)
- **UX-01** Every async view has loading, error (with retry), empty (with next action) and success states.
- **UX-02** Loading indicators don't flicker (delay ~150–300 ms) and skeletons match the final layout.
- **UX-03** Every mutation gives feedback (pending → success/error) and disables double-submit.
- **UX-04** Destructive actions confirm or offer undo; confirmation names the thing being destroyed.
- **UX-05** Unsaved-changes warning on forms that can lose work.
- **UX-06** 404, 403 and generic error pages exist and offer a way forward.
- **UX-07** Session expiry handled gracefully (redirect to login, preserve return URL, don't lose input).
- **UX-08** Long/short/missing content handled: truncation with full text available, long words wrap, missing avatars/images fall back.
- **UX-09** Lists support the expected operations at scale: search, sort, filter, pagination — and they are deep-linkable.
- **UX-10** Links behave like links (middle-click, open in new tab, right-click); back button works as expected.

## FORM — Forms
- **FORM-01** Schema-based validation shared with (or mirroring) the server; server errors mapped back to fields.
- **FORM-02** Validation timing is humane: on blur / on submit, not on every keystroke from the first character.
- **FORM-03** Errors appear next to the field, say how to fix it, and focus moves to the first error on submit.
- **FORM-04** Correct `type`, `inputMode`, `autoComplete`, `name`; password managers and paste work; `spellCheck={false}` on codes/emails.
- **FORM-05** Submit button not pre-disabled; shows pending state; prevents double submit; Enter submits.
- **FORM-06** Sensible defaults, input masks don't fight the user, values trimmed.

## COPY — Content, copy & i18n
- **COPY-01** Consistent terminology (same noun for the same thing everywhere) and consistent capitalization style for buttons/headings.
- **COPY-02** Button labels are specific verbs ("Save changes", "Delete invoice") — not "OK"/"Submit"/"Click here".
- **COPY-03** Error messages explain what happened and how to fix it; no raw error codes or stack traces shown.
- **COPY-04** Dates, numbers, currency formatted with `Intl` for the user's locale; timezones explicit where they matter.
- **COPY-05** No lorem ipsum, placeholder text, "Coming soon" dead ends, or test data in production UI.
- **COPY-06** If i18n is in scope: no hardcoded user-facing strings; layouts tolerate 30–40% longer text.

## SEC — Security & privacy (frontend)
- **SEC-01** No secrets or private API keys in client code or public env vars.
- **SEC-02** No `dangerouslySetInnerHTML` / `innerHTML` with unsanitized data; user-supplied URLs validated (no `javascript:`).
- **SEC-03** Auth tokens not stored in `localStorage`; session via `HttpOnly` cookies where possible; CSRF protection for cookie auth.
- **SEC-04** Authorization is enforced server-side; UI hiding is not relied on for security.
- **SEC-05** No PII or tokens in URLs, logs, analytics events or error-reporting payloads.
- **SEC-06** CSP and security headers configured (or noted as a gap); third-party scripts inventoried.
- **SEC-07** `npm audit` shows no high/critical vulnerabilities in production deps.

## ERR — Error handling & resilience
- **ERR-01** Route-level error boundaries with a friendly fallback and a retry/navigate option.
- **ERR-02** API layer normalizes errors into a typed shape; network failures, timeouts and 401/403/5xx handled distinctly.
- **ERR-03** Errors reported to a monitoring service (if the org uses one) with PII scrubbed.
- **ERR-04** App degrades gracefully offline/slow network (requests have timeouts; retry is possible; no infinite spinners).

## TEST — Testing
- **TEST-01** Test runner configured and tests pass.
- **TEST-02** Critical flows covered by e2e tests (auth, main CRUD path).
- **TEST-03** Components tested via Testing Library with role-based queries; network mocked with MSW.
- **TEST-04** Accessibility assertions (axe) in component or e2e tests.
- **TEST-05** No committed `.only`/`.skip`; tests are deterministic.

## TOOL — Tooling & delivery
- **TOOL-01** Scripts for `dev`, `build`, `typecheck`, `lint`, `test`, `format` exist and work.
- **TOOL-02** CI runs typecheck, lint, tests and build on every PR.
- **TOOL-03** Formatter (Prettier/Biome) configured and applied consistently.
- **TOOL-04** Dependencies reasonably current (framework and React not multiple majors behind); no deprecated packages (e.g. `moment`, `request`, CRA/`react-scripts`).
- **TOOL-05** Environment config documented (`.env.example`) and validated.
- **TOOL-06** README explains setup, scripts and architecture in enough detail for a new developer.

## META — Page metadata & SEO (public-facing apps only)
- **META-01** Unique `<title>` and meta description per route; Open Graph tags for shareable pages.
- **META-02** Canonical URLs, `robots` rules, sitemap if public.
- **META-03** Correct HTTP status for not-found routes in SSR apps.
