# Wire schema rules

Kafka Schema is a Draft-07 **payload** schema for the serialized message. It is not an OpenAPI request wrapper and not a Domain DTO schema.

## File

- Directory: repo’s kafka schema root, usually `src/schemas/kafka/`.
- Name: `kebab-case-of-ctor-kafka.schema.json` (`FooCreated` → `foo-created-kafka.schema.json`).
- `$id` / `title`: stable; `title` is the MessageCtor name when the repo uses titles that way.
- `description` should say it is a Kafka wire payload after the repo’s serializer.

## Shape

- Root `type: "object"` for an object message.
- `additionalProperties: false` unless the live payload demonstrably allows extras.
- No `requestBody`, `content`, `parameters`, `in`, or media-type wrappers unless the enforcement library requires them (prove from library source).
- No cross-file `$ref`. Same-file `definitions` / `#/definitions/...` are allowed.
- Do not `$ref` Common, Data, or Domain schemas. Wire shape diverges (`_typ`, dates as strings).

## Serialization facts

Author properties from a serialized fixture, not from the TypeScript class:

| Domain / runtime | Typical wire |
|---|---|
| class / nested DTO | object plus `_typ` const = serializer type name |
| `Date` | `string` + `format: date-time` (only if serializer emits ISO strings) |
| string timestamp already | keep `string`; add `format` only if already validated that way |
| optional / `undefined` | omit from `required`; omit property if serializer drops it |
| `null` | only if the fixture actually contains `null` |
| enum / const object | JSON `enum` of **wire strings**, not the const-object shape |
| field stripped before send | do not include it (deleted/partial payloads) |

`_typ`, when present, uses `"type": "string", "const": "<exact serialized value>"`. Nested serialized objects get their own `_typ` if the fixture has them.

The 4th argument to `sendWithSchema` (MessageCtor) drives `_typ` and `jsonSchema`. The 3rd argument may be a different runtime class or a plain object. Schema the **serialized 3rd argument under the 4th ctor**, not `payload instanceof ctor`.

## Attachment

```ts
export class ExampleCreated extends ApiExampleCreated {
  static readonly jsonSchema = ExampleCreatedKafkaSchema;
}
```

Load JSON at module init via the repo loader. Do not inline a second copy of the schema in TypeScript.

## What not to do

- Run `generate:types` on kafka files.
- Copy a Domain schema and add `_typ` without a serialize fixture.
- Share `$ref` between a Domain schema and a kafka wire schema.
- Change producer payload fields to make an easier schema.
