# ADR-002: 上下文完备性原则（Context Completeness Protocol）

**状态**: accepted
**日期**: 2026-05-11
**作者**: 大Joe (proposed) / joey (drafted)

## 背景
传统程序员转向 AI vibe coding 时最大的失败模式是：
- 只看一眼 README 就开干
- 不知道项目其他人最近做了什么
- 不知道有哪些已经定下来的架构约束
- 重复别人踩过的坑、推翻别人定好的设计

## 决策
**任何 AI Agent / 程序员启动 session 时，必须按强制顺序读完以下所有文件，并能用一段话回答 3 个问题，否则不允许写代码：**

### 必读清单
1. AGENTS.md
2. README.md
3. `.ai/context.md`
4. `feature_list.json`
5. `progress/current.md`
6. `progress/tasks/<当前 task>/` 整个目录
7. `decisions/` 所有 ADR
8. 最近 7 天的 `progress/daily/*.md`

### 必答 3 问
- 当前 task 是什么？验收标准是什么？
- 项目的核心架构约束有哪些？哪些事不能做？
- 最近 3 天的工作脉络是什么？我接的是哪一段？

## 理由
- **OpenAI Harness 文章核心洞察**："环境可读性"是 Agent 高效协作的前提
- **Anthropic Long-Running Agents 文章**：跨 session 接力的关键就是把所有状态外化到文件
- **大Joe 的洞察**：vibe coding 的工作模式是"上下文即一切"，不能省

## 影响
- AGENTS.md 顶部加"强制启动协议"章节
- 加 pre-commit hook 检查 progress 是否更新
- PR review 要求确认 reviewer 也走完启动协议

## 关联
- AGENTS.md "强制启动协议" 章节
- ADR-001（task 为主轴是上下文可追溯的前提）
