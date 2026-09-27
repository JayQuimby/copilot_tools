# Smell Search Patterns

Fast searches that surface likely problems. **Every hit is a lead — open the file and confirm before reporting.** Adjust `src/` to the project's source root. Use VS Code search (regex mode) or run with `grep -rnE` / `rg` in the terminal.

Tip: count first, then inspect: `rg -c 'pattern' src | sort -t: -k2 -n -r | head`

## Type safety (TS-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `:\s*any\b\|as any\|<any>` | Type safety disabled | TS-02 |
| `as unknown as` | Double cast hides a real type mismatch | TS-02 |
| `@ts-ignore\|@ts-nocheck` | Suppressed compiler errors | TS-02 |
| `@ts-expect-error` (without a reason after it) | Unexplained suppression | TS-02 |
| `\.json\(\)\) as \|await res\.json\(\) as` | Unvalidated API data | TS-03 |
| `JSON\.parse\(` | Check it's validated and wrapped in try/catch | TS-03, STATE-06 |
| `eslint-disable` | Look for disabled `react-hooks/exhaustive-deps`, `jsx-a11y/*` | TS-05, REACT-04 |
| `catch\s*\(\w*\)\s*\{\s*\}` or `catch \{\s*\}` | Swallowed errors | TS-06 |
| `console\.(log\|debug)` | Debug leftovers | TS-07 |
| `TODO\|FIXME\|HACK\|XXX` | Unfinished work | TS-07 |

## React (REACT-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `key=\{(index\|i\|idx)\}` | Index keys on possibly dynamic lists | REACT-02 |
| `key=\{(Math\.random\|crypto\.randomUUID\|uuid)` | Remounts every render | REACT-02 |
| `useEffect\(` | Review each: derived state? event logic? fetch without abort? | REACT-03/04/05 |
| `useEffect\([^)]*\{\s*set[A-Z]` | Effect that only sets state — usually derived state | REACT-03 |
| `useEffect\(.*fetch\(\|useEffect\(async` | Hand-rolled fetching / async effect | REACT-05 |
| `\.push\(\|\.splice\(\|\.sort\(\)` near state variables | Mutation of state | REACT-06 |
| `\{\s*\w+\.length\s*&&` | Renders `0` when empty | REACT-07 |
| `^\s{4,}(const\|function) [A-Z]\w*\s*(=\s*\(\|\()` | Indented PascalCase function — possibly a component defined inside a component | REACT-01 |
| `createContext\(` | Check value memoization and size of context | REACT-08 |
| `document\.(getElementById\|querySelector)` in components | Direct DOM manipulation | REACT-10 |
| `forwardRef` | Fine in older code; unnecessary in new React 19 code | REACT-11 |
| `ErrorBoundary\|errorElement\|error\.tsx` (absence) | Missing error boundaries | REACT-09, ERR-01 |

## Accessibility (A11Y-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `<(div\|span\|li\|td)[^>]*onClick` | Non-semantic interactive element | A11Y-02 |
| `<img(?![^>]*\balt=)` | Image without alt | A11Y-07 |
| `<button[^>]*>\s*<(svg\|Icon\|[A-Z]\w*Icon)` | Possibly icon-only button — check for `aria-label` | A11Y-07 |
| `outline:\s*(none\|0)\|outline-none` | Focus indicator removed | A11Y-04 |
| `tabIndex=\{?["']?[1-9]` | Positive tabindex | A11Y-03 |
| `user-scalable=no\|maximum-scale=1` | Zoom disabled | A11Y-11 |
| `placeholder=` on inputs without a nearby `<label` / `aria-label` | Placeholder used as label | A11Y-06 |
| `<a(?![^>]*href)` | Anchor without href | A11Y-02 |
| `role="button"` | Usually should be a real `<button>` | A11Y-02 |
| `autoFocus` | Check it's appropriate (not on mobile, not in the middle of a page) | A11Y-03 |

