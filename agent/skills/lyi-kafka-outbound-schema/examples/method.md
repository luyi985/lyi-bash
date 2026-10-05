# Method shape

Generic layout. Use only what the current repo already has, or create the missing piece in **this** repo’s existing package layout.

## Typical pieces

| Concern | What to find or add |
|---|---|
| Wire schemas | `*-kafka.schema.json` under the repo’s kafka schema root (often `src/schemas/kafka/`) |
| Load | Domain `src/domain/load-schema.ts` → `loadSchemaJson("kafka/…")`; see [../references/load-schema.md](../references/load-schema.md) |
| Ctor | `static readonly jsonSchema = loadSchemaJson(…)` on the MessageCtor passed to `sendWithSchema` |
| Send | producer adapter calls `sendWithSchema(topic, key, payload, MessageCtor, headers?)` |
| Flag | `Kafka.producerEnforceSchema` in env/registry config |
| Domain schemas | separate files; `generate:types` / json2ts must **not** include kafka |
| Asset copy | postbuild **and** `bundle:packages` copy kafka JSON into Domain package paths the loader checks |
| Published deps | Domain must **not** depend on unpublished `@…/schemas` |
| Tests | serialize with Playbook serializer, then `validateSchema(ctor.jsonSchema)` |

## Authoring sequence

1. Serialize a real payload with the producer ctor.
2. Write the kafka schema from that JSON (`_typ`, dates as strings, nested `_typ`).
3. Ensure Domain `loadSchemaJson` exists (create/repair per load-schema reference if missing or single-path).
4. Load + attach + send with that ctor.
5. Copy JSON into the loader’s runtime Domain paths (`build/domain` and `build/.bundles/domain`).
6. Test valid serialize + at least one reject.
7. Verify bundled Domain `package.json` has no `@…/schemas` dependency.

## Usual divergences (do not assume)

- Domain schema and kafka schema are two files when `_typ` / Date wire shape differ.
- MessageCtor on `sendWithSchema` may differ from the runtime payload class or a plain field bag.
- Catch policy (rethrow vs log-and-swallow) is per caller; leave it unless asked to change it.
- Some repos copy data schemas flat into Domain root (bare filenames); others keep `kafka/` / `data/` / `requests/` prefixes—match the repo, do not invent a second convention.
- A `schemas/load-schema` re-export is not required; only keep it if existing call sites still import that path.
