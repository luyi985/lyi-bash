---
name: kp-learning
description: Learn one knowledge point through detailed concept explanations, explicit relationships, examples, and responsive discussion, followed by user-approved Markdown capture. Use whenever the user wants to study and document a single KP.
---

# KP Learning

Take exactly one knowledge point from selection to an approved note in the target `raw` folder. Keep the KP's existing name and identity unless the user changes it.

Teach the concepts and their relationships explicitly before using questions to check or deepen understanding. This skill must work without ChatGPT Study mode. When Study mode is available, adapt it to this explanation-first approach; the teaching requirements and approval gates below remain authoritative.

## KP identity

Every KP ID must follow this schema:

```text
{namespace}-{scope}-{context}-{index}
```

The braces denote fields and are not part of the actual ID. Keep all four fields and their order. Reuse the course's established values and index style when they exist; do not silently rename an existing KP or invent a conflicting sequence. Use the KP ID consistently in the preview, Markdown title, references, and filename.

## Folder structure

Before using the workflow, read [references/folder-structure.md](references/folder-structure.md). It defines the `preRaw`, `raw`, and `wiki` knowledge layers, their allowed contents, provenance expectations, and the write boundary for this skill.

## Existing KP progress

Read existing Markdown definitions recursively under the resolved learning root's `preRaw/KP/`, including files directly in that directory, and check duplicate IDs across the entire tree. Do not follow directory symlinks outside that tree; matching raw-note IDs are not duplicate definitions. If the selected KP uniquely matches a readable, valid definition by ID, update only its frontmatter `status` and optional `learned_note`; preserve identity, sources, dependencies, body, other metadata, user-authored content, and its existing location. Re-read the definition before each update to avoid overwriting intervening edits. Do not create a plan, add missing KP files, or depend on another skill for standalone learning. If the root or match is ambiguous, or metadata needed for the match is unreadable or invalid, continue learning but withhold metadata writes and report the blocker.

KP `status` is the only progress authority; checkboxes in a route plan do not authorize status changes. If resuming a workspace without a selected KP, prefer existing `learning` or `review` items. When more than one exists, list them and ask the user to select one; never resume several automatically.

- After explicit approval to start interactive learning, set `status: learning`.
- When the complete draft is presented for user review, set `status: review`. Failed approval, grounding, or note persistence must not advance this to `completed`.
- Only after the approved note passes the grounding gate and is successfully written, set `status: completed` and `learned_note` to its path relative to the learning root, for example `raw/{kp-id}.md`.
- Preserve an existing `completed` status and note link during ordinary relearning unless the user explicitly reopens that KP. Explicit reopening permits the transitions above; retain the previous link until a replacement is successfully saved. A separately approved replacement note may update the link after successful persistence.
- If a metadata write fails, report the actual learning or note-save result separately from the unsynchronized status. After a successful note save, retry only metadata synchronization using that saved note as evidence; do not save the same note again just to repair progress. Do not infer approval or completion from an unrelated existing file.

## Resume boundary

Recovery is at KP level; this skill does not persist drafts or dialogue checkpoints. For a `learning` KP, establish the continuation point from available session context and the user; if it cannot be established, return to the preview instead of inferring mastery. For a `review` KP, look for the complete draft in the available session context. If it is unavailable, state that it must be reconstructed from available sources and user-confirmed understanding, present the reconstructed draft for review, and obtain fresh save approval. If supporting dialogue is missing, ask the user to restate their understanding or resume learning; never invent it. A `review` status alone is neither a stored draft nor save approval. Do not claim to restore a lost draft verbatim or carry unavailable approval into a new draft.

## Reference preservation

A completed raw KP must preserve its original sources, not only a link to its preRaw definition. Before collecting citations or drafting a note, read [references/source-provenance.md](references/source-provenance.md) for the inheritance, relative-path, and legacy-compatibility contract. It is self-contained and does not require another skill.

Local learning requires no Google Drive or remote connector. Use connectors only for corresponding user-specified remote sources; retain existing URLs and document IDs without implying they were reread. Preserve source identity and precise locators, allowing local path conversion to keep links correct at the output's location. Do not invent references or attribute the assistant's explanations to external sources. Provenance is independent of the user's `Understanding`.

## Workflow

### 1. Preview

- State the KP and its learning boundary.
- List the related core concepts with a short, plain explanation for each.
- Show the intended reasoning order and the main relationships to be explained. Brevity applies to this preview, not to the lesson that follows.
- Do not begin the full lesson yet.
- Stop and wait for the user to say `continue` or give equivalent explicit approval.

### 2. Detailed teaching and discussion

After approval, explain the scoped concepts in a coherent sequence. Provide the substance of the lesson proactively; do not make the user discover missing explanations through repeated answers to questions.

Apply the learning transition in `Existing KP progress` when a matching definition is available.

