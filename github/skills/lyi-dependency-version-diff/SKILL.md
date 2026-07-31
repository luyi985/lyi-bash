---
name: lyi-dependency-version-diff
description: Compare two exact versions of a dependency and produce an evidence-backed reusable Change Manifest. Use for npm, pnpm, yarn, framework, library, SDK, compiler, toolchain, or runtime upgrades before repository-specific impact analysis.
argument-hint: "[dependency] [old version] [new version]"
---

# Dependency Version Diff

This Skill is a lightweight VS Code adapter.

Read and follow the authoritative workflow:

- [Dependency Version Change Analysis](../../ai/change-impact/dependency-version-change-analysis.md)

Use the schemas and validators linked by that workflow. Keep reusable analysis logic in `.github/ai`; do not duplicate it in this adapter.
