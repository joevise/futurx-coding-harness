# FuturX Coding Harness v1.2 上手指南

> 给团队成员的 30 分钟速通文档
> **目标**：让任何人（不管是传统程序员还是 AI 原生）都能在 30 分钟内把 harness 用起来。

---

## 一、Harness 是什么？为什么必须用？

**一句话**：FuturX 公司内部所有 AI 编码项目的**强制协作标准**。

**解决的痛点**：
- 不同人用不同 AI 工具（Cursor / Claude Code / Copilot / OpenCode），项目散乱
- AI 容易写出"测试通过但偏题"的代码
- 多人协作时无意识做重复工作、推翻别人决策
- 半年后没人记得"当初为什么这么设计"

**核心范式**（必须记住）：

```
上下文完备性 + SDD（Spec→Plan→Test→Code） + 协作双重对齐 + 工具中立
```

---

## 二、5 分钟环境准备

### 1. 安装必要工具
```bash
# Git（必须）
git --version  # 应该 ≥ 2.30

# Python 3（必须，用于 new-task.sh 内部）
python3 --version  # 应该 ≥ 3.8

# GitHub CLI（推荐）
gh --version

# uv（可选，用于 GitHub Spec-Kit）
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. 配置 git user
```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

> ⚠️ `user.name` 会被自动写入 `collaborators.json`，**必须填真名**，不要用 nickname。

### 3. 选择你的 AI 工具
公司推荐：
- 主力编码：**OpenCode + MiniMax-M2.7**（最省钱）
- 复杂推理：**Claude Code**
- 实时辅助：**Cursor**

任何工具都吃同一份 `AGENTS.md`，自由选择。

---

## 三、3 种使用场景

### 场景 A：新建一个项目

```bash
# 1. 用 harness 做模板
gh repo create my-project --template joevise/futurx-coding-harness
cd my-project

# 2. 一键软链所有 AI 工具配置
bash scripts/sync-rules.sh

# 3. 编辑项目元信息
vim AGENTS.md          # 改顶部项目名
vim .ai/context.md     # 改业务背景 / 架构约束
vim README.md          # 改项目说明

# 4. 提交初始化
git add -A && git commit -m "[T-000] init: 项目初始化"
git push
```

### 场景 B：给已有项目接入 harness

```bash
cd /path/to/your-existing-project

# 1. 复制 harness 骨架（不覆盖已有代码）
cp -rn /path/to/futurx-coding-harness/{AGENTS.md,progress,decisions,.ai,scripts,.github,feature_list.json,.gitignore} ./

# 2. 软链 AI 工具配置
bash scripts/sync-rules.sh

# 3. 提交
git add -A && git commit -m "[T-000] chore: 接入 FuturX Coding Harness v1.2"
```

### 场景 C：加入一个已有的 harness 项目（最常见！）

```bash
# 1. clone
git clone <项目地址>
cd <项目>

# 2. session 启动自检（关键！）
bash scripts/sync-check.sh
# 会显示你参与的协作 task 最近 48h 的动态

# 3. 走启动协议（必读 8 类文件）
#    见下一节
```

---

## 四、Session 启动协议（强制）

**每次开始工作前，必须按顺序读完以下文件**：

| 序号 | 文件 | 作用 |
|---|---|---|
| 1 | `AGENTS.md` | 项目唯一真相源 + 强制规则 |
| 2 | `README.md` + `.ai/context.md` | 项目目标 + 架构约束 |
| 3 | `feature_list.json` | 全量功能清单 + 状态 |
| 4 | `progress/current.md` | 当前 sprint + 谁在做啥 |
| 5 | `progress/tasks/<当前 task>/` 整个目录 | 你接手的任务全部上下文 |
| 6 | `decisions/` 下所有 ADR | 已定的架构决策 |
| 7 | 最近 7 天的 `progress/daily/*.md` | 其他人最近做了什么 |
| 8 | `bash scripts/sync-check.sh` | 协作 task 最新动态 |

**读完必须能回答 3 个问题**：
- 当前 task 的 Spec 是什么？验收标准？
- 项目的核心架构约束有哪些？哪些事不能做？
- 最近 3 天有哪些工作？我接的是哪一段？

**回答不出 = 还没准备好 = 不能写代码。**

---

## 五、开一个新功能（SDD 流程）

### 关键铁律：**不允许手动建 task 目录**

```bash
bash scripts/new-task.sh
```

工具会引导你走完：

**1. 描述任务**
```
> 一句话描述你要做的任务：
> 加一个开盘三线信号识别模块
```

**2. 自动扫描相似 task**
工具会找到所有进行中的相似 task，强制你三选一：
- [1] 加入已有 task（变成 T-XXX.Y 子任务）
- [N] 独立新 task
- [Q] 取消

**3. 如果加入已有 task，必走双重对齐 3 步**
- Step 1: 读完 owner 的 spec / plan / log / decisions
- Step 2: 联系 owner 达成分工共识
- Step 3: 声明你的具体范围（≥10 字）

**4. 工具自动创建**
- 目录 + 6 个模板文件
- `collaborators.json` 自动登记你
- `feature_list.json` 自动更新
- `progress/daily/` 自动写一条

### 接下来按 SDD 流程走

