---
name: feishu-im-send
description: 使用飞书开放平台内部应用发送 text 消息到指定 open_id（ou_xxx），支持缺失环境变量时交互式配置
---

# Feishu IM Send

本 skill 用于在本仓库中维护 `feishu-im-send` 这套“脚本 + 入口 + 文档”的完整闭环，并指导如何正确使用它。

## 入口与位置（约定）

- 发送入口（使用当前文件平级的 `scripts/` 下脚本）：`node scripts/feishu-im-send.js`
- 工具实现（主脚本）：`scripts/feishu-im-send.js`

说明：本仓库的 skill 调用与维护以 `scripts/` 下脚本为准；请勿在文档中引用不存在的 `agents/tools/...` 路径。

## 使用说明

请默认用户已经配置好了对应的环境变量，该命令始终可用，如果执行时遇到报错，再提醒用户补充。

### 输入

- 参数：
  - `node scripts/feishu-im-send.js "消息内容"`
- 环境变量：
  - `FEISHU_APP_ID` / `FEISHU_APP_SECRET` / `FEISHU_RECEIVE_ID`
- env 文件：
  - 默认：`~/.config/feishu-im-send/env`
  - 覆盖：`--env-file <path>` 或 `FEISHU_IM_SEND_ENV_FILE=<path>`
  - 优先级：进程环境变量 > env 文件

当未配置 `FEISHU_APP_ID` / `FEISHU_APP_SECRET` 时：

- 交互式终端（TTY）下会提示你输入必要信息，并由脚本写入 env 文件完成配置（等价于执行一次 `--configure`）。
- 非交互环境（CI/管道）下不会进入交互，直接报错退出；请提前通过环境变量或 `--configure --app-id/--app-secret` 完成配置。

### 输出

- stdout：请求返回的 JSON（便于调试/管道处理）
- stderr：错误信息
- exit code：0 成功；非 0 失败

### 依赖与缓存

- Node.js（建议 `>= 18`，脚本使用内置 `fetch` 与 `crypto.randomUUID()`）
  - 若 Node 为 16/17：请使用 `node --experimental-fetch scripts/feishu-im-send.js ...`
- 需要可访问 `https://fsopen.bytedance.net/`
- Token 缓存：`~/.cache/feishu-im-send/tenant_access_token.json`（401/403 会自动清缓存并重试一次）

## Examples

- 发送一条消息：
  - `node scripts/feishu-im-send.js --text "hello"`
- 初始化/维护凭证（写入 env 文件，权限为 600）：
  - `node scripts/feishu-im-send.js --configure`
- 无交互写入（适合脚本/CI；`--force` 允许覆盖并备份）：
  - `node scripts/feishu-im-send.js --configure --app-id "xxx" --app-secret "yyy" --receive-id "ou_xxx" --force`
- 查看当前解析到的配置（secret 会脱敏）：
  - `node scripts/feishu-im-send.js --show-config`
- 查看命令行用法（用于自检文档/实现一致性）：
  - `node scripts/feishu-im-send.js --help`

## Guidelines

- 三件套同步：调整行为/参数时，同时检查 `scripts/feishu-im-send.js`、CLI 入口（如有）、本文件是否需要同步更新。
- `receive_id` 必须是 `open_id`：文档示例统一使用 `ou_xxx`，避免误传 `union_id`/`email`。
- 凭证不要进仓库：密钥只放环境变量或 `~/.config/feishu-im-send/env`。
- 不要发送敏感信息：token、cookie、密钥、用户数据等禁止发送到 IM。
- 排障优先自检：优先跑 `node scripts/feishu-im-send.js --show-config` 确认到底读了哪份配置；必要时删除缓存 `rm -f ~/.cache/feishu-im-send/tenant_access_token.json`。
