#!/usr/bin/env bash
# merge-code-map.sh — 把新生成的 code-map 与现有文件合并，保留人工标注段
# 用法: bash .harness/scripts/merge-code-map.sh <new-file> <target-file>

set -euo pipefail

NEW="${1:?need new code-map file}"
TARGET="${2:?need target code-map file}"

# 提取目标文件中的 HUMAN 段
HUMAN_SECTION=""
if [ -f "$TARGET" ]; then
  HUMAN_SECTION=$(awk '/<!-- HUMAN-START -->/,/<!-- HUMAN-END -->/' "$TARGET" || true)
fi

# 如果目标的 HUMAN 段非空（且不是默认模板），用它替换新文件里的 HUMAN 段
if [ -n "$HUMAN_SECTION" ]; then
  # 用 python 做安全替换（sed 处理多行 markdown 容易出问题）
  python3 - "$NEW" "$TARGET" <<'PYEOF'
import sys, re
new_path, target_path = sys.argv[1], sys.argv[2]
with open(new_path) as f:
    new = f.read()
with open(target_path) as f:
    old = f.read()

m = re.search(r'<!-- HUMAN-START -->.*?<!-- HUMAN-END -->', old, re.S)
if m:
    human = m.group(0)
    new = re.sub(r'<!-- HUMAN-START -->.*?<!-- HUMAN-END -->', human, new, count=1, flags=re.S)

with open(target_path, 'w') as f:
    f.write(new)
PYEOF
else
  cp "$NEW" "$TARGET"
fi
