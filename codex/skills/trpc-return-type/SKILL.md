---
name: trpc-return-type
description: Design consistent tRPC procedure outputs using success, message, and data envelopes; throw TRPCError for exceptional failures.
---

# tRPC Return Type

## Overview

Return every normal tRPC result in the standard success envelope:

```ts
return {
  success: true,
  message: "Clients loaded successfully",
  data: clients,
}
```

Use `ProcedureResult` only when a procedure has an expected business outcome
that requires an additional caller branch beyond the standard success envelope:

```ts
import type { ProcedureResult } from "@/server/types/procedure-result"

type StartReportResult = ProcedureResult<
  Report,
  {
    code: "subscription_required"
    details?: { upgradeUrl: string }
  }
>
```

## Rules

- Return `{ success: true, message, data }` for every successful query and mutation.
- Use a concise, operation-specific success message; do not put presentation-only copy in the API.
- Use `data: null` when a successful operation has no useful payload.
- Throw `TRPCError` for authentication, authorization, validation, not-found, conflict, and system failures.
- Use `ProcedureResult<TData, TError>` only for expected domain branches where both outcomes are valid responses.
- Keep `TError.code` a literal union so callers must handle known outcomes.
- Keep detailed presentation copy in the UI; the required `message` is a concise operation summary.
- Add an `.output()` schema when runtime validation at the procedure boundary is valuable.

## Patterns

Query:

```ts
return { success: true, message: "Clients loaded successfully", data: clients }
```

Mutation:

```ts
return { success: true, message: "Client created successfully", data: createdClient }
```

Exceptional failure:

```ts
throw new TRPCError({
  code: "NOT_FOUND",
  message: "Client not found",
})
```

Expected business outcome:

```ts
type StartReportResult = ProcedureResult<
  Report,
  { code: "subscription_required" }
>

if (!subscription.active) {
  return {
    ok: false,
    error: { code: "subscription_required" },
  } satisfies StartReportResult
}

return {
  ok: true,
  data: report,
} satisfies StartReportResult
```

## Refactoring Approach

Do not refactor standard success envelopes into `ProcedureResult` merely for
consistency. Introduce it only where the caller needs to branch on a valid
business outcome. Keep database and service failures on tRPC's error path.
