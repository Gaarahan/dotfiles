---
name: feishu-im-send
description: 使用飞书开放平台内部应用发送 text 消息到指定 open_id（ou_xxx），适合脚本/CI 通知与任务完成提醒
---

# Feishu IM Send

本 skill 用于在本仓库中维护 `feishu-im-send` 这套“脚本 + 入口 + 文档”的完整闭环，并指导如何正确使用它。

## 入口与位置（约定）

- CLI：`feishu-im-send`
- 入口脚本（稳定）：`bin/tools/feishu-im-send`
- 工具实现（主脚本）：`agents/tools/feishu-im-send/feishu-im-send.js`

说明：该工具固定使用 `receive_id_type=open_id`，因此 `--receive-id` / `FEISHU_RECEIVE_ID` 应传 `open_id`（通常形如 `ou_xxx`）。

## 使用说明

### 输入

- 参数：
  - `feishu-im-send "消息内容"`
  - `feishu-im-send --text "消息内容" --receive-id "ou_xxx"`
- 环境变量：
  - `FEISHU_APP_ID` / `FEISHU_APP_SECRET`
  - `FEISHU_RECEIVE_ID`（可选：发送消息时作为默认收件人；更推荐显式传 `--receive-id`）
- env 文件（推荐）：
  - 默认：`~/.config/feishu-im-send/env`
  - 覆盖：`--env-file <path>` 或 `FEISHU_IM_SEND_ENV_FILE=<path>`
  - 优先级：进程环境变量 > env 文件

### 输出

- stdout：请求返回的 JSON（便于调试/管道处理）
- stderr：错误信息
- exit code：0 成功；非 0 失败

### 依赖与缓存

- Node.js（建议 `>= 18`，脚本使用内置 `fetch` 与 `crypto.randomUUID()`）
- 需要可访问 `https://fsopen.bytedance.net/`
- Token 缓存：`~/.cache/feishu-im-send/tenant_access_token.json`（401/403 会自动清缓存并重试一次）

## Examples

- 发送一条消息（推荐显式指定接收人，避免误发）：
  - `feishu-im-send --text "hello" --receive-id "ou_xxx"`
- 初始化/维护凭证（写入 env 文件，权限为 600）：
  - `feishu-im-send --configure`
- 无交互写入（适合脚本/CI；`--force` 允许覆盖并备份）：
  - `feishu-im-send --configure --app-id "xxx" --app-secret "yyy" --receive-id "ou_xxx" --force`
- 查看当前解析到的配置（secret 会脱敏）：
  - `feishu-im-send --show-config`
- 查看命令行用法（用于自检文档/实现一致性）：
  - `feishu-im-send --help`

## Guidelines

- 三件套同步：调整行为/参数时，同时检查 `agents/tools/feishu-im-send/feishu-im-send.js`、`bin/tools/feishu-im-send`、本文件是否需要同步更新。
- `receive_id` 必须是 `open_id`：文档示例统一使用 `ou_xxx`，避免误传 `union_id`/`email`。
- 凭证不要进仓库：密钥只放环境变量或 `~/.config/feishu-im-send/env`。
- 不要发送敏感信息：token、cookie、密钥、用户数据等禁止发送到 IM。
- 排障优先自检：优先跑 `feishu-im-send --show-config` 确认到底读了哪份配置；必要时删除缓存 `rm -f ~/.cache/feishu-im-send/tenant_access_token.json`。
