---
name: requirement-delivery-harness
description: Drive a product requirement through explicit delivery stages while continuously distilling reusable collaboration rules, scripts, references, and templates. Use when starting or continuing a requirement whose workflow must be personalized, resumable, auditable, and unable to advance until each completed stage has updated and validated the harness.
---

# Requirement Delivery Harness

Run requirement delivery and harness evolution as two synchronized tracks.

## Start or resume

1. Run `python3 scripts/flow.py check` from the active repository.
2. If no task is active, initialize one with `python3 scripts/flow.py init --task-id <id> --title <title> --stage <stage>`.
3. Read the active stage state and its `stage-summary.md` and `harness-observations.md` files.
4. Do not start another stage while the current stage is not `closed`.

Store task-local evidence under `.workflow-memory/requirement-delivery/<task-id>/`. Keep product-specific facts out of this reusable skill.

## Maintain the harness safely

Every Harness change must remain reusable, pass a data-leak audit, and be committed to the dotfiles repository before it is recorded as promoted.

1. Keep requirement names, business decisions, document URLs or tokens, repository-specific paths, user or message identifiers, and other task evidence only in the active repository's `.workflow-memory` directory.
2. Write Harness rules as domain-neutral procedures, parameters, placeholders, checks, and templates. Never copy task-local examples or conclusions into `SKILL.md`, `references/`, `assets/`, `scripts/`, metadata, or commit messages.
3. Run `scripts/audit_reusability.py`. Pass a task-local forbidden-term file containing the current requirement name, source tokens, repository names, and other identifying terms.
4. Inspect the Harness-only diff, run `quick_validate.py`, and run the help or self-check command for every changed script.
5. Stage and commit only the intended Harness and required tracking configuration in the dotfiles repository. Do not include unrelated worktree changes, and do not use `--no-verify`.
6. Record the resulting commit hash and successful sanitization with `flow.py record-harness`. A changed Harness without both fields cannot pass the stage-close gate.

## Classify and verify inputs

Before deep investigation, classify every supplied source as one of: primary requirement, normative reference, historical solution, design artifact, or implementation repository.

1. Treat the user-designated primary requirement as the delivery target. Use similarly named references as constraints or implementation baselines, not as replacements for the target.
2. Record the role of each source in the task-local stage summary.
3. Verify that every external document and design artifact is accessible before relying on it.
4. If an inaccessible artifact affects interaction states, visual details, or acceptance criteria, record it as an explicit clarification item. Do not reconstruct missing details from nearby references.
5. When a user-provided webpage requires rendered UI, client-side state, screenshots, or interaction inspection, read `references/web-page-access.md` and use the official Playwright MCP in headless mode. Do not substitute the in-app browser or an ad hoc browser CLI.

## Work within a stage

1. State the stage goal, required inputs, expected artifact, and completion gate.
2. Read repository instructions and relevant knowledge bases before proposing a design or changing code.
3. Record missing semantic, state, scenario, or contract information as explicit questions. Do not invent fallback values.
4. Structure each blocking question as current information, impact, and requested confirmation.
5. When critical questions remain, create a clarification artifact and prepare a user-intervention handoff.
6. Send the handoff through Lark CLI before entering `waiting_for_user`, then record the returned `message_id` with `flow.py record-handoff --purpose waiting_for_user`.
7. Set the stage to `waiting_for_user` only after the handoff receipt exists.
8. Resume the same stage after answers arrive; do not restart completed investigation.

## Enter an implementation stage

1. Identify the repository's designated main development branch from repository instructions or its remote default branch. Before the first code change, create a dedicated semantic feature branch from that main-branch baseline, never from the current task branch. Default to `feat/<requirement-slug>` unless repository instructions require another pattern.
2. Record the main-branch baseline, its commit, and the feature branch in task-local evidence before implementation proceeds.
3. Classify backend dependencies by delivery phase. When the backend is still under development and integration has not started, record the contract dependency but do not block frontend implementation on live-interface verification.
4. Defer live backend verification to the integration stage, and do not claim end-to-end acceptance before that verification succeeds.

## Run requirement-to-frontend-solution

Treat clarification and technical-document writing as built-in parts of this stage. Do not require a separately installed collaboration or writing skill.

1. Investigate the primary requirement, normative references, design artifacts, relevant repository instructions, knowledge-base guidance, and the existing implementation.
2. If required information is missing, create or update the clarification document with `assets/clarification-document.xml`, then follow `references/comment-collaboration.md` for every inline-comment response cycle.
3. After each response cycle, separate confirmed conclusions, provisional assumptions, and unresolved questions. Keep the stage open until all blocking questions are resolved.
4. When information is sufficient, write the frontend technical solution with `assets/frontend-solution-document.xml` and follow `references/technical-document-writing.md` plus `references/readability-principles.md`.
5. Read the published document back and verify its structure, content, diagrams, and unresolved-item status before declaring it delivery-ready.

The clarification document and technical solution are stage artifacts. Record their URLs and latest revision evidence in `stage-summary.md` so the stage can resume without repeating completed work.

## Notify the user at handoff boundaries

Use `scripts/notify.py` whenever the stage pauses for user input or is ready to close. It resolves the authorized user's open_id, sends the standardized summary with Lark CLI as the configured bot, and records the returned `message_id`. The user has established bot-to-self as the persistent Harness notification identity and recipient.

Every handoff message must contain:

- Requirement and stage name.
- Current status and concise conclusion.
- Delivery or clarification artifact link.
- The exact user action required; write `No action required` for a closure notice.
- Resume condition or proposed next stage.

Send and record the handoff atomically:

```bash
python3 scripts/notify.py \
  --purpose waiting_for_user \
  --conclusion "Clarification document is ready" \
  --action "Answer the blocking questions in the document" \
  --resume "Resume solution writing after all blocking questions are answered" \
  --artifact-url "https://..."
```

Use `--dry-run` to inspect the rendered message without sending. Use `flow.py record-handoff` only to repair or import an externally sent receipt. For a completed stage, use `--purpose stage_close` before `close-stage`. Do not treat the in-app final response as a replacement for the Lark handoff.

## Close a stage

Follow `references/stage-close-protocol.md`. A stage may be declared complete only after `python3 scripts/flow.py close-stage` exits successfully.

Classify observations as follows:

- Stable collaboration or sequencing rule: update `SKILL.md`.
- Deterministic repeated action: add or update `scripts/` and run its help or equivalent self-check.
- Detailed domain guidance: add or update `references/`.
- Reusable output shape: add or update `assets/`.
- One-off or unvalidated observation: retain only in the task-local observation file.

Always give the user a closure receipt containing the delivery artifact, promoted harness changes, deferred observations, validation result, and next stage.

## Commands

```bash
python3 scripts/flow.py --help
python3 scripts/flow.py init --task-id TASK-ID --title "Title" --stage solution-design
python3 scripts/flow.py check
python3 scripts/flow.py set-title --title "Correct requirement title"
python3 scripts/flow.py set-status --status waiting_for_user
python3 scripts/flow.py set-status --status delivery_ready
python3 scripts/audit_reusability.py --forbid-file .workflow-memory/requirement-delivery/TASK-ID/harness-forbidden-terms.txt
python3 scripts/flow.py record-harness --changed yes --summary "Updated stage gate" --validation "audit_reusability.py; quick_validate.py" --commit-hash COMMIT --sanitized --passed
python3 scripts/notify.py --purpose waiting_for_user --conclusion "Needs answers" --action "Answer the clarification document" --resume "Resume after answers arrive"
python3 scripts/flow.py close-stage
```

Use `--root <repository>` before the subcommand only when the command is not executed from the target repository.
