#!/usr/bin/env bash
# generate-code-map.sh — 扫描项目源码生成 code-map 机器部分
# 用法: bash .harness/scripts/generate-code-map.sh > /tmp/code-map.new.md
#
# 行为：
# - 扫描常见源码目录（src / app / backend / frontend / lib / pkg / cmd / api 等）
# - 输出每个目录下的文件清单 + 文件首行注释（如有）
# - 不读 node_modules / .git / dist / build / .next / __pycache__

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

DATE=$(date +%Y-%m-%d)

cat <<HEADER
# Code Map

> 自动生成段（机器维护）+ 人工标注段（HUMAN-START / HUMAN-END 之间）
> 最后刷新：$DATE

<!-- AUTO-START -->
HEADER

# 常见源码目录候选
CANDIDATES=(src app backend frontend lib pkg cmd api server services apps packages)

EXCLUDES='node_modules|\.git|dist|build|\.next|__pycache__|\.venv|venv|target|coverage|\.cache'

found=0
for dir in "${CANDIDATES[@]}"; do
  if [ -d "$dir" ]; then
    found=1
    echo ""
    echo "## $dir/"
    # 列出该目录下深度 2 级以内的源码文件
    find "$dir" -maxdepth 4 -type f \
      \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \
         -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.java" \
         -o -name "*.kt" -o -name "*.rb" -o -name "*.php" -o -name "*.cs" \
         -o -name "*.swift" -o -name "*.vue" -o -name "*.svelte" \) \
      2>/dev/null | grep -Ev "$EXCLUDES" | sort | while read -r f; do
        # 抓取首行有效注释
        comment=$(head -20 "$f" 2>/dev/null | grep -m1 -E '^(//|#|"""|/\*\*?)' | \
                  sed -E 's|^(//|#|/\*+|\*)\s*||; s|"""\s*||; s|\s+\*/$||' | head -c 100)
        if [ -n "$comment" ]; then
          echo "- \`$f\` — $comment"
        else
          echo "- \`$f\`"
        fi
      done
  fi
done

if [ "$found" -eq 0 ]; then
  echo ""
  echo "_未发现常见源码目录。请手动维护 code-map.md，或在项目根目录创建 src/ app/ 等。_"
fi

cat <<FOOTER

<!-- AUTO-END -->

<!-- HUMAN-START -->
## 人工标注

> 本段不会被自动刷新。在这里写：
> - 关键模块的产品归属（→ PRD §X.Y / US-XXX）
> - 关键陷阱（→ lessons.md L-XXX）
> - 跨模块的依赖关系图

<!-- HUMAN-END -->
FOOTER
