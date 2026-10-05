---
name: learning-orchestrator
description: Prepare or resume a file-backed learning workspace from local source material or external links, validate inputs, decompose the material into knowledge points, and track KP progress. Use for planning and maintaining a structured learning path; do not use it to teach an individual KP.
---

# Learning Orchestrator

Turn validated learning material into a resumable set of KP Markdown files. This skill is self-contained and has no dependency on any other skill.

## Boundaries

- Own workspace inspection, initialization, recovery, source validation, analysis, KP decomposition, KP persistence, and progress reporting.
- Do not teach, quiz, or write the learned content of an individual KP.
- Do not invoke, require, or define another skill.
- Treat files as persistent state. Do not rely on conversation history as the source of truth.

## Required references

Before changing a learning workspace, read:

1. [references/folder-structure.md](references/folder-structure.md) for directory meanings and creation rules.
2. [references/learning-source.md](references/learning-source.md) for input resolution and the validation gate.
3. [references/kp-specification.md](references/kp-specification.md) before creating or updating KP files.
4. [references/common-workflow.md](references/common-workflow.md) for the lifecycle and resume behavior.

## Inputs

Accept one or both of:

- a specified file or folder under the workspace's `preRaw/` tree;
- an external link or externally addressable resource.

Also resolve the target learning root. If more than one plausible root exists and it cannot be inferred safely, ask before writing.

## Operating rules

1. Inspect before creating. Preserve a valid workspace and reconstruct progress from KP files.
2. Create only missing required directories; do not reorganize user material without explicit approval.
3. Validate every requested input before analysis. If available material is incomplete relative to the requested scope, stop and report what is unavailable.
4. Do not generate or revise the KP plan until the validation gate passes.
5. Use a supplied learning mode only for decomposition depth, ordering, and practice emphasis. Otherwise preserve the source's structure and produce independently learnable KPs. Each KP must cover one complete knowledge point rather than grouping loosely related topics.
6. Save each KP as `preRaw/KP/{kp-id}.md` using the shared schema and quality rules. Use simple language, pair technical terms with their English names when writing in another language, maintain a coherent reasoning sequence, attach traceable sources, and include at least one explanatory example. Preserve existing IDs and user-authored content whenever possible.
7. Derive progress by scanning KP metadata. Do not create a second progress source of truth.
8. Report validation, KP changes, status counts, and the next eligible KP. Stop there.

## Safety and user control

- Never treat an index, README, excerpt, or search snippet as proof that the full source was obtained.
- Never overwrite an existing KP merely because a new decomposition differs. Preserve identity, document the conflict, or ask when the choice changes learning scope.
- Do not promote content to `raw/` or `wiki/`; those layers are outside this skill.
