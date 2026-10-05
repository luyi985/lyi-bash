# Test contract

Prefer the repo’s existing test runner and Playbook helpers. Do not add a new framework.

## 1. Wire schema characterization

Serialize with the same flags the producer uses, then AJV-validate `ctor.jsonSchema`:

```ts
import { createValidateFunction, validateSchema } from "@playbook-lib/runtime/schema-validation";
import { SerializerFlags, serializeTypeToJsonStr } from "@playbook-lib/runtime/type-serializer";

function expectValidWirePayload(ctor: { jsonSchema: unknown }, message: unknown, label: string) {
  const jsonStr = serializeTypeToJsonStr(ctor as never, message, "", SerializerFlags.EnforceSerializing) ?? "";
  const validator = createValidateFunction(ctor.jsonSchema);
  expect(() => validateSchema(validator, JSON.parse(jsonStr), label)).not.toThrow();
}
```

Required cases:

- `ctor.jsonSchema` is truthy for every enforced message
- one valid serialized fixture per ctor
- one invalid fixture (missing required field and/or bad enum)

If the runtime helpers are missing, skip this file and record the gap. Do not reimplement a serializer.

## 2. Producer adapter

Mock `KafkaProducer.sendWithSchema`. Assert topic, key, payload, **ctor**, and headers.

Assert the mock rejection is **propagated** by the adapter (the adapter should not swallow).

## 3. Orchestrator catch policy

If the caller catches `KafkaSchemaValidationException`:

- assert it does not rethrow when that is the existing behavior
- assert structured log fields: `messageType`, `topic`, `key`, `errors`, `reason`

If the caller uses a generic `catch` and `log.error(error)`, do not silently upgrade it unless the user asked. Report the inconsistency.

## 4. What these tests do not prove

They do not prove `KafkaProducer.sendWithSchema` internals or broker delivery. Label that as missing runtime evidence unless library source is read.
