#!/usr/bin/env bash
#
# GitHub 仓库清理脚本 — 由 2026-07-12 的仓库审计生成（详见同目录 AUDIT.md）
#
# 用法:
#   bash repo-audit/cleanup.sh          # 逐仓库确认执行
#   DRY_RUN=1 bash repo-audit/cleanup.sh  # 只打印将执行的命令，不做任何改动
#
# 前置条件:
#   1. gh CLI 已登录:            gh auth status
#   2. 删除仓库需要额外授权:      gh auth refresh -h github.com -s delete_repo
#
# 每个仓库都会单独提示确认（y 执行 / 其他键跳过），可随时 Ctrl-C 中止。

set -euo pipefail

OWNER="arthaszyb"

# ── 删除清单：空壳仓库（0 KB，从未推送过内容，删除无损失）──────────────
DELETE_REPOS=(
  askChatGPT      # 公开, 2024-07 创建, 空
  bkLearn         # 私有, 2020-05 创建, 空
  my_ai_learning  # 公开, 2017-07 创建, 空
  markdownPIC     # 公开, 2020-08 创建, 空图床
)

# ── 归档清单：停更实验/临时仓库（只读冻结，可随时解除归档）──────────────
ARCHIVE_REPOS=(
  BankStatementAnalyzer-iOS  # 已被 Relaunch 版取代
  download_exam_papers       # 2025-05 单日脚本
  weather                    # 2025-04 单日实验
  moomoo-assist              # 2025-01 单日实验
  trade_expert               # 2025-01 单日实验
  stock-decision-assistant   # 2025-01 单日实验
  googleCalendar             # 2024-09 小工具
  myHOGO                     # 旧博客, 已被 github.io 取代
  golangNotes                # 2019 学习笔记
  k8s-notes                  # 2019 学习笔记
  rss_with_docker            # 2019 单日实验
)

DRY_RUN="${DRY_RUN:-0}"

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

confirm() {
  local prompt="$1"
  read -r -p "$prompt [y/N] " reply
  [[ "$reply" == "y" || "$reply" == "Y" ]]
}

echo "════════════════════════════════════════════════════"
echo " 仓库清理：${#DELETE_REPOS[@]} 个删除（不可逆），${#ARCHIVE_REPOS[@]} 个归档（可逆）"
[[ "$DRY_RUN" == "1" ]] && echo " 模式：DRY RUN（不会做任何改动）"
echo "════════════════════════════════════════════════════"
echo

echo "── 第 1 步：删除空壳仓库（不可逆！）──"
echo "   如未授权删除权限，请先运行: gh auth refresh -h github.com -s delete_repo"
echo
for repo in "${DELETE_REPOS[@]}"; do
  if confirm "删除 $OWNER/$repo ?"; then
    run gh repo delete "$OWNER/$repo" --yes
    echo "  ✓ 已删除 $OWNER/$repo"
  else
    echo "  - 跳过 $OWNER/$repo"
  fi
done

echo
echo "── 第 2 步：归档停更仓库（可随时解除归档）──"
echo
for repo in "${ARCHIVE_REPOS[@]}"; do
  if confirm "归档 $OWNER/$repo ?"; then
    run gh repo archive "$OWNER/$repo" --yes
    echo "  ✓ 已归档 $OWNER/$repo"
  else
    echo "  - 跳过 $OWNER/$repo"
  fi
done

echo
echo "完成。当前账号仓库状态："
run gh repo list "$OWNER" --limit 100
