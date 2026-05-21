# FuturX Coding Harness — 上手指南

> 无论你是从零开始还是接手一个已有代码的项目，**你只需要做一件事：告诉你的 AI 工具"帮我接 harness"**。
>
> 剩下的全部由 AI 自动完成。
>
> 读完后：你应该能在 30 分钟内让任何一个 AI coding 工具（Claude Code / Cursor / OpenCode / Codex）以正确的方式接手你的项目。

---

## 两种场景，对号入座

| 你的情况 | 阅读章节 |
|---|---|
| **我要从零启动一个全新项目** | → 场景 A：冷启动 |
| **我要接手一个已有代码的项目** | → 场景 B：接入现有项目 |

---

## 你只需要做一件事

**告诉你的 AI 工具：**

```
帮我把这个项目接上 FuturX Coding Harness。
```

就这么一句话。AI 会：
1. 检测项目当前状态（全新 vs 已有代码）
2. 自动完成所有初始化工作
3. 问你接下来要做什么

**你不需要敲任何命令、不需要装任何东西、不需要记任何路径。**

---

## 工具配置（AI 工具会自动处理）

不管你用哪个工具，只要 AI 能读文件系统，它就会自动找到项目根目录的 `AGENTS.md` 并读取。

| 你的 AI 工具 | 是否支持 | 说明 |
|---|---|---|
| **Claude Code** | ✅ | 默认读取项目根目录 AGENTS.md |
| **Cursor** | ✅ | 自动读取 `.cursorrules`（Harness 安装时会软链） |
| **OpenCode / OpenClaw** | ✅ | 直接读 AGENTS.md |
| **VS Code + Copilot** | ✅ | 读取 `.github/copilot-instructions.md`（Harness 安装时自动创建） |
| **GitHub Copilot Chat** | ✅ | 同上 |

**你不需要手动配置任何东西**。接好 harness 的项目，任何 AI 工具打开都能用。

---

## 场景 A：冷启动（全新项目，从零开始）

> 适用：你有一个空目录，或者一个刚建好的 Git 仓库，还没有业务代码。

### Step 1：把你的空项目交给 AI（1 分钟）

用你最顺手的工具打开项目目录，告诉它：

```
帮我接上 FuturX Coding Harness。
```

### Step 2：AI 自动完成初始化（5 分钟）

AI 会自动：

1. 识别这是一个全新项目
2. 从 harness 主仓库获取 `.harness/` 约束层
3. 初始化 `progress/`、`contracts/`、`product/` 目录骨架
4. 创建 `AGENTS.md` 入口文件
5. 软链工具配置文件（`.cursorrules` 等）
6. 安装 GitHub workflows（如果用 GitHub）
7. 起草第一版 `progress/current.md`

### Step 3：确认并补充项目信息（5 分钟）

AI 初始化完成后会告诉你它做了什么，然后问你：

- 项目叫什么名字？
- 做什么业务？
- 用什么技术栈？

你回答，AI 更新 `AGENTS.md` 和 `progress/current.md`。

### Step 4：第一个 commit（1 分钟）

```
帮我提交。
```

AI 自动 `git add -A && git commit -m "[T-000] chore: 初始化 FuturX Coding Harness vX.X"`。

---

### 冷启动完成 ✓

之后每次新 session，AI 工具会自动读 `progress/current.md` + `progress/lessons.md` + `product/prd/`（如有），你不需要再做任何配置。

---

## 场景 B：接入现有项目（已有代码的仓库）

> 适用：项目已经有代码了，但没用 harness，或者想切换到 harness。

### Step 1：把项目交给 AI（1 分钟）

用你最顺手的工具打开项目目录，告诉它：

```
帮我把这个项目接上 FuturX Coding Harness。
```

### Step 2：AI 自动完成初始化（5 分钟）

AI 会自动：

1. 识别这是一个有代码的已有项目
2. 从 harness 主仓库获取 `.harness/` 约束层
3. 初始化 `progress/`、`contracts/`、`product/` 目录骨架
4. 创建/更新 `AGENTS.md`
5. 安装 GitHub workflows
6. **自动识别项目当前状态**（技术栈、目录结构）

### Step 3：考古这个项目（20-30 分钟）⭐

如果 AI 发现这是一个有代码的已有项目，它会主动询问：

> "我看到这个项目已经有代码了，需要我跑一遍 onboarding archaeology 吗？我会把所有代码结构、API、模块依赖、技术栈、潜在风险全部摸清楚，生成一份新人 30 分钟上手指南。"

