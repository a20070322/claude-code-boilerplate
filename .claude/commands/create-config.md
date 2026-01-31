# /create-config - Claude Code 配置创建命令

## 描述
为任何技术栈创建完整的 Claude Code 配置模板，基于 RuoYi-Plus 和 Wot Starter 的成功经验。

## 使用方法
```
/create-config 为 React + TypeScript 项目创建配置
/create-config 为 Python + FastAPI 项目创建配置
/create-config 为 Go + Gin 项目创建配置
```

## 执行步骤

### 步骤 1: 技术栈分析
- [ ] 确定核心技术栈 (语言/框架/工具)
- [ ] 了解架构模式 (MVC/分层/微服务)
- [ ] 识别开发规范 (命名/风格/约定)
- [ ] 收集常见痛点 (新手错误/性能问题)

**需要回答的问题**:
- 这个技术栈的核心特点是什么？
- 新手最容易犯哪些错误？
- 有哪些"必须使用"和"禁止使用"的库/方法？
- 典型的开发流程是什么？

### 步骤 2: 激活配置创建技能
```
必须激活: claude-config-creator
```

### 步骤 3: 设计核心技能
根据技术栈设计 4-6 个核心技能，每个技能包含：

**必需结构**:
1. **代码模板** - 完整的、可运行的代码
2. **禁止事项** - 明确列出不能做什么 ⭐
3. **检查清单** - 可执行的检查项 ⭐

**技能分类**:
- **开发类** - CRUD开发、页面创建、API设计
- **规范类** - 代码规范、架构规范
- **辅助类** - 错误处理、性能优化、安全防护

### 步骤 4: 设计命令体系
创建 3-5 个核心命令：

**必需命令**:
- `/dev` - 标准开发流程 (多步骤)
- `/check` - 代码规范检查

**可选命令**:
- `/crud` - 快速生成代码
- `/page` - 创建页面
- `/api` - 创建API
- `/component` - 创建组件

### 步骤 5: 创建 4 个核心钩子
- `session-start.mjs` - 会话启动，展示上下文
- `user-prompt-submit.mjs` - **强制技能评估** ⭐核心
- `pre-tool-use.mjs` - 危险命令拦截
- `stop.mjs` - 任务完成总结

### 步骤 6: 创建代理系统
- `@code-reviewer` - 代码审查代理
- `@project-manager` - 项目管理代理

### 步骤 7: 编写文档
- `CLAUDE.md` - 项目规范 (总文档)
- `README.md` - 模板说明
- `使用指南.md` - 快速开始
- `docs/项目状态.md` - 进度跟踪
- `docs/待办清单.md` - 待办管理

### 步骤 8: 测试验证
- [ ] 测试钩子是否触发
- [ ] 测试技能是否激活
- [ ] 测试命令是否执行
- [ ] 测试代理是否工作

## 示例执行

用户输入:
```
/create-config 为 Next.js + TypeScript + Tailwind CSS 项目创建配置
```

AI 执行流程:
```
### 步骤 1: 技术栈分析

**核心技术栈**:
- 框架: Next.js 14 (App Router)
- 语言: TypeScript 5
- 样式: Tailwind CSS
- 状态: React Hooks + Context API

**架构特点**:
- App Router (src/app)
- Server Components 优先
- Client Pages 按需使用
- 路由即文件系统

**常见痛点**:
- Server/Client 组件混用
- 状态管理不当
- 性能优化缺失

### 步骤 2: 设计核心技能

设计 5 个核心技能:
1. next-page-generator - 页面生成 (App Router规范)
2. react-component-creator - 组件创建 (Server/Client区分)
3. api-route-creator - API路由创建
4. next-style-guide - Tailwind样式规范
5. next-performance - 性能优化

### 步骤 3: 设计命令体系

创建 4 个命令:
- /page - 创建Next.js页面
- /api - 创建API路由
- /component - 创建React组件
- /check - 代码规范检查

### 步骤 4: 生成配置文件

[生成完整的配置...]

### 步骤 5: 测试验证

[提供测试步骤...]
```

## 输出成果

完成后的目录结构:
```
{技术栈}-示例/
├── .claude/
│   ├── settings.json
│   ├── CLAUDE.md
│   ├── hooks/
│   │   ├── session-start.mjs
│   │   ├── user-prompt-submit.mjs  ⭐核心
│   │   ├── pre-tool-use.mjs
│   │   └── stop.mjs
│   ├── skills/
│   │   ├── {skill-1}/
│   │   ├── {skill-2}/
│   │   └── ...
│   ├── commands/
│   │   ├── {command-1}.md
│   │   └── ...
│   └── agents/
│       ├── code-reviewer/
│       └── project-manager/
├── docs/
│   ├── 项目状态.md
│   └── 待办清单.md
├── README.md
├── 使用指南.md
└── .gitignore
```

## 关键成功要素

### ⭐ 必须包含
1. **强制技能评估** - user-prompt-submit Hook
2. **禁止事项** - 每个技能明确列出
3. **检查清单** - 每个技能可执行的检查项
4. **完整模板** - 代码模板完整可运行
5. **代理系统** - 代码审查和项目管理

### 常见错误
- ❌ 只提供文档，不提供强制机制
- ❌ 技能只有模板，没有禁止事项
- ❌ 命令只有描述，没有详细步骤
- ❌ 缺少代码审查代理
- ❌ 文档不完整

## 注意事项
1. 配置质量 > 技能数量
2. 禁止事项比代码模板更重要
3. 强制评估是核心机制
4. 代理是质量保障
5. 文档是知识沉淀
