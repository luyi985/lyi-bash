# Enum integration

## Purpose

JSON Schema validates serialized enum values. Generated declarations normally expose literal unions. Domain code may expose TypeScript `enum` values for runtime access such as `Status.Active`.

The preferred safe target for ordinary schema-backed string enums is an exported const object plus a same-name type alias so runtime access is preserved while the type is exactly comparable with the generated union.

Do not change JSON Schema enums into object schemas. Keep runtime validation as primitive `enum` values.

## Enum-only execution mode

When the task is specifically to migrate enums, scan the entire repository source tree and inventory every enum or enum-like declaration, including ones outside Domain/DTO roots. Do not perform general Schema scaffolding, Request Schema work, class migration, or unrelated refactoring.

Discover roots from `tsconfig.json`, source imports, barrel exports, package exports, and active `src/**/domain/**`, `src/**/domains/**`, `src/**/dto/**`, and `src/**/dtos/**` trees.

For each exported declaration, locate:

- the Domain source symbol;
- corresponding Common/Data Schema when schema-backed;
- generated TypeScript root type;
- re-exports and aliases;
- downstream imports and runtime uses;
- SDK/package exports;
- `Object.keys`, `Object.values`, `Object.entries`, indexed lookup, reflection, switch statements, map/record keys, serializers, tests, and persisted/Kafka wire values.

Classify every enum as exactly one of:

- `SAFE_TO_MIGRATE`
- `RETAIN_WITH_ASSERTION`
- `BLOCKED`
- `NOT_SCHEMA_BACKED`

Do not silently skip any repository enum. Every discovered enum must have an owner/classification/action record. Apply every `SAFE_TO_MIGRATE` migration; do not stop after producing an audit report.

## SAFE_TO_MIGRATE gate

An enum may be automatically converted only when all of the following are true:

- it is a normal string enum;
- every member has a static string-literal value;
- it is not `const`, numeric, heterogeneous, ambient, declared, or computed;
- it has no namespace or declaration merging;
- no code depends on numeric reverse mapping;
- existing runtime member access such as `Status.Active` is preserved;
- the same exported runtime symbol and same exported type name remain available;
- package/barrel exports remain compatible;
- no downstream consumer relies on enum-specific runtime identity or shape;
- the corresponding generated Schema type exists and exactly describes the wire values;
- typecheck, tests, build, and consumer/package checks provide compatibility evidence.

If these facts cannot be proved, do not speculate. Use `RETAIN_WITH_ASSERTION` or `BLOCKED`.

## Identity string enum migration

Convert:

```ts
export enum Status {
  Active = "Active",
  Inactive = "Inactive",
}
```

into:

```ts
import type { Status as GeneratedStatus } from "../generated";

export const Status = {
  Active: "Active",
  Inactive: "Inactive",
} as const satisfies { [K in GeneratedStatus]: K };

export type Status = (typeof Status)[keyof typeof Status];
```

Preserve the runtime name, type name, member keys, and wire values. Use a type-only generated import and a `Generated`-prefixed alias.

Do not use `Record<GeneratedStatus, GeneratedStatus>` for identity enums. It accepts swapped valid values. `{ [K in GeneratedStatus]: K }` proves that every generated literal exists as the identical key/value pair.

## Alias-key enum migration

When public keys intentionally differ from wire values:

```ts
export enum Status {
  Enabled = "Active",
  Disabled = "Inactive",
}
```

use:

```ts
import type { Status as GeneratedStatus } from "../generated";

export const Status = {
  Enabled: "Active",
  Disabled: "Inactive",
} as const satisfies Record<string, GeneratedStatus>;

export type Status = (typeof Status)[keyof typeof Status];

type Equal<A, B> =
  (<T>() => T extends A ? 1 : 2) extends
  (<T>() => T extends B ? 1 : 2)
    ? true
    : false;

type Assert<T extends true> = T;

type _StatusMatchesGenerated = Assert<Equal<Status, GeneratedStatus>>;
```

Prefer an existing shared `Equal`/`Assert` utility when present. The value constraint rejects invalid values; the equality assertion rejects both missing generated values and extra Domain values.

## Schema alignment

For every schema-backed enum, the Schema remains a primitive literal contract such as:

```json
{
  "type": "string",
  "enum": ["Active", "Inactive"]
}
```

Verify exact equality across:

- original runtime values;
- const-object values after migration;
- derived Domain union;
- JSON Schema enum values;
- generated Schema union.

Detect and report missing values, extra values, duplicates, incorrect aliases, generated types widened to `string`/`number`, incorrectly modelled object schemas, and missing generated enum types.

Preserve the repository's existing Schema filename convention, directory layout, `$id`, `title`, and generated declaration layout. Do not rename files merely to standardize them.

## RETAIN_WITH_ASSERTION

Keep the original enum when conversion could alter a public/downstream runtime contract but exact compatibility can still be checked safely.

For supported TypeScript versions, a string enum may be compared by wire values:

```ts
import type { Status as GeneratedStatus } from "../generated";

export enum Status {
  Active = "Active",
  Inactive = "Inactive",
}

type Equal<A, B> =
  (<T>() => T extends A ? 1 : 2) extends
  (<T>() => T extends B ? 1 : 2)
    ? true
    : false;

type Assert<T extends true> = T;

type _StatusMatchesGenerated = Assert<Equal<`${Status}`, GeneratedStatus>>;
```

