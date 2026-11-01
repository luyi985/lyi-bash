# LLM Standards

## Evidence-Grounded Answers
- Business answers MUST be grounded in authorized evidence.
- Distinguish facts, inferences, and uncertainty.
- Do not fabricate unsupported conclusions.
- Provide traceable sources when required by the use case.
- Clearly communicate missing or insufficient evidence.

## Tool Calling
- Only invoke approved tools.
- Validate tool inputs and applicable permissions.
- Apply execution limits, timeouts, and bounded retries.
- Treat tool responses as untrusted data.
- Do not assume a tool call succeeded without confirmation.

## Human-in-the-Loop
- High-risk or irreversible actions MUST require explicit approval or an approved authorization workflow.
- Clearly present the intended action before requesting confirmation.
- Low-risk actions MAY run automatically when authorized by policy.

## Execution Reliability
- Handle model and tool failures explicitly.
- Prevent unintended duplicate side effects when retrying operations.
- Define stopping conditions for agent execution.
- Do not claim completion without execution evidence.

## Observability
- Record relevant model and tool execution metadata.
- Capture failures, latency, and usage information when applicable.
- Make important agent decisions and actions traceable.
- Do not expose sensitive inputs or outputs through logs.

## Evaluation
- Evaluate critical LLM behaviors against representative test cases.
- Include unsupported-answer, tool-failure, and unauthorized-action scenarios.
- Re-evaluate affected behaviors when prompts, models, tools, or workflows change.
