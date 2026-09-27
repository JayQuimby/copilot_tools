# App Screen Patterns

Proven layouts for the screens nearly every business web app needs. Use them as the default; deviate when the brief gives a reason.

## App shell
- **Sidebar + header** for apps with > ~5 top-level sections; **top nav only** for ≤ 5.
- Sidebar: 224–256px, collapsible to icons on desktop, becomes a drawer below ~1024px. Active item clearly marked (accent-subtle background + accent text or a leading bar), not just bold.
- Header: product name/logo, global search (⌘K if there is a command palette), notifications, user menu. Height 56–64px.
- Content area: consistent gutters (24px desktop, 16px mobile), `max-width` ~1280px for forms/detail views; tables and dashboards may go full width.
- A skip link to `<main>` as the first focusable element.

## Page header (top of every screen)
```
Breadcrumbs (optional, for depth ≥ 2)
Page title (h1)                          [Secondary]  [Primary action]
Optional one-line description (muted)
Tabs (optional, deep-linked)
```
- Same structure on every page. The primary action lives in the same place everywhere.

## List / table view
- Toolbar: search (debounced, in URL), filters (in URL, removable chips showing active filters), sort, view options, bulk actions appearing when rows are selected.
- Table: sticky header, left-aligned text, **right-aligned numbers** with tabular figures, consistent row height (40–48px comfortable, 32–36px compact), row hover state, truncation with tooltip/full text on detail.
- Row click goes to detail — make the primary cell a real link so it can open in a new tab.
- Pagination or virtualization; show total count ("1–50 of 1,284").
- States: loading skeleton rows (same column widths), empty ("No invoices yet" + create action), no results for filter ("No results for 'acme'" + clear filters), error (message + retry).
- Mobile: horizontal scroll container with the first column sticky, or stacked cards with the 3–4 most important fields.

## Detail view
- Header with entity name, status badge, key metadata, and actions (Edit primary; others in an overflow menu; Delete last and styled as danger).
- Content in clear sections with headings; a definition-list layout (label left/value right on desktop, stacked on mobile) for attributes.
- Related items as sub-tables or tabs. Activity/audit history if relevant (important in regulated contexts).

## Create / edit form
- Single column, labels above inputs, max ~640px wide. Group related fields with section headings; use two columns only for naturally paired short fields (first/last name, city/postcode).
- Required vs optional: mark whichever is the minority ("Optional" label is usually friendlier than asterisks).
- Help text below the label or input, in muted text; errors replace/augment it in danger color with an icon.
- Actions at the bottom (and sticky on long forms): Primary ("Create invoice") and Cancel. Primary on the right in dialogs; follow the project convention for pages.
- On submit: button shows pending, fields stay editable-but-locked, errors focus the first field, success navigates or shows a toast with a link.
- Long forms: section nav or a stepper with saved progress; warn on unsaved changes.

## Dialogs & drawers
- Dialogs for short, focused tasks and confirmations; drawers/side panels for viewing/editing an item while keeping list context.
- Title states the action ("Delete 3 invoices?"); body explains the consequence; buttons are verbs ("Delete invoices" / "Cancel"). Destructive confirm button in danger style.
- Width: 400–560px for confirmations/forms. Scroll the body, keep header and actions visible.

## Dashboard
- Lead with 3–5 KPI tiles (label, value, change vs. period with direction icon + color + text), then charts, then actionable lists ("Needs review").
- Every chart has a title, units, legend only if > 1 series, accessible text summary, and an empty state. Same time range control governs the whole page and is in the URL.
- Don't build a dashboard of vanity charts — each widget should answer a question someone has.

## Settings
- Left sub-nav of sections (or tabs on small screens); each section a form with its own save, or autosave with clear "Saved" status.
- Dangerous settings (delete account/workspace) isolated at the bottom in a clearly bordered danger zone.

## Empty, error & edge screens
- **Empty (first use):** short explanation of what will appear here + primary action to create the first item. An illustration is optional; keep it restrained.
- **No results:** echo the query, offer to clear filters.
- **Error:** plain-language cause, what the user can do (retry, go back, contact support), and a reference ID for support if available. Never a stack trace.
- **403:** say they don't have access and who to ask. **404:** link back to a sensible parent.
- **Loading:** skeletons matching the final layout for content; spinners only for small inline actions. Delay showing them ~150–300ms to avoid flicker.

## Notifications
- Toasts for transient confirmation ("Invoice sent — View"), bottom or top-right, `role="status"`, auto-dismiss 4–6s unless they contain an action or an error.
- Inline banners for persistent page-level conditions (read-only mode, degraded service).
- Errors that block the task stay inline near the cause, not only in a toast.
