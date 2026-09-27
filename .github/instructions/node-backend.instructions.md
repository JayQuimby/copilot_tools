---
name: Node.js backend
description: Rules for Node.js server code — APIs, services, data access, config.
applyTo: "**/server/**,**/api/**,**/routes/**,**/controllers/**,**/services/**,**/middleware/**,**/db/**,**/*.server.ts,**/app/api/**"
---

# Node.js backend rules

For API design, error-handling patterns and a review checklist, load the `node-api` skill.

## Structure
- Layered: **route/controller** (HTTP only: parse, validate, call service, map response) → **service** (business logic, no `req`/`res`) → **data access** (queries). Business logic never lives in route handlers.
- Configuration comes from environment variables, **validated once at startup** with a schema; the process fails fast if config is invalid. Never read `process.env` scattered through the code.
- Use ESM, the current Node Active LTS, and native APIs (`fetch`, `AbortController`, `node:test`, `structuredClone`) before adding packages. Import built-ins with the `node:` prefix.

## Input & output
- Validate **every** input (body, params, query, headers) with a schema at the edge. Reject unknown fields for write operations.
- Never return raw DB rows or internal objects — map to explicit response DTOs so you don't leak columns (password hashes, internal IDs, PII).
- Consistent error response shape across the API, e.g. RFC 9457 Problem Details: `{ type, title, status, detail, instance }`. Never send stack traces to clients.
- Correct status codes: 400 validation, 401 unauthenticated, 403 unauthorized, 404 not found, 409 conflict, 422 semantic errors, 429 rate-limited, 5xx only for server faults.
- Paginate every list endpoint. Put a hard upper bound on page size.

## Errors
- Use typed error classes (`NotFoundError`, `ValidationError`…) mapped to responses in **one** central error handler.
- Never swallow errors. Log once, at the boundary, with context.
- Handle `unhandledRejection` / `uncaughtException` by logging and exiting; let the process manager restart. Implement graceful shutdown on `SIGTERM` (stop accepting connections, drain, close DB pools).

## Security
- AuthN and **authZ on every endpoint** — check the caller may access *this specific resource* (prevents IDOR), not only that they're logged in.
- Parameterized queries / ORM query builders only. Never interpolate user input into SQL, shell commands, file paths or regexes.
- Secrets come from a secret manager or env; never commit them or log them.
- Set security headers (Helmet or equivalent), strict CORS allow-list (no `*` with credentials), rate limiting on auth and expensive endpoints, request body size limits.
- Cookies for sessions: `HttpOnly`, `Secure`, `SameSite=Lax` or `Strict`. Don't put tokens in `localStorage`.
- Hash passwords with argon2id or bcrypt. Use `crypto.randomUUID()` / `crypto.randomBytes` for tokens, never `Math.random()`.

## Logging & observability
- Structured JSON logs (pino or the project's logger) with a request/correlation ID. No `console.log` in server code.
- **Never log** passwords, tokens, session IDs, full request bodies, or PII. Redact by default.
- Audit-log security-relevant actions (login, permission changes, data export, deletes) with who/what/when.
- Expose health (`/healthz`) and readiness endpoints.

## Performance
- Don't block the event loop: no sync FS/crypto in request paths, move CPU-heavy work to worker threads or a queue.
- Parallelize independent I/O with `Promise.all`. Avoid N+1 queries — batch or join.
- Set timeouts on every outbound HTTP call and DB query.
- Use connection pooling; reuse clients instead of creating one per request.
