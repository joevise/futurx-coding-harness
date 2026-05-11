# AGENTS.md — FuturX Coding Harness v1.1

> 本文件是项目的**唯一真相源**。任何 AI 编码工具（Cursor / Claude Code / OpenCode / Codex / Copilot）启动时必须先读完本文件 + 启动协议中的所有上下文文件，再动手写代码。
>
> **本文件长度上限：150 行**（OpenAI 实测过的最优长度，超过会被忽略）。
>
> **当前版本：v1.1（2026-05-11）** — 新增 SDD（规格驱动开发）流程

---

## 🚨 强制启动协议（Context Completeness Protocol）

任何 AI Agent / 程序员启动 session 时，**必须按顺序读完以下所有文件**，并在动手前用一句话向用户确认"我现在理解的任务是 X，是否开始"。**未完成本协议的 commit 会被 PR 拒绝。**

### 必读清单（不可跳过）

1. **AGENTS.md**（项目地图 + 启动协议）
2. **README.md**（项目目标 + 技术栈 + 部署）
3. **`.ai/context.md`**（架构约束 / 风格 / 术语表 / 业务知识）
4. **`feature_list.json`**（全量功能清单 + 优先级 + 状态）
5. **`progress/current.md`**（当前 sprint 焦点 + 谁在做什么）
6. **`progress/tasks/<当前 task ID>/`** 整个目录（README + **spec.md** + **plan.md** + log + decisions）
7. **`decisions/` 下所有 ADR**（架构决策记录）
8. **最近 7 天的 `progress/daily/*.md`**

### 启动后必答 3 问
- **当前 task 的 Spec 是什么？验收标准是什么？**
- **项目的核心架构约束有哪些？哪些事不能做？**
- **最近 3 天有哪些已完成 / 进行中的工作？我接的是哪一段？**

回答不出 = 上下文未对齐 = **不允许写代码**。

---

## 🧭 SDD 工作流（v1.1 新增 ⭐）

**核心范式**：Spec → Plan → Test → Code（不是直接 AI 写代码）

| 阶段 | 产出文件 | Review 角色 | 必须完成 |
|---|---|---|---|
| 1. Spec（规格） | `progress/tasks/T-XXX/spec.md` | 产品 / Leader | 用户故事 + 验收标准 + 边界条件 |
| 2. Plan（计划） | `progress/tasks/T-XXX/plan.md` | 技术 Lead | 技术方案 + 任务拆解 + 风险点 |
| 3. Test（测试） | `tests/T-XXX/` | 工程师 | 测试用例对应 spec 的验收标准 |
| 4. Code（实现） | `src/...` | AI + 工程师 | 代码必须让 tests/T-XXX/ 全绿 |

**SDD 规则**：
- 任何新功能 task **必须有 spec.md**（修 bug / 小调整可豁免）
- spec.md 未 review = 不能写 plan.md
- plan.md 未 review = 不能写代码
- 没有对应测试的代码 = 不能 merge

可选工具：`uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`（GitHub Spec-Kit）

---

## 📁 目录结构

```
project/
├── AGENTS.md / CLAUDE.md→ / .cursorrules→ / CONVENTIONS.md→  # 同一份
├── README.md
├── feature_list.json
├── .ai/{context.md, tools-policy.md, model-routing.md}
├── progress/
│   ├── current.md
│   ├── tasks/T-XXX-name/{README, spec.md⭐, plan.md⭐, log, decisions, owner.txt}
│   ├── daily/YYYY-MM-DD-<name>.md
│   └── archive/
├── decisions/ADR-XXX-*.md
├── tests/T-XXX/                  # 按 task 组织测试
├── .github/{pull_request_template.md, workflows/ci.yml}
└── scripts/{sync-rules.sh, check-progress.sh}
```

---

## 🔁 Session SOP

**开头 3 件事**：
1. `pwd` + `git status` + 读 `progress/current.md`
2. 走完【强制启动协议】必读清单
3. 在 `progress/daily/今日-<我>.md` 写下"本次目标"

**结尾 3 件事**：
1. 跑测试（必须绿）
2. `git commit`（格式：`[T-XXX] <type>: <description>`）+ 更新 `feature_list.json`
3. 写 ADR（如有新决策）+ 更新 `progress/tasks/T-XXX/log.md` + daily

---

## 🛡 顶端 RULES（不可违反）

1. **上下文未读完 → 不写代码**
2. **新功能 → 先写 spec.md，再写 plan.md，再写测试，最后写代码**（SDD）
3. **架构 / 接口 / 选型决策 → 必须先写 ADR**
4. **每次提交 → 必须带测试**，CI 不绿不允许合并
5. **修改超 50 行 → 先列计划**
6. **session 结束 → 必须更新 progress/**
7. **commit message → 必须带 task ID**：`[T-XXX] feat/fix/...`
8. **不允许直接 copy-paste AI 输出 commit**

---

## 🧰 工具中立 & 测试栈

- **AI 工具**：自由选（Cursor/Claude Code/OpenCode/Codex/Copilot），都软链到 AGENTS.md
- **测试 3 层**：单元（pytest/vitest）+ 集成（Bruno + testcontainers）+ E2E（Playwright）
- **AI 评测**：Inspect AI / Promptfoo（涉及 LLM 输出的任务）
- 详见 `.ai/tools-policy.md` + `.ai/model-routing.md`

---

## 🔄 Harness 版本演进
- v1.0 (2026-05-11) — 首版（启动协议 + task 主轴 + 工具中立）
- **v1.1 (2026-05-11) — 新增 SDD 流程（spec.md + plan.md）+ 测试 3 层规范**
