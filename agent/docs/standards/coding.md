# Coding Standards

## Language and Boundaries
- Follow the project's language and tooling. For TypeScript projects, use strict type checking and avoid `any` unless justified.
- Validate external data at system boundaries.

## Architecture
- Keep modules focused, interfaces explicit, and dependencies visible.
- Prefer existing patterns. Add abstractions or dependencies only for current needs.

## Implementation
- Implement only the agreed scope; avoid unrelated refactoring.
- Preserve existing behavior unless a change is agreed.
- Define input, output, and failure contracts; never silently swallow errors.

## Review
- Check changes against the agreed design or approved plan, if available.
- Inspect side effects, dependencies, and compatibility risks.
- Keep changes small and reviewable.
