---
name: lyi-kafka-outbound-schema
description: Audit, author, and repair Playbook outbound Kafka wire-schema validation. Use when adding a producer message, fixing publish-time AJV failures, wiring static jsonSchema, sendWithSchema, Kafka.producerEnforceSchema, src/schemas/kafka/*-kafka.schema.json, domain loadSchemaJson, copy-domain-schema-json, or consumer npm E404 on unpublished @…/schemas. Applies the same method in any Playbook repo. Kafka schemas are runtime-only and never generate TypeScript declarations.
---

# Kafka Outbound Schema

Method for Playbook producer-enforcement. Discover the current repository. Do not copy another service’s class names, topics, DTO fields, paths, or catch policy.

Do not use this skill for Common/Data type generation, Domain `implements`, or HTTP request Schemas. Hand those to `static-schema-builder`, `static-schema-coverage`, `generated-type-enforcer`, and `request-schema-contract`.

Read when needed:

- [references/discovery.md](references/discovery.md)
- [references/load-schema.md](references/load-schema.md)
- [references/wire-schema-rules.md](references/wire-schema-rules.md)
- [references/test-contract.md](references/test-contract.md)
- [examples/method.md](examples/method.md)

## Hard rules

1. A Kafka schema validates **serialized JSON**, not the pre-serialization Domain object.
2. Never generate `.d.ts` from kafka schema files.
3. Never invent `_typ`, enum casing, date identity, or nested shape. Establish them from serializer output or library source.
4. Preserve existing payload bytes. Do not “fix” wire values to match Domain types.
5. Attach `jsonSchema` on the **same constructor** passed as the message type to `sendWithSchema` (or the repo’s equivalent).
6. If `@playbook-lib/kafka` is absent, mark producer internals as unconfirmed. Do not guess skip/throw behavior.
7. Do not modify a reference repository. Only change the repo the user opened.
8. Load Kafka JSON through Domain-owned `loadSchemaJson` (`@<project>/domain/load-schema`). Do not make published Domain depend on an unpublished `@<project>/schemas` package.

## Step 1 — Lock mode and inventory

**Action**
Choose one mode: `audit` | `add-message` | `repair`. Discover this repo’s producer/schema/build wiring using [references/discovery.md](references/discovery.md). Record actual paths.

**Complete when** the enforcement call, schema directory, loader, type-generation exclusion, and build copy path are known or explicitly absent.

**If blocked** report the exact searches attempted and stop.

## Step 2 — List outbound contracts

**Action**
For every `sendWithSchema(topic, key, payload, MessageCtor, headers?)` (or equivalent):

- MessageCtor name
- payload construction (class instance vs field bag)
- topic/key/headers source
- existing `static jsonSchema`
- catch/rethrow policy at each caller

**Complete when** every outbound ctor is listed with wiring status: `defined` | `registered` | `instantiated` | `invoked`.

## Step 3 — Capture the wire payload

**Action**
For the target ctor, produce the serialized JSON the producer will validate:

1. Prefer `serializeTypeToJsonStr(ctor, sample, "", SerializerFlags.EnforceSerializing)` when `@playbook-lib/runtime/type-serializer` exists.
2. Else read `KafkaProducer.sendWithSchema` in `node_modules/@playbook-lib/kafka` and match that serializer.
3. Else add a characterization test that serializes a fixture and fails until the schema matches. Do not author `_typ` from the Domain class name alone if serializer evidence is missing.

**Complete when** one accepted JSON fixture exists per target message, including nested objects.

## Step 4 — Author or repair the Kafka schema

**Action**
Write `*-kafka.schema.json` per [references/wire-schema-rules.md](references/wire-schema-rules.md).

Ensure Domain `loadSchemaJson` exists and is wired per [references/load-schema.md](references/load-schema.md):

1. Loader lives in `src/domain/load-schema.ts` with multi-candidate resolve.
2. MessageCtor uses `static readonly jsonSchema = loadSchemaJson("kafka/…-kafka.schema.json")` (or the repo’s established relative path).
3. Pass that same ctor into `sendWithSchema`.
4. Copy Kafka JSON into Domain package targets (`build/domain/kafka` and `build/.bundles/domain/kafka`) via postbuild **and** `bundle:packages` after `generate-packages`.
5. Confirm published Domain `package.json` does **not** depend on `@<project>/schemas`.

If type-generation globs Kafka files, exclude them. If the loader cannot resolve the JSON after build/publish, repair the loader candidates and/or copy script—do not publish a `schemas` package as a workaround.

**Complete when** schema file, Domain load export, ctor attachment, send call, asset copy, and Domain package deps agree.

## Step 5 — Confirm enforcement and failure policy

**Action**
Find `Kafka.producerEnforceSchema` (or equivalent) in env/registry config. Do not enable it globally unless the repo already does, or the user asked to enforce.

For each caller of the producer:

- rethrow → publish fails; caller must observe the error
- swallow → document whether persistence already happened; if catching `KafkaSchemaValidationException`, log `messageType`, `topic`, `key`, `errors`, and a stable `reason`

Do not change an existing catch policy unless the user asked.

**Complete when** flag value per env and each catch path have an observable effect.

## Step 6 — Tests

**Action**
Add or update tests per [references/test-contract.md](references/test-contract.md):

- serialize-then-validate happy path
- at least one invalid fixture per schema
- producer passes ctor + payload into `sendWithSchema`
- validation rejection propagates from producer
- chosen catch-path behavior at the orchestrator

**Complete when** those cases exist or gaps are listed as missing tests.

## Step 7 — Report

Return:

```text
# Kafka Outbound Schema: <repo> (<mode>)

## Conclusion
<complete | conditionally complete | broken | insufficient evidence>

## Inventory
enforcement call | schema dir | Domain loadSchemaJson | generate:types exclusion | postbuild + bundle copy | Domain deps on schemas? | producerEnforceSchema

## Outbound messages
ctor | payload | topic | jsonSchema | send site | catch policy | evidence

## Wire fixtures
ctor | how serialized | _typ values | gaps

## Changes or findings
...

## Tests
...

## Evidence gaps
...
```

Classify each material claim as: confirmed by code; likely but not confirmed; missing runtime evidence; contradiction/broken link.
