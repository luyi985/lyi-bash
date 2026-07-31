# Risk Model

Score each applicable or conditionally applicable finding from 1 to 5.

## Dimensions

- `likelihood`: probability that the trigger and failure condition occur
- `blast_radius`: number and importance of components, services, tenants, or users affected
- `severity`: consequence when the effect occurs
- `detectability`: ability to detect before or shortly after release; 5 means hard to detect
- `reversibility`: difficulty of rollback or recovery; 5 means hard or impossible to reverse

## Weighted score

Use:

```text
risk_score = likelihood * 0.25
           + blast_radius * 0.20
           + severity * 0.30
           + detectability * 0.15
           + reversibility * 0.10
```

Map the result:

- `critical`: 4.50–5.00
- `high`: 3.60–4.49
- `medium`: 2.60–3.59
- `low`: 1.60–2.59
- `informational`: 1.00–1.59

Do not mechanically elevate risk because evidence confidence is low. Report risk and confidence separately. When evidence is insufficient for scoring, set risk to `unknown` and state the missing evidence.

## Decision guidance

- Critical: block deployment unless explicitly accepted with mitigation.
- High: require targeted verification and guarded rollout.
- Medium: require evidence-based tests or monitoring before broad rollout.
- Low: normal review and regression coverage.
- Informational: document only.