# Claude Code Boilerplate

一个完整的 Claude Code 工程化实践示例项目,通过 Hooks + Skills + Commands + Agents 协同激活 AI 全部能力。

## 简介

本项目基于博客文章 [《25% → 90%！别让 Skills 吃灰: Hooks + Commands + Agents 协同激活 AI 全部能力》](https://blog.csdn.net/leoisaking/article/details/156203326) 实现,展示了如何通过配置体系将 AI 技能激活率从 **25% 提升到 90%+**。

## 核心特性

- **4 个生命周期钩子** - SessionStart、UserPromptSubmit、PreToolUse、Stop
- **26 个专业技能** - CRUD开发、API设计、数据库操作、代码规范等
- **3 个斜杠命令** - `/dev`、`/crud`、`/check`
- **2 个自定义代理** - 代码审查、项目管理

## 项目结构

```
.
├── RuoYi-Plus-示例/          # RuoYi-Plus 框架示例
│   └── .claude/              # Claude Code 配置目录
│       ├── hooks/            # 生命周期钩子
│       ├── skills/           # 专业技能
│       ├── commands/         # 斜杠命令
│       └── agents/           # 自定义代理
├── hook-示例/                # Hook 配置示例
└── README.md                 # 本文件
```

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/a20070322/claude-code-boilerplate.git
cd claude-code-boilerplate/RuoYi-Plus-示例
```

### 2. 启动 Claude Code

在项目目录下启动 Claude Code,会话启动时会自动触发 `session-start` 钩子。

### 3. 使用快捷命令

```bash
# 7步智能开发流程
/dev 开发用户管理功能

# 一键生成CRUD代码
crud bus_coupon

# 代码规范检查
check
```

## 效果数据

| 指标 | 优化前 | 优化后 | 提升 |
|------|--------|--------|------|
| **技能激活率** | ~25% | 90%+ | +260% |
| **CRUD开发** | 2-4小时 | 5-10分钟 | -95% |
| **代码问题** | 5-10个/模块 | 0-2个/模块 | -80% |
| **危险操作** | 偶发 | 0次 | -100% |
| **上手周期** | 1-2周 | 2-3天 | -75% |

## 技术栈

- **后端**: Spring Boot 3.x + MyBatis-Plus
- **前端**: Vue 3 + TypeScript + Element Plus
- **移动端**: UniApp + WD UI

## 参考资源

- [博客文章](https://blog.csdn.net/leoisaking/article/details/156203326)
- [视频教程](https://www.bilibili.com/video/BV1rnBKB2EME/)
- [Claude Code 官方文档](https://docs.anthropic.com/claude/code)

## 许可证

MIT License

## 致谢

感谢原作者 [抓蛙师](https://blog.csdn.net/leoisaking) 分享的最佳实践!
