# ADR-010 — 约束/状态两层分发架构

- **状态**：Accepted
- **日期**：2026-05-21
- **决策人**：大Joe + Dr.EOJAD
- **关联 ADR**：ADR-001（task 主轴）/ ADR-002（上下文完备性）/ ADR-007（Progress 层）

---

## 背景

v1.4 把 harness 的所有内容（铁律 / 流程 / Progress / ADR / 模板）放在一个仓库，团队接入靠 `cp -rn` 一次性硬拷贝。这有两个根本问题：

1. **一次性拷贝后断开关系**：主仓库升级到 v1.5，下游项目永远停留在 v1.4
2. **不分层导致两难**：
   - 铁律改动很慢（月级），但希望严格 review → 适合走 PR
   - code-map / current 改动很快（每次 commit），走 PR 太繁琐 → 适合自动化

把这两类东西混在一起，结果就是"要么严格到没人用，要么松到没人遵守"。

会议讨论结论：**按变化频率 + 协同方式分两层，分别用不同机制管理。**

---

## 决策

### 分层定义

| 层 | 内容 | 变化频率 | 物理位置 | 同步方式 |
|---|---|---|---|---|
| **约束层** | 4-5 条铁律 / Session 流程 / ADR / 模板 / 共享脚本 | 月级 | `.harness/`（只读） | 主仓库 PR → 自动分发到下游 |
| **状态层** | current / code-map / lessons / changes / contracts / product | 每次 commit | 项目根目录（可写） | 项目自己 commit；code-map 在 merge 后自动刷新 |

### 物理结构

```
项目目录/
├── .harness/                    🔒 约束层（从主仓库同步，禁止本地改）
│   ├── AGENTS.base.md           4-5 条铁律 + 流程
│   ├── decisions/               主仓库 ADR 副本
│   ├── templates/               模板
│   ├── scripts/                 共享脚本（含 generate-code-map.sh）
│   └── VERSION                  当前 harness 版本号
│
├── AGENTS.md                    📝 项目入口（继承 .harness/AGENTS.base.md）
├── progress/                    📝 状态层
├── contracts/                   📝 状态层（见 ADR-011）
├── product/                     📝 状态层（见 ADR-012）
└── 业务代码/
```

### 约束层分发机制

1. 主仓库 `futurx-coding-harness` 用 git tag 发布版本（`v1.5`、`v1.6`...）
2. 主仓库提供 reusable workflow：`.github/workflows/sync-template.yml`
3. 下游项目在自己仓库加 10 行：

```yaml
# .github/workflows/harness-sync.yml
on:
  schedule: { cron: '0 9 * * 1' }   # 每周一 9 点
  workflow_dispatch:                  # 也能手动触发
jobs:
  sync:
    uses: joevise/futurx-coding-harness/.github/workflows/sync-template.yml@main
```

4. Action 干两件事：
   - 把 `futurx-coding-harness` 仓库内容拉到下游项目的 `.harness/`
   - 如果有 diff，自动开 PR；下游 owner 看一眼合并即可

5. **反向回流**：项目里有人觉得铁律不对 → 直接给主仓库提 PR → 大Joe 审核合并 → 下次定时分发

### 状态层更新机制

- **current.md / lessons.md / changes/*.md**：靠人 commit（铁律 2、3、4 已约束）
- **code-map.md**：merge 到 main 后 GitHub Action 自动刷新（详见 ADR-013）
- **contracts/**：靠人 commit（铁律 5 约束，详见 ADR-011）
- **product/**：靠产品/设计师 commit（详见 ADR-012）

---

## 强制级别

| 项 | 强制级别 |
|---|---|
| `.harness/` 目录禁止本地修改 | 硬约束（AGENTS.md 顶部声明） |
| 下游项目必须挂 sync workflow | 强烈推荐 |
| 主仓库必须打 tag 发版 | 硬约束 |

---

## 取舍

- ✅ 约束层升级一次，全公司项目受益
- ✅ 状态层快变内容不用走 PR，开发体验不打折
- ✅ 任何人 clone 项目立刻拿到完整上下文
- ⚠️ 增加 `.harness/` 这层抽象，新人需 5 分钟学会（GUIDE.md 已覆盖）
- ⚠️ 主仓库变成关键基础设施，发版需谨慎（用 tag + changelog 兜底）

---

## 关联

- ADR-011（contracts/ 契约层）
- ADR-012（product/ 产品上下文层）
- ADR-013（code-map 自动刷新）
