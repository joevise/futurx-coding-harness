# ADR-011 — Contracts 层：跨角色契约对齐

- **状态**：Accepted
- **日期**：2026-05-21
- **决策人**：大Joe + Dr.EOJAD
- **关联 ADR**：ADR-002（上下文完备性）/ ADR-010（两层分发）

---

## 背景

v1.4 解决了"开发过程留痕"（Progress 4 件套），但**没解决多角色并行开发时的契约对齐问题**。

典型踩坑场景：

1. **前后端漂移**：后端改了 `/api/user` 返回字段，前端不知道，上线挂掉
2. **AI 幻觉接口**：前端用 AI 写代码时，AI"想象"了一个 `/api/order/cancel` 接口，后端根本没实现
3. **服务间漂移**：A 服务发出的事件 schema 改了，B 服务没收到通知

这些问题的根源：**接口/事件/数据模型是跨角色的"硬契约"，但没有一个集中的、权威的、可被所有 AI agent 读到的地方**。

---

## 决策

新增 `contracts/` 目录作为**项目所有跨角色契约的单一真相源（SSOT）**：

```
contracts/
├── api/                    ← REST/GraphQL/RPC 接口
│   ├── user-service.yaml   推荐 OpenAPI；项目小可以用 markdown
│   └── order-service.md
├── events/                 ← 消息队列/事件 schema
│   ├── order-created.md
│   └── user-deleted.md
└── data-models/            ← 跨服务/跨端共享的数据结构
    ├── User.md
    └── Order.md
```

### 配套铁律 5（升级版）

> **修改任何 API/事件/数据模型时，必须先改 `contracts/` 对应文件，再写实现代码。**
> 在 PR 描述里指明 contract diff，code review 时优先看 contract 变化。

### 约束细则

- **强制 contracts/ 优先**：实现代码不能领先于契约。如果要 quick fix 也得在同一个 PR 里同时改 contract
- **AI 必读**：AGENTS.md 里把 `contracts/` 列入"上下文必读"（与 `progress/current.md` 同级）
- **changes/*.md 关联**：task 完成时如果改了契约，changes/*.md 第 4 段必须列出 contract diff

### 推荐工具

| 类型 | 推荐格式 | 备选 |
|---|---|---|
| REST API | OpenAPI 3 (yaml) | Markdown 表格（项目小用） |
| GraphQL | SDL (.graphql) | — |
| 事件 | Markdown + JSON Schema | AsyncAPI（重型项目） |
| 数据模型 | Markdown 表格 + 类型定义 | TypeScript types / Pydantic |

不强制工具，只强制**所有跨角色契约都进 contracts/**。

---

## 强制级别

| 项 | 强制级别 |
|---|---|
| 改 API/事件先改 contracts/ | 硬约束（铁律 5） |
| 契约文件位置约定 | 硬约束 |
| 用何种 schema 工具（OpenAPI 等） | 推荐 |

---

## 取舍

- ✅ 多角色 vibe coding 的命门：AI 不会再幻觉接口
- ✅ 前后端 review 时第一眼看的就是 contract diff
- ✅ 上下文外化原则的延伸（ADR-002）
- ⚠️ 增加一道"双写"成本（先改 contract 再写代码）—— 但这正是要的护栏

---

## 关联

- ADR-002（上下文完备性）
- ADR-010（两层分发架构）
- ADR-012（产品/设计上下文层）
