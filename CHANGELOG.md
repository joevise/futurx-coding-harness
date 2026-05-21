# CHANGELOG — FuturX Coding Harness

所有重大版本变更记录在此。

仓库：https://git.futurx.cc/futurx/futurxlab/futurx_coding_harness

---

## v1.5 — 2026-05-21 ⭐

**主题：两层分发 + Contracts + Product + code-map 自动刷新**

来源：2026-05-21 大Joe × Dr.EOJAD 设计会议。
核心动机：解决多角色 vibe coding 的「上下文对齐」命门。

### 🆕 新增

- **两层架构**
  - `.harness/` 约束层（只读，自动同步）：AGENTS.base.md / decisions / templates / scripts / VERSION
  - 项目状态层：progress / contracts / product（项目自管理）
- **Contracts 层**：`contracts/{api,events,data-models}/` 跨角色契约 SSOT
- **Product 层**：`product/{prd,design,user-stories}/` 产品/设计上下文
- **铁律 5**：修改 API/事件/数据模型必须先改 contracts/
- **changes 模板升级**：4 段 → 5 段（新增「关联 PRD/US/契约」段）
- **GitHub Actions**
  - `harness-sync.yml` — 每周一从主仓库自动同步 `.harness/` + 开 PR
  - `auto-update-code-map.yml` — main push 后自动刷新 code-map（保留 HUMAN 段）
- **共享脚本**
  - `generate-code-map.sh` — 扫描代码生成 code-map 机器段
  - `merge-code-map.sh` — 合并新旧 code-map，保留 HUMAN 标注
  - `install-into.sh` — 一键接入新项目
- **新模板**：AGENTS.project / api-contract / event-contract / data-model / user-story
- **4 份 ADR**：ADR-010 / ADR-011 / ADR-012 / ADR-013

### ♻️ 升级

- AGENTS.md 4 条铁律 → 5 条铁律
- AGENTS.md 新增「两层分发」「Contracts 层」「Product 层」「自动同步」「一键接入」章节
- README.md 更新到 v1.5 主题

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
