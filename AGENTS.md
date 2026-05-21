# AGENTS.md — FuturX Coding Harness v1.6

> **轻量化版**。任何 AI 编码工具（Cursor / Claude Code / OpenCode / Codex / Copilot）启动时**先读这个文件 + .harness/AGENTS.base.md + progress/ 4 件套 + product/prd/ + contracts/**，再动手写代码。
>
> 当前版本：**v1.6（2026-05-21）** — + AI Onboarding Archaeology Skill
>
> 设计原则：**只对齐边界，不替换方法。**

---

## 🚨 团队 6 条铁律（不可违反）

1. **每个 commit 必须带 task ID**：`[T-XXX] feat/fix/docs/chore: <description>`
2. **每个 task 完成必须写** `progress/changes/YYYY-MM-DD-T-XXX.md`（**5 段**：改了什么 / 为什么改 / 思路 / 验收 / 关联 PRD/US/契约）
3. **新 session 必须读** `progress/current.md` + `progress/lessons.md` + `product/prd/<当前版本>.md`（如有）
4. **踩到新坑必须更新** `progress/lessons.md`
5. **修改任何 API / 事件 / 数据模型，必须先改 `contracts/` 对应文件，再写实现代码**
6. **项目第一次接入 harness 必须跑 `.harness/skills/onboarding-archaeology/` skill** ⭐ v1.6 新增

其他全部**推荐而非强制**。

---

## 🔍 AI Onboarding Archaeology（v1.6 新增核心能力）

第一次接手一个项目时，AI 会自动识别并询问是否启动考古。产出 7 份文件：

1. `progress/current.md` — 当前状态
2. `progress/code-map.md` — 详细代码地图
3. `progress/lessons_inferred.md` — 推测的坑（待复核）
4. `progress/onboarding-report.md` ⭐ — 新人 30 分钟入门
5. `contracts/api/_inferred.md` — 反向 API 清单（待复核）
6. `product/inferred-features.md` — 推测功能清单
7. `progress/onboard-uncertainty.md` ⭐ — AI 不确定的事（追问清单）

**任何 AI agent**（Claude Code / Cursor / OpenCode / Codex / Copilot）都会自动识别场景调用，用户无需打命令。

三段诚实标记：✅ 代码证据 / ⚠️ 推测但合理 / ❓ 不确定（→uncertainty.md）
`_inferred` 后缀机制：所有 AI 推测显式标记，人工复核后由人改名"晋升"为正式 SSOT。

Skill 位置：`.harness/skills/onboarding-archaeology/`
详见 `decisions/ADR-014-ai-onboard-archaeology.md`。

---

## 🏛️ v1.5 架构：两层分发

```
约束层（.harness/，只读，自动同步）
  ├─ AGENTS.base.md     6 条铁律 + Session 流程
  ├─ skills/            shared skills（如 onboarding-archaeology）⭐ v1.6
  ├─ decisions/         ADR 副本
  ├─ templates/         模板
  └─ scripts/           共享脚本

状态层（项目自己维护）
  ├─ progress/          开发过程（current / code-map / lessons / changes）
  ├─ contracts/         跨角色契约（API / 事件 / 数据模型）
  └─ product/           产品/设计上下文（prd / design / user-stories）
```

约束层走"主仓库 PR → GitHub Action 分发"；状态层项目自己 commit；其中 `code-map.md` 在 PR merge 后由 Action 自动刷新。

详见：
- `decisions/ADR-010-two-layer-distribution.md`
- `decisions/ADR-011-contracts-layer.md`
- `decisions/ADR-012-product-context-layer.md`
- `decisions/ADR-013-code-map-auto-refresh.md`
- `decisions/ADR-014-ai-onboard-archaeology.md` ⭐

---

## 📂 Progress 4 件套（v1.4 起）

```
progress/
├── current.md            ← 当前状态，AI 第一个读（< 100 行）
├── code-map.md           ← 代码地图（merge 后自动刷新；HUMAN 段保留人工标注）
├── lessons.md            ← 踩坑日志
└── changes/              ← 每个 task 一份 5 段
```

---

## 📑 Contracts 层（v1.5 新增）

```
contracts/
├── api/             REST/GraphQL/RPC 接口
├── events/          消息/事件 schema
└── data-models/     跨服务/跨端共享数据结构
```

**铁律 5**：改实现前必须先改 contracts。
详见 `decisions/ADR-011-contracts-layer.md`。

---

## 🎨 Product 层（v1.5 新增）

```
product/
├── prd/             产品需求文档
├── design/          figma-links.md + prototypes/
└── user-stories/    核心用户故事（US-XXX）
```

AI 改代码前应该读这里搞清楚"为啥做、给谁用"。
详见 `decisions/ADR-012-product-context-layer.md`。

---

## 🧰 Superpower Skill 工具箱（可选）

| 场景 | 推荐 skill |
|---|---|
| 陌生项目接手 | **`.harness/skills/onboarding-archaeology`** ⭐ v1.6 |
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

---

## 📝 产品输入规范

3 项核心 + 1 项规范，写进 `product/prd/<version>.md`：

| 项 | 内容 |
|---|---|
| ① 核心用户故事 + 主流程 | 像亚马逊新闻稿写用户旅程 |
| ② 业务边界 | 什么**不能**做 |
| ③ 验收标准 | 可量化或可观察 |
| ④ 设计规范 | 抽象框架 |

新项目 → 必须给 demo-grade HTML 原型（放 `product/design/prototypes/`）

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

### 第一次接手陌生项目
直接和你的 AI 工具说一句："这项目我没接触过，帮我考古一下"。
AI 会自动调用 `.harness/skills/onboarding-archaeology/`。

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
│   ├── scripts/
│   └── skills/onboarding-archaeology/   ⭐ v1.6
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
├── contracts/                      状态层 · 跨角色契约
├── product/                        状态层 · 产品/设计上下文
│
├── decisions/                      项目自己的 ADR
└── 业务代码/
```

---

## 🚀 接入新项目（一行命令）

```bash
cd /path/to/your-project
bash /path/to/futurx-coding-harness/scripts/install-into.sh
```

完成后用你的 AI 工具打开项目，它会自动询问是否考古（陌生项目场景）。

---

## 🔄 自动同步

每个项目根目录的 `.github/workflows/`：
- `harness-sync.yml` — 每周一从主仓库自动拉 `.harness/` 最新版本，开 PR
- `auto-update-code-map.yml` — main 分支收到 push 后自动刷新 `progress/code-map.md`

---

## 🛡️ RULES 优先级

```
铁律（6 条）  >  强烈推荐  >  推荐  >  随意
```

---

## 🔄 版本历史

- **v1.0** — 启动协议 + task 主轴 + 工具中立
- **v1.1** — SDD 流程 + 测试 3 层 + CI 校验
- **v1.2** — 多人协作双重对齐
- **v1.3** — Skill 化入口
- **v1.4** — Progress 4 件套 + 轻量化（10 → 4 铁律）+ Superpower 集成 + 3+1 PM 模板
- **v1.5** — 两层分发架构 + Contracts 层 + Product 层 + code-map 自动刷新（铁律 4→5）
- **v1.6** — **AI Onboarding Archaeology Skill，陌生项目自动考古（铁律 5→6）**（2026-05-21）
  - 架构原则：Skill 而非脚本，任何 AI agent 开箱可用，用户零命令成本

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
- ADR-010 — 两层分发架构 ⭐ v1.5
- ADR-011 — Contracts 层 ⭐ v1.5
- ADR-012 — Product 上下文层 ⭐ v1.5
- ADR-013 — code-map 自动刷新 ⭐ v1.5
- **ADR-014 — AI Onboarding Archaeology** ⭐ v1.6
