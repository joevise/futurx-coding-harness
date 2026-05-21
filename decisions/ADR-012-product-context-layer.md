# ADR-012 — Product 层：产品/设计上下文与代码绑定

- **状态**：Accepted
- **日期**：2026-05-21
- **决策人**：大Joe + Dr.EOJAD
- **关联 ADR**：ADR-009（PM 输入 3+1 模板）/ ADR-010（两层分发）

---

## 背景

v1.4 通过 `templates/pm-input-template.md`（3+1 模板）规范了产品给开发的**输入格式**，但有两个真空：

1. **产品上下文没"住"在仓库里**：PRD 散落在飞书/Notion，AI 读不到
2. **代码跟产品意图无绑定**：看一段代码，不知道它对应哪个用户故事、哪条产品需求

多角色团队（产品 / 设计 / 前端 / 后端）vibe coding 时，AI 缺少业务上下文 → 改出"技术对但业务错"的代码。

---

## 决策

新增 `product/` 目录，跟 `progress/` `contracts/` 平级，承载产品/设计上下文：

```
product/
├── prd/                          ← PRD 文档（用 3+1 模板写）
│   ├── v1.0-mvp.md
│   └── v1.1-search.md
├── design/                       ← 设计稿/原型
│   ├── figma-links.md            统一收口设计稿外链
│   └── prototypes/               demo-grade HTML 原型（新项目必给）
└── user-stories/                 ← 核心用户故事
    └── US-001-onboarding.md
```

### 与代码的绑定方式

**轻量绑定，不强制工具**：

1. **changes/*.md 第 4 段加引用**（升级 4 段为 5 段）：
   - 改了什么
   - 为什么改
   - 思路
   - 验收
   - **关联**：PRD 章节 / user story ID / 设计稿链接（新增）

2. **code-map.md 标注产品归属**：
   ```
   ## src/features/checkout/
   - 实现：US-003 / PRD §4.2
   - 关键文件：CheckoutForm.tsx, useCheckout.ts
   ```

3. **AGENTS.md 把 product/ 列入"上下文必读"**：
   - 新 session 开始时，AI 读 `progress/current.md` + `product/prd/<当前版本>.md`

### 角色分工

| 文件 | 主要维护者 |
|---|---|
| `prd/*.md` | 产品（婷婷） |
| `design/figma-links.md`, `prototypes/` | 设计师 / 交互 |
| `user-stories/*.md` | 产品 + 主开发 |
| changes/*.md 关联段 | 开发（写 task 总结时） |
| code-map.md 产品归属 | 开发（merge 触发的自动脚本会保留） |

---

## 强制级别

| 项 | 强制级别 |
|---|---|
| 项目必须有 `product/` 目录 | 硬约束 |
| changes/*.md 5 段（含关联） | 硬约束（升级铁律 2） |
| code-map.md 必须标注产品归属 | 推荐 |
| 设计稿一定上传到 prototypes/ | 推荐（新项目强制） |

---

## 取舍

- ✅ AI 改代码时立刻知道"这是为啥功能、给谁用"
- ✅ 产品/设计/开发三方在同一仓库对齐
- ✅ 历史可追溯：半年后看 changes/ 还能知道某段代码对应哪个 PRD
- ⚠️ 产品/设计师需要适应"东西要进仓库" —— GUIDE.md 单独写一节给非技术角色
- ⚠️ Figma/飞书链接可能失效 —— 建议关键设计稿用截图存进仓库做兜底

---

## 关联

- ADR-009（PM 输入 3+1 模板）
- ADR-010（两层分发）
- ADR-011（契约层）
