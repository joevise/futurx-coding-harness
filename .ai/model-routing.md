# 模型路由策略 (.ai/model-routing.md)

> 不同场景用不同模型，**按场景选模型，不按工具选**。

## 路由表

| 场景 | 首选模型 | 备选 | 原因 |
|---|---|---|---|
| 架构 / 决策 / 复杂推理 | Claude Opus 4.x | GPT-5 | 推理深 |
| 大量代码生成 / 重构 | MiniMax-M2.7 (国内) | Claude Sonnet | 性价比 10×+ |
| 实时补全 | Cursor 默认 / Copilot | — | 低延迟 |
| 长上下文 / 长任务 | Claude Sonnet (200K) | Gemini 2.5 Pro | 长 context |
| 视觉 / 截图 | Claude Sonnet vision | GPT-4V | 视觉强 |
| 中文场景 | MiniMax-M2.7 / 元宝 | Claude | 中文 native |

## OpenCode 配置（公司主推）
- 模型 ID：`minimax-cn/MiniMax-M2.7`
- API Key：从环境变量 `MINIMAX_API_KEY` 读
- 启动命令：`opencode --model minimax-cn/MiniMax-M2.7 run '任务描述'`

## 成本意识
- Token 是钱。能用 MiniMax 解决的不用 Claude。
- 长 session 注意 KV-cache 命中率，避免反复重读大文件。
- 不必要的工具调用 = 不必要的成本，慎用。
