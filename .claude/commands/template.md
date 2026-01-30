# /template - 模板管理命令

## 描述
创建新模板、验证模板、更新模板列表

## 使用方法
```
/template                   # 显示模板管理菜单
/template create <名称>      # 创建新模板
/template validate <名称>    # 验证模板
/template list              # 更新模板列表
```

## 执行步骤

### 1. 显示菜单
列出可用的模板操作

### 2. 创建新模板
**步骤 1: 需求澄清**
询问:
- 模板名称
- 目标技术栈
- 适用场景
- 核心特性

**步骤 2: 创建目录结构**
```bash
mkdir -p <模板名称>/.claude/{hooks,skills,commands,agents}
```

**步骤 3: 生成配置文件**
- settings.json
- CLAUDE.md
- README.md

**步骤 4: 验证模板**
运行验证流程

### 3. 验证模板
**检查项:**
- 目录结构完整
- settings.json 格式正确
- CLAUDE.md 内容完整
- README.md 内容完整

### 4. 更新模板列表
**扫描:** 当前目录下的所有子目录
**更新主 README:** 在模板列表章节添加或更新

## 注意事项
1. 模板名称使用 kebab-case
2. 确保所有配置文件格式正确
3. README 必须清晰易懂
4. 验证通过后再更新主 README
