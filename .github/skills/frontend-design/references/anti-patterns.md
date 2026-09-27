# UI Anti-Patterns

These are the common signs of UI that nobody designed on purpose, usually produced by templates or AI defaults. Any single one can be fine *when chosen for a reason*. The problem is when they appear by default.

## Templated / AI-generated tells
| Tell | Why it reads as generic | Do instead |
|---|---|---|
| Purple→blue or rainbow gradients on buttons, headers, text | The most common default "modern" look | Solid accent color; use gradients only if the brand does |
| Everything in a rounded card with a shadow | Flattens hierarchy; wastes space | Use spacing and headings to group; cards only for discrete, movable/clickable objects |
| Three identical feature cards with emoji or icon-in-a-circle | Marketing template in an app | Show the real content or product UI |
| Emoji as icons (🚀 ✨ 📊) | Inconsistent rendering, unprofessional | One icon set, consistent size/stroke |
| Glassmorphism/blur panels without a background worth blurring | Decorative noise, contrast problems | Opaque surfaces with a clear border or elevation |
| Giant hero with centered headline in a logged-in app | Wastes the most valuable space | Page header + content immediately |
| Center-aligned everything | Hard to scan; no alignment edge | Left-align in apps; center only short standalone messages |
| Pill buttons + square inputs + rounded cards all together | No shape system | One radius scale applied consistently |
| Gray text on colored backgrounds | Fails contrast, looks washed out | Use on-color tokens (`--color-on-accent`) |
| Bold/ALL CAPS labels everywhere; many font weights | Nothing stands out if everything does | 2–3 weights; hierarchy by size and spacing |
| Colored left-border "accent" on every card/alert | A common template flourish | Use status color only for status |
| Decorative numbered steps ("01 / 02 / 03") on non-sequential content | Visual structure that encodes nothing | Only number things that are a sequence |
| Stock "Welcome back, User! 👋" greetings | Filler | Show what needs attention |
| Fake/placeholder data or lorem ipsum left in | Signals unfinished | Real empty states or realistic seed data |

## Consistency failures
- Multiple grays that are almost the same (`#6b7280`, `#6c757d`, `#666`) — collapse into the token ramp.
- Buttons of different heights next to each other; inputs and buttons in the same row with different heights.
- Mixed icon sizes and stroke widths.
- Different spacing inside identical components on different pages.
- Several ways to show the same state (three different empty-state designs, two toast systems).
- Inconsistent capitalization ("Save Changes" vs "Save changes") and terminology ("Client" vs "Customer").

## Hierarchy failures
- Multiple primary (filled accent) buttons on one screen.
- Destructive action styled the same as a safe one, or placed where the primary usually is.
- Page title the same size as section titles.
- Dense walls of bordered boxes — borders on everything instead of whitespace.
- Important numbers in small muted text; labels louder than values.

## Interaction failures
- Hover-only affordances (actions that only appear on hover) with no keyboard/touch path.
- Disabled buttons with no explanation of why.
- Spinners that flash for 50ms; layout that jumps when data loads.
- Clicking a row does nothing, or does something different from row to row.
- Modals opening modals.
- Toasts as the only error feedback for a form.

## Motion failures
- Everything fades/slides in on page load.
- Bouncy/springy easing in a serious business tool.
- Animations longer than ~300ms for routine UI feedback.
- Ignoring `prefers-reduced-motion`.
