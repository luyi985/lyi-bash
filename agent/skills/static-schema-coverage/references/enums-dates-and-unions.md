# Enums, dates, and unions

## Enum architecture

JSON Schema validates the runtime wire value, not the TypeScript enum object.
Keep the Schema as a primitive literal contract:

```json
{
  "type": "string",
  "enum": ["Competition", "Participant", "Team"]
}
```

`json-schema-to-typescript` normally generates a literal union:

```ts
export type EntityType =
  | "Competition"
  | "Participant"
  | "Team";
```

Coverage must prove two separate facts:

1. Schema values exactly match the existing serialized values.
2. The Domain enum has a safe enforcement decision.

Classify every schema-backed enum as exactly one of:

```text
SAFE_TO_MIGRATE
RETAIN_WITH_ASSERTION
BLOCKED
NOT_SCHEMA_BACKED
```

Do not rewrite Domain enums in this Skill. Audit every enum or enum-like declaration across the repository, record the decision and evidence for `generated-type-enforcer`, and never silently skip an exported enum.

## Enum comparison

Compare exact runtime values, not member names alone.

Check:

- value count;
- spelling and case;
- string versus numeric representation;
- aliases and duplicate values;
- key names separately from wire values;
- `const enum`, ambient, computed, numeric, and heterogeneous forms;
- namespace/declaration merging;
- public package exports and external consumers;
- enum member types used in signatures or generics;
- `Object.keys`, `Object.values`, `Object.entries`, indexed lookup, reflection, and identity comparison;
- numeric reverse mapping such as `Enum[0]`;
- one canonical Schema source.

Never widen an enum to plain `string` or `number`.

## Safe identity string enum target

When keys and wire values are identical and conversion is proven safe, the target Enforcer pattern is:

```ts
import type { Status as GeneratedStatus } from "../generated";

export const Status = {
  Active: "Active",
  Inactive: "Inactive",
} as const satisfies {
  [K in GeneratedStatus]: K;
};

export type Status =
  (typeof Status)[keyof typeof Status];
```

The identity mapped type proves that every generated literal exists and that each key maps to its identical wire value.

Do not recommend:

```ts
Record<GeneratedStatus, GeneratedStatus>
```

for identity enums. That shape permits accidental swaps between valid values.

## Alias keys

When Domain keys intentionally differ from wire values, record the mapping explicitly.
The Enforcer target is:

```ts
import type { Status as GeneratedStatus } from "../generated";

type Equal<A, B> =
  (<T>() => T extends A ? 1 : 2) extends
  (<T>() => T extends B ? 1 : 2)
    ? true
    : false;

type Assert<T extends true> = T;

export const Status = {
  Enabled: "Active",
  Disabled: "Inactive",
} as const satisfies Record<string, GeneratedStatus>;

export type Status =
  (typeof Status)[keyof typeof Status];

type _StatusMatchesGenerated =
  Assert<Equal<Status, GeneratedStatus>>;
```

The value constraint rejects invalid values. The exact equality assertion rejects both missing generated values and extra Domain values.

## Retained enums

Do not force conversion when it may change runtime or public TypeScript behavior.

Examples that commonly require `RETAIN_WITH_ASSERTION` or `BLOCKED`:

- numeric or heterogeneous enums;
- `const enum` or ambient declarations;
- computed members;
- namespace merging;
- published package API;
- code relying on enum member nominal behavior;
- reverse lookup or reflection;
- uncertain external consumers.

A retained string enum must still have an exact generated-wire-value assertion and named evidence. On supported TypeScript versions, a string enum may expose its value union through a template literal:

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

type _StatusMatchesGenerated =
  Assert<Equal<`${Status}`, GeneratedStatus>>;
```

Coverage must record why the enum is retained and what tests prove behavior preservation.

## Numeric and heterogeneous enums

Do not automatically replace numeric or heterogeneous TypeScript enums.

A compiled numeric enum has reverse mappings such as `Enum[0]`. A const object does not.

- If reverse mapping or enum runtime identity is used, return `NO_GO` or require a named remediation plan.
- If only named member access and serialized numeric values are used, a const object may be safe after explicit tests.
- Preserve exact serialized numeric values; never infer them from declaration order.
- Require a repository-specific compile-time assertion against the generated numeric union.

## Coverage report fields for enums

For every schema-backed enum, record:

```text
Domain symbol
Schema file
Generated root
Wire values
Key-to-value mapping
Decision
Runtime/public-API evidence
Required Enforcer action
```

Do not claim coverage complete if an enum decision is missing. Coverage must also identify whether the mapping is identity-key or alias-key, the generated type module, downstream/public-export evidence, and the exact Enforcer action.

## Date and DateTime

Do not infer `Date` from a property name.

Existing string property:

```ts
createdDateTime: string;
```

stays a string. Preserve the existing use or absence of `format: "date-time"`.

Existing runtime Date property:

```ts
createdDateTime: Date;
```

may use:

```json
{
  "type": "string",
  "format": "date-time",
  "tsType": "Date"
}
```

only when current runtime validation and serialization already make that combination truthful.

Do not add:

- string-to-Date conversion;
- Date-to-string conversion;
- timezone normalization;
- new format rejection;
- changed optional/null/default behavior.

Kafka coverage is based on the serialized wire string, not the in-memory Date.

## Unions

Use `oneOf` for genuine mutually exclusive variants.

Prefer a discriminator property with distinct `const` values.

Verify every branch and reject ambiguous overlaps. Do not use `allOf` for inheritance.


## Repository-wide enum coverage

Do not limit enum discovery to Domain folders. Scan all active source roots and assign every enum-like declaration one of: `SHARED_BUSINESS_ENUM`, `LOCAL_BUSINESS_ENUM`, `TRANSPORT_ENUM`, `INTERNAL_RUNTIME_ENUM`, `THIRD_PARTY_ENUM`, or `GENERATED_ENUM`.

Coverage is complete only when:

- every discovered enum has a recorded owner and action;
- every shared consumer-facing business enum is Domain-owned or has an explicit blocked migration with evidence;
- duplicate business enum declarations are removed or converted to compatibility re-exports after behavior checks;
- enum values remain exactly aligned with Schema/generated types where schema-backed;
- no enum centralization introduces a circular dependency.
