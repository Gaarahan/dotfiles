---
name: gh-lark-comment-doc-editing
description: "飞书文档「划词协作」评论驱动的就地编辑工作流。当需要根据飞书文档里的划词评论（inline
  comment / 划词协作气泡）逐条修改正文，并且必须保住评论锚点（不让评论变孤儿）时使用。
  典型触发：「按文档里的评论逐条改」「处理划词协作意见」「回应评论但别把评论搞丢」「基于
  reviewer 批注修订飞书技术方案 / PRD」。本 skill 提供拉评论→拉正文→对齐分类→对齐拍板→
  就地批量改→验证锚点→在评论下回 `「ByAgent」` 回复的七步闭环，强约束是绝不重排章节编号、
  绝不整段删除重写、Agent 只回复不自行 resolve/delete 评论（删评论交给用户）。改动「怎么改」
  的判断走一套可读性原则（结论优先、拆密集长段、按角色拆条、新概念先解释来源、时序画流程图）。
  依赖 lark-doc skill 的 docs 子命令（+get-comments / +fetch / +update / +update-batch）与
  drive 的 file.comments / file.comment.replys 接口。若是从零写 / 整篇大改一篇技术飞书文档
  （文档还没有他人评论），那是另一个方向，改用姊妹 skill gh-lark-tech-doc-writing。"
---

# 飞书划词协作 · 评论驱动文档编辑

飞书文档的「划词协作」= 选中一段文字就地发起的评论。每条评论锚定在一段被引用的原文
（`quote`）上；**只要 quote 的关键子串还在正文里，评论就存活；子串一旦被删或改没，评论
立即变成孤儿（orphan）**。本 skill 的全部设计都围绕「改内容但保锚点」。

## 何时用这个 skill

命中任一即用：

- 用户给了一篇带划词评论的飞书文档，要求「按评论逐条改 / 处理这些意见 / 回应 reviewer」。
- 修订飞书技术方案、PRD、设计文档，且文档里有他人划词批注需要一条条落地。
- 用户强调「别把评论搞丢 / 保留评论 / 不要动章节编号」。

不适用：
- **从零写 / 整篇大改**一篇技术飞书文档（文档还没有他人评论）→ 用姊妹 skill
  **gh-lark-tech-doc-writing**（那边是自由落笔，没有保锚点约束）。
- 普通新建文档、非飞书文档 → 直接用 lark-doc。

## 硬约束（贯穿始终，违反即翻车）

1. **不重排章节编号**：不要因为插入/删除内容去改「一、二、三」「§3.1」等编号。
2. **不整段删除重写**：整段 delete-then-rewrite 会连带删掉 quote 子串 → 评论变孤儿。
   一律用**就地** `str_replace` / `block_insert` / `block_replace`，保留 quote 关键子串。
3. **`@file` / `--content` / `--output` 一律用绝对路径**：lark-cli 的 wrapper 会
   `cd` 到 SKILL_ROOT，相对路径会 FileNotFoundError。
4. **`+fetch` 带 `--api-version v2`**，且用 stdout 重定向到文件（`+fetch` 没有 `--output`）。
5. **改完必须验证锚点存活**：回 fetch，确认每条要保留的 quote 子串仍在正文中。
6. **改完必须在评论下回复 `「ByAgent」…`**：每条被处理的评论，都要用
   `drive file.comment.replys create` 在该评论线程下回一条以 `「ByAgent」` 开头的回复，
   描述本次改动 / 直接回答评论提问。**Agent 绝不自行「解决 / 删除」评论**——是否解决、
   是否删除由用户看过回复后自己决定（用户认可即会删掉对应评论）。
7. **“沉淀 / 强调”必须更新协作约束**：当用户说要“沉淀”某项经验，或再次“强调”某个问题时，
   其意图默认是修改可复用的协作约束以避免以后再犯，而不是只修当前文档或口头确认。本轮必须定位
   对应规则的唯一权威文件，写入可执行的触发条件与行为要求，并回读验证；仅完成当前内容修改不算
   完成。若规则同时适用于姊妹 skill，必须同步其共享引用或副本，避免规则漂移。

## 七步闭环

### 第 1 步 · 拉评论
```bash
bash <lark-doc>/scripts/lark-cli.sh docs +get-comments \
  --api-version v2 --doc '<DOC_URL>' > /abs/path/comments.txt
```
逐条记录：`quote`（锚点原文）、评论/回复意见、`is_solved`。给每条编个号（[0][1]…）。

