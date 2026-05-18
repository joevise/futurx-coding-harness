# FuturX Coding Harness v1.3

> FuturX 内部 AI vibe coding 标准 / 模板仓库

## 三大核心范式

| 范式 | 解决什么 | 引入版本 |
|---|---|---|
| **上下文完备性协议** | AI 启动时强制读完所有上下文 | v1.0 |
| **SDD（Spec→Plan→Test→Code）** | AI 不能直接看需求写代码 | v1.1 |
| **协作双重对齐** | 多人开发不撞车、不踩坑 | v1.2 ⭐ |

## v1.2 新特性 ⭐

- ✅ **`scripts/new-task.sh`**：智能 task 创建（自动 ID + 相似度扫描 + 双重对齐协议）
- ✅ **`scripts/sync-check.sh`**：session 启动时自动检查协作 task 动态
- ✅ **`collaborators.json`**：结构化协作记录，替代单行 owner.txt
- ✅ **子任务（T-XXX.Y）**：父子关系明确，加入协作有据可查

## 快速开始

让 AI agent 拉本 repo 并接入：直接对它说"帮我把当前项目接入 futurx coding harness"，它会读 SKILL.md 自己完成。

或手动：
```bash
# 1. 用本仓库做模板新建项目
gh repo create my-project --template joevise/futurx-coding-harness
cd my-project
bash scripts/sync-rules.sh

# 2. 开第一个 task
bash scripts/new-task.sh
# 按交互填写：描述 → 工具扫描相似 task → 决定独立/加入 → 创建目录
```

## 三大核心设计速览

### 1. 上下文完备性（v1.0）
session 启动必须读 8 类文件，并能回答 3 个核心问题。

### 2. SDD 流程（v1.1）
```
Spec（做什么） → Plan（怎么做） → Test（验证） → Code（实现）
```
每步进 git、可 review、可追溯。

### 3. 协作双重对齐（v1.2 ⭐）

**第 1 重：是不是同一个任务？**
- `new-task.sh` 扫描所有进行中的 task
- 找到相似的 → 强制用户决定：加入 / 独立 / 看完再说

**第 2 重：加入他人 task 必须走 3 步对齐**
- Step 1 读完 spec / plan / log / decisions
- Step 2 联系 owner 达成分工共识
- Step 3 声明自己的具体范围

三步全打钩才创建子任务目录。

## 工具中立

用什么 AI 工具自己选（Cursor / Claude Code / OpenCode / Codex / Copilot），但：
- 都软链到 AGENTS.md
- 都吐同样格式的 commit / PR / ADR

## 版本历史
- **v1.3** (2026-05-18) — Skill 化入口 + 解除 AGENTS.md 行数限制 + 斜杠命令规范
- **v1.2** (2026-05-11) — 多人协作双重对齐 + new-task.sh + sync-check.sh
- v1.1 (2026-05-11) — SDD + 测试 3 层 + CI 校验
- v1.0 (2026-05-11) — 启动协议 + task 主轴 + 工具中立

## 参考
- [GitHub Spec-Kit](https://github.com/github/spec-kit)
- Anthropic — Effective Harnesses for Long-Running Agents
- OpenAI — Harness Engineering: Leveraging Codex in an Agent-First World
