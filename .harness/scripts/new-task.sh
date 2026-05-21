#!/usr/bin/env bash
# new-task.sh — FuturX Harness v1.2 智能 task 创建 + 双重协作对齐
# 用法：bash scripts/new-task.sh

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# ─── 工具函数 ────────────────────────────────────────────────
log()  { echo -e "\033[36m$*\033[0m"; }
warn() { echo -e "\033[33m⚠️  $*\033[0m"; }
ok()   { echo -e "\033[32m✅ $*\033[0m"; }
die()  { echo -e "\033[31m❌ $*\033[0m"; exit 1; }
ask()  { local p="$1"; local v; read -r -p "$p " v; echo "$v"; }

[ -f feature_list.json ] || die "feature_list.json 不存在，请先初始化"

# 同步远端，防止 ID 冲突
log "🔄 同步远端，防止 ID 冲突..."
git fetch --quiet 2>/dev/null || warn "git fetch 失败，可能离线"

# ─── 收集当前状态 ────────────────────────────────────────────
ALL_TASKS=$(find progress/tasks -maxdepth 1 -type d -name "T-*" 2>/dev/null | sort)
MAX_ID=$(echo "$ALL_TASKS" | grep -oE "T-[0-9]+" | grep -oE "[0-9]+" | sort -n | tail -1)
MAX_ID=${MAX_ID:-0}
NEXT_ID=$(printf "T-%03d" $((10#$MAX_ID + 1)))

DOING_TASKS=$(python3 -c "
import json
with open('feature_list.json') as f:
    d = json.load(f)
for t in d.get('features', []):
    if t.get('status') in ('doing','spec-review','plan-review','code-review','spec-todo'):
        print(f\"{t['id']}|{t['title']}|{t['owner']}|{t['status']}\")
" 2>/dev/null || true)

CURRENT_USER=$(git config user.name || echo "unknown")

log ""
log "📋 当前 task 状态"
log "   总数: $(echo "$ALL_TASKS" | wc -l)"
log "   下一个 ID: $NEXT_ID"
log "   你的身份: $CURRENT_USER"
log ""

# ─── 收集用户描述 ────────────────────────────────────────────
DESC=$(ask "🤖 一句话描述你要做的任务：")
[ -z "$DESC" ] && die "描述不能为空"

# ─── 第 1 重对齐：扫描进行中的相似 task ──────────────────────
log ""
log "🔍 扫描进行中的相似 task..."

# 简单关键词匹配（中文 + 英文，去停用词）
KEYWORDS=$(echo "$DESC" | tr '[:upper:]' '[:lower:]' \
  | tr -d ',，。.！!？?、（）()【】[]<>《》""""\47' \
  | tr ' ' '\n' | awk 'length($0)>=2' | sort -u)

SIMILAR=()
if [ -n "$DOING_TASKS" ]; then
  while IFS='|' read -r tid ttitle towner tstatus; do
    [ -z "$tid" ] && continue
    score=0
    for kw in $KEYWORDS; do
      if echo "$ttitle" | tr '[:upper:]' '[:lower:]' | grep -qF "$kw"; then
        score=$((score + 2))
      fi
      tdir="progress/tasks/${tid}-"*
      for sf in $tdir/spec.md $tdir/README.md 2>/dev/null; do
        [ -f "$sf" ] && grep -qiF "$kw" "$sf" 2>/dev/null && score=$((score + 1))
      done
    done
    if [ "$score" -ge 2 ]; then
      SIMILAR+=("$score|$tid|$ttitle|$towner|$tstatus")
    fi
  done <<< "$DOING_TASKS"
fi

if [ ${#SIMILAR[@]} -gt 0 ]; then
  warn "发现可能相关的进行中 task："
  echo ""
  IFS=$'\n' SORTED=($(printf '%s\n' "${SIMILAR[@]}" | sort -rn))
  for i in "${!SORTED[@]}"; do
    IFS='|' read -r score tid ttitle towner tstatus <<< "${SORTED[$i]}"
    echo "  [$((i+1))] $tid  $ttitle"
    echo "       owner: $towner | status: $tstatus | 匹配度: $score"
    tdir=$(find progress/tasks -maxdepth 1 -type d -name "${tid}-*" | head -1)
    if [ -f "$tdir/log.md" ]; then
      echo "       最近 log:"
      tail -3 "$tdir/log.md" | sed 's/^/         /'
    fi
    echo ""
  done

  echo "❓ 你要做的这件事是不是上面某个 task 的一部分？"
  echo "   [1-${#SORTED[@]}] 是其中某个 task 的子任务（加入协作）"
  echo "   [N] 不是，这是独立新 task"
  echo "   [Q] 取消"
  choice=$(ask "请选择：")

  case "$choice" in
    [Qq]) die "已取消"; ;;
    [Nn]) PARENT=""; ;;
    [0-9]*)
      idx=$((choice - 1))
      [ $idx -ge 0 ] && [ $idx -lt ${#SORTED[@]} ] || die "无效选择"
      IFS='|' read -r _ PARENT _ PARENT_OWNER _ <<< "${SORTED[$idx]}"
      ;;
    *) die "无效选择"; ;;
  esac
else
  ok "未发现相似进行中 task"
  PARENT=""
fi

# ─── 第 2 重对齐：如果加入已有 task，必须走对齐协议 ──────────
if [ -n "$PARENT" ]; then
  PARENT_DIR=$(find progress/tasks -maxdepth 1 -type d -name "${PARENT}-*" | head -1)
  log ""
  warn "你选择加入 $PARENT（owner: $PARENT_OWNER）"
  log ""
  log "🚨 协作对齐协议（必须全部完成才能继续）"
  log ""
  log "Step 1/3 - 阅读对齐："
  log "   请打开以下文件并读完："
  for f in spec.md plan.md log.md decisions.md; do
    [ -f "$PARENT_DIR/$f" ] && log "     $PARENT_DIR/$f"
  done
  c=$(ask "   完成了吗？[y/N]：")
  [[ "$c" =~ ^[Yy]$ ]] || die "必须读完才能继续"

  log ""
  log "Step 2/3 - 联系当前 owner ($PARENT_OWNER)："
  log "   推荐：在飞书 @$PARENT_OWNER 说明你想接哪部分，达成分工共识"
  c=$(ask "   已联系并达成共识？[y/N]：")
  [[ "$c" =~ ^[Yy]$ ]] || die "必须先联系 owner 达成共识"

  log ""
  log "Step 3/3 - 声明你的范围："
  SCOPE=$(ask "   你具体负责什么？（至少 10 字，不能与 owner 重叠）：")
  [ ${#SCOPE} -lt 10 ] && die "范围描述太短，请认真填"

  # 子任务 ID
  SUB_MAX=$(find "$PARENT_DIR/subtasks" -maxdepth 1 -type d -name "${PARENT}.*" 2>/dev/null \
    | grep -oE "${PARENT}\.[0-9]+" | grep -oE "[0-9]+$" | sort -n | tail -1)
  SUB_MAX=${SUB_MAX:-0}
  TASK_ID="${PARENT}.$((10#$SUB_MAX + 1))"
  TASK_SLUG=$(ask "   子任务短名（kebab-case，例如 opening-three-line-signal）：")
  [ -z "$TASK_SLUG" ] && die "短名不能为空"
  TASK_DIR="$PARENT_DIR/subtasks/${TASK_ID}-${TASK_SLUG}"
  IS_SUBTASK=1
else
  TASK_ID="$NEXT_ID"
  TASK_SLUG=$(ask "🏷  task 短名（kebab-case，例如 opening-method-strategy）：")
  [ -z "$TASK_SLUG" ] && die "短名不能为空"
  TASK_DIR="progress/tasks/${TASK_ID}-${TASK_SLUG}"
  IS_SUBTASK=0
fi

# ─── 创建目录和模板文件 ─────────────────────────────────────
log ""
log "📁 创建：$TASK_DIR"
mkdir -p "$TASK_DIR"
TESTS_DIR="tests/${TASK_ID}"
mkdir -p "$TESTS_DIR"
touch "$TESTS_DIR/.gitkeep"

TODAY=$(date +%Y-%m-%d)
NOW=$(date +%Y-%m-%dT%H:%M:%S)

# README.md
cat > "$TASK_DIR/README.md" << EOF
# $TASK_ID: $DESC

## 任务描述
$DESC

## 验收标准
- [ ] 见 spec.md

## 关联资源
$([ $IS_SUBTASK -eq 1 ] && echo "- 父任务：$PARENT" || echo "- 独立 task")
- Tests: $TESTS_DIR/
EOF

# spec.md (从模板复制)
if [ -f progress/tasks/T-000-example-task/spec.md ]; then
  cp progress/tasks/T-000-example-task/spec.md "$TASK_DIR/spec.md"
  sed -i "s/T-XXX/$TASK_ID/g; s/<任务名>/$DESC/g" "$TASK_DIR/spec.md"
fi

# plan.md (从模板复制)
if [ -f progress/tasks/T-000-example-task/plan.md ]; then
  cp progress/tasks/T-000-example-task/plan.md "$TASK_DIR/plan.md"
  sed -i "s/T-XXX/$TASK_ID/g; s/<任务名>/$DESC/g" "$TASK_DIR/plan.md"
fi

# log.md
cat > "$TASK_DIR/log.md" << EOF
# $TASK_ID 工作日志

> 时间倒序，最新的在最上面。

## $TODAY by $CURRENT_USER
- ✨ 任务创建
$([ $IS_SUBTASK -eq 1 ] && echo "- 作为 $PARENT 的子任务" || echo "")
$([ $IS_SUBTASK -eq 1 ] && echo "- 协作范围：$SCOPE" || echo "")
- 状态：spec-todo（等待填写 spec.md）
EOF

# decisions.md
cat > "$TASK_DIR/decisions.md" << EOF
# $TASK_ID 任务相关决策

> 任务级别的小决策记录在这里。
> 影响整体架构的大决策应该写到根目录 \`decisions/ADR-XXX-*.md\`。
EOF

# collaborators.json（升级版的 owner.txt）
if [ $IS_SUBTASK -eq 1 ]; then
  cat > "$TASK_DIR/collaborators.json" << EOF
{
  "task_id": "$TASK_ID",
  "parent_task": "$PARENT",
  "primary_owner": "$CURRENT_USER",
  "scope": "$SCOPE",
  "collaborators": [
    {"name": "$CURRENT_USER", "role": "owner", "joined": "$TODAY", "scope": "$SCOPE"}
  ],
  "last_sync": "$NOW",
  "sync_log": [
    {"date": "$TODAY", "actor": "$CURRENT_USER", "type": "create", "note": "创建子任务，已与 $PARENT_OWNER 对齐"}
  ]
}
EOF
else
  cat > "$TASK_DIR/collaborators.json" << EOF
{
  "task_id": "$TASK_ID",
  "primary_owner": "$CURRENT_USER",
  "collaborators": [
    {"name": "$CURRENT_USER", "role": "owner", "joined": "$TODAY", "scope": "整体"}
  ],
  "last_sync": "$NOW",
  "sync_log": [
    {"date": "$TODAY", "actor": "$CURRENT_USER", "type": "create", "note": "任务创建"}
  ]
}
EOF
fi

# 兼容 v1.1：保留 owner.txt
echo "$CURRENT_USER" > "$TASK_DIR/owner.txt"

# ─── 更新 feature_list.json ─────────────────────────────────
python3 - << PYEOF
import json
with open('feature_list.json') as f:
    d = json.load(f)
d['features'].append({
    "id": "$TASK_ID",
    "title": "$DESC",
    "priority": "$([ $IS_SUBTASK -eq 1 ] && echo "P-inherit" || echo "P2")",
    "status": "spec-todo",
    "owner": "$CURRENT_USER",
    "parent": "$([ $IS_SUBTASK -eq 1 ] && echo "$PARENT" || echo "")",
    "scope": "$([ $IS_SUBTASK -eq 1 ] && echo "$SCOPE" || echo "")",
    "created": "$TODAY"
})
d['updated'] = "$TODAY"
with open('feature_list.json', 'w') as f:
    json.dump(d, f, ensure_ascii=False, indent=2)
PYEOF

# 更新 progress/daily/
DAILY="progress/daily/${TODAY}-${CURRENT_USER}.md"
if [ ! -f "$DAILY" ]; then
  cat > "$DAILY" << EOF
# $TODAY — $CURRENT_USER

## 本次目标

## 工作记录
- $(date +%H:%M) 创建 task $TASK_ID: $DESC
EOF
else
  echo "- $(date +%H:%M) 创建 task $TASK_ID: $DESC" >> "$DAILY"
fi

# ─── 完成 ───────────────────────────────────────────────────
log ""
ok "已创建 $TASK_ID"
log ""
log "📁 文件清单："
log "   $TASK_DIR/README.md"
log "   $TASK_DIR/spec.md      ⭐ 下一步：填这个"
log "   $TASK_DIR/plan.md"
log "   $TASK_DIR/log.md"
log "   $TASK_DIR/decisions.md"
log "   $TASK_DIR/collaborators.json"
log "   $TESTS_DIR/.gitkeep"
log ""
log "🎯 下一步流程："
log "   1. 填 $TASK_DIR/spec.md → 找产品/Leader review"
log "   2. spec 通过 → 填 plan.md → 找技术 Lead review"
log "   3. plan 通过 → 在 $TESTS_DIR/ 写测试"
log "   4. 测试就绪 → AI 写代码 → 让所有测试通过"
log "   5. PR + commit message: [$TASK_ID] feat: ..."
log ""
