---
name: webapp-completeness
description: Definition-of-done checklist that makes web app features production-complete rather than happy-path demos — loading/empty/error states, validation, permissions, responsiveness, accessibility, edge cases, feedback, navigation, and observability. Use when building a new feature, page or flow, when asked whether something is "done", "complete", "production ready" or "feature complete", or before opening a pull request.
argument-hint: "[feature, page or flow to check]"
---

# Web App Feature Completeness

A feature is not done when the happy path works. It's done when **a real user on a real device with real data** can't break it or get stuck. Use this list while building (as a plan) and before finishing (as a check). For each item, either satisfy it or state explicitly why it doesn't apply.

## How to use
1. Identify every screen, component and endpoint the feature touches.
2. Go through the sections below. For each gap, fix it (if in scope) or list it under "Known gaps" in your summary.
3. In your final message, include a compact table: section → ✅ / ⚠️ gap (reason) / N/A.

## 1. Data states (every async view)
- [ ] **Loading** — skeleton matching final layout (content) or inline spinner (small actions); delayed ~150–300ms to avoid flicker; no layout shift when data arrives.
- [ ] **Empty, first use** — explains what goes here and offers the action to create the first item.
- [ ] **Empty, no results** — echoes the search/filter and offers to clear it.
- [ ] **Error** — human-readable message, a Retry, and a way out. Different handling for network failure, 401 (re-auth), 403 (no access), 404 (gone), 409 (conflict), 5xx.
- [ ] **Partial / stale** — previous data kept while refetching (`keepPreviousData`); background refresh doesn't blank the screen.
- [ ] **Large data** — pagination/virtualization; tested with 1,000+ rows.

## 2. Mutations & feedback
- [ ] Pending state on the triggering control; double-submit prevented.
- [ ] Success feedback (toast, inline "Saved", navigation) that's announced to screen readers.
- [ ] Failure feedback near the cause; user input is preserved on failure.
- [ ] Destructive actions: confirmation naming the object, or undo.
- [ ] Optimistic updates (if used) roll back on error.
- [ ] Caches/queries invalidated so other views show fresh data.

## 3. Forms
- [ ] Schema validation on client **and** server (shared schema where possible); server errors mapped to fields.
- [ ] Labels, help text, required/optional indicators; correct input types, `autoComplete`, `inputMode`.
- [ ] Errors inline, specific, and focus moves to the first error on submit.
- [ ] Unsaved-changes warning if work can be lost.
- [ ] Edit forms prefilled; Cancel returns to where the user came from.
- [ ] Limits enforced and communicated (max length with counter, file size/type for uploads).

## 4. Permissions & security
- [ ] Server enforces authorization for every action (including direct URL access and API calls).
- [ ] UI hides or disables actions the user can't perform, with an explanation where helpful.
- [ ] Unauthenticated access redirects to login and returns to the original URL.
- [ ] No sensitive data in URLs, logs, client storage or error messages.
- [ ] Security-relevant actions are audit-logged (regulated environments).

## 5. Navigation & URL
- [ ] Every meaningful view has its own URL; filters, sort, pagination, tabs are in the URL.
- [ ] Refresh preserves the view; back/forward behaves as expected; scroll position is restored.
- [ ] Links are real links (open in new tab works).
- [ ] Page `<title>` updates per view; focus moves to the new content on route change.
- [ ] 404 for unknown IDs, not a blank page or an infinite spinner.

## 6. Accessibility
- [ ] Full flow completable with keyboard only; visible focus throughout.
- [ ] Screen reader: landmarks, headings, labels, live announcements for async results.
- [ ] Contrast passes in all themes; no color-only meaning.
- [ ] Dialogs trap and restore focus; Escape closes.
- [ ] Automated axe check passes for new screens.

## 7. Responsive & device
- [ ] Works at 360px, 768px, 1280px and wide screens; no horizontal page scroll.
- [ ] Touch targets ≥ 24px (44px preferred); no hover-only actions.
- [ ] Tables and wide content have a small-screen strategy.
- [ ] Dark mode (if supported) fully themed.

## 8. Content & edge cases
- [ ] Long names/values truncate gracefully with full text accessible; long unbroken strings wrap.
- [ ] Missing optional data shows a sensible placeholder ("—", "Not set"), never `undefined`/`null`/`NaN`/`Invalid Date`.
- [ ] Dates, numbers, currency formatted with `Intl`; timezones explicit where it matters.
- [ ] Copy is specific and consistent with the rest of the app; no lorem ipsum or TODO text.
- [ ] Concurrency: what happens if two users edit the same record? (409 handling / last-write-wins called out.)

## 9. Performance
- [ ] No request waterfalls; heavy components lazy-loaded.
- [ ] Interaction stays responsive (typing, filtering) with realistic data volumes.
- [ ] Images sized and lazy-loaded; no CLS from late content.

## 10. Quality & operability
- [ ] Types strict, no `any`; lint clean; tests added for new behavior and the main error path.
- [ ] Errors reported to monitoring (PII scrubbed); useful structured logs on the server.
- [ ] Feature flags / config documented; new env vars added to `.env.example` and validated.
- [ ] README or docs updated if setup or behavior changed.
