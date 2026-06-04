# 更新日志

## 2026-06-04

### 修复
- `templates/CLAUDE.md.snippet`：写日志规则改为用 `Add-Content` 追加，明确禁止用 `Edit`

**背景**：实际使用中发现，用 Edit 以某条已有日志为锚点插入新条目时，新条目会被放在锚点**之前**而非之后，导致时间顺序错乱。改用 Add-Content 追加末尾，天然保证顺序正确，且省 token。

---

## 2026-06-01

### 新增
- 首次发布：WORKLOG 半自动工作日志系统
- `scripts/create-worklog.ps1`（Windows）、`create-worklog.sh`（macOS/Linux）
- `templates/CLAUDE.md.snippet`、`templates/settings.hook.json`
- `examples/WORKLOG.md`、`examples/WORKLOG_index.md`
- `README.md`：包含理念说明、安装步骤、踩坑记录、跨工具迁移指南
