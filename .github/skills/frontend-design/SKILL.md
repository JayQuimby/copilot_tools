---
name: frontend-design
description: Produce professional, consistent, intentional web app UI — choosing a visual direction, defining design tokens (color, type, spacing, radius, elevation), laying out screens, and polishing components so they don't look templated or AI-generated. Use when building a new page, screen, component or app, restyling or "making it look professional", creating a design system or theme, or when the user says the UI looks generic, inconsistent, amateur or unpolished.
argument-hint: "[what to design, and any brand/audience notes]"
---

# Frontend Design for Professional Web Apps

Good app UI is **consistent, calm, legible and specific to its job**. Most "unprofessional" UI comes from inconsistency (ten grays, five radii, random spacing) and from generic defaults nobody chose on purpose. This skill fixes both.

References:
- [Token starter](./references/tokens.css) — a complete semantic token set with light/dark themes
- [App screen patterns](./references/app-patterns.md) — layouts for the screens every business app needs
- [Anti-patterns](./references/anti-patterns.md) — the tells of templated/AI-generated UI and what to do instead

## Step 0 — Respect what exists
If the project already has a design system, tokens, component library or brand guidelines, **use them**. Your job is to apply them consistently, fill gaps with values that fit, and never introduce a parallel system. Read the token source and 3–4 existing screens before designing anything.

## Step 1 — Write a short design brief (before code)
Answer in 5–8 lines and show it to the user:
- **Who uses it, how often, on what device?** (Daily power users on desktop want density and keyboard speed; occasional users on mobile want guidance and large targets.)
- **What is the primary job of this screen?** One sentence. That determines the single primary action.
- **Tone:** e.g. "trustworthy, quiet, precise" for finance/health/compliance; "friendly, spacious" for consumer onboarding.
- **Density:** compact / comfortable / spacious.
- **Constraints:** brand colors, existing library, accessibility level, dark mode, i18n.

## Step 2 — Choose the direction deliberately
Make explicit choices — each a sentence with a reason tied to the brief:
- **Color:** one brand/accent hue used sparingly for primary actions, selection and focus; a neutral ramp (slightly tinted toward the accent hue so it feels cohesive); semantic colors for success/warning/danger/info. Accent covers < 10% of the screen.
- **Typography:** one family for UI (a well-made sans is right for most apps), optionally a second for display or data (monospace for IDs/code). Define a scale (e.g. 12/14/16/18/20/24/30/36) and use ≤ 3–4 weights.
- **Shape:** one radius scale (e.g. 4 / 6 / 8 / 12 px) — smaller for dense tools, larger for friendly consumer apps. Nested radius = outer radius − padding.
- **Depth:** choose *borders* or *shadows* as the primary separator, not both everywhere. Shadows mean elevation (menus, dialogs, popovers), not decoration.
- **Spacing:** 4px base scale. Pick the default gaps for: inside controls, between fields, between sections, page gutters.
- **Motion:** 150–200 ms ease-out for UI feedback; one purposeful transition beats many decorative ones; honor reduced motion.

Encode every choice as tokens (start from [tokens.css](./references/tokens.css)). Components reference **semantic** tokens only.

## Step 3 — Lay out the screen
- Start from the content and the primary task, not from a hero section. Business apps rarely need heroes.
- Use the patterns in [app-patterns.md](./references/app-patterns.md): app shell, page header, list/table, detail, form, settings, empty/error states.
- Establish hierarchy with **size, weight and spacing first**, color second, borders/boxes last. Not everything needs a card.
- Align to a grid; keep a consistent content max-width; left-align text in apps (center only short, standalone messages).
- One primary button per view. Secondary actions are subdued; destructive actions are clearly styled and separated.

## Step 4 — Build with complete states
Every component and screen ships with: default, hover, active, focus-visible, disabled, loading, empty, error, and (if applicable) selected and read-only. Test with short, long and missing content. See the `webapp-completeness` skill.

## Step 5 — Review pass (do this before calling it done)
Go through this list and fix anything that fails:
1. **Squint test:** is the primary action and the main content obvious at a glance?
2. **Consistency:** any hardcoded color/size/spacing? Any value not from tokens? Any component styled differently from its twin elsewhere?
3. **Alignment:** do left edges line up? Are labels, inputs and buttons on the same baseline/grid?
4. **Spacing rhythm:** are related items closer than unrelated ones? Any cramped or floating elements?
5. **Type:** clear hierarchy with ≤ 3–4 sizes on the screen? Line length ≤ ~80ch? Numbers tabular in tables?
6. **Contrast & a11y:** muted text ≥ 4.5:1? Focus visible? Works by keyboard? Targets ≥ 24px?
7. **Responsive:** 360px, 768px, 1280px, 1920px — no overflow, no awkward empty expanses.
8. **Dark mode** (if supported): every surface themed, no pure black on pure white glare, borders visible.
9. **Anti-patterns:** check [anti-patterns.md](./references/anti-patterns.md). Remove anything that is there by default rather than by decision.
10. **Copy:** specific labels ("Save invoice"), consistent terms, helpful empty/error text, no lorem ipsum.

## Implementation notes
- **Tailwind:** map tokens into the theme (`@theme` in Tailwind v4, or `theme.extend` in v3) and use only theme classes; avoid arbitrary values. Use a `cn()` helper (`clsx` + `tailwind-merge`) and variant helpers (`cva`) for component variants.
- **CSS Modules / plain CSS:** tokens as custom properties on `:root` and `[data-theme="dark"]`; components use `var(--…)` only.
- **Accessible primitives:** build dialogs, menus, popovers, comboboxes, tabs and tooltips on Radix UI, React Aria or the project's library — never from scratch.
- **Icons:** one set (e.g. Lucide), consistent size (16/20px) and stroke; import individually.
