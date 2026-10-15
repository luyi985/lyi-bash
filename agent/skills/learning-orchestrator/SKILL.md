---
name: learning-orchestrator
description: Prepare or resume a file-backed learning workspace from local files, repositories, or external links. Preview structure, validate sources, plan knowledge points, and report progress. Use for learning-path preparation and maintenance, not individual KP teaching or a standalone code audit.
---

# Learning Orchestrator

Turn validated learning material into a resumable set of KP Markdown files. This skill is self-contained and has no dependency on any other skill.

## Boundaries

- Own workspace inspection, initialization, recovery, source validation, analysis, KP decomposition, KP persistence, and progress reporting.
- Produce source-grounded learning definitions and brief previews, not full lessons, quizzes, user understanding, or learned notes.
- Do not invoke, require, or define another skill.
- Treat files as persistent state. Do not rely on conversation history as the source of truth.

## Workflow and references

Follow [references/common-workflow.md](references/common-workflow.md): structure preview, workspace recovery, source validation, analysis and planning, then persistence and reporting. Load other references for the operation being performed:

- [references/kp-specification.md](references/kp-specification.md) for interpreting KP metadata and before creating or updating KPs. It owns the schema, quality requirements, dependency checks, and next-item selection rules.
- [references/folder-structure.md](references/folder-structure.md) before initializing directories or resolving write destinations.
- [references/learning-source.md](references/learning-source.md) before validating sources or writing source locators. It owns access and relative-path rules. A progress-only request does not require source validation or initialization guidance.

## Inputs

For analysis, accept one or both of:

- a specified local file, folder, or repository, including locations outside the learning workspace;
- an external link or externally addressable resource.

For progress reporting, an existing learning root is sufficient; no new source is required. Resolve the learning root separately from source locations. If more than one plausible root exists and it cannot be inferred safely, ask before writing.

## Core rules

- Inspect before creating; preserve workspace structure, KP identity, status, and user-authored content. Querying progress is read-only.
- Treat local sources as read-only references. Do not copy, move, or modify them automatically.
- Local learning works without Google Drive or any remote connector. Use connectors only for corresponding user-specified remote sources; retain their real URLs or resource identifiers. Persist local source paths relatively according to `learning-source.md`, never as absolute paths.
- Structure preview may precede validation. Detailed content or code analysis and KP planning require the source validation gate to pass.
- Use a supplied learning mode only for decomposition depth, ordering, and practice emphasis. Otherwise preserve source structure where compatible with independently learnable KPs. Module-level implementation and data-flow analysis are not a required workflow in this version.
- Derive progress from KP metadata, not a second progress table. Report existing progress even when a source becomes unavailable; do not replan from incomplete inputs.

## Safety and user control

- Never treat an index, README, excerpt, or search snippet as proof that the full source was obtained.
- Never overwrite an existing KP merely because a new decomposition differs. Preserve identity, document the conflict, or ask when the choice changes learning scope.
- Do not promote content to `raw/` or `wiki/`; those layers are outside this skill.
