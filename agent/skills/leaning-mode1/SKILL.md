---
name: leaning-mode1
description: Build and run Mode 1 dependency-driven sequential learning from existing Markdown knowledge points under preRaw/KP. Use when the user asks for Mode 1, wants a Mode 1 learning map, or wants to resume learning KPs in prerequisite order. Do not use to extract KPs from source material or for top-down recursive or practice-driven learning.
---

# Leaning Mode 1

Orchestrate existing KPs into a dependency-valid sequential learning route. Treat workspace files as the source of truth.

## Boundaries

- Read KPs; do not create, rewrite, merge, split, or delete them.
- Clarify relationships among KPs, including prerequisite, dependency, causality, composition, progression, contrast, support, and independence.
- Produce and maintain only the Mode 1 plan at `preRaw/planning/mode1.md`.
- Do not teach an individual KP inside the planning phase. When execution reaches a KP, hand off that KP as a distinct learning step without assuming or requiring another skill.
- Do not promote files into `raw/` or `wiki/`.

## Workspace gate

1. Resolve the learning workspace root. If multiple roots are plausible, ask before writing.
2. Require `preRaw/KP/` to exist and contain readable `.md` files. If it is missing or empty, stop: Mode 1 requires prepared KPs.
3. Ensure `preRaw/planning/` exists; create only that missing directory.
4. If `preRaw/planning/mode1.md` exists, read it before rebuilding or resuming. Preserve valid progress and user-authored notes.

## Planning workflow

1. Read every Markdown file recursively under `preRaw/KP/`. Do not infer the KP set from filenames alone.
2. Identify each KP's ID, scope, stated prerequisites, sources, and conceptual role. Report malformed or duplicate IDs instead of silently repairing them.
3. Analyze meaningful directed and non-directed relationships. Distinguish hard prerequisites from recommended order, causality from sequence, hierarchy from dependency, and independence from unresolved relationships.
4. Detect missing prerequisites, cycles, contradictions, and ambiguous edges. Never invent an edge merely to force a linear path.
5. Build a knowledge graph covering every KP and label edge types explicitly. If cycles or missing prerequisites prevent a valid route, record the blocker and ask for resolution before learning begins.
6. Derive a stable learning route using prerequisite order. Group mutually independent KPs into the same stage, but assign a deterministic recommended order for one-by-one learning. Source order is evidence, not learning order.
7. Write or update `preRaw/planning/mode1.md` using the required structure below. Preserve completed progress only when the KP still exists and its identity is unchanged.

## Required plan content

Include these sections in `mode1.md`:

- `Scope`: KP root, KP count, and last analysis date.
- `Knowledge Graph`: a Mermaid graph when supported; otherwise an explicit typed edge list. Every KP must appear, and every edge must state its relationship type.
- `Relationship Notes`: important causal, compositional, supporting, contrasting, independent, ambiguous, and missing relationships.
- `Validation Findings`: missing prerequisites, cycles, duplicate IDs, contradictions, or `None`.
- `Learning Route`: dependency-valid stages plus a deterministic one-by-one order.
- `Learning Progress`: exactly one checkbox per KP.
- `Current Position`: current KP, next eligible KP, and blockers.

Keep the knowledge graph as analysis and learning progress as mutable execution state. Do not mix progress markers into graph semantics.

## Execution and resume

1. Select the first unchecked KP whose hard prerequisites are complete.
2. Present that KP as the next learning step and keep traversal sequential; do not start multiple KPs together.
3. Mark a KP complete only after the user explicitly confirms completion or approves the resulting learned artifact. Do not equate exposure, explanation, or a generated draft with completion.
4. After completion, update the checkbox, `Current Position`, next eligible KP, and blockers without rebuilding a valid graph.
5. Reanalyze the full graph only when KP files change, a dependency is disputed, or the existing map is invalid.
6. Complete Mode 1 only when every KP is checked and no unresolved blocker remains.

## Reporting

After planning, report the KP count, graph validation status, plan path, and first eligible KP. On resume, report completed/total counts, current KP, next eligible KP, and blockers.
