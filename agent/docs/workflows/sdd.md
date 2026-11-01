# SDD Workflow

## 1. Specify
- Generate the feature specification.
- Define requirements, edge cases, and acceptance criteria.
- Human reviews and approves the specification.

## 2. Plan
- AI generates the technical plan.
- Reuse existing architecture where appropriate.
- Human reviews architectural decisions.
- Do not proceed without approval.

## 3. Tasks
- Break the approved plan into small, verifiable tasks.
- Define dependencies and completion criteria.
- Check consistency with the specification and plan.

## 4. Implement
- Execute only the authorized task or task group.
- Write implementation and applicable tests together.
- Run relevant verification.
- Report changed files, test results, and unresolved issues.
- Stop at the defined review gate.

## 5. Verify
- Validate the complete feature against the specification.
- Run relevant integration and regression tests.
- Resolve identified gaps.
- Human makes the final acceptance decision.

## 6. Change Management
- Requirement changes → Update Spec.
- Architecture changes → Update Plan.
- Implementation gaps → Update Tasks.
- Accepted changes → Record in Git.
