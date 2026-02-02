#!/bin/bash

# CRUD 代码规范验证脚本
# 验证生成的 CRUD 代码是否符合四层架构规范

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

# 检查 Java 文件是否符合规范
check_java_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo -e "${RED}文件不存在: $file${NC}"
    return 1
  fi

  echo "检查文件: $file"

  # 检查 Entity 是否继承 TenantEntity 或 BaseEntity
  if grep -q "extends TenantEntity\|extends BaseEntity" "$file"; then
    echo -e "  ${GREEN}✓${NC} Entity 继承了基类"
  else
    echo -e "  ${RED}✗${NC} Entity 未继承基类"
  fi

  # 检查 Service 是否继承了 ServiceImpl
  if grep -q "extends ServiceImpl" "$file"; then
    echo -e "  ${RED}✗${NC} Service 继承了 ServiceImpl (违反规范)"
  else
    echo -e "  ${GREEN}✓${NC} Service 未继承 ServiceImpl"
  fi

  # 检查是否使用了 MapstructUtils
  if grep -q "MapstructUtils" "$file"; then
    echo -e "  ${GREEN}✓${NC} 使用了 MapstructUtils"
  else
    echo -e "  ${YELLOW}⚠${NC} 未使用 MapstructUtils"
  fi

  # 检查是否有权限控制注解
  if grep -q "@PreAuthorize\|@SaCheckPermission" "$file"; then
    echo -e "  ${GREEN}✓${NC} 有权限控制注解"
  else
    echo -e "  ${YELLOW}⚠${NC} 缺少权限控制注解"
  fi
}

# 主检查流程
echo "========================================"
echo "CRUD 代码规范验证"
echo "========================================"
echo ""

if [ -z "$1" ]; then
  echo "用法: $0 <文件/目录>"
  echo ""
  echo "示例:"
  echo "  $0 src/main/java/com/ruoyi/system/domain/User.java"
  echo "  $0 src/main/java/com/ruoyi/system/service"
  exit 1
fi

target="$1"

if [ -f "$target" ]; then
  # 检查单个文件
  check_java_file "$target"
elif [ -d "$target" ]; then
  # 检查目录下所有 Java 文件
  find "$target" -name "*.java" | while read file; do
    check_java_file "$file"
    echo ""
  done
else
  echo -e "${RED}错误: 目标不存在${NC}"
  exit 1
fi

echo ""
echo "========================================"
echo "验证完成"
echo "========================================"