```
spec.md  →  plan.md  →  tests/T-XXX/  →  代码
 ↓          ↓             ↓                ↓
产品/Leader  技术 Lead     工程师写测试     AI 写实现
review     review                       让测试全绿
```

**每一步都不能跳！** spec 没通过不能写 plan，plan 没通过不能写测试，测试没写不能写代码。

---

## 六、日常工作 SOP

### 开头 3 件事
```bash
# 1. 状态检查
pwd
git status
git pull

# 2. 协作同步检查
bash scripts/sync-check.sh

# 3. 启动协议（读 8 类文件）+ 在 progress/daily/今日-我.md 写"本次目标"
```

### 写代码时
- ✅ 只动 spec.md 已定义的范围
- ✅ 严格让 tests/T-XXX/ 全绿
- ✅ 不超出 plan.md 列出的任务清单
- ❌ 不自己加戏（spec 没写的功能别加）
- ❌ 不修改其他 task 的代码（除非你也加入了那个 task）

### 结尾 3 件事
```bash
# 1. 跑测试
npm test  # 或 pytest, go test, ...

# 2. commit（必须带 task ID）
git commit -m "[T-003.1] feat: 实现三线信号识别核心逻辑"

# 3. 更新进度
#    - progress/tasks/T-XXX/log.md（追加今天做的事）
#    - progress/daily/今日-我.md（追加成果）
#    - feature_list.json（更新 status）

git push
```

---

## 七、常见问题 FAQ

### Q1: 为什么不能手动建 task 目录？
A: 因为多人协作时会有 ID 冲突、命名风格不一、漏掉对齐步骤。`new-task.sh` 一次性解决。

### Q2: 我只改一个 bug，也要走 SDD？
A: **不用**。修 bug / 小调整可以豁免 spec.md。但 commit message 还是要带 task ID。

### Q3: 我能不能不写 ADR？
A: 涉及**架构 / 接口 / 选型决策**必须写。改 bug、改样式、加日志这种不用。

### Q4: 我用 Cursor，团队同事用 Claude Code，会冲突吗？
A: 不会。所有工具都软链到同一份 `AGENTS.md`，吐出同样格式的产出。

### Q5: AI 输出可以直接 commit 吗？
A: **不行**。必须先跑测试 + 自己看一眼。AI 输出 100% 不看就 commit 是 PR 拒绝项。

### Q6: 我加入别人的 task，发现他设计有问题怎么办？
A: 不要自己改！先 **联系 owner 沟通**，达成共识后写 ADR 记录决策变更。

### Q7: 已经写了一半才发现是别人正在做的东西？
A: 立刻停手，跑 `bash scripts/new-task.sh` 走第 1 重对齐，决定是合并还是放弃自己的工作。

---

## 八、违反规则的后果

| 违反项 | 后果 |
|---|---|
| 没走启动协议就写代码 | PR 拒绝 |
| 手动建 task 目录 | PR 拒绝 |
| 加入他人 task 没走双重对齐 | PR 拒绝 |
| commit message 不带 task ID | pre-commit hook 拒绝 |
| 没更新 progress/ 就 commit | pre-commit hook 拒绝 |
| 测试没全绿就 merge | CI 失败 |
| AI 输出不看直接 commit | code review 拒绝 |

---

## 九、关键文件速查

```
AGENTS.md                    ← 唯一真相源，先读这个
README.md                    ← 项目概览
feature_list.json            ← 全量任务清单
progress/current.md          ← 现在谁在做啥
progress/tasks/T-XXX/        ← 单个任务全部上下文
  ├── README.md              ← 任务描述
  ├── spec.md                ← 做什么（产品视角）
  ├── plan.md                ← 怎么做（工程视角）
  ├── log.md                 ← 工作日志（时间倒序）
  ├── decisions.md           ← 任务级决策
  └── collaborators.json     ← 协作者登记 + sync_log
decisions/ADR-XXX-*.md       ← 架构决策记录
tests/T-XXX/                 ← 任务对应测试
.ai/                         ← AI 工具配置中心
  ├── context.md             ← 长期上下文
  ├── tools-policy.md        ← 工具使用约定
  └── model-routing.md       ← 模型选择策略
scripts/
  ├── new-task.sh            ← ⭐ 创建 task 必用
  ├── sync-check.sh          ← session 启动自检
  ├── sync-rules.sh          ← AI 工具软链同步
  └── check-progress.sh      ← pre-commit hook
```

---

## 十、向团队推广建议

1. **第 1 周**：先在 1-2 个项目试点（不大改动现有代码，只接入流程）
2. **第 2 周**：开 30 分钟培训会，演示 `new-task.sh` 完整流程
3. **第 3 周**：所有新项目强制使用
4. **第 4 周后**：老项目逐步迁移

**关键**：**Leader 必须自己先用起来**，团队才会跟。

---

## 附录：参考资料

- 仓库：https://github.com/joevise/futurx-coding-harness
- GitHub Spec-Kit：https://github.com/github/spec-kit
- Anthropic — Effective Harnesses for Long-Running Agents
- OpenAI — Harness Engineering: Leveraging Codex in an Agent-First World

---

**版本**：v1.2（2026-05-11）
**维护者**：joey（FuturX AI）
**反馈**：直接在 GitHub Issues 或飞书群提
