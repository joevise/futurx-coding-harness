# FuturX Coding Harness — 上手指南

> 无论你是从零开始还是接手一个半路项目，这份指南告诉你：**第一步做什么、第二步做什么、第三步做什么**。
>
> 读完后：你应该能在 30 分钟内让任何一个 AI coding 工具（Claude Code / Cursor / OpenCode / Codex）以正确的方式接手你的项目。

---

## 两种场景，对号入座

| 你的情况 | 阅读章节 |
|---|---|
| **我要从零启动一个全新项目** | → 场景 A：冷启动 |
| **我要接手一个已有代码的项目** | → 场景 B：接入现有项目 |
| **我想让 Claude Code / Cursor 等工具用 harness** | → 所有工具配置章节 |

---

## 工具配置总览

不管哪种场景，你都需要先告诉你的 AI 工具："**启动时先读 harness 的规则**"。

### Claude Code

```bash
# 方式 1：项目级配置（在项目根目录）
echo 'AGENTS.md' > .claude/projects/default.md
# 或直接让 Claude Code 读取
```

Claude Code **默认读取 `AGENTS.md`**（无需配置）。首次运行时它会自动找到项目根目录的 `AGENTS.md`。

确认方法：项目根目录有 `AGENTS.md` 即可。

### Cursor

Cursor 读取 `.cursorrules` 文件。Harness 安装时已软链：

```bash
ls -la .cursorrules  # 应该指向 AGENTS.md
```

如果没软链，手动创建：

```bash
ln -sf AGENTS.md .cursorrules
```

### OpenCode / OpenClaw

直接读 `AGENTS.md`。启动后告诉它：

```
请先读 AGENTS.md 和 .harness/AGENTS.base.md，然后告诉我当前项目状态。
```

### Codex（GitHub）

在项目根目录创建 `.github/copilot-instructions.md`：

```markdown
# Copilot Instructions

在开始任何任务前，先读取以下文件：
1. AGENTS.md
2. .harness/AGENTS.base.md
3. progress/current.md
4. progress/lessons.md
```

Harness 安装脚本已自动处理此事。

### 通用原则

**任何 AI coding 工具**，只要它能读文件系统，就让它先读这两个文件：

1. `AGENTS.md` — 项目入口（项目名 + 版本 + 工具配置）
2. `.harness/AGENTS.base.md` — 团队约束（铁律 + Session 流程）

---

## 场景 A：冷启动（全新项目，从零开始）

> 适用：你要在一个空目录里开始做新项目，还没有一行代码。

### Step 1：初始化 Git 仓库（2 分钟）

```bash
cd ~/your-project-path
git init
git remote add origin https://github.com/your-org/your-project.git
# 或你的 GitLab
git remote add origin https://git.futurx.cc/futurx/your-org/your-project.git
```

### Step 2：接入 Harness（30 秒）

```bash
bash ~/joevise-projects/futurx-coding-harness/scripts/install-into.sh
```

这个脚本会创建：
- `.harness/` — 约束层（只读）
- `progress/` — 开发过程目录
- `contracts/` — 契约目录
- `product/` — 产品目录
- `AGENTS.md` — 项目入口
- `SKILL.md` — Agent skill 入口
- 工具配置文件（`.cursorrules` / `.github/copilot-instructions.md` 等）

### Step 3：用 AI 工具打开项目（1 分钟）

用你最顺手的工具打开项目目录：

```bash
# Claude Code
claude

# Cursor
cursor .

# OpenCode
opencode

# 直接用 VS Code / JetBrains 等编辑器也行
```

### Step 4：AI 自动识别 + 初始化 current.md（5 分钟）

全新项目还没有 `progress/current.md` 的内容。AI 工具进入后，你应该看到它识别到 `.harness/` 但 `progress/current.md` 几乎是空的。

**告诉 AI 一句话**：

```
这是一个全新项目，请帮我初始化 harness：

1. 编辑 AGENTS.md 顶部的项目名
2. 帮我写 progress/current.md（全新项目版）
3. 告诉我接下来做什么
```

AI 会：
- 确认项目基本信息（项目名、技术栈、目标）
- 起草 `progress/current.md`
- 给出下一个 Action 项

### Step 5：第一个 commit（2 分钟）

```bash
git add -A
git commit -m "[T-000] chore: 初始化 FuturX Coding Harness v$(cat .harness/VERSION)"
git push origin main
```

### 冷启动完成 ✓

之后每次新 session，AI 工具会自动读 `progress/current.md` + `progress/lessons.md`，你不需要再做任何配置。

---

## 场景 B：接入现有项目（接手已有代码的仓库）

> 适用：项目已经有代码了，但没用 harness 或想切换到 harness。

### Step 1：.clone 项目（如果还没 clone）

```bash
git clone https://git.futurx.cc/futurx/your-team/your-project.git
cd your-project
```

### Step 2：接入 Harness（30 秒）

```bash
bash ~/joevise-projects/futurx-coding-harness/scripts/install-into.sh
```

**重要**：这个脚本是**幂等的、只加不改**的：
- 已有的代码 → 一行不动
- 已有的 `progress/` → 跳过（不会覆盖）
- 没有的目录 → 才创建

### Step 3：用 AI 工具打开项目（1 分钟）

```bash
# Claude Code / Cursor / OpenCode / Codex 等
```

### Step 4：告诉 AI "考古这个项目"（20-30 分钟）⭐

