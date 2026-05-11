# FuturX Coding Harness v1.0

> FuturX 内部 vibe coding 标准 / 模板仓库
> **目标**：让所有项目用同一套 AI 编码协作标准，做到可溯源、上下文对齐、工具中立。

## 这是什么

一套**强制性 AI 编码工程协议**，包括：
- 📝 顶端 RULES 提示词（`AGENTS.md`）
- 📁 标准化文件骨架（progress / decisions / .ai / tests / scripts）
- 🔁 强制 SOP（session 开头/结尾必做事项）
- 🧰 工具中立适配层（Cursor / Claude Code / OpenCode / Codex 都吃同一份）
- ✅ Pre-commit hook + CI 阻断（progress 未更新 / 测试不过 = 不让 merge）

## 为什么需要

我们的痛点：
- 团队成员背景多样（传统程序员 + AI 原生）
- 不同人用不同工具（Cursor / Claude Code / OpenCode / Codex）
- 项目越来越多，**上下文丢失** 和 **决策不可溯源** 是核心瓶颈

参考来源：
- [Anthropic — Effective Harnesses for Long-Running Agents](https://www.anthropic.com/research)
- [OpenAI — Harness Engineering: Leveraging Codex in an Agent-First World](https://openai.com/blog)

## 怎么用

### 新项目启动
```bash
# 1. 用本仓库做模板，建新项目
gh repo create my-project --template joevise/futurx-coding-harness

# 2. 进入项目，跑同步脚本
cd my-project
bash scripts/sync-rules.sh

# 3. 修改 AGENTS.md 顶部的项目名 + 编辑 .ai/context.md
```

### 已有项目接入
```bash
# 把本仓库的骨架复制进去（保留你已有的 src/）
cp -rn /path/to/futurx-coding-harness/{AGENTS.md,progress,decisions,.ai,scripts} ./
bash scripts/sync-rules.sh
```

## 三个核心设计

| 设计 | 说明 | 来源 |
|---|---|---|
| **Task 为主轴** | progress 按任务（T-XXX）分，不按人 | Anthropic feature_list.json |
| **AGENTS.md 唯一真相源** | 所有 AI 工具配置软链到它 | OpenAI Harness |
| **上下文完备性协议** | 启动必须读完所有上下文才能动手 | 大Joe 提出 |

## 目录速查
- `AGENTS.md` — 主入口，所有 AI 工具的 rules 都软链到它
- `progress/current.md` — 看一眼就知道现在谁在做啥
- `progress/tasks/T-XXX/` — 单个任务的全部历史
- `decisions/` — 架构决策记录（ADR）
- `.ai/context.md` — 长期上下文（架构、术语、约束）

## 当前版本
- **v1.0** (2026-05-11) — 首版发布
