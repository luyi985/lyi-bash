# Domain-contained generated declarations

## Goal

Publish one self-contained Domain contract package. Generate Common/Data declarations directly under the Domain source tree, normally:

```text
src/domain/generated/**
```

Do not publish or require a separate `@scope/generated` package. FE and other consumers should need only the Domain package for public data contracts.

## Generator output

Set the generator output root to the active published Domain root plus `/generated`. For a conventional repository:

```text
src/domain/generated/*.schema.d.ts
src/domain/generated/index.ts
src/domain/generated/schema-generation-manifest.json
```

If the published Domain root is repository-specific, discover it from package exports/bundling and use `<domain-root>/generated`; do not fall back to a separate top-level generated package.

## Dependency rules

- Hand-written Domain files may use type-only imports from their internal `generated` directory.
- Generated declarations may import other generated declarations in the same Domain package.
- No emitted Domain `.d.ts` may require a separately published generated package.
- Avoid generated imports from internal service/client packages when the referenced type is actually part of the public Domain contract. Migrate ownership into Domain only with behavior-preservation evidence.
- Third-party or genuinely external public types may remain dependencies when product ownership requires them; report them explicitly.

## Build/package verification

Verify all of the following:

1. `generate:types` writes to `src/domain/generated/**`.
2. No active `src/generated/**` output remains.
3. Domain package build/bundle includes the generated declarations.
4. Domain source imports resolve inside the same package after publishing.
5. A clean consumer can install/link only the Domain package and typecheck representative imports.
6. No package metadata or emitted declaration refers to a removed generated sibling package.
7. Re-running generation creates no diff.

## Runtime safety

Generated declarations are type artifacts. Do not add runtime side-effect imports merely to satisfy dependency discovery. Do not change handler, client, service, serializer, Kafka, persistence, or API behavior to make packaging pass.
