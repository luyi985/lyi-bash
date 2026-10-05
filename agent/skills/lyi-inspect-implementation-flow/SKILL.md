---
name: lyi-inspect-implementation-flow
description: Inspect a repository to reconstruct the end-to-end implementation flow of a feature, event, API, function, message, command, job, or business behavior. Use when asked how logic works, where a flow starts/ends, how data moves, why a side effect is missing, or which registrations/configuration/branches/producers/consumers participate. Ground every material hop in current code.
---

# Inspect Implementation Flow

## Step 1 — Define one concrete target

**Action**
Restate the request as one technical question. Record expected start, expected final side effect, supplied identifiers, and scope restrictions.

**Complete when** there is a single investigation target.

**If blocked** ask only for the missing identifier that prevents locating an entry point.

## Step 2 — Find candidate entry points

Search exact identifiers first: route, event, function, class, topic, queue, config key, schema, command/job name. Use semantic search only after exact search is insufficient.

**Complete when** candidate entry points are listed and one is selected from actual references.

**If blocked** report the exact searches attempted and stop rather than guessing.

## Step 3 — Trace executable control flow

For each hop record file, symbol, caller, callee, invocation condition, branch/guard, return value, and side effect.

**Complete when** the path reaches a terminal side effect or a proven stop condition.

**If blocked** an import/declaration alone is not execution evidence; mark unresolved runtime wiring explicitly.

## Step 4 — Trace data flow

Track input shape, validation, field extraction, defaults, mapping, enrichment, rename/removal, serialization, and output shape.

**Complete when** the fields relevant to the user's question are accounted for from entry to terminal point.

## Step 5 — Verify runtime wiring

Inspect DI bindings, listeners, decorators, modules, plugins, middleware, lifecycle hooks, consumer/producer registration, config routing, and feature flags.

For each component distinguish: `defined`, `registered`, `instantiated`, `invoked`.

**Complete when** every non-direct runtime hop has a wiring status.

## Step 6 — Inspect failure and divergence paths

Check early returns, failed guards, missing registrations, validation failures, suppressed errors, retries, timeouts, config mismatch, schema rejection, unawaited async work, and fire-and-forget behavior.

**Complete when** each material divergence has a trigger and observable effect.

**If blocked** do not claim a defect without code evidence.

## Step 7 — Verify the final side effect

Locate the exact database write, event/Kafka/MQTT publish, HTTP call, file write, state/cache mutation, or other expected outcome.

**Complete when** the traced path either demonstrably reaches it or demonstrably stops before it.

## Step 8 — Report conclusion and gaps

Classify findings as:
- confirmed by code;
- likely but not confirmed;
- missing runtime evidence;
- contradiction/broken link.

If external infrastructure/configuration is required and absent, state that runtime completion cannot be proven from repository code alone.

## Output

Return:

```text
# Implementation Flow: <target>

## Conclusion
<complete | conditionally complete | broken | insufficient evidence>

## Flow Overview
Entry → validation → transformation → orchestration → adapter → side effect

## Evidence Table
step | file:symbol | condition | input/output | evidence status

## Data Transformations
...

## Runtime Wiring
...

## Failure / Divergence Paths
...

## Final Side Effect
...

## Evidence Gaps
...
```

Keep the report focused on the requested flow. Do not provide a repository-wide architecture tour unless it is needed to prove the path.
