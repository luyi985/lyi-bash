# Global Agent Instructions

These are default instructions for AI coding assistants. Repository-specific instructions and the current user's directions refine the defaults; do not bypass security or explicit approval requirements.

## Working Style: Pair Programming by Default
- Inspect relevant code and requirements before making changes.
- Clarify material ambiguities; discuss important design options and trade-offs before significant changes.
- Treat a clear user request as agreement on its bounded scope; do not ask for redundant confirmation. Clarify material ambiguity or scope expansion before proceeding.
- When implementation is requested and permitted by the active mode, implement in small reviewable increments.
- Avoid speculative abstractions, unrelated refactoring, and unnecessary documentation.
- Pause at explicitly agreed review gates; never continue beyond an approved task scope.

## Copilot Mode
- When the user says "copilot" to request this mode, activate Copilot mode.
- Mentioning or quoting "copilot" while discussing documentation does not activate the mode.
- In Copilot mode, read and follow [copilot-llm-instruction.md](docs/workflows/copilot-llm-instruction.md) in addition to these instructions.
- Copilot mode is read-only: do not create, edit, or delete files, change repository state, or perform actions that modify external systems. This overrides implementation, test-editing, and documentation-writing instructions below.
- You may inspect code, explain findings, provide suggested code snippets or commands, and run checks only when they do not modify files or other state. Have the user run checks that may write artifacts or change state.
- Stay in Copilot mode until the user explicitly asks to exit or switch modes; then resume the requested mode, or the default working style if none is specified. An implementation request alone does not exit Copilot mode; guide the user through it.
- If the workflow file cannot be read, report the limitation and retain these read-only restrictions.

## Engineering Standards
Read applicable standards from the global directory `~/.agents/standards/` when present, together with repository-specific standards:
- `coding.md` for implementation and architecture.
- `testing.md` for implementation and verification.
- `security.md` for authentication, access control, sensitive data, or external systems.
- `llm.md` for LLM, RAG, agents, and tool calling.

Apply only relevant guidance. Project-specific stacks and requirements take precedence over generic preferences, subject to applicable safety constraints.

Discover repository-specific standards through applicable `AGENTS.md` files and their references. Resolve relative links against the containing file. If a referenced file is unavailable, report the relevant limitation and proceed with available guidance unless the missing instructions are essential to the task.

## Optional SDD
Do not require Spec, Plan, or Tasks for ordinary work. Use SDD when the user requests it or applicable repository instructions explicitly require it for the current task; the presence of old spec files alone does not activate SDD. Read `~/.agents/workflows/sdd.md` and the project's relevant spec, plan, and tasks. Respect its approval gates and the active mode's restrictions.

## Verification and Reporting
- When implementation is permitted, add or update checks relevant to changed behavior and execute them when possible. In Copilot mode, guide the user through those changes and checks within the mode's restrictions.
- Distinguish executed checks from suggested or unavailable checks.
- On completion, report changes or findings, verification results, material limitations, and any remaining next step. Do not invent follow-up work when the task is complete.
- When file edits are permitted, record important design decisions in existing project documentation. In Copilot mode, provide suggested text for the user to record; do not treat chat history as durable documentation.
