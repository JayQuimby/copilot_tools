# Backend Review Checklist

Score each category 0–5 as in the frontend audit.

## API — Design & contracts
- **API-01** Resource-oriented, consistent URL naming (plural nouns, kebab-case), correct HTTP methods and idempotency (PUT/DELETE idempotent; POST supports an `Idempotency-Key` where retries could duplicate).
- **API-02** Request and response schemas defined and validated; unknown fields rejected on writes.
- **API-03** Consistent error format (RFC 9457 Problem Details or one documented shape) and correct status codes.
- **API-04** List endpoints paginated (cursor preferred for large/changing sets) with max page size; filtering/sorting whitelisted.
- **API-05** Versioning strategy exists for breaking changes; OpenAPI (or equivalent) is up to date.
- **API-06** Response DTOs expose only needed fields; no internal IDs/columns/PII leaked.

## ARCH — Structure
- **BARCH-01** Route → service → data layering; no business logic in handlers, no HTTP objects in services.
- **BARCH-02** Config centralized and validated at startup; fails fast.
- **BARCH-03** Dependencies injected/passed (DB, clients) so services are testable.
- **BARCH-04** No circular module dependencies; shared types/schemas in one place.

## SEC — Security (OWASP API Top 10 oriented)
- **BSEC-01** Authentication on all non-public routes; tokens verified (signature, expiry, audience, issuer).
- **BSEC-02** Object-level authorization on every resource access (no IDOR); function-level authorization for admin actions.
- **BSEC-03** Injection-safe: parameterized queries, no shell/eval with input, path traversal prevented.
- **BSEC-04** Security headers (Helmet), strict CORS allow-list, CSRF protection for cookie sessions.
- **BSEC-05** Rate limiting and body-size limits, especially on auth, search and upload endpoints.
- **BSEC-06** Secrets from env/secret manager; none in repo, logs or error responses.
- **BSEC-07** Password hashing with argon2id/bcrypt; secure random tokens; session cookies `HttpOnly; Secure; SameSite`.
- **BSEC-08** Mass assignment prevented (explicit field picking on create/update).
- **BSEC-09** File uploads: type/size validated, stored outside web root, names not trusted, scanned if required.
- **BSEC-10** `npm audit` clean for production deps; dependencies maintained.

## ERR — Errors & resilience
- **BERR-01** Central error handler; typed domain errors; no stack traces to clients.
- **BERR-02** No swallowed errors; errors logged once with context.
- **BERR-03** Timeouts on all outbound calls and DB queries; retries with backoff only for idempotent operations.
- **BERR-04** Graceful shutdown on SIGTERM; unhandled rejections logged and process exits.
- **BERR-05** Transactions used where multiple writes must succeed together.

## DATA — Data access
- **DATA-01** No N+1 queries; indexes exist for frequent filters/sorts/joins.
- **DATA-02** Connection pooling configured; clients reused.
- **DATA-03** Migrations versioned and reversible; no schema changes at runtime.
- **DATA-04** Soft-delete/retention rules applied consistently where regulations require.

## OBS — Observability
- **OBS-01** Structured logs with request/correlation IDs; levels used sensibly.
- **OBS-02** PII, secrets and tokens redacted from logs.
- **OBS-03** Audit log for security-relevant events (auth, permission changes, exports, deletes).
- **OBS-04** Health/readiness endpoints; metrics/tracing if the platform supports them.

## PERF — Performance
- **BPERF-01** Event loop not blocked (no sync I/O or heavy CPU in request path).
- **BPERF-02** Independent I/O parallelized; response payloads bounded.
- **BPERF-03** Caching where appropriate with correct invalidation; HTTP caching headers for cacheable GETs.
- **BPERF-04** Compression enabled (or handled by the proxy).

## TEST — Testing
- **BTEST-01** Integration tests cover each endpoint's success, validation, 401, 403, 404 paths.
- **BTEST-02** Services unit-tested for business rules.
- **BTEST-03** Tests use an isolated test DB/container; no reliance on shared state.
