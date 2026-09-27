---
name: Testing
description: Rules for unit, component, integration and end-to-end tests.
applyTo: "**/*.test.ts,**/*.test.tsx,**/*.test.js,**/*.test.jsx,**/*.spec.ts,**/*.spec.tsx,**/*.spec.js,**/e2e/**,**/tests/**,**/__tests__/**"
---

# Testing rules

## What to test
- Test **behavior users and callers can observe**, not implementation details. Don't assert on internal state, private functions or CSS class names.
- Every bug fix gets a test that fails before the fix.
- Cover the unhappy paths: validation errors, network failure, empty results, unauthorized, slow responses.
- Priority: critical user flows (e2e) > component behavior (integration) > pure logic (unit). Don't chase coverage numbers with trivial tests.

## Component tests (Testing Library)
- Query in this order: `getByRole` (with `name`) → `getByLabelText` → `getByText` → `getByTestId` as a last resort.
- Use `userEvent` (awaited), not `fireEvent`, for interactions.
- Use `findBy*` / `waitFor` for async UI; never arbitrary `setTimeout` sleeps.
- Mock the network at the HTTP boundary with MSW, not by mocking your own fetch wrapper or hooks.
- Add an axe check for new components/pages: `expect(await axe(container)).toHaveNoViolations()`.

## E2E (Playwright)
- Use role-based locators and web-first assertions (`await expect(locator).toBeVisible()`).
- Each test is independent: sets up its own data, no ordering dependencies.
- Cover: happy path, validation error, server error and permission-denied for each critical flow.

## Hygiene
- Arrange / Act / Assert structure; one behavior per test; descriptive names (`it('shows an error when the email is already taken')`).
- No `.only` or `.skip` committed. No snapshot tests for large component trees — they get rubber-stamped.
- Tests must be deterministic: control time (`vi.useFakeTimers`), randomness and IDs.
- Backend: test services with real validation and a real (test) database or a container where practical; mock only external third-party services.
