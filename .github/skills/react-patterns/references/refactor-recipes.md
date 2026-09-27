# React Refactor Recipes

Each recipe: how to spot it, the fix, and a before/after. IDs match the `frontend-audit` checklist.

---

## R1 · Derived state synced with an effect (REACT-03)
**Spot:** `useState` + `useEffect` whose only job is `setX(f(props/state))`. Causes an extra render and stale-value bugs.

```tsx
// ❌ Before
const [fullName, setFullName] = useState('');
useEffect(() => { setFullName(`${first} ${last}`); }, [first, last]);

const [visible, setVisible] = useState<Todo[]>([]);
useEffect(() => { setVisible(todos.filter(t => !t.done)); }, [todos]);

// ✅ After — compute during render
const fullName = `${first} ${last}`;
const visible = todos.filter(t => !t.done); // useMemo only if measured as expensive and no React Compiler
```

## R2 · Resetting state when a prop changes (REACT-03)
```tsx
// ❌ Before
useEffect(() => { setComment(''); }, [userId]);

// ✅ After — let React reset it via key at the call site
<Profile userId={userId} key={userId} />
```

## R3 · Event logic inside an effect (REACT-04)
**Spot:** an effect that watches a flag set by a click, then does the "real" work.
```tsx
// ❌ Before
const [submitted, setSubmitted] = useState(false);
useEffect(() => { if (submitted) { post(form); showToast('Saved'); } }, [submitted]);

// ✅ After — do it in the handler
async function handleSubmit() {
  await post(form);
  showToast('Saved');
}
```

## R4 · Hand-rolled fetching in useEffect (REACT-05, STATE-01)
**Spot:** `useEffect(() => { fetch(...).then(setData) }, [])` with manual `loading`/`error` state. Misses race conditions, caching, retries, dedup, refetch-on-focus, and usually the error state.
```tsx
// ❌ Before
const [data, setData] = useState<User[]>();
const [loading, setLoading] = useState(true);
useEffect(() => {
  fetch('/api/users').then(r => r.json()).then(d => { setData(d); setLoading(false); });
}, []);

// ✅ After — TanStack Query (or the project's data layer)
const usersQuery = useQuery({
  queryKey: ['users', filters],
  queryFn: ({ signal }) => api.users.list(filters, { signal }), // validated with Zod inside
});
if (usersQuery.isPending) return <UsersTableSkeleton />;
if (usersQuery.isError) return <ErrorState error={usersQuery.error} onRetry={usersQuery.refetch} />;
if (usersQuery.data.length === 0) return <EmptyUsers />;
return <UsersTable users={usersQuery.data} />;
```
If a library is genuinely not allowed, at minimum use `AbortController`, ignore stale responses, and model state with a discriminated union.

## R5 · Request waterfall (PERF-01)
```ts
// ❌ Before — each awaits the previous even though they're independent
const user = await getUser(id);
const orders = await getOrders(id);
const prefs = await getPrefs(id);

// ✅ After
const [user, orders, prefs] = await Promise.all([getUser(id), getOrders(id), getPrefs(id)]);
```
In components: avoid parent fetches → render child → child fetches. Hoist both queries to the route level (loader or parallel `useQuery`/`useSuspenseQueries`), or prefetch on hover/route entry.

## R6 · Component defined inside a component (REACT-01)
```tsx
// ❌ Before — Row is a new type every render: remounts, loses focus/state
function Table({ rows }) {
  const Row = ({ r }) => <tr>…</tr>;
  return rows.map(r => <Row key={r.id} r={r} />);
}
// ✅ After — hoist to module scope; pass what it needs as props
function Row({ r }: { r: RowData }) { return <tr>…</tr>; }
```

## R7 · Index or random keys (REACT-02)
Use the entity ID. If items have no ID, create one when the data is created/loaded (not during render).

## R8 · Boolean soup → discriminated union (TS-04)
```tsx
// ❌ Before
const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [data, setData] = useState<Report | null>(null);

// ✅ After
type State =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'error'; message: string }
  | { status: 'success'; report: Report };
const [state, setState] = useState<State>({ status: 'idle' });
```

## R9 · Prop drilling (STATE-04)
Fix in this order: (1) **composition** — pass `children`/slots so intermediate components don't need the prop; (2) move the state closer to where it's used; (3) a focused context for a subtree; (4) a store only for app-wide state.
```tsx
// ✅ Composition removes 3 layers of drilling
<Layout sidebar={<UserMenu user={user} />}>{page}</Layout>
```

## R10 · One giant context (REACT-08)
Split by concern and update frequency (`AuthContext`, `ThemeContext`, `FeatureFlagsContext`). Memoize the value object if not using React Compiler. Separate state and dispatch contexts when many components only dispatch.

## R11 · God component (ARCH-04)
Steps: (1) extract custom hooks for each state/effect cluster (`useInvoiceFilters`, `useInvoiceSelection`); (2) extract named subcomponents for each JSX region (`InvoiceToolbar`, `InvoiceTable`, `InvoiceBulkActions`); (3) the parent becomes a readable composition of them. Keep behavior identical and tests green between steps.

## R12 · `div` with onClick (A11Y-02)
```tsx
// ❌ <div className="card" onClick={open}>…</div>
// ✅ If it navigates:  <Link to={`/invoices/${id}`} className="card">…</Link>
// ✅ If it acts:       <button type="button" className="card" onClick={open}>…</button>
```
For a card with a primary link plus other buttons inside: make the title a link with a `::after` overlay covering the card, and keep inner buttons above it with `position: relative; z-index: 1`.

## R13 · `&&` rendering `0` (REACT-07)
```tsx
// ❌ {items.length && <List items={items} />}
// ✅ {items.length > 0 ? <List items={items} /> : null}
```

## R14 · Uncontrolled ↔ controlled confusion & form boilerplate (FORM-*)
Move to React Hook Form + `zodResolver`, or React 19 `<form action>` + `useActionState`. Share the Zod schema with the server. Map server field errors back with `setError`.

## R15 · Missing error boundary (ERR-01)
Add a route-level boundary (router `errorElement`/`ErrorBoundary`, Next.js `error.tsx`, or `react-error-boundary`) rendering a friendly fallback with Retry and a link home. Report the error to monitoring with PII scrubbed.

## R16 · Stale closure in intervals/listeners
```tsx
// ❌ count is captured once
useEffect(() => { const id = setInterval(() => setCount(count + 1), 1000); return () => clearInterval(id); }, []);
// ✅ functional update
useEffect(() => { const id = setInterval(() => setCount(c => c + 1), 1000); return () => clearInterval(id); }, []);
```
For callbacks that must read the latest props without re-subscribing, use `useEffectEvent`.

## R17 · Slow typing / laggy filters (PERF-07)
```tsx
const [query, setQuery] = useState('');
const deferredQuery = useDeferredValue(query);
const results = useMemo(() => filterBig(list, deferredQuery), [list, deferredQuery]);
```
Or debounce the value that drives network requests (250–400ms).

## R18 · Heavy imports (PERF-03)
```ts
// ❌ import _ from 'lodash';          ✅ import debounce from 'lodash/debounce'; (or write the 5-line helper)
// ❌ import moment from 'moment';     ✅ date-fns / Temporal polyfill / Intl.DateTimeFormat
// ❌ import * as Icons from 'lucide-react';  ✅ import { Search } from 'lucide-react';
```
Lazy-load heavy routes and widgets: `const Chart = lazy(() => import('./Chart'));` inside `<Suspense fallback={<ChartSkeleton />}>`.
