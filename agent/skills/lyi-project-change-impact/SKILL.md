---
name: lyi-project-change-impact
description: Assess how a Change Manifest, dependency change, code diff, configuration change, API/schema change, runtime change, or infrastructure change affects a repository. Use to trace real references and call paths, validate trigger conditions, score technical/business risk, identify test gaps, and recommend rollout or rollback actions.
---

# Project Change Impact

## Step 1 — Lock scope and inputs

**Action**
Identify repository root/workspace, change source, before/after state, deployment target, runtime version, and missing evidence.

**Complete when** the analysis scope is explicit.

**If blocked** do not infer a missing before state from current code.

## Step 2 — Validate the change list

If a Change Manifest exists, confirm dependency name/versions and facts against project files where possible. Otherwise derive a provisional change list and label it provisional.

**Complete when** every `CHANGE-*` is accepted, rejected, or marked context-conflict.

## Step 3 — Build the reference map

Search direct and indirect usage: imports/re-exports, wrappers, adapters, factories, DI, config/env/defaults, schemas, type-only/generated code, tests/mocks, build/deploy, package exports, plugins, reflection, string registration, and runtime loading.

**Complete when** each change has candidate usage evidence or a documented absence/gap.

## Step 4 — Trace reachable paths

For each candidate:

```text
Change
→ use/wrapper/config
→ internal component
→ downstream service/topic/queue/database/API/user flow
→ technical observable
→ business consequence
```

**Complete when** every confirmed path has evidence for each material hop.

**If blocked** stop at unresolved dynamic/runtime hops and mark the rest unknown/possible.

## Step 5 — Evaluate trigger conditions

Assign exactly one: `applicable`, `not-applicable`, `conditionally-applicable`, `unknown`, `context-conflict`.

**Complete when** every change has one status and reason.

## Step 6 — Compare effective behavior

Check overrides, transforms, caught/remapped errors, normalization, idempotency, retries, adapters, and isolation from library defaults.

**Complete when** project behavior is distinguished from dependency/default behavior.

## Step 7 — Evaluate risk and test quality

Inspect compile/type, runtime, recovery, data/schema, concurrency/order/retry/timeout/duplication, performance, lifecycle, security, observability, mixed-version deployment, rollback, and business outcomes. Inspect whether tests use mocks, bypass changed code, compile only, or resolve the wrong version.

Read `references/risk-assessment-model.md` before scoring.

**Complete when** every medium/high/critical risk maps to a concrete verification.

## Step 8 — Define release criteria

For each material risk define test/check, expected signal, PASS, FAIL, rollout guard, and rollback action. Choose one recommendation from the allowed decision set in `references/impact-report-schema.md`.

**Complete when** release recommendation is evidence-backed.

**If blocked** use `insufficient-evidence`.

## Step 9 — Produce and validate report

Create `impact-report.yaml` using `references/impact-report-schema.md`, then run:

```bash
python scripts/validate_impact_report.py impact-report.yaml
```

**Complete when** validator exits 0.

## Output

Return `impact-report.yaml` plus a Markdown report covering baseline, evidence, applicability, impact paths, risk, verification, deployment/rollback, blockers, recommendation, confidence, and unresolved questions.

Finding an import proves usage, not impact. A passing build or unit test does not prove runtime compatibility. Never fabricate execution or production evidence.
