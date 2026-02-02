#!/bin/bash

# RESTful API 验证脚本
# 验证 Controller 接口是否符合 RESTful 规范

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

# 检查 Java Controller 文件
check_controller_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo -e "${RED}文件不存在: $file${NC}"
    return 1
  fi

  echo "检查文件: $file"

  # 检查类名是否以 Controller 结尾
  if grep -q "class.*Controller" "$file"; then
    echo -e "  ${GREEN}✓${NC} 类名符合规范（Controller 后缀）"
  else
    echo -e "  ${YELLOW}⚠${NC} 类名可能不符合规范（应以 Controller 结尾）"
  fi

  # 检查是否有 @RestController 或 @Controller
  if grep -q "@RestController\|@Controller" "$file"; then
    echo -e "  ${GREEN}✓${NC} 有 Controller 注解"
  else
    echo -e "  ${RED}✗${NC} 缺少 @RestController 或 @Controller 注解"
  fi

  # 检查 URL 是否使用复数名词
  local singular_urls=$(grep -oE '@(Get|Post|Put|Delete|Request)Mapping\("[^"]*"' "$file" | grep -E '[^/]/[a-z]+([^s]|"[^"])' | grep -v '/list\|/query\|/add\|/edit\|/remove\|/export' || true)

  if [ -z "$singular_urls" ]; then
    echo -e "  ${GREEN}✓${NC} URL 使用复数名词"
  else
    echo -e "  ${YELLOW}⚠${NC} 以下 URL 可能使用了单数名词:"
    echo "$singular_urls" | while read line; do
      echo "    $line"
    done
  fi

  # 检查 HTTP 方法使用是否正确
  local get_delete=$(grep -E '@GetMapping.*delete|@GetMapping.*remove' "$file" || true)
  if [ -n "$get_delete" ]; then
    echo -e "  ${RED}✗${NC} 使用 GET 方法进行删除操作"
  fi

  local post_update=$(grep -E '@PostMapping.*update|@PostMapping.*edit' "$file" || true)
  if [ -n "$post_update" ]; then
    echo -e "  ${RED}✗${NC} 使用 POST 方法进行修改操作"
  fi

  if [ -z "$get_delete" ] && [ -z "$post_update" ]; then
    echo -e "  ${GREEN}✓${NC} HTTP 方法使用正确"
  fi

  # 检查是否有权限注解
  if grep -q "@SaCheckPermission\|@PreAuthorize" "$file"; then
    echo -e "  ${GREEN}✓${NC} 有权限控制注解"
  else
    echo -e "  ${YELLOW}⚠${NC} 可能缺少权限控制注解"
  fi

  # 检查返回类型
  if grep -q "R<\|TableDataInfo<" "$file"; then
    echo -e "  ${GREEN}✓${NC} 使用统一的返回格式"
  else
    echo -e "  ${YELLOW}⚠${NC} 可能未使用统一的返回格式"
  fi

  # 检查路径参数是否使用 @PathVariable
  local path_params=$(grep -oE '\{[a-zA-Z]+\}' "$file" | wc -l)
  local path_variable=$(grep -c "@PathVariable" "$file" || true)

  if [ "$path_params" -eq "$path_variable" ]; then
    echo -e "  ${GREEN}✓${NC} 路径参数使用 @PathVariable"
  else
    echo -e "  ${YELLOW}⚠${NC} 部分路径参数可能未使用 @PathVariable"
  fi

  # 检查请求体是否使用 @RequestBody
  if grep -q "@PostMapping\|@PutMapping" "$file"; then
    if grep -A5 "@PostMapping\|@PutMapping" "$file" | grep -q "@RequestBody"; then
      echo -e "  ${GREEN}✓${NC} 请求体使用 @RequestBody"
    else
      echo -e "  ${YELLOW}⚠${NC} POST/PUT 方法可能缺少 @RequestBody"
    fi
  fi
}

# 主检查流程
echo "========================================"
echo "RESTful API 验证"
echo "========================================"
echo ""

if [ -z "$1" ]; then
  echo "用法: $0 <Java文件/目录>"
  echo ""
  echo "示例:"
  echo "  $0 src/main/java/com/ruoyi/web/controller/system/UserController.java"
  echo "  $0 src/main/java/com/ruoyi/web/controller/"
  exit 1
fi

target="$1"

if [ -f "$target" ]; then
  # 检查单个文件
  check_controller_file "$target"
elif [ -d "$target" ]; then
  # 检查目录下所有 Java 文件
  find "$target" -name "*Controller.java" | while read file; do
    echo ""
    check_controller_file "$file"
  done
else
  echo -e "${RED}错误: 目标不存在${NC}"
  exit 1
fi

echo ""
echo "========================================"
echo "验证完成"
echo "========================================"
