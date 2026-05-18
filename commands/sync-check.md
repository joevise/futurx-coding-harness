# /sync-check 命令规范

## 触发词
`/sync-check`、`检查协作进度`、`看看大家最近在干嘛`

## AI agent 该做什么

当用户触发 `/sync-check` 时：
1. 执行 `bash scripts/sync-check.sh`
2. 把 shell 输出翻译成人话汇报给用户
3. 如果发现用户参与的 task 有 48h 无进展，提示用户

## 示例对话

```
用户：/sync-check
AI：正在检查协作动态...
工具输出：
  === 你参与的 task ===
  T-012 现金管理模块
    - 最近动态：3 小时前 @王哥 更新了 spec
    - 状态：spec-review
  T-015 风险控制系统
    - 最近动态：2 天前 @李姐 提交了代码
    - 状态：doing（注意：超过 48h 无进展）
  === 48h 内有动作的 task ===
  T-010 交易引擎（不归你管）
    - 最近动态：1 小时前 @赵哥 开了新 PR

AI：汇报如下：
- T-012：spec 刚更新，等你 review
- T-015：⚠️ 超过 48h 无进展，要去推动一下吗？
- T-010：新 PR，等王哥 review
```

## 失败处理

| 情况 | 处理方式 |
|---|---|
| sync-check.sh 执行失败 | 提示用户「可能没在 harness 项目里」 |
| 用户不在任何 task 里 | 输出「你还没加入任何 task」 |
| 网络问题导致 git fetch 失败 | 提示「网络问题，尝试手动 git pull」 |