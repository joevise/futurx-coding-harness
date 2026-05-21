#!/bin/bash
# sync-rules.sh — 同步 AGENTS.md 到所有 AI 工具的配置入口
# 用法：在项目根目录执行 `bash scripts/sync-rules.sh`

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ ! -f AGENTS.md ]; then
  echo "❌ AGENTS.md 不存在，请先创建"
  exit 1
fi

echo "🔗 同步 AGENTS.md 到各 AI 工具配置入口..."

# Claude Code
ln -sf AGENTS.md CLAUDE.md && echo "  ✅ CLAUDE.md"

# Cursor
ln -sf AGENTS.md .cursorrules && echo "  ✅ .cursorrules"

# GitHub Copilot
mkdir -p .github
ln -sf ../AGENTS.md .github/copilot-instructions.md && echo "  ✅ .github/copilot-instructions.md"

# Aider
ln -sf AGENTS.md CONVENTIONS.md && echo "  ✅ CONVENTIONS.md"

echo ""
echo "✨ 完成。所有 AI 工具现在都会读 AGENTS.md。"
echo "📝 提醒：修改 AGENTS.md 后，所有工具自动同步（因为是软链）。"
