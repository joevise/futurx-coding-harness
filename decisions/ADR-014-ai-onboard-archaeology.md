# ADR-014 — AI Onboarding Archaeology（陌生项目自动考古）

- **状态**：Accepted
- **日期**：2026-05-21
- **决策人**：大Joe + Dr.EOJAD
- **关联 ADR**：ADR-002（上下文完备性）/ ADR-007（Progress 4 件套）/ ADR-008（轻量化 + Superpower）/ ADR-010（两层分发）

---

## 背景

v1.5 解决了"已有 harness 的项目如何对齐上下文"，但没解决一个更关键的场景：

> **新接手一个之前没接入 harness 的陌生项目，怎么把项目结构、API、模块依赖、技术栈、潜在风险、业务领域全部摸清楚？**

会议上大Joe 明确表态：
> 「这件事不可能我只写脚本来分析，而是更多的我可能就需要 AI 来自动来撰写了这些东西。自动考古，自动来返回溯所有的东西，自动去读之前所有的仓库，把所有的逻辑都给写清楚。我一定要保证就是一个项目在 onboard 时候，这个代码仓库里的东西，它是有一个 onboard 的一个过程。」

并明确架构：
> 「为这件事情单独写一个 Skill，不要写脚本。大家都会有自己的 Cloud Code 也好，用 Open Code 也好，用 Cursor 也好，直接来用这套东西。不需要打命令什么的。」

---

## 决策

### 1. 用 Skill 而非脚本

把陌生项目考古能力做成一个 **Superpower 风格的 Skill**，不是 bash 脚本：

```
.harness/skills/onboarding-archaeology/
├── SKILL.md              入口（AI 必读）
├── methodology.md        方法论细节（AI 卡住时查）
├── output-templates/     7 份产出模板
└── examples/             真实跑过的样例（学习用）
```

**理由**：
- Skill 是 AI-native 形态，Claude Code / Cursor / OpenCode / Codex / Copilot Chat 全部能读
- 用户无需记命令、切目录、跑脚本——任何 AI agent 进项目自动识别场景调用
- 演进只需改 markdown，不用动 bash

### 2. 自动触发机制

在 `.harness/AGENTS.base.md` 加触发规则：

> **当 AI 发现项目有 `.harness/` 但 `progress/current.md` 几乎为空，或用户提到"接手"、"上手"、"考古"、"这项目是干啥的"，必须主动询问是否启动 `onboarding-archaeology` skill。**

### 3. 7 份产出（带 `_inferred` 后缀的"晋升"机制）

| # | 产出 | 性质 |
|---|---|---|
| 1 | `progress/current.md` | 当前状态 |
| 2 | `progress/code-map.md` | 详细代码地图 |
| 3 | `progress/lessons_inferred.md` | 推测的踩坑（待复核） |
| 4 | `progress/onboarding-report.md` ⭐ | 新人 30 分钟入门 |
| 5 | `contracts/api/_inferred.md` | 反向 API 清单 |
| 6 | `product/inferred-features.md` | 推测功能 |
| 7 | `progress/onboard-uncertainty.md` ⭐ | AI 标记的"我不确定"清单 |

**`_inferred` 后缀**：所有 AI 推测内容显式标记，复核后由人改名去掉后缀，象征"晋升"为正式 SSOT。

### 4. 三段诚实标记

所有产出强制用：
- ✅ 代码证据确认（必须给 `文件:行号`）
- ⚠️ 推测但有依据
- ❓ 不确定（必须同时写入 uncertainty.md）

**禁止**：编造接口、瞎猜业务、把"我觉得"写成"项目是"。

### 5. 沙箱原则

考古过程严格 read-only：
- 不修改业务代码
- 只写入 `progress/` `contracts/` `product/`
- 禁止 `npm install` / `pip install` / `docker build` 等环境改动命令
- 允许 grep/find/cat/git log 等只读命令

---

## 强制级别

| 项 | 强制级别 |
|---|---|
| 项目第一次接入 harness 必须跑 onboarding-archaeology | 强烈推荐 |
| 7 份产出必须由人复核后入库 | 硬约束 |
| AI 产出必须用三段诚实标记 | 硬约束（skill 自检清单） |
| Skill 形态而非脚本 | 硬约束（架构决策） |

---

## 取舍

- ✅ AI-native 形态，任何 agent 工具开箱可用
- ✅ 用户零命令成本（"不需要打命令什么的"）
- ✅ 跟 harness 一起自动分发到所有项目
- ✅ 与 superpower 工具箱风格一致（团队已有认知）
- ⚠️ 依赖 AI 的代码理解能力（小项目可能 over-engineering，大项目可能跑超时）
- ⚠️ 7 份产出对小项目偏重 → 未来可加"轻量版"参数

---

## 验收标准

拿一个团队成员都不熟的真实项目（中型，1-5 万行代码），跑 onboarding-archaeology：

- ✅ 产出的 `onboarding-report.md` 读完后能在 30 分钟内改对一个小 bug
- ✅ `onboard-uncertainty.md` 列出至少 3 个真正模糊的地方（证明 AI 没瞎编）
- ✅ `contracts/api/_inferred.md` 反向提取的 API 与实际比对，准确率 ≥ 80%
- ✅ 全程不超过 30 分钟
- ✅ 全程没改动任何业务代码

---

## 关联

- ADR-002 上下文完备性
- ADR-007 Progress 4 件套
- ADR-008 轻量化 + Superpower 集成
- ADR-010 两层分发架构
- ADR-011 Contracts 层
- ADR-012 Product 上下文层
