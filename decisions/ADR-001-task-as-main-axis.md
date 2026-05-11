# ADR-001: progress/ 以 task 为主轴，不按人分

**状态**: accepted
**日期**: 2026-05-11
**作者**: joey

## 背景
团队多人协作，需要决定 `progress/` 目录如何组织。备选方案：
1. 按人分（`progress/joey/`, `progress/alice/`）
2. 按 commit 分
3. 按 task 分

## 决策
**采用方案 3：以 task 为主轴**

```
progress/
├── tasks/T-XXX-name/   # 主轴（功能维度）
├── daily/YYYY-MM-DD-name.md  # 辅轴（时间维度，按人+日期）
└── current.md          # 全局状态板
```

## 理由
- **按人分**：人会离职/调岗，半年后全是死文件；OpenAI/Anthropic 的 harness 都没有按人分
- **按 commit 分**：太细碎，git log 已经做了这件事
- **按 task 分**：任务是真实的工作单元，跨人协作时上下文不断裂；task ID 可以贯穿 commit message / feature_list / PR

## 影响
- commit message 必须带 task ID：`[T-XXX] feat: ...`
- 每个 task 必须有目录 + 4 个标准文件
- 人通过 `owner.txt` + `daily/` 文件名挂上去（动态、可换）

## 关联
- AGENTS.md "目录结构" 章节
- T-000 示范任务
