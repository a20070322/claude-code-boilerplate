# LangChain Starter - Claude Code 配置模板

一个生产级的 LangChain 开发配置模板，让 Claude Code 像经验丰富的 LangChain 工程师一样工作。

## 简介

本模板提供了完整的 LangChain 开发配置，包括强制技能评估、标准开发流程、代码质量保障和完整的文档体系。

基于 LangChain 官方最佳实践，覆盖链、智能体、提示、检索器和记忆等核心组件。

## 包含内容

### 核心配置
- ✅ **强制技能评估** - 通过 Hook 强制 AI 遵循 LangChain 规范
- ✅ **5个专业技能** - 覆盖链、智能体、提示、检索器、记忆
- ✅ **5个快捷命令** - 标准化开发流程
- ✅ **1个审查代理** - 自动代码审查
- ✅ **完整文档** - CLAUDE.md + README + 使用指南

### 技能清单

| 技能 | 描述 | 核心内容 |
|------|------|----------|
| **langchain-chain** | 构建链 | LCEL 语法、RAG 链、路由链 |
| **langchain-agent** | 开发智能体 | 工具调用、ReAct、规划执行 |
| **langchain-prompt** | 提示模板 | ChatPromptTemplate、少样本学习 |
| **langchain-retriever** | 检索器 | 向量存储、MMR、RAG |
| **langchain-memory** | 记忆组件 | 对话历史、持久化、会话管理 |

### 命令清单

| 命令 | 功能 |
|------|------|
| `/chain` | 创建 LangChain 链 |
| `/agent` | 创建 LangChain 智能体 |
| `/prompt` | 创建提示模板 |
| `/retriever` | 创建检索器 |
| `/check` | 检查配置和代码 |

## 技术栈

- **LangChain**: >= 0.2.0
- **LangChain Core**: >= 0.3.0
- **LangChain Anthropic**: >= 0.2.0
- **Python**: >= 3.9
- **Anthropic Claude**: claude-3-5-sonnet-20241022

## 快速开始

### 1. 安装依赖

```bash
pip install langchain langchain-core langchain-anthropic python-dotenv
```

### 2. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 文件，添加 API 密钥
```

### 3. 启动 Claude Code

```bash
cd /path/to/langchain-starter
claude
```

会话启动时会显示快捷命令和技能列表。

### 4. 创建第一个链

```bash
/chain basic --model claude-3-5-sonnet-20241022
```

## 核心特性

### 1. 强制技能评估机制

任何代码任务都会触发技能评估，确保 AI 遵循 LangChain 最佳实践：

```
用户: 创建一个 RAG 链

AI:
## 步骤 1 - 技能评估
- langchain-chain - 是 - 需要构建链
- langchain-retriever - 是 - 需要检索器
- langchain-prompt - 是 - 需要提示模板

## 步骤 2 - 激活技能
使用 langchain-chain 技能...

## 步骤 3 - 实现代码
[生成符合规范的代码]
```

### 2. LCEL 优先

所有链都使用 LCEL (LangChain Expression Language) 语法：

```python
# ✅ 正确 - 使用 LCEL
chain = prompt | llm | output_parser

# ❌ 错误 - 使用已弃用的 LLMChain
chain = LLMChain(llm=llm, prompt=prompt)
```

### 3. 完整的代码规范

每个技能包含：
- ✅ 完整的代码模板
- ✅ 禁止事项清单
- ✅ 可执行的检查清单
- ✅ 最佳实践建议

### 4. 自动代码审查

使用 `@chain-reviewer` 代理自动审查代码：

```bash
@chain-reviewer 审查这个链
```

输出包含：
- ✅ 通过项
- ⚠️ 警告项
- ❌ 错误项
- 📊 总体评分
- 🔧 修复建议

## 典型使用场景

### 场景 1: 创建 RAG 系统

```bash
# 1. 创建检索器
/retriever basic --vector-store chroma --k 5

# 2. 创建 RAG 链
/chain rag --vector-store chroma

# 3. 测试
python -m pytest tests/test_rag.py

# 4. 审查代码
@chain-reviewer 审查 RAG 链
```

### 场景 2: 创建工具调用 Agent

```bash
# 1. 创建工具
/agent tool-calling --tools search,calculator

