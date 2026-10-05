# Change Manifest Schema

## Required top-level structure

```yaml
schema_version: "1.0"
generated_at: "ISO-8601 timestamp or unknown"
dependency:
  ecosystem: npm
  name: package-name
  from_version: 1.0.0
  to_version: 2.0.0
  upgrade_kind: major
baseline:
  exact_versions_verified: true
  notes: []
evidence:
  - id: EVIDENCE-001
    type: source-diff
    authority: official
    reference: "tag v1.0.0..v2.0.0"
    scope: "src/client.ts"
    limitations: []
changes:
  - id: CHANGE-001
    title: "Concise change title"
    category: default-behavior
    component: "Producer retry configuration"
    before:
      summary: "Old behavior"
      contract: null
    after:
      summary: "New behavior"
      contract: null
    trigger_conditions:
      - "Consumer does not explicitly configure retry count"
    consumer_observables:
      - "Longer retry duration"
    compatibility:
      source: compatible
      binary: unknown
      runtime: conditionally-compatible
      data: not-applicable
    severity_hint: medium
    evidence_status: confirmed
    evidence_refs:
      - EVIDENCE-001
    verification_notes:
      - "Confirm implementation path in consuming project"
    limitations: []
unknowns:
  - id: UNKNOWN-001
    question: "Memory impact under sustained load"
    reason: "No benchmark or implementation evidence"
conflicts: []
summary:
  total_changes: 1
  confirmed: 1
  likely: 0
  possible: 0
  unknown: 0
```

## Allowed categories

- `api-added`
- `api-removed`
- `api-renamed`
- `signature-change`
- `type-contract`
- `default-behavior`
- `error-behavior`
- `data-format`
- `serialization`
- `concurrency`
- `performance`
- `lifecycle`
- `security`
- `observability`
- `runtime-compatibility`
- `module-system`
- `dependency-graph`
- `configuration`
- `deprecation`
- `documentation-only`
- `other`

## Compatibility values

Use one of:

- `compatible`
- `incompatible`
- `conditionally-compatible`
- `not-applicable`
- `unknown`

## Severity hint

This is dependency-level potential severity, not project risk:

- `critical`
- `high`
- `medium`
- `low`
- `informational`
- `unknown`

## Evidence rules

Every `confirmed`, `likely`, or `possible` change must reference at least one evidence item. `confirmed` requires exact-version or authoritative evidence. `possible` must describe the inference in `limitations`.