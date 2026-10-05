---
name: static-schema-builder
description: Build or repair the strict static-schema infrastructure for a TypeScript service. Use when ChatGPT must create and normalize common, data, and Kafka JSON Schemas; generate declarations from common and data directly inside the Domain package; make generated data types import generated common types; add deterministic barrel generation, schema validation, drift checks, npm scripts, postbuild asset copying, and Kafka packaging without changing runtime behavior.
---

# Static Schema Builder

Build the infrastructure only. Do not claim Domain coverage is correct; `static-schema-coverage` verifies that later.

## Request Schema ownership

Treat `src/schemas/requests/**` as out of scope and read-only. Do not use it as an architecture-validation target. Hand all request-Schema work to `request-schema-contract`.

Read these references before editing:

- [references/common-data-architecture.md](references/common-data-architecture.md)
- [references/schema-categories.md](references/schema-categories.md)
- [references/type-generation.md](references/type-generation.md)
- [references/build-and-scripts.md](references/build-and-scripts.md)
- [references/domain-contained-generation.md](references/domain-contained-generation.md)
- [references/runtime-invariants.md](references/runtime-invariants.md)

## Hard rules

- Never change existing application logic or the behavior/contracts of downstream clients, APIs, services, consumers, serializers, persistence, events, or integrations. Stop and report when a schema/tooling change cannot be proven behavior-neutral.
1. Preserve existing runtime behavior.
2. Treat `plug/` as read-only.
3. Use one strict architecture; do not invent compatibility modes.
4. Put reusable atomic leaf contracts in common.
5. Put Domain/DTO compile-time contracts in data.
6. Data may reference only common roots.
7. Never inspect, create, modify, validate, normalize, move, delete, or generate from `src/schemas/requests/**`; that directory is owned exclusively by `request-schema-contract`. Kafka is runtime-only and never generates `.d.ts` files.
8. Source Schema must use an exact external-package `tsType` for a Domain property whose unchanged API value is owned by a genuine external service/library package; never use current-repository or workspace-local types. When the API wire shape intentionally differs, preserve the wire Schema and require explicit serializer evidence for Coverage.
9. Do not use `allOf` for Domain inheritance or object extension; flatten the properties.
10. Do not hand-edit generated output as the final fix; repair source Schema or generation tooling.

## Required repository tools

Keep repository schema tooling minimal. Create or repair the six canonical repository `.mjs` tools under root `scripts/`. Do not create one script per micro-check, and do not retain superseded schema tooling under `tools/` or duplicate old scripts. Update package scripts, CI, docs and imports atomically.

```text
scripts/generate-schema-types.mjs
scripts/check-generated-types.mjs
scripts/copy-domain-schema-json.mjs
scripts/check-schema-coverage.mjs
scripts/check-generated-integration.mjs
scripts/check-enum-ownership.mjs
```

The bundled scripts are reference implementations. Adapt paths, module format, and package manager without weakening the rules.

## Workflow

### 1. Discover

Recursively inventory all Domain/DTO roots and all declarations according to `references/common-data-architecture.md`. Builder must create missing Data Schemas for every eligible JSON-shaped data contract when the mapping is provable. Record blocked or excluded declarations; do not silently skip them.

Inspect:

- existing Schema directories and runtime loaders;
- generator and generated output layout;
- Kafka producer serialization and `sendWithSchema()` bindings;
- package scripts, build output, package exports, bundling, published package lists, and emitted Domain `.d.ts` dependencies;
- existing tests and fixtures.

### 2. Normalize categories and complete Data coverage

Create or repair:

```text
src/schemas/common
src/schemas/data
src/schemas/kafka
src/domain/generated
```

Do not move a contract between categories based only on its filename. Classify by purpose. For each eligible Domain class, interface, object type alias, enum/literal union, discriminated union, nested DTO, or external data property, create or repair the corresponding Data Schema using the explicit Translation Service / Translation API / CMS API baseline in `references/common-data-architecture.md`. Do not convert interfaces to classes in this Skill.

### 3. Repair generation

- Generate common before data.
- Preserve source data `$ref` for runtime validation.
- Use temporary generation copies so generated data declarations import generated common declarations.
- Generate only root contracts into the public barrel.
- Fail the whole command on any partial error.
- Run generation twice; the second run must produce no diff.

### 4. Add npm and build lifecycle

Add or repair the repo-equivalent commands for `generate:types`, `check:generated-types`, `check:schema-coverage`, `check:generated-integration`, `check:enum-ownership`, `postbuild`, plus one aggregate `check:schema-contracts` command when appropriate.

Keep existing build commands intact and append the required postbuild behavior rather than replacing unrelated build logic.

### 5. Validate Domain-contained generated output

Apply `references/domain-contained-generation.md`. Generated declarations must live physically inside the published Domain source tree, normally `src/domain/generated/**`, and must not require a separately installed generated package. Domain source may import these generated declarations only through repository-relative or Domain-internal paths that compile into the same published Domain package. Verify the emitted Domain package has no unresolved dependency on a generated sibling package.

Every generated declaration must also be dependency-safe: if it imports a type that would force FE consumers to install another internal service/client library, migrate that public data contract into Domain ownership when behavior-neutral and represent it through Common/Data Schema. If ownership cannot be moved safely, stop and report the dependency instead of hiding it.

### 6. Validate infrastructure

Run:

- consolidated schema coverage/architecture check;
- generation;
- drift check;
- TypeScript build;
- runtime validation tests;
- Kafka/component tests when applicable;
- package/build asset inspection.

## Completion criteria

Builder is complete only when:

- category boundaries pass;
- generator handles common and data only;
- generated data types import generated common types;
- no `export *` exists in the generated barrel;
- single-file failure makes generation fail;
- generated output is deterministic;
- build output contains all required Schema and declaration assets;
- generated declarations are emitted inside the published Domain package and a clean consumer can typecheck with the Domain package alone;
- `src/schemas/requests/**` is unchanged; Kafka retains its existing runtime behavior.

## Handoff

Return:

1. Files created or changed
2. Category decisions
3. Generator behavior
4. Npm/build scripts
5. Commands and results
6. Runtime behavior evidence
7. Remaining infrastructure risks
8. Handoff to `static-schema-coverage`
