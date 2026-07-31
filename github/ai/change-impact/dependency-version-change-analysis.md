# Dependency Version Diff Analyzer

## Objective

Compare two dependency versions and produce a reusable dependency-level Change Manifest. Describe what changed in the dependency itself. Do not infer that a consuming project is affected unless project evidence is explicitly provided.

## Required inputs

Resolve or request only genuinely missing inputs:

- dependency name
- old version
- new version
- package ecosystem
- available evidence: package archives, source repositories, release notes, migration guides, API docs, declaration files, package metadata, lockfile diff, security advisories

If network or repository access is unavailable, analyze only supplied evidence and mark gaps as unknown.

## Evidence priority

Use sources in this order:

1. source or package file diff between exact versions
2. official migration guide
3. official release notes or changelog
4. exported API and type declaration diff
5. package metadata, exports, engines, peer dependencies, optional dependencies, install scripts
6. official documentation for each exact version
7. security advisories from authoritative sources
8. model inference

Never present inference as confirmed evidence.

## Workflow

1. Establish the exact baseline.
   - Confirm package name, ecosystem, old version, and new version.
   - Distinguish direct upgrade from a range or lockfile resolution change.
   - Record whether versions are prerelease, deprecated, yanked, or unsupported when evidence is available.

2. Collect and normalize evidence.
   - Preserve source identifiers, file paths, URLs or document titles, version tags, and relevant symbols.
   - Record unavailable evidence explicitly.

3. Compare package-level structure.
   - package metadata
   - exports and entry points
   - ESM and CommonJS behavior
   - engine requirements
   - peer, optional, and transitive dependencies
   - native modules and install scripts
   - license or package ownership changes when evidenced

4. Compare public contracts.
   - added, removed, or renamed exports
   - function, class, constructor, and method signatures
   - type narrowing or widening
   - return values and error types
   - configuration keys, defaults, validation, and deprecations

5. Compare runtime behavior.
   - defaults
   - retries, timeouts, batching, ordering, concurrency, caching, pooling
   - serialization and data formats
   - lifecycle, startup, shutdown, and cleanup
   - logging, metrics, tracing, telemetry
   - security and validation behavior
   - performance behavior only when supported by evidence

6. Classify every material change.
   Use one category from `./change-manifest-schema.md`.

7. Define trigger conditions.
   State the exact consumer condition required for the change to matter, such as:
   - return value is consumed
   - default value is not overridden
   - removed export is imported
   - runtime is below the new engine minimum
   - consumer relies on CommonJS loading

8. Assign evidence status.
   - `confirmed`: directly supported by authoritative or exact-version evidence
   - `likely`: strong evidence but a material detail remains unverified
   - `possible`: plausible inference requiring validation
   - `unknown`: insufficient evidence

9. Generate `change-manifest.yaml` using the schema in `./change-manifest-schema.md`.

10. Validate the manifest with:

```bash
python .github/ai/change-impact/scripts/validate_manifest.py change-manifest.yaml
```

11. Produce a concise human-readable summary alongside the manifest.

## Analysis rules

- Separate API compatibility from behavioral compatibility.
- Do not treat successful compilation as runtime compatibility.
- Do not treat absence from a changelog as proof of no change.
- Do not claim performance regression or improvement without benchmarks, implementation evidence, or authoritative statements.
- Include non-breaking behavior changes when they can alter outcomes.
- Preserve unknowns and conflicting evidence.
- Give each material change a stable ID such as `CHANGE-001`.
- Keep project-specific paths and business impact out of this manifest unless the user explicitly asks for a combined analysis.
- Prefer one precise change per entry. Split compound changes when trigger conditions or effects differ.

## Output contract

Produce:

1. `change-manifest.yaml`
2. a Markdown summary containing:
   - baseline
   - evidence reviewed
   - confirmed breaking changes
   - confirmed behavioral changes
   - compatibility and dependency changes
   - security changes
   - likely or possible changes
   - unknowns and evidence gaps

Use `./change-manifest-schema.md` as the authoritative format.