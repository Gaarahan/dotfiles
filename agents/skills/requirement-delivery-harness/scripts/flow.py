#!/usr/bin/env python3
"""Persist and enforce requirement-delivery stage gates."""

from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


STATUSES = {"in_progress", "waiting_for_user", "delivery_ready", "closed"}
STATE_DIR = Path(".workflow-memory/requirement-delivery")
ACTIVE_FILE = Path(".workflow-memory/active-harness.json")


def now() -> str:
    return datetime.now(timezone.utc).isoformat()


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def paths(root: Path) -> tuple[Path, Path]:
    return root / ACTIVE_FILE, root / STATE_DIR


def load_active(root: Path) -> tuple[dict[str, Any], Path]:
    active_path, state_root = paths(root)
    if not active_path.exists():
        raise SystemExit("No active harness task. Run flow.py init first.")
    active = read_json(active_path)
    state_path = state_root / active["task_id"] / "state.json"
    if not state_path.exists():
        raise SystemExit(f"Active task state is missing: {state_path}")
    return read_json(state_path), state_path


def task_dir(state_path: Path) -> Path:
    return state_path.parent


def nonempty_sections(path: Path, headings: list[str]) -> list[str]:
    if not path.exists():
        return headings
    text = path.read_text(encoding="utf-8")
    missing: list[str] = []
    for index, heading in enumerate(headings):
        marker = f"## {heading}"
        start = text.find(marker)
        if start < 0:
            missing.append(heading)
            continue
        content_start = start + len(marker)
        next_heading = text.find("\n## ", content_start)
        content = text[content_start : next_heading if next_heading >= 0 else len(text)].strip()
        if not content:
            missing.append(heading)
    return missing


def command_init(args: argparse.Namespace) -> None:
    root = args.root.resolve()
    active_path, state_root = paths(root)
    if active_path.exists():
        existing = read_json(active_path)
        raise SystemExit(f"Active task already exists: {existing['task_id']}")
    directory = state_root / args.task_id
    directory.mkdir(parents=True, exist_ok=False)
    state = {
        "schema_version": 1,
        "task_id": args.task_id,
        "title": args.title,
        "current_stage": args.stage,
        "status": "in_progress",
        "created_at": now(),
        "updated_at": now(),
        "stages": [{"name": args.stage, "status": "in_progress", "started_at": now()}],
    }
    write_json(directory / "state.json", state)
    write_json(active_path, {"skill": "requirement-delivery-harness", "task_id": args.task_id})
    (directory / "stage-summary.md").write_text(
        f"# {args.stage}\n\n## Delivery\n\n## Open Questions\n\n## Next Stage\n",
        encoding="utf-8",
    )
    (directory / "harness-observations.md").write_text(
        f"# {args.stage}\n\n## Candidate\n\n## Promoted\n\n## Deferred\n",
        encoding="utf-8",
    )
    print(json.dumps(state, ensure_ascii=False, indent=2))


def command_check(args: argparse.Namespace) -> None:
    state, state_path = load_active(args.root.resolve())
    result = dict(state)
    result["task_dir"] = str(task_dir(state_path))
    print(json.dumps(result, ensure_ascii=False, indent=2))


def command_set_status(args: argparse.Namespace) -> None:
    if args.status not in STATUSES - {"closed"}:
        raise SystemExit(f"Unsupported status: {args.status}")
    state, state_path = load_active(args.root.resolve())
    if state["status"] == "closed":
        raise SystemExit("The current stage is already closed.")
    if args.status == "waiting_for_user" and not find_handoff(state, state_path, "waiting_for_user"):
        raise SystemExit(
            "Cannot wait for user before recording the Lark intervention message. "
            "Send the summary, then run flow.py record-handoff --purpose waiting_for_user."
        )
    state["status"] = args.status
    state["updated_at"] = now()
    state["stages"][-1]["status"] = args.status
    write_json(state_path, state)
    print(json.dumps(state, ensure_ascii=False, indent=2))


def command_set_title(args: argparse.Namespace) -> None:
    state, state_path = load_active(args.root.resolve())
    title = args.title.strip()
    if not title:
        raise SystemExit("Title must not be empty.")
    state["title"] = title
    state["updated_at"] = now()
    write_json(state_path, state)
    print(json.dumps(state, ensure_ascii=False, indent=2))


def command_record_harness(args: argparse.Namespace) -> None:
    state, state_path = load_active(args.root.resolve())
    record = {
        "changed": args.changed == "yes",
        "summary": args.summary,
        "validation_command": args.validation,
        "passed": args.passed,
        "commit_hash": args.commit_hash,
        "sanitized": args.sanitized,
        "recorded_at": now(),
    }
    if not record["summary"].strip() or not record["validation_command"].strip():
        raise SystemExit("Harness summary and validation command are required.")
    if record["changed"] and not record["commit_hash"].strip():
        raise SystemExit("A changed Harness requires the dotfiles commit hash.")
    if record["changed"] and record["sanitized"] is not True:
        raise SystemExit("A changed Harness requires a passing task-data sanitization audit.")
    write_json(task_dir(state_path) / "harness-validation.json", record)
    print(json.dumps(record, ensure_ascii=False, indent=2))


