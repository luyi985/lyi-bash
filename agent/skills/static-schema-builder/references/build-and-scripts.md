# Build and scripts

Keep repository schema tooling deliberately small. The target repository toolset is exactly six scripts; do not create one file per check when one checker can own the concern.

```text
scripts/generate-schema-types.mjs
scripts/check-generated-types.mjs
scripts/copy-domain-schema-json.mjs
scripts/check-schema-coverage.mjs
scripts/check-generated-integration.mjs
scripts/check-enum-ownership.mjs
```

## Ownership

- `generate-schema-types.mjs`: generate Common then Data declarations into `src/domain/generated/**`; use temporary generation copies for `$ref` rewrites; replace output only after full success; selective type-only barrel; fail on collisions/duplicate roots.
- `check-generated-types.mjs`: run generation and fail when `src/domain/generated/**` has VCS drift. Do not reverse-map generated filenames to Schema categories when both Common and Data exist.
- `copy-domain-schema-json.mjs`: copy only Schema JSON that the built/published Domain runtime actually needs. Preserve the repository's established build/bundle layout.
- `check-schema-coverage.mjs`: consolidate architecture, Domain/DTO coverage, property semantics, external-type mapping, generated quality, enum/date/union checks.
- `check-generated-integration.mjs`: check Domain classes/interfaces/type aliases against generated roots and exactness rules.
- `check-enum-ownership.mjs`: scan the whole active repo for enum/enum-like declarations, ownership, duplicates, canonical Domain placement, re-exports and import cycles.

Do not retain active schema tooling under `tools/**`. Remove superseded scripts after package.json/CI/docs no longer reference them.

Recommended package scripts:

```json
{
  "generate:types": "node scripts/generate-schema-types.mjs",
  "check:generated-types": "node scripts/check-generated-types.mjs",
  "check:schema-coverage": "node scripts/check-schema-coverage.mjs",
  "check:generated-integration": "node scripts/check-generated-integration.mjs",
  "check:enum-ownership": "node scripts/check-enum-ownership.mjs",
  "postbuild": "node scripts/copy-domain-schema-json.mjs",
  "check:schema-contracts": "npm run check:schema-coverage && npm run check:enum-ownership && npm run check:generated-types && npm run check:generated-integration"
}
```

Adapt command names to the repo when equivalent scripts already exist. Do not replace unrelated build logic.
