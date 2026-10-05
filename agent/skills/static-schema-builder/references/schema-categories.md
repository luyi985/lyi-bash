# Schema categories

## Common

Common contains reusable atomic leaf contracts.

Requirements:

- One public root contract per file.
- Unique `title`.
- Stable `$id` when IDs are used.
- No `$ref`, `definitions`, or `$defs` anywhere in the file.
- No dependency on another Schema.
- Nested inline fields are allowed when they are intrinsic to the atomic contract.

Good examples:

- string or numeric wire-value enum;
- identifier;
- pagination metadata;
- small reusable value object.

Do not put composite DTOs in common merely because they are shared. If a contract needs another Schema, it belongs in data or should be flattened only when that preserves semantics.

## Data

Data contains compile-time Domain and DTO contracts.

Requirements:

- One root contract per file.
- May use `$ref` only to the root of a file in `../common/`.
- No fragments or JSON Pointers.
- No local `definitions` or `$defs`.
- No data-to-data, request, Kafka, source-code, or URL refs.
- Keep single-use nested structures inline.
- Avoid duplicated reusable shapes; create an atomic common contract when reuse is real and stable.

Allowed:

```json
{ "$ref": "../common/blacklist-reason.schema.json" }
```

Prohibited:

```json
{ "$ref": "#/definitions/reason" }
{ "$ref": "./another-data.schema.json" }
{ "$ref": "../common/models.schema.json#/definitions/reason" }
```

## Requests

`src/schemas/requests/**` is outside this Skill. Do not inspect, create, modify, validate, normalize, delete, or generate from request Schemas. Use `request-schema-contract` for all request-document work.

This exclusion is absolute even when request files appear architecturally inconsistent with Common/Data rules.

## Kafka

Kafka contains runtime validation for serialized producer payloads. Kafka Schema and request Schema are different categories and must not share a forced document structure.

- Name files `*-kafka.schema.json`.
- The entire Kafka file is normally a Draft-07 payload Schema rooted at the serialized message object/value. It is not an OpenAPI request wrapper.
- Validate the exact payload after serialization, not the pre-serialization Domain object or HTTP request metadata.
- Do not add `requestBody`, `content`, `parameters`, `in`, or media-type wrappers unless the existing Kafka enforcement library demonstrably requires such a nonstandard envelope.
- Do not generate declarations from Kafka schemas.
- Do not use cross-file refs.
- Same-file local definitions and local `#/definitions/...` refs are allowed.
- `_typ`, when present in the real payload, uses the exact serialized value and `const`.
- Nested serialized objects must match the actual producer output.
- Establish the contract from the serializer and the value passed to `sendWithSchema()` or the equivalent producer-enforcement call.


## Enum Schema note

An enum Schema remains a primitive literal contract, for example `type: "string"` plus `enum`. Do not model the TypeScript const object itself as a JSON object Schema. AJV validates the serialized enum value. The Domain const-object integration is handled later by `generated-type-enforcer`.
