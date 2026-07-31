---
name: lyi-project-change-impact
description: Assess how a Change Manifest, dependency change, code diff, configuration change, API or schema change, runtime change, or infrastructure change affects a repository. Use to trace references and call paths, validate trigger conditions, identify technical and business impact, score risk, find test gaps, and recommend deployment or rollback actions.
argument-hint: "[manifest or change] [repository scope]"
---

# Project Change Impact

This Skill is a lightweight VS Code adapter.

Read and follow the authoritative workflow:

- [Repository Impact Analysis](../../ai/change-impact/repository-impact-analysis.md)

Use the schemas and validators linked by that workflow. Keep reusable analysis logic in `.github/ai`; do not duplicate it in this adapter.
