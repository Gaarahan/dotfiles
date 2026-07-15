#!/usr/bin/env python3
"""Reject task-specific identifiers from the reusable Harness directory."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


TEXT_SUFFIXES = {".md", ".py", ".yaml", ".yml", ".json", ".xml", ".txt"}
BUILTIN_PATTERNS = {
    "live-lark-document-url": re.compile(
        r"https://[^\s<>'\"]+(?:larkoffice\.com|feishu\.cn)/(?:docx|wiki)/[A-Za-z0-9]+",
        re.IGNORECASE,
    ),
    "open-id": re.compile(r"\bou_[A-Za-z0-9]{12,}\b"),
    "message-id": re.compile(r"\bom_[A-Za-z0-9]{12,}\b"),
}


def load_forbidden(args: argparse.Namespace) -> list[str]:
    values = [value.strip() for value in args.forbid if value.strip()]
    if args.forbid_file:
        for line in args.forbid_file.read_text(encoding="utf-8").splitlines():
            value = line.strip()
            if value and not value.startswith("#"):
                values.append(value)
    return values


def scan(skill_dir: Path, forbidden: list[str]) -> list[dict[str, object]]:
    findings: list[dict[str, object]] = []
    custom = [(f"custom-term-{index}", value.casefold()) for index, value in enumerate(forbidden, start=1)]
    for path in sorted(skill_dir.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in TEXT_SUFFIXES or "__pycache__" in path.parts:
            continue
        text = path.read_text(encoding="utf-8")
        relative = str(path.relative_to(skill_dir))
        for line_number, line in enumerate(text.splitlines(), start=1):
            for category, pattern in BUILTIN_PATTERNS.items():
                if pattern.search(line):
                    findings.append({"file": relative, "line": line_number, "category": category})
            folded = line.casefold()
            for category, value in custom:
                if value in folded:
                    findings.append({"file": relative, "line": line_number, "category": category})
    return findings


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skill-dir", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--forbid", action="append", default=[], help="Task-specific term to reject; repeatable")
    parser.add_argument("--forbid-file", type=Path, help="Task-local file with one forbidden term per line")
    args = parser.parse_args()

    forbidden = load_forbidden(args)
    findings = scan(args.skill_dir.resolve(), forbidden)
    result = {
        "passed": not findings,
        "files_scanned": sum(
            1
            for path in args.skill_dir.resolve().rglob("*")
            if path.is_file() and path.suffix.lower() in TEXT_SUFFIXES and "__pycache__" not in path.parts
        ),
        "custom_terms_checked": len(forbidden),
        "findings": findings,
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))
    if findings:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
