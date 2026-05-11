# AGENTS.md — FuturX Coding Harness v1.0

> 本文件是项目的**唯一真相源**。任何 AI 编码工具（Cursor / Claude Code / OpenCode / Codex / Copilot）启动时必须先读完本文件 + 启动协议中的所有上下文文件，再动手写代码。
>
> **本文件长度上限：150 行**（OpenAI 实测过的最优长度，超过会被忽略）。

---

## 🚨 强制启动协议（Context Completeness Protocol）

任何 AI Agent / 程序员启动 session 时，**必须按顺序读完以下所有文件**，并在动手前用一句话向用户确认"我现在理解的任务是 X，是否开始"。**未完成本协议的 commit 会被 PR 拒绝。**

### 必读清单（不可跳过）

1. **本文件 AGENTS.md**（项目地图 + 启动协议）
2. **README.md**（项目目标 + 技术栈 + 部署）
3. **`.ai/context.md`**（架构约束 / 风格 / 术语表 / 业务知识）
4. **`feature_list.json`**（全量功能清单 + 优先级 + 状态）
5. **`progress/current.md`**（当前 sprint 焦点 + 谁在做什么）
6. **`progress/tasks/<当前 task ID>/`** 整个目录（任务描述 + 工作日志 + 决策）
7. **`decisions/` 下所有 ADR**（架构决策记录，决定了"为什么这么设计"）
8. **最近 7 天的 `progress/daily/*.md`**（其他人/Agent 最近做了什么）

### 启动后必答 3 问

读完上述文件后，必须能用一段话回答：

- **当前 task 是什么？验收标准是什么？**
- **这个项目的核心架构约束有哪些？哪些事不能做？**
- **最近 3 天有哪些已完成 / 进行中的工作？我接的是哪一段？**

回答不出 = 上下文未对齐 = **不允许写代码**。

---

## 📁 目录结构（强制）

```
project/
├── AGENTS.md                  # 本文件，项目唯一真相源
├── README.md                  # 项目总览
├── feature_list.json          # 功能清单（JSON 抗篡改）
├── .ai/
│   ├── context.md             # 长期上下文（架构/风格/术语）
│   ├── tools-policy.md        # 各 AI 工具用法约定
│   └── model-routing.md       # 模型选择策略
├── progress/                  # 进度（task 为主轴）
│   ├── current.md             # 全局当前状态（1屏看完）
│   ├── tasks/                 # ⭐ 主轴：按任务组织
│   │   └── T-XXX-name/
│   │       ├── README.md      # 任务描述 + 验收标准
│   │       ├── log.md         # 时间倒序工作日志
│   │       ├── decisions.md   # 任务相关决策
│   │       └── owner.txt      # 当前负责人
│   ├── daily/                 # 辅轴：按日期 + 人
│   │   └── YYYY-MM-DD-<name>.md
│   └── archive/               # 已完成任务归档
├── decisions/
│   └── ADR-XXX-title.md       # 架构决策记录
├── tests/                     # 端到端测试（Puppeteer/Playwright/pytest）
├── .github/
│   ├── pull_request_template.md
│   └── copilot-instructions.md → ../AGENTS.md
├── CLAUDE.md → AGENTS.md
├── .cursorrules → AGENTS.md
└── scripts/
    └── sync-rules.sh          # 同步所有 AI 工具的 rules 软链
```

---

## 🔁 Session SOP

### 开头 3 件事
1. `pwd` + `git status` + 读 `progress/current.md`
2. 走完上面【强制启动协议】的必读清单
3. 在 `progress/daily/今日-<我的名字>.md` 写下"本次目标"

### 结尾 3 件事
1. 跑测试（必须绿）
2. `git commit`（消息格式：`[T-XXX] <type>: <description>`）+ 更新 `feature_list.json` 状态
3. 写 ADR（如果有新决策）+ 更新 `progress/tasks/T-XXX/log.md` + `progress/daily/今日-<我的名字>.md`

---

## 🛡 顶端 RULES（不可违反）

1. **上下文未读完 → 不写代码**。任何 session 必须走完启动协议。
2. **架构/接口/选型决策 → 必须先写 ADR**，人类 review 通过才能实现。
3. **每次提交 → 必须带测试**，CI 不绿不允许合并。
4. **修改超 50 行 → 先列计划**，人类批准后再写。
5. **session 结束 → 必须更新 progress/**，没更新 = 工作未完成。
6. **commit message → 必须带 task ID**：`[T-XXX] feat/fix/docs: ...`
7. **不允许直接 copy-paste AI 输出 commit**，至少自检一遍 + 跑测试。

---

## 🧰 工具中立原则

用什么工具自己选（Cursor / Claude Code / OpenCode / Codex / Copilot），但：
- ✅ 所有工具都吃 `AGENTS.md`（通过软链 `CLAUDE.md`/`.cursorrules`/...）
- ✅ 所有工具都吐同样格式的 commit / PR / ADR
- ✅ 模型选择参考 `.ai/model-routing.md`

详见 `.ai/tools-policy.md`。

---

## 🔄 Harness 版本演进

本 harness 自身也是被维护的。升级流程：
- 每 2 周复盘一次（Harness 例会）
- 升级走 PR review，更新版本号（v1.0 → v1.1 → ...）
- 重大变更必须广播给所有项目
