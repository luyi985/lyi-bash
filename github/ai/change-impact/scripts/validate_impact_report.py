#!/usr/bin/env python3
"""Validate the minimal structure and cross-references of an impact report."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError as exc:
    raise SystemExit("PyYAML is required: pip install pyyaml") from exc

APPLICABILITY = {"applicable", "not-applicable", "conditionally-applicable", "unknown", "context-conflict"}
FINDING = {"confirmed", "likely", "possible", "unknown", "not-impacted"}
RATINGS = {"critical", "high", "medium", "low", "informational", "unknown"}
DECISIONS = {"safe-to-merge", "merge-with-required-tests", "deploy-behind-feature-flag", "canary-required", "manual-migration-required", "do-not-deploy", "insufficient-evidence"}


def add(condition: bool, message: str, errors: list[str]) -> None:
    if not condition:
        errors.append(message)


def validate(data: Any) -> list[str]:
    errors: list[str] = []
    add(isinstance(data, dict), "Report root must be a mapping", errors)
    if not isinstance(data, dict):
        return errors
    add(data.get("schema_version") == "1.0", "schema_version must be '1.0'", errors)
    add(isinstance(data.get("project"), dict), "project must be a mapping", errors)

    applicability = data.get("applicability", [])
    add(isinstance(applicability, list), "applicability must be a list", errors)
    change_ids = set()
    if isinstance(applicability, list):
        for idx, item in enumerate(applicability):
            add(isinstance(item, dict), f"applicability[{idx}] must be a mapping", errors)
            if not isinstance(item, dict):
                continue
            cid = item.get("change_id")
            add(bool(cid), f"applicability[{idx}].change_id is required", errors)
            if cid:
                add(cid not in change_ids, f"Duplicate change_id: {cid}", errors)
                change_ids.add(cid)
            add(item.get("status") in APPLICABILITY, f"{cid}.status is invalid", errors)

    impacts = data.get("impact_paths", [])
    add(isinstance(impacts, list), "impact_paths must be a list", errors)
    impact_ids = set()
    if isinstance(impacts, list):
        for idx, item in enumerate(impacts):
            add(isinstance(item, dict), f"impact_paths[{idx}] must be a mapping", errors)
            if not isinstance(item, dict):
                continue
            iid = item.get("id")
            cid = item.get("change_id")
            add(bool(iid), f"impact_paths[{idx}].id is required", errors)
            if iid:
                add(iid not in impact_ids, f"Duplicate impact id: {iid}", errors)
                impact_ids.add(iid)
            add(cid in change_ids, f"{iid} references unknown change_id: {cid}", errors)
            add(item.get("finding_status") in FINDING, f"{iid}.finding_status is invalid", errors)

    risks = data.get("risks", [])
    add(isinstance(risks, list), "risks must be a list", errors)
    risk_ids = set()
    if isinstance(risks, list):
        for idx, item in enumerate(risks):
            add(isinstance(item, dict), f"risks[{idx}] must be a mapping", errors)
            if not isinstance(item, dict):
                continue
            rid = item.get("id")
            iid = item.get("impact_id")
            add(bool(rid), f"risks[{idx}].id is required", errors)
            if rid:
                add(rid not in risk_ids, f"Duplicate risk id: {rid}", errors)
                risk_ids.add(rid)
            add(iid in impact_ids, f"{rid} references unknown impact_id: {iid}", errors)
            add(item.get("rating") in RATINGS, f"{rid}.rating is invalid", errors)
            for field in ("likelihood", "blast_radius", "severity", "detectability", "reversibility"):
                value = item.get(field)
                add(isinstance(value, int) and 1 <= value <= 5, f"{rid}.{field} must be an integer from 1 to 5", errors)

    recommendation = data.get("recommendation")
    add(isinstance(recommendation, dict), "recommendation must be a mapping", errors)
    if isinstance(recommendation, dict):
        add(recommendation.get("decision") in DECISIONS, "recommendation.decision is invalid", errors)

    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("report", type=Path)
    args = parser.parse_args()
    try:
        data = yaml.safe_load(args.report.read_text(encoding="utf-8"))
    except Exception as exc:
        print(f"Failed to read report: {exc}", file=sys.stderr)
        return 2
    errors = validate(data)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("Impact report validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())