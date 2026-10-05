# Discovery

Search exact identifiers first. Adapt paths to the repo. Do not assume `src/schemas/kafka` exists.

## Enforcement

```text
sendWithSchema
producerEnforceSchema
KafkaSchemaValidationException
static readonly jsonSchema
```

If `sendWithSchema` is missing, search `send(` on the Kafka producer wrapper and any `validateSchema` / `createValidateFunction` call immediately before produce.

## Schema assets

```text
*-kafka.schema.json
src/schemas/kafka
KAFKA_SCHEMA_DIR
loadSchemaJson
src/domain/load-schema.ts
@*/domain/load-schema
@*/schemas/load-schema
copy-domain-schema-json
```

Record:

- Which package owns the loader (must be Domain for published consumers)
- The loader’s candidate paths (moduleDir, `build/schemas`, `src/schemas`, published Domain files)
- Whether any published package imports `@…/schemas/load-schema` (risk: Domain depends on unpublished `schemas` → npm E404)
- Whether `npmPackages` lists `schemas` (usually should **not**)

If the loader is missing, single-path only, or Domain depends on unpublished `schemas`, follow [load-schema.md](load-schema.md) before attaching `jsonSchema`.

## Generation boundary

Find `generate:types`, `json2ts`, `json-schema-to-typescript`, `scripts/generate-schema-types.mjs`.

**Pass:** generator inputs are Common/Data (or root `src/schemas/*.schema.json`) and Kafka is excluded.

**Fail:** Kafka files are compiled to `.d.ts`, or Domain `implements` a type generated from a `*-kafka.schema.json`.

## Build copy

Find `postbuild`, `bundle:packages`, `copy-domain-schema-json`, or any copy of `*.schema.json` into `build/`.

Required agreement:

1. Copy destination is one of the loader candidates.
2. Kafka JSON lands in Domain package targets used at publish time (`build/domain/…` and `build/.bundles/domain/…` when playbook bundles Domain).
3. `bundle:packages` runs the copy **after** `playbook-cli generate-packages` (postbuild alone is not enough for release tarballs).

A copy to `build/schemas` is useless if the loader only checks `moduleDir/kafka` next to published Domain `load-schema.js`. See [load-schema.md](load-schema.md).

## DI / config

```text
standardKafkaProducerRegistry
KafkaProducer
withService(
configNamespace
Kafka.producerEnforceSchema
Kafka.topicPrefix
```

For each producer wrapper distinguish: `defined`, `registered` (`.withService` or inject graph), `instantiated`, `invoked`.

A class with `static inject` that is only a constructor dependency of a registered consumer is `registered` via the inject graph, not via an explicit `.withService`.

## Library source

When present, read:

- `node_modules/@playbook-lib/kafka/**` — `sendWithSchema`, schema flag, exception type
- `node_modules/@playbook-lib/runtime/type-serializer*` — `_typ`, Date, nested objects
- `node_modules/@playbook-lib/runtime/schema-validation*` — AJV compile/validate

If those packages are not installed, say so. Do not invent skip-vs-throw rules.
