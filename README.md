# FuturX Coding Harness v1.1

> FuturX 内部 AI vibe coding 标准 / 模板仓库
> **核心范式**：SDD（规格驱动）+ TDD（测试驱动）+ 上下文完备性 + 工具中立

## v1.1 新特性 ⭐

- ✅ **SDD 工作流**：每个 task 必须 Spec → Plan → Test → Code
- ✅ **测试 3 层规范**：单元（pytest/vitest）+ 集成（Bruno）+ E2E（Playwright）
- ✅ **CI 自动校验** harness 合规性
- ✅ **task 目录升级**：新增 spec.md + plan.md 模板

## 是什么

一套**强制性 AI 编码工程协议**：
- 📝 顶端 RULES（`AGENTS.md`）
- 📁 标准化文件骨架（progress / decisions / .ai / tests / scripts）
- 🧭 **SDD 流程**（Spec → Plan → Test → Code）
- 🔁 强制 SOP（session 开头/结尾必做）
- 🧰 工具中立适配层（Cursor / Claude Code / OpenCode / Codex 都吃同一份）
- ✅ Pre-commit hook + CI 阻断

## 为什么

- 团队成员背景多样（传统程序员 + AI 原生）
- 不同人用不同 AI 工具
- 项目越来越多，**上下文丢失**和**决策不可溯源**是核心瓶颈
- **AI 容易写出"测试通过但偏题"的代码** → 必须 SDD 先对齐"做什么"

参考：
- [GitHub Spec-Kit](https://github.com/github/spec-kit)（SDD 业界标准）
- Anthropic — Effective Harnesses for Long-Running Agents
- OpenAI — Harness Engineering: Leveraging Codex in an Agent-First World

## 怎么用

### 新项目启动
```bash
gh repo create my-project --template joevise/futurx-coding-harness
cd my-project
bash scripts/sync-rules.sh
# 编辑 AGENTS.md 顶部 + .ai/context.md
```

### 已有项目接入
```bash
cp -rn /path/to/futurx-coding-harness/{AGENTS.md,progress,decisions,.ai,scripts,.github} ./
bash scripts/sync-rules.sh
```

### 开一个新功能（SDD 流程）
```bash
# 1. 创建 task 目录
mkdir -p progress/tasks/T-001-my-feature tests/T-001
cp progress/tasks/T-000-example-task/{spec,plan,log,decisions}.md progress/tasks/T-001-my-feature/

# 2. 填 spec.md → 给产品/Leader review
# 3. 填 plan.md → 给技术 Lead review
# 4. 在 tests/T-001/ 写测试用例
# 5. AI 写代码让测试通过
# 6. PR + commit message: [T-001] feat: ...
```

## 四个核心设计

| 设计 | 说明 | 来源 |
|---|---|---|
| **Task 为主轴** | progress 按任务分，不按人 | Anthropic feature_list.json |
| **AGENTS.md 唯一真相源** | 所有 AI 工具配置软链到它 | OpenAI Harness |
| **上下文完备性协议** | 启动必须读完所有上下文 | 大Joe 提出 |
| **SDD（v1.1）** | Spec→Plan→Test→Code，AI 不能直接看需求写代码 | GitHub Spec-Kit |

## 版本历史
- **v1.1** (2026-05-11) — SDD 流程 + 测试 3 层规范 + CI 校验
- v1.0 (2026-05-11) — 首版（启动协议 + task 主轴 + 工具中立）
