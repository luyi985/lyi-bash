---
name: generated-type-enforcer
description: Install and configure the approved local eslint-plugin-schema-domain-check package, connect generated static-schema contracts to TypeScript Domain code, and add sustainable lint/typecheck enforcement. Use after schema coverage is complete to copy the approved plugin template, add the file dependency and actual lint rule, add type-only imports and class implements clauses, safely integrate or retain schema-backed enums with exact generated-union assertions, add interface/type-alias compatibility checks, and validate CI without changing runtime behavior.
---

# Generated Type Enforcer

Run only after `static-schema-coverage` reports complete coverage or clearly named exceptions.

Do not create or redesign Schemas, modify generator architecture, invent a different ESLint plugin, or change runtime behavior. Do not inspect or modify `src/schemas/requests/**`; it is owned by `request-schema-contract`.

Read:

- [../static-schema-builder/references/common-data-architecture.md](../static-schema-builder/references/common-data-architecture.md)

- [references/integration-patterns.md](references/integration-patterns.md)
- [references/exact-compatibility.md](references/exact-compatibility.md)
- [references/enum-integration.md](references/enum-integration.md)
- [references/eslint-plugin.md](references/eslint-plugin.md)

## Hard rules

- Never change existing application logic or the behavior/contracts of downstream clients, APIs, services, consumers, serializers, persistence, events, or integrations.
- All repository schema-related `.mjs` files must live under `scripts/`; update npm/CI references when moving an existing checker or installer and do not keep active duplicates under `tools/`. Stop and report when a schema/tooling change cannot be proven behavior-neutral.
- Treat `plug/` as read-only.
- Install the bundled `eslint-plugin-schema-domain-check` local package. Do not replace it with a newly designed plugin.
- Use the real rule name `schema-domain-check/domain-class-implements-schema-generated-type`.
- Never configure an `allowlist` for this rule. Every eligible class must be fixed, not exempted.
- Use type-only imports from the Domain-internal generated barrel under `src/domain/generated/**` (or the discovered Domain-root equivalent). Do not depend on a separate generated package.
- Do not import helper types accidentally redeclared inside individual generated files.
- Review every eligible object interface. Classify it as `SAFE_TO_CONVERT_TO_CLASS`, `RETAIN_INTERFACE_WITH_ASSERTION`, or `BLOCKED`. Convert only `SAFE_TO_CONVERT_TO_CLASS` interfaces after proving no runtime, public-export, downstream-import, constructor, decorator, dependency-injection, serialization, or `instanceof` behavior changes. Retain all other interfaces and enforce exact generated-type compatibility at compile time. Never convert a type alias to a class merely to use `implements`.
- Do not change constructors, methods, decorators, side effects, validators, serializers, defaults, errors, runtime identity, enum wire values, or public API behavior.
- `implements` is necessary for eligible classes but is not an exactness proof by itself.
- Enums do not use `implements`; scan every repository enum/enum-like declaration and assign an explicit ownership/action classification and classify each schema-backed enum before changing it.
- Auto-convert every enum classified `SAFE_TO_MIGRATE`; do not stop at audit-only output when an enum-only migration is requested.
- Retain unsafe enums with an exact generated-contract assertion and documented evidence.
- Do not auto-convert numeric, heterogeneous, `const`, ambient, computed, namespace-merged, or public-API enums without explicit proof.
- For identity const objects, use `{ [K in GeneratedType]: K }`; do not use `Record<GeneratedType, GeneratedType>`.

## Workflow

### 1. Read coverage evidence

Use:

```text
reports/static-schema-coverage.md
reports/static-schema-contract-map.json   # only when legacy names require it
```

Coverage must classify schema-backed enums as:

```text
SAFE_TO_MIGRATE
RETAIN_WITH_ASSERTION
BLOCKED
NOT_SCHEMA_BACKED
```

Do not guess mappings or migration safety.

Default convention:

```text
Domain symbol = Schema title = Generated root type
```

### 2. Apply repository-wide enum ownership and integration

Follow `references/enum-integration.md` completely. Scan the full repository, not only Domain/DTO folders. Run `node scripts/check-enum-ownership.mjs <repository-root>` and produce/maintain `reports/repository-enum-ownership.json` with one explicit owner/classification/action for every discovered enum or enum-like declaration.

For every `SHARED_BUSINESS_ENUM`, make Domain the canonical owner under `src/domain/enums/**` (or the discovered Domain-root equivalent), apply every `SAFE_TO_MIGRATE` const-object migration, and preserve legacy import paths with one-way compatibility re-exports when needed. Do not duplicate runtime definitions after migration.

