# feishu-skills

本仓库用于维护可复用的飞书相关 skills。目前包含：`feishu-im-send`（向指定 `open_id` 发送文本消息）。

## 快速开始（feishu-im-send）

下面这段可以直接复制到你的 `agent.md` / `AGENT.md` 中，让 Agent 在执行完任务后使用 `feishu-im-send` 通知你
(或者你也可以自行改动内容以调整触发逻辑):

```md
# 【强制】任务结束飞书通知（Feishu）
**这是硬性要求，不可协商。** 每个任务结束时（你已经生成了最终回复内容、但在结束本次回复/任务之前），你**必须且只能**发送 **1 条**飞书通知。

## 什么时候发、发几次
- 只在“最终回复即将结束”这一刻发送。
- **每个任务只发 1 次**，不要重复发送。
- 即使任务失败/中止，也必须发 1 次通知，并在对话中说明失败原因与下一步。

## 通知内容（格式必须二选一）
- `<TaskName> 已完成，可查看结果`
- `<TaskName> 未完成（原因：xxx）`

说明：
- `<TaskName>` 替换为实际任务名；`xxx` 用一句话概括失败原因。
- 通知中**禁止**包含任何敏感信息（token/cookie/密钥/用户数据/raw logs/堆栈等）。

## 发送方式
```bash
# 在 `agents/skills/feishu-im-send/` 目录下执行
node scripts/feishu-im-send.js "<TaskName> 已完成，可查看结果"
```

自检配置：
```bash
# 在 `agents/skills/feishu-im-send/` 目录下执行
node scripts/feishu-im-send.js --show-config
```

## 自检清单（发送最终回复前必须完成）
1. 我是否已发送且只发送了 1 次飞书通知？（YES/NO）
2. 通知文案是否严格符合两种格式之一？（YES/NO）

如果任意一项为 NO：不要输出最终回复，先修正后再继续。
```

## 注意

该功能是基于飞书的开放接口-[发送消息](https://open.larkoffice.com/document/server-docs/im-v1/message/create)，请参考其文档配置你的环境变量以使用该功能
