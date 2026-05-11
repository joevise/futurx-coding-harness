# AI 工具使用约定 (.ai/tools-policy.md)

## 工具中立原则
**用什么工具自己选，但所有工具吃同一份 `AGENTS.md`，吐同样格式的产出。**

## 各工具配置入口

| 工具 | 配置文件 | 处理方式 |
|---|---|---|
| Cursor | `.cursorrules` | 软链到 `AGENTS.md` |
| Claude Code | `CLAUDE.md` | 软链到 `AGENTS.md` |
| OpenCode | `AGENTS.md` | 原生支持 |
| Codex | `AGENTS.md` | 原生支持 |
| GitHub Copilot | `.github/copilot-instructions.md` | 软链到 `AGENTS.md` |
| Aider | `CONVENTIONS.md` | 软链到 `AGENTS.md` |

执行 `bash scripts/sync-rules.sh` 一键同步所有软链。

## 共同强制约束（无论用哪个工具）

1. **必走启动协议**（见 AGENTS.md "强制启动协议"）
2. **必带 task ID 提交**：`[T-XXX] <type>: <description>`
3. **必跑测试再 commit**
4. **修改超 50 行先列计划**
5. **不允许直接接受 AI 输出不看就 commit**

## 推荐工具分工

| 场景 | 推荐工具 | 理由 |
|---|---|---|
| 重逻辑 / 架构设计 | Claude Code | 推理强 |
| 大量代码生成 | OpenCode (MiniMax-M2.7) | 省 token，便宜 10×+ |
| 实时辅助 / 补全 | Cursor / Copilot | 交互快 |
| 长任务自动化 | Codex / OpenCode | 长上下文 |
| 项目对话 / 决策 | Claude Web / Joey 主 Agent | 综合判断 |

## 禁止事项
- ❌ 在没读 AGENTS.md 的 session 里直接让 AI 写代码
- ❌ 用 AI 输出绕过 lint / test / ADR 流程
- ❌ commit message 不带 task ID