## Styling & visual consistency (VIS-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `#[0-9a-fA-F]{3,8}\b` in `.tsx/.jsx/.module.css` (outside the token file) | Hardcoded colors | VIS-01/02 |
| `rgba?\(\|hsla?\(` outside token files | Hardcoded colors | VIS-01 |
| `\[\d+px\]\|-\[#` (Tailwind arbitrary values) | Off-scale values | VIS-01/04 |
| `style=\{\{` | Inline styles — static ones should be classes/tokens | VIS-01 |
| `!important` | Specificity fights | VIS-01 |
| `z-index:\s*\d{3,}\|z-\[\d+\]\|zIndex:\s*\d{3,}` | Unmanaged z-index | VIS-01 |
| `transition:\s*all\|transition-all` | Janky, expensive transitions | PERF-08 |
| `border-radius:\s*\d+px\|rounded-\[` | Count distinct radius values | VIS-05 |
| `font-size:\s*\d+px\|text-\[\d+px\]` | Off-scale typography | VIS-03 |
| `font-family:` outside the root/tokens | Stray font families | VIS-03 |
| Emoji characters in JSX (`[\u{1F300}-\u{1FAFF}]`) | Emoji used as icons | VIS-11 |

To measure consistency: `rg -o '#[0-9a-fA-F]{6}' src | cut -d: -f2 | sort | uniq -c | sort -rn` — many unique colors = no system.

## Performance (PERF-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `import \w+ from ['"]lodash['"]\|from ['"]moment['"]` | Heavy/whole-library imports | PERF-03 |
| `import \* as \w+ from ['"](lucide-react\|react-icons\|@mui/icons-material)` | Whole icon set imported | PERF-03 |
| `from ['"]\.\.?/.*index['"]\|from ['"]@/components['"]` | Barrel imports (check what they pull in) | PERF-03, ARCH-05 |
| `React\.lazy\|lazy\(\|import\(` (absence in router) | No code splitting | PERF-02 |
| `<img(?![^>]*(width\|height))` | Missing dimensions → CLS | PERF-04 |
| `\.map\([^)]*\)\.filter\(\|\.filter\([^)]*\)\.map\(` in hot paths | Multiple passes (minor) | PERF-07 |
| `\.find\(` inside `.map(` | O(n²) lookup — use a Map | PERF-07 |
| `await .*\n\s*const .* = await` (sequential independent awaits) | Waterfall | PERF-01 |
| `setInterval\(` | Check cleanup and necessity | REACT-04 |

## Security (SEC-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `dangerouslySetInnerHTML\|innerHTML\s*=` | XSS risk — must be sanitized | SEC-02 |
| `(api[_-]?key\|secret\|token\|password)\s*[:=]\s*['"][^'"]+['"]` | Hardcoded secret | SEC-01 |
| `(VITE\|NEXT_PUBLIC\|REACT_APP)_\w*(SECRET\|KEY\|TOKEN\|PASSWORD)` | Secret exposed to the client | SEC-01 |
| `localStorage\.setItem\(.*(token\|jwt\|auth)` | Token in localStorage | SEC-03 |
| `eval\(\|new Function\(` | Code injection | SEC-02 |
| `href=\{` with user data | Check for `javascript:` URL validation | SEC-02 |
| `target="_blank"` | Confirm `rel="noopener noreferrer"` for external links | SEC-02 |
| `console\.(log\|error)\(.*(user\|email\|token\|password)` | PII/secrets in logs | SEC-05 |

## Forms (FORM-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `<input(?![^>]*\b(type\|autoComplete)=)` | Missing type/autocomplete | FORM-04 |
| `disabled=\{!?(isValid\|!isDirty)` | Pre-disabled submit | FORM-05 |
| `onPaste=.*preventDefault` | Blocked paste | FORM-04 |
| `window\.(alert\|confirm\|prompt)` | Native dialogs — unstyled, blocking | UX-04 |

## Copy (COPY-*)
| Search (regex) | Why it matters | Check ID |
|---|---|---|
| `lorem\|ipsum\|placeholder text\|coming soon` (case-insensitive) | Unfinished content | COPY-05 |
| `>\s*(Submit\|OK\|Click here)\s*<` | Vague button labels | COPY-02 |
| `toLocaleDateString\(\)\|new Date\(.*\)\.toString\(\)\|\.toFixed\(2\)` | Ad-hoc formatting instead of `Intl` | COPY-04 |
| `\.\.\.['"<]` | Three dots instead of `…` | COPY-01 |

## Structure (ARCH-*)
- Largest files: `find src -name '*.[jt]sx' -exec wc -l {} + | sort -n | tail -20`
- Duplicate component names: `find src -name '*.tsx' -exec basename {} \; | sort | uniq -d`
- Button-like components: `rg -l 'function \w*(Button|Btn)\b' src`
- Unused exports (if available): `npx knip` or `npx ts-prune`