你说"好"，AI 就开始考古（详见 onboarding archaeology skill）。

### Step 4：人工复核（10-20 分钟）

考古完成后，AI 会产出 7 份文件。你需要：

1. **读 `progress/onboarding-report.md`**（你最先读的，30 分钟入门）
2. **拿 `progress/onboard-uncertainty.md` 找前作者问清楚**（AI 标出的"我不确定"清单）
3. **确认 `contracts/api/_inferred.md`**，无误后去掉 `_inferred` 后缀
4. **合并 `progress/lessons_inferred.md`** 到 lessons.md（如有）

### Step 5：提交

```
帮我提交。
```

---

### 接入完成 ✓

之后团队任何人加入，只需要 `git clone`，AI 工具自动识别 harness，任何角色进来都能拿到一致的上下文。

---

## 产品文档放在哪

项目里所有产品相关的内容，放在 `product/` 目录：

```
product/
├── prd/                         ← PRD（产品需求文档）放这里
│   ├── v1.0.md                  ← 例如：v1.0 的 PRD
│   └── v2.0.md                  ← 产品迭代后新增版本
│
├── design/                      ← 设计相关
│   ├── figma-links.md           ← 所有 Figma 设计稿的链接
│   └── prototypes/              ← HTML/CSS 原型文件（如果有）
│
└── user-stories/               ← 核心用户故事
    ├── US-001.md
    └── US-002.md
```

### PRD 放在 `product/prd/` 的好处

- AI 每次 session 开始时**自动读到**（Session 流程规定）
- 和代码在同一个仓库，**上下文不割裂**
- 代码改的时候，PRD 也在同一个地方，方便一起 review

### 纯产品项目也能用 harness

如果你的仓库一开始只有产品文档、没有代码：

1. AI 接入 harness 后，先在 `product/prd/` 写 PRD
2. 设计稿链接放进 `product/design/figma-links.md`
3. 等产品确认后，再开始写代码

**harness 不要求代码先行**。

---

## 附录：harness 的目录结构速览

```
project/
├── .harness/                     🔒 约束层（从主仓库同步，不手动改）
│   ├── AGENTS.base.md            铁律 + Session 流程
│   ├── VERSION
│   ├── skills/                   共享 skills（如 onboarding-archaeology）
│   ├── scripts/                  共享脚本
│   ├── templates/                模板
│   └── decisions/                ADR 副本
│
├── AGENTS.md                    项目入口（继承 .harness/）
├── SKILL.md                     Agent skill 入口
│
├── progress/                    📊 开发过程（你维护）
│   ├── current.md               当前状态（AI 每次读）
│   ├── code-map.md              代码地图
│   ├── lessons.md               踩坑日志
│   └── changes/                每个 task 的记录
│
├── contracts/                   📝 跨角色契约（你维护）
│   ├── api/                    API 定义
│   ├── events/                 事件/消息 schema
│   └── data-models/            共享数据结构
│
└── product/                    🎨 产品/设计上下文（你维护）
    ├── prd/                    PRD 文档
    ├── design/                 设计稿 + 原型
    └── user-stories/           用户故事
```

---

## 常见问题

**Q: 我的 AI 工具没有自动读 AGENTS.md？**
A: 确认项目根目录有 `AGENTS.md`。如果用了 Cursor，确认 `.cursorrules` 软链存在（`ls -la .cursorrules`）。告诉 AI："请先读 AGENTS.md 和 .harness/AGENTS.base.md"。

**Q: 全新项目，current.md AI 会怎么写？**
A: AI 会问你几个问题（项目名、业务目标、技术栈），然后基于你的回答起草。全新项目的 current.md 很简单：项目一句话 + 技术栈 + 开发计划。

**Q: onboarding archaeology 太慢了，能跳过吗？**
A: 可以跳过，直接告诉 AI："帮我手动填 progress/current.md"。但如果是**你真正不熟悉的项目**，强烈建议跑一遍——20-30 分钟换 30 分钟读完就能上手，值得。

**Q: harness 主仓库更新了，我的项目怎么同步？**
A: 什么都不用做。`harness-sync.yml` 每周一自动给你开 PR。如果急着要，在项目里告诉 AI："帮我同步 harness 最新版本"。

**Q: 多角色并行开发，怎么保证不冲突？**
A: 每人开发前 `git pull`，MR review 通过后 merge。**上下文在文件里，不在人的脑子里**——这是 harness 的核心价值。
