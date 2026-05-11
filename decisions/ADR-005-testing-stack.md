# ADR-005: 测试 3 层规范（单元 + 集成 + E2E）

**状态**: accepted
**日期**: 2026-05-11
**作者**: joey

## 背景
v1.0 只在 AGENTS.md 提了"必须有测试"，但没具体规定怎么测、用什么工具。
导致团队各搞各的，无法统一 review。

## 决策
**强制 3 层测试架构**：

### 第 1 层：单元测试
| 技术栈 | 推荐工具 |
|---|---|
| Python | pytest + pytest-cov |
| Node/TS | vitest |
| Go | go test |
| Rust | cargo test |

- 覆盖率目标：≥ 70%（不强求 100%）

### 第 2 层：集成测试
| 类型 | 推荐工具 |
|---|---|
| HTTP API | Bruno（文件即配置，进 git） |
| 数据库 | testcontainers |
| 队列/缓存 | testcontainers |

### 第 3 层：端到端测试
| 项目类型 | 推荐工具 |
|---|---|
| Web 前端 | **Playwright**（业界标准） |
| 后端服务 | Bruno + 自定义脚本 |
| AI Agent | **Inspect AI**（Anthropic）/ Promptfoo |
| 移动端 | Appium + Playwright |

## 理由
- **Playwright** 已成为业界标准（微软出品，跨浏览器，AI 友好）
- **Bruno** 优于 Postman：文件即配置，可进 git，无云依赖
- **Inspect AI** 是 Anthropic 官方 LLM 评测框架，AI 项目必备
- 3 层金字塔 = 工业最佳实践

## 强制规则
- 每个 task 在 `tests/T-XXX/` 下组织测试
- 测试用例必须一对一映射 spec.md 的验收标准
- CI 必须跑全部 3 层测试
- 覆盖率不达标 → PR 不通过

## 关联
- ADR-003 / ADR-004: SDD + TDD
- AGENTS.md "测试栈" 章节
