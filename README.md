# Claude Code 配置模板库

> 🚀 让 Claude Code 像一个经验丰富的开发者一样工作

Claude Code 工作空间模板库，提供各种开箱即用的配置模板。每个模板都是完整的工作空间，包含 `.claude` 配置文件、技能体系、快捷命令和智能代理。

## ✨ 特性

- 🎯 **开箱即用** - 直接复制到项目即可使用
- 🧠 **智能评估** - 自动识别任务并激活对应技能
- 📋 **标准化流程** - 通过命令体系规范开发流程
- 🤖 **智能代理** - 自动化代码审查和项目管理
- 🎓 **最佳实践** - 沉淀各种技术栈的开发经验

## 📦 模板列表

### 🌟 通用最佳实践（推荐）

适用于各种类型软件项目的通用配置，包含开箱即用的最佳实践。

**包含内容**：
- 🔔 4 个生命周期钩子
  - 会话启动 - 显示项目信息
  - 技能评估 - 自动识别任务类型
  - 危险命令拦截 - 防止误操作
  - 任务总结 - 代码质量检查
- 🎓 5 个专业技能
  - 代码规范
  - 异常处理
  - 安全防护
  - 性能优化
  - Bug 排查
- ⚡ 1 个快捷命令 `/dev`
- 🤖 2 个智能代理（代码审查、项目管理）

**使用方法**：
```bash
cp -r .claude /path/to/your/project/
```

**适用场景**：任何需要规范化开发的软件项目

---

### ☕ RuoYi-Plus 示例

RuoYi-Plus 框架专用配置，适合使用 RuoYi Plus 框架的 Java 后端项目。

**技术栈**：Spring Boot 3.x + MyBatis-Plus + Vue 3 + Element Plus

**包含内容**：
- 🔔 4 个生命周期钩子
- 🎓 4 个专业技能
  - CRUD 开发
  - API 设计
  - 数据库操作
  - 代码规范
- ⚡ 3 个快捷命令（`/dev`、`/crud`、`/check`）
- 🤖 2 个智能代理

**特点**：
- ✅ 强制技能评估机制
- ✅ 四层架构规范
- ✅ 完整的 CRUD 开发流程

**适用场景**：使用 RuoYi Plus 框架的 Java 后端项目

