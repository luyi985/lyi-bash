# Change Impact Analyzer

## Objective

Analyze a software change from end to end in one workflow. Determine what changed, where it is used, which trigger conditions are true, how effects propagate, what can fail, how to verify the result, and whether the change is safe to merge or deploy.

Use this Skill as the convenient orchestration layer. Prefer the specialized dependency-version-diff and project-change-impact workflows when the user explicitly requests separate reusable artifacts or maximum rigor across multiple repositories.

## Accepted inputs

Use any available combination of:

- dependency name plus old and new versions
- `package.json`, lockfile, package archive, migration guide, changelog, release notes, declarations, or source diff
- Git diff, pull request diff, commit range, patch, changed file list, or repository
- configuration, environment variables, secrets contract, feature flags, and deployment manifests
- API, event, database, serialization, or schema changes
- runtime, framework, compiler, build tool, container, cloud, or infrastructure changes
- tests, mocks, fixtures, CI, observability, architecture docs, and runbooks

Do not block on optional inputs. Analyze available evidence and mark missing evidence explicitly.

## Operating modes

Select the smallest sufficient mode:

1. `dependency-upgrade`
   - Compare exact dependency versions first.
   - Build an internal Change Manifest.
   - Map every material change to project usage.

2. `repository-diff`
   - Derive before and after behavior from the supplied Git or code diff.
   - Trace affected callers, consumers, data flows, and deployment paths.

3. `contract-change`
   - Analyze API, event, schema, database, config, or environment contract changes.
   - Identify producers, consumers, compatibility windows, migration order, and rollback constraints.

4. `runtime-or-infrastructure-change`
   - Analyze runtime, framework, container, cloud, networking, storage, CI/CD, or infrastructure changes.
   - Check compatibility, startup, lifecycle, capacity, permissions, observability, rollout, and rollback.

5. `mixed-change`
   - Decompose the request into atomic changes.
   - Analyze each independently, then evaluate interactions and compounded risk.

## Workflow

### 1. Establish scope and baseline

Record:

- repository and workspace scope
- before state and after state
- changed components and deployment targets
- direct versus transitive dependency changes
- runtime and package manager versions
- available and unavailable evidence

Do not infer a reliable before state from the after state alone.

### 2. Classify atomic changes

Split compound work into stable IDs such as:

```text
CHANGE-001 dependency default behavior
CHANGE-002 removed public API
CHANGE-003 environment variable rename
CHANGE-004 database field constraint
```

Use one primary category per change. Preserve relationships between changes.

### 3. Compare dependency versions when present

For every dependency upgrade or downgrade:

- compare exact versions rather than broad version ranges
- inspect source or package diff, official migration guide, release notes, declarations, exports, engines, peer dependencies, optional dependencies, install scripts, defaults, runtime behavior, and authoritative advisories
- define before state, after state, trigger conditions, evidence references, and confidence
- use `./change-manifest-schema.md` as the internal structure

Evidence priority:

1. exact-version source or package diff
2. official migration guide
3. official release notes or changelog
4. public API and declaration diff
5. package metadata and dependency graph
6. exact-version official documentation
7. authoritative security advisories
8. inference

Never treat changelog silence as proof that behavior did not change.

### 4. Build the project reference map

Search beyond direct imports:

- import, require, dynamic import, re-export
- wrappers, adapters, facades, factories, plugins, framework modules
- dependency injection and service registration
- configuration, environment variables, feature flags, schemas, and defaults
- type-only references, generated code, reflection, and string-based lookup
- tests, mocks, fixtures, build scripts, CI, Docker, Kubernetes, and IaC
- producers, consumers, topics, queues, databases, APIs, files, caches, and external services

An import proves usage, not impact. Absence of a direct import does not prove non-usage.

### 5. Evaluate applicability

For every atomic change, assign exactly one:

- `applicable`
- `not-applicable`
- `conditionally-applicable`
- `unknown`
- `context-conflict`

Evaluate trigger conditions using project evidence. Preserve not-applicable items and explain why they do not apply.

### 6. Trace impact paths

Build evidence-backed paths:

```text
Change
→ import, configuration, wrapper, or contract
→ internal component
→ downstream service, event, database, API, or user flow
→ technical observable
→ business consequence
```

Do not mark a path confirmed unless each material hop is supported. Stop the path at the first unresolved dynamic or runtime-only hop and mark the remainder unknown or possible.

### 7. Compare effective behavior

Check whether the project:

