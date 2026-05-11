# 项目长期上下文 (.ai/context.md)

> 这个文件存放**项目级别的稳定知识**：架构约束、风格、术语表、业务背景。
> 修改频率应该低于 progress/。如果某个内容在频繁变，说明它该放 progress/ 而不是这里。

## 架构约束
- 本项目是模板仓库，**不应该包含业务代码**
- 所有 markdown 文件遵循 commonmark
- 所有脚本必须可以在 macOS / Linux 上运行（不能用 GNU-only 选项）

## 风格约定
- 中英文混排，技术术语用英文
- 文件名用 kebab-case
- task ID 格式：`T-XXX-name`（XXX 是 3 位数字）
- ADR ID 格式：`ADR-XXX-title.md`
- commit message：`[T-XXX] <type>: <description>`，type 取自 conventional commits

## 术语表

| 术语 | 定义 |
|---|---|
| Harness | AI 编码工程的协作框架（提示词+文件骨架+SOP+工具链+评审制度） |
| Task | 工作单元，对应 progress/tasks/T-XXX/ |
| ADR | Architecture Decision Record，架构决策记录 |
| 启动协议 | session 开始时必须走完的上下文加载流程 |
| Vibe Coding | AI 主导的编码方式，人提供意图、AI 实现、人 review |

## 业务背景
- FuturX 是 AI 公司，团队多元（传统程序员 + AI 原生）
- 项目数量增长快，需要标准化的协作框架
- 公司主推工具：OpenCode (MiniMax-M2.7) 为主，Claude Code / Cursor / Codex 自由使用
