# Skill: Onboarding Archaeology — 陌生项目自动考古

> v1.6 核心能力。第一次接手一个项目时，由 AI 自动跑一遍考古，把项目结构、API、模块依赖、技术栈、潜在风险、业务领域**全部摸清楚并写入 harness 状态层文件**。
>
> 适用工具：Claude Code / Cursor / OpenCode / OpenClaw / Copilot Chat / Codex 任何能读 SKILL.md 的 AI。

---

## 何时使用此 Skill

你（AI agent）发现以下任一情况时，**立即询问用户是否启动 onboarding archaeology**：

1. 项目根目录有 `.harness/` 目录，但 `progress/current.md` 不存在 / 内容 < 10 行 / 顶部日期比 git 仓库初始化日期还旧
2. 用户说类似的话：
   - "这项目是干啥的 / 给我讲讲这个项目"
   - "帮我上手 / onboarding"
   - "考古一下 / 摸一遍底"
   - "我刚接手 / 这是别人写的"
3. 用户跑了 `install-into.sh` 后第一次和你交互

询问话术：
> 我发现这是个之前没接入 harness 的项目，需要我跑一遍 onboarding archaeology 吗？大约 20-30 分钟，结束后会给你 7 份产出文件 + 一份 onboarding report。

---

## 工作纪律（不可违反）

### 🔒 沙箱原则
1. **只读模式**：不修改任何业务代码、配置文件、依赖文件
2. **只写入** `progress/`、`contracts/`、`product/` 三个目录
3. **禁止执行**：`npm install` / `pip install` / `make` / `docker build` / 任何会改环境的命令
4. **允许执行**：`grep` / `find` / `cat` / `head` / `tail` / `wc` / `git log` / `git show` / `git blame` / `tree` / `ls`

### 📏 诚实原则（最重要）
所有写入的内容必须用三段式标记：
- **✅** = 代码或配置直接证据（必须给出 `文件路径:行号` 引用）
- **⚠️** = 推测但有合理依据
- **❓** = 不确定 → 必须同时写入 `progress/onboard-uncertainty.md`

**禁止**：编造接口、瞎猜业务逻辑、把"我觉得"写成"项目是"。
**鼓励**：不知道就大方写 ❓，留给原作者或下个开发者追问。

### ⏰ 时间纪律
- 总耗时控制在 30 分钟内
- 超时立即停止深读，把已知部分写完
- 不要追求 100% 覆盖；70% 准确 > 100% 编造

---

## 工作流（5 步）

### Step 1 — 证据收集（5-10 分钟，机器扫描）

按顺序读以下来源，把摘要存到 `/tmp/onboard-evidence.md`：

| 类别 | 命令/文件 | 看什么 |
|---|---|---|
| 项目说明 | `README*` / `docs/*` / 所有根目录 `*.md` | 业务定位 / 启动方式 |
| 技术栈 | `package.json` / `requirements.txt` / `pyproject.toml` / `go.mod` / `Cargo.toml` / `pom.xml` / `Gemfile` / `composer.json` | 语言 / 框架 / 关键依赖 |
| 部署 | `Dockerfile` / `docker-compose.yml` / `k8s/*.yaml` / `Procfile` / `Makefile` / `.github/workflows/*` | 部署形态 / 端口 / 环境变量 |
| 配置 | `.env.example` / `config/*` / `settings.*` | 外部依赖（DB / Redis / 第三方 API） |
| 入口 | `main.*` / `app.*` / `server.*` / `index.*` / `cmd/**/main.go` | 启动流程 |
| 路由 | `grep -rE "@app.route\|@router\|Router()\|app.get\|app.post\|@RequestMapping\|@RestController"` | API 端点清单 |
| 数据模型 | `models/` / `entities/` / `schemas/` / `migrations/` | 核心实体 |
| Git 历史 | `git log --oneline -100` / `git log --stat -20` / `git shortlog -sn` | 最近活跃 / 主要作者 / 重大节点 |
| 活跃模块 | `git log --name-only -50 \| sort \| uniq -c \| sort -rn \| head -20` | 谁经常被改 |
| 隐藏信号 | `grep -rE "TODO\|FIXME\|HACK\|XXX\|DEPRECATED"` | 已知坑 / 技术债 |
| 测试 | `tests/` / `*_test.*` / `*.spec.*` | 期望行为 |

