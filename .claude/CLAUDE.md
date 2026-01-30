# Claude Code 项目规范

## 项目概述

这是一个通用的 Claude Code 最佳实践模板,适用于各种类型的软件项目。

## 核心规范

### 代码规范
- 命名规范: 类名用 PascalCase, 方法名用 camelCase
- 注释规范: 类和方法必须有注释
- 异常处理: 不要吞掉异常,使用具体异常类型
- 空值检查: 正确处理 null 和 undefined

### Git 规范
- 提交信息格式: `type: description`
- type 类型: feat, fix, docs, style, refactor, test, chore
- 提交前进行代码检查

## 快捷命令

### /dev
7步智能开发流程,用于开发新功能

**使用**:
```
/dev 开发新功能描述
```

**步骤**:
1. 需求澄清
2. 技术设计
3. 数据/模型设计
4. 后端/核心开发
5. 前端开发 (可选)
6. 测试验证
7. 文档更新

## 技能 (Skills)

项目包含以下专业技能,会根据任务自动激活:

### 通用技能
- **code-patterns**: 代码规范
- **error-handler**: 异常处理
- **security-guard**: 安全防护
- **performance-doctor**: 性能优化
- **bug-detective**: Bug 排查

## 代理 (Agents)

### @code-reviewer
代码审查代理,用于审查代码质量

**触发方式**:
- 完成代码后手动调用: `@code-reviewer`

**审查内容**:
- 代码规范
- 安全问题
- 性能问题
- 最佳实践

### @project-manager
项目管理代理,维护项目状态和待办事项

**触发方式**:
- 手动调用: `@project-manager`

**管理内容**:
- 项目进度
- 待办清单
- 问题跟踪

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

## 代码检查清单

### 提交前必查
- [ ] 代码符合规范
- [ ] 已通过代码检查
- [ ] 已通过代码审查
- [ ] 功能测试通过
- [ ] 已更新文档

## 自定义配置

### 添加新技能

在 `.claude/skills/` 下创建新目录和 `SKILL.md`:

```bash
mkdir -p .claude/skills/my-skill
```

然后在 `SKILL.md` 中定义技能的触发条件和核心规范。

### 添加新命令

在 `.claude/commands/` 下创建 `.md` 文件定义新命令。

### 添加新代理

在 `.claude/agents/` 下创建目录和 `AGENT.md` 定义新代理。

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
├── STATUS.md             # 项目状态 (可选)
└── TODO.md               # 待办清单 (可选)
```

## 最佳实践

1. **使用快捷命令**: 优先使用 /dev 等命令,而不是直接描述需求
2. **及时审查**: 每次完成代码后使用 @code-reviewer 审查
3. **保持同步**: 定期使用 @project-manager 更新项目状态
4. **遵循规范**: 严格遵守代码规范
5. **测试驱动**: 编写代码前先考虑测试用例