**相关资源**：
- [RuoYi-Plus 官方文档](https://plus-doc.dromara.org/)

---

### 📱 Wot Starter 示例

Wot Starter 框架专用配置，适合使用 wot-design-uni 的 uni-app 前端项目。

**技术栈**：uni-app + Vue 3.4 + TypeScript + wot-design-uni + UnoCSS

**包含内容**：
- 🔔 4 个生命周期钩子
- 🎓 6 个专业技能
  - 页面生成
  - API 模块
  - 状态管理
  - 路由导航
  - 全局反馈
  - 组合式函数
- ⚡ 5 个快捷命令（`/page`、`/api`、`/store`、`/component`、`/check`）
- 🤖 2 个智能代理

**特点**：
- ✅ 强制技能评估机制
- ✅ 三层架构规范
- ✅ 多端开发支持（H5/小程序/App）
- ✅ 完整的前端开发流程

**适用场景**：uni-app 多端开发项目

**相关资源**：
- [Wot Starter GitHub](https://github.com/wot-ui/wot-starter)
- [wot-design-uni 文档](https://wot-ui.cn)

---

### 🎨 Wot Design Uni User

Wot Design Uni 组件库使用配置，专注于组件库的正确使用。

**技术栈**：uni-app + Vue 3 + TypeScript + wot-design-uni v1.14.0

**包含内容**：
- 🔔 3 个生命周期钩子
- 🎓 5 个组件使用技能
  - 基础组件（button, icon, cell, avatar, badge, tag）
  - 表单组件（form, input, picker, checkbox, radio, switch, upload, rate）
  - 反馈组件（dialog, toast, loading, popup, action-sheet, notify）
  - 布局组件（row/col, divider, card, collapse, grid, sticky, backtop）
  - 导航组件（tabs, tabbar, navbar, sidebar, steps, pagination）
- ⚡ 3 个快捷命令（`/use-component`、`/theme-config`、`/check-usage`）
- 🤖 1 个智能代理（@component-helper）

**特点**：
- ✅ 强制技能评估机制
- ✅ 覆盖 37+ 常用组件
- ✅ 每个技能包含禁止事项和检查清单
- ✅ 完整的代码模板和最佳实践

**适用场景**：使用 Wot Design Uni 组件库的 uni-app 项目

**与 Wot Starter 的区别**：
- **Wot Starter**：开发完整的 uni-app 应用（页面/API/Store/路由）
- **Wot Design Uni User**：专注于组件库的使用（组件查找/主题配置/规范检查）

**相关资源**：
- [wot-design-uni 官方文档](https://wot-ui.cn)
- [组件列表](https://wot-ui.cn/component)

---

### 🔧 Hook 示例

Hook 配置示例，展示如何使用生命周期钩子。

**包含内容**：
- 基础的 Hook 示例代码
- 详细的注释说明

**适用场景**：学习 Hook 机制，自定义钩子逻辑

---

## 🚀 快速开始

### 1. 选择模板

浏览模板列表，找到适合你项目的模板。

### 2. 复制配置

将模板目录下的 `.claude` 文件夹复制到你的项目根目录：

```bash
# 例如使用 RuoYi-Plus 模板
cp -r RuoYi-Plus-示例/.claude /path/to/your/project/

# 或使用通用最佳实践
cp -r .claude /path/to/your/project/
```

### 3. 启动 Claude Code

在你的项目目录下启动 Claude Code，配置自动生效。

## 🛠️ 自定义配置

### 修改模板

复制模板后，可以根据项目需求修改配置：

- `.claude/settings.json` - 核心配置
- `.claude/CLAUDE.md` - 项目规范
- `.claude/hooks/` - 生命周期钩子
- `.claude/skills/` - 专业技能
- `.claude/commands/` - 斜杠命令
- `.claude/agents/` - 自定义代理

### 创建新模板

#### 方法 1: 使用 /create-config 命令（推荐）

```bash
# 在 Claude Code 中执行
/create-config 为 React + TypeScript 项目创建配置
/create-config 为 Python + FastAPI 项目创建配置
```

这个命令会：
- 🔍 分析技术栈特点
- 🎯 设计核心技能和命令
- 📝 生成完整的配置文件
- ✅ 提供测试验证步骤

#### 方法 2: 基于现有模板

1. 复制任意模板目录
2. 修改 `.claude` 配置文件
3. 更新文档说明

#### 方法 3: 从零创建

参考 `.claude/skills/claude-config-creator/SKILL.md` 中的完整指南，了解：

- 📐 配置架构设计
- 🎓 技能设计原则
- ⚡ 命令设计方法
- 🔔 钩子实现技巧
- 📝 文档编写规范

包含 RuoYi-Plus 和 Wot Starter 的成功案例分析。

## 📋 模板规范

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
├── README.md             # 模板说明（必需）
└── docs/                 # 相关文档（可选）
```

## 🤝 贡献模板

欢迎提交新的模板！

### 模板要求

- ✅ 包含完整的 `.claude` 配置
- ✅ 提供 README.md 说明文档
- ✅ 注明适用场景和技术栈
- ✅ 配置文件格式正确

### 提交方式

1. Fork 本仓库
2. 创建新的模板目录
3. 提交 Pull Request

## 📚 参考资源

### 学习资料

- 📝 [博客文章：25% → 90%！别让 Skills 吃灰](https://blog.csdn.net/leoisaking/article/details/156203326)
- 🎥 [视频教程](https://www.bilibili.com/video/BV1rnBKB2EME/)
- 📖 [Claude Code 官方文档](https://docs.anthropic.com/claude/code)

### 官方文档

- [Claude Code 文档](https://docs.anthropic.com/claude/code)
- [Agent Skills 规范](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)

### 技术框架

- [RuoYi-Plus 官方文档](https://plus-doc.dromara.org/)
- [wot-design-uni 官方文档](https://wot-ui.cn)
- [uni-app 官方文档](https://uniapp.dcloud.net.cn/)

## 🔥 核心特性

### 强制技能评估

通过 `user-prompt-submit` Hook 实现：

```javascript
// 检测用户请求
if (isCodeTask(prompt)) {
  return {
    proceed: false,
    message: "请先评估需要的技能"
  }
}
```

**优势**：
- 🎯 自动识别任务类型
- 🧠 智能激活对应技能
- ✅ 确保代码符合规范

### 标准化命令体系

通过命令规范开发流程：

```
/dev     → 标准开发流程
/check   → 代码质量检查
/crud    → 快速生成代码
```

**优势**：
- 📋 流程标准化
- 🔄 可重复执行
- 📊 质量可追溯

### 智能代理系统

自动化代码审查和项目管理：

```
@code-reviewer    → 审查代码质量
@project-manager  → 管理项目进度
```

**优势**：
- 🤖 自动化审查
- 📈 进度跟踪
- 💡 改进建议

## 📊 配置对比

| 配置 | 技术栈 | 技能数 | 命令数 | 适用场景 |
|------|--------|--------|--------|----------|
| **通用最佳实践** | 通用 | 5 | 1 | 任何项目 |
| **RuoYi-Plus** | Spring Boot + MyBatis-Plus | 4 | 3 | Java 后端 |
| **Wot Starter** | uni-app + Vue 3 + TS | 6 | 5 | 前端开发 |
| **Wot Design Uni User** | wot-design-uni | 5 | 3 | 组件使用 |

## 🎓 使用建议

### 选择合适的模板

1. **任何项目** → 使用 **通用最佳实践**
2. **Java 后端（RuoYi-Plus）** → 使用 **RuoYi-Plus 示例**
3. **uni-app 前端开发** → 使用 **Wot Starter 示例**
4. **使用 wot-design-uni 组件** → 叠加 **Wot Design Uni User**

### 组合使用

对于复杂项目，可以组合多个配置：

```bash
# 基础配置
cp -r Wot-Starter-前端示例/.claude /path/to/project/

# 叠加组件库配置
cp -r wot-design-uni-user/.claude/skills /path/to/project/.claude/
cp -r wot-design-uni-user/.claude/commands /path/to/project/.claude/
```

## 📈 项目统计

- 📦 **配置模板**: 5 个
- 🎓 **专业技能**: 20+ 个
- ⚡ **快捷命令**: 10+ 个
- 🤖 **智能代理**: 6 个
- 📝 **文档页面**: 100+ 页

## 📜 许可证

MIT License

## 🙏 致谢

- 感谢原作者 [抓蛙师](https://blog.csdn.net/leoisaking) 分享的最佳实践！
- 感谢 [Anthropic](https://www.anthropic.com) 提供 Claude Code！
- 感谢所有贡献者的支持！

---

**🌟 如果这个项目对你有帮助，请给个 Star！**
