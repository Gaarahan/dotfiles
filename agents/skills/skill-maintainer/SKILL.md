---
name: skill-maintainer
description: 维护与创建本仓库 agents/skills 下其他 skill 的规范与操作流程（目录位置、三件套同步、shim 入口、校验方式）
---

# Skill Maintainer

当我需要在本仓库维护/新增/调整任何 skill（位于 `agents/skills/`）时，必须遵循本规范，以保证：结构统一、可审计、可复用、且不会出现“文档说 A、实际跑出来是 B”。

## 约定（位置与结构）

- Skill 规格文件固定放在：`agents/skills/<skill-name>/SKILL.md`
- 工具实现固定放在：`agents/tools/<tool-name>/...`
- 若要对外提供稳定入口（推荐）：添加 shim 到 `bin/tools/<cmd>`，只做转发，不写业务逻辑

说明：安装脚本会把仓库 `./agents` 软链到 `~/.agents`，因此仓库内结构就是线上实际生效结构。

## 创建/调整流程（必须执行）

1) 选择名称
   - `<skill-name>` 使用 `kebab-case`（例如 `feishu-im-send`）
   - 若命令行入口存在，建议 `<cmd>` 与 `<tool-name>` 一致（减少记忆负担）

2) 创建/更新三件套（缺一不可）
   - **技能规格**：`agents/skills/<skill-name>/SKILL.md`（必须使用标准模板）
   - **工具实现**：`agents/tools/<tool-name>/...`（脚本/小程序，尽量可审计、无黑盒）
   - **稳定入口（如有）**：`bin/tools/<cmd>`（shim/转发）

3) 校验（至少一种）
   - 对 CLI 工具：至少运行一次 `--help` 与 `--show-config`（或等价自检命令）
   - 对脚本：至少跑一次最小可用示例（成功与失败各 1 个更佳）

4) Review 与 Git 行为
   - 默认不自动执行 `git add`/`git commit`/`git push`。
   - 我只提供 `git diff` 与改动文件清单，等待你 review 后手动暂存；除非你明确要求我暂存/提交。

## 标准模板（必须使用）

创建新的 `agents/skills/<skill-name>/SKILL.md` 时，必须从以下模板开始：

```md
---
name: my-skill-name
description: A clear description of what this skill does and when to use it
---

# My Skill Name

[Add your instructions here that Claude will follow when this skill is active]

## Examples
- Example usage 1
- Example usage 2

## Guidelines
- Guideline 1
- Guideline 2
```

## Examples

- 新增一个 skill：`agents/skills/new-skill/SKILL.md` + `agents/tools/new-skill/*` +（可选）`bin/tools/new-skill`
- 调整一个 skill：同时检查 `agents/skills/<skill>/SKILL.md`、`agents/tools/<tool>/...`、`bin/tools/<cmd>` 是否需要同步更新

## Guidelines

- 规范优先：不要只改实现不改 `SKILL.md`，也不要只改 `SKILL.md` 不改实现。
- 可移植优先：不要在仓库内写死本机绝对路径；优先用 `$HOME`/XDG 路径或相对仓库路径。
- 安全优先：任何 token/secret 不得进入仓库；在 `SKILL.md` 中明确凭证来源与脱敏/缓存策略。