**这是最关键的一步**。看着 AI 的眼睛，说：

```
这项目我没接触过，帮我考古一下。
```

AI 会自动识别场景（`progress/current.md` 几乎为空），询问是否启动 onboarding archaeology。同意后它会：

1. **机器探针**（5-10 分钟）：扫描目录结构、git 历史、依赖文件、路由文件、TODO/FIXME 注释
2. **AI 理解**（10-20 分钟）：追踪入口 → 主流程 → 抽样活跃模块 → 推测业务逻辑
3. **7 份产出**：写入 `progress/` 和 `contracts/` 目录

**产出的文件**：

| 文件 | 用途 |
|---|---|
| `progress/current.md` | 项目当前状态，新人 5 分钟入门 |
| `progress/code-map.md` | 详细代码地图 |
| `progress/lessons_inferred.md` | AI 推测的踩坑记录（待你复核） |
| `progress/onboarding-report.md` ⭐ | **你最先读的**，30 分钟上手指南 |
| `contracts/api/_inferred.md` | 反向提取的 API 清单（待复核） |
| `product/inferred-features.md` | AI 推测的产品功能 |
| `progress/onboard-uncertainty.md` ⭐ | **最重要的**，AI 标出的"我不确定"清单 |

### Step 5：人工复核（10-20 分钟）

考古完成后，**你必须做这几件事**：

#### 5a. 读 `onboarding-report.md`
这应该让你在 30 分钟内对这个项目有手感。读完后你应该知道：
- 项目是干啥的
- 怎么跑起来
- 改一个常见功能要碰哪些文件
- 哪里有坑

#### 5b. 拿 `onboard-uncertainty.md` 找前作者/前同事问清楚
这份清单里全是 AI 拿不准的地方。拿着它去找原作者过一遍，比自己猜快 10 倍。

#### 5c. 确认 API 契约
打开 `contracts/api/_inferred.md`，对照代码确认 API 是否准确。
- 如果没问题：`git mv contracts/api/_inferred.md contracts/api/<service-name>.md`
- 如果有误：修正后再 rename

#### 5d. 合并 lessons
`progress/lessons_inferred.md` 里的推测坑，如果确认是真的，手动合并到 `progress/lessons.md`（如果已存在的话）。

### Step 6：提交（2 分钟）

```bash
# 晋升 _inferred 文件（去掉后缀）
git mv contracts/api/_inferred.md contracts/api/<your-service>.md 2>/dev/null || true

git add -A
git commit -m "[T-000] chore: 接入 FuturX Coding Harness v$(cat .harness/VERSION)"
git push origin main
```

### 接入完成 ✓

之后团队任何人加入，只需要 `git clone` + `bash install-into.sh`，AI 工具自动识别 harness，任何角色进来都能拿到一致的上下文。

---

## 附录：install-into.sh 做了什么

| 操作 | 说明 |
|---|---|
| 创建 `.harness/` | 从主仓库复制约束层（AGENTS.base.md / VERSION / scripts / skills / templates / decisions） |
| 创建 `progress/` | 目录骨架，不覆盖已有内容 |
| 创建 `contracts/` | 目录骨架，不覆盖已有内容 |
| 创建 `product/` | 目录骨架，不覆盖已有内容 |
| 软链 `CLAUDE.md` → `AGENTS.md` | Claude Code 自动读取 |
| 软链 `.cursorrules` → `AGENTS.md` | Cursor 自动读取 |
| 创建 `.github/copilot-instructions.md` | Codex/GitHub Copilot 读取 |
| 安装 `.github/workflows/` | harness-sync.yml + auto-update-code-map.yml |
| 初始化 `progress/current.md` | 仅当文件不存在时（全新项目版模板） |

---

## 附录：workflows 自动同步

安装后，两个 GitHub Actions 自动运行：

### 1. `harness-sync.yml` — 每周一自动同步
每周一从主仓库拉取 `.harness/` 最新版本，自动开 PR 推送到下游项目。

### 2. `auto-update-code-map.yml` — merge 后自动刷新
每次 PR merge 到 main，自动跑 `generate-code-map.sh` 刷新 `progress/code-map.md`，并 commit 回仓库。

---

## 常见问题

**Q: 安装后 AI 工具没有自动读 AGENTS.md？**
A: 确认 `.cursorrules` 软链存在（`ls -la .cursorrules`）。没有的话手动 `ln -sf AGENTS.md .cursorrules`。

**Q: 全新项目，current.md 应该写什么？**
A: 让 AI 工具帮你初始化。全新项目的 current.md 很简单：项目一句话 + 技术栈 + 开发计划（未来 1-2 周要做什么）。

**Q: 我不想用 onboarding archaeology，太慢了？**
A: 对于你熟悉的现有项目，可以跳过 Step 4，直接手动填 `progress/current.md`（10 分钟足够）。onboarding archaeology 是给**真正陌生的项目**用的。

**Q: 主仓库更新了，我的项目怎么同步？**
A: 什么都不用做。`harness-sync.yml` 每周一自动给你开 PR。如果你急着要，现在就触发：`git fetch origin` 然后看有没有新 PR。

**Q: 多角色并行开发，怎么保证不冲突？**
A: 每人开发前 `git pull`，MR review 通过后 merge，AI 工具 merge 后会自动刷新 code-map。核心是**上下文在文件里，不在人的脑子里**。