### Step 2 — 定向深读（10-15 分钟，AI 理解）

基于 Step 1 的证据：
1. **追入口 → 主流程**：从入口文件追到第一个业务 handler，画出请求生命周期
2. **抽样 3 个最活跃模块**：根据 git 活跃度 top 3，每个完整读一遍
3. **读 1-2 个测试**：测试是最诚实的文档，理解期望行为
4. **追依赖图**：找 import / require / use 语句，理出模块依赖

### Step 3 — 7 份产出（按模板写入）

**所有 AI 推测的文件加 `_inferred` 后缀**，让人一眼分辨。
复核确认后由人改名去掉后缀（这是产出"晋升"为正式 SSOT 的仪式）。

| # | 输出文件 | 模板 |
|---|---|---|
| 1 | `progress/current.md` | `.harness/skills/onboarding-archaeology/output-templates/current.md` |
| 2 | `progress/code-map.md` | `.harness/skills/onboarding-archaeology/output-templates/code-map.md` |
| 3 | `progress/lessons_inferred.md` | `.harness/skills/onboarding-archaeology/output-templates/lessons.md` |
| 4 | `progress/onboarding-report.md` ⭐ | `.harness/skills/onboarding-archaeology/output-templates/onboarding-report.md` |
| 5 | `contracts/api/_inferred.md` | `.harness/skills/onboarding-archaeology/output-templates/api-inferred.md` |
| 6 | `product/inferred-features.md` | `.harness/skills/onboarding-archaeology/output-templates/features-inferred.md` |
| 7 | `progress/onboard-uncertainty.md` ⭐ | `.harness/skills/onboarding-archaeology/output-templates/uncertainty.md` |

⭐ = 价值最高的两份。`onboarding-report.md` 给新人 30 分钟入门；`uncertainty.md` 给原作者追问清单。

### Step 4 — 总结汇报（给用户）

写完后用这个格式跟用户讲：

```
✅ Onboarding archaeology 完成（耗时 X 分钟）

【我搞清楚了什么】
- 项目业务：xxx
- 技术栈：xxx
- 核心模块：xxx
- 主要 API：xxx 个

【我不确定的（建议你优先确认）】
1. xxx（原因）
2. xxx
3. xxx

【建议你接下来】
1. 先读 progress/onboarding-report.md（30 分钟入门）
2. 复核 contracts/api/_inferred.md，确认无误后改名去掉 _inferred 后缀
3. 拿 progress/onboard-uncertainty.md 找原作者/前同事追问

【产出文件】
- progress/current.md
- progress/code-map.md
- ...
```

### Step 5 — 引导用户做"晋升"复核

用户复核后，引导执行：
```bash
# 复核 contracts/api/_inferred.md 无误后：
git mv contracts/api/_inferred.md contracts/api/<service-name>.md

# 复核 lessons_inferred.md 无误后：
git mv progress/lessons_inferred.md progress/lessons.md  # 如已存在则手动合并

# 提交：
git add -A
git commit -m "[T-000] chore: harness onboarding archaeology 完成"
```

---

## 调用其他 skill 的边界

如果遇到以下场景，**先停止考古，提示用户切换 skill**：

| 场景 | 切换到 |
|---|---|
| 用户想立刻修一个 bug | `systematic-debugging` |
| 用户要规划新功能 | `writing-plans` |
| 项目跑不起来要 debug | `systematic-debugging` |

考古不是万能锤子，是新接手项目的**第一步**。

---

## 自检清单（写完前必过）

- [ ] 7 份产出文件都写了？
- [ ] 所有断言都有 `文件:行号` 引用？
- [ ] `_inferred` 后缀加对了？
- [ ] `onboard-uncertainty.md` 至少列出 3 个真实模糊点？
- [ ] `onboarding-report.md` 读完真能 30 分钟上手？
- [ ] 没修改业务代码 / 配置 / 依赖文件？
- [ ] 总结汇报里有"我不确定"段？

---

## 关联

- ADR-014 — AI Onboarding Archaeology（决策文档）
- ADR-002 — 上下文完备性
- ADR-007 — Progress 4 件套
- ADR-011 — Contracts 层
- ADR-012 — Product 层
- `.harness/skills/onboarding-archaeology/methodology.md` — 详细方法论
