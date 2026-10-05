# Folder Structure

The learning workspace uses three knowledge layers:

```text
<learning-root>/
|-- preRaw/
|-- raw/
`-- wiki/
```

## preRaw

`preRaw/` contains unprocessed source material, imports, notes, transcripts, and other inputs that may support learning.

Content in `preRaw/` is evidence or working material. It is not an approved learning artifact.

## raw

`raw/` contains completed KP learning notes produced from the actual learning dialogue, explicitly approved by the user, and passed through the Contextual Grounding Check.

A raw KP should remain traceable to the source material from which it was learned. When source references exist, preserve them in the raw note.

This is the only knowledge-layer destination that KP Learning may write to. A draft must not enter `raw/` until the user gives explicit save approval and the final approved content passes the grounding gate.

## wiki

`wiki/` contains stable, synthesized knowledge derived from one or more approved raw notes.

Wiki synthesis and promotion are outside the scope of KP Learning. Never write directly to `wiki/` while running this skill.

## Invariants

- Preserve the existing folder names and structure.
- Do not create parallel variants such as `pre-raw`, `Raw`, or `knowledge-wiki`.
- Treat `preRaw/` as input, `raw/` as the approved and grounded output of this skill, and `wiki/` as a downstream knowledge layer.
- Preserve source provenance when promoting learned material into `raw/`; never silently discard existing references.
