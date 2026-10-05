# Type generation

## Inputs and outputs

Generate only:

```text
src/schemas/common/**/*.schema.json
src/schemas/data/**/*.schema.json
```

Never generate from requests or Kafka.

Preserve the repository's established generated layout. For the common flat layout:

```text
src/domain/generated/*.schema.d.ts
src/domain/generated/index.ts
```

## Common-to-data generated references

A source data Schema keeps a normal JSON Schema ref:

```json
{ "$ref": "../common/blacklist-reason.schema.json" }
```

Generation must not repeatedly expand that common contract into every data declaration.

Required sequence:

1. Generate common declarations.
2. Map each common source file to its generated module and root type.
3. Create temporary copies of data schemas.
4. Replace each data-to-common `$ref` in the temporary copy with:

```json
{ "tsType": "import(\"./blacklist-reason.schema\").BlacklistReason" }
```

5. Generate data declarations from the temporary copies.
6. Delete temporary files.
7. Never write those local generated imports into source Schema.

## External `tsType`

Source Schema may use:

```json
{ "tsType": "import(\"@external/package\").TypeName" }
```

only when all are true:

- the package is genuinely externally published;
- it is declared in dependencies or devDependencies as appropriate;
- the subpath resolves during source, build, and consumer typechecking;
- the Schema still describes runtime validation correctly;
- no current-repository or workspace-local type is referenced.

`tsType: "Date"` is a special case and is allowed only when the existing Domain property is already a runtime `Date`. Do not introduce conversion.

## Root exports

Generate a public barrel with selective root exports:

```ts
export type { BlacklistReason } from "./blacklist-reason.schema";
export type { CreateBlacklistRequest } from "./create-blacklist-request.schema";
```

Never use `export *`.

Fail on:

- duplicate root type names;
- duplicate output filenames;
- missing generated root type;
- stale barrel entries;
- partial generation;
- unresolved common mapping;
- unintended type degradation.

Local JSON Schema refs may normally be inlined or redeclared by the generator. The strict architecture avoids repeated common redeclaration by using the temporary import transformation above.
