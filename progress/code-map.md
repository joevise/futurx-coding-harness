# 代码地图 — futurx-coding-harness

## 顶层入口
- `SKILL.md` — AI agent 接入入口，写明 agent 在 5 种场景下要做什么
- `AGENTS.md` — 团队铁律（4 条）+ progress 4 件套规范 + superpower 推荐清单
- `README.md` — 人类视角的项目介绍

## 配置与软链
- `CLAUDE.md → AGENTS.md`（软链）
- `.cursorrules → AGENTS.md`（软链）
- `CONVENTIONS.md → AGENTS.md`（软链）
- `feature_list.json` — 全量功能清单

## 模板（核心交付物）
- `templates/current.md` — 项目当前状态模板
- `templates/code-map.md` — 代码地图模板
- `templates/lessons.md` — 踩坑日志模板
- `templates/changes-template.md` — 任务变更记录模板
- `templates/pm-input-template.md` — 产品输入 3+1 模板

## 决策
- `decisions/ADR-001` ~ `ADR-006` — v1.0 ~ v1.3 决策
- `decisions/ADR-007` ⭐ — Progress 4 件套
- `decisions/ADR-008` ⭐ — 轻量化 + Superpower
- `decisions/ADR-009` ⭐ — 产品输入 3+1

## 命令
- `commands/new-task.md` — /new-task 语义（v1.4 降级为推荐）
- `commands/sync-check.md` — /sync-check 语义（v1.4 降级为推荐）
- `commands/start-session.md` — /start-session 语义

## 脚本（v1.4 全部 opt-in）
- `scripts/new-task.sh` — 创建协作 task 目录
- `scripts/sync-check.sh` — 检查协作动态
- `scripts/check-progress.sh` — 进度核查
- `scripts/sync-rules.sh` — 同步规则文件

## 进度
- `progress/current.md` — 当前状态
- `progress/code-map.md` — 本文件
- `progress/lessons.md` — 踩坑日志
- `progress/changes/` — 每个 task 一份变更记录
- `progress/daily/` — 历史日志（v1.3 遗留，v1.4 不强制）
- `progress/tasks/` — 历史 task 目录（v1.3 遗留，v1.4 不强制）

## 关键约束 / 陷阱
- ⚠️ 不要把 superpower skill 内容**复制粘贴**进 AGENTS.md，应该**引用**（见 lessons L-001）
- ⚠️ AGENTS.md 不要超过 250 行（柔性目标，硬上限 300）