> **注意：`+get-comments` 返回的是文档全部评论线程，不等于「还没处理的」。** 它会把
> 已被 resolve 的、锚点已被改写而成孤儿的、以及往轮已回过 `「ByAgent」` 的评论一并返回，
> 所以看到的总条数往往远大于真正待办数（且 `is_solved` 字段不一定如实反映 UI 里的解决态，
> 别拿它当唯一判据）。**统计「还剩几条要改」时，孤儿阶段的评论不计入**——判据见第 3 步：
> quote 子串已不在正文里（锚点被改写覆盖）即为孤儿，视为诉求已满足，直接跳过；线程里已有
> `「ByAgent」` 回复的也算已处理。真正待办 = 仍锚定活文本 且 线程内无 `「ByAgent」` 回复。

### 第 2 步 · 拉正文（带 block id）
```bash
bash <lark-doc>/scripts/lark-cli.sh docs +fetch \
  --api-version v2 --doc '<DOC_URL>' --doc-format xml --detail with-ids \
  > /abs/path/full.xml
```
拿到最新 revision 和每个 block 的 id。正文是 JSON 包裹的 XML，用 Python 取
`data.document.content` 落地成 `content.xml` 再定位。

### 第 3 步 · 逐条对齐 + 分类
把每条评论的 quote 与当前正文比对，分两类：
- **已被改写覆盖（孤儿，不计入待办）**：quote 所指原文早前已被重写替换 → 子串已不在正文里
  → 诉求视为已满足，评论自然成孤儿。**这类不计入「还剩几条要改」的统计，直接跳过**
  （这是预期结果，不是 bug）。同理，线程里已有 `「ByAgent」` 回复的也算已处理、不再计入。
- **仍锚定活文本**：quote 子串还在正文里、且线程内没有 `「ByAgent」` 回复 → 本轮需真正动手。

### 第 4 步 · 动手前对齐（仅结构性改动时）
涉及删段、补图、加伪代码等实质/有歧义的改动，先给用户一张表拍板，无歧义的直接做：

| # | 位置 | 评论意见 | 打算怎么改 | 需确认 |
|---|------|----------|-----------|--------|
| … | §X   | …        | 就地 str_replace… | ⚠️ 删除范围 / 影响面 |

### 第 5 步 · 批量就地改
用 `+update-batch` 组一个 edits 数组（JSON 文件，绝对路径 `@` 引用）：
```json
[
  {"command":"str_replace","pattern":"<含 quote 子串的原文>","content":"<保留 quote 子串 + 追加结论>"},
  {"command":"block_replace","block_id":"doxcnXXXX","content":"@/abs/path/newblock.xml","doc_format":"xml"}
]
```
- **pattern 要包含 quote 的关键子串**，content 里**也保留该子串**，只在其后追加/改写。
- 表格整行的**结构性删除**（删 `<tr>`）：`str_replace` 删不掉，改用 `block_replace`
  重建整张表 block。
