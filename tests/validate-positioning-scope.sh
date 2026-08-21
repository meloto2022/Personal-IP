#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

forbidden='固定赛道为.?AI 自媒体|固定使用四种内容形式|前 5 条.*AI 科普|生成三套完整的小红书账号包装|小红书简介中必须|^# 小红书主页简介'
if rg -n "$forbidden" \
  "$repo_root/SKILL.md" \
  "$repo_root/README.md" \
  "$repo_root/references" \
  "$repo_root/agents/openai.yaml"; then
  echo "FAIL: fixed AI or single-platform assumptions remain" >&2
  exit 1
fi

for required in \
  '企业老板' \
  '家居建材' \
  '装修' \
  '目标客户' \
  '真实案例' \
  '抖音' \
  '小红书' \
  '视频号'; do
  rg -q "$required" "$repo_root/SKILL.md" "$repo_root/README.md" "$repo_root/references" || {
    echo "FAIL: missing required concept: $required" >&2
    exit 1
  }
done

for file in \
  README.md \
  SKILL.md \
  agents/openai.yaml \
  references/interview-guide.md \
  references/profile-bio-guide.md \
  references/output-templates.md; do
  test -s "$repo_root/$file" || {
    echo "FAIL: missing file: $file" >&2
    exit 1
  }
done

echo "PASS: enterprise-owner positioning scope is consistent"
