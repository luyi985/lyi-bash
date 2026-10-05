---
name: static-schema-preflight
description: Perform a read-only progress and readiness audit for a repository adopting the strict static-schema architecture. Use before, between, and after the builder, coverage, and generated-type-enforcer stages to inspect schema categories, generation scripts, build packaging, domain coverage, generated type quality, TypeScript integration, installation of the approved eslint-plugin-schema-domain-check local package, and CI enforcement, then report stage status plus GO, GO_WITH_REMEDIATION, or NO_GO without modifying production files.
---

# Static Schema Preflight

Use this skill as the read-only controller for the static-schema workflow.

## Request Schema boundary

Ignore `src/schemas/requests/**` completely. Do not inspect, assess, validate, or report on request Schemas. Request contracts are owned exclusively by `request-schema-contract`.

Do not modify repository files. Do not present missing evidence as success.

- Never change existing application logic or the behavior/contracts of downstream clients, APIs, services, consumers, serializers, persistence, events, or integrations. Stop and report when a schema/tooling change cannot be proven behavior-neutral.

## Stages assessed

Assess four stages independently:

```text
Builder      -> schemas, generator, npm scripts, build assets
Coverage     -> Domain symbol -> Schema -> Generated type correctness
Enforcement  -> approved ESLint plugin, implements/type assertions, and CI rules
Overall      -> safe readiness across all stages
```

Read [references/target-architecture.md](references/target-architecture.md) before assessing boundaries. Read [references/progress-rubric.md](references/progress-rubric.md) before assigning statuses.

## Workflow

1. Discover repository roots and tooling.
2. Run the bundled structural checker:

```bash
node scripts/check-schema-progress.mjs <repository-root>
```

3. Inspect evidence the checker cannot prove:
   - runtime validation and serialization behavior;
   - Domain-to-Schema field equivalence;
   - enum wire values, migration eligibility, retained-enum assertions, and Date/DateTime semantics;
   - external `tsType` ownership and missing external-type mappings;
   - class/interface integration with generated types;
   - component, Kafka, build, package-publication, and consumer tests;
   - Domain-contained generated output under `src/domain/generated/**`, absence of a separate generated-package dependency, and a clean consumer typecheck with the Domain package alone; repository-wide enum ownership/centralization coverage and circular-dependency evidence.
4. For Enforcement, verify the exact approved local package:
   - repository-root `eslint-plugin-schema-domain-check/package.json` and `index.cjs`;
   - `file:eslint-plugin-schema-domain-check` devDependency;
   - actual exported rule `domain-class-implements-schema-generated-type`;
   - active ESLint registration or dedicated lint script;
   - absence of obsolete `require-implements-generated` rule usage;
   - absence of any `allowlist` option for `schema-domain-check/domain-class-implements-schema-generated-type`;
   - complete Domain/DTO inventory and a Data Schema for every eligible JSON-shaped type; complete repository-wide enum inventory with an explicit owner/action for every enum;
   - all repository schema-related `.mjs` tooling located under `scripts/`, with no active schema tooling under `tools/`;
   - npm and CI commands updated to reference `scripts/...` paths; enum enum ownership check are present when enum centralization is enabled.
5. Build a stage report.
6. Recommend exactly one next skill:
   - `static-schema-builder`
   - `static-schema-coverage`
   - `generated-type-enforcer`
   - none, when complete

## Hard safety rules

- Treat `plug/` as read-only.
- Do not propose runtime behavior changes as schema cleanup.
- Preserve payloads, validation, serialization, defaults, coercion, errors, optional/null semantics, constructors, methods, side effects, enum wire values, enum runtime/public API behavior, enum ownership and module dependency direction, and Date handling.
- A lack of tests or unclear ownership is evidence, not permission to guess.
- Do not let a generated `.d.ts` prove its own source Schema is correct.
- Do not accept a newly invented ESLint plugin as equivalent when the approved `eslint-plugin-schema-domain-check` template is required.
- The plugin only guards eligible exported classes; it does not replace coverage, enum eligibility decisions, retained-enum assertions, or exact compatibility checks.
- Any schema-domain-check class allowlist is prohibited. Do not accept per-class bypasses as remediation or completion evidence.

## Required report

Use this exact structure:

```text
Overall: GO | GO_WITH_REMEDIATION | NO_GO

Builder:
  Status: COMPLETE | IN_PROGRESS | NOT_STARTED | BLOCKED
  Evidence:
  Gaps:

Coverage:
  Status: COMPLETE | IN_PROGRESS | NOT_STARTED | BLOCKED
  Covered: <n>/<n eligible symbols>
  Exclusions: <n>
  Evidence:
  Gaps:

Enforcement:
  Status: COMPLETE | IN_PROGRESS | NOT_STARTED | BLOCKED
  Plugin package:
  Rule:
  Evidence:
  Gaps:

Runtime safety:
  Evidence:
  Unknowns:

Next skill: <name or none>
Required remediation:
```

## Decision

Return exactly one overall decision:

- `GO`: all hard checks pass, all eligible Domain contracts are covered, the approved plugin and complementary enforcement are active, and behavior-preservation evidence is adequate.
- `GO_WITH_REMEDIATION`: the architecture is safely repairable without runtime behavior change, but named work remains.
- `NO_GO`: safe migration requires changing `plug/`, ownership is unresolved, current behavior cannot be represented safely, or required runtime semantics cannot be preserved.

Project incompleteness alone is not `NO_GO`.
