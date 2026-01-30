# /check - 配置检查命令

## 描述
检查 .claude 配置的正确性和完整性

## 使用方法
```
check                  # 检查当前项目配置
check <模板目录>        # 检查指定模板的配置
```

## 执行步骤

### 1. 检查目录结构
- [ ] .claude 目录存在
- [ ] settings.json 存在
- [ ] CLAUDE.md 存在

### 2. 检查配置文件
- [ ] JSON 格式正确
- [ ] hooks 配置有效
- [ ] permissions 配置有效

### 3. 检查技能定义
- [ ] 每个 skill 有 SKILL.md
- [ ] 格式符合规范

### 4. 检查命令定义
- [ ] 每个 command 是 .md 文件
- [ ] 格式符合规范

## 输出格式

```
## 🔍 配置检查报告

### 📁 目录结构
✓ .claude/ 目录存在
✓ settings.json 存在
✓ CLAUDE.md 存在

### ⚙️ 配置文件
✓ settings.json 格式正确
✓ CLAUDE.md 内容完整

### 📚 技能定义
✓ doc-development - 完整
✓ template-dev - 完整

### ⚠️ 警告
• [列出警告项]

### ✗ 错误
[列出错误项]
```
