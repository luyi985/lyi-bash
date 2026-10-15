# KP Specification

Store each new knowledge point at `preRaw/KP/{kp-id}.md`. Discover existing definitions recursively under `preRaw/KP/` and preserve their locations. IDs must be unique across the entire KP tree within the learning root, including different subdirectories; raw notes that reuse their KP's ID are not additional definitions.

## Identity

```text
{namespace}-{scope}-{context}-{index}
```

All four fields are required in that order. Use filesystem-safe lowercase values separated by hyphens unless the workspace already has a compatible convention. Preserve established IDs and index width. Never recycle an ID for a different concept.

## Status

- `pending`: created but not started.
- `learning`: active learning is in progress.
- `review`: learned content awaits user review or save approval.
- `completed`: the user-approved learned note has been persisted by the responsible workflow.

This skill may create `pending` KPs and preserve or report all statuses. A learning workflow may update an existing KP at observed lifecycle events: user approval to begin learning, presentation of a complete draft for review, and successful persistence of the approved learned note. Never infer completion from conversation fluency or the mere existence of a similarly named raw file.

KP frontmatter `status` is the only progress authority. Route-plan checkboxes, counts, and current-position sections are derived displays; never use them to overwrite KP status. For new completions, user confirmation of understanding or approval of a draft does not replace successful persistence of the approved, grounded note. If the note is saved but status synchronization fails, report both results; the responsible learning workflow must repair metadata from that save evidence before dependent KPs become eligible.

`learned_note` is optional and records the approved note's path relative to the learning root, normally `raw/{kp-id}.md`. Set it with `completed` only after the approved note is successfully saved. Existing completed KPs without this field remain valid; do not downgrade or rewrite them. When the user explicitly reopens a completed KP, retain its previous note link until a replacement is successfully saved. Keep an already completed KP completed during ordinary relearning unless the user explicitly reopens it.

## Content quality requirements

KP files are source-grounded learning definitions and brief previews, not full lessons, dialogue-derived understanding, or approved learned notes. Keep the existing sections; avoid repeating the same explanation across them. Every generated KP must satisfy all five requirements:

1. **One complete knowledge point.** A KP has one central question or concept and explains the complete minimum boundary needed to understand that point. All sections must contribute to the same point. Split material when it contains independently learnable concepts; do not split one concept into fragments that are meaningless alone.
2. **Simple language with English terminology.** Prefer short, direct explanations. When the document is written in a language other than English, give the English form the first time a technical term appears, for example `消费者组（consumer group）`. Do not add English translations to ordinary non-technical words.
3. **Logical progression.** Order the KP from prerequisite context to the central mechanism, then consequences, boundaries, and relevant examples. Each step must make the next step easier to understand; avoid disconnected fact lists or unexplained jumps.
4. **Traceable sources.** Every KP must cite at least one source that directly supports its scope. Use precise locators such as a relative file path plus heading, a document section or page, or a URL plus page heading, following [learning-source.md](learning-source.md). A repository root, course homepage, or vague source name is insufficient when a more precise locator is available.
5. **Explanatory example.** Every KP must include at least one concrete example that demonstrates the central concept or mechanism. State what part of the knowledge point the example illustrates. Prefer an example from the supplied source; when creating one, label it as an illustrative example and do not present invented details as source facts.

A KP that fails any requirement is not ready to persist.

## File schema

```markdown
---
id: <namespace-scope-context-index>
title: <concise title>
status: pending
sources:
  - <learning-root-relative local locator or unchanged external identifier>
dependencies: []
---

# <id>: <title>

## Learning Objective

<One observable understanding outcome.>

## Scope

- Included: ...
- Excluded: ...

## Source Context

<Why this KP exists and where its supporting material is located.>

## Knowledge Point

<A simple description centered on one complete concept or question. Introduce technical terms with their English names.>

## Logical Path

1. <Required context or prerequisite>
2. <Central mechanism or idea>
3. <Result, consequence, or why it matters>
4. <Boundary, limitation, or example when relevant>

## Key Terms

- <Local-language term> (`<English term>`): <plain-language meaning>

## Example

<A concrete example showing the central concept or mechanism. Explain explicitly what it demonstrates.>

## Sources

- <File-relative source link or unchanged external identifier, with precise location and the part that supports this KP>
```

The frontmatter `sources` field and the `## Sources` section must describe the same evidence set. Frontmatter provides machine-readable locators relative to the learning root; body local source links are relative to this KP's actual file location. Resolve both to verify the same source targets and precise locations, not identical strings. External URLs and resource identifiers retain their values. The full path and legacy-compatibility rules are owned by `learning-source.md`. A downstream raw note must inherit these original references, not replace them with only a link to this KP.

Add `learned_note` to frontmatter only when a saved note is available; do not require it in pending KPs or migrate older files to add it.

## Dependencies and next eligibility

`dependencies` contains hard prerequisite KP IDs that must be `completed` before a pending KP is eligible. Put recommended reading order in the body; do not turn it into a blocking edge. Do not equate code calls or module dependencies with learning prerequisites.

Before saving a plan or recommending a next KP, validate the entire relevant KP set for readable metadata, valid statuses, duplicate IDs, missing prerequisite IDs, self-references, and cycles. If a legacy KP lacks `dependencies`, use clearly stated hard prerequisites from its body; if none are stated, treat it as having no recorded prerequisites for reporting without adding the field. If stated prerequisites cannot be resolved unambiguously, report that ambiguity. Report invalid or ambiguous metadata and withhold a next-item recommendation until resolved; do not silently repair IDs, retire KPs, or invent prerequisites. Existing progress counts and current items can still be reported with the validation findings.

- Report all `learning` and `review` KPs as current items, identifying review/save work still pending. Do not choose another pending KP while current items exist. If several current items exist, ask the user to select one before resuming learning; a progress-only query only lists them and need not pause for selection. Do not automatically resume multiple active KPs.
- Otherwise choose a `pending` KP only if all its hard prerequisites are `completed`. Among eligible candidates, use the source's established sequence, then KP ID as a tie-breaker; when no source sequence can be established from existing metadata or context without fetching historical sources, sort by KP ID. Do not add a separate ordering or progress file.
- If no pending KP is eligible, report its unfinished prerequisites or validation blockers. Report completion only for a nonempty valid set in which every KP is `completed`; an empty set means no plan is available.

## Update rules

- Reuse an existing KP when its learning objective is materially the same.
- Preserve user-authored additions and current status.
- Add a new KP when the objective is independently learnable and materially distinct.
- Split a draft KP when it has more than one central concept. Merge adjacent drafts when neither forms a complete, independently meaningful knowledge point.
- Reject an example that introduces a second independent knowledge point, relies on unexplained concepts, or does not demonstrate the KP's central mechanism.
- If replanning would split, merge, or retire an active or completed KP, report the migration and wait for approval before changing its identity.
- Aggregate progress from KP files; do not maintain a separate progress count.
