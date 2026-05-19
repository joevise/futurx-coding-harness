# CHANGELOG — FuturX Coding Harness

所有重大版本变更记录在此。

仓库：https://git.futurx.cc/futurx/futurxlab/futurx_coding_harness

---

## v1.4 — 2026-05-19 ⭐

**主题：Progress 4 件套 + 轻量化 + Superpower 集成**

来源：2026-05-18 团队对齐会议（大Joe / 百村 / 乐琴 / 阿和 / 婷婷 / 子健）

### 🆕 新增

- **Progress 4 件套**（v1.4 核心创新）
  - `progress/current.md` — 项目当前状态，AI 第一个读（< 100 行）
  - `progress/code-map.md` — 代码地图（几百行内）
  - `progress/lessons.md` — 踩坑日志（业界推荐但其实错的方案）
  - `progress/changes/YYYY-MM-DD-T-XXX.md` — 每个 task 一份变更记录
- **3 份 ADR**
  - `ADR-007` — Progress 层
  - `ADR-008` — 轻量化 + Superpower 集成
  - `ADR-009` — 产品输入 3+1 模板
- **5 份模板**（`templates/`）
  - current / code-map / lessons / changes / pm-input

### ♻️ 重写

- **AGENTS.md**：从 10 条 RULES → **4 条铁律** + 推荐分级 + Superpower 工具箱清单
- **SKILL.md**：v1.4，5 大场景（接入 / 启动 / 提交 / 踩坑 / 新 task）
- **feature_list.json**：v1.3 → v1.4
- **README.md**：顶部加 v1.4 摘要

### 🎯 4 条铁律（取代 v1.3 的 10 条 RULES）

1. 每个 commit 必须带 task ID（`[T-XXX] feat/fix/...`）
2. 每个 task 完成必须写 `progress/changes/YYYY-MM-DD-T-XXX.md`
3. 新 session 必须读 `progress/current.md` + `lessons.md`
4. 踩到新坑必须更新 `lessons.md`

**其他全部降级为推荐**（SDD / 双重对齐 / new-task.sh / 测试覆盖率…）。

### 🧰 引入 Superpower 工具箱（opt-in）

引用式集成 11 个 skill，按场景自愿调用：

> brainstorming / writing-plans / requesting-code-review / using-git-worktrees / test-driven-development / systematic-debugging / **verification-before-completion ⭐** / receiving-code-review / subagent-driven-development / dispatching-parallel-agents / finishing-a-development-branch

### 📝 产品输入 3+1 模板

| 项 | 内容 |
|---|---|
| ① 核心用户故事 + 主流程 | 像亚马逊新闻稿写用户旅程 |
| ② 业务边界 | 什么不能做 |
| ③ 验收标准 | 可量化或可观察 |
| ④ 设计规范 | 抽象框架，不再用 word |

两类项目分开：新项目必须给 demo-grade HTML 原型；存量项目用 PRD + 增量描述。

### 设计原则

**只对齐边界，不替换方法。**

阿和原话：「我们只需要把这个框架弄好就行，自由度交给每个人。」

---

## v1.3 — 2026-05-18

- Skill 化升级：新增 SKILL.md 入口 + commands/ 目录
- 解除 AGENTS.md ≤ 150 行限制
- 斜杠命令规范：`/new-task` / `/sync-check` / `/start-session`

## v1.2 — 2026-05-11

- 多人协作双重对齐协议
- `scripts/new-task.sh` + `scripts/sync-check.sh`
- `collaborators.json`

## v1.1 — 2026-05-11

- 引入 SDD 流程（Spec → Plan → Test → Code）
- 测试 3 层（单元 / 集成 / E2E）
- CI 校验

## v1.0 — 2026-05-11

- 启动协议 + Task 主轴 + 工具中立
