# .harness/ — 团队约束层（只读）

> ⚠️ **此目录由 `futurx-coding-harness` 主仓库自动同步，请勿在本地修改。**
>
> 想升级铁律 / 流程 / 共享脚本？请到主仓库 https://github.com/joevise/futurx-coding-harness 提 PR。

---

## 内容

| 文件 | 作用 |
|---|---|
| `VERSION` | 当前 harness 版本号 |
| `AGENTS.base.md` | 4-5 条铁律 + Session 流程 + 工具中立性 |
| `decisions/` | 主仓库 ADR 副本（决策档案） |
| `templates/` | current.md / code-map.md / lessons.md / changes / pm-input 等模板 |
| `scripts/` | 共享脚本（generate-code-map.sh / merge-code-map.sh / new-task.sh / sync-check.sh / sync-rules.sh） |

---

## 同步机制

由 `.github/workflows/harness-sync.yml` 每周一自动检查主仓库版本并开 PR。
也可手动触发：GitHub Actions 页面 → Harness Sync → Run workflow。

详见 `decisions/ADR-010-two-layer-distribution.md`。
