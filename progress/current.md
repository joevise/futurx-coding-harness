# 当前状态 - 2026-05-21

## 项目阶段
**v1.5 设计与实现完成（待团队 review + 端到端验证）**

## 技术栈速览
- 类型：AI 编码协作模板仓库（无运行时）
- 语言：Markdown + Bash + GitHub Actions YAML
- 双远端：GitHub (joevise) + GitLab (futurx)
- 接入方式：`bash scripts/install-into.sh`（v1.5 一键化）

## v1.5 核心
- 两层分发：`.harness/`（约束层，自动同步）+ 状态层（项目自管理）
- Contracts 层（铁律 5）：API/事件/数据模型 SSOT
- Product 层：PRD / 设计 / 用户故事
- code-map 自动刷新（merge 后 GitHub Action）
- 4 条铁律 → 5 条铁律
- changes 模板 4 段 → 5 段

## 进行中的任务
（无）

## 最近完成（最多 5 个）
- T-003 ✅ v1.5 升级 — 两层分发 + Contracts + Product + code-map 自动刷新（2026-05-21）
- T-002 ✅ v1.4 升级 — Progress 4 件套 + 轻量化（2026-05-19）
- T-001 ✅ v1.3 Skill 化升级（2026-05-18）

## 已知问题 / 待跟进
- ⚠️ `harness-sync.yml` 内的远端仓库地址需根据真实部署调整（GitHub vs GitLab）
- ⚠️ `install-into.sh` 需选 1 个真实项目端到端验证
- ⚠️ 跨项目 dashboard（T-004）尚未启动

## 关键链接
- Kick-off 飞书文档：https://futurxai.feishu.cn/docx/CGRGd6xW5o9SFyxdm2bcgEWnnrg
- GitLab: https://git.futurx.cc/futurx/futurxlab/futurx_coding_harness
