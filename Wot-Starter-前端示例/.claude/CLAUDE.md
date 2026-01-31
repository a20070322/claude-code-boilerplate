# Claude Code 项目规范

## 项目概述

这是一个基于 Wot Starter (uni-app + Vue3 + Wot UI) 的前端项目配置模板，演示如何使用 Claude Code 进行高效的多端前端开发。

## 技术栈

### 核心框架
- **框架**: uni-app (跨平台开发)
- **语言**: Vue 3.4 + TypeScript 5.5
- **构建工具**: Vite 5.2
- **包管理器**: pnpm 9.9

### UI 与样式
- **UI 组件库**: wot-design-uni (70+ 高质量组件)
- **样式方案**: UnoCSS (原子化 CSS)
- **图标**: UnoCSS Iconify (i-carbon-*)

### 状态与路由
- **状态管理**: Pinia 2.3
- **路由**: @wot-ui/router (轻量级路由库)

### 网络请求
- **HTTP 客户端**: Alova.js
- **Mock**: @alova/mock

### 开发工具
- **代码规范**: ESLint
- **提交规范**: Commitizen + Commitlint
- **自动导入**: unplugin-auto-import

## 核心规范

### 三层架构
```
组件层 (Pages/Components) → 逻辑层 (Composables/Store) → 数据层 (API)
```

### 命名规范
- **页面**: 小写 + 短横线 (user-profile, order-list)
- **组件**: 大驼峰 (UserProfile, OrderCard)
- **Composable**: use 前缀 + 大驼峰 (useUser, useOrder)
- **Store**: use + 大驼峰 + Store 后缀 (useUserStore)
- **API**: 小驼峰 (getUserInfo, createOrder)

### 代码规范
- 必须使用 `<script setup>` 语法
- 必须使用 UnoCSS 原子化样式
- 必须使用 wot-design-uni 组件
- 必须使用 `useRouter()` 进行导航
- 必须使用 `GlobalToast/Message/Loading` 处理交互
- 必须使用 Alova 发送请求
- 必须使用 Pinia 管理状态

### 禁止事项
- ❌ 禁止使用 `uni.showToast` (使用 `useGlobalToast()`)
- ❌ 禁止使用 `uni.navigateTo` (使用 `router.push()`)
- ❌ 禁止使用 `uni.request` (使用 Alova)
- ❌ 禁止在 Store 中调用 `uni.xxx` API
- ❌ 禁止在组件中写复杂的业务逻辑
- ❌ 禁止使用非 UnoCSS 的复杂样式
- ❌ 禁止使用 `BeanUtil.copyProperties()` 类似的工具

## 快捷命令

### /page
创建 uni-app 页面，支持主包和分包

**使用**:
```
/page 创建用户设置页面
/page 添加订单详情页面到 subPages 分包
```

### /api
创建 Alova API 模块和 Mock 数据

**使用**:
```
/api 创建用户相关的 API
/api 添加订单查询和创建接口
```

### /store
创建 Pinia Store

**使用**:
```
/store 创建用户状态管理
/store 添加购物车 Store
```

### /component
创建 Vue 组件

**使用**:
```
/component 创建用户头像组件
/component 添加订单卡片组件
```

### /check
代码规范检查

**使用**:
```
check                  # 检查所有变更
check <文件/目录>      # 检查指定文件
check --fix           # 自动修复
```

## 技能 (Skills)

项目包含以下专业技能，会根据任务自动激活：

### 页面开发
- **uni-page-generator**: 页面生成规范
- **wot-router-usage**: 路由导航指南

### 状态管理
- **pinia-store-generator**: Pinia Store 规范

### API 开发
- **alova-api-module**: API 模块创建

### 组件开发
- **vue-composable-creator**: 组合式函数创建

### 交互反馈
- **global-feedback**: 全局反馈组件使用

## 代理 (Agents)

### @code-reviewer
代码审查代理，用于审查代码质量

**触发方式**:
- 完成代码后手动触发
- 手动调用: `@code-reviewer`

**审查内容**:
- 样式规范 (UnoCSS, wot-design-uni)
- API 使用 (Alova, 错误处理)
- 状态管理 (Pinia 规范)
- 路由使用 (@wot-ui/router)
- 组件规范 (Vue 3 Composition API)
- 代码质量 (TypeScript, ESLint)

### @project-manager
项目管理代理，维护项目状态和待办事项

