---
name: lyi-change-impact
description: Analyze a software change end to end across dependency upgrades, code diffs, API/schema/config/runtime/infrastructure changes, and mixed change sets. Use when asked what can break, which consumers are affected, what tests are required, or whether a change is safe to merge or deploy. Produces evidence-backed applicability, impact paths, risks, verification criteria, and a release recommendation.
---

# Change Impact

Use the smallest sufficient mode: dependency upgrade, repository diff, contract change, runtime/infrastructure change, or mixed change.

## Step 1 — Freeze the baseline

**Action**
- Record repository/workspace scope, before state, after state, changed components, deployment target, runtime/package-manager versions, and evidence available/unavailable.
- Split mixed work into stable IDs: `CHANGE-001`, `CHANGE-002`, ...

**Complete when** every change has a before/after description or is explicitly marked unknown.

**If blocked** do not infer a before state from current code. Mark the missing baseline and continue only with evidence-supported analysis.

## Step 2 — Establish dependency facts when versions changed

**Action**
- Compare exact old/new versions.
- Prioritize exact source/package diff, then official migration docs, release notes, declarations/API, package metadata, official docs, advisories, and finally inference.
- Record trigger conditions and evidence status for each material dependency change.

**Complete when** each dependency change has evidence, trigger conditions, and confidence.

**If blocked** label the item `unknown`; never treat changelog silence as proof of no change.

Read `references/change-manifest-schema.md` when a reusable dependency manifest is needed.

## Step 3 — Build the project reference map

**Action**
Search beyond direct imports: re-exports, wrappers, adapters, factories, DI, registrations, config/env/flags, schemas, type-only references, generated code, tests/mocks, build/CI, deployment, producers/consumers, databases, APIs, queues, files, caches, reflection, and string-based lookup.

**Complete when** every `CHANGE-*` has candidate consumers or a documented reason none can be located.

**If blocked** treat unresolved dynamic loading or runtime registration as unknown.

## Step 4 — Evaluate applicability

Assign exactly one status per change:
- `applicable`
- `not-applicable`
- `conditionally-applicable`
- `unknown`
- `context-conflict`

**Complete when** every change has a status plus evidence for the trigger condition.

**If blocked** use `unknown` or `context-conflict`; do not force a conclusion.

## Step 5 — Trace impact paths

For each applicable or conditional change, trace:

```text
Change
→ direct use/config/wrapper/contract
→ internal component
→ downstream service/event/database/API/user flow
→ technical observable
→ business consequence
```

**Complete when** each confirmed path has evidence for every material hop.

**If blocked** stop at the first unresolved hop and mark the remainder likely/possible/unknown.

## Step 6 — Compare effective behavior

Check overrides, input/output transforms, error handling, retries, normalization, idempotency, caching, batching, ordering, concurrency, timeouts, adapters, startup/shutdown, and cleanup.

**Complete when** the project-specific effective behavior is separated from library/default behavior.

**If blocked** keep API compatibility and runtime compatibility separate.

## Step 7 — Assess risks

Assess only evidence-supported dimensions: compile/type, runtime, errors/recovery, data/schema/serialization, retry/order/concurrency, lifecycle, performance/capacity, security, observability, deployment/mixed-version, rollback, and business effect.

Read `references/risk-assessment-model.md` before assigning a risk rating.

**Complete when** every medium/high/critical risk has likelihood, blast radius, severity, detectability, reversibility, and confidence.

**If blocked** use risk `unknown`; low confidence is not itself high risk.

## Step 8 — Define verification and release criteria

For each material risk, define:
- exact test/runtime check;
- expected signal;
- PASS criterion;
- FAIL criterion;
- rollout guard;
- rollback/stop condition.

Choose one recommendation:
`safe-to-merge`, `merge-with-required-tests`, `deploy-behind-feature-flag`, `canary-required`, `manual-migration-required`, `do-not-deploy`, or `insufficient-evidence`.

**Complete when** the recommendation is traceable to explicit verification evidence.

**If blocked** return `insufficient-evidence` rather than optimistic approval.

## Step 9 — Validate structured artifacts when produced

If producing `change-manifest.yaml`:

```bash
python scripts/validate_manifest.py change-manifest.yaml
```

If producing `impact-report.yaml`:

```bash
python scripts/validate_impact_report.py impact-report.yaml
```

Fix validation failures before claiming completion.

## Output

Return a concise reviewer report with:
1. decision;
2. baseline and atomic changes;
3. evidence and missing evidence;
4. applicability matrix;
5. confirmed/likely/possible/unknown/not-impacted paths;
6. risks;
7. verification with PASS/FAIL criteria;
8. deployment and rollback;
9. blocking/non-blocking actions;
10. recommendation and confidence.

Never fabricate test execution, runtime metrics, production behavior, or repository contents. Compilation and unit tests alone do not prove behavioral compatibility.
