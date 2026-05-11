# ADR-006: 多人协作的双重对齐协议

**状态**: accepted
**日期**: 2026-05-11
**作者**: 大Joe (proposed) / joey (drafted)

## 背景
v1.1 的 task 管理假设一个 task 只有一个 owner。但实际多人协作中暴露两个问题：

1. **无意识重复**：B 想做 X，不知道 A 也在做 X（或类似的事）
2. **盲目接力**：B 加入 A 的 task 但没读 A 的 spec / plan / decisions / log，
   推翻 A 已经定好的设计，或者重踩 A 已经踩过的坑

手动靠"自觉沟通"无法解决，必须工具化。

## 决策
**引入双重对齐协议**，由 `scripts/new-task.sh` 工具强制执行：

### 第 1 重：是不是同一个任务？
- 创建 task 前自动扫描所有 `status ∈ {doing, spec-review, plan-review, code-review, spec-todo}` 的 task
- 基于标题 + spec.md + README.md 做关键词相似度匹配
- 找到相似 task 时，**强制用户三选一**：
  - 加入已有 task（成为子任务 T-XXX.Y）
  - 确认是独立新 task
  - 看完所有相似 task 的完整 spec 再决定

### 第 2 重：加入已有 task 必须走对齐流程
- **Step 1 阅读对齐**：必须确认读完 spec.md / plan.md / log.md / decisions.md
- **Step 2 联系 owner**：必须确认已经与 owner 达成分工共识（线下沟通）
- **Step 3 声明范围**：必须填写自己负责的具体范围（≥10 字）

三步全部完成才允许创建子任务目录。

### 数据结构升级
- `owner.txt`（单行）→ `collaborators.json`（结构化）
- 字段：primary_owner / collaborators[] / scope / sync_log[]
- 保留 owner.txt 做向后兼容

## 理由
- **AI 时代多人协作的真正风险不是 ID 冲突**，是"上下文不对齐"
- 工具强制 > 自觉沟通：人会偷懒，工具不会
- `collaborators.json` + `sync_log` 让协作历史可追溯
- 子任务 ID（T-XXX.Y）让父子关系一目了然
- 与"上下文完备性原则"（ADR-002）一脉相承——把上下文外化到文件

## 影响
- 必须用 `scripts/new-task.sh` 创建 task，禁止手动建目录
- task 目录新增 `collaborators.json`（owner.txt 保留兼容）
- 新增 `scripts/sync-check.sh`：session 启动时检查协作 task 最新动态
- PR template 新增"协作对齐确认"check
- feature_list.json 新增 `parent` 字段

## 取舍
- ✅ 重复劳动 / 设计冲突大幅减少
- ✅ 协作历史完全留痕，新人 onboarding 快
- ⚠️ 创建 task 流程变长（但只是把"必要沟通"前置）
- ⚠️ 子任务嵌套深度建议不超过 2 层（T-XXX.Y，不再有 T-XXX.Y.Z）

## 关联
- ADR-001: task 为主轴
- ADR-002: 上下文完备性
- AGENTS.md "协作对齐" 章节
