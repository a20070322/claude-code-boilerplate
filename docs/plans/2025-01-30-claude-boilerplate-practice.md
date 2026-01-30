# Claude Code 模板库工程实践 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 为 claude-code-boilerplate 模板库项目定制一套完整的 `.claude` 工程实践配置，提升文档编写、模板开发、配置规范和流程优化效率。

**Architecture:** 基于现有的 4 个生命周期钩子机制，针对模板库维护场景定制专业技能、斜杠命令和代理，形成完整的工作流。

**Tech Stack:** Claude Code Hooks (Node.js), Markdown, Git

---

## Task 1: 设计并创建文档开发专业技能

**目标:** 创建文档编写规范和流程的技能定义

**Files:**
- Create: `.claude/skills/doc-development/SKILL.md`

**Step 1: 创建文档开发技能文件**

创建 `.claude/skills/doc-development/SKILL.md`:

```markdown
# 文档开发技能

## 触发条件
- 关键词: 文档、README、指南、手册、说明
- 场景: 编写或修改项目文档时

## 文档类型

### 1. README 文档
**必需章节:**
- 项目简介 (1-2 句话)
- 快速开始 (最少 3 步)
- 功能特性 (列表形式)
- 使用示例 (代码块)
- 相关链接

**格式规范:**
```markdown
# 项目名称

简短描述 (1-2 句话)

## 简介
[项目的详细说明]

## 快速开始
\`\`\`bash
# 步骤 1
command

# 步骤 2
command
\`\`\`

## 功能特性
- ✅ 特性 1
- ✅ 特性 2

## 使用示例
\`\`\`javascript
// 代码示例
\`\`\`

## 相关链接
- 文档链接
- 问题反馈
```

### 2. 使用指南文档
**结构:**
1. 配置完成状态
2. 立即开始使用
3. 核心功能说明
4. 常见问题
5. 参考资源

### 3. API/配置文档
**包含:**
- 配置项说明
- 参数说明
- 返回值说明
- 示例代码

## 文档编写原则

### 1. 清晰优先
- 使用简洁的语言
- 避免技术术语堆砌
- 提供具体示例

### 2. 结构化
- 使用清晰的层级
- 合理的分节
- 代码块标注语言

### 3. 可维护性
- 统一的格式风格
- 版本更新记录
- 相关文档引用

## 检查清单
- [ ] 标题层级正确 (h1 > h2 > h3)
- [ ] 代码块标注语言
- [ ] 链接可访问
- [ ] 示例代码可运行
- [ ] 包含必要的步骤
- [ ] 使用列表和表格增强可读性
```

**Step 2: 测试技能是否可用**

在 Claude Code 中测试: `帮我写一个模板的 README`

预期: AI 应该激活 doc-development 技能并按规范生成文档

**Step 3: 提交技能文件**

```bash
git add .claude/skills/doc-development/
git commit -m "feat(skills): add doc-development skill"
```

---

## Task 2: 设计并创建模板开发专业技能

**目标:** 定义新模板的开发规范和流程

**Files:**
- Create: `.claude/skills/template-dev/SKILL.md`

**Step 1: 创建模板开发技能文件**

创建 `.claude/skills/template-dev/SKILL.md`:

```markdown
# 模板开发技能

## 触发条件
- 关键词: 模板、示例、boilerplate、新框架
- 场景: 创建新的技术栈模板或框架示例时

## 模板结构规范

