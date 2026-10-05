# Handler field coverage

Do not equate "not directly read" with "unused".

## Search order

Trace each field through:

1. direct property access;
2. destructuring and aliases;
3. object spread or whole-object pass-through;
4. mapper/normalizer/validator helpers;
5. middleware-populated request values;
6. service, client, repository, command, or event calls;
7. tests and fixtures;
8. API documentation and generated clients.

## Classifications

- `DIRECT`: handler reads the field explicitly.
- `TRANSITIVE`: field is passed in an object or transformed downstream.
- `VALIDATION_ONLY`: field affects validation or routing but is not consumed as business data.
- `UNKNOWN`: analysis cannot prove usage or non-usage.
- `NOT_FOUND`: broad search found no use, but compatibility has not been approved for removal.

## Mandatory behavior

For `UNKNOWN` and `NOT_FOUND`:

- keep the Schema field unchanged;
- notify the user;
- show search evidence;
- identify existing clients or public API risk;
- recommend a separate deprecation/removal workflow when appropriate.

Never delete, make optional, make required, rename, relocate, or narrow a field based solely on static non-usage.