# 2. 添加记忆
使用 langchain-memory 技能配置记忆

# 3. 测试
python -m pytest tests/test_agent.py

# 4. 检查
/check code
```

### 场景 3: 优化现有代码

```bash
# 1. 审查代码
@chain-reviewer 检查 chains/old_chain.py

# 2. 根据建议重构
使用 langchain-chain 技能重构

# 3. 验证
/check all
```

## 项目结构

```
langchain-starter/
├── .claude/
│   ├── settings.json          # 核心配置
│   ├── CLAUDE.md              # 项目规范
│   ├── hooks/                 # 生命周期钩子
│   ├── skills/                # 专业技能 (5个)
│   ├── commands/              # 斜杠命令 (5个)
│   ├── agents/                # 代理 (1个)
│   └── docs/                  # 项目文档
├── chains/                    # 链定义示例
├── agents/                    # 智能体示例
├── prompts/                   # 提示模板示例
├── retrievers/                # 检索器示例
├── tests/                     # 测试文件
├── requirements.txt           # 依赖列表
└── README.md                  # 本文件
```

## 核心规范

### LCEL 规范
- ✅ 使用 `|` 操作符组合组件
- ✅ 使用 `invoke()` 而不是 `run()`
- ✅ 使用 ChatPromptTemplate
- ✅ 类型注解完整

### Agent 规范
- ✅ 使用 `create_tool_calling_agent`
- ✅ 工具函数有类型注解
- ✅ 设置 max_iterations
- ✅ 启用错误处理

### 提示规范
- ✅ 使用 ChatPromptTemplate
- ✅ 变量命名清晰
- ✅ 指定输出格式
- ✅ 控制 token 长度

## 与其他模板对比

| 特性 | LangChain Starter | LangGraph Starter |
|------|-------------------|-------------------|
| 核心框架 | LangChain | LangGraph |
| 构建方式 | LCEL 链 | 状态图 |
| 适用场景 | 单轮/多轮任务 | 复杂工作流 |
| 智能体 | Tool-calling Agent | 多智能体协作 |
| 状态管理 | Memory 组件 | TypedDict State |
| 学习曲线 | 较低 | 较高 |

## 常见问题

### Q: 什么时候使用 LangChain，什么时候使用 LangGraph?

**A:**
- **LangChain** - 适合线性流程、单轮任务、简单对话
- **LangGraph** - 适合复杂工作流、多智能体协作、有状态应用

### Q: 如何选择向量存储?

**A:**
- **Chroma** - 轻量级，适合开发
- **Pinecone** - 云服务，易扩展
- **Weaviate** - 开源，功能丰富
- **FAISS** - 高性能，本地部署

### Q: 如何优化 Agent 性能?

**A:**
1. 限制 max_iterations
2. 使用异步工具
3. 实现结果缓存
4. 优化工具描述

### Q: 如何防止无限循环?

**A:**
1. 设置 max_iterations
2. 添加超时
3. 使用时间限制
4. 监控执行步数

## 进阶使用

### 自定义技能

在 `.claude/skills/` 目录创建新技能：

```markdown
---
name: langchain-custom
description: 自定义技能
---

# 技能内容
...
```

### 自定义命令

在 `.claude/commands/` 目录创建新命令：

```markdown
# /custom - 自定义命令
...
```

### 集成 CI/CD

```yaml
# .github/workflows/check.yml
name: LangChain Check
on: [push]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run check
        run: |
          python -m pytest tests/
          mypy .
```

## 贡献指南

欢迎贡献！请遵循以下步骤：

1. Fork 项目
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 许可证

MIT License

## 相关资源

- [LangChain 官方文档](https://python.langchain.com/)
- [LangChain GitHub](https://github.com/langchain-ai/langchain)
- [Claude Code 文档](https://docs.anthropic.com/claude-code)
- [Anthropic Claude API](https://docs.anthropic.com/)

## 支持

如有问题或建议：
1. 查阅 `.claude/CLAUDE.md`
2. 查看 `.claude/skills/` 中的技能文档
3. 使用 `/check` 命令检查配置
4. 提交 Issue

---

**让 Claude Code 成为你的 LangChain 开发专家！** 🦜🤖
