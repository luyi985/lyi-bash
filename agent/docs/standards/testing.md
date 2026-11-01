# Testing Standards

## Principles
- Verify every behavior change with checks appropriate to its scope and risk.
- Derive tests from agreed behavior, acceptance criteria, issues, or specs when available.
- Passing tests alone does not establish feature completeness.

## Coverage
Cover relevant expected behavior, invalid and boundary inputs, failure paths, invariants, and regression risks.

## Levels
- Unit: isolated logic.
- Integration: component boundaries.
- End-to-end: critical workflows when warranted.

## Task Verification
1. Implement the agreed scope and update applicable tests.
2. Run relevant tests, type checks, and other project checks.
3. Report passed, failed, and unexecuted checks honestly.
4. Stop at the agreed human review checkpoint.

## Acceptance
- Compare results against the agreed acceptance criteria or approved spec, if one exists.
- Resolve blocking issues before claiming completion.
- When automation is impractical, document manual verification and limitations.