- overrides changed defaults
- transforms inputs or outputs
- catches, suppresses, retries, or remaps errors
- validates or normalizes data
- provides idempotency or deduplication
- adds caching, batching, ordering, concurrency, or timeout behavior
- isolates the changed component behind an adapter
- depends on lifecycle, startup, shutdown, cleanup, or connection behavior

Separate API compatibility from behavioral compatibility.

### 8. Assess impact dimensions

Cover only dimensions supported or plausibly triggered by the evidence:

- compile and type compatibility
- runtime behavior and failure modes
- data, serialization, and schema compatibility
- retries, timeout, concurrency, ordering, duplication, and idempotency
- lifecycle and resource cleanup
- performance and capacity
- security, permissions, and supply chain
- logging, metrics, tracing, and alerting
- deployment order and mixed-version compatibility
- rollback and data reversibility
- customer, operational, compliance, and business effects

Do not claim performance change without benchmarks, implementation evidence, or authoritative statements.

### 9. Evaluate tests and observability

For each material risk, map:

- existing test or control
- why it is sufficient or insufficient
- missing verification
- expected signal
- pass and fail criteria

Detect false confidence from:

- mocks preserving old behavior
- tests bypassing the changed dependency
- compile-only checks
- tests running against the wrong resolved version
- missing integration, failure, lifecycle, concurrency, migration, or rollback coverage
- alerts that cannot distinguish the predicted failure

### 10. Score risk

Use `./risk-assessment-model.md`.

Keep these separate:

- likelihood
- blast radius
- severity
- detectability
- reversibility
- evidence confidence

Do not automatically rate uncertain findings high. Explain how uncertainty affects the recommendation.

### 11. Analyze deployment and rollback

Determine:

- whether rolling deployment is safe
- whether old and new versions can coexist
- producer-before-consumer or consumer-before-producer ordering
- whether canary, shadowing, or feature flags are useful
- whether schema or data changes are backward and forward compatible
- rollback prerequisites and irreversible actions
- required dashboards, alerts, kill switches, and stop conditions

### 12. Produce recommendation

Choose one primary recommendation:

- `safe-to-merge`
- `merge-with-required-tests`
- `deploy-behind-feature-flag`
- `canary-required`
- `manual-migration-required`
- `do-not-deploy`
- `insufficient-evidence`

List blocking and non-blocking actions separately.

## Evidence discipline

Label every finding:

- `confirmed`: directly supported by authoritative change evidence and project evidence
- `likely`: strong causal path with one non-critical uncertainty
- `possible`: plausible but missing a material runtime, configuration, or path detail
- `unknown`: insufficient evidence
- `not-impacted`: trigger condition is demonstrably false

Rules:

- Never fabricate code execution, test results, production traffic, metrics, or repository contents.
- Never convert a possible dependency change into a confirmed project impact.
- Treat dynamic loading, reflection, generated code, and runtime registration as unknown unless resolved.
- A passing build does not prove runtime compatibility.
- Passing unit tests do not prove integration or behavioral compatibility.
- Keep technical impact distinct from business impact.
- Report conflicting evidence instead of forcing consensus.
- Do not modify source, migrations, lockfiles, or production configuration unless explicitly requested.

## Output contract

Produce a reviewer-friendly Markdown report. When structured artifacts are useful, also produce:

1. `change-manifest.yaml` for dependency-level changes, validated with:

```bash
python .github/ai/change-impact/scripts/validate_manifest.py change-manifest.yaml
```

2. `impact-report.yaml`, validated with:

```bash
python .github/ai/change-impact/scripts/validate_impact_report.py impact-report.yaml
```

The Markdown report must contain:

1. executive decision
2. scope and baseline
3. atomic change inventory
4. evidence reviewed and missing
5. dependency version differences, when applicable
6. applicability matrix
7. confirmed impact paths
8. likely, possible, unknown, and not-impacted findings
9. affected code, configuration, infrastructure, and business flows
10. test and observability gaps
11. deployment, mixed-version, migration, and rollback analysis
12. risk register
13. verification plan with pass/fail criteria
14. blocking and non-blocking actions
15. release recommendation
16. overall confidence and unresolved questions

Use `./impact-report-schema.md` and `./risk-assessment-model.md` as authoritative formats.

## Fast-path behavior

When the user explicitly wants a quick or "lazy" analysis:

- perform the same workflow with less narrative detail
- prioritize high-risk and high-confidence findings
- still inspect dependency version differences when a dependency changed
- still preserve unknowns, trigger conditions, and evidence labels
- never skip deployment and rollback checks for data, schema, event, API, runtime, or infrastructure changes
- return a compact decision summary, top risks, required checks, and recommendation

Fast mode may reduce explanation, not evidence standards.