**触发方式**:
- `/update-status`
- `/add-todo`
- 手动调用: `@project-manager`

**管理内容**:
- 项目进度
- 待办清单
- 问题跟踪
- 进度报告

## 开发流程

### 新功能开发
```
1. 用户提出需求
2. AI 评估并激活相关技能
3. 使用 /page、/api、/store 等命令创建代码
4. 按照技能规范编写代码
5. 使用 @code-reviewer 审查代码
6. 使用 /check 检查规范
7. 提交代码
```

### 快速创建页面
```
1. 使用 /page 创建页面
2. 使用 /api 创建接口
3. 使用 /store 创建状态管理
4. 编写页面逻辑
5. 测试功能
6. 提交代码
```

### 代码审查流程
```
1. 完成功能开发
2. 使用 @code-reviewer 审查
3. 根据反馈修复问题
4. 使用 /check 最终检查
5. 提交代码
```

## 代码检查清单

### 提交前必查
- [ ] 代码符合项目规范
- [ ] 使用 UnoCSS 原子化样式
- [ ] 使用 wot-design-uni 组件
- [ ] 使用 Alova 发送请求
- [ ] 使用 Pinia 管理状态
- [ ] 使用 `useRouter()` 导航
- [ ] 使用 `GlobalFeedback` 处理交互
- [ ] 已通过 /check 检查
- [ ] 已通过 @code-reviewer 审查
- [ ] 功能测试通过
- [ ] 运行 `pnpm type-check` 无错误
- [ ] 运行 `pnpm lint:fix` 无警告

## 常见问题

### Q: AI 不遵守项目规范?
A: 检查 `hooks/user-prompt-submit.mjs` 是否正常工作，确保技能正确激活

### Q: 代码审查太严格?
A: code-reviewer 会区分严重程度，严重问题必须修复，建议问题可以选择性修复

### Q: 如何添加新的技能?
A: 在 `.claude/skills/` 目录下创建新目录和 `SKILL.md` 文件

### Q: 如何自定义命令?
A: 在 `.claude/commands/` 目录下创建 `.md` 文件

## 最佳实践

1. **使用快捷命令**: 优先使用 /page、/api、/store 等命令，而不是直接描述需求
2. **及时审查**: 每次完成代码后使用 @code-reviewer 审查
3. **保持同步**: 定期使用 /update-status 更新项目状态
4. **遵循规范**: 严格遵守三层架构和命名规范
5. **测试驱动**: 编写代码前先考虑测试用例

## 项目结构

```
.
├── .claude/              # Claude Code 配置
│   ├── settings.json     # 核心配置
│   ├── CLAUDE.md         # 项目规范 (本文件)
│   ├── hooks/            # 生命周期钩子
│   │   ├── session-start.mjs
│   │   ├── user-prompt-submit.mjs
│   │   ├── pre-tool-use.mjs
│   │   └── stop.mjs
│   ├── skills/           # 专业技能
│   │   ├── uni-page-generator/
│   │   ├── alova-api-module/
│   │   ├── pinia-store-generator/
│   │   ├── global-feedback/
│   │   ├── wot-router-usage/
│   │   └── vue-composable-creator/
│   ├── commands/         # 斜杠命令
│   │   ├── page.md
│   │   ├── api.md
│   │   ├── store.md
│   │   ├── component.md
│   │   └── check.md
│   └── agents/           # 自定义代理
│       ├── code-reviewer/
│       └── project-manager/
├── src/                 # 源代码目录
│   ├── api/             # API 层
│   ├── components/      # 组件
│   ├── composables/     # 组合式函数
│   ├── layouts/         # 布局
│   ├── pages/           # 主包页面
│   ├── subPages/        # 分包页面
│   ├── store/           # 状态管理
│   └── utils/           # 工具函数
└── docs/                # 项目文档
    ├── 项目状态.md
    └── 待办清单.md
```

## 更新日志

### 2025-01-31
- 初始化 Claude Code 配置
- 创建 4 个生命周期钩子
- 创建 6 个核心技能
- 创建 5 个斜杠命令
- 创建 2 个代理

## 参考资源

- [Wot Starter 官方文档](https://starter.wot-ui.cn/)
- [wot-design-uni 组件库](https://wot-ui.cn/)
- [Alova 文档](https://alova.js.org/zh-CN/)
- [UnoCSS 文档](https://unocss.dev/)
- [Claude Code 官方文档](https://docs.anthropic.com/claude/code)