Capture the module-cycle baseline before moving enums with `node scripts/check-enum-ownership.mjs <repository-root>` (or the repository's established dependency-cruiser/madge command), run it again after migration, and reject any newly introduced cycle. Preserve primitive Schema enums and downstream/package behavior. Do not modify Request Schemas or unrelated classes.

### 3. Install the approved ESLint plugin

The Skill bundles this exact local package:

```text
assets/eslint-plugin-schema-domain-check/
  package.json
  index.cjs
```

Copy it unchanged to the repository root:

```text
eslint-plugin-schema-domain-check/
  package.json
  index.cjs
```

Then add:

```json
{
  "devDependencies": {
    "eslint-plugin-schema-domain-check": "file:eslint-plugin-schema-domain-check"
  }
}
```

Run the repository package-manager install command so the file dependency is present in the lockfile and `node_modules`.

Use the bundled installer when appropriate:

```bash
node scripts/install-schema-domain-plugin.mjs <repository-root> --domain-glob "src/**/domain/**/*.ts"
```

The installer copies the approved template and updates `package.json`; configure ESLint separately using the repository's existing config format.

### 4. Configure ESLint

For legacy ESLint config, register:

```json
{
  "plugins": ["schema-domain-check"]
}
```

Add the exact rule through config or the dedicated script:

```text
schema-domain-check/domain-class-implements-schema-generated-type
```

Recommended script:

```json
{
  "scripts": {
    "lint:schema-domain-check": "eslint src/**/domain/**/*.ts --quiet --rule schema-domain-check/domain-class-implements-schema-generated-type:error"
  }
}
```

Adapt only the Domain glob. Do not use the obsolete rule name `schema-domain-check/require-implements-generated`; it is not exported by the supplied plugin. Do not pass rule options containing `allowlist`; any configured allowlist is a hard failure.

For flat config, load the local package using the repository's existing module style and register it under the key `schema-domain-check`. Do not introduce a second ESLint configuration system.

### 5. Integrate classes

For an eligible class:

```ts
import type {
  TeamBlacklist as GeneratedTeamBlacklist,
} from "../generated";

export class TeamBlacklist
  implements GeneratedTeamBlacklist {
  // existing implementation unchanged
}
```

Use a `Generated` alias to avoid name collisions.

### 6. Integrate enums safely

For every schema-backed enum, apply the eligibility gate in `references/enum-integration.md`.

For an identity string enum classified `SAFE_TO_MIGRATE`:

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

When keys intentionally differ from wire values, use the alias-key exact-equality pattern from the enum reference.

When conversion may change runtime or public TypeScript behavior:

- keep the enum;
- add an exact generated-union assertion;
- add a named entry to `reports/static-schema-enforcement-exceptions.json`;
- include reason and runtime/public-API evidence.

Do not claim the ESLint class rule covers enums.

### 7. Integrate interfaces and type aliases

The supplied ESLint rule checks exported classes with instance fields. It does not cover interfaces, type aliases, enums, or exact two-way equality. Use compile-time compatibility assertions or the dedicated checker for those cases. Do not create runtime classes.

### 8. Add exact data-shape checks

Where extra public data fields are not allowed, compare Domain data properties and generated contracts in both directions. Strip methods before comparison.

### 9. Add CI checks

Require at least:

```text
lint:schema-domain-check
check:generated-contracts
```

CI order should include:

```text
validate:schemas
generate:types
check:generated-types
check:schema-coverage
lint:schema-domain-check
check:generated-contracts
eslint
typecheck
test
build
```

### 10. Validate

Verify the plugin package and exported rule:

```bash
node -e 'const p=require("./eslint-plugin-schema-domain-check"); if(!p.rules?.["domain-class-implements-schema-generated-type"]) process.exit(1)'
```

Run the bundled integration checker when TypeScript is installed:

```bash
node scripts/check-generated-integration.mjs <repository-root>
node scripts/check-enum-ownership.mjs <repository-root>
```

The checker accepts a retained enum only when the exception manifest names it and the named compile-time assertion references the generated contract.

Run the cycle checker before enum centralization to capture the baseline, then again after migration. Do not accept any newly introduced cycle. Then run plugin lint, normal lint, typecheck, tests, and build.

## Plugin limitations that require complementary checks

The approved plugin intentionally focuses on exported non-abstract classes with instance fields and may skip `Error` subclasses according to the approved rule behavior. It must not support or consume a class allowlist. Do not claim it proves complete schema coverage or exact equality.

Separately verify:

- interfaces, type aliases, unions, and enum exactness;
- enum migration eligibility and retained-enum evidence;
- exact data-property equivalence and unwanted extra fields;
- the correct Domain symbol to generated root mapping;
- type-only import policy;
- classes exported indirectly or through patterns outside the plugin's AST scope;
- classes with multiple `implements` entries.

Do not modify the approved plugin or ESLint configuration to hide a lint failure. Repair the Domain integration. Enum enforcement exceptions are separate and must never be used as class allowlists.

## Completion criteria

- The exact `eslint-plugin-schema-domain-check` template exists at repository root.
- `package.json` contains the exact local file dependency.
- The active ESLint configuration registers `schema-domain-check`.
- No ESLint config, package script, or inline rule invocation supplies an `allowlist` option for `schema-domain-check/domain-class-implements-schema-generated-type`.
- `lint:schema-domain-check` uses the actual exported rule name.
- Every eligible class is connected to the correct generated root type.
- Every eligible interface/type alias has an equivalent compile-time check.
- Every repository enum/enum-like declaration has an explicit owner/classification/action, and every shared business enum is Domain-owned or explicitly blocked with evidence.
- Enum centralization introduces no new circular dependency.
- Every schema-backed enum has one explicit outcome:
  - safely migrated const object with exact generated-union checking;
  - retained enum with named exact assertion and documented evidence;
  - blocked with a named remediation;
  - or documented as not Schema-backed.
- Identity enum objects use `{ [K in GeneratedType]: K }` and cannot swap keys and values.
- Alias-key enum objects use an exact two-way equality assertion.
- Numeric or heterogeneous enum decisions include runtime evidence.
- Exactness checks exist where the contract forbids extra data fields.
- Domain imports use the Domain-internal generated barrel and type-only syntax; no emitted Domain declaration requires a separate generated package.
- Plugin lint, normal lint, typecheck, tests, and build pass.
- Re-running the skill creates no new diff.

## Report

Return:

1. Plugin files copied
2. Dependency and lockfile changes
3. ESLint configuration and exact rule name
4. Mapping used
5. Class integrations
6. Enum eligibility decisions
7. Const-object enum migrations
8. Retained enum assertions and exception evidence
9. Interface/type-alias assertions
10. Exactness checks
11. CI commands
12. Validation evidence
13. Blocked items and reasons
14. Final status
