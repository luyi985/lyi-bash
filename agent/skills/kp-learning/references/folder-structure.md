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

When a selected KP uniquely matches an existing definition anywhere under `preRaw/KP/`, KP Learning may update only that file's frontmatter `status` and `learned_note` fields at the lifecycle events defined in `SKILL.md`. Preserve all other content and the file's location. This metadata exception does not authorize creating KP definitions, editing the plan, moving sources, or writing learned drafts into `preRaw/`. Drafts and dialogue checkpoints are not persisted by this skill.

## raw

`raw/` contains completed KP learning notes produced from the actual learning dialogue, explicitly approved by the user, and passed through the Contextual Grounding Check.

A raw KP inherits the original references from its preRaw KP's frontmatter and body, plus any additional sources used in the session. A link to the preRaw definition may supplement but cannot replace those original references. Local source links are relative to the actual raw Markdown file, and source metadata locators, if present, are relative to the learning root. Preserve external URLs, IDs, and precise locators. See [source-provenance.md](source-provenance.md) for the self-contained inheritance and legacy-path rules.

This is the only destination for learned-note content. The existing-KP metadata exception above is the only permitted write to `preRaw/`. A draft must not enter `raw/` until the user gives explicit save approval and the final approved content passes the grounding gate.

## wiki

`wiki/` contains stable, synthesized knowledge derived from one or more approved raw notes.

Wiki synthesis and promotion are outside the scope of KP Learning. Never write directly to `wiki/` while running this skill.

## Invariants

- Preserve the existing folder names and structure.
- Do not create parallel variants such as `pre-raw`, `Raw`, or `knowledge-wiki`.
- Treat `preRaw/` as input with the narrow existing-KP metadata exception above, `raw/` as the approved and grounded output of this skill, and `wiki/` as a downstream knowledge layer.
- Preserve source provenance when promoting learned material into `raw/`; never silently discard existing references.
