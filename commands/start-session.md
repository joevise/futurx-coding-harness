# /start-session 命令规范

## 触发词
`/start-session`、`开始新 session`、`开始工作`

## AI agent 该做什么

当用户触发 `/start-session` 时，按以下顺序执行启动协议：

### 第一步：读 8 类文件
按顺序读，不能跳过：
1. `AGENTS.md` — 项目唯一真相源
2. `README.md` + `.ai/context.md` — 项目目标 + 架构约束
3. `feature_list.json` — 全量功能清单
4. `progress/current.md` — 当前 sprint
5. `progress/tasks/<当前 task>/` 整个目录 — 你接手的任务全部上下文
6. `decisions/` 下所有 ADR — 已定的架构决策
7. 最近 7 天的 `progress/daily/*.md` — 其他人最近做了什么
8. `bash scripts/sync-check.sh` — 协作 task 最新动态

### 第二步：回答 3 个核心问题
向用户输出「启动协议自检报告」：

```
📋 启动协议自检报告

1. 当前 task 的 Spec 是什么？验收标准？
   [你的回答]

2. 项目的核心架构约束有哪些？哪些事不能做？
   [你的回答]

3. 最近 3 天有哪些工作？我接的是哪一段？
   [你的回答]
```

### 第三步：等用户确认
「以上是我的理解。确认开始工作吗？」

用户确认后才能开始写代码。

## 示例对话

```
用户：/start-session
AI：收到！正在执行启动协议...

（读取 AGENTS.md, README.md, feature_list.json, progress/current.md,
  T-012 整个目录, decisions/, 最近 7 天 daily/, 跑 sync-check.sh）

📋 启动协议自检报告

1. 当前 task 的 Spec 是什么？验收标准？
   T-012.1 负责货币基金 T+0 申购赎回。
   - 用户可实时申购赎回货币基金
   - T+0 到账
   - 单笔限额 100 万

2. 项目的核心架构约束有哪些？哪些事不能做？
   - 必须走 SDD 流程，不能直接写代码
   - 不能修改其他 task 的代码
   - 不能绕过双重对齐

3. 最近 3 天有哪些工作？我接的是哪一段？
   - 王哥在推进 T-012 现金管理主模块（spec 刚 review）
   - 我接的是 T-012.1 申购赎回子模块

以上是我的理解，确认开始工作吗？
用户：确认，开始吧
AI：✅ 开始工作。先写 spec.md 还是先看王哥的 plan？
```

## 失败处理

| 情况 | 处理方式 |
|---|---|
| 用户跳过启动协议 | 报错「启动协议是强制流程，commit 会被 PR 拒绝」 |
| 读文件时权限不足 | 提示用户「缺少读取权限，尝试 git clone」 |
| 3 个问题答不上来 | 说明「还没准备好，需要继续读」 |