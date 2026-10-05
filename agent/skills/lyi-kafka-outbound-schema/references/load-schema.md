# Domain `loadSchemaJson` (runtime schema loader)

Use this when Step 1 finds no loader, the loader only checks one path, Kafka JSON is copied somewhere the loader never looks, or a published Domain package depends on an unpublished `@…/schemas` package.

Kafka wire schemas are **runtime assets**. They must load through Domain-owned `loadSchemaJson`, not through a published `schemas` npm package.

## Ownership rules

1. Put the loader at `src/domain/load-schema.ts` and import it as `@<project>/domain/load-schema`.
2. Do **not** put the real loader under `src/schemas/load-schema.ts` if Domain (or any published package) imports that path. Playbook `generate-packages` will then add `@<project>/schemas` as a Domain dependency. If `schemas` is absent from `npmPackages`, consumers get npm **E404**.
3. Do **not** add `schemas` to `npmPackages` just to fix the E404. Domain must be self-contained.
4. A `src/schemas/load-schema.ts` that only re-exports Domain is optional compatibility for monorepo call sites that already import `@<project>/schemas/load-schema`. Prefer migrating callers to Domain and deleting the re-export when nothing uses it.
5. Never generate `.d.ts` from `*-kafka.schema.json`. Loader is for runtime JSON only.

## Required loader shape

Sync load. Multi-candidate resolve. Fail with the full candidate list.

Adapt `<project>` and subdirs to the repo (`kafka` is required for this skill; include `data` / `common` / `requests` when those assets also load through the same helper):

```ts
import { existsSync, readFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const findProjectRoot = (startDir: string): string => {
  let dir = startDir;
  while (dir !== path.parse(dir).root) {
    if (existsSync(path.join(dir, "package.json"))) {
      return dir;
    }
    dir = path.dirname(dir);
  }
  return process.cwd();
};

const resolveSchemaFilePath = (fileName: string): string => {
  const moduleDir = path.dirname(fileURLToPath(import.meta.url));
  const root = findProjectRoot(moduleDir);
  const subdirs = ["data", "requests", "common", "kafka"] as const;

  const candidates = [
    path.join(moduleDir, fileName),
    ...subdirs.map((subdir) => path.join(moduleDir, subdir, fileName)),
    path.join(moduleDir, "..", "schemas", fileName),
    ...subdirs.map((subdir) => path.join(moduleDir, "..", "schemas", subdir, fileName)),
    path.join(root, "build/schemas", fileName),
    ...subdirs.map((subdir) => path.join(root, "build/schemas", subdir, fileName)),
    path.join(root, "src/schemas", fileName),
    ...subdirs.map((subdir) => path.join(root, "src/schemas", subdir, fileName)),
    path.join(root, fileName),
  ];

  const filePath = candidates.find(existsSync);
  if (filePath) {
    return filePath;
  }

  throw new Error(
    `<project>: missing schema file "${fileName}". Checked: ${candidates.join(", ")}. Run "npm run build" (and bundle copy) to ship bundled schemas.`
  );
};

export const loadSchemaJson = <T>(fileName: string): T => {
  const filePath = resolveSchemaFilePath(fileName);
  return JSON.parse(readFileSync(filePath, "utf8")) as T;
};
```

### Why multi-path

| Layout | Typical hit |
|---|---|
| Published Domain package | `moduleDir/kafka/<file>` next to compiled `load-schema.js` |
| Monorepo `build/` | `../schemas/kafka/<file>` or `build/schemas/kafka/<file>` |
| Source / tests before copy | `src/schemas/kafka/<file>` |

A single `path.join(moduleDir, fileName)` works only when every runtime already copied JSON beside the module.

## Call-site pattern (Kafka)

Source of truth: `src/schemas/kafka/<name>-kafka.schema.json`.

```ts
import { loadSchemaJson } from "@<project>/domain/load-schema";
import type { Schema } from "ajv";

export class SomeOutboundMessage {
  static readonly jsonSchema: Schema = loadSchemaJson("kafka/some-outbound-kafka.schema.json");
  // …
}
```

Pass **that same constructor** to `sendWithSchema`. Do not load the file in the producer ad hoc unless the repo already does that and the user asked to preserve it.

Prefer a path that matches the on-disk layout after copy (`kafka/…`). If the repo copies Kafka JSON flat into the Domain package root (translation-api data style), use the bare filename the repo already uses—do not invent a second convention.

## Asset copy (must match loader candidates)

Maintain a copy script (often `scripts/copy-domain-schema-json.mjs`) that:

1. Copies `src/schemas/kafka/*-kafka.schema.json` into **both**:
   - `build/domain/kafka/`
   - `build/.bundles/domain/kafka/`
2. Also copies any other runtime schema dirs the Domain loader serves (`data`, `common`, `requests`) using the same target roots.
3. Copies `src/domain/generated` into Domain package targets when the repo already does that.

Wire the script in **both**:

```json
"postbuild": "… && node scripts/copy-domain-schema-json.mjs",
"bundle:packages": "playbook-cli generate-packages --project . && node scripts/copy-domain-schema-json.mjs"
```

`postbuild` alone is not enough: release packaging that only runs `generate-packages` will drop Kafka JSON from the published Domain tarball unless `bundle:packages` copies again **after** generate.

## Verification checklist

After `npm run build && npm run bundle:packages` (or the repo’s release equivalent):

- [ ] `rg "@<project>/schemas/load-schema" src` is empty, or only intentional legacy callers remain
- [ ] `build/.bundles/domain/package.json` has **no** `@<project>/schemas` dependency
- [ ] `build/.bundles/domain/kafka/` contains the `*-kafka.schema.json` files used by MessageCtors
- [ ] Smoke: import Domain `load-schema` from the bundle path and `loadSchemaJson("kafka/…-kafka.schema.json")` succeeds
- [ ] MessageCtor `static jsonSchema` is defined from that loader; `sendWithSchema` uses the same ctor

## Anti-patterns

| Anti-pattern | Result |
|---|---|
| Domain imports `@<project>/schemas/load-schema` | Published Domain depends on unpublished `schemas` → consumer `npm i` E404 |
| Publish `schemas` only to satisfy that dep | Wrong ownership; Domain should ship assets |
| Copy Kafka JSON only to `build/schemas` while loader only checks `moduleDir/kafka` | Runtime missing-file errors after publish |
| `bundle:packages` without copy | Local postbuild looks fine; released Domain lacks JSON |
| Re-export-only `schemas/load-schema` with zero callers | Noise; delete or migrate callers |

## Scope boundary

- This reference is for **runtime JSON loading** used by Kafka (and any Domain-owned schema load).
- Do **not** replace existing hand-written Couchbase/AJV `JSONSchemaType` objects with `loadSchemaJson` unless the user asked for that migration.
- HTTP request schemas belong to `request-schema-contract`; Common/Data generation belongs to `static-schema-builder`.
