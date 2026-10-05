# Impact Report Schema

```yaml
schema_version: "1.0"
project:
  name: "project-name"
  repository_root: "."
  revision: "commit, branch, or unknown"
baseline:
  runtime: "Node.js 22"
  package_manager: "pnpm"
  deployment_model: "Kubernetes rolling deployment"
  limitations: []
change_context:
  dependency: "kafkajs"
  from_version: "2.2.4"
  to_version: "3.0.0"
  manifest_validated: true
context_conflicts: []
applicability:
  - change_id: CHANGE-001
    status: applicable
    trigger_evaluation: "Retry count is not explicitly configured"
    evidence:
      - path: src/platform/kafka/client.ts
        symbol: createProducer
        observation: "No retry override"
    confidence: confirmed
impact_paths:
  - id: IMPACT-001
    change_id: CHANGE-001
    finding_status: likely
    path:
      - "Dependency retry default"
      - "KafkaClient wrapper"
      - "AlertEventPublisher"
      - "alert.status.update topic"
    technical_effect: "Longer retry duration and possible duplicate send"
    business_effect: "Delayed or duplicate customer alert status"
    evidence_refs: []
    assumptions: []
risks:
  - id: RISK-001
    impact_id: IMPACT-001
    likelihood: 3
    blast_radius: 4
    severity: 4
    detectability: 3
    reversibility: 2
    score: 3.55
    rating: medium
    evidence_confidence: medium
    rationale: "Concise explanation"
verification:
  - id: VERIFY-001
    risk_id: RISK-001
    type: integration-test
    action: "Simulate broker timeout using the resolved new package version"
    expected_evidence: "Retry count, latency, and duplicate behavior"
    blocking: true
deployment:
  mixed_version_compatibility: unknown
  rollback_safety: conditionally-safe
  canary_required: true
  notes: []
recommendation:
  decision: canary-required
  blocking_actions:
    - VERIFY-001
  non_blocking_actions: []
  confidence: medium
unknowns: []
```

## Allowed applicability values

- `applicable`
- `not-applicable`
- `conditionally-applicable`
- `unknown`
- `context-conflict`

## Allowed finding status values

- `confirmed`
- `likely`
- `possible`
- `unknown`
- `not-impacted`

## Allowed decisions

- `safe-to-merge`
- `merge-with-required-tests`
- `deploy-behind-feature-flag`
- `canary-required`
- `manual-migration-required`
- `do-not-deploy`
- `insufficient-evidence`