### 标准模板目录结构
\`\`\`
模板名称/
├── .claude/              # Claude Code 配置 (必需)
│   ├── settings.json     # 核心配置
│   ├── CLAUDE.md         # 项目规范
│   ├── hooks/            # 生命周期钩子
│   ├── skills/           # 专业技能
│   ├── commands/         # 斜杠命令
│   └── agents/           # 自定义代理
├── README.md             # 模板说明 (必需)
├── 示例代码/             # 可选的示例代码
└── docs/                 # 相关文档 (可选)
\`\`\`

## 模板开发流程

### 1. 需求分析
- [ ] 明确目标技术栈
- [ ] 明确适用场景
- [ ] 列出核心特性

### 2. 配置设计
- [ ] 定义必需的技能
- [ ] 定义快捷命令
- [ ] 定义代理 (如需要)
- [ ] 设计钩子逻辑 (如需要)

### 3. 文档编写
- [ ] 编写 README.md
  - 技术栈说明
  - 包含内容
  - 快速开始
  - 注意事项
- [ ] 编写 CLAUDE.md
  - 项目概述
  - 核心规范
  - 开发流程

### 4. 示例代码 (可选)
- [ ] 创建最小可用示例
- [ ] 确保代码可运行
- [ ] 添加必要注释

### 5. 测试验证
- [ ] 复制模板到新项目测试
- [ ] 验证配置正确性
- [ ] 验证文档完整性

## 配置文件规范

### settings.json
\`\`\`json
{
  "hooks": {
    "SessionStart": [...],     // 可选
    "UserPromptSubmit": [...], // 可选
    "PreToolUse": [...],       // 可选
    "Stop": [...]              // 可选
  },
  "permissions": {
    "allow": ["*"]
  }
}
\`\`\`

### 技能定义
每个技能必须包含:
- 触发条件 (关键词 + 场景)
- 核心规范
- 代码示例 (如适用)
- 检查清单

### 命令定义
每个命令必须包含:
- 描述
- 使用方法
- 执行步骤
- 注意事项

## 质量标准

### 文档质量
- README 清晰完整
- 配置说明准确
- 示例代码可用
- 格式统一规范

### 配置质量
- JSON 格式正确
- 路径引用正确
- Hook 脚本可执行
- 技能定义完整

### 可用性
- 一键复制使用
- 最小配置要求
- 清晰的错误提示
- 完整的使用文档

## 常见模板类型

### 框架模板
- 特定技术栈 (Vue, React, Spring Boot)
- 完整的项目结构
- 框架特定的规范

### 功能模板
- 特定功能 (CRUD, API, 认证)
- 可复用的配置
- 通用性优先

### Hook 模板
- 单一钩子示例
- 学习用途
- 最小化配置

## 提交检查
- [ ] 目录结构符合规范
- [ ] README.md 完整清晰
- [ ] CLAUDE.md 规范明确
- [ ] 配置文件格式正确
- [ ] 示例代码可运行
- [ ] 已在真实项目中测试
- [ ] 更新主 README 模板列表
\`\`\`

**Step 2: 更新技能评估钩子**

修改 `.claude/hooks/skill-forced-eval.js`，添加新技能到列表:

\`\`\`javascript
const skills = [
  'code-patterns',
  'doc-development',    // 新增
  'template-dev',       // 新增
  'config-validator',   // 新增
  'error-handler',
  'security-guard',
  'performance-doctor',
  'bug-detective'
];
\`\`\`

**Step 3: 测试技能**

在 Claude Code 中测试: `帮我创建一个 React 模板`

预期: AI 应该激活 template-dev 技能并按流程执行

**Step 4: 提交更改**

\`\`\`bash
git add .claude/skills/template-dev/ .claude/hooks/skill-forced-eval.js
git commit -m "feat(skills): add template-dev skill"
\`\`\`

---

## Task 3: 创建配置验证专业技能

**目标:** 确保配置文件的正确性和一致性

**Files:**
- Create: `.claude/skills/config-validator/SKILL.md`

**Step 1: 创建配置验证技能**

\`\`\`bash
mkdir -p .claude/skills/config-validator
\`\`\`

创建 `.claude/skills/config-validator/SKILL.md`:

\`\`\`markdown
# 配置验证技能

## 触发条件
- 关键词: 配置、settings、验证、检查
- 场景: 创建或修改 .claude 配置文件时

## 验证清单

### settings.json 验证
- [ ] JSON 格式正确
- [ ] hooks 节点完整 (SessionStart, UserPromptSubmit, PreToolUse, Stop)
- [ ] 每个 hook 有 matcher 和 command
- [ ] permissions 配置正确

### CLAUDE.md 验证
- [ ] 项目概述清晰
- [ ] 核心规范明确
- [ ] 快捷命令列表完整
- [ ] 技能列表准确
- [ ] 代理列表准确
- [ ] 开发流程描述清晰

### Hooks 验证
- [ ] JavaScript 文件语法正确
- [ ] 有可执行权限 (chmod +x)
- [ ] 错误处理完善
- [ ] 不会阻塞正常使用

### Skills 验证
- [ ] 每个 skill 有 SKILL.md
- [ ] 触发条件明确
- [ ] 规范内容完整
- [ ] 有检查清单

### Commands 验证
- [ ] 命令文件是 .md 格式
- [ ] 有描述和使用方法
- [ ] 有执行步骤
- [ ] 有注意事项

### Agents 验证
- [ ] 每个 agent 有 AGENT.md
- [ ] 触发方式明确
- [ ] 职责范围清晰
- [ ] 有使用示例

## 常见问题

### JSON 格式错误
**症状:** settings.json 无法加载
**检查:** 使用 JSON 验证工具检查语法

### Hook 不触发
**症状:** 配置的 hook 没有执行
**检查:**
1. settings.json 中路径是否正确
2. 文件是否有执行权限
3. Node.js 是否已安装

### 技能不激活
**症状:** 定义了技能但 AI 不使用
**检查:**
1. skill-forced-eval.js 中是否包含该技能
2. SKILL.md 是否在正确的目录
3. 触发条件是否明确

### 命令无效
**症状:** /命令 无法执行
**检查:**
1. 文件是否在 .claude/commands/ 目录
2. 文件扩展名是否为 .md
3. 文件名是否正确

## 验证流程

### 自动验证
运行配置验证命令 (在 Task 6 中创建)

### 手动验证
1. 检查文件结构
2. 验证配置文件
3. 测试 hook 触发
4. 测试技能激活
5. 测试命令执行
\`\`\`

**Step 2: 提交技能**

\`\`\`bash
git add .claude/skills/config-validator/
git commit -m "feat(skills): add config-validator skill"
\`\`\`

---

## Task 4: 创建文档维护斜杠命令

**目标:** 提供快捷的文档维护命令

**Files:**
- Create: `.claude/commands/doc.md`
- Modify: `.claude/hooks/session-start.js`

**Step 1: 创建 /doc 命令**

创建 `.claude/commands/doc.md`:

\`\`\`markdown
# /doc - 文档维护命令

## 描述
统一的文档维护入口,支持创建、更新、检查各种类型的文档

## 使用方法
\`\`\`
/doc                    # 显示文档维护菜单
/doc readme             # 创建/更新 README
/doc guide              # 创建/更新使用指南
/doc api                # 创建 API 文档
/doc check              # 检查文档质量
/doc toc                # 更新目录
\`\`\`

## 执行步骤

### 1. 显示菜单 (无参数时)
列出可用的文档操作:
- 创建 README
- 更新使用指南
- 生成 API 文档
- 检查文档质量
- 更新目录结构

### 2. README 创建/更新 (/doc readme)
**检查:**
- [ ] README.md 是否存在
- [ ] 当前是什么类型的项目

**生成内容:**
- 项目名称和简介
- 快速开始 (3 步)
- 功能特性列表
- 使用示例
- 相关链接

### 3. 使用指南创建/更新 (/doc guide)
**生成内容:**
- 配置完成状态
- 立即开始使用
- 核心功能说明
- 常见问题
- 参考资源

### 4. API 文档生成 (/doc api)
**扫描:**
- .claude/commands/ 目录
- .claude/skills/ 目录
- .claude/agents/ 目录

**生成:**
- 命令列表和说明
- 技能列表和触发条件
- 代理列表和用途

### 5. 文档质量检查 (/doc check)
**检查项:**
- 标题层级是否正确
- 代码块是否有语言标注
- 链接是否有效
- 是否有示例代码
- 格式是否统一

**输出:**
发现问题列表和修复建议

### 6. 更新目录 (/doc toc)
**扫描:**
- 当前目录的 .md 文件
- 生成目录结构
- 更新到文件顶部

## 示例

用户: \`\`\`
/doc readme
\`\`\`

AI 执行:
\`\`\`
### 检查现有 README
✓ 找到 README.md

### 分析项目类型
✓ 模板库项目

### 生成内容
[生成完整的 README 内容]

### 预览并确认
显示生成的内容,等待用户确认

### 更新文件
更新 README.md
\`\`\`

## 注意事项
1. 生成前先检查文件是否已存在
2. 已有内容会被保留,只更新缺失部分
3. 使用统一的格式风格
4. 确保示例代码正确
\`\`\`

**Step 2: 更新会话启动钩子**

修改 `.claude/hooks/session-start.js`,在快捷命令中添加 /doc:

\`\`\`javascript
💡 **快捷命令**:
| /dev  | 开发新功能 (7步流程) |
| /doc  | 文档维护命令 |
| /plan | 创建实现计划 |
\`\`\`

**Step 3: 提交更改**

\`\`\`bash
git add .claude/commands/doc.md .claude/hooks/session-start.js
git commit -m "feat(commands): add /doc command for documentation"
\`\`\`

---

## Task 5: 创建模板开发斜杠命令

**目标:** 提供快捷的模板创建和验证命令

**Files:**
- Create: `.claude/commands/template.md`
- Modify: `.claude/hooks/session-start.js`

**Step 1: 创建 /template 命令**

创建 `.claude/commands/template.md`:

\`\`\`markdown
# /template - 模板管理命令

## 描述
创建新模板、验证模板、更新模板列表

## 使用方法
\`\`\`
/template                        # 显示模板管理菜单
/template create <名称>          # 创建新模板
/template validate <名称>        # 验证模板
/template list                   # 更新模板列表
\`\`\`

## 执行步骤

### 1. 显示菜单 (无参数时)
列出可用的模板操作:
- 创建新模板
- 验证现有模板
- 更新主 README 模板列表
- 模板质量检查

### 2. 创建新模板 (/template create <名称>)

**步骤 1: 需求澄清**
询问:
- 模板名称
- 目标技术栈
- 适用场景
- 核心特性
- 是否包含示例代码

**步骤 2: 创建目录结构**
\`\`\`bash
mkdir -p <模板名称>/.claude/{hooks,skills,commands,agents}
mkdir -p <模板名称>/docs
\`\`\`

**步骤 3: 生成配置文件**
- settings.json (基础配置)
- CLAUDE.md (项目规范)
- README.md (模板说明)

**步骤 4: 生成文档**
- README.md: 包含技术栈、特性、快速开始
- CLAUDE.md: 包含规范、流程、技能列表

**步骤 5: 创建示例 (可选)**
根据技术栈创建最小可用示例

**步骤 6: 验证模板**
运行验证流程 (参考 validate 子命令)

### 3. 验证模板 (/template validate <名称>)

**检查项:**
- [ ] 目录结构完整
- [ ] settings.json 格式正确
- [ ] CLAUDE.md 内容完整
- [ ] README.md 内容完整
- [ ] Hook 脚本可执行
- [ ] 技能定义完整
- [ ] 命令定义完整

**输出:**
验证报告,包含:
- ✓ 通过项
- ✗ 失败项
- ⚠ 警告项
- 修复建议

### 4. 更新模板列表 (/template list)

**扫描:**
- 当前目录下的所有子目录
- 找出包含 .claude 的目录

**更新主 README:**
在模板列表章节添加或更新:
- 模板名称
- 技术栈
- 包含内容
- 适用场景

## 示例

用户: \`\`\`
/template create react-typescript
\`\`\`

AI 执行:
\`\`\`
### 需求澄清
- 技术栈: React 18 + TypeScript + Vite
- 场景: 现代 Web 前端项目
- 特性: 组件开发、状态管理、路由

### 创建目录
[创建目录结构]

### 生成配置
[生成配置文件]

### 生成文档
[生成 README 和 CLAUDE.md]

### 验证
[验证模板]

✓ 模板创建完成: react-typescript/
\`\`\`

## 注意事项
1. 模板名称使用 kebab-case
2. 确保所有配置文件格式正确
3. README 必须清晰易懂
4. 验证通过后再更新主 README
\`\`\`

**Step 2: 更新会话启动钩子**

修改 `.claude/hooks/session-start.js`,添加 /template 命令:

\`\`\`javascript
💡 **快捷命令**:
| /dev      | 开发新功能 (7步流程) |
| /doc      | 文档维护命令 |
| /template | 模板管理命令 |
| /plan     | 创建实现计划 |
\`\`\`

**Step 3: 提交更改**

\`\`\`bash
git add .claude/commands/template.md .claude/hooks/session-start.js
git commit -m "feat(commands): add /template command"
\`\`\`

---

## Task 6: 创建配置检查斜杠命令

**目标:** 提供配置验证和修复命令

**Files:**
- Create: `.claude/commands/check.md`

**Step 1: 创建 /check 命令**

创建 `.claude/commands/check.md`:

\`\`\`markdown
# /check - 配置检查命令

## 描述
检查 .claude 配置的正确性和完整性

## 使用方法
\`\`\`
check                    # 检查当前项目配置
check <模板目录>          # 检查指定模板的配置
check --fix              # 自动修复可修复的问题
\`\`\`

## 执行步骤

### 1. 检查目录结构
- [ ] .claude 目录存在
- [ ] settings.json 存在
- [ ] CLAUDE.md 存在
- [ ] hooks/ 目录存在 (可选)
- [ ] skills/ 目录存在 (可选)
- [ ] commands/ 目录存在 (可选)
- [ ] agents/ 目录存在 (可选)

### 2. 检查 settings.json
- [ ] JSON 格式正确
- [ ] hooks 配置有效
- [ ] permissions 配置有效

### 3. 检查 Hook 脚本
- [ ] JavaScript 语法正确
- [ ] 文件有执行权限
- [ ] 路径引用正确

### 4. 检查技能定义
- [ ] 每个 skill 有 SKILL.md
- [ ] 格式符合规范
- [ ] 触发条件明确

### 5. 检查命令定义
- [ ] 每个 command 是 .md 文件
- [ ] 格式符合规范

### 6. 检查代理定义
- [ ] 每个 agent 有 AGENT.md
- [ ] 格式符合规范

## 输出格式

\`\`\`
## 🔍 配置检查报告

### 📁 目录结构
✓ .claude/ 目录存在
✓ settings.json 存在
✓ CLAUDE.md 存在
✓ hooks/ 目录存在 (4 个文件)
✓ skills/ 目录存在 (3 个技能)
✓ commands/ 目录存在 (3 个命令)

### ⚙️ 配置文件
✓ settings.json 格式正确
✓ CLAUDE.md 内容完整

### 🪝 Hook 脚本
✓ session-start.js - 正常
✓ skill-forced-eval.js - 正常
✓ pre-tool-use.js - 正常
✓ stop.js - 正常

### 📚 技能定义
✓ code-patterns - 完整
✓ doc-development - 完整
✓ template-dev - 完整

### 📝 命令定义
✓ dev.md - 完整
✓ doc.md - 完整
✓ template.md - 完整

### 🤖 代理定义
✓ code-reviewer - 完整
✓ project-manager - 完整

### ⚠️ 警告
• skills/config-validator/SKILL.md 缺少检查清单

### ✗ 错误
无

### 💡 修复建议
1. 为 config-validator 技能添加检查清单
\`\`\`

## 自动修复

使用 \`\`\`check --fix\`\`\` 时自动修复:
- 添加缺失的执行权限
- 修复 JSON 格式 (小问题)
- 创建缺失的目录
\`\`\`

**Step 2: 提交命令**

\`\`\`bash
git add .claude/commands/check.md
git commit -m "feat(commands): add /check command"
\`\`\`

---

## Task 7: 创建模板库维护代理

**目标:** 创建专门用于模板库维护的代理

**Files:**
- Create: `.claude/agents/maintainer/AGENT.md`

**Step 1: 创建维护代理**

\`\`\`bash
mkdir -p .claude/agents/maintainer
\`\`\`

创建 `.claude/agents/maintainer/AGENT.md`:

\`\`\`markdown
# Template Maintainer Agent

## 触发方式
- 手动调用: \`\`\`@maintainer\`\`\`
- 自动触发: 提交包含模板变更时

## 职责
维护模板库的整体质量和一致性

## 工作内容

### 1. 模板验证
- 检查新模板的完整性
- 验证配置文件正确性
- 测试模板可用性

### 2. 文档审查
- 检查 README 完整性
- 验证使用指南准确性
- 确保 API 文档更新

### 3. 配置规范
- 确保配置一致性
- 检查命名规范
- 验证格式统一

### 4. 质量报告
- 生成维护报告
- 列出待修复问题
- 提供改进建议

## 维护检查清单

### 新模板提交
- [ ] 目录结构符合规范
- [ ] README.md 完整清晰
- [ ] CLAUDE.md 规范明确
- [ ] 配置文件格式正确
- [ ] 已在真实项目测试
- [ ] 更新主 README
- [ ] 通过 /check 验证

### 定期维护
- [ ] 所有模板通过验证
- [ ] 文档保持最新
- [ ] 示例代码可运行
- [ ] 链接有效
- [ ] 版本号更新

## 使用示例

用户: \`\`\`@maintainer 检查所有模板
\`\`\`

AI 执行:
\`\`\`
## 🔍 模板库维护报告

### 📊 整体概况
- 模板总数: 5
- 需要更新: 2
- 发现问题: 3

### 📁 模板详情

#### ✓ RuoYi-Plus-示例
- 配置: 正常
- 文档: 完整
- 测试: 通过

#### ⚠️ React-示例
- 配置: 正常
- 文档: 缺少快速开始
- 测试: 未测试
- 建议: 补充 README 快速开始章节

#### ✓ 通用最佳实践
- 配置: 正常
- 文档: 完整
- 测试: 通过

[继续列出其他模板...]

### 🔧 待修复问题
1. React-示例 缺少快速开始
2. Vue-示例 配置文件格式错误
3. Python-示例 示例代码无法运行

### 💡 改进建议
1. 统一 README 格式
2. 添加模板使用统计
3. 创建模板贡献指南
\`\`\`

## 输出格式

维护报告应包含:
- 整体概况统计
- 每个模板的详细状态
- 发现的问题列表
- 修复建议
- 优先级排序
\`\`\`

**Step 2: 提交代理**

\`\`\`bash
git add .claude/agents/maintainer/
git commit -m "feat(agents): add maintainer agent"
\`\`\`

---

## Task 8: 更新项目根目录 CLAUDE.md

**目标:** 更新主配置文件,反映新的技能和命令

**Files:**
- Modify: `.claude/CLAUDE.md`

**Step 1: 更新 CLAUDE.md**

\`\`\`markdown
# Claude Code 项目规范

## 项目概述

claude-code-boilerplate 是一个 Claude Code 工作空间模板库,提供各种开箱即用的配置模板。

## 核心规范

### 模板库维护规范
- 新模板必须通过 /check 验证
- README 必须包含技术栈、特性、快速开始
- CLAUDE.md 必须明确规范和流程
- 配置文件格式必须正确

### 文档规范
- 使用统一的 Markdown 格式
- 代码块必须标注语言
- 链接必须可访问
- 提供具体示例

## 快捷命令

### /dev
7步智能开发流程,用于开发新功能

### /doc
文档维护命令,支持创建、更新、检查文档

**使用**:
\`\`\`bash
/doc readme     # 创建/更新 README
/doc guide      # 创建/更新使用指南
/doc check      # 检查文档质量
\`\`\`

### /template
模板管理命令,支持创建、验证、更新模板

**使用**:
\`\`\`bash
/template create <名称>    # 创建新模板
/template validate <名称>  # 验证模板
/template list             # 更新模板列表
\`\`\`

### /check
配置检查命令,验证配置的正确性和完整性

**使用**:
\`\`\`bash
check              # 检查当前配置
check --fix        # 自动修复问题
\`\`\`

## 技能 (Skills)

### 文档开发
- **doc-development**: 文档编写规范和流程

### 模板开发
- **template-dev**: 模板开发规范和流程
- **config-validator**: 配置验证规范

### 通用技能
- **code-patterns**: 代码规范
- **error-handler**: 异常处理
- **security-guard**: 安全防护
- **performance-doctor**: 性能优化
- **bug-detective**: Bug 排查

## 代理 (Agents)

### @maintainer
模板库维护代理,负责:
- 模板验证
- 文档审查
- 配置规范检查
- 质量报告生成

**使用**: \`\`\`@maintainer\`\`\`

### @code-reviewer
代码审查代理

### @project-manager
项目管理代理

## 开发流程

### 创建新模板
\`\`\`
1. 使用 /template create 创建模板骨架
2. 编写配置文件
3. 编写文档 (README, CLAUDE.md)
4. 创建示例代码 (可选)
5. 使用 /check 验证
6. 使用 @maintainer 审查
7. 更新主 README
8. 提交代码
\`\`\`

### 维护现有模板
\`\`\`
1. 使用 @maintainer 检查所有模板
2. 修复发现的问题
3. 更新文档
4. 验证配置
5. 提交更新
\`\`\`

## 代码检查清单

### 提交前必查
- [ ] 配置文件格式正确
- [ ] 已通过 /check 验证
- [ ] 已通过 @maintainer 审查
- [ ] 文档完整准确
- [ ] 示例代码可运行
- [ ] 已更新主 README (如需要)

## 项目结构

\`\`\`
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
├── README.md             # 主 README
└── STATUS.md             # 项目状态 (可选)
\`\`\`

## 最佳实践

1. **使用快捷命令**: 优先使用 /template, /doc, /check 等命令
2. **及时审查**: 创建模板后使用 @maintainer 审查
3. **保持同步**: 定期检查所有模板状态
4. **遵循规范**: 严格遵守模板开发规范
5. **测试驱动**: 确保模板可用后再提交
\`\`\`

**Step 2: 提交更新**

\`\`\`bash
git add .claude/CLAUDE.md
git commit -m "docs: update CLAUDE.md with new skills and commands"
\`\`\`

---

## Task 9: 更新主 README

**目标:** 更新主 README,反映新的工程实践

**Files:**
- Modify: `README.md`

**Step 1: 更新 README**

\`\`\`markdown
# Claude Code Boilerplate

Claude Code 工作空间模板库,提供各种开箱即用的配置模板。

## 简介

这是一个 Claude Code 配置模板集合,每个目录都是一个独立的工作空间,包含完整的 \`.claude\` 配置文件。你可以根据项目类型选择合适的模板,直接复制使用。

## 模板列表

### 通用最佳实践 (推荐)

适用于各种类型软件项目的通用配置,包含开箱即用的最佳实践。

**包含内容**:
- 4 个生命周期钩子
- 8 个专业技能 (代码规范、文档开发、模板开发、配置验证等)
- 4 个斜杠命令 (\`/dev\`, \`/doc\`, \`/template\`, \`/check\`)
- 3 个代理 (代码审查、项目管理、模板维护)

**使用方法**:
\`\`\`bash
cp -r .claude /path/to/your/project/
\`\`\`

### RuoYi-Plus-示例

RuoYi-Plus 框架专用配置

**技术栈**: Spring Boot 3.x + MyBatis-Plus + Vue 3 + Element Plus

### hook-示例

Hook 配置示例,用于学习 Hook 机制

## 快速开始

### 1. 选择模板

浏览模板列表,找到适合你项目的模板

### 2. 复制配置

\`\`\`bash
cp -r 模板名称/.claude /path/to/your/project/
\`\`\`

### 3. 启动 Claude Code

在你的项目目录下启动 Claude Code,配置自动生效

## 模板库维护

本项目使用 Claude Code 进行自我维护,包含:

### 维护命令
- \`/doc\` - 文档维护
- \`/template\` - 模板管理
- \`/check\` - 配置检查

### 维护代理
- \`@maintainer\` - 模板库维护

### 维护流程
\`\`\`
1. /template create <名称>  # 创建新模板
2. /check                   # 验证配置
3. @maintainer              # 审查质量
4. 更新 README
5. 提交代码
\`\`\`

## 贡献指南

### 提交新模板

1. Fork 本仓库
2. 使用 \`/template create\` 创建模板
3. 完善 README 和配置
4. 使用 \`/check\` 验证
5. 提交 Pull Request

### 模板要求
- 包含完整的 \`.claude\` 配置
- 提供 README.md 说明
- 注明技术栈和适用场景
- 通过配置验证

## 参考资源

- [博客文章: 25% → 90%！别让 Skills 吃灰](https://blog.csdn.net/leoisaking/article/details/156203326)
- [视频教程](https://www.bilibili.com/video/BV1rnBKB2EME/)
- [Claude Code 官方文档](https://docs.anthropic.com/claude/code)

## 许可证

MIT License
\`\`\`

**Step 2: 提交更新**

\`\`\`bash
git add README.md
git commit -m "docs: update README with maintenance workflow"
\`\`\`

---

## Task 10: 最终验证和测试

**目标:** 验证所有配置正确并测试完整流程

**Files:**
- All configuration files

**Step 1: 运行配置检查**

\`\`\`bash
# 在 Claude Code 中执行
check
\`\`\`

预期输出:
- 所有配置项检查通过
- 无错误
- 无警告 (或仅有建议)

**Step 2: 测试 /doc 命令**

\`\`\`bash
# 在 Claude Code 中执行
/doc readme
\`\`\`

预期: 生成或更新 README

**Step 3: 测试 /template 命令**

\`\`\`bash
# 在 Claude Code 中执行
/template list
\`\`\`

预期: 列出所有模板并更新主 README

**Step 4: 测试 @maintainer 代理**

\`\`\`bash
# 在 Claude Code 中执行
@maintainer 检查所有模板
\`\`\`

预期: 生成维护报告

**Step 5: 测试技能激活**

\`\`\`bash
# 在 Claude Code 中执行
帮我创建一个 Vue 模板
\`\`\`

预期: 自动激活 template-dev 技能

**Step 6: 最终提交**

\`\`\`bash
git add .
git commit -m "feat: complete claude boilerplate practice setup

- Add doc-development skill for documentation
- Add template-dev skill for template development
- Add config-validator skill for configuration validation
- Add /doc command for documentation maintenance
- Add /template command for template management
- Add /check command for configuration validation
- Add @maintainer agent for template library maintenance
- Update CLAUDE.md with new skills and commands
- Update README with maintenance workflow

All configurations tested and validated."
\`\`\`

---

## 完成标准

✓ 所有 10 个任务完成
✓ 所有配置文件已创建
✓ 所有技能可正常激活
✓ 所有命令可正常执行
✓ 所有代理可正常调用
✓ 通过 /check 验证
✓ 文档完整准确
✓ 代码已提交

## 后续建议

1. **创建第一个新模板**: 使用 \`/template create\` 创建一个新的框架模板
2. **编写贡献指南**: 创建 CONTRIBUTING.md 说明如何贡献模板
3. **添加模板测试**: 为每个模板添加自动化测试
4. **版本管理**: 使用语义化版本号管理模板库
5. **CI/CD**: 添加自动化验证流程
