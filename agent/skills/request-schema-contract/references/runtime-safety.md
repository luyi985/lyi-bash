# Runtime and downstream safety

All work is contract preservation unless the user separately approves a behavior change.

## Protected behavior

Do not alter:

- route paths or HTTP methods;
- handler/controller/middleware logic;
- request extraction locations;
- accepted payload or parameter shapes;
- required/optional/null semantics;
- defaults or coercion;
- validation order or error format/status;
- media types;
- client SDK request models;
- service calls and downstream payloads;
- serializers, events, persistence, or side effects;
- public TypeScript API behavior.

## Compatibility gate

Before creating or tightening a Schema, compare against:

- current runtime validation;
- handler behavior;
- unit/component/integration tests;
- generated or handwritten clients;
- service-to-service callers;
- API documentation and examples;
- Git history when restoring structure.

A Schema that rejects previously accepted traffic is a behavior change. Stop and request user approval when this cannot be ruled out.

## Allowed default edits

Without extra approval, edit only:

- request Schema files needed to restore the proven loader contract;
- missing request Schema files that exactly model existing behavior;
- request Schema tests following an existing repository pattern;
- audit reports.

Do not modify production code to fit the Schema.
