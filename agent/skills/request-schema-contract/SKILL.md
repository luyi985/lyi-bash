---
name: request-schema-contract
description: Audit, restore, create, and verify runtime request Schemas under src/schemas/requests for TypeScript APIs that use Translation-API-style OpenAPI/Playbook request documents. Use when request wrappers were flattened, request Schemas are missing, handler fields may be uncovered or unused, or body/query/path/header validation must be matched to routes and handlers without changing existing API, client, service, validation, or downstream behavior.
---

# Request Schema Contract

Own only runtime request Schemas under `src/schemas/requests/**` and the evidence needed to verify them.

Do not modify Common, Data, Kafka, generated declarations, Domain types, handlers, clients, services, routes, serializers, middleware, or business logic to make a Schema pass.

Read:

- [references/request-document-format.md](references/request-document-format.md)
- [references/handler-coverage.md](references/handler-coverage.md)
- [references/runtime-safety.md](references/runtime-safety.md)

## Hard rules

1. Preserve all existing runtime and public behavior. Never change request payload shape, accepted values, defaults, coercion, error status/body, media types, route semantics, handler behavior, client behavior, service behavior, downstream contracts, serialization, or side effects unless the user explicitly approves a separately reported behavioral change.
2. Treat `plug/` as read-only.
3. Restrict edits to `src/schemas/requests/**` and request-schema reports/tests unless the user explicitly authorizes another file.
4. Use the repository's actual request loader and Translation-API-style document structure as the format authority. Do not infer format from DTO shape alone.
5. Do not flatten `requestBody.content["application/json"].schema` into the document root.
6. Do not convert `parameters[]` into a body Schema or a body Schema into `parameters[]` merely for consistency.
7. Never generate TypeScript declarations from request Schemas.
8. Never delete or narrow a request field merely because direct handler usage is not found. Report it to the user with evidence and leave the field unchanged.
9. Before adding a missing request Schema, inspect every API route and handler, including middleware and delegated validators, to determine method, location, requiredness, and runtime extraction path.
10. A newly added or tightened Schema must not reject any request currently accepted and relied on by an existing client or downstream integration. When compatibility cannot be proven, stop and report the risk instead of changing the Schema.
11. Place every repository request-schema `.mjs` utility under repository-root `scripts/`. Migrate active request-schema tooling out of `tools/` and update package scripts, CI, imports, tests, and documentation atomically; do not keep active duplicates.

## Workflow

### 1. Discover request execution paths

Inspect all route registrations, controllers, handlers, middleware, request validators, Schema loaders, and tests. Build a route inventory containing:

```text
HTTP method | route | handler | body/query/path/header/cookie reads | current Schema | loader extraction path
```

Do not inspect only filenames. Follow aliases, wrappers, middleware, helper functions, and handler delegation.

### 2. Establish the document format

Determine how production code loads request documents. For Translation-API-style repositories:

- body payloads live under `requestBody.content[mediaType].schema`;
- query/path/header/cookie values live in `parameters[]`;
- the request document root is not itself the AJV payload Schema;
- external `$ref` behavior is preserved exactly when supported by the loader.

Apply the detailed rules in `references/request-document-format.md`.

### 3. Audit field usage without deleting

For every field represented by a request Schema:

- trace direct reads such as `req.body.x`, `req.query.x`, `req.params.x`, and `req.headers.x`;
- trace destructuring, aliases, spread, object pass-through, mapper functions, middleware, and service/client calls;
- classify usage as `DIRECT`, `TRANSITIVE`, `VALIDATION_ONLY`, `UNKNOWN`, or `NOT_FOUND`.

For `UNKNOWN` or `NOT_FOUND`, notify the user and preserve the field. Do not remove it automatically.

### 4. Audit coverage

For every handler input that participates in request processing, verify that the request document covers the correct location and semantics:

- property name;
- body/query/path/header/cookie location;
- required versus optional;
- nullable behavior;
- arrays and nested objects;
- enum/const values;
- string and numeric constraints;
- defaults and coercion expectations;
- `additionalProperties` behavior;
- supported media type;
- external `$ref` resolution;
- validation error behavior.

Do not add constraints that are not already proven by handler code, existing validators, tests, API documentation, or established repository conventions.

### 5. Create missing request Schemas

When a route/handler has no request Schema:

1. Prove the handler's full input contract from route, handler, middleware, tests, clients, and existing validation.
2. Select the correct body or `parameters[]` representation.
3. Create a Translation-API-compatible request document.
4. Preserve current acceptance behavior; do not silently tighten validation.
5. Add or update request-validation tests where the repository already has an established test pattern.
6. Do not add the request Schema to generated type tooling.

Stop and report ambiguity when the full contract cannot be proven.

### 6. Restore damaged request Schemas

When an older tool flattened or otherwise changed a request document:

- recover wrapper/location structure from loader code, handler access, tests, Git history, and equivalent repository examples;
- retain the latest legitimate payload constraints;
- restore only the proven request-document structure;
- do not blindly revert an entire historical file when later payload changes may be valid.

### 7. Validate

Run the repository's real request loader and validation tests. Verify at minimum:

- every body Schema is extracted from the expected nested node;
- every parameter has the correct `name`, `in`, `required`, and `schema`;
- GET/HEAD do not gain a body without explicit runtime evidence;
- POST/PUT/PATCH body requests retain their wrapper;
- DELETE preserves its proven existing contract;
- no request Schema participates in generated declaration output;
- a second run is idempotent;
- no non-request production file changed.

## Required output

Write:

```text
reports/request-schema-contract.md
```

Include:

```text
Route | Handler | Method | Input location | Schema | Format status | Field coverage | Compatibility evidence | Action
```

For unused or uncertain fields, include a visible section:

```text
User review required
- Schema field
- Route and handler
- Usage classification
- Search evidence
- Compatibility risk
- Recommendation
```

Return exactly one decision:

- `GO`: every request contract is loader-compatible, covered, and behavior-preserving.
- `GO_WITH_REMEDIATION`: named safe work or user decisions remain.
- `NO_GO`: restoration or generation cannot be performed without unproven behavioral impact.
