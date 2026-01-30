# Claude Code 项目规范

## 项目概述

这是一个基于 RuoYi-Plus 框架的示例项目,演示如何使用 Claude Code 进行高效开发。

## 技术栈

### 后端
- **框架**: Spring Boot 3.x
- **ORM**: MyBatis-Plus
- **数据库**: MySQL 8.x
- **缓存**: Redis
- **安全**: Spring Security + JWT

### 前端
- **框架**: Vue 3 + TypeScript
- **UI 库**: Element Plus (封装为 A* 组件)
- **状态管理**: Pinia
- **构建工具**: Vite

### 移动端
- **框架**: UniApp
- **UI 库**: WD UI
- **状态管理**: Pinia

## 核心规范

### 四层架构
```
Controller → Service (不继承) → DAO (buildQueryWrapper) → Mapper
```

### 命名规范
- 表名: 小写 + 下划线 (sys_user, bus_order)
- 类名: 大驼峰 (UserService, OrderController)
- 方法名: 小驼峰 (getUserById, saveOrder)
- 变量名: 小驼峰 (userName, totalCount)

### 代码规范
- Entity 必须继承 TenantEntity/BaseEntity
- Service 禁止继承 ServiceImpl
- DAO 必须实现 buildQueryWrapper()
- Controller 路径必须包含实体名
- 对象转换使用 MapstructUtils

## 快捷命令

### /dev
7步智能开发流程,用于开发新功能

**使用**:
```
/dev 开发优惠券管理功能
```

**步骤**:
1. 需求澄清
2. 技术设计
3. 数据库设计
4. 后端开发
5. 前端开发
6. 测试验证
7. 文档更新

### /crud
从数据库表一键生成CRUD代码

**使用**:
```
crud <表名>

例如:
crud bus_coupon
```

**生成**:
- Entity, BO, VO
- DAO, Service, Controller
- Mapper
- 前端 API 和页面 (可选)

### /check
全栈代码规范检查

**使用**:
```
check                  # 检查所有变更
check <文件/目录>      # 检查指定文件
check --fix           # 自动修复
```

### /update-status
更新项目状态

### /add-todo
添加待办事项

## 技能 (Skills)

项目包含以下专业技能,会根据任务自动激活:

### 后端开发
- **crud-development**: CRUD开发规范
- **api-development**: RESTful API设计
- **database-ops**: 数据库操作
- **error-handler**: 异常处理

### 前端开发
- **ui-pc**: Element Plus封装组件
- **store-pc**: Pinia状态管理

### 移动端
- **ui-mobile**: WD UI组件
- **uniapp-platform**: 跨平台条件编译

### 业务集成
- **payment-integration**: 支付集成
- **wechat-integration**: 微信集成
- **file-oss-management**: 文件上传与OSS

### 质量保障
- **bug-detective**: Bug排查
- **performance-doctor**: 性能优化
- **security-guard**: 安全防护
- **code-patterns**: 代码规范

## 代理 (Agents)

### @code-reviewer
代码审查代理,用于审查代码质量

**触发方式**:
- 完成代码后自动触发
- 手动调用: `@code-reviewer`

**审查内容**:
- 后端代码规范
- 前端代码规范
- 安全问题
- 性能问题

### @project-manager
项目管理代理,维护项目状态和待办事项

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
3. 使用 /dev 命令开始开发
4. 按照标准流程执行
5. 使用 @code-reviewer 审查代码
6. 提交代码
7. 使用 @project-manager 更新状态
```

### 快速CRUD
```
1. 设计数据库表
2. 使用 /crud <表名> 生成代码
3. 使用 @code-reviewer 审查
4. 测试功能
5. 提交代码
```

## 代码检查清单

### 提交前必查
- [ ] 代码符合规范
- [ ] 已通过 /check 检查
- [ ] 已通过 @code-reviewer 审查
- [ ] 功能测试通过
- [ ] 已更新文档
- [ ] 已更新项目状态

## 常见问题

### Q: AI 不遵守项目规范?
A: 检查 .claude/hooks/skill-forced-eval.js 是否正常工作,确保技能正确激活

### Q: 代码审查太严格?
A: code-reviewer 会区分严重程度,严重问题必须修复,建议问题可以选择性修复

### Q: 如何添加新的技能?
A: 在 .claude/skills/ 目录下创建新目录和 SKILL.md 文件

### Q: 如何自定义命令?
A: 在 .claude/commands/ 目录下创建 .md 文件

## 最佳实践

1. **使用快捷命令**: 优先使用 /dev, /crud 等命令,而不是直接描述需求
2. **及时审查**: 每次完成代码后使用 @code-reviewer 审查
3. **保持同步**: 定期使用 /update-status 更新项目状态
4. **遵循规范**: 严格遵守四层架构和命名规范
5. **测试驱动**: 编写代码前先考虑测试用例

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
├── docs/                 # 项目文档
│   ├── 项目状态.md
│   └── 待办清单.md
├── ruoyi-modules/        # 业务模块
│   └── ...
└── pom.xml              # Maven 配置
```

## 更新日志

### 2024-01-30
- 初始化 Claude Code 配置
- 创建 4 个生命周期钩子
- 创建 4 个核心技能
- 创建 3 个斜杠命令
- 创建 2 个代理

## 联系方式

如有问题,请联系项目负责人。
