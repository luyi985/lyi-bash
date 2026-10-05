# Target architecture

Use the explicit Translation Service / Translation API / CMS API Common/Data baseline defined in `../../static-schema-builder/references/common-data-architecture.md`. Preflight must treat missing Data Schemas for eligible Domain/DTO declarations as incomplete coverage.

## Schema categories

```text
src/schemas/common   atomic reusable leaf contracts
src/schemas/data     Domain/DTO compile-time contracts
src/schemas/kafka    serialized Kafka wire validation
src/domain/generated declarations generated from common and data only, physically inside the Domain package
```

### Common

- One standalone public root contract per file.
- Unique `title` and stable `$id` when the repository uses IDs.
- No `$ref`, `definitions`, or `$defs`.
- Common is for reusable leaf contracts. Composite DTOs belong in data.

### Data

- Represents Domain or DTO compile-time contracts.
- May reference only the root of a file under `src/schemas/common`.
- No local definitions, fragments, data-to-data references, request references, Kafka references, or source-code references.
- Data-specific single-use nested structures remain inline.

### Request Schema boundary

`src/schemas/requests/**` is excluded from this architecture and must not be inspected or modified by static-schema skills. Use `request-schema-contract`.

### Kafka

- Runtime-only Draft-07 schema for the serialized producer payload.
- Kafka and request schemas are not the same structure: Kafka normally has the serialized message Schema at the file root and has no HTTP `requestBody` or `parameters` wrapper.
- Does not participate in TypeScript generation.
- `_typ` must match the real serialized payload and use `const` when present.
- No cross-file references. Same-file local definitions are allowed when needed.
- Match the payload passed to `sendWithSchema()` or equivalent enforcement.

## Generation

- Generate common first, then data.
- Source data schemas keep JSON Schema `$ref` for runtime use.
- For generation only, data-to-common refs may be replaced in temporary copies with `tsType: import("./common-module").CommonType`.
- Never write those temporary local imports into source Schema.
- Requests and Kafka are excluded.
- The generated barrel uses selective `export type`, never `export *`.

## TypeScript references

- Source Schema may use `tsType: import("package").Type` only for a genuine externally published package.
- Current-repository, path-alias, sibling-workspace, and monorepo-local types are prohibited.
- `tsType: "Date"` is allowed only when the existing runtime Domain property is already `Date` and no conversion behavior changes.

## Repository schema tooling location

All schema-related `.mjs` files must be located under repository-root `scripts/`. Any active schema generator, architecture validator, drift checker, build copier, coverage checker, integration checker, or Kafka schema copier under `tools/` is a remediation issue. `package.json` and CI must call `scripts/...` paths only. Do not accept duplicate active copies in both directories.



## Domain-contained generated output

The generated declarations are part of the Domain package:

```text
src/domain/generated/**
```

Preflight must reject an active top-level `src/generated/**` output or a published Domain `.d.ts` dependency on a separate generated sibling package when the repository has adopted this architecture. Verify that a clean consumer can use the built/published Domain package alone.

## Repository-wide enum ownership

Preflight must inventory every repository enum/enum-like declaration, not only those under Domain. Every enum needs an explicit ownership classification and action. All shared consumer-facing business enums must be Domain-owned (normally `src/domain/enums/**`) after safe migration, with exact values preserved and compatibility re-exports where necessary.

Require evidence that enum centralization introduced no new circular dependency. Use the repository's dependency-cycle tooling when available and inspect ESM/type-only import direction.