- 改完检查返回：revision 是否推进、`updated_blocks_count` 是否 > 0（=0 说明 pattern 没匹配上）。
- **怎么改**——即「把哪里改成什么」的判断，全部走下面的
  「[可读性原则](#可读性原则改动怎么改的判据)」：评论说「太长」就拆密集长段、说「用流程图」
  就画图、说「细节没必要」就砍到只留结论。

### 第 6 步 · 验证锚点存活
回 fetch 最新正文，逐条确认要保留的 quote 子串仍在；清理残留交叉引用（如已删项的
`(Q6)` 引用）与遗留的问答形式。

### 第 7 步 · 在评论下回复 `「ByAgent」`（关键，别省）
每条本轮处理过的评论，都要在其线程下回一条以 `「ByAgent」` 开头的回复：**描述本次
怎么改的 / 直接回答该评论的提问**，让 reviewer 无需翻正文就知道诉求已落地。

**硬规矩：Agent 只回复，绝不 resolve / delete 评论。** 是否算解决、是否删除评论，
一律交给用户——用户看完回复觉得 OK，自己会把评论删掉 / 点解决。

先用 raw API 列评论拿真实 `comment_id`（`+get-comments` 返回的 `comment_id` 可能为空）：
```bash
bash <lark-doc>/scripts/lark-cli.sh drive file.comments list \
  --file-token <DOC_TOKEN> --file-type docx --page-size 100 > comments_raw.json
: # 从 data.items[].comment_id + quote 建立「评论→改动」映射
```
再逐条回复（**`--data` 用内联 JSON 字符串，不要用 `@绝对路径`**——raw `drive` 子命令
要求相对路径，与 `docs` wrapper 的 `@绝对路径` 约定相反，内联最稳）：
```bash
DATA=$(python3 -c "import json;print(json.dumps({'content':{'elements':[{'type':'text_run','text_run':{'text':'「ByAgent」<本次改动/回答>'}}]}},ensure_ascii=False))")
bash <lark-doc>/scripts/lark-cli.sh drive file.comment.replys create \
  --file-token <DOC_TOKEN> --file-type docx \
  --comment-id <COMMENT_ID> --data "$DATA"
```
回复文案要点：① `「ByAgent」` 开头；② 一句话讲清楚改了什么 / 结论是什么；
③ 指明落地位置（第几节 / 哪个块），方便 reviewer 核对。

## 可读性原则（改动「怎么改」的判据）

评论只说「哪里有问题」，「改成什么」由这套原则判定，**详见
[`references/readability-principles.md`](references/readability-principles.md)**
（该文件是**软链**，指向姊妹 skill 里的唯一权威副本
`../../gh-lark-tech-doc-writing/references/readability-principles.md`）。要点速记：结论优先去问答体、
只留结论砍实现细节、拆密集长段、大段无格式文本改带小标题列表、多模块职责按角色拆条、
新概念先解释来源、时序/分支改画图（规则图用 Mermaid，总览/架构等排版要求高的优先用 SVG，不强制 Mermaid）。

> **本 skill 的额外约束：任何改动都要保留其它评论的 quote 锚点**（就地改，不整段删重写）。
> 落地手法上，改场景常用 `block_replace` 把一个块换成多块（若该块正是被要求重写的评论锚点，
> 成孤儿是预期结果）、`block_insert_after` 插流程图。
>
> 原则要改，只改那份 canonical 文件，不要在本 SKILL.md 里另抄。

## 常见坑

| 现象 | 原因 | 处理 |
|------|------|------|
| `+fetch` 返回空 / exit 2 | 缺 `--api-version v2` | 补上，并 stdout 重定向到文件 |
| `@file` FileNotFoundError | wrapper cd 到 SKILL_ROOT | `@` 后用**绝对路径** |
| `updated_blocks_count: 0` | pattern 没匹配（HTML 实体转义、空白差异） | 回 fetch 看实际文本，注意 `<`→`&lt;`、`<code>` 标签 |
| 删表格行 `str_replace` 失败 | str_replace 不能删结构性 `<tr>` | 用 `block_replace` 重建整张表 |
| `block_insert_after` 返回 ok 但没插入 | 前一步 `block_replace` 已把该 block 的 id 换掉，锚点还用旧 id | 改后先 `+fetch` 拿**新 id**，再按新 id 插入 |
| 评论变孤儿 | quote 子串被删 | 改法里保留 quote 关键子串 |
| 回复评论报 `invalid file path`（要求相对路径） | raw `drive` 子命令与 `docs` wrapper 的 `@` 约定相反 | `--data` 用**内联 JSON 字符串**，不要用 `@绝对路径` |
| 回复时 `comment_id` 为空 | `docs +get-comments` 不一定回填 id | 改用 `drive file.comments list` 拿 `data.items[].comment_id` |
| `str_replace` 命中划词评论锚点段落却一直 `result=failed`（`updated_blocks_count:0`） | 划词/inline 评论会把该段的 text run 打散成多段,`str_replace`(单条或 `+update-batch` 批量)匹配不到连续文本 | 别再纠结 pattern,直接用 `block_replace` 整块重建(先 `+fetch --detail with-ids` 拿 block id,按块给新 XML);同一术语散落多块时逐块 `block_replace` |
| wrapper 报 `result=failed` / `degrade_code=1011,no document changes` 但其实已改成 | `docs +update/+update-batch` 的 success 判定不可靠——后端已落库,wrapper 仍回 failed | **以 `+fetch` 回读的实际正文为准**,别信 wrapper 的 ok/failed;改完必回 fetch 确认 `revision` 推进 + 目标文本已变,再决定是否重试(盲重试会重复改) |

## 依赖

- **lark-doc** skill（同一仓库/环境内），提供 `docs +get-comments / +fetch / +update /
  +update-batch`。本 skill 只是这套命令之上的**方法论编排**，不重复实现 API。
- **飞书 drive API**（同一 lark-cli），提供 `drive file.comments list`（拿真实
  `comment_id`）与 `drive file.comment.replys create`（在评论线程下回 `「ByAgent」` 回复）。
- 姊妹 skill **gh-lark-tech-doc-writing**：从零写 / 整篇大改技术飞书文档时用它；本 skill 的
  `references/readability-principles.md` 是一个**软链**，指向它下面的同名文件（唯一权威副本）。
  **两个 skill 需作为同一 collection 一起安装**，软链的相对目标才解析得到。
