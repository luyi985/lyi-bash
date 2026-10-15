# Common Workflow

## 0. Preview the specified structure

For new analysis or replanning, inspect the specified source to establish what material is present before detailed analysis. This read-only preview may precede resolving the learning root. Skip source preview for progress-only requests and go directly to step 1. For a single file, inspect its type and outline rather than scanning unrelated neighboring files. For external sources, preview the accessible resource structure using available tools; a local copy is not required.

- For a directory, list its main sections, identify file types and representative entrypoints or configuration files, and classify the material as code, documents, or a mixture. Expand selected relevant subdirectories as needed; do not recursively read every file.
- Prune dependency and environment directories such as `node_modules/`, `.venv/`, `venv/`, and `__pypackages__/`; version-control directories such as `.git/`, `.hg/`, and `.svn/`; and recognizable caches or generated outputs such as `__pycache__/`, `.pytest_cache/`, `.mypy_cache/`, `.next/`, and `coverage/`. Skip directories such as `vendor/`, `dist/`, and `build/` only when their role as dependency or generated output is established. Keep dependency manifests and lockfiles visible because they help explain the project structure.
- Apply exclusions during traversal, not only when formatting the results. Do not follow directory symlinks outside the selected scope. If the user explicitly selects an otherwise skipped directory, inspect that target; if later analysis requires excluded material, inspect only the relevant part and disclose the expanded scope.
- Give a concise content map, likely reading entrypoints, and the preview's coverage, skipped categories, and access limitations. A directory listing or README alone is not proof that the full source is accessible.
- Reuse preview results during workspace inspection and validation in this execution; revisit only unresolved or newly relevant areas.

Do not generate or revise KPs during this preview. Continue with workspace inspection and source validation; detailed content and code analysis still require the validation gate to pass.

## 1. Recover the workspace

Resolve the learning root independently of source paths, inspect its existing structure, and read existing Markdown KP definitions recursively under `preRaw/KP/`, including files directly in that directory. Check duplicate IDs across that entire set, not just within each subdirectory; learned notes in `raw/` are not duplicate definitions. Do not follow directory symlinks outside the KP tree. Interpret and validate metadata using `kp-specification.md`; report malformed files, unknown statuses, and duplicate IDs instead of repairing them silently. Report valid status counts separately from invalid files.

For progress-only requests, report counts, current items, and next eligibility using `kp-specification.md`, then stop. Do not create missing directories, reopen source links, or rewrite KPs. If the workspace or KP directory is missing or empty, report that no plan is available; do not treat an empty set as a completed course.

For analysis or replanning, read `folder-structure.md`. Initialize only missing required directories when a write is needed, after the requested sources have passed step 2. Preserve existing paths and material.

## 2. Validate the requested sources

Apply `learning-source.md` to the sources needed for this analysis or replanning scope. Reuse the preview's structure observations, verify content access, and retain precise source locators with the prescribed path bases. Local inputs require no remote connector; do not fetch unrelated historical sources again.

If a required source fails validation, report the missing coverage and available existing progress, then stop without changing the KP plan. Validation success permits detailed analysis; a preview alone does not.

## 3. Analyze and reconcile the KP plan

Inspect structure, concepts, prerequisites, examples, exercises, and explicit objectives. Separate source facts from inferred learning structure. A supplied learning mode may affect decomposition depth, order, and practice emphasis, but not workspace or KP invariants.

Compare proposed learning objectives with existing KPs first. Build or reconcile drafts using the schema, quality requirements, and update rules in `kp-specification.md`. Keep definitions and examples brief enough to prepare learning without writing full lessons or attributing understanding to the user.

- Retain unchanged KPs and statuses.
- Update safe metadata or scope clarifications without erasing user content.
- Add missing KPs as `pending`.
- Pause before splits, merges, or retirement of active or completed KPs.
- Validate the combined existing and proposed KP set, including identities and hard prerequisites, before saving. For new or explicitly revised citations, check relative path bases and that metadata and body references resolve to the same targets and locations. Preserve unrelated legacy citations. If invalid, report the issues and leave the plan unchanged until resolved; do not manufacture edges or rewrite identities to force a valid plan.

## 4. Persist and report

Once validation passes, initialize missing directories if needed and write only new or safely updated definitions to `preRaw/KP/{kp-id}.md`. Count only successful writes as changes; if a write fails, report what was and was not saved and rescan actual files before reporting progress.

Report the learning root, source validation and limitations, KP changes, status counts, current items, and next eligibility according to `kp-specification.md`. Include the preview summary without emitting a second copy of the same map. Stop there; teaching the KP is outside this skill.
