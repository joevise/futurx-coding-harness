# AGENTS.md — FuturX Coding Harness v1.5

> **轻量化版**。任何 AI 编码工具（Cursor / Claude Code / OpenCode / Codex / Copilot）启动时**先读这个文件 + .harness/AGENTS.base.md + progress/ 4 件套 + product/prd/ + contracts/**，再动手写代码。
>
> 当前版本：**v1.5（2026-05-21）** — 两层分发 + Contracts + Product + code-map 自动刷新
>
> 设计原则：**只对齐边界，不替换方法。**

---

## 🚨 团队 5 条铁律（不可违反）

1. **每个 commit 必须带 task ID**：`[T-XXX] feat/fix/docs/chore: <description>`
2. **每个 task 完成必须写** `progress/changes/YYYY-MM-DD-T-XXX.md`（**5 段**：改了什么 / 为什么改 / 思路 / 验收 / 关联 PRD/US/契约）
3. **新 session 必须读** `progress/current.md` + `progress/lessons.md` + `product/prd/<当前版本>.md`（如有）
4. **踩到新坑必须更新** `progress/lessons.md`
5. **修改任何 API / 事件 / 数据模型，必须先改 `contracts/` 对应文件，再写实现代码** ⭐ v1.5 新增

其他全部**推荐而非强制**。

---

## 🏛️ v1.5 架构：两层分发

```
约束层（.harness/，只读，自动同步）
  ├─ AGENTS.base.md     5 条铁律 + Session 流程
  ├─ decisions/         ADR 副本
  ├─ templates/         模板
  └─ scripts/           共享脚本

状态层（项目自己维护）
  ├─ progress/          开发过程（current / code-map / lessons / changes）
  ├─ contracts/         跨角色契约（API / 事件 / 数据模型）⭐ 新增
  └─ product/           产品/设计上下文（prd / design / user-stories）⭐ 新增
```

约束层走"主仓库 PR → GitHub Action 分发"；状态层项目自己 commit；其中 `code-map.md` 在 PR merge 后由 Action 自动刷新。

详见：
- `decisions/ADR-010-two-layer-distribution.md`
- `decisions/ADR-011-contracts-layer.md`
- `decisions/ADR-012-product-context-layer.md`
- `decisions/ADR-013-code-map-auto-refresh.md`

---

## 📂 Progress 4 件套（v1.4 起）

```
progress/
├── current.md            ← 当前状态，AI 第一个读（< 100 行）
├── code-map.md           ← 代码地图（merge 后自动刷新；HUMAN 段保留人工标注）
├── lessons.md            ← 踩坑日志
└── changes/              ← 每个 task 一份 5 段
```

| 文件 | 长度 | 更新频次 | 谁维护 |
|---|---|---|---|
| current.md | < 100 行 | 每次 commit | 开发者 |
| code-map.md | < 500 行 | merge 后自动 | 🤖 机器 + 人工标注段 |
| lessons.md | 不限 | 踩坑时 | 开发者 |
| changes/*.md | 每 task 一份 | task 完成 | 开发者 |

---

## 📑 Contracts 层（v1.5 新增）

```
contracts/
├── api/             REST/GraphQL/RPC 接口（OpenAPI 或 markdown）
├── events/          消息/事件 schema
└── data-models/     跨服务/跨端共享数据结构
```

**铁律 5**：改实现前必须先改 contracts。
review 时优先看 contract diff。
详见 `decisions/ADR-011-contracts-layer.md`。

---

## 🎨 Product 层（v1.5 新增）

```
product/
├── prd/             产品需求文档（用 templates/pm-input-template.md 3+1 模板）
├── design/          figma-links.md + prototypes/
└── user-stories/    核心用户故事（US-XXX）
```

AI 改代码前应该读这里搞清楚"为啥做、给谁用"。
changes/*.md 第 5 段（关联）必须引用对应 PRD / US / 设计稿。
详见 `decisions/ADR-012-product-context-layer.md`。

---

## 🧰 Superpower Skill 工具箱（可选）

| 场景 | 推荐 skill |
|---|---|
| 需求模糊 | `brainstorming` |
| 复杂开发前 | `writing-plans` |
| PR 提交前自检 | `requesting-code-review` |
| 多分支并行 | `using-git-worktrees` |
| 关键业务逻辑 | `test-driven-development` |
| 遇到 bug | `systematic-debugging` |
| 声称完成前 | `verification-before-completion` ⭐强烈推荐 |
| 收到 review | `receiving-code-review` |
| 大任务拆分 | `subagent-driven-development` |
| 并行任务 | `dispatching-parallel-agents` |
| 分支收尾 | `finishing-a-development-branch` |

详见 `decisions/ADR-008-lightweight-and-superpower.md`。

---

## 📝 产品输入规范（婷婷 / 子健必读）

3 项核心 + 1 项规范，写进 `product/prd/<version>.md`：

| 项 | 内容 |
|---|---|
| ① 核心用户故事 + 主流程 | 像亚马逊新闻稿写用户旅程 |
| ② 业务边界 | 什么**不能**做 |
| ③ 验收标准 | 可量化或可观察 |
| ④ 设计规范 | 抽象框架，不再用 word |

新项目 → 必须给 demo-grade HTML 原型（放 `product/design/prototypes/`）
存量项目 → PRD + 增量描述（V1.1 / V1.2 叠加）

模板：`templates/pm-input-template.md`
详见 `decisions/ADR-009-pm-input-template.md`。

---

## 🔧 工具中立性

| Agent 工具 | 读哪个文件 |
|---|---|
| Claude Code | `CLAUDE.md → AGENTS.md → .harness/AGENTS.base.md` |
| Cursor | `.cursorrules → AGENTS.md → ...` |
| OpenCode / OpenClaw / Codex | 直接读 `AGENTS.md` |
| Copilot | `.github/copilot-instructions.md → AGENTS.md → ...` |

---

## 🔁 Session 标准流程

### 开始 session
```bash
pwd
git status
cat progress/current.md
cat progress/lessons.md
ls product/prd/ 2>/dev/null && cat product/prd/$(ls -t product/prd/ | head -1)
ls contracts/api/ 2>/dev/null
```
然后用一句话确认任务理解，等待用户批准。

### 结束 session
```bash
# 1. 跑测试
# 2. 写 progress/changes/YYYY-MM-DD-T-XXX.md（5 段）
# 3. 更新 progress/current.md
# 4. 如有踩坑，更新 progress/lessons.md
# 5. 如改了契约，确认 contracts/ 已同步
git add -A
git commit -m "[T-XXX] feat: <description>"
```

---

## 📁 项目目录骨架

```
project/
├── .harness/                       🔒 团队约束层（只读，自动同步）
│   ├── AGENTS.base.md
│   ├── VERSION
│   ├── decisions/
│   ├── templates/
│   └── scripts/
│
├── AGENTS.md                       项目入口（继承 .harness/AGENTS.base.md）
├── CLAUDE.md / .cursorrules / CONVENTIONS.md   软链 → AGENTS.md
├── SKILL.md                        agent 入口
│
├── progress/                       状态层 · 开发过程
│   ├── current.md
│   ├── code-map.md
│   ├── lessons.md
│   └── changes/
│
├── contracts/                      状态层 · 跨角色契约 ⭐
├── product/                        状态层 · 产品/设计上下文 ⭐
│
├── decisions/                      项目自己的 ADR
└── 业务代码/
```

---

## 🚀 接入新项目（一行命令）

```bash
# 在你的项目根目录跑：
bash /path/to/futurx-coding-harness/scripts/install-into.sh
```

完成后：
1. 编辑 `AGENTS.md` 顶部项目名
2. 编辑 `progress/current.md` 写当前状态
3. `git add -A && git commit -m '[T-000] chore: 接入 harness v1.5'`

---

## 🔄 自动同步

每个项目根目录的 `.github/workflows/`：
- `harness-sync.yml` — 每周一从主仓库自动拉 `.harness/` 最新版本，开 PR
- `auto-update-code-map.yml` — main 分支收到 push 后自动刷新 `progress/code-map.md`

---

## 🛡️ RULES 优先级

```
铁律（5 条）  >  强烈推荐  >  推荐  >  随意
```

---

## 🔄 版本历史

- **v1.0** — 启动协议 + task 主轴 + 工具中立
- **v1.1** — SDD 流程 + 测试 3 层 + CI 校验
- **v1.2** — 多人协作双重对齐 + new-task.sh + sync-check.sh
- **v1.3** — Skill 化入口 + 解除行数限制 + 斜杠命令规范
- **v1.4** — Progress 4 件套 + 轻量化（10 → 4 铁律）+ Superpower 集成 + 3+1 PM 模板
- **v1.5** — **两层分发架构 + Contracts 层 + Product 层 + code-map 自动刷新（铁律 4→5）**（2026-05-21）
  - 来源：2026-05-21 大Joe + Dr.EOJAD 设计会议
  - 核心：解决多角色 vibe coding 的"上下文对齐"命门

---

## 📚 关键 ADR 速查

- ADR-001 — Task 主轴
- ADR-002 — 上下文完备性
- ADR-003 — SDD（v1.4 降级为推荐）
- ADR-004 — SDD + TDD
- ADR-005 — 测试栈
- ADR-006 — 协作对齐（v1.4 降级为推荐）
- ADR-007 — Progress 4 件套 ⭐ v1.4
- ADR-008 — 轻量化 + Superpower ⭐ v1.4
- ADR-009 — PM 输入 3+1 模板 ⭐ v1.4
- **ADR-010 — 两层分发架构** ⭐ v1.5
- **ADR-011 — Contracts 层** ⭐ v1.5
- **ADR-012 — Product 上下文层** ⭐ v1.5
- **ADR-013 — code-map 自动刷新** ⭐ v1.5
