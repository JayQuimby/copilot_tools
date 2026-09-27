---
name: node-api
description: Design, build, review and harden Node.js + TypeScript backend APIs (Express 5, Fastify, Next.js route handlers, NestJS) — layering, validation, error handling, auth/authorization, security headers, logging, database access, pagination, performance and graceful shutdown. Use when creating or modifying endpoints, services or data access, when reviewing or auditing backend code, or when an API is slow, insecure or inconsistent.
argument-hint: "[endpoint, service or directory]"
---

# Node.js API

References:
- [Backend review checklist](./references/backend-checklist.md) — IDs for auditing existing backend code
- [Patterns](./references/patterns.md) — code shapes for config, validation, errors, handlers, logging, shutdown

## When building an endpoint
1. **Contract first.** Define request and response schemas (Zod or the project's validator). Infer TS types from them. If the project has OpenAPI, update it (or generate it from the schemas).
2. **Route layer:** parse + validate input → call service → map result to response DTO → status code. Nothing else.
3. **Service layer:** business rules and authorization decisions. Pure where possible; receives typed inputs and the authenticated principal, not `req`.
4. **Data layer:** parameterized queries/ORM; returns domain objects; no HTTP concepts.
5. **Errors:** throw typed domain errors; the central error handler maps them to Problem Details responses.
6. **AuthZ:** verify the caller can act on *this* resource (ownership/tenant/role). Test the forbidden case.
7. **Tests:** happy path, validation failure, unauthorized (401), forbidden (403), not found (404), and conflict where relevant.
8. **Verify:** typecheck, lint, tests; exercise the endpoint (`curl`/REST client) and confirm status codes and response shape.

## When reviewing existing backend code
Work through [backend-checklist.md](./references/backend-checklist.md) and report findings in the same format as the `frontend-audit` report (ID, severity, effort, file:line, evidence, impact, fix). Search leads:

| Search | Concern |
|---|---|
| `` `SELECT .*\$\{ `` / `query\(.*\+` | SQL injection via interpolation |
| `exec\(\|execSync\(\|spawn\(.*shell: true` | Command injection |
| `process\.env\.` outside the config module | Unvalidated, scattered config |
| `res\.(json\|send)\((user\|row\|result\|doc)\)` | Leaking raw DB objects |
| `console\.(log\|error)` | Unstructured logging, possible PII |
| `catch\s*\(\w*\)\s*\{\s*\}` | Swallowed errors |
| `cors\(\)\|origin:\s*['"]\*` | Open CORS |
| `jwt\.decode\(` | Token decoded without verification |
| `Math\.random\(` | Insecure randomness for IDs/tokens |
| `readFileSync\|writeFileSync\|pbkdf2Sync\|scryptSync` in handlers | Event-loop blocking |
| `for .* of .*\) \{[^}]*await .*(find\|query\|get)` | N+1 queries |
| `fetch\(` without `signal`/timeout | Hanging outbound calls |
