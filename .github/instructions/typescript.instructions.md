---
name: TypeScript & JavaScript
description: Type-safety and language rules for all TS/JS source files.
applyTo: "**/*.ts,**/*.tsx,**/*.js,**/*.jsx,**/*.mjs,**/*.cjs"
---

# TypeScript / JavaScript rules

## Type safety
- Assume `"strict": true` plus `noUncheckedIndexedAccess`. Write code that compiles under it.
- **No `any`.** Use `unknown` and narrow. If a third-party type is wrong, write a small typed wrapper — don't spread `any` through the codebase.
- **No escape hatches to silence errors**: `as unknown as X`, `// @ts-ignore`, `// @ts-expect-error` without a linked reason, non-null `!` on values that can really be null. Fix the type instead.
- Validate data crossing a trust boundary (fetch responses, `JSON.parse`, `localStorage`, env vars, URL/search params, form data) with a schema and infer the type from it:

```ts
// ✅ Preferred
const User = z.object({ id: z.string(), email: z.string().email() });
type User = z.infer<typeof User>;
const user = User.parse(await res.json());

// ❌ Avoid — a cast is a lie the compiler can't check
const user = (await res.json()) as User;
```

- Model states with discriminated unions, not bags of optional booleans:

```ts
// ✅
type Load<T> = { status: 'idle' } | { status: 'loading' } | { status: 'error'; error: Error } | { status: 'success'; data: T };
// ❌ { isLoading?: boolean; isError?: boolean; data?: T }  — allows impossible combinations
```

- Use exhaustive `switch` with a `never` check for unions.
- Prefer `type` for unions/utility types, `interface` for extendable object shapes — follow the project if it has picked one.
- Use `satisfies` to check literals without widening (`const routes = {...} satisfies Record<string, Route>`).
- Export types that are part of a module's public contract; keep internal ones private.

## Plain JS / JSX projects
- Add `// @ts-check` or enable `checkJs` and type with JSDoc (`/** @param {User} user */`). React 19 removed `propTypes` checking for function components — use JSDoc/TS instead.

## Language idioms
- `const` by default; `let` only when reassigned; never `var`.
- `async/await` over `.then` chains. Every promise is awaited, returned, or explicitly `void`-ed with a reason. No floating promises.
- Run independent async work in parallel with `Promise.all` / `Promise.allSettled` — sequential `await`s of independent calls are a performance bug.
- Immutable updates: spread, `toSorted()`, `toSpliced()`, `structuredClone()`. Don't mutate function arguments or props.
- Use `Map`/`Set` for lookups in loops instead of `array.find` inside `array.map` (O(n²)).
- Optional chaining and `??` over `||` when `0`/`''` are valid values.
- Throw `Error` objects (or subclasses), never strings. Use `cause` when wrapping: `new Error('Failed to load user', { cause: err })`.
- Named exports over default exports (better refactoring and grep-ability) unless the framework requires default (e.g. Next.js pages).
- Import from the specific module, not a barrel `index.ts`, when the barrel pulls in large dependencies.

## Naming
- Files: follow the project. Otherwise `PascalCase.tsx` for components, `camelCase.ts` for utilities, `kebab-case` for route folders.
- Booleans read as questions: `isOpen`, `hasAccess`, `canEdit`.
- Event handler props `onX`, implementations `handleX`.
- No abbreviations that aren't universal (`btn`, `usr`, `cfg` → spell them out).

## Comments
- Explain **why**, not what. Delete commented-out code.
- A `TODO` must include an owner or ticket reference.
