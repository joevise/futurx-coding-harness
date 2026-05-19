# ADR-007 — Progress 层：项目进度追踪系统

- **状态**：Accepted
- **日期**：2026-05-19
- **决策人**：大Joe + 项目组（百村 / 乐琴 / 阿和 / 婷婷 / 子健）
- **会议来源**：2026-05-18 Harness Engineering 内部对齐会
- **关联 ADR**：ADR-001（task 主轴）/ ADR-002（上下文完备性）

---

## 背景

v1.3 之前的 harness 有 `decisions/`（ADR）、`progress/tasks/`（task spec/plan/log）、`progress/daily/`（日志），但**缺少专门的进度追踪层**。

会议上百村和乐琴分别提出两个核心痛点：

### 百村的痛点：上下文反复污染
> 「spec-kit 这个东西只有在你第一次使用它的时候，你会觉得它最好使。一旦遇到 tricky 问题，AI 会被里面错误的 test 反复污染。它会一直在错误假设里绕圈出不来。」

百村提出的解法：**短小的代码地图 + 踩坑日志**，让 AI 倾向读这些短文件，快速对齐到正确上下文。

### 乐琴的痛点：开发链路不完整
> 「我现在的 spec 只到 design，缺过程记录。」

大Joe 补刀：
> 「commit 写的内容不够，每个 task 必须有一份变更记录文件，说清楚改了什么、为什么改、思路是什么。」

---

## 决策

新增 `progress/` 4 件套，作为**强制**的最小存档单元：

### 1. `progress/current.md`（< 100 行）
- 项目阶段 / 技术栈 / 进行中任务 / 最近完成 / 已知阻塞
- **AI 第一个读**
- 每次 commit 必须更新

### 2. `progress/code-map.md`（几百行内）
- 代码地图：哪个文件做什么
- 标注关键陷阱，指向 lessons.md
- 让 AI 不用全文扫码

### 3. `progress/lessons.md`（踩坑日志）
- 记录"业界推荐但其实错的"方案
- AI 读完后**禁止再用已被标记的错误方案**

### 4. `progress/changes/YYYY-MM-DD-T-XXX.md`
- 每个 task 完成时强制写一份
- 4 段：改了什么 / 为什么改 / 思路 / 验收
- **审计追溯的核心**

---

## 兼容性

- 保留 `progress/tasks/` 和 `progress/daily/`（不破坏存量）
- 但**新项目接入只强制 4 件套**，tasks/daily 改为可选

---

## 强制级别

| 层 | 强制级别 |
|---|---|
| AGENTS.md 顶部铁律 | 硬约束 |
| git pre-commit hook | 可选（团队按需启用）|
| sub-agent push 前审查 | 推荐（阿和的做法） |

---

## 解决的问题

| 痛点 | 4 件套如何解决 |
|---|---|
| 百村：spec 污染上下文 | current.md 限 100 行 + code-map.md 短小 + lessons.md 标错方案 |
| 乐琴：缺过程链路 | changes/*.md 每 task 一份，4 段强制 |
| 大Joe：commit 不够详细 | changes/*.md 替代繁琐 commit message |
| 大Joe：要可追溯 | git history + changes/*.md 双重存档 |
| 子健：要查进度不用打扰开发 | 直接问 agent，agent 读 current.md 回答 |
