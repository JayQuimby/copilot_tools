---
name: new-feature
description: Plan and build a production-complete full-stack feature (UI + API) following the house standards.
argument-hint: "[describe the feature]"
agent: agent
---

Build this feature: **${input:feature:describe the feature}**

## 1. Understand (no edits yet)
- Find how similar features are built in this codebase: routes, components, data hooks, API handlers, schemas, tests. List the files you'll model yours on.
- Identify reusable pieces (UI primitives, form components, API client, validation schemas, auth helpers). Reuse them.
- Check installed libraries/versions in `package.json`.

## 2. Plan
Write a todo list covering: data model/schema changes → API endpoint(s) → client data hooks → UI screens/components → states → tests → verification. Include the relevant items from the [webapp-completeness](../skills/webapp-completeness/SKILL.md) checklist as explicit todos (loading/empty/error states, validation, permissions, URL state, a11y, responsive).

State assumptions. Ask only if a decision is ambiguous **and** expensive to reverse.

## 3. Build
- Backend per [node-api](../skills/node-api/SKILL.md): schema-validated input, service layer, authorization on the specific resource, DTO responses, typed errors.
- Frontend per [react-patterns](../skills/react-patterns/SKILL.md) and [frontend-design](../skills/frontend-design/SKILL.md): data via the data layer, URL state, existing primitives and tokens only, every state handled.
- Tests: API integration tests (success, 400, 401, 403, 404), component tests with role-based queries, and an axe check on new screens.

## 4. Verify & report
Run the [verify-changes](../skills/verify-changes/SKILL.md) loop. Then report: files changed, verification table, the completeness table (✅ / ⚠️ / N/A per section), and known gaps or follow-ups.
