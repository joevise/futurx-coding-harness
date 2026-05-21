# T-XXX — 任务标题

> 模板：每个 task 完成时必须填写，命名 `progress/changes/YYYY-MM-DD-T-XXX.md`。
> **这是审计追溯的关键文件，不能省略。**（铁律 2，v1.5 升级为 5 段）

- **负责人**：
- **开始时间**：YYYY-MM-DD
- **完成时间**：YYYY-MM-DD
- **关联 commit**：abc1234, def5678
- **关联 PR**：#42（如果有）

## 1. 改了什么
- 新增 / 修改 / 删除的文件清单
- 数据库迁移（如有）
- **契约变更**（如有，列出 contracts/ 下的 diff 路径）

## 2. 为什么改
- 产品需求来源 / 修复的 bug 编号 / 重构动机

## 3. 思路
- 评估了哪些方案
- 选了哪个，为什么
- ⚠️ 避开了哪些坑（关联到 lessons.md 的 L-XXX）

## 4. 验收
- ✅ / ⚠️ / ❌ 单元测试
- ✅ / ⚠️ / ❌ 集成测试
- ✅ / ⚠️ / ❌ 产品验收

## 5. 关联（v1.5 新增）
- **PRD**：`product/prd/<version>.md` §X.Y
- **用户故事**：US-XXX
- **设计稿**：`product/design/figma-links.md` → {link}
- **契约**：`contracts/api/xxx.md` / `contracts/events/xxx.md`

## 遗留 / 后续
- 留给下个 task 处理的事项
- 已知但未解决的小问题
