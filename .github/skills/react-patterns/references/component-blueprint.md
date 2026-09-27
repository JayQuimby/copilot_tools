# Component Blueprint

Default shapes to start from. Adapt to the project's conventions (styling approach, folder layout, data library).

## Presentational primitive
```tsx
import { cn } from '@/lib/cn';

type BadgeProps = React.ComponentProps<'span'> & {
  tone?: 'neutral' | 'success' | 'warning' | 'danger' | 'info';
};

export function Badge({ tone = 'neutral', className, ...props }: BadgeProps) {
  return <span data-tone={tone} className={cn('badge', className)} {...props} />;
}
```
- Extends native props; forwards `className`, `ref` (React 19: just a prop) and rest.
- Variants are a typed union, never free-form strings.
- No data fetching, no global state.

## Data-driven view (feature component)
```tsx
export function InvoicesPage() {
  const [params, setParams] = useInvoiceSearchParams(); // filters in the URL
  const invoices = useInvoices(params);                 // data layer hook

  return (
    <Page>
      <PageHeader title="Invoices" actions={<CreateInvoiceButton />} />
      <InvoiceFilters value={params} onChange={setParams} />
      {invoices.isPending ? (
        <InvoiceTableSkeleton />
      ) : invoices.isError ? (
        <ErrorState error={invoices.error} onRetry={() => invoices.refetch()} />
      ) : invoices.data.items.length === 0 ? (
        params.hasFilters ? <NoResults onClear={() => setParams({})} /> : <EmptyInvoices />
      ) : (
        <InvoiceTable data={invoices.data} />
      )}
    </Page>
  );
}
```
Every data view explicitly renders **loading, error, empty-first-use, empty-no-results, success**.

## Data hook
```ts
const InvoiceList = z.object({ items: z.array(Invoice), total: z.number() });

export function useInvoices(params: InvoiceParams) {
  return useQuery({
    queryKey: ['invoices', params],
    queryFn: async ({ signal }) => InvoiceList.parse(await api.get('/invoices', { params, signal })),
    placeholderData: keepPreviousData, // no flash when paging/filtering
  });
}
```

## Mutation with feedback
```ts
export function useDeleteInvoice() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => api.delete(`/invoices/${id}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['invoices'] });
      toast.success('Invoice deleted');
    },
    onError: (err) => toast.error(toUserMessage(err)),
  });
}
```

## Custom hook conventions
- Name `useX`; returns an object (not a tuple) when it returns more than two things.
- Owns one concern. Accepts plain params, returns stable, typed results.
- Cleans up everything it subscribes to.

## Folder layout (feature-based, when the project has none)
```
src/
  app/            # routing, providers, app shell
  components/ui/  # shared primitives (Button, Input, Dialog, Table…)
  features/
    invoices/
      api.ts          # data hooks + schemas
      components/     # feature components
      routes/         # route components
      invoices.test.tsx
  lib/            # framework-agnostic utilities (cn, formatters, api client)
  styles/         # tokens.css, globals
```
