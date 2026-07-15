#!/usr/bin/env python3
"""Send a standardized Lark Harness handoff and record its receipt."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any


ACTIVE_FILE = Path(".workflow-memory/active-harness.json")
STATE_DIR = Path(".workflow-memory/requirement-delivery")


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def resolve_lark_cli() -> str:
    configured = os.environ.get("LARK_CLI_BIN")
    if configured and Path(configured).is_file():
        return configured
    discovered = shutil.which("lark-cli")
    if discovered:
        return discovered
    candidates = sorted(
        (
            candidate
            for candidate in Path.home().glob(".nvm/versions/node/*/bin/lark-cli")
            if (candidate.parent / "node").is_file()
        ),
        reverse=True,
    )
    if candidates:
        return str(candidates[0])
    raise SystemExit("lark-cli not found. Set LARK_CLI_BIN or add lark-cli to PATH.")


def run_json(argv: list[str]) -> dict[str, Any]:
    env = dict(os.environ)
    executable_dir = str(Path(argv[0]).parent)
    env["PATH"] = executable_dir + os.pathsep + env.get("PATH", "")
    env["LARKSUITE_CLI_NO_UPDATE_NOTIFIER"] = "1"
    env["LARKSUITE_CLI_NO_SKILLS_NOTIFIER"] = "1"
    completed = subprocess.run(argv, capture_output=True, text=True, env=env, check=False)
    raw = completed.stdout.strip() or completed.stderr.strip()
    try:
        payload = json.loads(raw)
    except json.JSONDecodeError as error:
        raise SystemExit(f"Command did not return JSON: {' '.join(argv[:3])}\n{raw}") from error
    if completed.returncode != 0 or payload.get("ok") is False:
        raise SystemExit(json.dumps(payload, ensure_ascii=False, indent=2))
    return payload


def load_state(root: Path) -> tuple[dict[str, Any], Path]:
    active_path = root / ACTIVE_FILE
    if not active_path.exists():
        raise SystemExit("No active Harness task. Run flow.py init first.")
    task_id = read_json(active_path)["task_id"]
    state_path = root / STATE_DIR / task_id / "state.json"
    return read_json(state_path), state_path


def resolve_self_open_id(lark_cli: str) -> str:
    status = run_json([lark_cli, "auth", "status", "--json", "--verify"])
    open_id = status.get("identities", {}).get("user", {}).get("openId")
    if not open_id:
        raise SystemExit("Authorized user open_id is unavailable. Run lark-cli auth login first.")
    return str(open_id)


def find_value(value: Any, key: str) -> Any:
    if isinstance(value, dict):
        if key in value:
            return value[key]
        for child in value.values():
            found = find_value(child, key)
            if found is not None:
                return found
    if isinstance(value, list):
        for child in value:
            found = find_value(child, key)
            if found is not None:
                return found
    return None


def build_markdown(state: dict[str, Any], args: argparse.Namespace) -> str:
    status = "等待你介入" if args.purpose == "waiting_for_user" else "阶段已完成"
    artifact = f"[打开阶段产物]({args.artifact_url})" if args.artifact_url else "暂无独立产物链接"
    return "\n".join(
        [
            "## Harness 阶段交接",
            "",
            f"- 需求：{state['title']}",
            f"- 阶段：{state['current_stage']}",
            f"- 状态：{status}",
            "",
            "### 当前结论",
            args.conclusion,
            "",
            "### 阶段产物",
            artifact,
            "",
            "### 需要你做",
            args.action,
            "",
            "### 恢复条件 / 下一步",
            args.resume,
        ]
    )


def command_notify(args: argparse.Namespace) -> None:
    root = args.root.resolve()
    state, _ = load_state(root)
    markdown = build_markdown(state, args)
    if args.dry_run:
        print(json.dumps({"identity": "bot", "recipient": args.recipient_open_id or "SELF", "markdown": markdown}, ensure_ascii=False, indent=2))
        return

    lark_cli = resolve_lark_cli()
    recipient = args.recipient_open_id or resolve_self_open_id(lark_cli)
    idempotency_source = ":".join(
        [
            state["task_id"],
            state["current_stage"],
            args.purpose,
            args.conclusion,
            args.action,
            args.resume,
            args.artifact_url,
        ]
    )
    idempotency_key = "harness-" + hashlib.sha256(idempotency_source.encode()).hexdigest()[:32]
    response = run_json(
        [
            lark_cli,
            "im",
            "+messages-send",
            "--user-id",
            recipient,
            "--markdown",
            markdown,
            "--as",
            "bot",
            "--idempotency-key",
            idempotency_key,
            "--format",
            "json",
        ]
    )
    message_id = find_value(response, "message_id")
    if not message_id:
        raise SystemExit("Lark send succeeded but no message_id was returned; receipt was not recorded.")

    flow_script = Path(__file__).with_name("flow.py")
    record = run_json(
        [
            sys.executable,
            str(flow_script),
            "--root",
            str(root),
            "record-handoff",
            "--purpose",
            args.purpose,
            "--recipient",
            recipient,
            "--identity",
            "bot",
            "--message-id",
            str(message_id),
            "--summary",
            args.conclusion,
            "--artifact-url",
            args.artifact_url,
        ]
    )
    print(json.dumps({"sent": True, "message_id": message_id, "handoff": record}, ensure_ascii=False, indent=2))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd(), help="Target repository root")
    parser.add_argument("--purpose", required=True, choices=["waiting_for_user", "stage_close"])
    parser.add_argument("--conclusion", required=True)
    parser.add_argument("--action", required=True)
    parser.add_argument("--resume", required=True)
    parser.add_argument("--artifact-url", default="")
    parser.add_argument("--recipient-open-id", help="Override the authorized user's open_id")
    parser.add_argument("--dry-run", action="store_true")
    parser.set_defaults(func=command_notify)
    return parser


def main() -> None:
    args = build_parser().parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