Do not use `as`, `any`, `unknown`, broad casts, suppression comments, or ESLint allowlists to silence incompatibility.

## BLOCKED enums

Do not automatically convert:

- numeric enums;
- heterogeneous enums;
- `const enum`;
- computed members;
- ambient or `declare enum`;
- namespace/declaration-merged enums;
- enums relying on reverse lookup;
- enums whose runtime object shape is externally consumed;
- public package enums where compatibility cannot be proved;
- enums whose generated Schema type is missing or incorrect.

Report exact blocking evidence and required remediation. Do not add an allowlist.

## Runtime compatibility checks

Review consumers for patterns including:

```ts
Status.Active
Object.values(Status)
Object.keys(Status)
Record<Status, T>
value === Status.Active
switch (value) {}
import { Status } from "..."
import type { Status } from "..."
```

Preserve named exports, public import paths, barrel exports, package export maps, JSON payload values, and runtime string values. Do not convert a value import to type-only when runtime access is used.

A compile-successful change is not enough. Verify tests, build, package output, and relevant consumer typechecks.

## Type-position changes after migration

The const object is a value and the type alias is a type with the same name:

```ts
const current: Status = Status.Active;
```

When a specific member value is required in a type position, use `typeof`:

```ts
export type Message = KafkaMessage<typeof Status.Active, Payload>;
```

## Validation

Use the repository's real package scripts, including equivalents of:

```text
npm run generate:types
npm run check:generated-types
npm run validate:schemas
npm run check:schema-coverage
npm run check:generated-integration
npm run lint:schema-domain-check
npm run typecheck
npm test
npm run build
```

Run generation twice and verify the second run produces no new diff. Review the final git diff and confirm no unrelated Request Schema, API, client, service, Kafka, persistence, serialization, or business-logic changes occurred.

## Enum report

For every enum record:

```text
Enum name
Source file
Schema file
Generated type
Current enum kind
Identity or alias-key mapping
Classification
Action taken
Compatibility evidence
Unresolved issue
```

Use `GO` only when every eligible safe enum is migrated and all required checks pass. Use `GO_WITH_REMEDIATION` when blocked enums or Schema mismatches remain. Use `NO_GO` only when compatibility cannot be determined safely.

## ESLint boundary

The approved `schema-domain-check/domain-class-implements-schema-generated-type` rule checks eligible exported classes. It does not migrate or validate enums. Enum migration and exact generated-union enforcement belong to this Enforcer workflow and `scripts/check-generated-integration.mjs`.

## Repository-wide enum centralization

The objective is to make the Domain package self-contained for public business types. Scan the full repository, including API, service, client, SDK, Kafka, utilities, and package roots, for:

- TypeScript `enum`;
- `const enum`;
- string-literal const objects used as enums;
- literal-union aliases paired with runtime constants;
- local re-exports/duplicates of business enum values.

For every discovery, record one ownership classification:

```text
SHARED_BUSINESS_ENUM
LOCAL_BUSINESS_ENUM
TRANSPORT_ENUM
INTERNAL_RUNTIME_ENUM
THIRD_PARTY_ENUM
GENERATED_ENUM
```

For every `SHARED_BUSINESS_ENUM`, make Domain the canonical owner, normally under `src/domain/enums/<Name>.ts`, and migrate safe string enums to the const-object + same-name type pattern. Preserve old public/module entry points with compatibility re-exports where required so downstream imports do not break.

Do not copy transport-only or implementation-only enums into Domain. "All enums covered" means every repository enum is inventoried and assigned an explicit owner/action, while every shared consumer-facing business enum is Domain-owned.

### Circular dependency gate

Before moving an enum:

1. Build the current import/re-export dependency graph for the enum source, proposed Domain enum module, generated module, and all consumers.
2. Prefer leaf enum modules that import only Domain-internal generated types using `import type`, or no runtime modules at all.
3. Never make `src/domain/enums/**` import API, service, client, repository, Kafka, handler, or infrastructure modules.
4. Preserve compatibility re-exports in old modules only when they point one-way to Domain and do not create a cycle.
5. Run the repository dependency-cycle checker (`dependency-cruiser`, `madge`, or equivalent) when available. Otherwise inspect the TypeScript module graph and emitted ESM imports.
6. Any newly introduced cycle is `BLOCKED`; do not land the centralization until the cycle is removed without behavior change.

### Behavior-preservation gate

Preserve:

- exact member keys and string values;
- `Status.Member` runtime access;
- `Object.keys/values/entries` results for supported string enums;
- JSON/AJV wire values;
- package/barrel export paths through re-export compatibility where required;
- serialization, switch/equality behavior, SDK/FE imports, and persisted/Kafka values.

Do not auto-migrate numeric, heterogeneous, computed, ambient, merged, or reverse-lookup-dependent enums. Record them as retained/blocked while still counting them in repository-wide enum coverage.

### Domain-contained generated imports

Generated enum union types now live inside the Domain package under `src/domain/generated/**`. Const-object enum modules may import generated unions from that internal directory, but must not depend on a separately published generated package. A clean consumer must be able to use Domain enums by installing only the Domain package.
