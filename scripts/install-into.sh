#!/usr/bin/env bash
# install-into.sh — 一键把 harness 接入到目标项目
# 用法:
#   cd /path/to/your-project
#   bash /path/to/futurx-coding-harness/scripts/install-into.sh
#
# 行为:
#   1. 复制约束层骨架 (.harness/) 到目标项目
#   2. 复制状态层骨架 (progress/ contracts/ product/) — 若目标已有则跳过
#   3. 复制 templates/ decisions/ — 仅作参考
#   4. 创建 AGENTS.md 项目入口（基于 templates/AGENTS.project.md）
#   5. 软链 CLAUDE.md / .cursorrules → AGENTS.md
#   6. 安装 GitHub Actions 工作流（harness-sync + auto-update-code-map）

set -euo pipefail

HARNESS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:-$(pwd)}"

if [ ! -d "$TARGET" ]; then
  echo "❌ 目标目录不存在: $TARGET"
  exit 1
fi

echo "📦 Installing FuturX Coding Harness v$(cat "$HARNESS_ROOT/.harness/VERSION") into: $TARGET"

cd "$TARGET"

# 1. 约束层
echo "→ 复制 .harness/ 约束层"
mkdir -p .harness
cp -r "$HARNESS_ROOT/.harness/"* .harness/

# 2. 状态层骨架（不覆盖已有）
for d in progress contracts product; do
  if [ ! -d "$d" ]; then
    echo "→ 创建 $d/ 骨架"
    cp -r "$HARNESS_ROOT/$d" "./$d"
  else
    echo "  ($d/ 已存在，跳过)"
  fi
done

# 3. progress 子目录
mkdir -p progress/changes progress/archive

# 4. 项目入口
if [ ! -f "AGENTS.md" ]; then
  echo "→ 生成 AGENTS.md（项目入口）"
  cp "$HARNESS_ROOT/templates/AGENTS.project.md" AGENTS.md
fi

# 5. 软链
for link in CLAUDE.md .cursorrules CONVENTIONS.md; do
  if [ ! -e "$link" ]; then
    ln -s AGENTS.md "$link"
    echo "→ 软链 $link → AGENTS.md"
  fi
done

# 6. .github workflows
mkdir -p .github/workflows
for wf in harness-sync.yml auto-update-code-map.yml; do
  if [ ! -f ".github/workflows/$wf" ]; then
    cp "$HARNESS_ROOT/.github/workflows/$wf" ".github/workflows/$wf"
    echo "→ 安装 .github/workflows/$wf"
  fi
done

# 7. 起步 progress 文件
[ -f progress/current.md ] || cp "$HARNESS_ROOT/templates/current.md" progress/current.md
[ -f progress/code-map.md ] || cp "$HARNESS_ROOT/templates/code-map.md" progress/code-map.md
[ -f progress/lessons.md ] || cp "$HARNESS_ROOT/templates/lessons.md" progress/lessons.md

echo ""
echo "✅ 接入完成。下一步："
echo "   1. 编辑 AGENTS.md 顶部的 {项目名}"
echo ""
echo "🔍 如果这是个你不熟悉的项目（如接手、考古）："
echo "   直接用你的 AI 工具（Claude Code / Cursor / OpenCode / Codex）打开项目目录，"
echo "   说一句：「这项目我没接触过，帮我考古一下」"
echo "   AI 会自动调用 .harness/skills/onboarding-archaeology/ skill，20-30 分钟后产出 7 份文件。"
echo ""
echo "📝 如果这是你熟悉的项目："
echo "   手动编辑 progress/current.md 写当前状态，然后提交："
echo "   git add -A && git commit -m '[T-000] chore: 接入 FuturX Coding Harness v$(cat .harness/VERSION)'"
