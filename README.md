# Claude Code Boilerplate

Claude Code 工作空间模板库，提供各种开箱即用的配置模板。

## 简介

这是一个 Claude Code 配置模板集合，每个目录都是一个独立的工作空间，包含完整的 `.claude` 配置文件。你可以根据项目类型选择合适的模板，直接复制使用。

## 模板列表

### 通用最佳实践 (推荐)

适用于各种类型软件项目的通用配置，包含开箱即用的最佳实践。

**包含内容**：
- 4 个生命周期钩子 (会话启动、技能评估、危险命令拦截、任务完成总结)
- 5 个专业技能 (代码规范、异常处理、安全防护、性能优化、Bug 排查)
- 1 个斜杠命令 (`/dev` - 7步智能开发流程)
- 2 个代理 (代码审查、项目管理)

**使用方法**：
```bash
# 复制根目录的 .claude 文件夹到你的项目
cp -r .claude /path/to/your/project/
```

**适用场景**：任何需要规范化开发的软件项目

### RuoYi-Plus-示例

RuoYi-Plus 框架专用配置，适合使用 RuoYi Plus 框架的 Java 后端项目。

**包含内容**：
- 4 个生命周期钩子
- 4 个专业技能（CRUD开发、API设计、数据库操作、代码规范）
- 3 个斜杠命令（`/dev`、`/crud`、`/check`）
- 2 个代理（代码审查、项目管理）

**技术栈**：Spring Boot 3.x + MyBatis-Plus + Vue 3 + Element Plus

### hook-示例

Hook 配置示例，展示如何使用生命周期钩子。

**适用场景**：学习 Hook 机制，自定义钩子逻辑

## 快速开始

### 1. 选择模板

浏览模板列表，找到适合你项目的模板。

### 2. 复制配置

将模板目录下的 `.claude` 文件夹复制到你的项目根目录：

```bash
# 例如使用 RuoYi-Plus 模板
cp -r RuoYi-Plus-示例/.claude /path/to/your/project/
```

### 3. 启动 Claude Code

在你的项目目录下启动 Claude Code，配置自动生效。

## 自定义配置

### 修改模板

复制模板后，可以根据项目需求修改配置：

- `.claude/settings.json` - 核心配置
- `.claude/CLAUDE.md` - 项目规范
- `.claude/hooks/` - 生命周期钩子
- `.claude/skills/` - 专业技能
- `.claude/commands/` - 斜杠命令
- `.claude/agents/` - 自定义代理

### 创建新模板

基于现有模板创建新的工作空间：

1. 复制任意模板目录
2. 修改 `.claude` 配置文件
3. 更新文档说明

## 模板规范

每个模板目录应包含：

```
模板名称/
├── .claude/              # Claude Code 配置目录
│   ├── settings.json     # 核心配置
│   ├── CLAUDE.md         # 项目规范
│   ├── hooks/            # 生命周期钩子
│   ├── skills/           # 专业技能
│   ├── commands/         # 斜杠命令
│   └── agents/           # 自定义代理
├── README.md             # 模板说明
└── docs/                 # 相关文档（可选）
```

## 贡献模板

欢迎提交新的模板！

### 模板要求

- 包含完整的 `.claude` 配置
- 提供 README.md 说明文档
- 注明适用场景和技术栈
- 配置文件格式正确

### 提交方式

1. Fork 本仓库
2. 创建新的模板目录
3. 提交 Pull Request

## 参考资源

- [博客文章：25% → 90%！别让 Skills 吃灰](https://blog.csdn.net/leoisaking/article/details/156203326)
- [视频教程](https://www.bilibili.com/video/BV1rnBKB2EME/)
- [Claude Code 官方文档](https://docs.anthropic.com/claude/code)

## 许可证

MIT License

## 致谢

感谢原作者 [抓蛙师](https://blog.csdn.net/leoisaking) 分享的最佳实践！
