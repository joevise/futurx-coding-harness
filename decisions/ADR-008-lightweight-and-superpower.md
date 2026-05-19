# ADR-008 — 轻量化原则 + Superpower Skill 集成

- **状态**：Accepted
- **日期**：2026-05-19
- **决策人**：大Joe + 项目组
- **会议来源**：2026-05-18 Harness Engineering 内部对齐会
- **关联 ADR**：ADR-003（SDD 流程）— 本 ADR 部分修订其强制性

---

## 背景

v1.3 之前 harness 有"重型化"倾向：强制 SDD 流程、强制双重对齐协议、强制 task 目录脚本生成。

会议上百村和阿和都明确反对**全员强制**：

### 百村
> 「spec 真的很反人类，它只有在新项目+逻辑简单时才好用。遇到 tricky 问题整个架构就崩了，AI 会被错误的 spec 反复污染。」

### 阿和
> 「我相信百村和乐琴他们都有自己的一套开发方式，**我们只需要把这个要求给他定好**，然后可能每个人都可以用自己合适的，**我们只需要把这个框架弄好就行**。harness 应该是很轻量的。」

阿和同时推荐了他用了几个月的 **superpower** skill 包（12+ 个独立 skill：brainstorming / writing-plans / requesting-code-review / using-git-worktrees / test-driven-development 等）。大Joe 当场拍板「可以直接照搬进我们的 skill，作为强力开发底座」。

---

## 表面冲突

「轻量化」和「集成 superpower」乍看冲突，但**本质上互补**。问题不是 skill 多不多，而是**集成方式**。

---

## 决策

### 原则 1：opt-in（自愿）而非 mandatory（强制）

- AGENTS.md 顶部铁律控制在**几条核心**（commit 带 task ID / 更新 progress / 读 lessons / 写 changes）
- SDD / 双重对齐 / new-task.sh 全部**降级为推荐**，不强制
- 个人 spec 随意（本地，不上仓库）

### 原则 2：引用式集成，不嵌入

- superpower 通过 **ClawHub install** 或文档**引用方式**接入
- AGENTS.md 只列 skill 名字 + 一句话说明，**不复制 skill 内容**
- 每个 skill 是独立 markdown，agent 按需调用

### 原则 3：尊重既有工具

- Cursor / Claude Code / OpenCode / Codex 全部支持
- 主 AGENTS.md 软链到各工具对应文件（.claude/CLAUDE.md / .cursorrules / agents.md）
- 不要求任何人改变 IDE 或开发方式

### 原则 4：AGENTS.md 控制在 200 行内（柔性目标）

- 不再像 v1.0 强制 150 行，但也不放任膨胀
- 目标是"agent 一眼能读完团队边界"

---

## 推荐使用的 superpower skill 清单

| skill 名 | 触发场景 | 强制级别 |
|---|---|---|
| brainstorming | 需求模糊时 | 推荐 |
| writing-plans | 复杂任务开发前 | 推荐 |
| requesting-code-review | PR 提交前 | 推荐 |
| using-git-worktrees | 多分支并行开发 | 推荐 |
| test-driven-development | 关键业务逻辑 | 推荐 |
| systematic-debugging | 遇到 bug 不知所措 | 推荐 |
| receiving-code-review | 收到 review 反馈 | 推荐 |
| verification-before-completion | 声称完成前自检 | **强烈推荐** |
| subagent-driven-development | 大任务拆分 | 推荐 |
| dispatching-parallel-agents | 并行任务 | 推荐 |
| finishing-a-development-branch | 分支收尾 | 推荐 |
| writing-plans | 写实施计划 | 推荐 |

---

## 解决的问题

| 担心 | 决策如何解决 |
|---|---|
| 百村：SDD 太重 | 改推荐，spec 个人随意 |
| 百村：spec 污染上下文 | 配合 ADR-007 progress 层，AI 读短文件 |
| 阿和：希望保留个人工作流 | 引用式集成，不替换 |
| 大Joe：要团队对齐 | progress 4 件套 + AGENTS.md 200 行铁律 |
| 团队新人：不知道怎么开发 | superpower 提供工具箱 |

---

## 不冲突的证据

阿和原话直接说明了为什么不冲突：

> 「我们只需要把这个**框架**弄好就行，**自由度交给每个人**。」

superpower = 框架里的工具箱
AGENTS.md = 自由度的边界
progress 4 件套 = 团队对齐的最小集