- Explain each core concept in enough detail to understand what it means, the problem it addresses, how and why its mechanism works, and its relevant assumptions, boundaries, and common confusions. Introduce necessary prerequisites and unfamiliar terms before relying on them. Adapt these dimensions to the concept rather than mechanically filling a template or repeating definitions.
- Connect the concepts explicitly: identify relevant prerequisite, composition, causal, data/control-flow, or contrast relationships and explain why each relationship holds. Distinguish causation from sequence and required prerequisites from helpful context. Explain how these concepts jointly answer the KP's central question; a list of isolated definitions is insufficient. This is conceptual analysis within the selected KP, not a rewrite of the workspace dependency graph.
- Use a concrete example to trace the mechanism and the participating concepts step by step. Prefer a shared example that connects several concepts; add a counterexample or boundary case when it resolves a likely confusion. For code-based KPs, connect explanations to available code and trace relevant inputs, transformations, and results; label invented examples as illustrative. Use a small diagram or comparison table when it makes a relationship clearer, and explain its meaning in prose.
- Organize a long lesson into connected sections or meaningful parts, giving a complete explanation of each part before a check-in. Depth comes from mechanisms, reasoning, examples, and boundaries, not from word count or a fixed number of questions. Do not reduce the main lesson to a brief glossary followed by a quiz.
- Use focused questions after a substantive explanation when they help diagnose a specific misunderstanding or support transfer. Questions are optional and do not gate access to the remaining explanation. Answer the user's questions directly, then clarify or explore further as useful; do not routinely respond with another question in place of an explanation. If the user prefers uninterrupted explanation, continue without requiring answers.
- Use the user's feedback to revisit reasoning gaps, correct misconceptions, or add examples. Do not infer understanding from silence, agreement, or merely having delivered a detailed explanation.
- Keep the dialogue within the previewed KP scope unless a dependency is necessary or the user expands the scope.
- Do not force a mechanical quiz or add a separate verification stage. The dialogue itself supplies the learning feedback.

Before moving to the note draft, ensure the scoped core concepts, their important relationships, and an explanatory example have actually been covered, unless the user explicitly narrows the scope or asks to stop. If the user stops early, preserve remaining gaps as open questions rather than claiming mastery or silently treating them as covered.

### 3. Draft and review the raw note

Generate a Markdown draft from the teaching and discussion that actually occurred. Preserve the substantive concept explanations, reasoning, examples, and relationships developed in the session; do not collapse them into one-line definitions. Separate objective explanation from understanding actually expressed or established by the user.

Use this structure when it fits the material:

```markdown
# <namespace-scope-context-index>: <KP title>

## Concepts

### <Concept>
Grounded explanation of meaning, purpose, mechanism, relevant boundaries, and examples actually covered in the lesson.

## Concept Relationships

- Explain the important relationships among the scoped concepts, why they hold, and how the concepts work together in the example.

## Understanding

- The user's explanation or mental model
- Important reasoning and links to existing knowledge
- Misconceptions corrected during the discussion
- Useful examples, counterexamples, boundaries, or tradeoffs

## Open Questions

- Only unresolved questions that remain after the session

## References

- <inherited original source with file-relative local link or unchanged external identifier; precise locator and consultation status>
- <additional source directly used in this session, when applicable>
```

- Omit `## Open Questions` when no unresolved questions remain.
- Omit `## Understanding` when no user understanding has actually been established; do not fill it with the assistant's own explanation attributed to the user. Omit `## Concept Relationships` only when no separate relationship applies to the selected KP.
- Omit `## References` only when no source reference exists.
- Build `References` from the complete inherited source set plus additional session sources according to `source-provenance.md`. Resolve the intended note location before rendering local links; ask if it is ambiguous. Keep the note unsaved until approval and the grounding gate pass.
- Do not write the draft to `raw` yet.
- Present the complete draft for the user's review.
- Apply the review transition in `Existing KP progress` when a matching definition is available.
- Answer second-round questions and revise the same draft as needed.
- Treat feedback as changes to a draft, not as approval to persist it.
- Stop and wait for the user to say `save` or give equally explicit save approval.

### 4. Contextual Grounding Check

After explicit save approval but before writing to `raw/`, perform a Contextual Grounding Check against the material actually available during the learning session.

Verify all of the following:

1. **Source grounding**
   - Objective claims in `Concepts` and `Concept Relationships` are supported by the source material, preserved references, or clearly established session context.
   - Do not introduce unsupported facts merely from model memory.

2. **Dialogue grounding**
   - `Understanding` reflects reasoning, explanations, examples, corrections, or conclusions actually developed during the learning dialogue.
   - Do not attribute an interpretation, conclusion, or mental model to the user unless it was expressed or clearly established during the session.

3. **Scope grounding**
   - The final note remains inside the selected KP's learning boundary.
   - Remove unrelated knowledge that entered the conversation but is not necessary to understand this KP.

4. **Reference consistency**
   - Reconcile the preRaw KP's frontmatter and body references with the draft according to `source-provenance.md`; every inherited original reference and additional source used in the session must be accounted for.
   - Verify converted local paths identify the same source targets and precise locations, and external identifiers remain intact. Resolve conflicting or ambiguous targets before saving; do not silently discard a reference or select one competing target.
   - Distinguish inherited provenance from sources actually consulted in this session. An unavailable inherited external reference remains labeled unverified; it is not proof of a newly taught claim. Do not invent references to justify unsupported content.

The grounding check is a commit gate:

- If the draft passes, proceed with the approved save.
- If the check finds only non-substantive formatting issues, correct them without changing meaning and continue.
- If the check finds unsupported, misattributed, out-of-scope, or materially changed content, do not write to `raw/`.
- Revise the draft, explain the material grounding correction to the user, and require explicit save approval again before rerunning the check.

### 5. Commit to raw

- Only after explicit approval and a passing Contextual Grounding Check, save the Markdown to the previously resolved `raw` destination. Preserve the established filename, terminology, and folder conventions when available.
- Use the destination established for the reviewed draft's relative links. If it changes, recompute local links and recheck target equivalence before saving; if the destination remains ambiguous, ask for it and never guess among multiple `raw` folders.
- After the note has been successfully written, synchronize its completion metadata according to `Existing KP progress`. A metadata failure does not undo or duplicate the saved note.

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

For a matched planned KP, dependent learning remains blocked until its `completed` metadata is synchronized. Standalone learning does not require a planning file. A saved note and an unsynchronized planned status must be reported as separate outcomes.

If any condition fails, do not mark the KP completed; keep its current learning or review status and report the blocker, subject to the completed-KP preservation rule above. Report note persistence and progress synchronization separately when they differ.
