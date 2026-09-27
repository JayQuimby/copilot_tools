---
name: Accessibility (WCAG 2.2 AA)
description: Accessibility requirements for any markup-producing file.
applyTo: "**/*.tsx,**/*.jsx,**/*.html,**/*.vue,**/*.svelte"
---

# Accessibility rules (WCAG 2.2 AA)

In regulated environments accessibility is often a legal requirement (ADA, Section 508, EN 301 549). Treat violations as bugs.

## Semantics
- Native elements first: `<button>`, `<a href>`, `<input>`, `<select>`, `<dialog>`, `<nav>`, `<main>`, `<header>`, `<footer>`, `<table>` for tabular data. Add ARIA only when no native element fits — and then follow the WAI-ARIA Authoring Practices pattern exactly.
- One `<h1>` per page; headings don't skip levels. Each page has a unique, descriptive `<title>`.
- `<html lang>` is set. Provide a "Skip to main content" link.
- Links navigate; buttons act. Don't use `<a>` without `href` or `<button>` for navigation.

## Keyboard & focus
- Everything operable by mouse is operable by keyboard, in a logical tab order. No positive `tabIndex`.
- Visible focus indicator on every focusable element (`:focus-visible`), ≥ 3:1 contrast, not obscured by sticky headers (WCAG 2.4.11).
- Modals trap focus, close on Escape, and return focus to the trigger. Background gets `inert`.
- After route changes, move focus to the main heading or content. After deleting an item, move focus somewhere sensible.
- Drag-and-drop, swipe and other gestures have a single-pointer/keyboard alternative (WCAG 2.5.7).

## Names, labels, descriptions
- Every form control has a programmatically associated label (`<label htmlFor>` or wrapping). Placeholder is not a label.
- Required fields are indicated in text, not only with color or `*` alone; use `aria-required` or `required`.
- Errors: linked via `aria-describedby`, announced, and focus moves to the first invalid field on submit.
- Icon-only buttons have `aria-label`; decorative SVGs have `aria-hidden="true"`.
- Images: meaningful `alt`, or `alt=""` for decorative. Complex charts get a text summary or data table.

## Dynamic content
- Toasts, async validation, and "saved" messages use `aria-live="polite"` (or `role="status"`); critical errors `role="alert"`.
- Loading regions use `aria-busy` and announce completion when meaningful.
- Don't auto-dismiss messages that contain actions faster than the user can reach them.

## Visual
- Contrast: text ≥ 4.5:1, large text ≥ 3:1, UI boundaries and focus rings ≥ 3:1.
- Target size ≥ 24×24 CSS px (WCAG 2.5.8).
- Content reflows at 320px width and 400% zoom without loss. Never disable zoom (`user-scalable=no`, `maximum-scale=1`).
- Respect `prefers-reduced-motion`; nothing flashes more than 3 times per second.
- Don't rely on color alone for meaning.

## Authentication (WCAG 3.3.8)
- Allow paste and password managers in login and OTP fields. Don't require memorizing or transcribing codes without an alternative.

## Testing
- Add `jest-axe`/`vitest-axe` or `@axe-core/playwright` assertions for new pages and components.
- Query tests by role and accessible name (`getByRole('button', { name: /save/i })`) — this tests accessibility for free.
