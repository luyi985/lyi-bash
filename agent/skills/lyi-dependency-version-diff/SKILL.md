---
name: lyi-dependency-version-diff
description: Compare two exact versions of a dependency and produce an evidence-backed reusable Change Manifest. Use for npm/pnpm/yarn packages, frameworks, SDKs, compilers, toolchains, or runtimes before repository-specific impact analysis. Focuses on dependency facts, trigger conditions, compatibility, and evidence without claiming a consuming project is affected.
---

# Dependency Version Diff

## Step 1 — Confirm exact baseline

**Action**
Capture ecosystem, dependency name, exact old version, exact new version, direct/transitive context when known, and whether either version is prerelease/deprecated/unsupported when evidenced.

**Complete when** the exact comparison pair is unambiguous.

**If blocked** request only the missing version fact; do not compare ranges as though they were exact resolved versions.

## Step 2 — Collect evidence in authority order

Use this order:
1. exact-version source/package diff;
2. official migration guide;
3. official release notes/changelog;
4. exported API/declaration diff;
5. package metadata/exports/engines/peer/optional/install scripts;
6. exact-version official docs;
7. authoritative advisories;
8. inference.

**Complete when** every material claim references evidence or is explicitly unknown.

**If blocked** preserve unavailable evidence as a gap. Never promote inference to confirmed.

## Step 3 — Compare package structure

Inspect metadata, entry points, ESM/CJS, engines, peer/optional/transitive dependencies, native/install behavior, and evidenced ownership/license changes.

**Complete when** structural changes are either recorded or explicitly checked with no material difference found.

## Step 4 — Compare public contracts

Inspect added/removed/renamed exports, signatures, constructors/methods, type narrowing/widening, return/error contracts, config keys/defaults/validation, and deprecations.

**Complete when** each material contract change has before, after, and trigger condition.

## Step 5 — Compare runtime behavior

Inspect defaults, retry/timeout/batching/order/concurrency/cache/pool behavior, serialization/data format, lifecycle/cleanup, observability, security/validation, and performance only when evidence supports it.

**Complete when** each material runtime change states what a consumer must do for it to matter.

## Step 6 — Classify and label confidence

Use one category from `references/change-manifest-schema.md`.
Assign one evidence status: `confirmed`, `likely`, `possible`, `unknown`.

**Complete when** every material change has a stable `CHANGE-*` ID, category, trigger conditions, evidence refs, compatibility, and severity hint.

**If blocked** use `unknown`; do not invent project impact.

## Step 7 — Produce and validate the manifest

Generate `change-manifest.yaml` using `references/change-manifest-schema.md`, then run:

```bash
python scripts/validate_manifest.py change-manifest.yaml
```

**Complete when** validator exits 0.

**If blocked** report validation errors and do not call the manifest complete.

## Output

Return:
1. `change-manifest.yaml`;
2. concise Markdown summary of baseline, evidence, breaking changes, behavioral changes, compatibility/dependency/security changes, likely/possible items, unknowns, and evidence gaps.

Do not include repository-specific business impact unless explicitly asked for combined analysis.
