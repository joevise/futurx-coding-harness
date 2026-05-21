#!/bin/bash
# check-progress.sh — pre-commit hook 用，检查本次提交是否更新了 progress/
# 安装：cp scripts/check-progress.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

# 检查是否有 progress/ 文件被修改
if ! git diff --cached --name-only | grep -q "^progress/"; then
  echo "⚠️  本次提交没有更新 progress/ 目录"
  echo "   请更新 progress/daily/今日-<你的名字>.md 或对应的 progress/tasks/T-XXX/log.md"
  echo "   如果确认不需要更新，加 --no-verify 跳过（不推荐）"
  exit 1
fi

# 检查 commit message 是否带 task ID
COMMIT_MSG_FILE="$1"
if [ -n "$COMMIT_MSG_FILE" ] && [ -f "$COMMIT_MSG_FILE" ]; then
  if ! grep -qE "^\[T-[0-9]{3}\]" "$COMMIT_MSG_FILE"; then
    echo "⚠️  commit message 必须带 task ID，格式：[T-XXX] <type>: <description>"
    exit 1
  fi
fi

echo "✅ progress 检查通过"
