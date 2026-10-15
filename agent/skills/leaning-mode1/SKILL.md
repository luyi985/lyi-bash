---
name: leaning-mode1
description: Build and run Mode 1 dependency-driven sequential learning from existing Markdown knowledge points under preRaw/KP. Use when the user asks for Mode 1, wants a Mode 1 learning map, or wants to resume learning KPs in prerequisite order. Do not use to extract KPs from source material or for top-down recursive or practice-driven learning.
---

# Leaning Mode 1

Orchestrate existing KPs into a dependency-valid sequential learning route. KP frontmatter is the progress authority; the route plan is a derived view. This skill works independently and does not require another skill to be installed or invoked.

## Boundaries

- Read KPs; do not create, rewrite, merge, split, or delete them.
- Record meaningful relationships that explain understanding or order; do not exhaustively classify every pair of KPs.
- Produce and maintain only the Mode 1 plan at `preRaw/planning/mode1.md`.
- Do not teach an individual KP inside the planning phase. When execution reaches a KP, hand off that KP as a distinct learning step without assuming or requiring another skill.
- Do not promote files into `raw/` or `wiki/`.

## Workspace gate

1. Resolve the learning workspace root. If multiple roots are plausible, ask before writing.
2. Require `preRaw/KP/` to contain readable Markdown definitions, including any in subdirectories. If it is missing or empty, report no plan is available and stop; an empty set is not a completed course.
3. If `preRaw/planning/mode1.md` exists, read it before rebuilding or resuming. Preserve user-authored notes. Its checkboxes and current-position text are not evidence of KP completion.
4. Create `preRaw/planning/` only when writing a plan requires it. A progress-only query reads KP state and reports findings without initializing or rewriting files.

## Progress and prerequisite contract

- Recursively read every Markdown KP definition under `preRaw/KP/`, including files directly in that directory; do not follow directory symlinks outside the tree. Check duplicate IDs across the whole tree in the learning root. Raw notes reusing their KP IDs are not additional definitions.
- Read ID, title, `status`, scope, and prerequisites from content. Valid statuses are `pending`, `learning`, `review`, and `completed`. Report unreadable definitions, malformed metadata, unknown statuses, and duplicate IDs; do not repair them silently or recommend a next KP from an invalid set.
- `dependencies` records hard prerequisite KP IDs. If a legacy KP lacks that field, use clearly stated hard prerequisites in its body; if none are stated, treat it as having no recorded prerequisites without rewriting it. Withhold recommendations if stated prerequisites are ambiguous. Detect missing IDs, self-references, and cycles.
- Explicit hard prerequisites take precedence over inferred relationships. Keep suggested order nonblocking. Record suspected additional prerequisites or contradictions in `Validation Findings`; if they affect route validity, pause recommendations for resolution rather than editing KPs or silently changing their prerequisite contract.
- `status` is the only progress authority. Only `completed` satisfies a hard prerequisite. New completion requires user review, explicit save approval, a passing grounding check, successful note persistence, and status synchronization by the responsible learning workflow. Saying "understood," approving a draft, or checking a plan box does not complete a KP.
- Historical `completed` KPs remain valid without `learned_note`; do not downgrade them or require a replacement note. If a new note was saved but status synchronization failed, report the mismatch and require metadata repair from that save evidence before dependent KPs become eligible. This skill does not perform that repair.

## Planning workflow

1. Read and validate the full KP set using the contract above. Identify scope, sources, and conceptual roles; do not infer content or progress from filenames alone.
2. For an existing plan, compare route inputs using [references/route-input-summary.md](references/route-input-summary.md) before rebuilding. Preserve a valid graph and order when only progress changed.
3. When route analysis is needed, inspect meaningful relationships, distinguishing hard prerequisites from suggested order and other conceptual links. Never invent edges to force a linear route. Build a graph covering every KP and label each recorded edge.
4. Derive prerequisite-valid stages and a stable one-by-one order. Preserve a still-valid existing order; otherwise use useful nonblocking recommendations, then established source order and KP ID to resolve independent candidates. Source order must never override hard prerequisites.
5. Write or update the plan structure below. Derive all progress displays from current KP statuses, retain user notes, and record unresolved validation findings. Advance the route-input summary only after the route has been validated.

## Required plan content

Include these sections in `mode1.md`:

- `Scope`: KP root, KP count, and last analysis date.
- `Route Input Summary`: the per-KP semantic fingerprints defined in `references/route-input-summary.md`; used only for route invalidation, not progress tracking.
- `Knowledge Graph`: a Mermaid graph when supported; otherwise an explicit typed edge list. Every KP must appear, and every edge must state its relationship type.
- `Relationship Notes`: only the conceptual links and ordering rationale that help explain this route.
- `Validation Findings`: missing prerequisites, cycles, duplicate IDs, contradictions, or `None`.
- `Learning Route`: dependency-valid stages plus a deterministic one-by-one order.
- `Learning Progress`: exactly one derived checkbox per KP, checked only when its status is `completed`; counts come from the same statuses. Separately report invalid files without inventing counts for them.
- `Current Position`: all current `learning` or `review` KPs, next eligibility, and blockers.

Keep graph analysis separate from derived progress. Do not read checkboxes back into KP metadata or use them to decide eligibility. A progress-only report may describe stale plan displays without rewriting them.

## Execution and resume

1. Reread KP states on every resume, validate metadata and prerequisites, and check whether route inputs changed. Refresh progress displays from statuses when writing is requested; never preserve stale checks over current metadata.
2. Prioritize existing `learning` or `review` KPs. If several exist, list them and ask which one to resume; do not automatically advance or start multiple KPs. A progress-only query lists them without requiring a selection.
3. If there are no current items and the route is valid, select the first `pending` KP in that route whose hard prerequisites are all `completed`. If blocked, report unfinished prerequisites or validation findings instead of bypassing them.
4. Hand off one KP with its learning root, ID, actual file path, and current status. Handoff is neither approval to start learning nor completion. A `learning` item requires establishing the continuation point or returning to preview. A `review` item needs its actual complete draft; if unavailable, disclose that review must be reconstructed from available sources and user-confirmed understanding with fresh save approval, not inferred from status.
5. After the learning step, reread the KP status. Refresh counts, checkboxes, and position from metadata. If only `status` or `learned_note` changed, retain the validated graph and order. Reevaluate affected relationships when semantic inputs change; inspect the whole graph if the impact cannot be bounded, a dependency is disputed, or the map is invalid. Follow the route-input reference for legacy plans and change detection.
6. On the first update of an old plan, record any mismatch between old checkboxes and current KP statuses in `Validation Findings`, then regenerate progress displays. Preserve user notes, never infer completion from the old checks, and never modify KP metadata to reconcile the plan. After reconciliation, this historical display mismatch alone does not block a valid route.
7. Complete Mode 1 only for a nonempty, valid KP set in which every status is `completed` and no unresolved route blocker remains.

## Reporting

After planning, report KP counts, route validation, plan path, current items, and next eligibility. On resume, report metadata-derived completed/total counts, current items, next eligibility, blockers, and whether progress alone was refreshed or route analysis was needed. Distinguish historical reconciliation notes from unresolved blockers. Stop at the handoff; teaching and note persistence belong to the individual learning step.
