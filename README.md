# Claude Code 半自动工作日志（WORKLOG）

让每一次任务"有迹可循"：把**做了什么、用了什么方法、踩了什么坑、为什么这么决策**，留成一份不随对话上下文消失的记录。

**"半自动"** = 建文件全自动（SessionStart hook），写内容由 AI 在关键节点手动完成。适配 [Claude Code](https://claude.com/claude-code)，理念部分对任何 AI 助手通用。

---

## 目录

- [解决什么问题](#解决什么问题)
- [核心理念（与工具无关）](#核心理念与工具无关)
- [哪些是 Claude Code 专属](#哪些是-claude-code-专属)
- [安装](#安装)
- [怎么用](#怎么用)
- [设计说明 / 踩过的坑](#设计说明--踩过的坑)
- [换别的 AI 工具怎么办](#换别的-ai-工具怎么办)
- [文件结构](#文件结构)
- [License](#license)

---

## 解决什么问题

AI 编程助手的对话上下文会在**压缩（compaction）**或**新开会话**时丢失或变模糊。于是：

- "这个数字上次是怎么算错的？" —— 只能凭记忆
- "这个设计当初为什么这么定？" —— `git diff` 只记录改了什么，不记录**为什么**
- 换了新对话，AI 又要你把背景重讲一遍

**WORKLOG** 在每个项目目录留一份持久的工作日志：AI 在任务节点把过程、方法、坑、决策写进去。以后无论上下文怎么变，**翻日志就能恢复**——既给人看，也给下一次的 AI 看。

它记的是**任务的方法/坑/决策**，不是聊天逐字记录，也不是 `git log` 的代码流水账。

---

## 核心理念（与工具无关）

即使你不用 Claude Code，下面这些原则也通用：

1. **双文件分层**
   - `WORKLOG_index.md` —— 目录。每条一句话摘要，用来**快速扫描定位**。
   - `WORKLOG.md` —— 详细。摘要后面接方法/坑/决策。
   - 翻阅时：先扫 index 找到目标，再去 WORKLOG 看细节。文件再长，定位成本也低。

2. **每条带三要素**：`### 时间 [任务标签] (session: 对话id)`
   - **`[任务标签]`** —— 主分组键。摘要常常是"做了 ppt""写了稿子"这种通用动作，跨任务长得一模一样，光看内容分不清；**有了标签，一眼就能把同一个任务的条目归到一起**。
   - **session / 对话 id** —— 溯源，知道这条是哪段对话产生的。
   - **时间** —— 排序、定位。

3. **一个任务可以拆成多条，不强求合并**
   同一任务的多条日志用**同一个标签**即可，翻阅时按标签聚合。不必把一个跨越多次进展的任务硬塞进一条。

4. **记"为什么"，不只记"做了什么"**
   - **方法**：用了什么方案（有参考价值时写）
   - **坑**：遇到什么问题、怎么解决的
   - **决策**：为什么这么选而不是别的
   这些才是 `git` 不记录、日后最值钱的东西。顺利无特别之处，一行摘要带过即可。

5. **手动写在关键节点**
   任务告一段落时，或（AI 对话）**主动压缩前**先写一条（此时记忆最完整，质量最好）。不追求每一步自动记录——那只会变成噪音流水账。

---

## 哪些是 Claude Code 专属

| 部分 | 通用性 |
|------|--------|
| 上面的理念、双文件、任务标签、内容结构 | ✅ 任何 AI 助手、甚至手写笔记都适用 |
| 自动建文件的 hook、用 `CLAUDE.md` 注入指令、用对话记录文件取 id | ⚠️ **Claude Code 专属** |
| `create-worklog.ps1` | ⚠️ Windows / PowerShell（Mac/Linux 用 `.sh` 版） |

换别的模型 / 工具：**保留理念，机制按你的工具重新实现**（见[换别的 AI 工具怎么办](#换别的-ai-工具怎么办)）。

---

## 安装

### Claude Code · Windows

1. 把 `scripts/create-worklog.ps1` 放到 `C:\Users\<你>\.claude\create-worklog.ps1`
2. 编辑 `C:\Users\<你>\.claude\settings.json`，把 `templates/settings.hook.json` 里的 `SessionStart` hook **合并**进去
   （**不是整体替换**——如果你已经有 `hooks` 对象，就把 `SessionStart` 加进去；把命令里的 `<YOU>` 换成你的用户名）
3. 把 `templates/CLAUDE.md.snippet` 的内容**追加**到你的**全局** `CLAUDE.md`（`C:\Users\<你>\.claude\CLAUDE.md`，没有就新建）
4. **重开一个对话** —— 以后每个项目目录首次打开都会自动生成 `WORKLOG.md` 和 `WORKLOG_index.md`

### Claude Code · macOS / Linux

1. 把 `scripts/create-worklog.sh` 放到 `~/.claude/create-worklog.sh`，然后 `chmod +x ~/.claude/create-worklog.sh`
2. settings.json 的 hook 命令改成 `bash ~/.claude/create-worklog.sh`（去掉 `"shell": "powershell"`）
3. CLAUDE.md 片段同上
4. 重开对话生效

> 配置改动只对**新会话**生效。改完记得新开一个对话。

---

## 怎么用

- **写日志**：任务告一段落时跟 AI 说"写日志"；或在你主动压缩对话前先让它写一条。
- **格式**：见 `examples/`。每条 `### 时间 [任务标签] (session: id)` + 摘要；详细版再接方法/坑/决策。
- **翻阅**：直接跟 AI 说任务名（"看下登录那个任务怎么做的"），它按 `[标签]` 把相关条目捞出来——你不用去翻 id。
- **取 id**（Claude Code）：对话记录在 `~/.claude/projects/<项目对应目录>/<id>.jsonl`，文件名即 id，当前对话 = 最新被写的那个。

---

## 设计说明 / 踩过的坑

这套东西是迭代打磨出来的，下面几个坑值得想改造的人留意：

- **agent 类型 hook 在 VSCode 扩展里不支持**
  报错 `Agent stop hooks are not yet supported outside REPL`。所以"压缩前自动让 AI 写存档"在 VSCode 里**行不通**，只能手动写。`command` 类型 hook 正常。

- **PowerShell 5.1 的脚本必须纯 ASCII（含注释）**
  无 BOM 的 `.ps1` 会被按 GBK/ANSI 读，中文注释的字节会乱码、**破坏脚本**。所以脚本注释一律英文。

- **不要用单独的状态文件存 session id**
  早期版本用过一个 `.worklog_session` 文件，但它每个文件夹只有一个、会被"**最后启动的那个会话**"覆盖；同一文件夹开过多个对话时就指错了。改用"**最新 `.jsonl` 文件名**"取 id 更可靠。

- **任务一般不跨对话、但可能跨多次压缩**
  所以 session id 是任务的天然边界；同一对话内的多个任务靠 `[任务标签]` 区分。

- **追加日志尽量不整篇重读**
  日志很长后，用 shell 在文件尾部追加（保证 UTF-8、补换行）比"读全文再改"省得多。

---

## 换别的 AI 工具怎么办

只保留**理念层**，机制层按你的工具重写：

- **"自动建文件"** → 工具若没有 hook，就手动建，或用它的等价启动钩子
- **"指令注入"**（这里用 CLAUDE.md）→ 放进你工具的系统提示 / 规则文件
- **"取对话 id"** → 用你工具的会话标识；实在没有，用"日期 + 任务标签"也足够分组

核心不变：**双文件、任务标签、记方法/坑/决策、在关键节点手动写。**

---

## 文件结构

```
claude-worklog/
├── README.md                     本文件
├── scripts/
│   ├── create-worklog.ps1        SessionStart hook（Windows）
│   └── create-worklog.sh         SessionStart hook（macOS/Linux）
├── templates/
│   ├── settings.hook.json        要合并进 settings.json 的 hook 片段
│   └── CLAUDE.md.snippet          要追加进全局 CLAUDE.md 的规则
└── examples/
    ├── WORKLOG_index.md          目录文件示例（虚构内容）
    └── WORKLOG.md                详细文件示例（虚构内容）
```

`examples/` 里是**虚构的示例**，仅用于演示格式。

---

## License

MIT —— 随意取用、修改、分享。
