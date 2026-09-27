---
name: Security baseline
description: Security rules that apply to every file, frontend and backend.
applyTo: "**"
---

# Security baseline

- **Secrets**: never hardcode keys, tokens, passwords or connection strings — including in tests, examples and comments. Anything in the frontend bundle (`VITE_*`, `NEXT_PUBLIC_*`, `REACT_APP_*`) is public; never put secrets there.
- **Injection**: parameterize queries; never build SQL, shell commands, HTML, file paths or regexes from user input by string concatenation.
- **XSS**: rely on React's escaping. `dangerouslySetInnerHTML` only with content sanitized by DOMPurify (or equivalent) and a comment explaining why. Validate URLs before using them in `href`/`src` (block `javascript:`).
- **AuthZ**: authorization is enforced on the server for every request. Hiding a button in the UI is not access control.
- **Data exposure**: return only the fields the client needs. Don't log PII, credentials or tokens. Don't store tokens or sensitive data in `localStorage`/`sessionStorage`.
- **Dependencies**: prefer established, maintained packages. Flag any new dependency in your summary with why it's needed. Pin via lockfile; run `npm audit` when adding packages.
- **Third parties**: don't add analytics, CDNs, fonts from external hosts, or outbound calls without calling it out — in regulated environments these may need approval.
- **Errors**: never expose stack traces, SQL errors or internal paths to users.
- If you notice an existing vulnerability while working, report it in your summary even if it's out of scope.
