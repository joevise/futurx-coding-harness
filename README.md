# FuturX Coding Harness v1.6

> FuturX 内部 AI vibe coding 标准 / 模板仓库

## ⭐ v1.6 新增（2026-05-21）

**AI Onboarding Archaeology — 陌生项目自动考古 Skill**

- 任何 AI agent（Claude Code / Cursor / OpenCode / Codex / Copilot）首次进入未接入 harness 的项目，自动识别并询问是否启动考古
- 7 份自动产出：current / code-map / lessons / onboarding-report / api / features / uncertainty
- 三段诚实标记机制：✅ 证据 / ⚠️ 推测 / ❓ 不确定
- `_inferred` 后缀 → 人工复核后晋升为正式 SSOT
- 用户零命令成本（不用打任何命令）

详见 `AGENTS.md` 和 `decisions/ADR-014-ai-onboard-archaeology.md`。

## v1.5（同日发布）

两层分发 + Contracts + Product + code-map 自动刷新（铁律 4→5）

## 历史

- v1.4 Progress 4 件套 + 轻量化 + Superpower
- v1.3 Skill 化升级
- v1.2 多人协作双重对齐
- v1.1 SDD 流程
- v1.0 启动协议 + task 主轴

详见 `CHANGELOG.md`。

## 接入新项目

```bash
cd /path/to/your-project
bash /path/to/futurx-coding-harness/scripts/install-into.sh
```

接入后用你的 AI 工具打开项目，它会自动询问是否跑 onboarding-archaeology（陌生项目）。

## 上手指南

详见 `GUIDE.md`（30 分钟速通）。
