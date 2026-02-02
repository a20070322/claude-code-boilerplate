#!/bin/bash

# Claude Code 配置验证脚本
# 用于验证创建的配置是否符合标准

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 计数器
total=0
passed=0
failed=0

# 检查函数
check() {
  local name="$1"
  local command="$2"

  total=$((total + 1))
  echo -n "[$total] 检查 $name... "

  if eval "$command" &> /dev/null; then
    echo -e "${GREEN}✓ 通过${NC}"
    passed=$((passed + 1))
    return 0
  else
    echo -e "${RED}✗ 失败${NC}"
    failed=$((failed + 1))
    return 1
  fi
}

# 获取项目根目录
PROJECT_ROOT="${1:-.}"
CLAUDE_DIR="$PROJECT_ROOT/.claude"

echo "========================================"
echo "Claude Code 配置验证"
echo "项目路径: $PROJECT_ROOT"
echo "========================================"
echo ""

# 检查 .claude 目录是否存在
check ".claude 目录存在" "[ -d '$CLAUDE_DIR' ]"

if [ ! -d "$CLAUDE_DIR" ]; then
  echo -e "${RED}错误: .claude 目录不存在${NC}"
  exit 1
fi

# 检查核心配置文件
check "settings.json 存在" "[ -f '$CLAUDE_DIR/settings.json' ]"
check "CLAUDE.md 存在" "[ -f '$CLAUDE_DIR/CLAUDE.md' ]"

# 检查 hooks 目录
check "hooks 目录存在" "[ -d '$CLAUDE_DIR/hooks' ]"

if [ -d "$CLAUDE_DIR/hooks" ]; then
  check "session-start hook 存在" "[ -f '$CLAUDE_DIR/hooks/session-start.mjs' -o -f '$CLAUDE_DIR/hooks/session-start.js' ]"
  check "user-prompt-submit hook 存在" "[ -f '$CLAUDE_DIR/hooks/user-prompt-submit.mjs' -o -f '$CLAUDE_DIR/hooks/user-prompt-submit.js' ]"
  check "stop hook 存在" "[ -f '$CLAUDE_DIR/hooks/stop.mjs' -o -f '$CLAUDE_DIR/hooks/stop.js' ]"
fi

# 检查 skills 目录
check "skills 目录存在" "[ -d '$CLAUDE_DIR/skills' ]"

if [ -d "$CLAUDE_DIR/skills" ]; then
  # 检查至少有一个 skill
  skill_count=$(find "$CLAUDE_DIR/skills" -mindepth 1 -maxdepth 1 -type d | wc -l)
  check "至少有 1 个 skill" "[ $skill_count -ge 1 ]"

  # 检查每个 skill 的结构
  for skill_dir in "$CLAUDE_DIR/skills"/*/; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      skill_file="$skill_dir/SKILL.md"

      # 检查 SKILL.md 是否存在
      if [ -f "$skill_file" ]; then
        # 检查 YAML 前置元数据
        if grep -q "^---" "$skill_file"; then
          echo -e "  ${GREEN}✓${NC} $skill_name 有 YAML 前置元数据"
        else
          echo -e "  ${YELLOW}⚠${NC} $skill_name 缺少 YAML 前置元数据"
        fi

        # 检查必需字段
        if grep -q "^name:" "$skill_file"; then
          echo -e "  ${GREEN}✓${NC} $skill_name 有 name 字段"
        else
          echo -e "  ${RED}✗${NC} $skill_name 缺少 name 字段"
        fi

        if grep -q "^description:" "$skill_file"; then
          echo -e "  ${GREEN}✓${NC} $skill_name 有 description 字段"
        else
          echo -e "  ${RED}✗${NC} $skill_name 缺少 description 字段"
        fi
      else
        echo -e "  ${RED}✗${NC} $skill_name 缺少 SKILL.md"
      fi
    fi
  done
fi

# 检查 commands 目录
check "commands 目录存在" "[ -d '$CLAUDE_DIR/commands' ]"

if [ -d "$CLAUDE_DIR/commands" ]; then
  command_count=$(find "$CLAUDE_DIR/commands" -name "*.md" | wc -l)
  check "至少有 1 个命令" "[ $command_count -ge 1 ]"
fi

# 检查 agents 目录（可选）
if [ -d "$CLAUDE_DIR/agents" ]; then
  echo -e "${GREEN}✓${NC} agents 目录存在（可选）"
fi

# 检查 docs 目录（可选）
if [ -d "$CLAUDE_DIR/docs" ]; then
  echo -e "${GREEN}✓${NC} docs 目录存在（可选）"
fi

# JSON 语法检查
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  check "settings.json 语法正确" "python3 -m json.tool '$CLAUDE_DIR/settings.json' > /dev/null 2>&1 || node -e 'JSON.parse(require(\"fs\").readFileSync(\"$CLAUDE_DIR/settings.json\", \"utf8\"))' > /dev/null 2>&1"
fi

echo ""
echo "========================================"
echo "验证结果汇总"
echo "========================================"
echo -e "总计: $total"
echo -e "${GREEN}通过: $passed${NC}"
echo -e "${RED}失败: $failed${NC}"

if [ $failed -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✓ 所有检查通过！${NC}"
  exit 0
else
  echo ""
  echo -e "${RED}✗ 有 $failed 项检查失败${NC}"
  exit 1
fi
