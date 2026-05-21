# AGENTS.base.md — FuturX Coding Harness 约束层基础规范

> 此文件由主仓库 `futurx-coding-harness` 维护并自动同步到下游项目的 `.harness/AGENTS.base.md`。
> **不要在项目里直接改这个文件**。要改请去主仓库提 PR。
>
> 项目特定规范写在项目根目录的 `AGENTS.md`（继承本文件）。

---

## 🚨 团队 5 条铁律（不可违反）

1. **每个 commit 必须带 task ID**：`[T-XXX] feat/fix/docs/chore: <description>`
2. **每个 task 完成必须写** `progress/changes/YYYY-MM-DD-T-XXX.md`（**5 段**：改了什么 / 为什么改 / 思路 / 验收 / 关联 PRD/US/契约）
3. **新 session 必须读** `progress/current.md` + `progress/lessons.md` + `product/prd/<当前版本>.md`（如有）
4. **踩到新坑必须更新** `progress/lessons.md`
5. **修改任何 API / 事件 / 数据模型，必须先改 `contracts/` 对应文件，再写实现代码**

其他全部**推荐而非强制**。

---

## 📂 项目目录骨架

```
project/
├── .harness/                        🔒 约束层（只读，自动同步）
│   ├── AGENTS.base.md
│   ├── decisions/
│   ├── templates/
│   ├── scripts/
│   └── VERSION
│
├── AGENTS.md                        📝 项目入口（继承 .harness/AGENTS.base.md）
├── CLAUDE.md / .cursorrules         软链 → AGENTS.md
│
├── progress/                        📝 状态层 · 开发过程
│   ├── current.md                   当前状态（< 100 行）
│   ├── code-map.md                  代码地图（merge 后自动刷新）
│   ├── lessons.md                   踩坑日志
│   └── changes/                     每 task 一份 5 段
│
├── contracts/                       📝 状态层 · 跨角色契约（铁律 5）
│   ├── api/
│   ├── events/
│   └── data-models/
│
├── product/                         📝 状态层 · 产品/设计上下文
│   ├── prd/
│   ├── design/
│   └── user-stories/
│
├── decisions/                       项目自己的 ADR
└── 业务代码/
```

---

## 🔁 Session 标准流程

### 开始 session
```bash
pwd                                       # 确认目录
git status                                # 工作区干净
cat progress/current.md                   # 当前状态
cat progress/lessons.md                   # 避坑
ls product/prd/ 2>/dev/null               # 看最新 PRD
ls contracts/api/ 2>/dev/null             # 看接口契约
```
然后用一句话确认任务理解，等待用户批准。

### 结束 session
```bash
# 1. 跑测试（如果有）
# 2. 写 progress/changes/YYYY-MM-DD-T-XXX.md（5 段）
# 3. 更新 progress/current.md
# 4. 如有踩坑，更新 progress/lessons.md
# 5. 如改了契约，确认 contracts/ 已同步更新
git add -A
git commit -m "[T-XXX] feat: <description>"
```

---

## 🔧 工具中立性

| Agent 工具 | 读哪个文件 |
|---|---|
| Claude Code | `CLAUDE.md → AGENTS.md → .harness/AGENTS.base.md` |
| Cursor | `.cursorrules → AGENTS.md → ...` |
| OpenCode / OpenClaw / Codex | 直接读 `AGENTS.md`（再读 .harness/AGENTS.base.md） |
| Copilot | `.github/copilot-instructions.md → AGENTS.md → ...` |

---

## 🛡️ RULES 优先级

```
铁律（5 条）  >  强烈推荐  >  推荐  >  随意
```

冲突时按优先级处理。

---

## 📚 关联 ADR

- ADR-001 task 主轴
- ADR-002 上下文完备性
- ADR-007 Progress 4 件套
- ADR-008 轻量化 + Superpower
- ADR-009 PM 输入 3+1 模板
- ADR-010 两层分发架构
- ADR-011 Contracts 层
- ADR-012 Product 上下文层
- ADR-013 code-map 自动刷新
