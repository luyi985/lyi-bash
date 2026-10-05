# Progress rubric

## Builder COMPLETE

Require evidence for all applicable items:

- `common`, `data`, and `kafka` categories are created or explicitly not applicable. Request Schemas are out of scope.
- Common is atomic and reference-free.
- Data refs target only common roots.
- Kafka schemas describe serialized message payloads.
- Generator processes common before data and fails nonzero on any file failure.
- Generated data declarations reference generated common declarations rather than redeclaring common contracts.
- Barrel exports only root contracts.
- Schema validation, generation, drift check, and postbuild/package scripts exist.
- Build output contains schemas and generated declarations.
- Kafka schemas are copied to consumer paths when producer enforcement requires it.

## Coverage COMPLETE

Require:

- All Domain roots were discovered.
- Every eligible JSON-shaped class, interface, type alias, enum, and union has one mapped Schema and generated root type.
- Exclusions are behavior-only or non-JSON and documented.
- Properties, required/optional, nullability, arrays, unions, enums, Date semantics, formats, bounds, and external types match.
- Every external service/library-owned Domain property has the exact external `tsType`, unless a documented wire-shape exception proves a different serialized API contract.
- No unintended `any`, `unknown`, `{}`, `object`, or open index signature remains.
- Coverage evidence comes from source comparison, not generation success alone.

## Enforcement COMPLETE

Require all of the following:

- The approved `eslint-plugin-schema-domain-check/` folder exists at repository root with `package.json` and `index.cjs`.
- Root `package.json` contains:

  ```json
  "eslint-plugin-schema-domain-check": "file:eslint-plugin-schema-domain-check"
  ```

- The installed plugin exports `domain-class-implements-schema-generated-type`.
- ESLint registers the plugin as `schema-domain-check`, or the dedicated lint script invokes the exact rule.
- `lint:schema-domain-check` uses:

  ```text
  schema-domain-check/domain-class-implements-schema-generated-type
  ```

- The obsolete rule `schema-domain-check/require-implements-generated` is absent.
- No ESLint config, package script, or inline invocation configures an `allowlist` for the schema-domain-check rule.
- Eligible classes use type-only imports and implement the mapped generated contract.
- Interfaces/type aliases use compile-time compatibility assertions or an equivalent checker.
- Every schema-backed enum has an explicit enforcement outcome: safely migrated, retained with exact assertion and evidence, blocked with remediation, or documented as not Schema-backed.
- Identity const-object enums use `{ [K in GeneratedType]: K }`; alias-key objects use an exact two-way equality assertion.
- Retained enums are listed in `reports/static-schema-enforcement-exceptions.json` with reason, evidence, and a named assertion.
- Numeric, heterogeneous, `const`, ambient, computed, namespace-merged, and public-API enums are never auto-converted without explicit proof.
- Exact compatibility is checked where extra Domain fields are not allowed.
- Generated root contracts are imported from the public barrel, not helper types accidentally emitted inside individual files.
- Plugin lint, normal lint, typecheck, tests, and build pass.

The ESLint plugin alone is not proof of complete coverage or exact equality. Coverage and TypeScript checks remain mandatory.

## BLOCKED examples

- Required changes inside `plug/`.
- External package types cannot be resolved in source or consumer builds.
- Existing Date/string behavior is unclear and tests are absent.
- Kafka serialized payload cannot be established.
- A Domain runtime identity cannot be represented without changing behavior.


## Domain-contained generation and enum centralization

Builder is incomplete when generated declarations are still emitted to a separate top-level generated package instead of the published Domain `/generated` directory. Coverage/Enforcement are incomplete when any repository enum lacks an ownership/action record, any safe shared business enum remains outside Domain, or a new circular dependency is introduced by centralization.
