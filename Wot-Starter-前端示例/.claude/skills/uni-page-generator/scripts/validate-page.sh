#!/bin/bash

# uni-app 页面验证脚本
# 验证页面文件是否符合 Wot Starter 项目规范

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

# 检查 Vue 页面文件
check_page_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo -e "${RED}文件不存在: $file${NC}"
    return 1
  fi

  echo "检查文件: $file"

  # 检查文件名是否为 index.vue
  if [[ $(basename "$file") == "index.vue" ]]; then
    echo -e "  ${GREEN}✓${NC} 文件名正确（index.vue）"
  else
    echo -e "  ${RED}✗${NC} 文件名错误，应为 index.vue"
  fi

  # 检查是否使用 <script setup>
  if grep -q "<script setup" "$file"; then
    echo -e "  ${GREEN}✓${NC} 使用 script setup 语法"
  else
    echo -e "  ${RED}✗${NC} 未使用 script setup 语法"
  fi

  # 检查是否配置了 definePage
  if grep -q "definePage" "$file"; then
    echo -e "  ${GREEN}✓${NC} 配置了 definePage 宏"

    # 检查是否配置了 name
    if grep -q "name:" "$file"; then
      echo -e "  ${GREEN}✓${NC} 配置了路由 name"
    else
      echo -e "  ${YELLOW}⚠${NC} 未配置路由 name"
    fi

    # 检查是否配置了 layout
    if grep -q "layout:" "$file"; then
      echo -e "  ${GREEN}✓${NC} 配置了 layout"
    else
      echo -e "  ${YELLOW}⚠${NC} 未配置 layout"
    fi

    # 检查是否配置了导航栏标题
    if grep -q "navigationBarTitleText" "$file"; then
      echo -e "  ${GREEN}✓${NC} 配置了导航栏标题"
    else
      echo -e "  ${YELLOW}⚠${NC} 未配置导航栏标题"
    fi
  else
    echo -e "  ${RED}✗${NC} 未配置 definePage 宏"
  fi

  # 检查是否使用了 useRouter
  if grep -q "useRouter()" "$file"; then
    echo -e "  ${GREEN}✓${NC} 使用 useRouter() 进行导航"
  else
    # 如果页面中有路由跳转但没有使用 useRouter
    if grep -q "router\." "$file" && ! grep -q "useRouter()" "$file"; then
      echo -e "  ${YELLOW}⚠${NC} 使用了 router 但可能未调用 useRouter()"
    fi
  fi

  # 检查是否错误地使用了 uni.navigateTo
  if grep -q "uni.navigateTo" "$file"; then
    echo -e "  ${RED}✗${NC} 使用了 uni.navigateTo（应该使用 useRouter）"
  else
    echo -e "  ${GREEN}✓${NC} 未使用 uni.navigateTo"
  fi

  # 检查是否使用了 <style> 标签
  if grep -q "<style" "$file"; then
    # 检查是否是 scoped
    if grep -q "<style scoped" "$file"; then
      echo -e "  ${YELLOW}⚠${NC} 使用了 style 标签（推荐使用 UnoCSS）"
    fi
  else
    echo -e "  ${GREEN}✓${NC} 未使用 style 标签（符合 UnoCSS 规范）"
  fi

  # 检查是否使用了 UnoCSS 原子化类
  if grep -q "class=\"[a-z]-[" "$file" || grep -q "class='" "$file"; then
    echo -e "  ${GREEN}✓${NC} 使用了 UnoCSS 原子化类"
  fi
}

# 主检查流程
echo "========================================"
echo "uni-app 页面验证"
echo "========================================"
echo ""

if [ -z "$1" ]; then
  echo "用法: $0 <Vue文件/目录>"
  echo ""
  echo "示例:"
  echo "  $0 src/pages/user/index.vue"
  echo "  $0 src/subPages/"
  exit 1
fi

target="$1"

if [ -f "$target" ]; then
  # 检查单个文件
  check_page_file "$target"
elif [ -d "$target" ]; then
  # 检查目录下所有 Vue 文件
  find "$target" -name "index.vue" | while read file; do
    echo ""
    check_page_file "$file"
  done
else
  echo -e "${RED}错误: 目标不存在${NC}"
  exit 1
fi

echo ""
echo "========================================"
echo "验证完成"
echo "========================================"
