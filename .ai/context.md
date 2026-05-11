# 项目长期上下文 (.ai/context.md)

> 这个文件存放**项目级别的稳定知识**：架构约束、风格、术语表、业务背景。

## 架构约束
- 本项目是模板仓库，**不应该包含业务代码**
- 所有 markdown 文件遵循 commonmark
- 所有脚本必须可以在 macOS / Linux 上运行

## 风格约定
- 中英文混排，技术术语用英文
- 文件名用 kebab-case
- task ID 格式：`T-XXX-name`
- ADR ID 格式：`ADR-XXX-title.md`
- commit message：`[T-XXX] <type>: <description>`（conventional commits）

## 术语表

| 术语 | 定义 |
|---|---|
| Harness | AI 编码工程的协作框架 |
| Task | 工作单元，对应 progress/tasks/T-XXX/ |
| ADR | Architecture Decision Record，架构决策记录 |
| **SDD** | **Spec-Driven Development，规格驱动开发（v1.1 引入）** |
| **Spec** | **规格说明，用户/产品视角的"做什么"文档** |
| **Plan** | **技术方案，工程视角的"怎么做"文档** |
| TDD | Test-Driven Development，测试驱动开发 |
| 启动协议 | session 开始时必须走完的上下文加载流程 |
| Vibe Coding | AI 主导的编码方式 |

## 业务背景
- FuturX 是 AI 公司，团队多元（传统程序员 + AI 原生）
- 项目数量增长快，需要标准化的协作框架
- 公司主推工具：OpenCode (MiniMax-M2.7) 为主，Claude Code / Cursor / Codex 自由使用

## SDD 流程速记
```
Spec (做什么) → Plan (怎么做) → Test (验证) → Code (实现)
```
- 每步都进 git
- 每步都可 review
- AI 拿着 spec 写代码，比拿着模糊需求写靠谱