def handoff_path(state_path: Path) -> Path:
    return task_dir(state_path) / "handoffs.json"


def read_handoffs(state_path: Path) -> list[dict[str, Any]]:
    path = handoff_path(state_path)
    return read_json(path) if path.exists() else []


def find_handoff(state: dict[str, Any], state_path: Path, purpose: str) -> dict[str, Any] | None:
    stage_started_at = state["stages"][-1]["started_at"]
    for record in reversed(read_handoffs(state_path)):
        if (
            record.get("stage") == state["current_stage"]
            and record.get("purpose") == purpose
            and record.get("channel") == "lark"
            and record.get("message_id")
            and record.get("sent_at", "") >= stage_started_at
        ):
            return record
    return None


def command_record_handoff(args: argparse.Namespace) -> None:
    state, state_path = load_active(args.root.resolve())
    record = {
        "stage": state["current_stage"],
        "purpose": args.purpose,
        "channel": "lark",
        "recipient": args.recipient,
        "identity": args.identity,
        "message_id": args.message_id,
        "summary": args.summary,
        "artifact_url": args.artifact_url,
        "sent_at": now(),
    }
    required = ["recipient", "message_id", "summary"]
    missing = [key for key in required if not str(record[key]).strip()]
    if missing:
        raise SystemExit("Missing handoff fields: " + ", ".join(missing))
    records = read_handoffs(state_path)
    records.append(record)
    write_json(handoff_path(state_path), records)
    print(json.dumps(record, ensure_ascii=False, indent=2))


def command_close_stage(args: argparse.Namespace) -> None:
    root = args.root.resolve()
    state, state_path = load_active(root)
    directory = task_dir(state_path)
    errors: list[str] = []
    if state["status"] != "delivery_ready":
        errors.append(f"stage status must be delivery_ready, got {state['status']}")
    summary_missing = nonempty_sections(directory / "stage-summary.md", ["Delivery", "Open Questions", "Next Stage"])
    observation_missing = nonempty_sections(directory / "harness-observations.md", ["Candidate", "Promoted", "Deferred"])
    if summary_missing:
        errors.append("empty stage-summary sections: " + ", ".join(summary_missing))
    if observation_missing:
        errors.append("empty harness-observations sections: " + ", ".join(observation_missing))
    validation_path = directory / "harness-validation.json"
    if not validation_path.exists():
        errors.append("harness-validation.json is missing")
    else:
        validation = read_json(validation_path)
        if validation.get("passed") is not True:
            errors.append("harness validation has not passed")
        if validation.get("changed") is True and not validation.get("commit_hash"):
            errors.append("changed harness has no dotfiles commit hash")
        if validation.get("changed") is True and validation.get("sanitized") is not True:
            errors.append("changed harness has no passing sanitization audit")
    if not find_handoff(state, state_path, "stage_close"):
        errors.append("Lark stage-close handoff is missing; send the closure summary and record its message_id")
    if errors:
        raise SystemExit("Cannot close stage:\n- " + "\n- ".join(errors))
    state["status"] = "closed"
    state["updated_at"] = now()
    state["stages"][-1]["status"] = "closed"
    state["stages"][-1]["closed_at"] = now()
    write_json(state_path, state)
    print(json.dumps(state, ensure_ascii=False, indent=2))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd(), help="Target repository root")
    subparsers = parser.add_subparsers(dest="command", required=True)

    init = subparsers.add_parser("init", help="Initialize an active task and first stage")
    init.add_argument("--task-id", required=True)
    init.add_argument("--title", required=True)
    init.add_argument("--stage", required=True)
    init.set_defaults(func=command_init)

    check = subparsers.add_parser("check", help="Show the active task and stage")
    check.set_defaults(func=command_check)

    status = subparsers.add_parser("set-status", help="Set current stage status")
    status.add_argument("--status", required=True, choices=sorted(STATUSES - {"closed"}))
    status.set_defaults(func=command_set_status)

    title = subparsers.add_parser("set-title", help="Correct the active task title without changing its identity")
    title.add_argument("--title", required=True)
    title.set_defaults(func=command_set_title)

    record = subparsers.add_parser("record-harness", help="Record harness update and validation")
    record.add_argument("--changed", required=True, choices=["yes", "no"])
    record.add_argument("--summary", required=True)
    record.add_argument("--validation", required=True)
    record.add_argument("--commit-hash", default="")
    record.add_argument("--sanitized", action="store_true")
    record.add_argument("--passed", action="store_true", required=True)
    record.set_defaults(func=command_record_harness)

    handoff = subparsers.add_parser("record-handoff", help="Record a sent Lark stage handoff message")
    handoff.add_argument("--purpose", required=True, choices=["waiting_for_user", "stage_close"])
    handoff.add_argument("--recipient", required=True)
    handoff.add_argument("--identity", required=True, choices=["user", "bot"])
    handoff.add_argument("--message-id", required=True)
    handoff.add_argument("--summary", required=True)
    handoff.add_argument("--artifact-url", default="")
    handoff.set_defaults(func=command_record_handoff)

    close = subparsers.add_parser("close-stage", help="Close the stage after all gates pass")
    close.set_defaults(func=command_close_stage)
    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
