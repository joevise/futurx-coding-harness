#!/usr/bin/env bash
# sync-check.sh — Session 启动时检查协作 task 的最新动态
# 用法：bash scripts/sync-check.sh
# 推荐：加进 shell rc 或 git hooks/post-merge

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

CURRENT_USER=$(git config user.name || echo "unknown")

# 找所有协作中且包含当前用户的 task
TASKS_WITH_ME=()
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if grep -q "\"name\": *\"$CURRENT_USER\"" "$f" 2>/dev/null; then
    n=$(python3 -c "
import json
with open('$f') as x:
    d = json.load(x)
n = len(d.get('collaborators', []))
print(n)
" 2>/dev/null)
    if [ "$n" -ge 2 ]; then
      tdir=$(dirname "$f")
      TASKS_WITH_ME+=("$tdir|$f")
    fi
  fi
done < <(find progress/tasks -name "collaborators.json" 2>/dev/null)

if [ ${#TASKS_WITH_ME[@]} -eq 0 ]; then
  exit 0
fi

echo ""
echo "🔄 协作 task 同步检查（你参与的 task 有 ${#TASKS_WITH_ME[@]} 个）："
echo ""

for entry in "${TASKS_WITH_ME[@]}"; do
  IFS='|' read -r tdir cfile <<< "$entry"
  TID=$(basename "$tdir" | grep -oE "T-[0-9]+(\.[0-9]+)?")
  TITLE=$(basename "$tdir" | sed "s/^T-[0-9.]*-//")
  echo "  📌 $TID  $TITLE"

  if [ -f "$tdir/log.md" ]; then
    # 找最近 48 小时的 log
    RECENT=$(awk '/^## /{block=$0; printing=0} /^## [0-9]{4}-/{
      d=$2
      cmd="date -d \"" d "\" +%s 2>/dev/null"; cmd | getline ts; close(cmd)
      now=systime()
      if (ts > 0 && (now - ts) < 172800) {print block; printing=1; next}
      else printing=0
    } printing' "$tdir/log.md" 2>/dev/null | head -10)
    if [ -n "$RECENT" ]; then
      echo "     最近 48h 更新："
      echo "$RECENT" | sed 's/^/       /'
    else
      echo "     最近 48h 无新动态"
    fi
  fi
  echo ""
done

echo "💡 建议：动手前先读一下这些 task 的最新 log/decisions，再开始你的工作"
echo ""
