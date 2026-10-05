# External types and generated degradation

## External `tsType`

Allowed source Schema form:

```json
{
  "tsType": "import(\"@published/package/subpath\").ExternalType"
}
```

Require evidence that:

- this is a genuine externally published package;
- the dependency and subpath resolve;
- build and downstream declaration consumers can resolve it;
- the JSON Schema runtime keywords still describe the actual value;
- the external type does not hide a current-repository contract.

Prohibit source `tsType` references to:

- current repository paths or aliases;
- generated local modules;
- sibling workspaces;
- monorepo-local packages.

The builder's temporary data-to-common generated import is an internal generation mechanism and is not written to source Schema.

## Degradation patterns

Review generated declarations containing:

```ts
any
unknown
{}
object
[k: string]: unknown
Record<string, unknown>
```

These are defects when the Domain type is more precise.

Also inspect:

- missing required properties;
- arrays becoming `unknown[]`;
- enum becoming `string`;
- union branches collapsing;
- external imports resolving to `any`;
- duplicate helper types masking a wrong common mapping.

Approve an open type only with direct evidence that the Domain contract is intentionally open.


## Missing external `tsType` detection

For every Domain property, resolve the declaration owner of its TypeScript type. When the owner is a genuine external service/library package and the API value is the same plain-data contract, require the matching Schema property to contain:

```json
{
  "tsType": "import(\"@published/package/subpath\").ExportedType"
}
```

Use the original exported type name, not a local import alias. Follow namespace imports and re-exports to the final external declaration owner.

Report `EXTERNAL_TYPE_TSTYPE_MISSING` when an external Domain property is represented only as a weak object such as `type: object`, `additionalProperties: true`, `{}`, `unknown`, or an otherwise unrelated local shape.

Do not mechanically add `tsType` when the external runtime type is serialized to a different API wire representation, such as a class or timestamp wrapper serialized as a string. In that case require an explicit evidence entry in:

```text
reports/static-schema-external-wire-shape-exceptions.json
```

Each entry must name the Domain symbol, property, external owner, Schema pointer, wire shape, serializer/validator evidence, and reason. Missing evidence is not an exception.
