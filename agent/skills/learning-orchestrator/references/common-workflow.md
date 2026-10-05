# Common Workflow

## 1. Inspect and resume

Resolve the learning root, inspect its structure, enumerate sources, and scan `preRaw/KP/*.md`. Summarize counts by status and identify malformed or duplicate IDs before writing.

## 2. Initialize minimally

Create only missing directories according to `folder-structure.md`. Existing workspaces use this same entrypoint; there is no separate resume workflow.

## 3. Resolve and validate inputs

Resolve every specified local and external source, retain stable locators for KP metadata, and apply `learning-source.md`. Stop without modifying the KP plan if any required input fails.

## 4. Analyze sources

Inspect structure, concepts, prerequisites, examples, exercises, and explicit objectives. Separate source facts from inferred learning structure. A supplied learning mode may affect decomposition depth, order, and practice emphasis, but not workspace or KP invariants.

## 5. Build or reconcile the KP plan

Create independently learnable KPs, assign IDs, record sources, and express prerequisite edges with `dependencies`. Compare against existing files first. Before persistence, check every proposed KP against the five content quality requirements in `kp-specification.md`: one complete point, simple language with English terminology, logical progression, precise sources, and an explanatory example.

- Retain unchanged KPs and statuses.
- Update safe metadata or scope clarifications without erasing user content.
- Add missing KPs as `pending`.
- Pause before splits, merges, or retirement of active or completed KPs.
- Reject or revise any draft KP that mixes multiple points, contains logical jumps, uses unexplained terminology, lacks direct source support, or has no example demonstrating its central mechanism.

## 6. Persist and report

Write new or safely updated definitions to `preRaw/KP/{kp-id}.md`. Report the learning root, validated inputs and limitations, KP changes, counts by status, and the next eligible KP respecting dependencies. Stop there; loading or teaching the KP is outside this skill.
