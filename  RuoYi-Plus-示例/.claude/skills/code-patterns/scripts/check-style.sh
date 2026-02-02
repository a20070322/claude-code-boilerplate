#!/bin/bash

# Java 代码规范检查脚本
# 检查 Java 代码是否符合项目编码规范

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

# 检查 Java 文件命名规范
check_naming() {
  local file="$1"
  local filename=$(basename "$file")

  echo "检查文件: $file"

  # 检查类名（大驼峰）
  if [[ ! "$filename" =~ ^[A-Z][a-zA-Z0-9]*\.java$ ]]; then
    echo -e "  ${YELLOW}⚠${NC} 文件名可能不符合大驼峰规范: $filename"
  else
    echo -e "  ${GREEN}✓${NC} 文件名符合大驼峰规范"
  fi

  # 提取类名
  local classname="${filename%.java}"

  # 检查文件中是否有对应的类声明
  if grep -q "class $classname" "$file"; then
    echo -e "  ${GREEN}✓${NC} 类名与文件名一致"
  else
    echo -e "  ${YELLOW}⚠${NC} 未找到类声明: class $classname"
  fi
}

# 检查方法命名（小驼峰）
check_method_naming() {
  local file="$1"

  # 查找方法定义
  local methods=$(grep -E "^\s*(public|private|protected).*\s+[a-zA-Z][a-zA-Z0-9_<>\s]*\(" "$file" | grep -v "^[[:space:]]*\*" | head -20)

  if [ -z "$methods" ]; then
    return 0
  fi

  echo "检查方法命名..."

  echo "$methods" | while read -r line; do
    # 提取方法名
    local methodname=$(echo "$line" | sed -n 's/.* \([a-zA-Z][a-zA-Z0-9_]*\)(.*/\1/p')

    if [ -z "$classname" ]; then
      continue
    fi

    # 检查是否以大写字母开头（非构造函数）
    if [[ "$classname" =~ ^[A-Z] ]] && [[ ! "$line" =~ " $classname\(" ]]; then
      echo "$line" | grep -E " [A-Z][a-z]*\(" && echo -e "  ${YELLOW}⚠${NC} 方法名应以小驼峰: $line"
    fi
  done
}

# 检查常量命名（全大写）
check_constants() {
  local file="$1"

  echo "检查常量命名..."

  # 查找 static final 字段
  local constants=$(grep -E "^\s*(public|private|protected).*static.*final.*String.*=" "$file")

  if [ -z "$constants" ]; then
    echo -e "  ${GREEN}✓${NC} 未找到常量定义"
    return 0
  fi

  echo "$constants" | while read -r line; do
    # 提取常量名
    local constname=$(echo "$line" | sed -n 's/.* \([a-zA-Z_][a-zA-Z0-9_]*\) =.*/\1/p')

    # 检查是否全大写
    if [[ "$constname" =~ ^[a-z] ]]; then
      echo -e "  ${YELLOW}⚠${NC} 常量名应全大写: $constname"
    elif [[ ! "$constname" =~ ^[A-Z_0-9]+$ ]]; then
      echo -e "  ${YELLOW}⚠${NC} 常量名应全大写+下划线: $constname"
    fi
  done
}

# 检查布尔变量命名
check_boolean_naming() {
  local file="$1"

  echo "检查布尔变量命名..."

  # 查找 boolean 类型字段
  local booleans=$(grep -E "^\s*private\s+boolean\s+[a-zA-Z][a-zA-Z0-9_]*;" "$file")

  if [ -z "$booleans" ]; then
    return 0
  fi

  echo "$booleans" | while read -r line; do
    # 提取变量名
    local varname=$(echo "$line" | sed -n 's/.*private\s+boolean\s+\([a-zA-Z][a-zA-Z0-9_]*\);.*/\1/p')

    # 检查是否有 is/has/can 前缀
    if [[ ! "$varname" =~ ^(is|has|can) ]] && [[ ! "$varname" =~ ^(enabled|disabled) ]]; then
      echo -e "  ${YELLOW}⚠${NC} 布尔变量建议使用 is/has/can 前缀: $varname"
    fi
  done
}

# 检查异常处理
check_exception_handling() {
  local file="$1"

  echo "检查异常处理..."

  # 查找空的 catch 块
  local empty_catches=$(grep -A 5 "catch.*{" "$file" | grep -E "^\s*\}\s*" | wc -l)

  if [ "$empty_catches" -gt 0 ]; then
    echo -e "  ${YELLOW}⚠${NC} 可能存在空的 catch 块"
  fi

  # 查找吞掉异常的 catch
  if grep -q "catch.*Exception.*{[\s\n]*\}" "$file"; then
    echo -e "  ${RED}✗${NC} 存在吞掉异常的 catch 块"
  fi
}

# 主检查流程
echo "========================================"
echo "Java 代码规范检查"
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
  check_naming "$target"
  check_method_naming "$target"
  check_constants "$target"
  check_boolean_naming "$target"
  check_exception_handling "$target"
elif [ -d "$target" ]; then
  # 检查目录下所有 Java 文件
  find "$target" -name "*.java" | while read file; do
    echo ""
    check_naming "$file"
    check_method_naming "$file"
    check_constants "$file"
    check_boolean_naming "$file"
    check_exception_handling "$file"
  done
else
  echo -e "${RED}错误: 目标不存在${NC}"
  exit 1
fi

echo ""
echo "========================================"
echo "检查完成"
echo "========================================"
