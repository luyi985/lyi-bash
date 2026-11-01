# Security Standards

## Authorization
- Every protected operation MUST enforce authorization in application code.
- User permissions and resource permissions MUST be validated.
- LLM instructions MUST NOT be treated as authorization.

## Tenant Isolation
- Data access MUST enforce tenant boundaries where applicable.
- Retrieved documents MUST be filtered by authorized tenant and identity.
- Cross-tenant data exposure MUST NOT be permitted.

## Data Protection
- Sensitive data MUST be protected in transit and at rest.
- Collect and expose only data required for the approved task.
- Do not send sensitive data to unauthorized models, tools, or external services.
- Define retention and deletion rules for persisted sensitive data.

## Input and Tool Security
- Treat user input and external tool results as untrusted data.
- Validate inputs before executing operations.
- Enforce applicable timeouts and execution limits.
- Prevent untrusted content from overriding application policies.

## Audit
- Record security-relevant actions and outcomes.
- Include actor, authorization context, operation, result, and failure information where appropriate.
- Redact sensitive information from audit records.
- Apply access controls and retention policies to logs.
