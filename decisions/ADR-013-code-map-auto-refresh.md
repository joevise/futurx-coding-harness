# ADR-013 — code-map.md 在 merge 后自动刷新

- **状态**：Accepted
- **日期**：2026-05-21
- **决策人**：大Joe + Dr.EOJAD
- **关联 ADR**：ADR-007（Progress 4 件套）/ ADR-010（两层分发）

---

## 背景

`progress/code-map.md` 是 Progress 4 件套之一，AI 用它快速定位代码。但 v1.4 靠开发者手动维护，实际中：

- 开发改完代码常常忘记同步 code-map.md
- 即使跑 `/sync-check` 提醒，开发者也会跳过
- 大Joe 强调"不靠 hook、不靠脚本、靠 AI 自觉"——这个原则**适用于开发中**，但 **merge 后 main 分支必须最新** 是另一个层级的需求

`code-map.md` 的特殊性：**它本质是代码结构的镜像**，机器扫一遍最准、最快、最一致。是 4 件套里**最适合自动化的一份**。

---

## 决策

`code-map.md` 在 PR merge 到 main 后由 GitHub Action 自动刷新：

### 触发条件
- `push` 事件，分支 = `main`（即 PR merge 后）
- 不在 feature 分支跑（开发中不打扰）

### 工作流逻辑

```yaml
# .github/workflows/auto-update-code-map.yml
on:
  push:
    branches: [main]
    paths-ignore:
      - 'progress/code-map.md'   # 防自循环
jobs:
  refresh:
    steps:
      - checkout
      - run: bash .harness/scripts/generate-code-map.sh > /tmp/code-map.new.md
      - run: |
          # 保留人工注释（产品归属等），仅刷新结构
          bash .harness/scripts/merge-code-map.sh /tmp/code-map.new.md progress/code-map.md
      - run: |
          if git diff --quiet progress/code-map.md; then exit 0; fi
          git config user.name "harness-bot"
          git config user.email "harness-bot@futurx.local"
          git add progress/code-map.md
          git commit -m "[chore] auto: refresh code-map post-merge"
          git push
```

### `generate-code-map.sh` 行为

扫描项目源码目录，提取每个文件第一行注释/docstring，输出结构化 markdown：

```markdown
# Code Map (auto-generated YYYY-MM-DD)

## src/api/
- `users.ts` — 用户 CRUD 接口
- `orders.ts` — 订单接口

## src/services/
...
```

### 人工注释保留

`code-map.md` 允许两类内容：
1. **机器生成**（文件清单 + 文件第一行注释）
2. **人工标注**（关联 PRD、关键陷阱指向 lessons.md、产品归属）

`merge-code-map.sh` 保留人工标注块（用 `<!-- HUMAN-START -->` `<!-- HUMAN-END -->` 标记），只刷新机器生成块。

---

## 强制级别

| 项 | 强制级别 |
|---|---|
| 所有项目挂 auto-update-code-map workflow | 强烈推荐 |
| `generate-code-map.sh` 提供在 .harness/scripts/ | 硬约束 |
| 人工标注用 HUMAN 标签包裹 | 推荐 |

---

## 取舍

- ✅ code-map 永远最新，AI 进来读到的就是真相
- ✅ 不打扰开发流程（只在 merge 后跑）
- ✅ 不违反"开发中靠 AI 自觉"原则（这是 merge 后基础设施层）
- ⚠️ 自动 commit 占用一行 git history（用 [chore] auto 前缀清晰可滤）
- ⚠️ 人工标注规则需团队学习（GUIDE.md 单独说明）

---

## 关联

- ADR-007（Progress 4 件套）
- ADR-010（两层分发）
- ADR-012（产品上下文层 — code-map 标注产品归属）
