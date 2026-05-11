# PR Checklist

## 关联 Task
- Task ID: `T-XXX`
- Task 链接: `progress/tasks/T-XXX-name/`

## 改了什么
<!-- 简短描述 -->

## SDD 流程确认（v1.1）
- [ ] `spec.md` 已写 + 产品/Leader review 通过
- [ ] `plan.md` 已写 + 技术 Lead review 通过
- [ ] 测试用例已映射到 spec 的验收标准
- [ ] 代码实现让所有测试通过

## 启动协议确认
- [ ] 我读完了 AGENTS.md 强制启动协议中的所有上下文文件
- [ ] 我已更新 `progress/tasks/T-XXX/log.md`
- [ ] 我已更新 `progress/daily/YYYY-MM-DD-<name>.md`
- [ ] 我已更新 `feature_list.json` 中本 task 的状态

## 决策记录
- [ ] 涉及非平凡架构决策 → 已写 `decisions/ADR-XXX-*.md`
- [ ] 或：本次不涉及架构决策

## 测试
- [ ] 单元测试已加 / 已更新（覆盖率 ≥ 70%）
- [ ] 集成测试通过
- [ ] 端到端测试通过
- [ ] CI 全绿

## Reviewer 提醒
Reviewer 也必须走启动协议：读 AGENTS.md + 当前 task 目录（含 spec/plan） + 相关 ADR，再开始 review。
