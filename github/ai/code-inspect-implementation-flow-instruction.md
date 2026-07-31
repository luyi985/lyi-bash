# Inspect Implementation Flow

## Objective

Inspect the repository and reconstruct the implementation flow of a user-specified behavior, feature, event, API, command, job, or business rule.

The result must be grounded in the current codebase.

Do not infer that a component participates in the flow merely because its name appears relevant.

## Input

The user should provide one or more of the following:

- A feature or business behavior.
- An event name.
- An API route.
- A class, function, method, or module.
- A producer or consumer.
- A command or background job.
- A description of expected behavior.
- A suspected implementation problem.

Optional focus areas may include:

- Data flow.
- Control flow.
- Dependency injection.
- Event registration.
- Configuration.
- Validation.
- Error handling.
- Persistence.
- External calls.
- Message production or consumption.

## Investigation Workflow

### Step 1: Define the investigation target

Restate the target as a concrete technical question.

Identify:

- Expected starting point.
- Expected final side effect.
- Relevant identifiers supplied by the user.
- Any scope restrictions.

Do not begin with a repository-wide explanation.

### Step 2: Locate candidate entry points

Search the codebase for exact identifiers first, including:

- Event names.
- Route paths.
- Function names.
- Class names.
- Topic names.
- Queue names.
- Configuration keys.
- Schema names.

Then search semantically related identifiers only when exact search is insufficient.

List candidate entry points and select the one supported by actual references.

### Step 3: Trace the control flow

Follow executable references from the entry point.

For each step, identify:

- File.
- Symbol.
- Caller.
- Callee.
- Invocation condition.
- Return value or side effect.
- Relevant branch or guard.

Do not treat imports or declarations as evidence that code executes.

### Step 4: Trace the data flow

Track the relevant payload through the implementation.

For each transformation, record:

- Input shape.
- Field extraction.
- Validation.
- Mapping or enrichment.
- Serialization.
- Output shape.

Explicitly identify renamed, removed, defaulted, or generated fields.

### Step 5: Inspect registrations and runtime wiring

Check runtime relationships that may not be visible from direct function calls, including:

- Dependency-injection bindings.
- Event listeners.
- Decorators.
- Module registration.
- Plugin registration.
- Middleware.
- Framework lifecycle hooks.
- Consumer and producer registration.
- Configuration-based routing.
- Feature flags.

Distinguish between:

- Defined.
- Registered.
- Instantiated.
- Invoked.

### Step 6: Inspect termination and failure paths

Identify every point where the flow can stop or diverge, including:

- Early return.
- Failed condition.
- Missing listener.
- Missing registration.
- Validation failure.
- Caught and suppressed error.
- Retry behavior.
- Timeout.
- Configuration mismatch.
- Schema rejection.
- Unawaited asynchronous operation.
- Fire-and-forget behavior.

Do not claim a defect unless the code supports that conclusion.

### Step 7: Verify the final side effect

Locate the exact implementation responsible for the expected outcome, such as:

- Database write.
- Event emission.
- Kafka publish.
- MQTT publish.
- HTTP request.
- File write.
- State update.
- Cache mutation.

Confirm whether the traced path actually reaches it.

### Step 8: Report evidence and gaps

Separate findings into:

- Confirmed by code.
- Likely but not confirmed.
- Missing runtime evidence.
- Contradictions or broken links.

When runtime behavior depends on external configuration or infrastructure that is not present in the repository, state that it cannot be determined from the available code.

## Output Format

# Implementation Flow: `<target>`

## Conclusion

Give a direct summary of how the implementation works.

State whether the expected flow is complete, conditionally complete, or broken.

## Flow Overview

```text
Entry point
  -> validation
  -> transformation
  -> orchestration
  -> adapter
  -> final side effect