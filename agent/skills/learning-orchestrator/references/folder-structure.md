# Learning Workspace Structure

```text
<learning-root>/
|-- preRaw/
|   |-- sources/
|   `-- KP/
|-- raw/
`-- wiki/
```

## Directory meanings

- `preRaw/` is the unapproved working layer.
- `preRaw/sources/` holds copied, downloaded, imported, or user-provided inputs when local persistence is appropriate. Preserve older workspaces that keep material directly under `preRaw/`.
- `preRaw/KP/` contains planned KP definitions and status. These are working state, not learned notes.
- `raw/` contains user-approved learning notes. This skill must not write there.
- `wiki/` contains synthesized long-term knowledge. This skill must not write there.

## Initialization

Always inspect the target root first.

- If no structure exists, create `preRaw/sources/`, `preRaw/KP/`, `raw/`, and `wiki/`.
- If part exists, create only missing required directories.
- Use the canonical names above; do not create aliases such as `pre-raw`, `Raw`, or `knowledge-wiki`.
- Do not move existing files merely to normalize an older workspace.

The learning root represents one bounded course, project, certification, repository, or topic. It is persistent state, not part of the skill installation.
