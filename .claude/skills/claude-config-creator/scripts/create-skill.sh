#!/bin/bash

# Skill 骨架创建脚本
# 快速创建符合官方标准的 Skill 骨架

if [ -z "$1" ]; then
  echo "用法: $0 <skill-name> [description]"
  echo ""
  echo "示例:"
  echo "  $0 crud-development 'CRUD 开发技能，用于创建标准的增删改查功能'"
  exit 1
fi

SKILL_NAME="$1"
DESCRIPTION="${2:-请添加技能描述}"

# 验证 skill name 格式
if [[ ! "$SKILL_NAME" =~ ^[a-z0-9-]+$ ]]; then
  echo "❌ 错误: skill-name 只能包含小写字母、数字和连字符"
  exit 1
fi

# 创建目录
SKILL_DIR=".claude/skills/$SKILL_NAME"
mkdir -p "$SKILL_DIR"

# 创建 SKILL.md
cat > "$SKILL_DIR/SKILL.md" << EOF
---
name: $SKILL_NAME
description: $DESCRIPTION
---

# ${SKILL_NAME^}

## 使用场景
[描述在什么情况下会触发这个技能]

## 核心规范
### 规范1：[规范名称]
[详细说明]
- 要点1
- 要点2

代码示例：
\`\`\`[language]
[示例代码]
\`\`\`

## 禁止事项 ⭐重要
- ❌ 不要做X（说明原因）
- ❌ 不要使用Y方法（应该用Z）

## 检查清单 ⭐重要
- [ ] 检查项1
- [ ] 检查项2

## 注意事项
[其他重要说明]
EOF

# 创建 examples 目录
mkdir -p "$SKILL_DIR/examples"

# 创建示例文件
cat > "$SKILL_DIR/examples/typical-output.md" << EOF
# 典型输出示例

[展示使用该技能后的预期输出格式]
EOF

# 创建 scripts 目录
mkdir -p "$SKILL_DIR/scripts"

# 创建验证脚本（如果需要）
cat > "$SKILL_DIR/scripts/validate.sh" << EOF
#!/bin/bash
# $SKILL_NAME 验证脚本

echo "验证 $SKILL_NAME 相关配置..."
# 添加验证逻辑
EOF

chmod +x "$SKILL_DIR/scripts/validate.sh"

echo "✓ Skill 骨架创建成功！"
echo ""
echo "创建的文件:"
echo "  $SKILL_DIR/SKILL.md"
echo "  $SKILL_DIR/examples/typical-output.md"
echo "  $SKILL_DIR/scripts/validate.sh"
echo ""
echo "下一步:"
echo "  1. 编辑 SKILL.md 完善技能内容"
echo "  2. 添加更多示例到 examples/"
echo "  3. 实现验证脚本 scripts/validate.sh"
