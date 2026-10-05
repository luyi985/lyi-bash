# KP Specification

Store each knowledge point at `preRaw/KP/{kp-id}.md`.

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

This skill may create `pending` KPs and preserve or report all statuses. Update status only from explicit workspace evidence or user instruction; never infer completion from conversation fluency.

## Content quality requirements

Every generated KP must satisfy all five requirements:

1. **One complete knowledge point.** A KP has one central question or concept and explains the complete minimum boundary needed to understand that point. All sections must contribute to the same point. Split material when it contains independently learnable concepts; do not split one concept into fragments that are meaningless alone.
2. **Simple language with English terminology.** Prefer short, direct explanations. When the document is written in a language other than English, give the English form the first time a technical term appears, for example `消费者组（consumer group）`. Do not add English translations to ordinary non-technical words.
3. **Logical progression.** Order the KP from prerequisite context to the central mechanism, then consequences, boundaries, and relevant examples. Each step must make the next step easier to understand; avoid disconnected fact lists or unexplained jumps.
4. **Traceable sources.** Every KP must cite at least one source that directly supports its scope. Use precise locators such as a file path plus heading, a document section or page, or a URL plus page heading. A repository root, course homepage, or vague source name is insufficient when a more precise locator is available.
5. **Explanatory example.** Every KP must include at least one concrete example that demonstrates the central concept or mechanism. State what part of the knowledge point the example illustrates. Prefer an example from the supplied source; when creating one, label it as an illustrative example and do not present invented details as source facts.

A KP that fails any requirement is not ready to persist.

## File schema

```markdown
---
id: <namespace-scope-context-index>
title: <concise title>
status: pending
sources:
  - <source locator>
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

- <Precise source locator and the part that supports this KP>
```

The frontmatter `sources` field and the `## Sources` section must describe the same evidence set. Frontmatter provides machine-readable locators; the section explains which part of each source supports the KP. `dependencies` contains KP IDs normally learned first.

## Update rules

- Reuse an existing KP when its learning objective is materially the same.
- Preserve user-authored additions and current status.
- Add a new KP when the objective is independently learnable and materially distinct.
- Split a draft KP when it has more than one central concept. Merge adjacent drafts when neither forms a complete, independently meaningful knowledge point.
- Reject an example that introduces a second independent knowledge point, relies on unexplained concepts, or does not demonstrate the KP's central mechanism.
- If replanning would split, merge, or retire an active or completed KP, report the migration and wait for approval before changing its identity.
- Aggregate progress from KP files; do not maintain a separate progress count.
