# Coverage method

## Architecture baseline

Apply the explicit Translation Service / Translation API / CMS API Common/Data architecture in `../../static-schema-builder/references/common-data-architecture.md`. This means atomic reference-free Common files, one complete Data root per eligible Domain/DTO type, Data refs only to Common roots, and generation from Common/Data only.

## Eligible symbols

Require coverage for JSON-shaped data contracts:

- classes whose instances are serialized or validated as data;
- object interfaces;
- object type aliases;
- enums and literal unions used in payloads;
- discriminated unions;
- request/response DTOs represented in data schemas;
- imported external data types used as properties.

Every eligible symbol must have a corresponding Data Schema. Missing schemas are coverage failures and must be generated when semantics are provable.

## Valid exclusions

Exclude only with evidence:

- services and repositories;
- callbacks and function types;
- validators and guards;
- framework request/response objects;
- classes whose runtime identity or methods are the contract rather than JSON data;
- opaque non-JSON values.

A type is not excludable merely because it is difficult to model.

## Exact comparison

For each property compare both directions:

1. Domain values accepted by the type must be representable by the Schema.
2. Values accepted by the Schema must fit the Domain type.

Check inherited properties explicitly. Do not use `allOf` to reproduce TypeScript inheritance; flatten the effective property set in the data Schema.

## Required and optional

- `property?: T` is optional.
- `property: T | undefined` is not automatically equivalent to omission; inspect runtime usage and compiler settings.
- `property: T | null` requires explicit null semantics.
- Do not infer required fields from constructors alone when deserialization bypasses constructors.

## Additional properties

`additionalProperties: false` is correct only when runtime validation rejects unknown fields or the contract requires exact payloads.

An open object is correct only when the Domain type has an index signature or equivalent open shape.

## Evidence order

Prefer:

1. source Domain declarations;
2. runtime validators and serializers;
3. tests and fixtures;
4. generated declarations;
5. naming inference.

Generated output is last because it is derived from the Schema being audited.
