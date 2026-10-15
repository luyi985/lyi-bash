# Source Provenance

Read before collecting citations, drafting a raw KP, or checking reference consistency. These rules work without any other skill or Google Drive connection. They change source representation in the requested output, not existing source files or approved notes.

## Inherit original references

1. Read the selected preRaw KP's frontmatter `sources` and body source sections, including headings named `Sources` or `References`. Include any other explicit citations that identify supporting material; do not rely on the reference heading alone. Standalone learning without a preRaw definition uses the actual available session sources and does not create a planning file or invent references.
2. Reconcile entries by source target and precise location, retaining source names, URLs, document IDs, headings, symbols, page numbers, timestamps, and other original locators. Equivalent entries may be deduplicated while retaining their useful descriptions. Different targets or locations must all be retained; a section missing from a legacy file does not erase references present elsewhere.
3. If frontmatter and body disagree, report the mismatch. An omission can be handled by carrying the union into the draft and disclosing it without modifying the preRaw file. Competing targets for the same claimed reference or uncertain path bases require resolution before saving; do not silently choose one or invent a replacement.
4. Put the complete inherited set into the raw note's `References`, then add sources directly used during the current session. Mark entries as inherited, directly consulted, or both. For inherited entries that were not rechecked, say so; do not imply fresh access or verification. Preserve a temporarily inaccessible external identifier and label its access unverified, rather than deleting it or pretending it supports a new factual claim.
5. A link to the originating preRaw KP can be included as lineage, but never replaces its original references. Do not treat ChatGPT explanations as external sources or infer provenance from user understanding.

## Relative local paths

- Runtime tools may resolve absolute local paths for access. In newly generated or explicitly revised source citations, use relative local paths, not absolute paths, home-directory expansions, or local `file://` URLs. Do not automatically copy, move, download, or export the material to obtain a relative path.
- Frontmatter `sources`, if present, uses paths relative to the learning root. Body local links and plain-text local locators are relative to the Markdown file that contains them; prefer clickable links. Raw notes do not need new frontmatter solely for provenance.
- Resolve inherited references from their original base first, retaining the precise locator, then compute the path from the actual destination file. Do not copy a preRaw body link unchanged into raw or assume a fixed nesting depth. External local sources may use `../`; links remain portable only while the relative directory layout is preserved.
- Preserve URLs and external resource identifiers exactly, including Drive IDs, query parameters, and fragments. They are not filesystem paths and need no relative conversion. Local-only learning does not call remote connectors; only user-specified remote sources may require them. Inheriting an existing remote citation alone does not require fetching it.
- Read legacy absolute paths and earlier learning-root-relative body citations compatibly. Establish the original base from declared conventions or verified context before conversion. If multiple targets are plausible or the target cannot be established, report the ambiguity and resolve it before saving a converted reference. Do not interpret absence of access as evidence for a different target.
- Verify the original and converted forms identify the same file and locator. For missing local files with an otherwise known target, retain the reference in the draft and disclose its unresolved accessibility; do not claim verification or silently redirect it. A missing source required to support the note's claims remains a grounding blocker. Escape Markdown link syntax as needed without changing the target.

For `<learning-root>/preRaw/sources/course.md`, equivalent representations are:

| Reference location | Local locator |
|---|---|
| preRaw KP frontmatter | `preRaw/sources/course.md#transactions` |
| `preRaw/KP/{kp-id}.md` body | `[Course](../sources/course.md#transactions)` |
| `preRaw/KP/chapter/{kp-id}.md` body | `[Course](../../sources/course.md#transactions)` |
| `raw/{kp-id}.md` body | `[Course](../preRaw/sources/course.md#transactions)` |
| `raw/chapter/{kp-id}.md` body | `[Course](../../preRaw/sources/course.md#transactions)` |

If the raw destination is ambiguous, resolve it before presenting the draft's local links. A new destination requires recomputing and rechecking those links, not copying old relative strings.

## Compatibility and save check

Before saving, account for every inherited reference and additional session source, check source/locator equivalence after path conversion, and ensure no new absolute local source paths were introduced. Resolve conflicting targets first. Preserve the draft's distinctions between inherited and consulted sources, including access limitations. Omit `References` only when there truly are no references in either the source KP or session material.

Do not batch-migrate historical KPs, rewrite the original preRaw KP's citations, or modify approved raw notes as a side effect. The existing narrow metadata writeback remains limited to `status` and `learned_note`. Progress-only inspection does not require path migration, source access, or a Drive connection.
