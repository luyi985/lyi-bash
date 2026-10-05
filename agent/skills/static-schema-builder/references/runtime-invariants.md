# Runtime invariants

Do not inspect or modify `src/schemas/requests/**`; it is owned by `request-schema-contract`.

Schema migration is not a runtime redesign.

Preserve:

- API input and output shapes;
- validation acceptance and rejection;
- error types, messages, and status behavior;
- coercion and defaults;
- required, optional, and null semantics;
- constructors, methods, decorators, and side effects;
- serializers and deserializers;
- Kafka payloads and `_typ` values; Kafka schemas remain serialized-message payload schemas and are not converted into HTTP request wrappers;
- enum values and casing;
- Date/string runtime identities and formats.

## Date rule

Do not infer runtime `Date` from a field name.

Existing string:

```ts
createdDateTime: string;
```

remains a string Schema, optionally with the existing `date-time` format.

Existing runtime Date:

```ts
createdDateTime: Date;
```

may use a string runtime Schema plus `tsType: "Date"` only when current validation and serialization already behave that way. Add no conversion.

## Characterization evidence

When behavior is unclear, add or inspect tests before editing:

- accepted and rejected payload fixtures;
- serializer snapshots;
- Kafka producer payload fixtures;
- component/API tests;
- Date and enum edge cases.
