#!/usr/bin/env python3
"""Validate the minimal structure and internal references of a Change Manifest."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError as exc:
    raise SystemExit("PyYAML is required: pip install pyyaml") from exc

ALLOWED_STATUS = {"confirmed", "likely", "possible", "unknown"}
ALLOWED_SEVERITY = {"critical", "high", "medium", "low", "informational", "unknown"}


def require(condition: bool, message: str, errors: list[str]) -> None:
    if not condition:
        errors.append(message)


def validate(data: Any) -> list[str]:
    errors: list[str] = []
    require(isinstance(data, dict), "Manifest root must be a mapping", errors)
    if not isinstance(data, dict):
        return errors

    require(data.get("schema_version") == "1.0", "schema_version must be '1.0'", errors)
    dependency = data.get("dependency")
    require(isinstance(dependency, dict), "dependency must be a mapping", errors)
    if isinstance(dependency, dict):
        for key in ("ecosystem", "name", "from_version", "to_version"):
            require(bool(dependency.get(key)), f"dependency.{key} is required", errors)

    evidence = data.get("evidence", [])
    require(isinstance(evidence, list), "evidence must be a list", errors)
    evidence_ids = set()
    if isinstance(evidence, list):
        for idx, item in enumerate(evidence):
            require(isinstance(item, dict), f"evidence[{idx}] must be a mapping", errors)
            if isinstance(item, dict):
                eid = item.get("id")
                require(bool(eid), f"evidence[{idx}].id is required", errors)
                if eid:
                    require(eid not in evidence_ids, f"Duplicate evidence id: {eid}", errors)
                    evidence_ids.add(eid)

    changes = data.get("changes", [])
    require(isinstance(changes, list), "changes must be a list", errors)
    change_ids = set()
    if isinstance(changes, list):
        for idx, change in enumerate(changes):
            require(isinstance(change, dict), f"changes[{idx}] must be a mapping", errors)
            if not isinstance(change, dict):
                continue
            cid = change.get("id")
            require(bool(cid), f"changes[{idx}].id is required", errors)
            if cid:
                require(cid not in change_ids, f"Duplicate change id: {cid}", errors)
                change_ids.add(cid)
            for key in ("title", "category", "component"):
                require(bool(change.get(key)), f"{cid or f'changes[{idx}]'}.{key} is required", errors)
            status = change.get("evidence_status")
            require(status in ALLOWED_STATUS, f"{cid}.evidence_status is invalid: {status}", errors)
            severity = change.get("severity_hint")
            require(severity in ALLOWED_SEVERITY, f"{cid}.severity_hint is invalid: {severity}", errors)
            refs = change.get("evidence_refs", [])
            require(isinstance(refs, list), f"{cid}.evidence_refs must be a list", errors)
            if status in {"confirmed", "likely", "possible"}:
                require(bool(refs), f"{cid} requires at least one evidence reference", errors)
            if isinstance(refs, list):
                for ref in refs:
                    require(ref in evidence_ids, f"{cid} references unknown evidence id: {ref}", errors)

    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    args = parser.parse_args()
    try:
        data = yaml.safe_load(args.manifest.read_text(encoding="utf-8"))
    except Exception as exc:
        print(f"Failed to read manifest: {exc}", file=sys.stderr)
        return 2
    errors = validate(data)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("Manifest validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())