# Common/Data reference architecture

Use this architecture as the explicit baseline derived from the established patterns in translation-service, translation-api, and cms-api. Apply the architectural rules, not those repositories' service names, URI hosts, filenames, or unrelated legacy quirks.

## Repository layout

```text
src/schemas/common/**    reusable atomic leaf contracts
src/schemas/data/**      complete Domain/DTO data contracts
src/domain/generated/**  declarations generated from Common and Data only; published inside Domain
scripts/*.mjs            all repository schema tooling
```

`src/schemas/requests/**` belongs only to `request-schema-contract`. `src/schemas/kafka/**` is runtime validation only and does not generate TypeScript declarations.

## Domain inventory and Data coverage

Recursively discover every real Domain/DTO root instead of assuming one directory. Inspect at least:

```text
src/domain/**
src/api/domain/**
src/**/domain/**
src/**/domains/**
src/**/dto/**
src/**/dtos/**
```

Also inspect `tsconfig.json`, path aliases, package exports, barrel files, handlers, services, clients, serializers, tests, and repository-specific source roots.

Classify every declaration. Create or validate a Data Schema for every eligible JSON-shaped data contract:

- class;
- object interface;
- object-shaped type alias;
- enum or literal union used as data;
- discriminated union;
- nested DTO/value object;
- external service/library data type used by an eligible property.

Do not generate Data Schemas for behavior-only services, repositories, handlers, callbacks, framework objects, validators, opaque runtime identities, or non-JSON values. Record every exclusion with evidence.

## Common contract rules

Common is the reusable leaf layer.

- One public root contract per file.
- One unique `title` per root.
- No `$ref`, `definitions`, or `$defs` anywhere in a Common file.
- No Common-to-Common dependency.
- Use primitive enums, identifiers, pagination metadata, and small stable reusable value objects here.
- Do not move a composite DTO into Common merely because several Data contracts use it.

Example:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "common/blacklist-reason.schema.json",
  "title": "BlacklistReason",
  "type": "string",
  "enum": ["Catalogue", "Technical", "Other"]
}
```

## Data contract rules

Data is the complete compile-time Domain/DTO layer.

- One public root contract per file.
- Default filename: `<kebab-case-type-name>.schema.json`.
- Root `title` must match the Domain symbol unless a documented legacy map proves otherwise.
- May reference only the root of a Common file using a relative `$ref`.
- No Data-to-Data refs.
- No local `definitions` or `$defs`.
- No fragments or JSON Pointers.
- Keep private single-use nested objects inline.
- Preserve exact property names, required/optional state, nullable state, arrays, enums, unions, dates, defaults, bounds, and `additionalProperties` behavior.
- Do not use `allOf` to model TypeScript inheritance; flatten the effective property set.
- Do not create unconstrained placeholder schemas such as `{ "type": "object", "additionalProperties": true }` unless that is the proven Domain contract.

Example:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "data/competition-result.schema.json",
  "title": "CompetitionResult",
  "type": "object",
  "properties": {
    "competitionKey": { "type": "string" },
    "reason": { "$ref": "../common/blacklist-reason.schema.json" }
  },
  "required": ["competitionKey", "reason"],
  "additionalProperties": false
}
```

Allowed:

```json
{ "$ref": "../common/blacklist-reason.schema.json" }
```

Prohibited:

```json
{ "$ref": "./another-data.schema.json" }
{ "$ref": "#/definitions/reason" }
{ "$ref": "../common/models.schema.json#/definitions/reason" }
```

## External package types

When an eligible Domain property is owned by a genuine external published service/library package and the API value is transferred unchanged, use the exact exported symbol:

```json
{
  "type": "object",
  "tsType": "import(\"@service-lib/domain/team\").Team"
}
```

Resolve local aliases and re-exports to the final package owner. Do not use `tsType` for current-repository types, path aliases, monorepo sibling packages, or workspace-local packages. If serialization changes the wire shape, model the wire shape and require serializer/test evidence instead of inserting `tsType` mechanically.

## Type generation

Generate declarations only from Common and Data, and write them into the published Domain package under `src/domain/generated/**` (or the repository-equivalent Domain root plus `/generated`). Do not create a separate repository-level `src/generated` package.

1. Generate Common first.
2. Preserve source Data `$ref` values for runtime validation.
3. For generation only, rewrite Data-to-Common root refs in temporary copies to generated imports such as:

```json
{
  "tsType": "import(\"./blacklist-reason.schema\").BlacklistReason"
}
```

4. Never write temporary local `tsType` imports back into source JSON.
5. Fail on duplicate root titles, duplicate output filenames, missing roots, partial generation errors, or stale barrel exports.
6. Use only selective barrel exports:

```ts
export type { CompetitionResult } from "./competition-result.schema";
```

7. Never use `export *`.
8. The second generation run must produce no diff.

## Interface integration boundary

Inventory every object interface and create its Data Schema when eligible. Do not convert interfaces inside Builder or Coverage.

`generated-type-enforcer` may convert an interface to a class only when runtime, public API, package exports, constructors, decorators, dependency injection, downstream imports, and serialization behavior are proven unchanged. Otherwise retain the interface and add an exact compile-time compatibility assertion.

## Non-negotiable compatibility rule

No Skill may alter existing runtime logic or downstream contracts involving handlers, routes, clients, APIs, services, package exports, serializers, Kafka, persistence, validation behavior, defaults, errors, constructors, decorators, or integrations. Successful compilation alone is not compatibility evidence. Stop and report when safety cannot be proven.

## Domain-contained generated contract

Treat the Domain package as the self-contained public data-contract package. Generated declarations are implementation/verification artifacts of that package, not a separately published dependency.

Required shape:

```text
src/domain/**             hand-written public Domain contracts
src/domain/enums/**       canonical shared business enum runtime objects/types
src/domain/generated/**   Common/Data generated declarations and generated barrel
```

Rules:

- FE and external consumers must be able to install/import the Domain package without separately installing a generated package.
- Domain-to-generated imports must stay inside the Domain package boundary.
- Generated files may import other generated files under `src/domain/generated/**`.
- Generated files must not introduce avoidable dependencies on internal service/client packages.
- Public data contracts currently owned by internal service/client packages should be migrated into Domain ownership only when values, serialization, public imports, and downstream behavior are preserved.
- Do not move infrastructure-only or behavior-only types into Domain merely to remove a dependency.
- Run a clean consumer typecheck using only the built/published Domain package.

## Repository-wide enum ownership

Inventory every enum and enum-like declaration across the repository, not only Domain/DTO folders. Every discovered enum must receive an explicit disposition.

Classify at minimum:

- `SHARED_BUSINESS_ENUM` — consumer-facing business contract; canonical owner must be Domain.
- `LOCAL_BUSINESS_ENUM` — business meaning but intentionally module-local; keep local only with evidence that it is not part of the public/shared contract.
- `TRANSPORT_ENUM` — HTTP/Kafka/framework boundary-only value; do not move unless it is also a public Domain contract.
- `INTERNAL_RUNTIME_ENUM` — implementation state; keep local.
- `THIRD_PARTY_ENUM` — externally owned; do not copy ownership unless the product contract intentionally absorbs it.
- `GENERATED_ENUM` — generated artifact; never make it the hand-written runtime owner.

Every `SHARED_BUSINESS_ENUM` must be represented in `src/domain/enums/**` as a const object plus a same-name type alias after compatibility is proved. Preserve all member keys, runtime values, public import paths through compatibility re-exports when needed, and Schema enum values.

Do not silently skip any enum. Coverage is incomplete until every repository enum has a recorded owner, classification, and action.
