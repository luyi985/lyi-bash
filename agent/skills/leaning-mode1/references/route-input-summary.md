# Route Input Summary

Read when creating, validating, or resuming a Mode 1 plan. This summary detects changes to route inputs across sessions; it is not a progress record and never authorizes a completion transition.

## Stored representation

In `mode1.md`, use a `Route Input Summary` section with `format: semantic-sha256-v1` and one table row per KP:

| KP ID | Path relative to learning root | SHA-256 |
|---|---|---|
| example-core-topic-001 | preRaw/KP/example-core-topic-001.md | computed digest |

Sort rows by KP ID, then path. Store only real computed digests, not placeholders or hashes inferred by the model. If required file access or hashing tools are unavailable, report that comparison cannot be established and validate the route directly rather than claiming unchanged inputs.

## Fingerprint construction

For each discovered KP definition:

1. Parse its YAML frontmatter as a mapping and retain its Markdown body. Validate metadata first; unreadable files or duplicate IDs block a valid summary.
2. Remove only the top-level frontmatter fields `status` and `learned_note` from the fingerprint input. Keep every other field and the body, including scope, objectives, prerequisite explanations, examples, sources, and user-authored content. Do not edit the source file.
3. Construct the object `{"path": <relative POSIX path>, "metadata": <remaining mapping>, "body": <body>}`. Normalize body line endings to LF; retain other body text. Frontmatter delimiter lines are not part of the body. Encode YAML date/time scalars as their ISO strings and require string mapping keys so different tools can reproduce the object; unsupported metadata values are a comparison limitation, not grounds to rewrite a KP.
4. Serialize that object as UTF-8 JSON with recursively sorted mapping keys, literal Unicode, no extra spaces, and no appended newline. Compute SHA-256 over those bytes. Preserve sequence order. These are file-content fingerprints, not hashes of summaries written by the model.

This deliberately treats other metadata or body changes conservatively as possible route changes. Semantic equivalence can be assessed during review; progress-only changes never alter these fingerprints.

## Comparison and invalidation

- Compare the complete set of IDs, paths, and digests with the last validated summary. Membership changes and file moves are changes even when a title is unchanged.
- If all fingerprints match, retain a structurally valid existing graph and order; refresh only progress from current KP statuses. Still check current statuses and prerequisite validity, and do not trust a plan with missing or duplicate route entries, backward hard-prerequisite ordering, or unresolved route blockers merely because input hashes match. A disputed dependency also requires review.
- If inputs differ, inspect changed KPs and their connected relationships. Reevaluate affected order and edges when the impact is clear. Recheck the full graph when impact is uncertain, the map is invalid, or a dependency dispute cannot be bounded. Revalidate the final route against all explicit hard prerequisites.
- A plan without a supported summary needs one direct route and prerequisite revalidation before establishing this baseline. Keep a valid old order and user notes; missing hashes do not justify discarding the whole plan. Do not repeat this legacy check solely because progress later changes.
- Write the new summary only with a validated route. If unresolved findings prevent validation, retain the last validated summary (if any) and mark the route blocked; do not stamp changed inputs as accepted. A progress-only query reports its findings without writing a summary or refreshing the plan file.
- Reconcile old checkbox mismatches separately from these fingerprints. Display reconciliation never changes source KP status and does not make a valid route semantically stale.
