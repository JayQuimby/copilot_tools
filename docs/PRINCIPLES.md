# Guiding Principles for Building Web Apps

The human-readable "why" behind everything in `.github/`. The instruction files and skills turn these into rules Copilot follows; this page is for people.

## 1. Consistency beats cleverness
A professional app feels like one person built it. One way to fetch data, one way to build forms, one button component, one set of tokens. When a new approach is better, migrate to it deliberately. Don't add a second way next to the first.

## 2. Design is a system, not a coat of paint
Colors, spacing, type, radius, elevation and motion are decided once, as tokens, and every screen uses them. Most "unprofessional" UI is really *inconsistent* UI. Hierarchy comes from size, weight and spacing before color and boxes. One primary action per screen.

## 3. A feature isn't done until the unhappy paths are
Loading, empty, error, forbidden, not found, slow network, long text, 1,000 rows, keyboard-only, 360px wide, dark mode. The happy path is maybe 40% of the work. The [completeness checklist](../.github/skills/webapp-completeness/SKILL.md) is the definition of done.

## 4. Types are the contract, schemas are the border guard
Strict TypeScript inside, runtime validation at every boundary: API input, API responses, storage, URL params, env vars. Types are inferred from schemas, so there is one source of truth.

## 5. Derive, don't duplicate
State that can be computed isn't state. Server data lives in the data layer, shareable view state lives in the URL, and only what's left goes in component state.

## 6. Accessible by default
Semantic HTML, keyboard operability, visible focus, labels, contrast. It's cheaper to build in than to bolt on, and in regulated industries it's often a legal requirement.

## 7. Secure by default
Authorization on the server, for every request, for the specific resource. Validate input, encode output, keep secrets out of code and bundles, keep PII out of logs. Treat new third-party services as decisions that need approval.

## 8. Performance is a feature
Kill waterfalls, split bundles, size images, virtualize long lists, keep interactions under 200ms. Measure before micro-optimizing.

## 9. Prove it works
Typecheck, lint, test, build. "It should work" is not a status. Every bug fix gets a test that fails without it.

## 10. Leave it better, in separate commits
When you find poor code, record it. Fix it in a scoped change with tests, not tangled into an unrelated feature. Audits give that work a list, IDs and a priority order.

---

## Default stack for new projects
Use these defaults when a project hasn't already chosen:

| Concern | Default |
|---|---|
| Runtime | Node.js current Active LTS, ESM |
| Frontend | React 19 + TypeScript (strict), Vite. Use Next.js App Router when you need SSR/SEO |
| Styling | Tailwind CSS v4 with semantic tokens, or CSS Modules + CSS variables |
| Primitives | Radix UI / shadcn/ui, or React Aria |
| Server state | TanStack Query |
| Client state | Local state, then Context, then Zustand (only if needed) |
| Forms | React Hook Form + Zod, or React 19 actions |
| Validation | Zod, shared between client and server |
| Routing | React Router (data mode) or TanStack Router, or Next.js |
| Backend | Express 5 or Fastify, layered route → service → data |
| Logging | pino (structured, redacted) |
| Testing | Vitest + Testing Library + MSW; Playwright + axe for e2e |
| Lint/format | ESLint flat config (typescript-eslint, react-hooks, jsx-a11y) + Prettier |
| Icons | Lucide |
| Dates | `Intl` + date-fns |
