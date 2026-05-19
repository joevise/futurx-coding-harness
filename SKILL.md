---
name: futurx-coding-harness
description: FuturX 团队 AI 编码协作框架 v1.4。当用户要求"接入 harness / 用 futurx 规范 / 团队协作开发 / 项目进度对齐"时启用。轻量化设计 + 集成 superpower skill 工具箱 + progress 4 件套进度追踪。
version: 1.4
---

# FuturX Coding Harness Skill v1.4

> **设计哲学**：轻量化、自由度、自愿使用。**只对齐边界，不替换方法。**
> 灵感来源：Anthropic Harness Engineering + OpenAI Codex 范式 + 2026-05-18 团队对齐会议

---

## 🎯 你（AI agent）该做什么

### 场景 1：用户说"帮我把这个项目接入 futurx harness"

执行步骤：
1. 检查当前目录是 git 仓库（不是就让用户先 `git init`）
2. 复制以下文件/目录（用 `cp -rn`，不覆盖已有）：
   - `AGENTS.md`, `SKILL.md`
   - `templates/`, `commands/`, `decisions/`
   - `progress/` 目录骨架（current.md / code-map.md / lessons.md / changes/）
3. 根据 agent 工具软链 AGENTS.md：
   - Claude Code → `CLAUDE.md → AGENTS.md`
   - Cursor → `.cursorrules → AGENTS.md`
   - OpenCode / OpenClaw / Codex → 直接读根目录 AGENTS.md
   - Copilot → `.github/copilot-instructions.md → AGENTS.md`
4. 从 templates/ 复制 4 件套到 progress/，提示用户填写
5. `git add -A && git commit -m "[T-000] chore: 接入 FuturX Coding Harness v1.4"`

### 场景 2：用户说 `/start-session` 或开新 session

按**最小启动协议**读以下文件，然后用一句话确认任务：
1. `AGENTS.md`（团队铁律）
2. `progress/current.md`（当前状态）
3. `progress/code-map.md`（代码定位）
4. `progress/lessons.md`（避坑）
5. `progress/changes/`（最近 3 个 task）

### 场景 3：用户说"我完成了 T-XXX，准备提交"

强制做这 3 件事：
1. 写 `progress/changes/YYYY-MM-DD-T-XXX.md`（4 段：改了什么 / 为什么改 / 思路 / 验收）
2. 更新 `progress/current.md` 移除该 task 或标记完成
3. commit message 带 `[T-XXX]` 前缀

### 场景 4：用户说"踩坑了"或发现错误方案

更新 `progress/lessons.md`，新增 L-XXX 条目。

### 场景 5：用户说 `/new-task` 或开新任务

读 `progress/current.md` 检查是否有相似进行中的 task，如果有 → 提示协作；否则分配新 task ID。

---

## 🧰 推荐工具：Superpower Skills

详见 `decisions/ADR-008-lightweight-and-superpower.md`。

| 场景 | 推荐 skill |
|---|---|
| 需求模糊 | brainstorming |
| 复杂任务开发前 | writing-plans |
| 代码评审前自检 | requesting-code-review |
| 多分支并行 | using-git-worktrees |
| 关键业务逻辑 | test-driven-development |
| 遇到 bug | systematic-debugging |
| 声称完成前自检 | verification-before-completion ⭐强烈推荐 |

**这些是工具不是义务。** Agent 按场景自行判断是否调用。

---

## 🚨 团队 4 条铁律（不可逾越）

1. **每个 commit 必须带 task ID**：`[T-XXX] feat/fix/docs/...`
2. **每个 task 完成必须写** `progress/changes/YYYY-MM-DD-T-XXX.md`
3. **新 session 必须读** `progress/current.md` + `progress/lessons.md`
4. **踩到新坑必须更新** `progress/lessons.md`

其他全部**推荐而非强制**（SDD / 双重对齐 / 任务脚本 / 测试覆盖率 …）。

---

## 📐 设计原则

- **轻量化** > 完备性
- **自愿** > 强制
- **短文件** > 长 spec
- **共识** > 流程
- **进度可追溯** > 进度可控制

详见 `decisions/ADR-007 / ADR-008 / ADR-009`。
