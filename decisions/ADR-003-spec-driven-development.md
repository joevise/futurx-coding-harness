# ADR-003: 引入 SDD（Spec-Driven Development）作为 v1.1 升级

**状态**: accepted
**日期**: 2026-05-11
**作者**: 大Joe (proposed) / joey (drafted)

## 背景
v1.0 的流程是 "task → 直接写代码"，但实际使用中暴露了一个问题：
**AI 容易写出"测试通过但偏题"的代码**——根源是没有规格说明（Spec），
AI 和工程师对"做什么"的理解从一开始就不对齐。

GitHub 2025 年 9 月开源了 [Spec-Kit](https://github.com/github/spec-kit)，
把 Spec-Driven Development（SDD）推成 AI 编码的业界标准范式。

## 决策
**v1.1 引入 SDD 流程**，每个 task 必须按以下顺序产出文档：

```
Spec（spec.md） → Plan（plan.md） → Test（tests/T-XXX/） → Code
```

### 强制规则
- 新功能 task **必须有 spec.md**（修 bug / 小调整可豁免）
- spec.md 未 review → 不能写 plan.md
- plan.md 未 review → 不能写代码
- 没有对应测试的代码 → 不能 merge

### 工具
- 可选用 GitHub Spec-Kit CLI（`specify-cli`）
- 不强制依赖 spec-kit，markdown 模板足够

## 理由
- **SDD 解决"做的事正确"，TDD 解决"代码正确"**——AI 时代两者都要
- **Spec 是文件 → 进 git → 可 review → 可追溯**，符合 harness 精神
- **降低 AI 跑偏率**：AI 拿着 spec 写代码，比拿着模糊需求写靠谱得多
- **产品/工程对齐**：spec 是产品和工程的共同语言
- **业界趋势**：GitHub / Anthropic / OpenAI 都在推 SDD

## 影响
- task 目录从 4 个文件升级到 6 个：新增 `spec.md` 和 `plan.md`
- AGENTS.md 加 SDD 工作流章节
- PR 模板加 spec/plan review 确认项
- 强制启动协议必读清单加上 spec.md + plan.md

## 取舍
- ✅ 上游对齐成本上升，下游返工成本下降
- ⚠️ 写 spec 需要功夫，但比写错代码再返工强
- ⚠️ 团队需要学会写规格说明（新的能力门槛）

## 关联
- ADR-001: task 为主轴
- ADR-002: 上下文完备性
- ADR-004: SDD + TDD 关系
