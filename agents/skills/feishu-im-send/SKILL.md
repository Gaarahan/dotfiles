# Skill: feishu-im-send

## 简介

通过飞书（Lark/Feishu）开放平台的“内部应用”获取 `tenant_access_token`，再发送一条 `text` 消息到指定用户（`open_id`）。

适用场景：

- 自动化脚本/CI 在关键节点通知自己（构建成功/失败、发布结果等）
- 本地脚本把信息快速推到 IM（临时提醒、待办等）

## 入口

- CLI：`feishu-im-send`
- 入口脚本（稳定）：`dotfiles/bin/tools/feishu-im-send`
- 工具实现（主脚本）：`dotfiles/agents/tools/feishu-im-send/feishu-im-send.js`

## 输入

### 参数

- `feishu-im-send "消息内容"`
- `feishu-im-send --text "消息内容" --receive-id "ou_xxx"`

### 环境变量

- `FEISHU_APP_ID` / `FEISHU_APP_SECRET`
- `FEISHU_RECEIVE_ID`（可选：作为默认收件人；更推荐显式传 `--receive-id`）

### env 文件（推荐）

为了避免每次手动 `export`，工具会自动加载 env 文件（但 **进程环境变量优先级更高**）：

- 默认：`~/.config/feishu-im-send/env`
- 指定：`--env-file <path>`
- 或：`FEISHU_IM_SEND_ENV_FILE=<path>`

## 输出

- stdout：请求返回的 JSON（便于调试/管道处理）
- stderr：错误信息
- exit code：0 成功；非 0 失败

## 依赖

- Node.js（建议 `>= 18`，脚本使用内置 `fetch` 与 `crypto.randomUUID()`）
- 可访问 `https://fsopen.bytedance.net/`

## 缓存

- Token 缓存：`~/.cache/feishu-im-send/tenant_access_token.json`
- 401/403 会自动清缓存并重试一次

## 示例

1) 发送一条消息（推荐显式指定接收人，避免误发）：

```sh
feishu-im-send --text "hello" --receive-id "ou_xxx"
```

2) 初始化/维护凭证（写入 env 文件，权限为 600）：

```sh
feishu-im-send --configure
```

3) 无交互写入（适合脚本/CI；`--force` 允许覆盖并备份）：

```sh
feishu-im-send --configure --app-id "xxx" --app-secret "yyy" --receive-id "ou_xxx" --force
```

4) 配合环境变量（env 文件依然可用，但 env 优先生效）：

```sh
export FEISHU_APP_ID="..."
export FEISHU_APP_SECRET="..."
export FEISHU_RECEIVE_ID="ou_xxx"

feishu-im-send "build done"
```

5) 查看当前解析到的配置（secret 会脱敏）：

```sh
feishu-im-send --show-config
```

## 安全与边界

- **务必显式配置接收人**：建议总是传 `--receive-id` 或设置 `FEISHU_RECEIVE_ID`。
- **凭证不要进仓库**：密钥只放在环境变量或 `~/.config/feishu-im-send/env`，不要提交到 Git。
- **不要把敏感信息发到 IM**：token、cookie、密钥、用户数据等禁止发送。

## 排障

- “缺少应用凭证”：检查 `FEISHU_APP_ID` / `FEISHU_APP_SECRET` 是否已设置。
- “不知道当前到底读了哪份配置”：运行 `feishu-im-send --show-config`。
- “想重建配置”：运行 `feishu-im-send --configure`。
- “发送消息失败 401/403”：删除缓存后重试：

```sh
rm -f ~/.cache/feishu-im-send/tenant_access_token.json
```
