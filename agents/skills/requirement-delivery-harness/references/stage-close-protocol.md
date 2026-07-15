# Stage close protocol

Close a stage only when delivery and process distillation are both complete.

## Required state

The stage must be `delivery_ready`. The task directory must contain:

- `stage-summary.md` with non-empty `Delivery`, `Open Questions`, and `Next Stage` sections.
- `harness-observations.md` with non-empty `Candidate`, `Promoted`, and `Deferred` sections. Use `None — <reason>` when a section has no entries.
- `harness-validation.json` recording whether the reusable harness changed, a concise summary, the validation command, and a passing result. When changed, it must also contain the dotfiles commit hash and `sanitized: true`.
- `handoffs.json` containing a Lark `stage_close` record for the current stage, including recipient, sending identity, message ID, summary, and artifact link when available.

## User intervention handoff

Before setting a stage to `waiting_for_user`:

1. Create or update the clarification artifact.
2. Send a Lark summary containing the stage status, artifact link, required user action, and resume condition.
3. Record the returned `message_id` with `flow.py record-handoff --purpose waiting_for_user`.
4. Set the stage to `waiting_for_user`.

## Promotion rule

Promote a rule when the user explicitly confirms it or the current run demonstrates it as a necessary reusable guardrail. Keep uncertain, product-specific, or one-off findings in the task-local observation file.

Before promotion, audit the Harness directory with `scripts/audit_reusability.py`, inspect the Harness-only diff, validate the Skill and changed commands, then commit the Harness in the dotfiles repository. Never place task names, source URLs or tokens, business-specific conclusions, repository-specific paths, or personal identifiers in the reusable Skill or its commit message.

## Closure receipt

Report:

1. Stage name and `closed` status.
2. Delivery artifact and location.
3. Rules, scripts, references, or assets promoted to the harness.
4. Deferred observations and why they remain local.
5. Validation commands, sanitization result, and Harness commit hash.
6. The next proposed stage.

The same closure summary must be sent through Lark CLI and recorded as `purpose=stage_close` before `close-stage` can pass.
