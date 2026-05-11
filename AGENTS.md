# AGENTS.md — FuturX Coding Harness v1.2

> 本文件是项目的**唯一真相源**。任何 AI 编码工具（Cursor / Claude Code / OpenCode / Codex / Copilot）启动时必须先读完本文件 + 启动协议中的所有上下文文件，再动手写代码。
>
> **当前版本：v1.2（2026-05-11）** — 新增多人协作双重对齐协议

---

## 🚨 强制启动协议（Context Completeness Protocol）

任何 AI Agent / 程序员启动 session **必须按顺序读完以下文件**，并用一句话向用户确认任务理解。**未完成 = commit 被 PR 拒绝。**

### 必读清单
1. **AGENTS.md**（本文件）
2. **README.md** + **`.ai/context.md`**（架构 / 风格 / 术语）
3. **`feature_list.json`**（全量功能清单）
4. **`progress/current.md`**（当前 sprint）
5. **`progress/tasks/<当前 task>/`** 整个目录（含 spec/plan/log/decisions/collaborators）
6. **`decisions/` 全部 ADR**
7. **最近 7 天的 `progress/daily/*.md`**

### 必答 3 问
- 当前 task 的 Spec 是什么？验收标准？
- 项目的核心架构约束有哪些？
- 最近 3 天哪些工作？我接的是哪一段？

---

## 🤝 协作对齐协议（v1.2 新增 ⭐⭐）

**多人开发同一系统时，所有新 task 必须用 `bash scripts/new-task.sh` 创建，不允许手动建目录。**

工具会强制走【双重对齐】：

### 第 1 重：是不是同一个任务？
工具自动扫描所有进行中的 task，找相似的强制用户决定：
- **是已有 task 的一部分** → 加入协作（成为子任务 T-XXX.Y）
- **是独立新 task** → 分配新 ID

### 第 2 重：加入已有 task 必须走 3 步
- ✅ **Step 1 阅读对齐**：读完 owner 的 spec / plan / log / decisions
- ✅ **Step 2 联系 owner**：达成分工共识（飞书/当面）
- ✅ **Step 3 声明范围**：填写自己负责的具体范围

三步全打钩才创建子任务目录。

### Session 启动自检
每次 session 启动建议跑 `bash scripts/sync-check.sh`，自动检查你参与的协作 task 最近 48h 动态。

---

## 🧭 SDD 工作流

**核心范式**：Spec → Plan → Test → Code

| 阶段 | 产出文件 | Review | 必须完成 |
|---|---|---|---|
| 1. Spec | `progress/tasks/T-XXX/spec.md` | 产品 / Leader | 用户故事 + 验收标准 |
| 2. Plan | `progress/tasks/T-XXX/plan.md` | 技术 Lead | 技术方案 + 拆解 + 风险 |
| 3. Test | `tests/T-XXX/` | 工程师 | 一一对应 spec 验收标准 |
| 4. Code | `src/...` | AI + 工程师 | 让 tests/T-XXX/ 全绿 |

**规则**：spec 未 review → 不能写 plan；plan 未 review → 不能写代码；无对应测试 → 不能 merge。

可选工具：[GitHub Spec-Kit](https://github.com/github/spec-kit)

---

## 📁 目录结构

```
project/
├── AGENTS.md / CLAUDE.md→ / .cursorrules→ / CONVENTIONS.md→
├── README.md / feature_list.json
├── .ai/{context.md, tools-policy.md, model-routing.md}
├── progress/
│   ├── current.md
│   ├── tasks/T-XXX-name/
│   │   ├── {README, spec, plan, log, decisions}.md
│   │   ├── collaborators.json  ⭐ v1.2
│   │   ├── owner.txt           # 兼容保留
│   │   └── subtasks/T-XXX.Y-*/ ⭐ v1.2（子任务）
│   ├── daily/YYYY-MM-DD-<name>.md
│   └── archive/
├── decisions/ADR-XXX-*.md
├── tests/T-XXX/
├── .github/{pull_request_template.md, workflows/ci.yml}
└── scripts/
    ├── sync-rules.sh
    ├── check-progress.sh
    ├── new-task.sh        ⭐ v1.2
    └── sync-check.sh      ⭐ v1.2
```

---

## 🔁 Session SOP

**开头**：`pwd` + `git status` + `bash scripts/sync-check.sh` + 走启动协议 + 写 daily
**结尾**：跑测试 + commit（`[T-XXX] <type>: ...`）+ 更新 feature_list / log / daily

---

## 🛡 顶端 RULES（不可违反）

1. 上下文未读完 → 不写代码
2. **新 task 必须用 `bash scripts/new-task.sh`** → 不允许手动建目录
3. **加入他人 task 必须走完双重对齐** → 不允许跳过
4. 新功能：先 spec → 再 plan → 再测试 → 最后代码（SDD）
5. 架构 / 接口 / 选型决策 → 必须先写 ADR
6. 每次提交带测试，CI 不绿不合并
7. 修改超 50 行先列计划
8. session 结束必须更新 progress/
9. commit message：`[T-XXX] feat/fix/...`
10. 不允许直接 copy-paste AI 输出 commit

---

## 🧰 工具中立 & 测试栈

- **AI 工具**：自由选（都软链到 AGENTS.md），详见 `.ai/tools-policy.md`
- **测试 3 层**：单元（pytest/vitest）+ 集成（Bruno）+ E2E（Playwright）
- **AI 评测**：Inspect AI / Promptfoo

---

## 🔄 版本历史
- v1.0 — 启动协议 + task 主轴 + 工具中立
- v1.1 — SDD 流程 + 测试 3 层 + CI 校验
- **v1.2 — 多人协作双重对齐 + new-task.sh + sync-check.sh + collaborators.json**
