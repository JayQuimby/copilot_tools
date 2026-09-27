# Backend Patterns

Express 5 flavored; the same shapes apply to Fastify (use its schema hooks) and Next.js route handlers.

## Validated config (fail fast)
```ts
// src/config.ts
import { z } from 'zod';

const Env = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']),
  PORT: z.coerce.number().int().default(3000),
  DATABASE_URL: z.string().url(),
  SESSION_SECRET: z.string().min(32),
  CORS_ORIGINS: z.string().transform((s) => s.split(',').map((o) => o.trim())),
});

export const config = Env.parse(process.env); // throws at startup with a clear message
```

## Typed errors + Problem Details handler
```ts
export class AppError extends Error {
  constructor(public status: number, public title: string, message?: string, options?: ErrorOptions) {
    super(message ?? title, options);
  }
}
export class NotFoundError extends AppError { constructor(what: string) { super(404, 'Not Found', `${what} was not found`); } }
export class ForbiddenError extends AppError { constructor() { super(403, 'Forbidden', 'You do not have access to this resource'); } }

// Registered last
export const errorHandler: ErrorRequestHandler = (err, req, res, _next) => {
  if (err instanceof z.ZodError) {
    return res.status(400).type('application/problem+json').json({
      type: 'about:blank', title: 'Validation failed', status: 400,
      errors: err.issues.map((i) => ({ path: i.path.join('.'), message: i.message })),
    });
  }
  if (err instanceof AppError) {
    return res.status(err.status).type('application/problem+json').json({ type: 'about:blank', title: err.title, status: err.status, detail: err.message });
  }
  req.log.error({ err }, 'Unhandled error');
  res.status(500).type('application/problem+json').json({ type: 'about:blank', title: 'Internal Server Error', status: 500, instance: req.id });
};
```

## Thin handler → service
```ts
const Params = z.object({ id: z.string().uuid() });
const UpdateInvoice = z.object({ dueDate: z.coerce.date(), notes: z.string().max(2000).optional() }).strict();

router.patch('/invoices/:id', requireAuth, async (req, res) => {
  const { id } = Params.parse(req.params);
  const input = UpdateInvoice.parse(req.body);
  const invoice = await invoiceService.update(req.user, id, input);
  res.json(toInvoiceDto(invoice));
}); // Express 5 forwards rejected promises to the error handler automatically

// service
export async function update(user: Principal, id: string, input: UpdateInvoiceInput) {
  const invoice = await invoiceRepo.findById(id);
  if (!invoice) throw new NotFoundError('Invoice');
  if (invoice.tenantId !== user.tenantId || !user.can('invoice:update')) throw new ForbiddenError();
  return invoiceRepo.update(id, input);
}
```

## Explicit response DTO
```ts
export const toInvoiceDto = (i: Invoice) => ({
  id: i.id, number: i.number, status: i.status, total: i.totalCents, currency: i.currency, dueDate: i.dueDate.toISOString(),
}); // never res.json(row)
```

## Structured logging with redaction
```ts
import pino from 'pino';
export const logger = pino({
  level: config.NODE_ENV === 'production' ? 'info' : 'debug',
  redact: { paths: ['req.headers.authorization', 'req.headers.cookie', '*.password', '*.token', '*.ssn', '*.email'], censor: '[REDACTED]' },
});
// pino-http with genReqId → correlation ID on every log line
```

## Security middleware
```ts
app.use(helmet());
app.use(cors({ origin: config.CORS_ORIGINS, credentials: true }));
app.use(express.json({ limit: '100kb' }));
app.use('/auth', rateLimit({ windowMs: 15 * 60_000, limit: 20 }));
```

## Outbound calls with timeout
```ts
const res = await fetch(url, { signal: AbortSignal.timeout(5_000) });
if (!res.ok) throw new AppError(502, 'Bad Gateway', `Upstream responded ${res.status}`);
const data = UpstreamSchema.parse(await res.json());
```

## Graceful shutdown
```ts
const server = app.listen(config.PORT);
const shutdown = async (signal: string) => {
  logger.info({ signal }, 'Shutting down');
  server.close(async () => { await db.end(); process.exit(0); });
  setTimeout(() => process.exit(1), 10_000).unref();
};
process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);
process.on('unhandledRejection', (err) => { logger.fatal({ err }, 'Unhandled rejection'); process.exit(1); });
```

## Cursor pagination
```ts
const Query = z.object({ cursor: z.string().optional(), limit: z.coerce.number().int().min(1).max(100).default(25) });
// return { items, nextCursor } — nextCursor = last item's sort key (opaque, base64)
```
