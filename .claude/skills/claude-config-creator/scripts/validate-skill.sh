#!/bin/bash

# Skill 文件格式验证脚本
# 验证单个 Skill 文件是否符合官方标准

SKILL_FILE="$1"

if [ -z "$SKILL_FILE" ]; then
  echo "用法: $0 <skill-file-path>"
  exit 1
fi

if [ ! -f "$SKILL_FILE" ]; then
  echo "错误: 文件不存在: $SKILL_FILE"
  exit 1
fi

echo "验证 Skill 文件: $SKILL_FILE"
echo "========================================"

# 检查文件是否为 markdown
if [[ ! "$SKILL_FILE" =~ \.md$ ]]; then
  echo "❌ 错误: 文件必须是 .md 格式"
  exit 1
fi

echo "✓ 文件格式正确 (.md)"

# 读取文件内容
content=$(cat "$SKILL_FILE")

# 检查 YAML 前置元数据
if [[ ! "$content" =~ ^"---"$ ]]; then
  echo "❌ 错误: 缺少 YAML 前置元数据起始标记 (---)"
  exit 1
fi

echo "✓ 有 YAML 前置元数据起始标记"

# 提取 YAML 内容
yaml_content=$(sed -n '/^---$/,/^---$/p' "$SKILL_FILE" | head -n -1)

if [ -z "$yaml_content" ]; then
  echo "❌ 错误: YAML 前置元数据为空"
  exit 1
fi

echo "✓ YAML 前置元数据不为空"

# 检查 name 字段
if [[ ! "$yaml_content" =~ ^name: ]]; then
  echo "❌ 错误: 缺少必需字段 'name'"
  exit 1
fi

name_value=$(echo "$yaml_content" | grep "^name:" | cut -d':' -f2 | xargs)

if [ -z "$name_value" ]; then
  echo "❌ 错误: 'name' 字段值为空"
  exit 1
fi

echo "✓ name 字段存在: $name_value"

# 检查 name 字段格式（小写字母、数字、连字符）
if [[ ! "$name_value" =~ ^[a-z0-9-]+$ ]]; then
  echo "⚠️  警告: 'name' 应该只包含小写字母、数字和连字符"
fi

# 检查 name 长度
if [ ${#name_value} -gt 64 ]; then
  echo "❌ 错误: 'name' 字段超过 64 个字符（当前: ${#name_value}）"
  exit 1
fi

echo "✓ name 字段格式正确"

# 检查保留字
reserved_words=("anthropic" "claude")
for word in "${reserved_words[@]}"; do
  if [[ "$name_value" == *"$word"* ]]; then
    echo "❌ 错误: 'name' 字段包含保留字 '$word'"
    exit 1
  fi
done

echo "✓ name 字段不包含保留字"

# 检查 description 字段
if [[ ! "$yaml_content" =~ ^description: ]]; then
  echo "❌ 错误: 缺少必需字段 'description'"
  exit 1
fi

desc_value=$(echo "$yaml_content" | grep "^description:" | cut -d':' -f2- | xargs)

if [ -z "$desc_value" ]; then
  echo "❌ 错误: 'description' 字段值为空"
  exit 1
fi

echo "✓ description 字段存在"

# 检查 description 长度
if [ ${#desc_value} -gt 1024 ]; then
  echo "❌ 错误: 'description' 字段超过 1024 个字符（当前: ${#desc_value}）"
  exit 1
fi

echo "✓ description 字段长度正确 (${#desc_value} 字符)"

# 检查 description 是否包含触发条件
if [[ ! "$desc_value" =~ [Ww]hen ]] && [[ ! "$desc_value" =~ [Uu]se ]]; then
  echo "⚠️  警告: 'description' 应该说明何时使用该 Skill"
fi

# 检查主要内容区域
main_content=$(sed -n '/^---$/,/^---$/p' "$SKILL_FILE" | tail -n +2 | sed '1d')

if [ -z "$main_content" ]; then
  echo "❌ 错误: Skill 缺少主要内容"
  exit 1
fi

echo "✓ 主要内容存在"

# 检查是否有章节标题
if [[ ! "$main_content" =~ ^# ]]; then
  echo "⚠️  警告: 主要内容缺少章节标题 (#)"
fi

echo ""
echo "========================================"
echo "✓ 所有检查通过！"
echo "========================================"
echo ""
echo "Skill 信息:"
echo "  名称: $name_value"
echo "  描述: $desc_value"
echo "  文件: $SKILL_FILE"
