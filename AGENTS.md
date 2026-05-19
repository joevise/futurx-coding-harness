# AGENTS.md — FuturX Coding Harness v1.4

> **轻量化版**。任何 AI 编码工具（Cursor / Claude Code / OpenCode / Codex / Copilot）启动时**先读这个文件 + progress/ 4 件套**，再动手写代码。
>
> 当前版本：**v1.4（2026-05-19）** — Progress 层 + 轻量化 + Superpower 集成
>
> 设计原则：**只对齐边界，不替换方法。**

---

## 🚨 团队 4 条铁律（不可违反）

1. **每个 commit 必须带 task ID**：`[T-XXX] feat/fix/docs/chore: <description>`
2. **每个 task 完成必须写** `progress/changes/YYYY-MM-DD-T-XXX.md`（4 段）
3. **新 session 必须读** `progress/current.md` + `progress/lessons.md`（不到 200 行）
4. **踩到新坑必须更新** `progress/lessons.md`

其他全部**推荐而非强制**。

---

## 📂 Progress 4 件套（v1.4 核心创新）

每个项目仓库必须有 `progress/` 目录，包含：

```
progress/
├── current.md            ← 当前状态，AI 第一个读（< 100 行）
├── code-map.md           ← 代码地图（几百行内）
├── lessons.md            ← 踩坑日志（业界推荐但其实错的方案）
└── changes/              ← 每个 task 一份变更记录
    ├── 2026-05-19-T-001.md
    ├── 2026-05-19-T-002.md
    └── ...
```

### 各文件的硬约束

| 文件 | 长度 | 更新频次 | 谁读 |
|---|---|---|---|
| current.md | < 100 行 | 每次 commit | AI / 子健 / 全员 |
| code-map.md | < 500 行 | 大改动时 | AI 定位代码 |
| lessons.md | 不限 | 踩坑时立即更新 | AI 避坑 / 新人 |
| changes/*.md | 每个 task 一份 | task 完成时 | 审计 / 追溯 |

详见 `decisions/ADR-007-progress-tracking-layer.md`。

---

## 🧰 Superpower Skill 工具箱（可选）

推荐使用 superpower skill 包作为开发底座，**自愿而非强制**：

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

产品输入统一为 **3 项核心 + 1 项规范**：

| 项 | 内容 |
|---|---|
| ① 核心用户故事 + 主流程 | 像亚马逊新闻稿写用户旅程 |
| ② 业务边界 | 什么**不能**做 |
| ③ 验收标准 | 可量化或可观察 |
| ④ 设计规范 | 抽象框架，不再用 word |

**两类项目分开**：
- 新项目 → 必须给 demo-grade HTML 原型（业务体验对，UI 丑没关系）
- 存量项目 → PRD + 增量描述（V1.1 / V1.2 叠加）

模板：`templates/pm-input-template.md`
详见 `decisions/ADR-009-pm-input-template.md`。

---

## 🔧 工具中立性

| Agent 工具 | 读哪个文件 |
|---|---|
| Claude Code | `CLAUDE.md → AGENTS.md` |
| Cursor | `.cursorrules → AGENTS.md` |
| OpenCode / OpenClaw / Codex | 直接读 `AGENTS.md` |
| Copilot | `.github/copilot-instructions.md → AGENTS.md` |

**这一份 AGENTS.md 是单源**，软链到各工具对应文件名。每个人用自己习惯的工具，不强制改变。

---

## 🧭 SDD（推荐而非强制）

会议结论：百村等老炮反对 SDD 强制流程（spec-kit 在 tricky 项目里污染上下文）。**v1.4 改为推荐**：

- 个人 spec 随意，放本地，**不上仓库**
- 团队对齐的是 commit 上来的代码质量
- 推荐 superpower 的 `writing-plans` skill 写实施计划

详见 `decisions/ADR-008-lightweight-and-superpower.md`。

---

## 🔁 Session 标准流程

### 开始 session
```bash
pwd                         # 确认目录
git status                  # 确认工作区干净
cat progress/current.md     # 读当前状态
cat progress/lessons.md     # 读避坑
```
然后用一句话确认任务理解，等待用户批准。

### 结束 session
```bash
# 1. 跑测试（如果有）
# 2. 写 progress/changes/YYYY-MM-DD-T-XXX.md
# 3. 更新 progress/current.md
# 4. 如有踩坑，更新 progress/lessons.md
git add -A
git commit -m "[T-XXX] feat: <description>"
```

---

## 📁 目录结构（参考）

```
project/
├── AGENTS.md / CLAUDE.md→ / .cursorrules→
├── SKILL.md                          ← agent 入口
├── README.md
├── progress/                         ← ⭐ 4 件套
│   ├── current.md
│   ├── code-map.md
│   ├── lessons.md
│   └── changes/YYYY-MM-DD-T-XXX.md
├── decisions/                        ← ADR
├── product/                          ← 产品 PRD（婷婷/子健）
├── spec/                             ← 个人 spec（gitignored 或不强制共享）
├── templates/                        ← 模板
├── commands/                         ← 斜杠命令规范
├── scripts/                          ← 辅助脚本（按需）
└── tests/                            ← 测试
```

---

## 🛡️ 顶端 RULES 优先级

```
铁律（4 条）  >  强烈推荐  >  推荐  >  随意
```

任何 agent 行为冲突时，按上述优先级处理。

---

## 🔄 版本历史

- **v1.0** — 启动协议 + task 主轴 + 工具中立
- **v1.1** — SDD 流程 + 测试 3 层 + CI 校验
- **v1.2** — 多人协作双重对齐 + new-task.sh + sync-check.sh + collaborators.json
- **v1.3** — Skill 化入口 + 解除 AGENTS.md 行数限制 + 斜杠命令规范
- **v1.4** — **Progress 4 件套 + 轻量化 + Superpower 集成 + 3+1 PM 模板**（2026-05-19）
  - 来源：2026-05-18 团队对齐会议
  - 核心：从"重型框架"转向"轻量边界 + 工具箱"

---

## 📚 关键 ADR 速查

- [ADR-001](decisions/ADR-001-task-as-main-axis.md) — Task 主轴
- [ADR-002](decisions/ADR-002-context-completeness.md) — 上下文完备性
- [ADR-003](decisions/ADR-003-spec-driven-development.md) — SDD（v1.4 降级为推荐）
- [ADR-004](decisions/ADR-004-sdd-plus-tdd.md) — SDD + TDD
- [ADR-005](decisions/ADR-005-testing-stack.md) — 测试栈
- [ADR-006](decisions/ADR-006-collaboration-alignment.md) — 协作对齐（v1.4 降级为推荐）
- **[ADR-007](decisions/ADR-007-progress-tracking-layer.md) — Progress 4 件套** ⭐ v1.4
- **[ADR-008](decisions/ADR-008-lightweight-and-superpower.md) — 轻量化 + Superpower** ⭐ v1.4
- **[ADR-009](decisions/ADR-009-pm-input-template.md) — 产品输入 3+1 模板** ⭐ v1.4
