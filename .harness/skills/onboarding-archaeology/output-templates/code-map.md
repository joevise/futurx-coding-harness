# Code Map

> 自动生成段（机器维护）+ 人工标注段（HUMAN-START / HUMAN-END 之间）
> 最后刷新：{YYYY-MM-DD}（onboarding-archaeology 初版）

<!-- AUTO-START -->

## 入口
- ✅ `{path}` — {推断功能}（启动入口，依据：package.json scripts.start / Dockerfile CMD）

## 业务模块

### `src/{module-a}/` — {一句话用途}
- `file1.ts` — ✅ {功能}
- `file2.ts` — ⚠️ {推测功能}

### `src/{module-b}/`
...

## 基础设施
- `src/lib/` / `src/utils/` / `src/middleware/`

## 数据层
- 模型定义位置：
- 数据库迁移位置：

## 测试
- 单元测试：
- 集成测试：

<!-- AUTO-END -->

<!-- HUMAN-START -->
## 人工标注

> 本段不会被自动刷新。在这里写：
> - 关键模块的产品归属（→ PRD §X.Y / US-XXX）
> - 关键陷阱（→ lessons.md L-XXX）
> - 跨模块的依赖关系图

<!-- HUMAN-END -->
