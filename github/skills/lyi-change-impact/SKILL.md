---
name: lyi-change-impact
description: Analyze software changes end to end, including dependency upgrades, code diffs, API or schema changes, configuration, runtime, infrastructure, and mixed change sets. Use when asked what a change affects, what can break, which tests are required, or whether it is safe to merge or deploy.
argument-hint: "[change, diff, dependency upgrade, or repository scope]"
---

# Change Impact

This Skill is a lightweight VS Code adapter.

Read and follow the authoritative workflow:

- [End-to-End Change Impact Analysis](../../ai/change-impact/end-to-end-change-impact-analysis.md)

Load its linked schemas and risk model only when required. Keep reusable analysis logic in `.github/ai`; do not duplicate it in this adapter.
