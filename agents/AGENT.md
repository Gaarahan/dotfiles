# ~/.agents 全局规范（VibeCoding）

本目录用于管理你本机的 Agent 行为规范与可复用技能（skills），目标是：

- 可移植：跟随 dotfiles，一次配置，多机复用
- 可组合：把能力拆成小技能，每个技能都有清晰的输入/输出与边界
- 可审计：技能尽量复用本仓库的脚本（例如 `bin/tools/*`），避免“黑盒”行为

## 目录约定

- `~/.agents/AGENT.md`
  - 你个人的“全局协作约定”（提问/改码、输出风格、默认偏好、允许的副作用等）
  - 作用范围：对所有项目生效

- `~/.agents/skills/<skill-name>/SKILL.md`
  - 某个技能的规格说明（Skill Spec）
  - 文件名固定：`SKILL.md`

- `~/.agents/tools/<tool-name>/...`
  - skill 会复用的“工具实现”（脚本/小程序），尽量做到可审计、可复用
  - 对外提供稳定入口时，建议配套一个 `dotfiles/bin/tools/<cmd>` 作为 shim

## SKILL.md 模板（建议结构）

1. **技能简介**：一句话描述 + 典型使用场景
2. **入口/命令**：CLI 命令、脚本路径、或 API
3. **输入**：参数、stdin、环境变量、配置文件
4. **输出**：stdout/stderr、退出码、产物文件
5. **依赖**：运行时（Node/Python/Go）、网络、权限
6. **示例**：3-5 个常用用例（含失败示例）
7. **安全与边界**：隐私、默认行为、避免误触发的约束
8. **排障**：常见报错、如何验证、如何清理缓存

## 与 dotfiles 的集成方式

本仓库推荐把 skills 放到 `dotfiles/agents/` 下，并通过安装脚本把它软链到 `~/.agents`，与 `~/.zshrc` / `~/.tmux.conf` 的管理方式一致。

## 完备性约束（重要）

当修改任意 skill 相关内容时，必须保证“脚本、入口、文档”同步更新，避免出现：文档说 A、实际跑出来是 B 的情况。

- **技能规格**：`agents/skills/<skill-name>/SKILL.md`
- **工具实现**：`agents/tools/<tool-name>/...`
- **稳定入口（如有）**：`bin/tools/<cmd>`（通常只做转发/shim）
- **校验方式**：至少运行一次 `--help` / `--show-config`（或该工具的等价自检命令），确保文档与输出一致
