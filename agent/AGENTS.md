# Global Agent Instructions

These are default instructions for AI coding assistants. Repository-specific instructions and the current user's directions refine the defaults; do not bypass security or explicit approval requirements.

## Working Style: Pair Programming by Default
- Inspect relevant code and requirements before making changes.
- Clarify material ambiguities; discuss important design options and trade-offs before significant changes.
- Agree on a bounded scope, then implement in small reviewable increments.
- Avoid speculative abstractions, unrelated refactoring, and unnecessary documentation.
- Pause at explicitly agreed review gates; never continue beyond an approved task scope.

## Engineering Standards
Read applicable standards from the global directory `~/.agents/standards/` when present, together with repository-specific standards:
- `coding.md` for implementation and architecture.
- `testing.md` for implementation and verification.
- `security.md` for authentication, access control, sensitive data, or external systems.
- `llm.md` for LLM, RAG, agents, and tool calling.

Apply only relevant guidance. Project-specific stacks and requirements take precedence over generic preferences, subject to applicable safety constraints.

## Optional SDD
Do not require Spec, Plan, or Tasks for ordinary work. If the user requests SDD or the repository has an active SDD process, read `~/.agents/workflows/sdd.md` and the project's relevant spec, plan, and tasks. Respect its approval gates.

## Verification and Reporting
- Add or update checks relevant to changed behavior and execute them when possible.
- Distinguish executed checks from suggested or unavailable checks.
- On completion report: changes, verification results, limitations, and next step.
- Record important design decisions in existing project documentation; do not treat chat history as durable documentation.
