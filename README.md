# FuturX Coding Harness v1.5

> FuturX 内部 AI vibe coding 标准 / 模板仓库

## ⭐ v1.5 新增（2026-05-21）

**两层分发 + Contracts + Product + code-map 自动刷新**

- **两层架构**：`.harness/`（约束层，只读，自动同步）+ 项目状态层（自管理）
- **Contracts 层**：`contracts/` 跨角色契约 SSOT（铁律 5）
- **Product 层**：`product/` 产品/设计上下文（PRD / 设计稿 / 用户故事）
- **code-map 自动刷新**：main 分支 push 后由 GitHub Action 自动跑（HUMAN 段保留）
- **接入零成本**：`bash scripts/install-into.sh` 一行命令

详见 `AGENTS.md` 和 `decisions/ADR-010 ~ 013`。

## 历史

- v1.4 — Progress 4 件套 + 轻量化 + Superpower 集成
- v1.3 — Skill 化升级
- v1.2 — 多人协作双重对齐
- v1.1 — SDD 流程
- v1.0 — 启动协议 + task 主轴

详见 `CHANGELOG.md`。

## 接入新项目

```bash
cd /path/to/your-project
bash /path/to/futurx-coding-harness/scripts/install-into.sh
```

## 上手指南

详见 `GUIDE.md`（30 分钟速通）。
