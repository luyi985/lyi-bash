# Learning Source

## Accepted inputs

- `LocalSource`: a specified readable file, folder, or repository, inside or outside the learning workspace. Reference it in place as read-only; do not automatically copy, move, or modify it.
- `ExternalSource`: an external link or externally addressable resource available through the current runtime.

Resolve sources using the capabilities available in the current environment; do not bind this specification to one connector or transport. Local files and repositories support the complete preparation workflow without Google Drive or any remote connection. Use a connector only for a corresponding user-specified remote source. Google Drive remains optional; its absence does not block local learning, and removing the dependency does not remove existing Drive references. Do not automatically export, download, or copy material into the learning workspace.

Resolve source locations separately from the learning root. Existing material under `preRaw/` remains valid; `preRaw/sources/` is not a mandatory staging location.

## Source locators and path bases

- In newly generated or explicitly revised outputs, store all local source paths as relative paths, including sources outside the workspace. Runtime tools may resolve absolute paths for access, but do not persist those absolute source paths, home-directory expansions, or local `file://` URLs in KP metadata or source citations.
- In frontmatter `sources`, local paths are relative to the learning root. In body Markdown links, targets are relative to the Markdown file that contains the link. Body plain-text local source locators use the same file-relative base; prefer clickable links. Both forms must identify the same source and precise location, not contain identical path strings.
- Compute each relative path from its actual base; do not hard-code a fixed number of `../` segments. Sources outside the learning root may use `../`; reference them in place. Moving the learning root alone can break such links because their validity depends on preserving the relative directory layout.
- Preserve source names and heading fragments, symbol names, page numbers, timestamps, and other locators when converting a path. For code, record an available revision or dirty-worktree limitation rather than implying an immutable source. Escape Markdown link targets as needed without changing the file or locator they identify.
- URLs, Drive document IDs, and other external resource identifiers are not local filesystem paths. Preserve them faithfully, including fragments and query parameters; do not invent a relative-path replacement. If an authorized local copy is supplied, it may be recorded alongside the original identifier without replacing provenance.

For a file at `<learning-root>/preRaw/sources/course.md`, equivalent locators are:

| Location of reference | Local locator |
|---|---|
| KP frontmatter `sources` | `preRaw/sources/course.md#transactions` |
| `preRaw/KP/{kp-id}.md` body | `[Course](../sources/course.md#transactions)` |
| `preRaw/KP/chapter/{kp-id}.md` body | `[Course](../../sources/course.md#transactions)` |
| `raw/{kp-id}.md` body | `[Course](../preRaw/sources/course.md#transactions)` |

## Historical references

Read legacy absolute paths and earlier path conventions without rewriting their files. For a new output, resolve the original target using its declared base or verified context, then convert the local path to the appropriate new base. A legacy body locator may have been learning-root-relative; do not reinterpret it blindly as file-relative. If multiple bases are plausible, report the ambiguity and resolve it before emitting or saving a converted reference. Do not silently choose a different existing file.

Only adjust references in the output currently requested. Do not batch-migrate old KPs, change their status, or rewrite approved notes as a side effect. Progress-only inspection remains compatible with old path styles and does not require link migration or source access.

## Validation gate

Structure preview may precede this gate and can establish resource type and coverage, but it does not establish full content access. Before detailed content or code analysis and KP planning, verify the sources needed for the requested scope:

1. the resource exists or resolves;
2. it is readable;
3. its expected scope is accessible, not only its title or summary;
4. no obviously required part is missing;
5. the obtained content is sufficient for the requested decomposition.

For folders, repositories, courses, and multi-page collections, inspect enough structure to distinguish complete access from a landing page, README, excerpt, or partial listing.

Excluded dependency, environment, or generated directories are not automatically missing required material. If the requested scope needs a specific excluded part, inspect that part and disclose the expanded scope, or report it as unavailable. Validate the requested learning boundary rather than requiring unrelated repository or collection contents.

## Failure behavior

If validation fails, do not change the KP plan. Identify each unavailable or incomplete required input, distinguish access failure from missing material or uncertain scope, and state the smallest action needed to continue. Existing KP progress may still be read and reported. Progress-only requests do not require revalidation of historical sources.

Validation confirms accessibility and apparent coverage; it does not claim the source is factually correct.
