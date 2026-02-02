#!/bin/bash

# SQL 脚本验证脚本
# 验证 SQL 脚本是否符合数据库规范

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查函数
check() {
  local name="$1"
  local command="$2"

  echo -n "检查 $name... "

  if eval "$command" &> /dev/null; then
    echo -e "${GREEN}✓ 通过${NC}"
    return 0
  else
    echo -e "${RED}✗ 失败${NC}"
    return 1
  fi
}

# 检查 SQL 文件
check_sql_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo -e "${RED}文件不存在: $file${NC}"
    return 1
  fi

  echo "检查文件: $file"

  # 检查表命名（小写+下划线）
  if grep -E "CREATE TABLE [`']?[A-Z]" "$file" | grep -v "COMMENT"; then
    echo -e "  ${YELLOW}⚠${NC} 表名可能使用了大写字母或驼峰命名"
  else
    echo -e "  ${GREEN}✓${NC} 表名符合规范（小写+下划线）"
  fi

  # 检查是否使用 BIGINT 主键
  if grep -E "PRIMARY KEY.*\bINT\b" "$file" | grep -v "BIGINT"; then
    echo -e "  ${YELLOW}⚠${NC} 主键不是 BIGINT，可能不支持雪花 ID"
  else
    echo -e "  ${GREEN}✓${NC} 主键使用 BIGINT"
  fi

  # 检查是否有字符集配置
  if grep -q "CHARSET=utf8mb4" "$file"; then
    echo -e "  ${GREEN}✓${NC} 配置了字符集 utf8mb4"
  else
    echo -e "  ${YELLOW}⚠${NC} 未配置 utf8mb4 字符集"
  fi

  # 检查是否有字段注释
  local total_fields=$(grep -o "COMMENT '[^']*'" "$file" | wc -l)
  local comment_lines=$(grep -o "COMMENT '[^']*'" "$file" | wc -l)

  if [ "$comment_lines" -gt 0 ]; then
    echo -e "  ${GREEN}✓${NC} 字段有注释 ($comment_lines 个)"
  else
    echo -e "  ${RED}✗${NC} 缺少字段注释"
  fi

  # 检查是否有通用字段
  local required_fields="create_time|update_time|remark"
  for field in $(echo $required_fields | tr '|' ' '); do
    if grep -q "\`$field\`" "$file"; then
      echo -e "  ${GREEN}✓${NC} 包含通用字段: $field"
    else
      echo -e "  ${YELLOW}⚠${NC} 缺少通用字段: $field"
    fi
  done

  # 检查是否使用了外键约束
  if grep -qi "FOREIGN KEY" "$file"; then
    echo -e "  ${RED}✗${NC} 使用了外键约束（影响性能）"
  else
    echo -e "  ${GREEN}✓${NC} 未使用外键约束"
  fi
}

# 主检查流程
echo "========================================"
echo "SQL 脚本验证"
echo "========================================"
echo ""

if [ -z "$1" ]; then
  echo "用法: $0 <sql文件/目录>"
  echo ""
  echo "示例:"
  echo "  $0 sql/coupon.sql"
  echo "  $0 sql/"
  exit 1
fi

target="$1"

if [ -f "$target" ]; then
  # 检查单个文件
  check_sql_file "$target"
elif [ -d "$target" ]; then
  # 检查目录下所有 SQL 文件
  find "$target" -name "*.sql" | while read file; do
    echo ""
    check_sql_file "$file"
  done
else
  echo -e "${RED}错误: 目标不存在${NC}"
  exit 1
fi

echo ""
echo "========================================"
echo "验证完成"
echo "========================================"
