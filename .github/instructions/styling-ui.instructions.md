---
name: Styling & UI consistency
description: Design-token, layout and visual-consistency rules for UI code and stylesheets.
applyTo: "**/*.tsx,**/*.jsx,**/*.css,**/*.scss,**/*.module.css,**/tailwind.config.*"
---

# Styling & UI rules

For choosing a visual direction or building a new screen, load the `frontend-design` skill.

## Use the system, don't invent values
- All colors, spacing, radii, shadows, font sizes and z-indexes come from **design tokens**: CSS custom properties, the Tailwind theme, or the design-system package. No raw hex/rgb, no arbitrary pixel values (`mt-[13px]`, `padding: 13px`) in components.
- If a needed token doesn't exist, add it to the token source — don't hardcode it in one place.
- Use semantic tokens in components (`--color-bg-surface`, `--color-text-muted`, `--color-danger`), not palette tokens (`--gray-200`). This is what makes dark mode and theming work.
- Reuse existing UI primitives (Button, Input, Card, Dialog…). Don't hand-style a one-off button next to the shared one.

## Layout
- Spacing follows a 4px-based scale. Related items sit closer together than unrelated ones.
- Use flex/grid with `gap`; avoid margin hacks and JS measurement for layout.
- Mobile-first and responsive: it must work at 360px wide with no horizontal scroll, and look intentional at 1440px+ (constrain line length for text to ~60–80ch).
- Use logical properties (`margin-inline`, `padding-block`) when the project supports RTL.
- `z-index` values come from a small named scale (dropdown, sticky, modal, toast). No `9999`.

## Typography
- Use the type scale; limit to 2–3 weights. Body text ≥ 16px on mobile. Line-height ~1.5 for body, tighter for headings.
- Use `font-variant-numeric: tabular-nums` for numbers in tables, prices and counters.
- Use `text-wrap: balance` on headings, `text-wrap: pretty` on paragraphs where supported.

## States & interaction
- Every interactive element has distinct **hover, active, focus-visible and disabled** styles. Never remove the focus outline without a visible replacement (`:focus-visible` ring with ≥ 3:1 contrast).
- Hit targets ≥ 24×24px (44×44px preferred on touch).
- Transitions list specific properties (`transition: opacity 150ms, transform 150ms`), never `transition: all`. Animate `transform`/`opacity`, not `width`/`height`/`top`.
- Respect `prefers-reduced-motion`.
- Cursor: `pointer` only on things that act on click.

## Color & contrast
- Text contrast ≥ 4.5:1 (≥ 3:1 for large text and UI component boundaries). Muted/placeholder text must still pass.
- Never convey meaning by color alone — pair it with an icon or text (error states, status badges, charts).
- If the app supports dark mode, every new style must be checked in both themes; set `color-scheme` on `<html>`.

## Avoid
- `!important` (except to override third-party styles, with a comment).
- Inline `style={{…}}` for static styling — only for truly dynamic values.
- Styling by element or deep descendant selectors that leak (`.card div span`).
- Mixing styling approaches in one project (e.g. Tailwind + styled-components + CSS modules) unless the project already does.
