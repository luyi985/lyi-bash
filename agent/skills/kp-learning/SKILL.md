---
name: kp-learning
description: Learn one knowledge point through a concept preview, Socratic dialogue, and user-approved Markdown capture. Use whenever the user wants to study and document a single KP.
---

# KP Learning

Take exactly one knowledge point from selection to an approved note in the target `raw` folder. Keep the KP's existing name and identity unless the user changes it.

This skill must work without ChatGPT Study mode. When Study mode is available, its question-led behavior may be used as the teaching engine, but the workflow and approval gates below remain authoritative.

## KP identity

Every KP ID must follow this schema:

```text
{namespace}-{scope}-{context}-{index}
```

The braces denote fields and are not part of the actual ID. Keep all four fields and their order. Reuse the course's established values and index style when they exist; do not silently rename an existing KP or invent a conflicting sequence. Use the KP ID consistently in the preview, Markdown title, references, and filename.

## Folder structure

Before using the workflow, read [references/folder-structure.md](references/folder-structure.md). It defines the `preRaw`, `raw`, and `wiki` knowledge layers, their allowed contents, provenance expectations, and the write boundary for this skill.

## Reference preservation

A completed raw KP must preserve its source provenance.

- When the selected KP or its supporting material contains references, citations, source URLs, document names, page or section markers, timestamps, or other source identifiers, carry them into the raw note.
- Preserve existing reference values faithfully. Do not rewrite, normalize, shorten, or invent references unless required by an established course convention.
- If multiple source materials materially contributed to the final KP, include all such sources.
- Do not treat conversational explanations from ChatGPT as external references.
- If the source KP has no reference information, do not invent a reference.
- Reference preservation is independent of the user's `Understanding`; references describe provenance, not the learner's interpretation.

## Workflow

### 1. Preview

- State the KP and its learning boundary.
- List the related core concepts with a short, plain explanation for each.
- Do not begin the full lesson yet.
- Stop and wait for the user to say `continue` or give equivalent explicit approval.

### 2. Interactive learning

After approval, guide learning primarily through one focused question at a time.

- Use the user's answer to decide whether to follow up, correct a misconception, add an example or counterexample, or move forward.
- Keep the dialogue within the previewed KP scope unless a dependency is necessary or the user expands the scope.
- Do not force a mechanical quiz or add a separate verification stage. The dialogue itself supplies the learning feedback.

Continue until the user indicates the discussion is sufficient or the conversation naturally covers the scoped concepts without an unresolved misunderstanding.

### 3. Draft the raw note

Generate a Markdown draft from the actual learning dialogue. Separate objective explanation from the understanding formed during the session.

Use this structure when it fits the material:

```markdown
# <namespace-scope-context-index>: <KP title>

## Concepts

### <Concept>
Accurate, concise explanation.

## Understanding

- The user's explanation or mental model
- Important reasoning and links to existing knowledge
- Misconceptions corrected during the discussion
- Useful examples, counterexamples, boundaries, or tradeoffs

## Open Questions

- Only unresolved questions that remain after the session

## References

- <preserved source reference>
```

- Omit `## Open Questions` when no unresolved questions remain.
- Omit `## References` only when no source reference exists.
- Do not write the draft to `raw` yet.

### 4. Human review

- Present the complete draft for the user's review.
- Answer second-round questions and revise the same draft as needed.
- Treat feedback as changes to a draft, not as approval to persist it.
- Stop and wait for the user to say `save` or give equally explicit save approval.

### 5. Contextual Grounding Check

After explicit save approval but before writing to `raw/`, perform a Contextual Grounding Check against the material actually available during the learning session.

Verify all of the following:

1. **Source grounding**
   - Objective claims in `Concepts` are supported by the source material, preserved references, or clearly established session context.
   - Do not introduce unsupported facts merely from model memory.

2. **Dialogue grounding**
   - `Understanding` reflects reasoning, explanations, examples, corrections, or conclusions actually developed during the learning dialogue.
   - Do not attribute an interpretation, conclusion, or mental model to the user unless it was expressed or clearly established during the session.

3. **Scope grounding**
   - The final note remains inside the selected KP's learning boundary.
   - Remove unrelated knowledge that entered the conversation but is not necessary to understand this KP.

4. **Reference consistency**
   - References retained in the raw note genuinely identify or support the source material used for this KP.
   - Do not silently drop existing source references.
   - Do not invent references to justify unsupported content.

The grounding check is a commit gate:

- If the draft passes, proceed with the approved save.
- If the check finds only non-substantive formatting issues, correct them without changing meaning and continue.
- If the check finds unsupported, misattributed, out-of-scope, or materially changed content, do not write to `raw/`.
- Revise the draft, explain the material grounding correction to the user, and require explicit save approval again before rerunning the check.

### 6. Commit to raw

- Before saving, verify that any reference information associated with the selected KP or source material is present in the final draft.
- Do not commit a raw KP that silently drops existing source references.
- Only after explicit approval and a passing Contextual Grounding Check, resolve the course's existing `raw` folder and save the Markdown there. Preserve the established filename, terminology, and folder conventions when available.
- If the destination is ambiguous, ask only for the missing location at commit time; never guess among multiple `raw` folders.

## Invariants

- Learning may transform knowledge, but must not sever provenance.
- Nothing enters `raw/` until it passes the Contextual Grounding Check.
- A material grounding revision invalidates the previous save approval and requires the user to approve the revised draft again.

## Completion

The KP is complete only when:

1. the user has reviewed the final draft;
2. the user has explicitly approved saving it;
3. the final approved draft has passed the Contextual Grounding Check; and
4. the Markdown file has been successfully written to the intended `raw` folder.

If any condition fails, keep the KP in review or report the write blocker.
