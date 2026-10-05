# Request document format

Use the repository loader as the source of truth. Translation-API-style request documents use OpenAPI/Playbook-shaped wrappers around Draft-07 payload Schemas.

## Body request

For a JSON body, preserve this shape:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://service/requests/create-item-request.schema.json",
  "title": "CreateItemRequest",
  "requestBody": {
    "required": true,
    "content": {
      "application/json": {
        "schema": {
          "type": "object",
          "properties": {},
          "required": [],
          "additionalProperties": false
        }
      }
    }
  }
}
```

The nested `schema` is the payload Schema. The complete request document is not interchangeable with that nested Schema when the loader expects the wrapper.

## Parameter request

Represent query, path, header, and cookie values with `parameters[]`:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://service/requests/get-item-request.schema.json",
  "title": "GetItemRequest",
  "parameters": [
    {
      "name": "itemKey",
      "in": "query",
      "required": true,
      "schema": {
        "type": "string",
        "minLength": 1
      }
    }
  ]
}
```

Preserve `description`, `style`, `explode`, and other loader-supported metadata when present.

## Method defaults

- `GET` and `HEAD`: use `parameters[]` by default. Permit a body only with explicit route, loader, production, and test evidence.
- `POST`, `PUT`, and `PATCH`: use `requestBody.content[mediaType].schema` for body payloads; parameters may coexist.
- `DELETE`: preserve the proven repository contract. Do not add a body from DTO shape alone.

The method is not sufficient by itself. Route registration, handler access, loader behavior, and tests decide the actual location.

## Format prohibitions

Do not:

- flatten a body wrapper;
- wrap a proven pure-payload repository format without evidence;
- move query/path/header values into the body;
- move body fields into `parameters[]`;
- remove external `$ref` support used by the loader;
- apply Common/Data architectural restrictions to request documents unless the request loader itself requires them;
- include request Schemas in generated TypeScript declarations.
