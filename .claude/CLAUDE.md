# Claude Code 项目规范

## 项目概述

claude-code-boilerplate 是一个 Claude Code 工作空间模板库，提供各种开箱即用的配置模板。

## 核心工作

### 模板库维护
- 创建新的技术栈模板
- 维护现有模板
- 验证配置正确性
- 编写和更新文档

### 文档规范
- 使用统一的 Markdown 格式
- 代码块必须标注语言
- 链接必须可访问
- 提供具体示例

## 快捷命令

### /doc
文档维护命令

**使用:**
```
/doc readme     # 创建/更新 README
/doc check      # 检查文档质量
```

### /template
模板管理命令

**使用:**
```
/template create <名称>    # 创建新模板
/template validate <名称>  # 验证模板
/template list             # 更新模板列表
```

### /check
配置检查命令

**使用:**
```
check              # 检查当前配置
check <模板目录>   # 检查指定模板
```

### /explore
项目探索命令

**使用:**
```
/explore          # 探索当前项目
/explore <路径>   # 探索指定目录
```

## 技能 (Skills)

### 文档开发
- **doc-development**: 文档编写规范和流程

### 模板开发
- **template-dev**: 模板开发规范和流程
- **config-validator**: 配置验证规范

### 项目理解
- **project-explorer**: 项目探索和分析（老项目学习）

## 代理 (Agents)

### @maintainer
模板库维护代理

**触发方式:** `@maintainer`

**职责:**
- 模板验证
- 文档审查
- 配置规范检查
- 质量报告生成

## 开发流程

### 创建新模板
```
1. /template create <名称>  # 创建模板骨架
2. 编写配置文件
3. 编写文档 (README, CLAUDE.md)
4. /check                   # 验证配置
5. @maintainer              # 审查质量
6. 更新主 README
7. 提交代码
```

### 维护现有模板
```
1. @maintainer 检查所有模板
2. 修复发现的问题
3. 更新文档
4. 验证配置
5. 提交更新
```

### 学习老项目
```
1. /explore 项目目录
2. 查看探索报告
3. 理解项目结构
4. 识别技术栈
5. 找出关键文件
```

## 提交检查清单

### 提交前必查
- [ ] 配置文件格式正确
- [ ] 已通过 /check 验证
- [ ] 已通过 @maintainer 审查
- [ ] 文档完整准确
- [ ] 示例代码可运行
- [ ] 已更新主 README (如需要)

## 项目结构

```
.
├── .claude/              # Claude Code 配置
│   ├── settings.json     # 核心配置
│   ├── CLAUDE.md         # 项目规范 (本文件)
│   ├── hooks/            # 生命周期钩子
│   ├── skills/           # 专业技能
│   ├── commands/         # 斜杠命令
│   └── agents/           # 自定义代理
├── 模板1/                # 模板目录
│   └── .claude/
├── 模板2/                # 模板目录
│   └── .claude/
├── docs/                 # 项目文档
│   └── plans/            # 实现计划
└── README.md             # 主 README
```

## 最佳实践

1. **使用快捷命令**: 优先使用 /template, /doc, /check 等命令
2. **及时审查**: 创建模板后使用 @maintainer 审查
3. **保持同步**: 定期检查所有模板状态
4. **遵循规范**: 严格遵守模板开发规范
5. **测试驱动**: 确保模板可用后再提交
