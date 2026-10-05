---
name: static-schema-coverage
description: Audit and repair semantic coverage between TypeScript Domain contracts, strict common/data JSON Schemas, and generated declaration roots. Use after the static-schema-builder stage to discover Domain roots, classify JSON-shaped symbols, compare properties, optionality, enums, unions, dates, external types, and generated output, repair common/data Schema mistakes without changing runtime behavior, and produce an evidence-based coverage report with GO, GO_WITH_REMEDIATION, or NO_GO.
---

# Static Schema Coverage

Verify that the Schema represents the existing Domain contract correctly. Generation success is not coverage evidence.

Do not modify generator architecture, npm scripts, postbuild, Kafka schemas, ESLint configuration, or `plug/`. Do not inspect or modify `src/schemas/requests/**`; it is owned by `request-schema-contract`.

Read:

- [../static-schema-builder/references/common-data-architecture.md](../static-schema-builder/references/common-data-architecture.md)
- [references/coverage-method.md](references/coverage-method.md)
- [references/enums-dates-and-unions.md](references/enums-dates-and-unions.md)
- [references/external-types-and-degradation.md](references/external-types-and-degradation.md)

- Never change existing application logic or the behavior/contracts of downstream clients, APIs, services, consumers, serializers, persistence, events, or integrations. Stop and report when a schema/tooling change cannot be proven behavior-neutral.

## Scope

Inspect and, when safe, repair:

```text
Domain source roots
src/schemas/common/**
src/schemas/data/**
src/domain/generated/**
```

Requests and Kafka are not the source of Domain compile-time coverage.

## Workflow

### 1. Discover Domain roots

Do not assume only `src/domain`.

Search recursively for repository-specific roots such as:

```text
src/domain/**
src/api/domain/**
src/**/domain/**
src/**/domains/**
src/**/dto/**
src/**/dtos/**
```

Use `tsconfig.json`, package exports, barrels, handlers, services, clients, serializers, and tests to discover additional roots. Inventory every declaration, not only exported classes. Separately scan the entire repository for every enum/enum-like declaration, including enums outside Domain/DTO roots, so enum ownership coverage is complete.

Run the bundled inventory helpers when TypeScript is installed:

```bash
node scripts/check-schema-coverage.mjs <repository-root>
node scripts/check-enum-ownership.mjs <repository-root>
```

### 2. Classify every declaration

Classify exported and internally used declarations as:

- JSON-shaped class;
- object interface;
- object type alias;
- enum, const-object enum, or literal union;
- discriminated union;
- external data type;
- behavior-only service/function/framework type;
- non-JSON runtime identity.

Only valid behavior/non-JSON categories may be excluded. Record the reason.

### 3. Build the coverage matrix

For each eligible symbol record:

```text
Domain symbol | Source | Kind | Schema | Generated root | Status | Evidence
```

Default mapping rule:

```text
Domain symbol name = Schema title = Generated root type
```

Document explicit legacy exceptions rather than guessing.

### 4. Compare semantics

Compare source Domain and Schema field by field:

- property name and type;
- required versus optional;
- nullable versus non-nullable;
- array and tuple item types;
- nested objects;
- enum and const values, plus an explicit `SAFE_TO_MIGRATE`, `RETAIN_WITH_ASSERTION`, `BLOCKED`, or `NOT_SCHEMA_BACKED` decision;
- union branches and discriminators;
- defaults and coercion assumptions;
- string formats and numeric bounds;
- `additionalProperties`;
- Date/string runtime identity;
- external-package ownership;
- every Domain property whose declared type is owned by an external service/library package must either use an exact external-package `tsType` in its Schema property or have documented evidence that the API wire shape is intentionally modelled differently.


For every repository enum, record ownership/classification and action. For every schema-backed/shared-business enum, additionally include in the coverage report:

```text
Wire values | Key-to-value mapping | Decision | Runtime/public-API evidence | Enforcer action
```

Do not mark coverage complete while any repository enum lacks an explicit ownership/classification/action record, while any shared business enum remains outside Domain without an approved compatibility reason, or when an enum decision/evidence is missing. Do not mark coverage complete while `EXTERNAL_TYPE_TSTYPE_MISSING` findings remain unresolved.

### 5. Create missing Data Schemas and repair semantic errors

For every eligible symbol without a Data Schema, create one using the exact Common/Data baseline in `../static-schema-builder/references/common-data-architecture.md` when the mapping is provable. Do not generate broad placeholder objects. Report uncertain serialization, nullability, union, Date, external-type, or open-object cases instead of guessing.

### 6. Repair only semantic Schema errors

May repair common/data Schema when evidence is clear.

Do not:

- redesign Domain types;
- change constructors, methods, serializers, validators, defaults, or errors;
- add local or workspace `tsType` to bypass missing Schema;
- weaken a precise type to make generation pass;
- convert interface/type alias to class in this skill;
- rewrite Domain enums in this skill. Record the required Enforcer action, including retained-enum assertions when conversion is unsafe.

### 7. Verify generated output

Run generation after repairs and inspect the resulting declarations.

Use:

```bash
node scripts/check-schema-coverage.mjs <repository-root>
```

Treat warnings as review items. Approve open types only when they exactly match the existing Domain contract.

### 8. Produce evidence

Write:

```text
reports/static-schema-coverage.md
```

Optionally write a machine-readable exception map for legacy naming:

```text
reports/static-schema-contract-map.json
```

## Decision

Return exactly one:

- `GO`: every eligible symbol is correctly covered with adequate evidence.
- `GO_WITH_REMEDIATION`: safe named repairs or tests remain.
- `NO_GO`: the current contract cannot be represented safely without changing behavior or protected code.

## Handoff

When coverage is complete, hand off to `generated-type-enforcer`.
