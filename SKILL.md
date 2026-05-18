---
name: futurx-coding-harness
description: FuturX 内部 AI 编码协作标准。当用户要求"接入 harness / 用 futurx 规范 / 走 SDD 流程 / 创建 task / 检查协作 task"时启用。提供 /new-task /sync-check /start-session 三个核心斜杠命令。
version: 1.3
---

# FuturX Coding Harness Skill

## 你（AI agent）该做什么

### 场景 1：用户说"帮我把这个项目接入 futurx harness"
执行步骤：
1. 检查当前目录是不是 git 仓库（不是就报错让用户先 git init）
2. 把以下文件/目录复制到当前项目（不覆盖已有文件，用 cp -rn）：
   - AGENTS.md, README.md（如果项目自己有，跳过 README.md）
   - .ai/, progress/, decisions/, scripts/, .github/, templates/
   - feature_list.json, .gitignore（合并而非覆盖）
3. 根据用户使用的 agent 工具，在对应位置软链 AGENTS.md：
   - Claude Code → `.claude/CLAUDE.md → AGENTS.md`
   - Cursor → `.cursor/rules/agents.mdc → AGENTS.md`
   - OpenCode → 直接读根目录 AGENTS.md，无需软链
   - OpenClaw → 直接读根目录 AGENTS.md
   - Copilot → `.github/copilot-instructions.md → AGENTS.md`
4. 提示用户编辑 .ai/context.md 写入项目业务背景
5. 跑 `git add -A && git commit -m "[T-000] chore: 接入 FuturX Coding Harness v1.3"`

### 场景 2：用户说 `/new-task` 或"开一个新任务"
读 `commands/new-task.md`，按里面的协议走（核心是跑 scripts/new-task.sh，并强制走双重对齐）。

### 场景 3：用户说 `/sync-check` 或"检查协作进度"
跑 `bash scripts/sync-check.sh`，把输出汇报给用户。

### 场景 4：用户说 `/start-session` 或开始新 session
按"启动协议"读 8 类文件，然后回答 3 个核心问题，再请用户确认开始工作。

## 三大核心范式（你必须遵守）
1. 上下文完备性：session 启动读 8 类文件
2. SDD：Spec→Plan→Test→Code，不可跳步
3. 协作双重对齐：相似任务扫描 + 加入他人 task 走 3 步对齐

详见 AGENTS.md（不限行数，分节结构化）。

## 不可逾越的红线
- 不允许手动建 progress/tasks/T-XXX 目录，必须用 scripts/new-task.sh
- commit message 必须带 task ID（[T-XXX] 或 [T-XXX.Y]）
- AI 输出不看就直接 commit = 红线